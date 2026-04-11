import { RowDataPacket, ResultSetHeader } from 'mysql2/promise';
import { db } from '../../config';
import { config } from '../../config/env';

// ─── Helpers de conversión de fechas ─────────────────────────────────────────

/** Convierte ISO 8601 ('2026-03-23T12:58:58.000Z') a 'YYYY-MM-DD HH:MM:SS' para MySQL TIMESTAMP/DATETIME */
function toMysqlDatetime(val: unknown): string | null {
  if (!val) return null;
  return String(val).replace('T', ' ').replace('Z', '').substring(0, 19);
}

/** Convierte ISO 8601 a 'YYYY-MM-DD' para MySQL DATE */
function toMysqlDate(val: unknown): string {
  if (!val) return new Date().toISOString().substring(0, 10);
  return String(val).substring(0, 10);
}

// ─── Estado interno del servicio ─────────────────────────────────────────────

interface SyncStatus {
  isOnline: boolean;
  isSyncing: boolean;
  lastSyncAt: Date | null;
  lastPullAt: Date | null;
  pendingSales: number;
  pendingPurchases: number;
}

const state: SyncStatus = {
  isOnline: false,
  isSyncing: false,
  lastSyncAt: null,
  lastPullAt: null,
  pendingSales: 0,
  pendingPurchases: 0,
};

// ─── Cursores por entidad ────────────────────────────────────────────────────
// Cada entidad mantiene su propio cursor (since + afterId) para que la
// paginación de ventas no interfiera con la de productos, etc.
// Se inicializan en 2020 para que el primer arranque traiga TODO el historial.

interface EntityCursor { since: string; afterId: string; }

const EPOCH = '2020-01-01T00:00:00.000Z';

const pullCursors: Record<string, EntityCursor> = {
  users:          { since: EPOCH, afterId: '' },  // debe ir ANTES que sales (FK seller_id)
  products:       { since: EPOCH, afterId: '' },
  customers:      { since: EPOCH, afterId: '' },
  sales:          { since: EPOCH, afterId: '' },
  purchases:      { since: EPOCH, afterId: '' },
  movements:      { since: EPOCH, afterId: '' },
  cashSessions:   { since: EPOCH, afterId: '' },
  creditPayments: { since: EPOCH, afterId: '' },
  categories:     { since: EPOCH, afterId: '' },
  orders:         { since: EPOCH, afterId: '' },
  recipes:        { since: EPOCH, afterId: '' },
};

// Cursores para PUSH (local → nube): cada entidad recuerda hasta dónde subió.
const pushCursors: Record<string, EntityCursor> = {
  customers:      { since: EPOCH, afterId: '' },
  products:       { since: EPOCH, afterId: '' },
  movements:      { since: EPOCH, afterId: '' },
  cashSessions:   { since: EPOCH, afterId: '' },
  creditPayments: { since: EPOCH, afterId: '' },
  orders:         { since: EPOCH, afterId: '' },
  recipes:        { since: EPOCH, afterId: '' },
  suppliers:      { since: EPOCH, afterId: '' },
};

let syncTimer: ReturnType<typeof setInterval> | null = null;

// ─── Helpers ─────────────────────────────────────────────────────────────────

/**
 * Verifica si hay conexión con el backend en la nube.
 * Hace un GET /health al CLOUD_API_URL con timeout de 5s.
 */
async function checkConnectivity(): Promise<boolean> {
  if (!config.sync.cloudApiUrl) return false;
  try {
    const controller = new AbortController();
    const timer = setTimeout(() => controller.abort(), 5000);
    const res = await fetch(`${config.sync.cloudApiUrl}/health`, {
      signal: controller.signal,
    });
    clearTimeout(timer);
    return res.ok;
  } catch {
    return false;
  }
}

async function countPending(): Promise<{ sales: number; purchases: number }> {
  const [rows] = await db.execute<RowDataPacket[]>(
    `SELECT
       (SELECT COUNT(*) FROM sales            WHERE synced = 0) AS pending_sales,
       (SELECT COUNT(*) FROM purchase_invoices WHERE synced = 0) AS pending_purchases`
  );
  return {
    sales: Number((rows[0] as any).pending_sales),
    purchases: Number((rows[0] as any).pending_purchases),
  };
}

/**
 * Hace un POST al backend de la nube con el header de autenticación de sync.
 */
async function postToCloud(path: string, body: unknown): Promise<boolean> {
  try {
    const controller = new AbortController();
    const timer = setTimeout(() => controller.abort(), 15000);
    const res = await fetch(`${config.sync.cloudApiUrl}${path}`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'x-sync-secret': config.sync.secret,
      },
      body: JSON.stringify(body),
      signal: controller.signal,
    });
    clearTimeout(timer);
    return res.ok;
  } catch {
    return false;
  }
}

// ─── Push ventas locales → nube ───────────────────────────────────────────────

async function pushSales(): Promise<number> {
  const [salesRows] = await db.execute<RowDataPacket[]>(
    `SELECT * FROM sales WHERE synced = 0 ORDER BY created_at ASC LIMIT 50`
  );
  if (salesRows.length === 0) return 0;

  // Cargar items de cada venta
  const salesWithItems = await Promise.all(
    salesRows.map(async (sale: any) => {
      const [items] = await db.execute<RowDataPacket[]>(
        `SELECT * FROM sale_items WHERE sale_id = ?`,
        [sale.id]
      );
      return { ...sale, items };
    })
  );

  const ok = await postToCloud('/api/sync/receive-sales', { sales: salesWithItems });
  if (!ok) return 0;

  // Marcar como sincronizadas
  const ids = salesRows.map((s: any) => s.id);
  const placeholders = ids.map(() => '?').join(',');
  await db.execute(
    `UPDATE sales SET synced = 1, synced_at = NOW() WHERE id IN (${placeholders})`,
    ids
  );

  console.log(`[Sync] ${ids.length} ventas sincronizadas con la nube`);
  return ids.length;
}

// ─── Push compras locales → nube ─────────────────────────────────────────────

async function pushPurchases(): Promise<number> {
  const [purchaseRows] = await db.execute<RowDataPacket[]>(
    `SELECT * FROM purchase_invoices WHERE synced = 0 ORDER BY created_at ASC LIMIT 50`
  );
  if (purchaseRows.length === 0) return 0;

  const purchasesWithItems = await Promise.all(
    purchaseRows.map(async (inv: any) => {
      const [items] = await db.execute<RowDataPacket[]>(
        `SELECT * FROM purchase_invoice_items WHERE invoice_id = ?`,
        [inv.id]
      );
      return { ...inv, items };
    })
  );

  const ok = await postToCloud('/api/sync/receive-purchases', { purchases: purchasesWithItems });
  if (!ok) return 0;

  const ids = purchaseRows.map((p: any) => p.id);
  const placeholders = ids.map(() => '?').join(',');
  await db.execute(
    `UPDATE purchase_invoices SET synced = 1, synced_at = NOW() WHERE id IN (${placeholders})`,
    ids
  );

  console.log(`[Sync] ${ids.length} compras sincronizadas con la nube`);
  return ids.length;
}

// ─── Helpers de push con cursor ──────────────────────────────────────────────

/** Avanza el cursor de push de una entidad tras enviar una página. */
function advancePushCursor(entity: string, rows: any[], limit: number, dateField = 'updated_at'): void {
  if (rows.length > 0) {
    const last = rows[rows.length - 1];
    pushCursors[entity].since   = new Date(last[dateField]).toISOString();
    pushCursors[entity].afterId = rows.length >= limit ? (last.id ?? '') : '';
  }
}

// ─── Push clientes locales → nube ────────────────────────────────────────────

async function pushCustomers(): Promise<number> {
  const LIMIT = 100;
  const cur = pushCursors.customers;
  const [rows] = await db.execute<RowDataPacket[]>(
    cur.afterId
      ? `SELECT id, tenant_id, cedula, name, phone, email, address, credit_limit, notes, updated_at
         FROM customers WHERE updated_at > ? AND id > ?
         ORDER BY updated_at ASC, id ASC LIMIT ${LIMIT}`
      : `SELECT id, tenant_id, cedula, name, phone, email, address, credit_limit, notes, updated_at
         FROM customers WHERE updated_at > ?
         ORDER BY updated_at ASC, id ASC LIMIT ${LIMIT}`,
    cur.afterId ? [cur.since, cur.afterId] : [cur.since]
  );
  if (rows.length === 0) return 0;
  const ok = await postToCloud('/api/sync/receive-customers', { customers: rows });
  if (!ok) return 0;
  advancePushCursor('customers', rows, LIMIT);
  return rows.length;
}

// ─── Push productos locales → nube ───────────────────────────────────────────

async function pushProducts(): Promise<number> {
  const LIMIT = 100;
  const cur = pushCursors.products;
  const [rows] = await db.execute<RowDataPacket[]>(
    cur.afterId
      ? `SELECT id, tenant_id, name, articulo, category, product_type, brand, model,
                description, purchase_price, sale_price, sku, barcode, stock,
                reorder_point, supplier, supplier_id, entry_date, image_url, notes,
                location_in_store, updated_at
         FROM products WHERE updated_at > ? AND id > ?
         ORDER BY updated_at ASC, id ASC LIMIT ${LIMIT}`
      : `SELECT id, tenant_id, name, articulo, category, product_type, brand, model,
                description, purchase_price, sale_price, sku, barcode, stock,
                reorder_point, supplier, supplier_id, entry_date, image_url, notes,
                location_in_store, updated_at
         FROM products WHERE updated_at > ?
         ORDER BY updated_at ASC, id ASC LIMIT ${LIMIT}`,
    cur.afterId ? [cur.since, cur.afterId] : [cur.since]
  );
  if (rows.length === 0) return 0;
  const ok = await postToCloud('/api/sync/receive-products', { products: rows });
  if (!ok) return 0;
  advancePushCursor('products', rows, LIMIT);
  return rows.length;
}

// ─── Push movimientos de stock locales → nube ────────────────────────────────

async function pushMovements(): Promise<number> {
  const LIMIT = 200;
  const cur = pushCursors.movements;
  const [rows] = await db.execute<RowDataPacket[]>(
    cur.afterId
      ? `SELECT id, tenant_id, product_id, type, quantity, previous_stock, new_stock,
                reason, reference_id, user_id, created_at
         FROM stock_movements WHERE created_at > ? AND id > ?
         ORDER BY created_at ASC, id ASC LIMIT ${LIMIT}`
      : `SELECT id, tenant_id, product_id, type, quantity, previous_stock, new_stock,
                reason, reference_id, user_id, created_at
         FROM stock_movements WHERE created_at > ?
         ORDER BY created_at ASC, id ASC LIMIT ${LIMIT}`,
    cur.afterId ? [cur.since, cur.afterId] : [cur.since]
  );
  if (rows.length === 0) return 0;
  const ok = await postToCloud('/api/sync/receive-movements', { movements: rows });
  if (!ok) return 0;
  advancePushCursor('movements', rows, LIMIT, 'created_at');
  return rows.length;
}

// ─── Push sesiones de caja locales → nube ───────────────────────────────────

async function pushCashSessions(): Promise<number> {
  const LIMIT = 50;
  const cur = pushCursors.cashSessions;
  const [rows] = await db.execute<RowDataPacket[]>(
    cur.afterId
      ? `SELECT id, tenant_id, opened_by, opened_by_name, opening_amount, opened_at,
                closed_by, closed_by_name, closed_at, status, observations,
                total_sales_count, total_cash_sales, total_card_sales,
                total_transfer_sales, total_fiado_sales, created_at, updated_at
         FROM cash_sessions WHERE updated_at > ? AND id > ?
         ORDER BY updated_at ASC, id ASC LIMIT ${LIMIT}`
      : `SELECT id, tenant_id, opened_by, opened_by_name, opening_amount, opened_at,
                closed_by, closed_by_name, closed_at, status, observations,
                total_sales_count, total_cash_sales, total_card_sales,
                total_transfer_sales, total_fiado_sales, created_at, updated_at
         FROM cash_sessions WHERE updated_at > ?
         ORDER BY updated_at ASC, id ASC LIMIT ${LIMIT}`,
    cur.afterId ? [cur.since, cur.afterId] : [cur.since]
  );
  if (rows.length === 0) return 0;
  const ok = await postToCloud('/api/sync/receive-cash-sessions', { sessions: rows });
  if (!ok) return 0;
  advancePushCursor('cashSessions', rows, LIMIT);
  return rows.length;
}

// ─── Push pagos de crédito locales → nube ───────────────────────────────────

async function pushCreditPayments(): Promise<number> {
  const LIMIT = 100;
  const cur = pushCursors.creditPayments;
  const [rows] = await db.execute<RowDataPacket[]>(
    cur.afterId
      ? `SELECT id, tenant_id, sale_id, customer_id, amount, payment_method,
                receipt_number, notes, received_by, created_at
         FROM credit_payments WHERE created_at > ? AND id > ?
         ORDER BY created_at ASC, id ASC LIMIT ${LIMIT}`
      : `SELECT id, tenant_id, sale_id, customer_id, amount, payment_method,
                receipt_number, notes, received_by, created_at
         FROM credit_payments WHERE created_at > ?
         ORDER BY created_at ASC, id ASC LIMIT ${LIMIT}`,
    cur.afterId ? [cur.since, cur.afterId] : [cur.since]
  );
  if (rows.length === 0) return 0;
  const ok = await postToCloud('/api/sync/receive-credit-payments', { payments: rows });
  if (!ok) return 0;
  advancePushCursor('creditPayments', rows, LIMIT, 'created_at');
  return rows.length;
}

// ─── Push categorías locales → nube (tabla pequeña, envío completo) ──────────

async function pushCategories(): Promise<number> {
  const [rows] = await db.execute<RowDataPacket[]>(
    `SELECT id, tenant_id, name, description, image_url, hidden_in_store
     FROM categories ORDER BY name ASC LIMIT 500`
  );
  if (rows.length === 0) return 0;
  const ok = await postToCloud('/api/sync/receive-categories', { categories: rows });
  if (!ok) return 0;
  return rows.length;
}

// ─── Push pedidos del storefront locales → nube ──────────────────────────────

async function pushOrders(): Promise<number> {
  const LIMIT = 100;
  const cur = pushCursors.orders;
  const [rows] = await db.execute<RowDataPacket[]>(
    cur.afterId
      ? `SELECT id, tenant_id, order_number, customer_name, customer_phone, customer_email,
                customer_cedula, department, municipality, address, neighborhood,
                subtotal, shipping_cost, discount, total, status, payment_method,
                delivery_status, notes, created_at, updated_at
         FROM storefront_orders WHERE updated_at > ? AND id > ?
         ORDER BY updated_at ASC, id ASC LIMIT ${LIMIT}`
      : `SELECT id, tenant_id, order_number, customer_name, customer_phone, customer_email,
                customer_cedula, department, municipality, address, neighborhood,
                subtotal, shipping_cost, discount, total, status, payment_method,
                delivery_status, notes, created_at, updated_at
         FROM storefront_orders WHERE updated_at > ?
         ORDER BY updated_at ASC, id ASC LIMIT ${LIMIT}`,
    cur.afterId ? [cur.since, cur.afterId] : [cur.since]
  );
  if (rows.length === 0) return 0;

  const ordersWithItems = await Promise.all(
    (rows as any[]).map(async (o: any) => {
      const [items] = await db.execute<RowDataPacket[]>(
        `SELECT id, order_id, product_id, product_name, product_image,
                quantity, unit_price, original_price, discount_percent, total_price, size, color
         FROM storefront_order_items WHERE order_id = ?`,
        [o.id]
      );
      return { ...o, items };
    })
  );

  const ok = await postToCloud('/api/sync/receive-orders', { orders: ordersWithItems });
  if (!ok) return 0;
  advancePushCursor('orders', rows, LIMIT);
  return rows.length;
}

// ─── Push recetas BOM locales → nube ────────────────────────────────────────

async function pushRecipes(): Promise<number> {
  const LIMIT = 200;
  const cur = pushCursors.recipes;
  const [rows] = await db.execute<RowDataPacket[]>(
    cur.afterId
      ? `SELECT id, tenant_id, product_id, ingredient_id, quantity, include_in_cost, created_at
         FROM product_recipes WHERE created_at > ? AND id > ?
         ORDER BY created_at ASC, id ASC LIMIT ${LIMIT}`
      : `SELECT id, tenant_id, product_id, ingredient_id, quantity, include_in_cost, created_at
         FROM product_recipes WHERE created_at > ?
         ORDER BY created_at ASC, id ASC LIMIT ${LIMIT}`,
    cur.afterId ? [cur.since, cur.afterId] : [cur.since]
  );
  if (rows.length === 0) return 0;
  const ok = await postToCloud('/api/sync/receive-recipes', { recipes: rows });
  if (!ok) return 0;
  advancePushCursor('recipes', rows, LIMIT, 'created_at');
  return rows.length;
}

// ─── Push proveedores locales → nube ────────────────────────────────────────

async function pushSuppliers(): Promise<number> {
  const LIMIT = 100;
  const cur = pushCursors.suppliers;
  const [rows] = await db.execute<RowDataPacket[]>(
    cur.afterId
      ? `SELECT id, tenant_id, name, contact_name, phone, email, address, city, country,
                tax_id, payment_terms, notes, is_active, created_at, updated_at
         FROM suppliers WHERE updated_at > ? AND id > ?
         ORDER BY updated_at ASC, id ASC LIMIT ${LIMIT}`
      : `SELECT id, tenant_id, name, contact_name, phone, email, address, city, country,
                tax_id, payment_terms, notes, is_active, created_at, updated_at
         FROM suppliers WHERE updated_at > ?
         ORDER BY updated_at ASC, id ASC LIMIT ${LIMIT}`,
    cur.afterId ? [cur.since, cur.afterId] : [cur.since]
  );
  if (rows.length === 0) return 0;
  const ok = await postToCloud('/api/sync/receive-suppliers', { suppliers: rows });
  if (!ok) return 0;
  advancePushCursor('suppliers', rows, LIMIT);
  return rows.length;
}

// ─── Recibir ventas de un local (endpoint en la NUBE) ────────────────────────

export async function receiveSalesFromLocal(sales: any[]): Promise<{ inserted: number; skipped: number }> {
  let inserted = 0;
  let skipped = 0;

  const connection = await db.getConnection();
  try {
    await connection.beginTransaction();

    for (const sale of sales) {
      // INSERT IGNORE: si el ID ya existe en la nube, lo omite sin error
      const [result] = await connection.execute<ResultSetHeader>(
        `INSERT IGNORE INTO sales
           (id, tenant_id, invoice_number, customer_id, customer_name, customer_phone,
            customer_email, subtotal, tax, discount, total, payment_method, amount_paid,
            change_amount, seller_id, seller_name, cash_session_id, status, credit_status,
            due_date, notes, synced, synced_at, origin, created_at, updated_at)
         VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,1,NOW(),'local',?,?)`,
        [
          sale.id, sale.tenant_id, sale.invoice_number, sale.customer_id || null,
          sale.customer_name || null, sale.customer_phone || null, sale.customer_email || null,
          sale.subtotal, sale.tax, sale.discount, sale.total, sale.payment_method,
          sale.amount_paid, sale.change_amount, sale.seller_id || null, sale.seller_name,
          sale.cash_session_id || null, sale.status, sale.credit_status || null,
          sale.due_date || null, sale.notes || null,
          sale.created_at, sale.updated_at,
        ]
      );

      if (result.affectedRows > 0) {
        // Insertar items también
        for (const item of (sale.items || [])) {
          await connection.execute(
            `INSERT IGNORE INTO sale_items
               (id, tenant_id, sale_id, product_id, product_name, product_sku,
                quantity, unit_price, discount, subtotal, created_at)
             VALUES (?,?,?,?,?,?,?,?,?,?,?)`,
            [
              item.id, item.tenant_id || sale.tenant_id, item.sale_id,
              item.product_id, item.product_name, item.product_sku,
              item.quantity, item.unit_price, item.discount, item.subtotal,
              item.created_at,
            ]
          );
        }
        inserted++;
      } else {
        skipped++;
      }
    }

    await connection.commit();
    return { inserted, skipped };
  } catch (err) {
    await connection.rollback();
    throw err;
  } finally {
    connection.release();
  }
}

// ─── Recibir compras de un local (endpoint en la NUBE) ───────────────────────

export async function receivePurchasesFromLocal(purchases: any[]): Promise<{ inserted: number; skipped: number }> {
  let inserted = 0;
  let skipped = 0;

  const connection = await db.getConnection();
  try {
    await connection.beginTransaction();

    for (const inv of purchases) {
      const [result] = await connection.execute<ResultSetHeader>(
        `INSERT IGNORE INTO purchase_invoices
           (id, tenant_id, invoice_number, supplier_id, supplier_name, purchase_date,
            document_type, subtotal, discount, tax, total, payment_method, payment_status,
            due_date, file_url, notes, created_by, synced, synced_at, origin, created_at, updated_at)
         VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,1,NOW(),'local',?,?)`,
        [
          inv.id, inv.tenant_id, inv.invoice_number, inv.supplier_id || null,
          inv.supplier_name, inv.purchase_date, inv.document_type,
          inv.subtotal, inv.discount, inv.tax, inv.total, inv.payment_method,
          inv.payment_status, inv.due_date || null, inv.file_url || null,
          inv.notes || null, inv.created_by || null,
          inv.created_at, inv.updated_at,
        ]
      );

      if (result.affectedRows > 0) {
        for (const item of (inv.items || [])) {
          await connection.execute(
            `INSERT IGNORE INTO purchase_invoice_items
               (id, tenant_id, invoice_id, product_id, product_name, product_sku,
                quantity, unit_cost, subtotal)
             VALUES (?,?,?,?,?,?,?,?,?)`,
            [
              item.id, item.tenant_id || inv.tenant_id, item.invoice_id,
              item.product_id, item.product_name, item.product_sku,
              item.quantity, item.unit_cost, item.subtotal,
            ]
          );
        }
        inserted++;
      } else {
        skipped++;
      }
    }

    await connection.commit();
    return { inserted, skipped };
  } catch (err) {
    await connection.rollback();
    throw err;
  } finally {
    connection.release();
  }
}

// ─── Recibir clientes de un local (endpoint en la NUBE) ─────────────────────

export async function receiveCustomersFromLocal(customers: any[]): Promise<{ upserted: number }> {
  let upserted = 0;
  for (const c of customers) {
    await db.execute(
      `INSERT INTO customers (id, tenant_id, cedula, name, phone, email, address, credit_limit, notes, updated_at)
       VALUES (?,?,?,?,?,?,?,?,?,?)
       ON DUPLICATE KEY UPDATE
         name=IF(VALUES(updated_at)>updated_at,VALUES(name),name),
         phone=IF(VALUES(updated_at)>updated_at,VALUES(phone),phone),
         email=IF(VALUES(updated_at)>updated_at,VALUES(email),email),
         address=IF(VALUES(updated_at)>updated_at,VALUES(address),address),
         credit_limit=IF(VALUES(updated_at)>updated_at,VALUES(credit_limit),credit_limit),
         notes=IF(VALUES(updated_at)>updated_at,VALUES(notes),notes),
         updated_at=IF(VALUES(updated_at)>updated_at,VALUES(updated_at),updated_at)`,
      [c.id, c.tenant_id, c.cedula||null, c.name, c.phone||null,
       c.email||null, c.address||null, c.credit_limit||0, c.notes||null,
       toMysqlDatetime(c.updated_at)]
    );
    upserted++;
  }
  return { upserted };
}

// ─── Recibir productos de un local (endpoint en la NUBE) ────────────────────

export async function receiveProductsFromLocal(products: any[]): Promise<{ upserted: number }> {
  let upserted = 0;
  for (const p of products) {
    await db.execute(
      `INSERT INTO products
         (id, tenant_id, name, articulo, category, product_type, brand, model,
          description, purchase_price, sale_price, sku, barcode, stock,
          reorder_point, supplier, supplier_id, entry_date, image_url, notes,
          location_in_store, updated_at)
       VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)
       ON DUPLICATE KEY UPDATE
         stock=IF(VALUES(updated_at)>updated_at,VALUES(stock),stock),
         sale_price=IF(VALUES(updated_at)>updated_at,VALUES(sale_price),sale_price),
         purchase_price=IF(VALUES(updated_at)>updated_at,VALUES(purchase_price),purchase_price),
         name=IF(VALUES(updated_at)>updated_at,VALUES(name),name),
         updated_at=IF(VALUES(updated_at)>updated_at,VALUES(updated_at),updated_at)`,
      [p.id, p.tenant_id, p.name, p.articulo||null, p.category,
       p.product_type||'general', p.brand||null, p.model||null,
       p.description||null, p.purchase_price, p.sale_price, p.sku,
       p.barcode||null, p.stock, p.reorder_point||5,
       p.supplier||null, p.supplier_id||null, toMysqlDate(p.entry_date),
       p.image_url||null, p.notes||null, p.location_in_store||null,
       toMysqlDatetime(p.updated_at)]
    );
    upserted++;
  }
  return { upserted };
}

// ─── Recibir movimientos de stock de un local (endpoint en la NUBE) ──────────

export async function receiveMovementsFromLocal(movements: any[]): Promise<{ inserted: number }> {
  let inserted = 0;
  for (const m of movements) {
    const [res] = await db.execute<ResultSetHeader>(
      `INSERT IGNORE INTO stock_movements
         (id, tenant_id, product_id, type, quantity, previous_stock, new_stock,
          reason, reference_id, user_id, created_at)
       VALUES (?,?,?,?,?,?,?,?,?,?,?)`,
      [m.id, m.tenant_id, m.product_id, m.type, m.quantity,
       m.previous_stock, m.new_stock, m.reason||null,
       m.reference_id||null, m.user_id||null, m.created_at]
    );
    if (res.affectedRows > 0) inserted++;
  }
  return { inserted };
}

// ─── Recibir sesiones de caja de un local (endpoint en la NUBE) ─────────────

export async function receiveCashSessionsFromLocal(sessions: any[]): Promise<{ upserted: number }> {
  let upserted = 0;
  for (const cs of sessions) {
    await db.execute(
      `INSERT INTO cash_sessions
         (id, tenant_id, opened_by, opened_by_name, opening_amount, opened_at,
          closed_by, closed_by_name, closed_at, status, observations,
          total_sales_count, total_cash_sales, total_card_sales,
          total_transfer_sales, total_fiado_sales, created_at, updated_at)
       VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)
       ON DUPLICATE KEY UPDATE
         status=IF(VALUES(updated_at)>updated_at,VALUES(status),status),
         closed_by=IF(VALUES(updated_at)>updated_at,VALUES(closed_by),closed_by),
         closed_by_name=IF(VALUES(updated_at)>updated_at,VALUES(closed_by_name),closed_by_name),
         closed_at=IF(VALUES(updated_at)>updated_at,VALUES(closed_at),closed_at),
         total_sales_count=IF(VALUES(updated_at)>updated_at,VALUES(total_sales_count),total_sales_count),
         total_cash_sales=IF(VALUES(updated_at)>updated_at,VALUES(total_cash_sales),total_cash_sales),
         total_card_sales=IF(VALUES(updated_at)>updated_at,VALUES(total_card_sales),total_card_sales),
         total_transfer_sales=IF(VALUES(updated_at)>updated_at,VALUES(total_transfer_sales),total_transfer_sales),
         total_fiado_sales=IF(VALUES(updated_at)>updated_at,VALUES(total_fiado_sales),total_fiado_sales),
         updated_at=IF(VALUES(updated_at)>updated_at,VALUES(updated_at),updated_at)`,
      [cs.id, cs.tenant_id, cs.opened_by, cs.opened_by_name,
       cs.opening_amount||0, cs.opened_at, cs.closed_by||null,
       cs.closed_by_name||null, cs.closed_at||null, cs.status||'cerrada',
       cs.observations||null, cs.total_sales_count||0,
       cs.total_cash_sales||0, cs.total_card_sales||0,
       cs.total_transfer_sales||0, cs.total_fiado_sales||0,
       cs.created_at, cs.updated_at]
    );
    upserted++;
  }
  return { upserted };
}

// ─── Recibir pagos de crédito de un local (endpoint en la NUBE) ─────────────

export async function receiveCreditPaymentsFromLocal(payments: any[]): Promise<{ inserted: number }> {
  let inserted = 0;
  for (const cp of payments) {
    const [res] = await db.execute<ResultSetHeader>(
      `INSERT IGNORE INTO credit_payments
         (id, tenant_id, sale_id, customer_id, amount, payment_method,
          receipt_number, notes, received_by, created_at)
       VALUES (?,?,?,?,?,?,?,?,?,?)`,
      [cp.id, cp.tenant_id, cp.sale_id, cp.customer_id, cp.amount,
       cp.payment_method, cp.receipt_number||null, cp.notes||null,
       cp.received_by||null, cp.created_at]
    );
    if (res.affectedRows > 0) inserted++;
  }
  return { inserted };
}

// ─── Recibir categorías de un local (endpoint en la NUBE) ───────────────────

export async function receiveCategoriesFromLocal(categories: any[]): Promise<{ upserted: number }> {
  let upserted = 0;
  for (const cat of categories) {
    await db.execute(
      `INSERT INTO categories (id, tenant_id, name, description, image_url, hidden_in_store)
       VALUES (?,?,?,?,?,?)
       ON DUPLICATE KEY UPDATE
         name=VALUES(name), description=VALUES(description),
         image_url=VALUES(image_url), hidden_in_store=VALUES(hidden_in_store)`,
      [cat.id, cat.tenant_id, cat.name, cat.description||null,
       cat.image_url||null, cat.hidden_in_store||0]
    );
    upserted++;
  }
  return { upserted };
}

// ─── Recibir pedidos del storefront de un local (endpoint en la NUBE) ────────

export async function receiveOrdersFromLocal(orders: any[]): Promise<{ upserted: number }> {
  let upserted = 0;
  const connection = await db.getConnection();
  try {
    await connection.beginTransaction();
    for (const o of orders) {
      await connection.execute(
        `INSERT INTO storefront_orders
           (id, tenant_id, order_number, customer_name, customer_phone, customer_email,
            customer_cedula, department, municipality, address, neighborhood,
            subtotal, shipping_cost, discount, total, status, payment_method,
            delivery_status, notes, created_at, updated_at)
         VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)
         ON DUPLICATE KEY UPDATE
           status=IF(VALUES(updated_at)>updated_at,VALUES(status),status),
           delivery_status=IF(VALUES(updated_at)>updated_at,VALUES(delivery_status),delivery_status),
           updated_at=IF(VALUES(updated_at)>updated_at,VALUES(updated_at),updated_at)`,
        [o.id, o.tenant_id, o.order_number, o.customer_name, o.customer_phone,
         o.customer_email||null, o.customer_cedula||null, o.department||null,
         o.municipality||null, o.address||null, o.neighborhood||null,
         o.subtotal, o.shipping_cost||0, o.discount||0, o.total,
         o.status, o.payment_method||null, o.delivery_status||'sin_asignar',
         o.notes||null, o.created_at, o.updated_at]
      );
      for (const oi of (o.items || [])) {
        await connection.execute(
          `INSERT IGNORE INTO storefront_order_items
             (order_id, product_id, product_name, product_image,
              quantity, unit_price, original_price, discount_percent, total_price, size, color)
           VALUES (?,?,?,?,?,?,?,?,?,?,?)`,
          [oi.order_id, oi.product_id||null, oi.product_name, oi.product_image||null,
           oi.quantity, oi.unit_price, oi.original_price||null,
           oi.discount_percent||0, oi.total_price, oi.size||null, oi.color||null]
        );
      }
      upserted++;
    }
    await connection.commit();
    return { upserted };
  } catch (err) {
    await connection.rollback();
    throw err;
  } finally {
    connection.release();
  }
}

// ─── Recibir recetas BOM de un local (endpoint en la NUBE) ──────────────────

export async function receiveRecipesFromLocal(recipes: any[]): Promise<{ inserted: number }> {
  let inserted = 0;
  for (const pr of recipes) {
    const [res] = await db.execute<ResultSetHeader>(
      `INSERT IGNORE INTO product_recipes
         (id, tenant_id, product_id, ingredient_id, quantity, include_in_cost)
       VALUES (?,?,?,?,?,?)`,
      [pr.id, pr.tenant_id, pr.product_id, pr.ingredient_id,
       pr.quantity, pr.include_in_cost ?? 1]
    );
    if (res.affectedRows > 0) inserted++;
  }
  return { inserted };
}

// ─── Recibir proveedores de un local (endpoint en la NUBE) ──────────────────

export async function receiveSuppliersFromLocal(suppliers: any[]): Promise<{ upserted: number }> {
  let upserted = 0;
  for (const s of suppliers) {
    await db.execute(
      `INSERT INTO suppliers
         (id, tenant_id, name, contact_name, phone, email, address, city, country,
          tax_id, payment_terms, notes, is_active, created_at, updated_at)
       VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)
       ON DUPLICATE KEY UPDATE
         name=IF(VALUES(updated_at)>updated_at,VALUES(name),name),
         contact_name=IF(VALUES(updated_at)>updated_at,VALUES(contact_name),contact_name),
         phone=IF(VALUES(updated_at)>updated_at,VALUES(phone),phone),
         email=IF(VALUES(updated_at)>updated_at,VALUES(email),email),
         address=IF(VALUES(updated_at)>updated_at,VALUES(address),address),
         is_active=IF(VALUES(updated_at)>updated_at,VALUES(is_active),is_active),
         updated_at=IF(VALUES(updated_at)>updated_at,VALUES(updated_at),updated_at)`,
      [s.id, s.tenant_id, s.name, s.contact_name||null, s.phone||null,
       s.email||null, s.address||null, s.city||null, s.country||'Colombia',
       s.tax_id||null, s.payment_terms||null, s.notes||null,
       s.is_active ?? 1, s.created_at, toMysqlDatetime(s.updated_at)]
    );
    upserted++;
  }
  return { upserted };
}

// ─── Pull: nube → local (productos y clientes actualizados) ──────────────────

/** Avanza el cursor de una entidad tras recibir una página. */
function advanceCursor(
  entity: string,
  rows: any[],
  limit: number,
  dateField = 'updated_at'
): void {
  if (rows.length >= limit) {
    const last = rows[rows.length - 1];
    pullCursors[entity].since   = new Date(last[dateField]).toISOString();
    pullCursors[entity].afterId = last.id ?? '';
  } else {
    pullCursors[entity].since   = new Date().toISOString();
    pullCursors[entity].afterId = '';
  }
}

/** true si alguna entidad sigue paginando (recibió página completa). */
function stillPaginating(): boolean {
  return Object.keys(pullCursors).some((e) => pullCursors[e].since !== new Date().toISOString() && pullCursors[e].since > EPOCH && pullCursors[e].afterId !== '' );
}

/**
 * Descarga de la nube TODOS los módulos y los aplica localmente.
 * Cada entidad tiene su propio cursor para paginar independientemente.
 */
async function pullFromCloud(): Promise<number> {
  if (!config.sync.cloudApiUrl || !config.sync.tenantId) return 0;

  try {
    const controller = new AbortController();
    const timer = setTimeout(() => controller.abort(), 30000);

    // Enviamos el estado de cada cursor al servidor
    const params = new URLSearchParams({
      tenantId: config.sync.tenantId,
      cursors: JSON.stringify(pullCursors),
    });

    const res = await fetch(
      `${config.sync.cloudApiUrl}/api/sync/changes?${params.toString()}`,
      {
        headers: { 'x-sync-secret': config.sync.secret },
        signal: controller.signal,
      }
    );
    clearTimeout(timer);

    if (!res.ok) return 0;
    const data = await res.json() as {
      tenant?: any;
      users?: any[];
      products?: any[];       customers?: any[];
      sales?: any[];          saleItems?: any[];
      purchases?: any[];      purchaseItems?: any[];
      movements?: any[];
      cashSessions?: any[];
      creditPayments?: any[];
      categories?: any[];
      storeInfo?: any;
      productRecipes?: any[];
      orders?: any[];         orderItems?: any[];
    };

    let applied = 0;

    // ── Tenant ──────────────────────────────────────────────────────────────
    if (data.tenant) {
      const t = data.tenant;
      await db.execute(
        `INSERT INTO tenants (id, name, slug, business_type, status, plan, max_users, max_products, bg_color)
         VALUES (?,?,?,?,?,?,?,?,?)
         ON DUPLICATE KEY UPDATE
           name=VALUES(name), slug=VALUES(slug), status=VALUES(status), plan=VALUES(plan), bg_color=VALUES(bg_color)`,
        [t.id, t.name, t.slug, t.business_type||null, t.status||'activo',
         t.plan||'basico', t.max_users||5, t.max_products||500, t.bg_color||'#000000']
      );
    }

    // ── Usuarios (necesario antes de ventas por FK seller_id) ───────────────
    for (const u of (data.users || [])) {
      await db.execute(
        `INSERT INTO users
           (id, tenant_id, name, email, password, role, is_active, updated_at)
         VALUES (?,?,?,?,?,?,?,?)
         ON DUPLICATE KEY UPDATE
           name=IF(VALUES(updated_at)>updated_at,VALUES(name),name),
           role=IF(VALUES(updated_at)>updated_at,VALUES(role),role),
           is_active=IF(VALUES(updated_at)>updated_at,VALUES(is_active),is_active),
           password=IF(VALUES(updated_at)>updated_at,VALUES(password),password),
           updated_at=IF(VALUES(updated_at)>updated_at,VALUES(updated_at),updated_at)`,
        [u.id, u.tenant_id, u.name, u.email, u.password, u.role,
         u.is_active ?? 1, toMysqlDatetime(u.updated_at)]
      );
      applied++;
    }
    advanceCursor('users', data.users||[], 200);

    // ── Categorías ──────────────────────────────────────────────────────────
    for (const cat of (data.categories || [])) {
      await db.execute(
        `INSERT INTO categories (id, tenant_id, name, description, image_url, hidden_in_store)
         VALUES (?,?,?,?,?,?)
         ON DUPLICATE KEY UPDATE name=VALUES(name), description=VALUES(description),
           image_url=VALUES(image_url), hidden_in_store=VALUES(hidden_in_store)`,
        [cat.id, cat.tenant_id, cat.name, cat.description||null,
         cat.image_url||null, cat.hidden_in_store||0]
      );
    }
    if ((data.categories||[]).length) {
      advanceCursor('categories', data.categories!, 200);
    } else if (pullCursors.categories.since === EPOCH) {
      // No llegaron categorías pero el cursor sigue en EPOCH: avanzar para no pedir de nuevo
      pullCursors.categories.since = new Date().toISOString();
      pullCursors.categories.afterId = '';
    }

    // ── Store info ──────────────────────────────────────────────────────────
    if (data.storeInfo) {
      const s = data.storeInfo;
      await db.execute(
        `INSERT INTO store_info (tenant_id, name, address, phone, tax_id, email, logo_url,
           schedule, social_instagram, social_facebook, social_tiktok, social_whatsapp,
           invoice_greeting, invoice_copies)
         VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?)
         ON DUPLICATE KEY UPDATE
           name=VALUES(name), address=VALUES(address), phone=VALUES(phone),
           logo_url=VALUES(logo_url), email=VALUES(email), schedule=VALUES(schedule),
           social_instagram=VALUES(social_instagram), social_facebook=VALUES(social_facebook),
           social_tiktok=VALUES(social_tiktok), social_whatsapp=VALUES(social_whatsapp),
           invoice_greeting=VALUES(invoice_greeting), invoice_copies=VALUES(invoice_copies)`,
        [s.tenant_id, s.name, s.address||null, s.phone||null, s.tax_id||null,
         s.email||null, s.logo_url||null, s.schedule||null,
         s.social_instagram||null, s.social_facebook||null,
         s.social_tiktok||null, s.social_whatsapp||null,
         s.invoice_greeting||'¡Gracias por su compra!', s.invoice_copies||1]
      );
    }

    // ── Productos ───────────────────────────────────────────────────────────
    for (const p of (data.products || [])) {
      await db.execute(
        `INSERT INTO products
           (id, tenant_id, name, articulo, category, product_type, brand, model,
            description, purchase_price, sale_price, sku, barcode, stock,
            reorder_point, supplier, supplier_id, entry_date, image_url, notes,
            location_in_store, updated_at)
         VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)
         ON DUPLICATE KEY UPDATE
           stock=IF(VALUES(updated_at)>updated_at,VALUES(stock),stock),
           sale_price=IF(VALUES(updated_at)>updated_at,VALUES(sale_price),sale_price),
           purchase_price=IF(VALUES(updated_at)>updated_at,VALUES(purchase_price),purchase_price),
           name=IF(VALUES(updated_at)>updated_at,VALUES(name),name),
           updated_at=IF(VALUES(updated_at)>updated_at,VALUES(updated_at),updated_at)`,
        [p.id, p.tenant_id, p.name, p.articulo||null, p.category,
         p.product_type||'general', p.brand||null, p.model||null,
         p.description||null, p.purchase_price, p.sale_price, p.sku,
         p.barcode||null, p.stock, p.reorder_point||5,
         p.supplier||null, p.supplier_id||null, toMysqlDate(p.entry_date),
         p.image_url||null, p.notes||null, p.location_in_store||null,
         toMysqlDatetime(p.updated_at)]
      );
      applied++;
    }
    advanceCursor('products', data.products||[], 500);

    // ── Clientes ────────────────────────────────────────────────────────────
    for (const c of (data.customers || [])) {
      await db.execute(
        `INSERT INTO customers
           (id, tenant_id, cedula, name, phone, email, address, credit_limit, notes, updated_at)
         VALUES (?,?,?,?,?,?,?,?,?,?)
         ON DUPLICATE KEY UPDATE
           name=IF(VALUES(updated_at)>updated_at,VALUES(name),name),
           phone=IF(VALUES(updated_at)>updated_at,VALUES(phone),phone),
           credit_limit=IF(VALUES(updated_at)>updated_at,VALUES(credit_limit),credit_limit),
           updated_at=IF(VALUES(updated_at)>updated_at,VALUES(updated_at),updated_at)`,
        [c.id, c.tenant_id, c.cedula, c.name, c.phone||null,
         c.email||null, c.address||null, c.credit_limit||0,
         c.notes||null, toMysqlDatetime(c.updated_at)]
      );
      applied++;
    }
    advanceCursor('customers', data.customers||[], 500);

    // ── Ventas ──────────────────────────────────────────────────────────────
    for (const s of (data.sales || [])) {
      await db.execute(
        `INSERT IGNORE INTO sales
           (id, tenant_id, invoice_number, customer_id, customer_name, customer_phone,
            customer_email, subtotal, tax, discount, total, payment_method, amount_paid,
            change_amount, seller_id, seller_name, cash_session_id, status, credit_status,
            due_date, notes, synced, synced_at, origin, created_at, updated_at)
         VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,1,NOW(),'cloud',?,?)`,
        [s.id, s.tenant_id, s.invoice_number, s.customer_id||null,
         s.customer_name||null, s.customer_phone||null, s.customer_email||null,
         s.subtotal, s.tax, s.discount, s.total, s.payment_method,
         s.amount_paid, s.change_amount, s.seller_id||null, s.seller_name,
         s.cash_session_id||null, s.status, s.credit_status||null,
         s.due_date||null, s.notes||null, s.created_at, s.updated_at]
      );
      applied++;
    }
    for (const si of (data.saleItems || [])) {
      await db.execute(
        `INSERT IGNORE INTO sale_items
           (id, tenant_id, sale_id, product_id, product_name, product_sku,
            quantity, unit_price, discount, subtotal, created_at)
         VALUES (?,?,?,?,?,?,?,?,?,?,?)`,
        [si.id, si.tenant_id, si.sale_id, si.product_id, si.product_name,
         si.product_sku, si.quantity, si.unit_price, si.discount, si.subtotal, si.created_at]
      );
    }
    advanceCursor('sales', data.sales||[], 200);

    // ── Compras ─────────────────────────────────────────────────────────────
    for (const inv of (data.purchases || [])) {
      await db.execute(
        `INSERT IGNORE INTO purchase_invoices
           (id, tenant_id, invoice_number, supplier_id, supplier_name, purchase_date,
            document_type, subtotal, discount, tax, total, payment_method, payment_status,
            due_date, file_url, notes, created_by, synced, synced_at, origin, created_at, updated_at)
         VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,1,NOW(),'cloud',?,?)`,
        [inv.id, inv.tenant_id, inv.invoice_number, inv.supplier_id||null,
         inv.supplier_name, inv.purchase_date, inv.document_type,
         inv.subtotal, inv.discount, inv.tax, inv.total, inv.payment_method,
         inv.payment_status, inv.due_date||null, inv.file_url||null,
         inv.notes||null, inv.created_by||null, inv.created_at, inv.updated_at]
      );
      applied++;
    }
    for (const pi of (data.purchaseItems || [])) {
      await db.execute(
        `INSERT IGNORE INTO purchase_invoice_items
           (id, tenant_id, invoice_id, product_id, product_name, product_sku,
            quantity, unit_cost, subtotal)
         VALUES (?,?,?,?,?,?,?,?,?)`,
        [pi.id, pi.tenant_id, pi.invoice_id, pi.product_id, pi.product_name,
         pi.product_sku, pi.quantity, pi.unit_cost, pi.subtotal]
      );
    }
    advanceCursor('purchases', data.purchases||[], 100);

    // ── Movimientos de stock ────────────────────────────────────────────────
    for (const m of (data.movements || [])) {
      await db.execute(
        `INSERT IGNORE INTO stock_movements
           (id, tenant_id, product_id, type, quantity, previous_stock, new_stock,
            reason, reference_id, user_id, created_at)
         VALUES (?,?,?,?,?,?,?,?,?,?,?)`,
        [m.id, m.tenant_id, m.product_id, m.type, m.quantity,
         m.previous_stock, m.new_stock, m.reason||null,
         m.reference_id||null, m.user_id||null, m.created_at]
      );
      applied++;
    }
    advanceCursor('movements', data.movements||[], 500, 'created_at');

    // ── Sesiones de caja ────────────────────────────────────────────────────
    for (const cs of (data.cashSessions || [])) {
      await db.execute(
        `INSERT IGNORE INTO cash_sessions
           (id, tenant_id, opened_by, opened_by_name, opening_amount, opened_at,
            closed_by, closed_by_name, closed_at, status, observations,
            total_sales_count, total_cash_sales, total_card_sales,
            total_transfer_sales, total_fiado_sales, created_at, updated_at)
         VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)`,
        [cs.id, cs.tenant_id, cs.opened_by, cs.opened_by_name,
         cs.opening_amount||0, cs.opened_at, cs.closed_by||null,
         cs.closed_by_name||null, cs.closed_at||null, cs.status||'cerrada',
         cs.observations||null, cs.total_sales_count||0,
         cs.total_cash_sales||0, cs.total_card_sales||0,
         cs.total_transfer_sales||0, cs.total_fiado_sales||0,
         cs.created_at, cs.updated_at]
      );
      applied++;
    }
    advanceCursor('cashSessions', data.cashSessions||[], 100);

    // ── Pagos de crédito ────────────────────────────────────────────────────
    for (const cp of (data.creditPayments || [])) {
      await db.execute(
        `INSERT IGNORE INTO credit_payments
           (id, tenant_id, sale_id, customer_id, amount, payment_method,
            receipt_number, notes, received_by, created_at)
         VALUES (?,?,?,?,?,?,?,?,?,?)`,
        [cp.id, cp.tenant_id, cp.sale_id, cp.customer_id, cp.amount,
         cp.payment_method, cp.receipt_number||null, cp.notes||null,
         cp.received_by||null, cp.created_at]
      );
      applied++;
    }
    advanceCursor('creditPayments', data.creditPayments||[], 200, 'created_at');

    // ── Recetas BOM (product_recipes) ──────────────────────────────────────
    for (const pr of (data.productRecipes || [])) {
      await db.execute(
        `INSERT IGNORE INTO product_recipes
           (id, tenant_id, product_id, ingredient_id, quantity, include_in_cost)
         VALUES (?,?,?,?,?,?)`,
        [pr.id, pr.tenant_id, pr.product_id, pr.ingredient_id,
         pr.quantity, pr.include_in_cost ?? 1]
      );
      applied++;
    }
    advanceCursor('recipes', data.productRecipes||[], 500, 'created_at');

    // ── Pedidos del storefront ──────────────────────────────────────────────
    for (const o of (data.orders || [])) {
      await db.execute(
        `INSERT INTO storefront_orders
           (id, tenant_id, order_number, customer_name, customer_phone, customer_email,
            customer_cedula, department, municipality, address, neighborhood,
            subtotal, shipping_cost, discount, total, status, payment_method,
            delivery_status, notes, created_at, updated_at)
         VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)
         ON DUPLICATE KEY UPDATE
           status=IF(VALUES(updated_at)>updated_at,VALUES(status),status),
           delivery_status=IF(VALUES(updated_at)>updated_at,VALUES(delivery_status),delivery_status),
           updated_at=IF(VALUES(updated_at)>updated_at,VALUES(updated_at),updated_at)`,
        [o.id, o.tenant_id, o.order_number, o.customer_name, o.customer_phone,
         o.customer_email||null, o.customer_cedula||null, o.department||null,
         o.municipality||null, o.address||null, o.neighborhood||null,
         o.subtotal, o.shipping_cost||0, o.discount||0, o.total,
         o.status, o.payment_method||null, o.delivery_status||'sin_asignar',
         o.notes||null, o.created_at, o.updated_at]
      );
      applied++;
    }
    for (const oi of (data.orderItems || [])) {
      await db.execute(
        `INSERT IGNORE INTO storefront_order_items
           (order_id, product_id, product_name, product_image,
            quantity, unit_price, original_price, discount_percent, total_price, size, color)
         VALUES (?,?,?,?,?,?,?,?,?,?,?)`,
        [oi.order_id, oi.product_id||null, oi.product_name, oi.product_image||null,
         oi.quantity, oi.unit_price, oi.original_price||null,
         oi.discount_percent||0, oi.total_price, oi.size||null, oi.color||null]
      );
    }
    advanceCursor('orders', data.orders||[], 200);

    // ── Log de progreso ─────────────────────────────────────────────────────
    const anyPageFull = Object.entries(pullCursors).some(([, c]) => c.afterId !== '');
    if (anyPageFull) {
      console.log(`[Sync] PULL: ${applied} registros aplicados (paginando, continúa en próximo ciclo)`);
    } else {
      state.lastPullAt = new Date();
      console.log(`[Sync] PULL: ${applied} registros aplicados desde la nube`);
    }

    return applied;
  } catch (err) {
    console.error('[Sync] Error en pull:', err);
    return 0;
  }
}

// ─── getChangesSince: endpoint de la NUBE para servir cambios a los locales ──

/**
 * Retorna productos y clientes del tenant modificados desde `since`.
 * Se usa en el endpoint GET /api/sync/changes (solo corre en la nube).
 */
/** Helper: query con cursor compuesto (updated_at, id) */
async function queryWithCursor(
  sql: string,
  sqlWithAfterId: string,
  params: any[],
  paramsWithAfterId: any[]
): Promise<RowDataPacket[]> {
  const [rows] = paramsWithAfterId[paramsWithAfterId.length - 1]
    ? await db.execute<RowDataPacket[]>(sqlWithAfterId, paramsWithAfterId)
    : await db.execute<RowDataPacket[]>(sql, params);
  return rows;
}

/**
 * Endpoint de la NUBE: retorna todos los módulos del tenant para el local.
 * Recibe un mapa de cursores por entidad enviado por el cliente local.
 */
export async function getChangesSince(
  tenantId: string,
  cursors: Record<string, { since: string; afterId: string }>
): Promise<Record<string, any>> {

  const c = (entity: string) => cursors[entity] ?? { since: EPOCH, afterId: '' };

  // ── Tenant ────────────────────────────────────────────────────────────────
  const [tenantRows] = await db.execute<RowDataPacket[]>(
    `SELECT id, name, slug, business_type, status, plan, max_users, max_products, bg_color
     FROM tenants WHERE id = ? LIMIT 1`,
    [tenantId]
  );

  // ── Usuarios (necesario antes de ventas por FK seller_id) ────────────────
  const cu = c('users');
  const [users] = await db.execute<RowDataPacket[]>(
    cu.afterId
      ? `SELECT id, tenant_id, name, email, password, role, is_active, updated_at
         FROM users WHERE tenant_id = ? AND updated_at > ? AND id > ?
         ORDER BY updated_at ASC, id ASC LIMIT 200`
      : `SELECT id, tenant_id, name, email, password, role, is_active, updated_at
         FROM users WHERE tenant_id = ? AND updated_at > ?
         ORDER BY updated_at ASC, id ASC LIMIT 200`,
    cu.afterId ? [tenantId, cu.since, cu.afterId] : [tenantId, cu.since]
  );

  // ── Categorías (solo en el primer sync — el cursor aún está en EPOCH) ───────
  // Las categorías no tienen updated_at; se envían una sola vez y el local las conserva.
  const catCursor = c('categories');
  const categories = catCursor.since === EPOCH
    ? await (async () => {
        const [rows] = await db.execute<RowDataPacket[]>(
          `SELECT id, tenant_id, name, description, image_url, hidden_in_store
           FROM categories WHERE tenant_id = ?
           ORDER BY name ASC LIMIT 200`,
          [tenantId]
        );
        return rows;
      })()
    : [];

  // ── Store info (solo en el primer sync igual) ────────────────────────────
  const [storeRows] = await db.execute<RowDataPacket[]>(
    `SELECT tenant_id, name, address, phone, tax_id, email, logo_url, schedule,
            social_instagram, social_facebook, social_tiktok, social_whatsapp,
            invoice_greeting, invoice_copies
     FROM store_info WHERE tenant_id = ? LIMIT 1`,
    [tenantId]
  );

  // ── Productos ────────────────────────────────────────────────────────────
  const cp = c('products');
  const products = await queryWithCursor(
    `SELECT id, tenant_id, name, articulo, category, product_type, brand, model,
            description, purchase_price, sale_price, sku, barcode, stock,
            reorder_point, supplier, supplier_id, entry_date, image_url, notes,
            location_in_store, updated_at
     FROM products WHERE tenant_id = ? AND updated_at > ?
     ORDER BY updated_at ASC, id ASC LIMIT 500`,
    `SELECT id, tenant_id, name, articulo, category, product_type, brand, model,
            description, purchase_price, sale_price, sku, barcode, stock,
            reorder_point, supplier, supplier_id, entry_date, image_url, notes,
            location_in_store, updated_at
     FROM products WHERE tenant_id = ? AND (updated_at > ? OR (updated_at = ? AND id > ?))
     ORDER BY updated_at ASC, id ASC LIMIT 500`,
    [tenantId, cp.since],
    [tenantId, cp.since, cp.since, cp.afterId]
  );

  // ── Clientes ──────────────────────────────────────────────────────────────
  const cc = c('customers');
  const customers = await queryWithCursor(
    `SELECT id, tenant_id, cedula, name, phone, email, address, credit_limit, notes, updated_at
     FROM customers WHERE tenant_id = ? AND updated_at > ?
     ORDER BY updated_at ASC, id ASC LIMIT 500`,
    `SELECT id, tenant_id, cedula, name, phone, email, address, credit_limit, notes, updated_at
     FROM customers WHERE tenant_id = ? AND (updated_at > ? OR (updated_at = ? AND id > ?))
     ORDER BY updated_at ASC, id ASC LIMIT 500`,
    [tenantId, cc.since],
    [tenantId, cc.since, cc.since, cc.afterId]
  );

  // ── Ventas ────────────────────────────────────────────────────────────────
  const cs = c('sales');
  const sales = await queryWithCursor(
    `SELECT id, tenant_id, invoice_number, customer_id, customer_name, customer_phone,
            customer_email, subtotal, tax, discount, total, payment_method, amount_paid,
            change_amount, seller_id, seller_name, cash_session_id, status, credit_status,
            due_date, notes, created_at, updated_at
     FROM sales WHERE tenant_id = ? AND updated_at > ?
     ORDER BY updated_at ASC, id ASC LIMIT 200`,
    `SELECT id, tenant_id, invoice_number, customer_id, customer_name, customer_phone,
            customer_email, subtotal, tax, discount, total, payment_method, amount_paid,
            change_amount, seller_id, seller_name, cash_session_id, status, credit_status,
            due_date, notes, created_at, updated_at
     FROM sales WHERE tenant_id = ? AND (updated_at > ? OR (updated_at = ? AND id > ?))
     ORDER BY updated_at ASC, id ASC LIMIT 200`,
    [tenantId, cs.since],
    [tenantId, cs.since, cs.since, cs.afterId]
  );
  let saleItems: any[] = [];
  if ((sales as any[]).length > 0) {
    const ids = (sales as any[]).map((s: any) => s.id);
    const ph = ids.map(() => '?').join(',');
    const [rows] = await db.execute<RowDataPacket[]>(
      `SELECT id, tenant_id, sale_id, product_id, product_name, product_sku,
              quantity, unit_price, discount, subtotal, created_at
       FROM sale_items WHERE sale_id IN (${ph})`,
      ids
    );
    saleItems = rows as any[];
  }

  // ── Compras ───────────────────────────────────────────────────────────────
  const cpu = c('purchases');
  const purchases = await queryWithCursor(
    `SELECT id, tenant_id, invoice_number, supplier_id, supplier_name, purchase_date,
            document_type, subtotal, discount, tax, total, payment_method, payment_status,
            due_date, file_url, notes, created_by, created_at, updated_at
     FROM purchase_invoices WHERE tenant_id = ? AND updated_at > ?
     ORDER BY updated_at ASC, id ASC LIMIT 100`,
    `SELECT id, tenant_id, invoice_number, supplier_id, supplier_name, purchase_date,
            document_type, subtotal, discount, tax, total, payment_method, payment_status,
            due_date, file_url, notes, created_by, created_at, updated_at
     FROM purchase_invoices WHERE tenant_id = ? AND (updated_at > ? OR (updated_at = ? AND id > ?))
     ORDER BY updated_at ASC, id ASC LIMIT 100`,
    [tenantId, cpu.since],
    [tenantId, cpu.since, cpu.since, cpu.afterId]
  );
  let purchaseItems: any[] = [];
  if ((purchases as any[]).length > 0) {
    const ids = (purchases as any[]).map((p: any) => p.id);
    const ph = ids.map(() => '?').join(',');
    const [rows] = await db.execute<RowDataPacket[]>(
      `SELECT id, tenant_id, invoice_id, product_id, product_name, product_sku,
              quantity, unit_cost, subtotal
       FROM purchase_invoice_items WHERE invoice_id IN (${ph})`,
      ids
    );
    purchaseItems = rows as any[];
  }

  // ── Movimientos de stock ──────────────────────────────────────────────────
  const cm = c('movements');
  const [movements] = await db.execute<RowDataPacket[]>(
    `SELECT id, tenant_id, product_id, type, quantity, previous_stock, new_stock,
            reason, reference_id, user_id, created_at
     FROM stock_movements WHERE tenant_id = ? AND created_at > ?
     ORDER BY created_at ASC, id ASC LIMIT 500`,
    [tenantId, cm.since]
  );

  // ── Sesiones de caja ──────────────────────────────────────────────────────
  const ccs = c('cashSessions');
  const [cashSessions] = await db.execute<RowDataPacket[]>(
    `SELECT id, tenant_id, opened_by, opened_by_name, opening_amount, opened_at,
            closed_by, closed_by_name, closed_at, status, observations,
            total_sales_count, total_cash_sales, total_card_sales,
            total_transfer_sales, total_fiado_sales, created_at, updated_at
     FROM cash_sessions WHERE tenant_id = ? AND updated_at > ?
     ORDER BY updated_at ASC, id ASC LIMIT 100`,
    [tenantId, ccs.since]
  );

  // ── Pagos de crédito ──────────────────────────────────────────────────────
  const ccp = c('creditPayments');
  const [creditPayments] = await db.execute<RowDataPacket[]>(
    `SELECT id, tenant_id, sale_id, customer_id, amount, payment_method,
            receipt_number, notes, received_by, created_at
     FROM credit_payments WHERE tenant_id = ? AND created_at > ?
     ORDER BY created_at ASC, id ASC LIMIT 200`,
    [tenantId, ccp.since]
  );

  // ── Recetas BOM (product_recipes) ─────────────────────────────────────────
  const cr = c('recipes') ?? { since: EPOCH, afterId: '' };
  const [productRecipes] = await db.execute<RowDataPacket[]>(
    `SELECT id, tenant_id, product_id, ingredient_id, quantity, include_in_cost, created_at
     FROM product_recipes WHERE tenant_id = ? AND created_at > ?
     ORDER BY created_at ASC, id ASC LIMIT 500`,
    [tenantId, cr.since]
  );

  // ── Pedidos del storefront ─────────────────────────────────────────────────
  const co = c('orders');
  const [orders] = await db.execute<RowDataPacket[]>(
    `SELECT id, tenant_id, order_number, customer_name, customer_phone, customer_email,
            customer_cedula, department, municipality, address, neighborhood,
            subtotal, shipping_cost, discount, total, status, payment_method,
            delivery_status, notes, created_at, updated_at
     FROM storefront_orders WHERE tenant_id = ? AND updated_at > ?
     ORDER BY updated_at ASC, id ASC LIMIT 200`,
    [tenantId, co.since]
  );
  let orderItems: any[] = [];
  if ((orders as any[]).length > 0) {
    const ids = (orders as any[]).map((o: any) => o.id);
    const ph = ids.map(() => '?').join(',');
    const [rows] = await db.execute<RowDataPacket[]>(
      `SELECT id, order_id, product_id, product_name, product_image,
              quantity, unit_price, original_price, discount_percent,
              total_price, size, color
       FROM storefront_order_items WHERE order_id IN (${ph})`,
      ids
    );
    orderItems = rows as any[];
  }

  return {
    tenant: (tenantRows as any[])[0] || null,
    users,
    categories, storeInfo: (storeRows as any[])[0] || null,
    products, customers,
    sales, saleItems,
    purchases, purchaseItems,
    movements,
    cashSessions,
    creditPayments,
    productRecipes,
    orders, orderItems,
  };
}

// ─── Ciclo principal de sync ──────────────────────────────────────────────────

export async function runSync(): Promise<{ salesSynced: number; purchasesSynced: number; pulled: number }> {
  if (state.isSyncing) return { salesSynced: 0, purchasesSynced: 0, pulled: 0 };

  state.isSyncing = true;
  try {
    const online = await checkConnectivity();
    state.isOnline = online;

    const pending = await countPending();
    state.pendingSales = pending.sales;
    state.pendingPurchases = pending.purchases;

    if (!online) {
      return { salesSynced: 0, purchasesSynced: 0, pulled: 0 };
    }

    // 1. PUSH: subir todos los datos locales a la nube (backup completo)
    const salesSynced     = await pushSales();
    const purchasesSynced = await pushPurchases();
    await pushCustomers();
    await pushProducts();
    await pushMovements();
    await pushCashSessions();
    await pushCreditPayments();
    // Nota: las categorías NO se pushean desde local → nube.
    // Son administradas en la nube (fuente de verdad) y bajan al local vía pullFromCloud.
    // Pushear categorías locales sobreescribiría eliminaciones hechas en la nube.
    await pushOrders();
    await pushRecipes();
    await pushSuppliers();

    // 2. PULL: bajar cambios de la nube (productos, clientes, etc.)
    const pulled = await pullFromCloud();

    // Actualizar contadores después del push
    const pendingAfter = await countPending();
    state.pendingSales = pendingAfter.sales;
    state.pendingPurchases = pendingAfter.purchases;
    state.lastSyncAt = new Date();

    return { salesSynced, purchasesSynced, pulled };
  } finally {
    state.isSyncing = false;
  }
}

// ─── Scheduler ───────────────────────────────────────────────────────────────

export function startSyncScheduler(): void {
  if (!config.sync.isLocalInstance || !config.sync.cloudApiUrl) {
    return; // Solo activo en instancias locales con CLOUD_API_URL configurado
  }

  console.log(`[Sync] Instancia local detectada. Scheduler iniciado (cada ${config.sync.intervalMs / 1000}s)`);
  console.log(`[Sync] Destino: ${config.sync.cloudApiUrl}`);

  // Primer intento al arrancar
  runSync().catch((err) => console.error('[Sync] Error en sync inicial:', err));

  syncTimer = setInterval(() => {
    runSync().catch((err) => console.error('[Sync] Error en sync:', err));
  }, config.sync.intervalMs);
}

export function stopSyncScheduler(): void {
  if (syncTimer) {
    clearInterval(syncTimer);
    syncTimer = null;
  }
}

export function getSyncStatus(): SyncStatus & { isLocalInstance: boolean } {
  return {
    ...state,
    isLocalInstance: config.sync.isLocalInstance,
  };
}

/**
 * Reinicia todos los cursores de pull a EPOCH forzando que el próximo pullFromCloud
 * descargue TODO el historial desde la nube. Útil para recuperar datos faltantes.
 */
export function resetSyncCursors(): void {
  for (const key of Object.keys(pullCursors)) {
    pullCursors[key] = { since: EPOCH, afterId: '' };
  }
  state.lastPullAt = null;
  console.log('[Sync] Cursores reiniciados a EPOCH — el próximo ciclo descargará todo el historial.');
}
