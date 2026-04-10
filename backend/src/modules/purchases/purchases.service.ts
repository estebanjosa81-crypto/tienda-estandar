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
  document_type: string;
  subtotal: number;
  discount: number;
  tax: number;
  total: number;
  payment_method: string;
  payment_status: string;
  due_date: Date | null;
  file_url: string | null;
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
  purchase_price: number | null;
}

interface SupplierRow extends RowDataPacket {
  id: string;
  name: string;
  contact_name: string | null;
  phone: string | null;
  email: string | null;
  city: string | null;
  address: string | null;
  tax_id: string | null;
  payment_terms: string | null;
  notes: string | null;
}

interface CountRow extends RowDataPacket {
  total: number;
}

export interface CreatePurchaseItem {
  productId: string;
  quantity: number;
  unitCost: number;
  salePrice?: number;
}

export interface CreatePurchaseData {
  invoiceNumber: string;
  supplierId?: string;
  supplierName: string;
  purchaseDate: string;
  documentType?: 'factura' | 'remision' | 'orden_compra' | 'nota_credito';
  items: CreatePurchaseItem[];
  paymentMethod?: 'efectivo' | 'transferencia' | 'tarjeta' | 'credito' | 'nequi' | 'daviplata' | 'credito_proveedor' | 'mixto';
  paymentStatus?: 'pagado' | 'pendiente' | 'parcial';
  dueDate?: string;
  fileUrl?: string;
  discount?: number;
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
      documentType: row.document_type || 'factura',
      subtotal: Number(row.subtotal),
      discount: Number(row.discount || 0),
      tax: Number(row.tax),
      total: Number(row.total),
      paymentMethod: row.payment_method,
      paymentStatus: row.payment_status,
      dueDate: row.due_date || null,
      fileUrl: row.file_url || null,
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

  private mapSupplier(row: SupplierRow) {
    return {
      id: row.id,
      name: row.name,
      contactName: row.contact_name,
      phone: row.phone,
      email: row.email,
      city: row.city,
      address: row.address,
      taxId: row.tax_id,
      paymentTerms: row.payment_terms,
      notes: row.notes,
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

  async getNextInvoiceNumber(tenantId: string): Promise<string> {
    const year = new Date().getFullYear();
    const [rows] = await db.execute<CountRow[]>(
      `SELECT COUNT(*) as total FROM purchase_invoices WHERE tenant_id = ? AND YEAR(created_at) = ?`,
      [tenantId, year]
    );
    const count = (rows[0].total || 0) + 1;
    return `FC-${year}-${String(count).padStart(4, '0')}`;
  }

  async getSupplierStats(tenantId: string, supplierId: string) {
    const [rows] = await db.execute<RowDataPacket[]>(
      `SELECT
         COUNT(*) AS total_facturas,
         COALESCE(SUM(total), 0) AS total_comprado,
         MAX(purchase_date) AS ultima_compra,
         SUM(CASE WHEN payment_status = 'pendiente' THEN 1 ELSE 0 END) AS facturas_pendientes
       FROM purchase_invoices
       WHERE tenant_id = ? AND supplier_id = ?`,
      [tenantId, supplierId]
    );
    return {
      totalFacturas: Number(rows[0].total_facturas || 0),
      totalComprado: Number(rows[0].total_comprado || 0),
      ultimaCompra: rows[0].ultima_compra || null,
      facturasPendientes: Number(rows[0].facturas_pendientes || 0),
    };
  }

  async create(tenantId: string, userId: string, data: CreatePurchaseData) {
    const connection = await db.getConnection();

    try {
      await connection.beginTransaction();

      const invoiceId = uuidv4();
      let subtotal = 0;
      const discount = data.discount || 0;

      interface ItemToInsert {
        id: string;
        productId: string;
        productName: string;
        productSku: string;
        quantity: number;
        unitCost: number;
        salePrice?: number;
        subtotal: number;
        currentStock: number;
        currentPurchasePrice: number;
      }

      const itemsToInsert: ItemToInsert[] = [];

      for (const item of data.items) {
        const [productRows] = await connection.execute<ProductRow[]>(
          'SELECT id, stock, name, sku, purchase_price FROM products WHERE id = ? AND tenant_id = ? FOR UPDATE',
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
          salePrice: item.salePrice,
          subtotal: itemSubtotal,
          currentStock: Number(product.stock),
          currentPurchasePrice: Number(product.purchase_price || 0),
        });
      }

      // Determine payment status automatically if not explicitly provided
      const paymentMethod = data.paymentMethod || 'efectivo';
      let paymentStatus = data.paymentStatus;
      if (!paymentStatus) {
        paymentStatus = paymentMethod === 'credito_proveedor' ? 'pendiente' : 'pagado';
      }

      const total = subtotal - discount;

      // Insert purchase invoice header
      await connection.execute<ResultSetHeader>(
        `INSERT INTO purchase_invoices
          (id, tenant_id, invoice_number, supplier_id, supplier_name, purchase_date, document_type,
           subtotal, discount, tax, total, payment_method, payment_status, due_date, file_url, notes, created_by)
         VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, 0, ?, ?, ?, ?, ?, ?, ?)`,
        [
          invoiceId,
          tenantId,
          data.invoiceNumber,
          data.supplierId || null,
          data.supplierName,
          data.purchaseDate,
          data.documentType || 'factura',
          subtotal,
          discount,
          total,
          paymentMethod,
          paymentStatus,
          data.dueDate || null,
          data.fileUrl || null,
          data.notes || null,
          userId,
        ]
      );

      // Insert items, update stock with weighted average cost
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

        // Weighted average cost formula:
        // new_avg = (current_stock * current_cost + quantity * new_cost) / new_stock
        let newAvgCost: number;
        if (item.currentStock > 0 && item.currentPurchasePrice > 0) {
          newAvgCost = ((item.currentStock * item.currentPurchasePrice) + (item.quantity * item.unitCost)) / newStock;
        } else {
          newAvgCost = item.unitCost;
        }

        // Update product stock, weighted average cost, and sale price if provided
        if (item.salePrice != null && item.salePrice > 0) {
          await connection.execute(
            'UPDATE products SET stock = ?, purchase_price = ?, sale_price = ? WHERE id = ?',
            [newStock, newAvgCost, item.salePrice, item.productId]
          );
        } else {
          await connection.execute(
            'UPDATE products SET stock = ?, purchase_price = ? WHERE id = ?',
            [newStock, newAvgCost, item.productId]
          );
        }

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

  async update(id: string, tenantId: string, data: {
    invoiceNumber?: string;
    supplierName?: string;
    supplierId?: string | null;
    purchaseDate?: string;
    documentType?: string;
    paymentMethod?: string;
    paymentStatus?: string;
    dueDate?: string | null;
    fileUrl?: string | null;
    discount?: number;
    notes?: string | null;
  }) {
    const fields: string[] = [];
    const values: any[] = [];

    if (data.invoiceNumber !== undefined) { fields.push('invoice_number = ?'); values.push(data.invoiceNumber); }
    if (data.supplierName !== undefined) { fields.push('supplier_name = ?'); values.push(data.supplierName); }
    if ('supplierId' in data) { fields.push('supplier_id = ?'); values.push(data.supplierId ?? null); }
    if (data.purchaseDate !== undefined) { fields.push('purchase_date = ?'); values.push(data.purchaseDate); }
    if (data.documentType !== undefined) { fields.push('document_type = ?'); values.push(data.documentType); }
    if (data.paymentMethod !== undefined) { fields.push('payment_method = ?'); values.push(data.paymentMethod); }
    if (data.paymentStatus !== undefined) { fields.push('payment_status = ?'); values.push(data.paymentStatus); }
    if ('dueDate' in data) { fields.push('due_date = ?'); values.push(data.dueDate ?? null); }
    if ('fileUrl' in data) { fields.push('file_url = ?'); values.push(data.fileUrl ?? null); }
    if (data.discount !== undefined) {
      fields.push('discount = ?');
      values.push(data.discount);
      // Recalculate total from current subtotal
      const [rows] = await db.execute<PurchaseInvoiceRow[]>(
        'SELECT subtotal FROM purchase_invoices WHERE id = ? AND tenant_id = ?',
        [id, tenantId]
      );
      if (rows.length > 0) {
        fields.push('total = ?');
        values.push(Number(rows[0].subtotal) - data.discount);
      }
    }
    if ('notes' in data) { fields.push('notes = ?'); values.push(data.notes ?? null); }

    if (fields.length === 0) return this.findById(id, tenantId);

    values.push(id, tenantId);
    await db.execute(
      `UPDATE purchase_invoices SET ${fields.join(', ')} WHERE id = ? AND tenant_id = ?`,
      values
    );

    return this.findById(id, tenantId);
  }

  async getSuppliers(tenantId: string) {
    const [rows] = await db.execute<SupplierRow[]>(
      `SELECT id, name, contact_name, phone, email, address, city, tax_id, payment_terms, notes
       FROM suppliers WHERE tenant_id = ? AND is_active = TRUE ORDER BY name`,
      [tenantId]
    );
    return rows.map(this.mapSupplier);
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
      `SELECT id, name, contact_name, phone, email, address, city, tax_id, payment_terms, notes
       FROM suppliers WHERE id = ?`,
      [id]
    );
    return this.mapSupplier(rows[0]);
  }
}

export const purchasesService = new PurchasesService();
