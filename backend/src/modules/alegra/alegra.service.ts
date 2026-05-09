import pool from '../../config/database';

interface AlegraConfig {
  email: string;
  token: string;
  numberTemplateId: number;
  taxId: number | null;
}

export interface AlegraInvoiceItem {
  name: string;
  quantity: number;
  price: number;
  applyTax: boolean;
}

export interface AlegraInvoiceData {
  tenantId: string;
  saleId: string;
  invoiceNumber: string;
  customerName: string;
  customerEmail?: string;
  customerPhone?: string;
  customerCedula?: string;
  date: string;
  items: AlegraInvoiceItem[];
  observations?: string;
}

export interface AlegraInvoiceResult {
  alegraId: string;
  cufe?: string;
  pdfUrl?: string;
  dianStatus: string;
}

export class AlegraService {
  private async getConfig(tenantId: string): Promise<AlegraConfig | null> {
    let email = process.env.ALEGRA_EMAIL || '';
    let token = process.env.ALEGRA_TOKEN || '';
    let numberTemplateId = parseInt(process.env.ALEGRA_NUMBER_TEMPLATE_ID || '0');
    let taxId = process.env.ALEGRA_TAX_ID ? parseInt(process.env.ALEGRA_TAX_ID) : null;

    if (!email || !token) {
      const [rows] = await pool.query(
        `SELECT setting_key, setting_value FROM platform_settings
         WHERE setting_key IN ('alegra_email','alegra_token','alegra_number_template_id','alegra_tax_id','alegra_enabled')
         LIMIT 10`
      ) as any[];

      const s: Record<string, string> = {};
      for (const r of rows) s[r.setting_key] = r.setting_value || '';

      if (s['alegra_enabled'] === 'false') return null;

      email = s['alegra_email'] || '';
      token = s['alegra_token'] || '';
      numberTemplateId = parseInt(s['alegra_number_template_id'] || '0');
      taxId = s['alegra_tax_id'] ? parseInt(s['alegra_tax_id']) : null;
    }

    if (!email || !token || !numberTemplateId) return null;

    return { email, token, numberTemplateId, taxId };
  }

  private authHeader(email: string, token: string): string {
    return 'Basic ' + Buffer.from(`${email}:${token}`).toString('base64');
  }

  async createInvoice(data: AlegraInvoiceData): Promise<AlegraInvoiceResult | null> {
    const config = await this.getConfig(data.tenantId);
    if (!config) {
      console.log('[Alegra] No configurado — se omite factura electrónica');
      return null;
    }

    const payload = {
      date: data.date,
      dueDate: data.date,
      client: {
        name: data.customerName || 'Consumidor Final',
        identification: data.customerCedula || '222222222222',
        ...(data.customerEmail ? { email: data.customerEmail } : {}),
        ...(data.customerPhone ? { phone: data.customerPhone } : {}),
        type: 'person',
      },
      numberTemplate: { id: config.numberTemplateId },
      items: data.items.map(item => ({
        name: item.name,
        quantity: item.quantity,
        price: item.price,
        ...(config.taxId && item.applyTax ? { tax: [{ id: config.taxId }] } : {}),
      })),
      currency: { code: 'COP', exchangeRate: 1 },
      observations: data.observations || `Pedido online ${data.invoiceNumber}`,
    };

    const res = await fetch('https://app.alegra.com/api/v1/invoices', {
      method: 'POST',
      headers: {
        Authorization: this.authHeader(config.email, config.token),
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(payload),
    });

    if (!res.ok) {
      const body = await res.text();
      throw new Error(`Alegra ${res.status}: ${body}`);
    }

    const result = await res.json() as any;

    return {
      alegraId: String(result.id),
      cufe: result.stamp?.cufe || result.cufe || undefined,
      pdfUrl: result.pdf || undefined,
      dianStatus: result.stamp?.status || result.status || 'created',
    };
  }

  // Guarda el resultado de Alegra en la tabla sales (fuera de transacción)
  async saveResult(saleId: string, result: AlegraInvoiceResult): Promise<void> {
    await pool.query(
      `UPDATE sales SET alegra_id = ?, cufe = ?, dian_status = ?, alegra_pdf_url = ? WHERE id = ?`,
      [result.alegraId, result.cufe || null, result.dianStatus, result.pdfUrl || null, saleId]
    );
  }
}

export const alegraService = new AlegraService();
