import { v4 as uuidv4 } from 'uuid';
import { db } from '../../config';
import { AppError } from '../../common/middleware';
import { RowDataPacket, ResultSetHeader } from 'mysql2';

interface PurchaseInvoiceRow extends RowDataPacket {
  id: string;
  tenant_id: string;
  invoice_number: string;
  supplier_id: string | null;
  supplier_name: string;
  purchase_date: Date;
  subtotal: number;
  tax: number;
  total: number;
  payment_method: string;
  payment_status: string;
  notes: string | null;
  created_by: string | null;
  created_at: Date;
  updated_at: Date;
}

interface PurchaseInvoiceItemRow extends RowDataPacket {
  id: string;
  invoice_id: string;
  product_id: string;
  product_name: string;
  product_sku: string;
  quantity: number;
  unit_cost: number;
  subtotal: number;
}

interface ProductRow extends RowDataPacket {
  id: string;
  stock: number;
  name: string;
  sku: string;
}

interface SupplierRow extends RowDataPacket {
  id: string;
  name: string;
  contact_name: string | null;
  phone: string | null;
  email: string | null;
  city: string | null;
}

interface CountRow extends RowDataPacket {
  total: number;
}

export interface CreatePurchaseItem {
  productId: string;
  quantity: number;
  unitCost: number;
}

export interface CreatePurchaseData {
  invoiceNumber: string;
  supplierId?: string;
  supplierName: string;
  purchaseDate: string;
  items: CreatePurchaseItem[];
  paymentMethod?: 'efectivo' | 'transferencia' | 'tarjeta' | 'credito';
  paymentStatus?: 'pagado' | 'pendiente' | 'parcial';
  notes?: string;
}

export class PurchasesService {
  private mapInvoice(row: PurchaseInvoiceRow, items: PurchaseInvoiceItemRow[] = []) {
    return {
      id: row.id,
      invoiceNumber: row.invoice_number,
      supplierId: row.supplier_id,
      supplierName: row.supplier_name,
      purchaseDate: row.purchase_date,
      subtotal: Number(row.subtotal),
      tax: Number(row.tax),
      total: Number(row.total),
      paymentMethod: row.payment_method,
      paymentStatus: row.payment_status,
      notes: row.notes,
      createdBy: row.created_by,
      createdAt: row.created_at,
      updatedAt: row.updated_at,
      items: items.map((i) => ({
        id: i.id,
        invoiceId: i.invoice_id,
        productId: i.product_id,
        productName: i.product_name,
        productSku: i.product_sku,
        quantity: Number(i.quantity),
        unitCost: Number(i.unit_cost),
        subtotal: Number(i.subtotal),
      })),
    };
  }

  async findAll(tenantId: string, page = 1, limit = 20) {
    const offset = (page - 1) * limit;

    const [countRows] = await db.execute<CountRow[]>(
      'SELECT COUNT(*) as total FROM purchase_invoices WHERE tenant_id = ?',
      [tenantId]
    );
    const total = countRows[0].total;

    const [rows] = await db.execute<PurchaseInvoiceRow[]>(
      'SELECT * FROM purchase_invoices WHERE tenant_id = ? ORDER BY created_at DESC LIMIT ? OFFSET ?',
      [tenantId, String(limit), String(offset)]
    );

    const invoicesWithItems = [];
    for (const row of rows) {
      const [itemRows] = await db.execute<PurchaseInvoiceItemRow[]>(
        'SELECT * FROM purchase_invoice_items WHERE invoice_id = ?',
        [row.id]
      );
      invoicesWithItems.push(this.mapInvoice(row, itemRows));
    }

    return {
      data: invoicesWithItems,
      pagination: {
        page,
        limit,
        total,
        totalPages: Math.ceil(total / limit),
      },
    };
  }

  async findById(id: string, tenantId: string) {
    const [rows] = await db.execute<PurchaseInvoiceRow[]>(
      'SELECT * FROM purchase_invoices WHERE id = ? AND tenant_id = ?',
      [id, tenantId]
    );

    if (rows.length === 0) {
      throw new AppError('Factura de compra no encontrada', 404);
    }

    const [itemRows] = await db.execute<PurchaseInvoiceItemRow[]>(
      'SELECT * FROM purchase_invoice_items WHERE invoice_id = ?',
      [id]
    );

    return this.mapInvoice(rows[0], itemRows);
  }

  async create(tenantId: string, userId: string, data: CreatePurchaseData) {
    const connection = await db.getConnection();

    try {
      await connection.beginTransaction();

      const invoiceId = uuidv4();
      let subtotal = 0;

      interface ItemToInsert {
        id: string;
        productId: string;
        productName: string;
        productSku: string;
        quantity: number;
        unitCost: number;
        subtotal: number;
        currentStock: number;
      }

      const itemsToInsert: ItemToInsert[] = [];

      for (const item of data.items) {
        const [productRows] = await connection.execute<ProductRow[]>(
          'SELECT id, stock, name, sku FROM products WHERE id = ? AND tenant_id = ? FOR UPDATE',
          [item.productId, tenantId]
        );

        if (productRows.length === 0) {
          throw new AppError(`Producto no encontrado: ${item.productId}`, 404);
        }

        const product = productRows[0];
        const itemSubtotal = item.quantity * item.unitCost;
        subtotal += itemSubtotal;

        itemsToInsert.push({
          id: uuidv4(),
          productId: item.productId,
          productName: product.name,
          productSku: product.sku,
          quantity: item.quantity,
          unitCost: item.unitCost,
          subtotal: itemSubtotal,
          currentStock: product.stock,
        });
      }

      // Insert purchase invoice header
      await connection.execute<ResultSetHeader>(
        `INSERT INTO purchase_invoices
          (id, tenant_id, invoice_number, supplier_id, supplier_name, purchase_date, subtotal, tax, total, payment_method, payment_status, notes, created_by)
         VALUES (?, ?, ?, ?, ?, ?, ?, 0, ?, ?, ?, ?, ?)`,
        [
          invoiceId,
          tenantId,
          data.invoiceNumber,
          data.supplierId || null,
          data.supplierName,
          data.purchaseDate,
          subtotal,
          subtotal,
          data.paymentMethod || 'efectivo',
          data.paymentStatus || 'pagado',
          data.notes || null,
          userId,
        ]
      );

      // Insert items, update stock and register movements
      for (const item of itemsToInsert) {
        await connection.execute(
          `INSERT INTO purchase_invoice_items (id, tenant_id, invoice_id, product_id, product_name, product_sku, quantity, unit_cost, subtotal)
           VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)`,
          [
            item.id,
            tenantId,
            invoiceId,
            item.productId,
            item.productName,
            item.productSku,
            item.quantity,
            item.unitCost,
            item.subtotal,
          ]
        );

        const newStock = item.currentStock + item.quantity;

        // Update product stock
        await connection.execute(
          'UPDATE products SET stock = ? WHERE id = ?',
          [newStock, item.productId]
        );

        // Register stock movement (entrada)
        await connection.execute(
          `INSERT INTO stock_movements (id, tenant_id, product_id, type, quantity, previous_stock, new_stock, reason, reference_id, user_id)
           VALUES (?, ?, ?, 'entrada', ?, ?, ?, ?, ?, ?)`,
          [
            uuidv4(),
            tenantId,
            item.productId,
            item.quantity,
            item.currentStock,
            newStock,
            `Compra ${data.invoiceNumber} - ${data.supplierName}`,
            invoiceId,
            userId,
          ]
        );

        // Update purchase_price to reflect actual cost paid
        if (item.unitCost > 0) {
          await connection.execute(
            'UPDATE products SET purchase_price = ? WHERE id = ? AND tenant_id = ?',
            [item.unitCost, item.productId, tenantId]
          );
        }
      }

      await connection.commit();

      return this.findById(invoiceId, tenantId);
    } catch (error) {
      await connection.rollback();
      throw error;
    } finally {
      connection.release();
    }
  }

  async getSuppliers(tenantId: string) {
    const [rows] = await db.execute<SupplierRow[]>(
      'SELECT id, name, contact_name, phone, email, city FROM suppliers WHERE tenant_id = ? AND is_active = TRUE ORDER BY name',
      [tenantId]
    );
    return rows;
  }

  async createSupplier(tenantId: string, data: {
    name: string;
    contactName?: string;
    phone?: string;
    email?: string;
    city?: string;
    address?: string;
    taxId?: string;
    paymentTerms?: string;
    notes?: string;
  }) {
    const id = uuidv4();
    await db.execute(
      `INSERT INTO suppliers (id, tenant_id, name, contact_name, phone, email, city, address, tax_id, payment_terms, notes, is_active)
       VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, TRUE)`,
      [
        id,
        tenantId,
        data.name,
        data.contactName || null,
        data.phone || null,
        data.email || null,
        data.city || null,
        data.address || null,
        data.taxId || null,
        data.paymentTerms || null,
        data.notes || null,
      ]
    );
    const [rows] = await db.execute<SupplierRow[]>(
      'SELECT id, name, contact_name, phone, email, city FROM suppliers WHERE id = ?',
      [id]
    );
    return rows[0];
  }
}

export const purchasesService = new PurchasesService();
