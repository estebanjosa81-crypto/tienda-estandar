import { Router, Request, Response, NextFunction } from 'express';
import { body, query, param } from 'express-validator';
import { v4 as uuidv4 } from 'uuid';
import { validateRequest } from '../../utils/validators';
import pool from '../../config/database';
import { authenticate } from '../../common/middleware';
import { config } from '../../config/env';
import { MercadoPagoConfig, Preference } from 'mercadopago';
import crypto from 'crypto';
import { audit } from '../../utils/audit-logger';

const router: ReturnType<typeof Router> = Router();

// =============================================
// PUBLIC: Crear pedido desde el storefront (sin auth)
// =============================================
router.post(
  '/public',
  [
    body('customerName').notEmpty().withMessage('Nombre del cliente es requerido'),
    body('customerPhone').notEmpty().withMessage('Teléfono es requerido'),
    body('customerEmail').optional().isEmail().withMessage('Email inválido'),
    body('customerCedula').optional().notEmpty(),
    body('department').optional().notEmpty(),
    body('municipality').optional().notEmpty(),
    body('address').optional().notEmpty(),
    body('neighborhood').optional().notEmpty(),
    body('notes').optional(),
    body('items').isArray({ min: 1 }).withMessage('Debe incluir al menos un producto'),
    body('items.*.productId').notEmpty().withMessage('ID de producto requerido'),
    body('items.*.productName').notEmpty().withMessage('Nombre de producto requerido'),
    body('items.*.quantity').isInt({ min: 1 }).withMessage('Cantidad debe ser al menos 1'),
    body('items.*.unitPrice').isFloat({ min: 0 }).withMessage('Precio unitario inválido'),
    body('deliveryLatitude').optional().isFloat().withMessage('Latitud inválida'),
    body('deliveryLongitude').optional().isFloat().withMessage('Longitud inválida'),
    body('clientUserId').optional().notEmpty(),
    body('tenantId').optional().notEmpty(),
    validateRequest,
  ],
  async (req: Request, res: Response, _next: NextFunction) => {
    try {
      const {
        customerName, customerPhone, customerEmail, customerCedula,
        department, municipality, address, neighborhood, notes,
        items, tenantId: requestedTenantId, paymentMethod, shippingCost = 0, discount = 0,
        deliveryLatitude, deliveryLongitude, clientUserId
      } = req.body;

      // Find tenant
      let tenantId = requestedTenantId;
      if (!tenantId) {
        const [tenants] = await pool.query(
          'SELECT id FROM tenants WHERE status = ? ORDER BY id ASC LIMIT 1',
          ['activo']
        ) as any;
        if (!tenants || tenants.length === 0) {
          res.status(400).json({ success: false, error: 'No hay tienda disponible' });
          return;
        }
        tenantId = tenants[0].id;
      }

      // Generate order number
      const orderNumber = `PED-${Date.now().toString(36).toUpperCase()}`;
      const orderId = uuidv4();

      // Calculate totals
      const subtotal = items.reduce((sum: number, item: any) => sum + (item.unitPrice * item.quantity), 0);
      const total = Math.max(0, subtotal + shippingCost - discount);

      // Append coupon to notes if code provided
      const couponNote = req.body.couponCode
        ? ` [Cupón: ${req.body.couponCode} - Descuento: $${discount}]`
        : '';
      const finalNotes = (notes || '') + couponNote;

      // Insert order
      await pool.query(
        `INSERT INTO storefront_orders
          (id, tenant_id, order_number, customer_name, customer_phone, customer_email, customer_cedula,
           department, municipality, address, neighborhood, delivery_latitude, delivery_longitude,
           notes, subtotal, shipping_cost, discount, total, payment_method, client_user_id, status)
         VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'pendiente')`,
        [orderId, tenantId, orderNumber, customerName, customerPhone, customerEmail || null, customerCedula || null,
          department || null, municipality || null, address || null, neighborhood || null,
          deliveryLatitude || null, deliveryLongitude || null, finalNotes,
          subtotal, shippingCost, discount, total, paymentMethod || null, clientUserId || null]
      );

      // Insert order items (con descuento por item para reportes DIAN)
      for (const item of items) {
        await pool.query(
          `INSERT INTO storefront_order_items
            (order_id, product_id, product_name, product_image, quantity, unit_price, original_price, discount_percent, total_price, size, color)
           VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
          [orderId, item.productId, item.productName, item.productImage || null,
            item.quantity, item.unitPrice, item.originalPrice || item.unitPrice, item.discountPercent || 0,
            item.unitPrice * item.quantity,
            item.size || null, item.color || null]
        );
      }

      // Fire merchant notification (async, non-blocking)
      try {
        const notifTitle = `Nuevo pedido #${orderNumber}`;
        const notifMsg = `${customerName} realizó un pedido por $${total.toLocaleString('es-CO')}`;
        await pool.query(
          `INSERT INTO merchant_notifications (tenant_id, type, title, message, data)
           VALUES (?, 'new_order', ?, ?, ?)`,
          [tenantId, notifTitle, notifMsg, JSON.stringify({ orderId, orderNumber, customerName, total, paymentMethod })]
        );
      } catch { /* notifications are non-critical */ }

      res.status(201).json({
        success: true,
        data: {
          orderId,
          orderNumber,
          total,
          status: 'pendiente',
          message: 'Pedido creado exitosamente'
        }
      });
    } catch (error) {
      console.error('Create order error:', error);
      res.status(500).json({ success: false, error: 'Error al crear el pedido' });
    }
  }
);

// =============================================
// PUBLIC: Crear preferencia Checkout Pro de MercadoPago
// =============================================
router.post(
  '/mp-preference',
  [
    body('customerName').notEmpty(),
    body('customerPhone').notEmpty(),
    body('customerEmail').optional().isEmail(),
    body('items').isArray({ min: 1 }),
    body('items.*.productId').notEmpty(),
    body('items.*.productName').notEmpty(),
    body('items.*.quantity').isInt({ min: 1 }),
    body('items.*.unitPrice').isFloat({ min: 0 }),
    validateRequest,
  ],
  async (req: Request, res: Response, _next: NextFunction) => {
    try {
      // Read MP token from env or platform_settings DB
      let mpToken = config.mp.accessToken;
      let frontendUrl = config.mp.frontendUrl;
      if (!mpToken) {
        const [psRows] = await pool.query(
          "SELECT setting_key, setting_value FROM platform_settings WHERE setting_key IN ('mp_access_token','frontend_url')"
        ) as any;
        for (const r of psRows) {
          if (r.setting_key === 'mp_access_token') mpToken = r.setting_value;
          if (r.setting_key === 'frontend_url') frontendUrl = r.setting_value || frontendUrl;
        }
      }
      if (!mpToken) {
        res.status(503).json({ success: false, error: 'Pago en línea no configurado. Configúralo en el panel de administración.' });
        return;
      }

      const {
        customerName, customerPhone, customerEmail, customerCedula,
        department, municipality, address, neighborhood, notes,
        items, tenantId: requestedTenantId, couponCode, discount = 0,
      } = req.body;

      // Find tenant
      let tenantId = requestedTenantId;
      if (!tenantId) {
        const [tenants] = await pool.query(
          'SELECT id FROM tenants WHERE status = ? ORDER BY id ASC LIMIT 1',
          ['activo']
        ) as any;
        if (!tenants || tenants.length === 0) {
          res.status(400).json({ success: false, error: 'No hay tienda disponible' });
          return;
        }
        tenantId = tenants[0].id;
      }

      // Check if online payment discount is enabled for this tenant
      let onlineDiscountEnabled = false;
      try {
        const [siRows] = await pool.query(
          'SELECT online_discount_enabled FROM store_info WHERE tenant_id = ? LIMIT 1',
          [tenantId]
        ) as any;
        if (siRows && siRows.length > 0) {
          onlineDiscountEnabled = siRows[0].online_discount_enabled === 1 || siRows[0].online_discount_enabled === true;
        }
      } catch { /* column may not exist yet — default false */ }

      // Apply 10% online payment discount only if enabled
      const ONLINE_DISCOUNT = 0.10;
      const discountedItems = items.map((item: any) => ({
        ...item,
        unitPrice: onlineDiscountEnabled
          ? Math.round(item.unitPrice * (1 - ONLINE_DISCOUNT))
          : item.unitPrice,
      }));

      const subtotal = discountedItems.reduce((sum: number, item: any) => sum + (item.unitPrice * item.quantity), 0);
      const total = Math.max(0, subtotal - discount);

      // Create order in DB
      const orderNumber = `PED-${Date.now().toString(36).toUpperCase()}`;
      const orderId = uuidv4();
      const couponNote = couponCode ? ` [Cupón: ${couponCode} - Desc: $${discount}]` : '';
      const onlineDiscountNote = onlineDiscountEnabled ? '[PAGO EN LÍNEA MP -10%] ' : '[PAGO EN LÍNEA MP] ';
      const finalNotes = `${onlineDiscountNote}${notes || ''}${couponNote}`.trim();

      await pool.query(
        `INSERT INTO storefront_orders
          (id, tenant_id, order_number, customer_name, customer_phone, customer_email, customer_cedula,
           department, municipality, address, neighborhood, notes, subtotal, shipping_cost, discount,
           total, payment_method, status)
         VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 0, ?, ?, 'mercadopago', 'pendiente')`,
        [orderId, tenantId, orderNumber, customerName, customerPhone, customerEmail || null, customerCedula || null,
          department || null, municipality || null, address || null, neighborhood || null, finalNotes,
          subtotal, discount, total]
      );

      const itemDiscountPct = onlineDiscountEnabled ? 10 : 0;
      for (const item of discountedItems) {
        await pool.query(
          `INSERT INTO storefront_order_items
            (order_id, product_id, product_name, product_image, quantity, unit_price, original_price, discount_percent, total_price)
           VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)`,
          [orderId, item.productId, item.productName, item.productImage || null,
            item.quantity, item.unitPrice, item.originalUnitPrice || item.unitPrice,
            itemDiscountPct, item.unitPrice * item.quantity]
        );
      }

      // Create MercadoPago preference
      const mpClient = new MercadoPagoConfig({ accessToken: mpToken });
      const preferenceClient = new Preference(mpClient);

      const preference = await preferenceClient.create({
        body: {
          external_reference: orderId,
          items: discountedItems.map((item: any) => ({
            id: item.productId,
            title: item.productName,
            quantity: item.quantity,
            unit_price: item.unitPrice,
            currency_id: 'COP',
          })),
          payer: {
            name: customerName,
            email: customerEmail || 'cliente@perfummua.com',
            phone: { number: customerPhone },
            identification: customerCedula ? { type: 'CC', number: customerCedula } : undefined,
          },
          back_urls: {
            success: `${frontendUrl}/?mp=success&order=${orderId}`,
            failure: `${frontendUrl}/?mp=failure&order=${orderId}`,
            pending: `${frontendUrl}/?mp=pending&order=${orderId}`,
          },
          auto_return: 'approved',
          statement_descriptor: 'PERFUM MUA',
          metadata: { orderId, orderNumber },
        },
      });

      res.status(201).json({
        success: true,
        data: {
          orderId,
          orderNumber,
          total,
          initPoint: preference.init_point,
          sandboxInitPoint: preference.sandbox_init_point,
        },
      });
    } catch (error) {
      console.error('MP preference error:', error);
      res.status(500).json({ success: false, error: 'Error al crear preferencia de pago' });
    }
  }
);

// =============================================
// PUBLIC: Crear aplicación de crédito con ADDI
// =============================================
router.post(
  '/addi-application',
  [
    body('customerName').notEmpty(),
    body('customerPhone').notEmpty(),
    body('customerEmail').optional().isEmail(),
    body('items').isArray({ min: 1 }),
    body('items.*.productId').notEmpty(),
    body('items.*.productName').notEmpty(),
    body('items.*.quantity').isInt({ min: 1 }),
    body('items.*.unitPrice').isFloat({ min: 0 }),
    validateRequest,
  ],
  async (req: Request, res: Response, _next: NextFunction) => {
    try {
      // Read ADDI credentials from env or platform_settings DB
      let addiClientId = process.env.ADDI_CLIENT_ID || '';
      let addiClientSecret = process.env.ADDI_CLIENT_SECRET || '';
      let addiStoreSlug = process.env.ADDI_STORE_SLUG || '';
      let addiProduction = process.env.ADDI_PRODUCTION === 'true';
      let addiProductionExplicitlySet = !!process.env.ADDI_PRODUCTION;

      if (!addiClientId || !addiClientSecret) {
        const [psRows] = await pool.query(
          "SELECT setting_key, setting_value FROM platform_settings WHERE setting_key IN ('addi_client_id','addi_client_secret','addi_store_slug','addi_production')"
        ) as any;
        for (const r of psRows) {
          if (r.setting_key === 'addi_client_id') addiClientId = r.setting_value || addiClientId;
          if (r.setting_key === 'addi_client_secret') addiClientSecret = r.setting_value || addiClientSecret;
          if (r.setting_key === 'addi_store_slug') addiStoreSlug = r.setting_value || addiStoreSlug;
          if (r.setting_key === 'addi_production') { addiProduction = r.setting_value === 'true'; addiProductionExplicitlySet = true; }
        }
      }

      // Use staging credentials as fallback if nothing configured
      const stagingClientId = 'y61CPhOS0YB7wxz8BgKBpQt4YcTsW0wi';
      if (!addiClientId) addiClientId = stagingClientId;
      if (!addiClientSecret) addiClientSecret = 'U6zgGfhZ_F-HLbqyM70fkssviIQ2PDL34phvGIL4wIppfoSXv-z63mrldcrnUZUi';

      // Real credentials always use production — staging fallback is only for default test creds
      if (addiClientId !== stagingClientId) addiProduction = true;

      const addiAudience = addiProduction ? 'https://api.addi.com' : 'https://api.staging.addi.com';
      const addiAuthUrl = addiProduction ? 'https://auth.addi.com/oauth/token' : 'https://auth.addi-staging.com/oauth/token';
      const addiApiUrl = addiProduction ? 'https://api.addi.com' : 'https://api.staging.addi.com';
      const frontendUrl = config.mp.frontendUrl || process.env.FRONTEND_URL || 'http://localhost:3000';

      // Step 1: Authenticate with ADDI
      const authRes = await fetch(addiAuthUrl, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          audience: addiAudience,
          grant_type: 'client_credentials',
          client_id: addiClientId,
          client_secret: addiClientSecret,
        }),
      });

      if (!authRes.ok) {
        const authErr = await authRes.text();
        console.error('ADDI auth error:', authErr);
        res.status(503).json({ success: false, error: 'Error al autenticar con ADDI. Verifica las credenciales.' });
        return;
      }

      const authData: any = await authRes.json();
      const addiToken = authData.access_token;
      if (!addiToken) {
        res.status(503).json({ success: false, error: 'No se recibió token de ADDI.' });
        return;
      }

      const {
        customerName, customerPhone, customerEmail, customerCedula,
        department, municipality, address, neighborhood, notes,
        items, tenantId: requestedTenantId, couponCode, discount = 0,
      } = req.body;

      // Find tenant
      let tenantId = requestedTenantId;
      if (!tenantId) {
        const [tenants] = await pool.query(
          'SELECT id FROM tenants WHERE status = ? ORDER BY id ASC LIMIT 1',
          ['activo']
        ) as any;
        if (!tenants || tenants.length === 0) {
          res.status(400).json({ success: false, error: 'No hay tienda disponible' });
          return;
        }
        tenantId = tenants[0].id;
      }

      const subtotal = items.reduce((sum: number, item: any) => sum + (item.unitPrice * item.quantity), 0);
      const total = Math.max(0, subtotal - discount);

      // Create order in DB
      const orderNumber = `PED-${Date.now().toString(36).toUpperCase()}`;
      const orderId = uuidv4();
      const couponNote = couponCode ? ` [Cupón: ${couponCode} - Desc: $${discount}]` : '';
      const finalNotes = `[PAGO ADDI] ${notes || ''}${couponNote}`.trim();

      await pool.query(
        `INSERT INTO storefront_orders
          (id, tenant_id, order_number, customer_name, customer_phone, customer_email, customer_cedula,
           department, municipality, address, neighborhood, notes, subtotal, shipping_cost, discount,
           total, payment_method, status)
         VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 0, ?, ?, 'addi', 'pendiente')`,
        [orderId, tenantId, orderNumber, customerName, customerPhone, customerEmail || null, customerCedula || null,
          department || null, municipality || null, address || null, neighborhood || null, finalNotes,
          subtotal, discount, total]
      );

      for (const item of items) {
        await pool.query(
          `INSERT INTO storefront_order_items
            (order_id, product_id, product_name, product_image, quantity, unit_price, original_price, discount_percent, total_price)
           VALUES (?, ?, ?, ?, ?, ?, ?, 0, ?)`,
          [orderId, item.productId, item.productName, item.productImage || null,
            item.quantity, item.unitPrice, item.originalUnitPrice || item.unitPrice,
            item.unitPrice * item.quantity]
        );
      }

      // Step 2: Create ADDI application
      const nameParts = customerName.trim().split(' ');
      const firstName = nameParts[0] || customerName;
      const lastName = nameParts.slice(1).join(' ') || customerName;

      // Addi requires phone with +57 country code
      const rawPhone = String(customerPhone || '').replace(/\D/g, '');
      const addiPhone = rawPhone.startsWith('57') ? `+${rawPhone}` : `+57${rawPhone}`;

      const addiClient: Record<string, any> = {
        firstName,
        lastName,
        cellphone: addiPhone,
        documentType: 'CC',
      };
      if (customerEmail) addiClient.email = customerEmail;
      if (customerCedula) addiClient.document = customerCedula;

      const addiPayload: Record<string, any> = {
        orderId,
        totalAmount: total,
        currency: 'COP',
        client: addiClient,
        products: items.map((item: any) => ({
          sku: String(item.productId),
          name: item.productName,
          quantity: item.quantity,
          unitPrice: item.unitPrice,
        })),
        redirectUrl: `${frontendUrl}/?addi=success&order=${orderId}`,
        cancelUrl: `${frontendUrl}/?addi=cancel&order=${orderId}`,
      };

      console.log('ADDI payload:', JSON.stringify(addiPayload));

      if (addiStoreSlug) {
        addiPayload.store = { slug: addiStoreSlug };
      }

      if (address) {
        addiPayload.pickUpAddress = {
          city: municipality || '',
          street: address,
        };
      }

      const appRes = await fetch(`${addiApiUrl}/v1/online-applications`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${addiToken}`,
        },
        body: JSON.stringify(addiPayload),
      });

      const appData: any = await appRes.json();

      if (!appRes.ok) {
        console.error('ADDI application error:', appData);
        res.status(502).json({ success: false, error: appData?.message || 'Error al crear aplicación de crédito en ADDI.' });
        return;
      }

      const applicationUrl = appData.applicationUrl || appData.url || appData.redirectUrl;
      if (!applicationUrl) {
        console.error('ADDI response missing URL:', appData);
        res.status(502).json({ success: false, error: 'ADDI no devolvió una URL de pago.' });
        return;
      }

      res.status(201).json({
        success: true,
        data: {
          orderId,
          orderNumber,
          total,
          applicationUrl,
        },
      });
    } catch (error) {
      console.error('ADDI application error:', error);
      res.status(500).json({ success: false, error: 'Error al crear la aplicación de crédito ADDI.' });
    }
  }
);

// =============================================
// PUBLIC: Crear solicitud de crédito con Sistecredito
// =============================================

// Helper: load Sistecredito pasarela credentials from env or platform_settings
// Based on G-ALI-08 / G-ALI-10 / G-ALI-12 documentation
async function loadSisteCredentials() {
  let vendorId = process.env.SISTECREDITO_VENDOR_ID || '';      // ApplicationToken
  let storeId = process.env.SISTECREDITO_STORE_ID || '';        // ApplicationKey
  let subscriptionKey = process.env.SISTECREDITO_SUBSCRIPTION_KEY || ''; // Ocp-Apim-Subscription-Key
  let isProduction = process.env.SISTECREDITO_ENV === 'production' || process.env.SISTECREDITO_PRODUCTION === 'true';

  if (!vendorId || !storeId || !subscriptionKey) {
    const [psRows] = await pool.query(
      "SELECT setting_key, setting_value FROM platform_settings WHERE setting_key IN ('sistecredito_vendor_id','sistecredito_store_id','sistecredito_subscription_key','sistecredito_production')"
    ) as any;
    for (const r of psRows) {
      if (r.setting_key === 'sistecredito_vendor_id') vendorId = r.setting_value || vendorId;
      if (r.setting_key === 'sistecredito_store_id') storeId = r.setting_value || storeId;
      if (r.setting_key === 'sistecredito_subscription_key') subscriptionKey = r.setting_value || subscriptionKey;
      if (r.setting_key === 'sistecredito_production') isProduction = r.setting_value === 'true';
    }
  }

  // Pasarela URL — same for both environments, ambiente controlled by SCOrigen header
  const baseUrl = 'https://api.credinet.co';
  const scOrigen = isProduction ? 'Production' : 'Staging';

  return { vendorId, storeId, subscriptionKey, isProduction, baseUrl, scOrigen };
}

// Helper: build pasarela headers (G-ALI-10)
function buildSisteHeaders(vendorId: string, storeId: string, subscriptionKey: string, scOrigen: string): Record<string, string> {
  return {
    'Content-Type': 'application/json',
    'SCLocation': '0,0',
    'SCOrigen': scOrigen,
    'country': 'co',
    'Ocp-Apim-Subscription-Key': subscriptionKey,
    'ApplicationKey': storeId,
    'ApplicationToken': vendorId,
  };
}

// Helper: poll GetTransactionResponse until paymentRedirectUrl is available (max ~15s)
async function pollSisteRedirectUrl(
  transactionId: string,
  headers: Record<string, string>,
  baseUrl: string
): Promise<string | null> {
  for (let i = 0; i < 12; i++) {
    await new Promise(r => setTimeout(r, 1500));
    try {
      const res = await fetch(`${baseUrl}/pay/GetTransactionResponse?transactionId=${transactionId}`, { headers });
      if (!res.ok) continue;
      const json: any = await res.json();
      const pmr = json?.data?.paymentMethodResponse;
      const url = pmr?.paymentRedirectUrl;
      const status = pmr?.statusResponse || json?.data?.transactionStatus;
      if (url && url.trim() !== '') return url;
      // If terminal failure, stop polling
      if (['Rejected', 'Cancelled', 'Expired', 'Abandoned', 'Failed'].includes(status)) return null;
    } catch { /* keep polling */ }
  }
  return null;
}

router.post(
  '/sistecredito-application',
  [
    body('customerName').notEmpty(),
    body('customerPhone').notEmpty(),
    body('customerEmail').optional().isEmail(),
    body('customerCedula').notEmpty().withMessage('La cédula es requerida para Sistecredito'),
    body('items').isArray({ min: 1 }),
    body('items.*.productId').notEmpty(),
    body('items.*.productName').notEmpty(),
    body('items.*.quantity').isInt({ min: 1 }),
    body('items.*.unitPrice').isFloat({ min: 0 }),
    validateRequest,
  ],
  async (req: Request, res: Response, _next: NextFunction) => {
    try {
      const { vendorId, storeId, subscriptionKey, baseUrl, scOrigen } = await loadSisteCredentials();

      if (!vendorId || !storeId || !subscriptionKey) {
        res.status(503).json({ success: false, error: 'Sistecredito no está configurado. Configúralo en el panel de administración.' });
        return;
      }

      const frontendUrl = config.mp.frontendUrl || process.env.FRONTEND_URL || 'http://localhost:3000';
      const backendUrl = process.env.BACKEND_URL || 'http://localhost:3001';

      const {
        customerName, customerPhone, customerEmail, customerCedula,
        department, municipality, address, notes,
        items, tenantId: requestedTenantId, couponCode, discount = 0,
      } = req.body;

      // Find tenant
      let tenantId = requestedTenantId;
      if (!tenantId) {
        const [tenants] = await pool.query(
          'SELECT id FROM tenants WHERE status = ? ORDER BY id ASC LIMIT 1',
          ['activo']
        ) as any;
        if (!tenants || tenants.length === 0) {
          res.status(400).json({ success: false, error: 'No hay tienda disponible' });
          return;
        }
        tenantId = tenants[0].id;
      }

      const subtotal = items.reduce((sum: number, item: any) => sum + (item.unitPrice * item.quantity), 0);
      const total = Math.round(Math.max(0, subtotal - discount));

      // Create order in DB
      const orderNumber = `PED-${Date.now().toString(36).toUpperCase()}`;
      const orderId = uuidv4();
      const couponNote = couponCode ? ` [Cupón: ${couponCode} - Desc: $${discount}]` : '';
      const finalNotes = `[PAGO SISTECREDITO] ${notes || ''}${couponNote}`.trim();

      await pool.query(
        `INSERT INTO storefront_orders
          (id, tenant_id, order_number, customer_name, customer_phone, customer_email, customer_cedula,
           department, municipality, address, notes, subtotal, shipping_cost, discount,
           total, payment_method, status)
         VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 0, ?, ?, 'sistecredito', 'pendiente')`,
        [orderId, tenantId, orderNumber, customerName, customerPhone, customerEmail || null, customerCedula || null,
          department || null, municipality || null, address || null, finalNotes,
          subtotal, discount, total]
      );

      for (const item of items) {
        await pool.query(
          `INSERT INTO storefront_order_items
            (order_id, product_id, product_name, product_image, quantity, unit_price, original_price, discount_percent, total_price)
           VALUES (?, ?, ?, ?, ?, ?, ?, 0, ?)`,
          [orderId, item.productId, item.productName, item.productImage || null,
            item.quantity, item.unitPrice, item.originalUnitPrice || item.unitPrice,
            item.unitPrice * item.quantity]
        );
      }

      // Build payload for pasarela (G-ALI-12 / G-ALI-10)
      // paymentMethodId=2 for Sistecredito in both Staging and Production
      const [nameParts] = [customerName.trim().split(' ')];
      const firstName = nameParts[0] || customerName;
      const lastName = nameParts.slice(1).join(' ') || '';

      const sistePayload: Record<string, any> = {
        invoice: orderNumber,
        description: `Compra ${orderNumber}`,
        paymentMethod: {
          paymentMethodId: 2,
          BankCode: 1,
          UserType: 0,
        },
        currency: 'COP',
        value: total,
        tax: 0,
        taxBase: total,
        sandbox: { isActive: false },
        urlResponse: `${frontendUrl}/?sistecredito=success&order=${orderId}`,
        urlConfirmation: `${backendUrl}/api/orders/sistecredito-webhook`,
        methodConfirmation: 'POST',
        client: {
          docType: 'CC',
          document: customerCedula,
          name: firstName,
          lastName: lastName,
          email: customerEmail || '',
          indCountry: '57',
          phone: customerPhone,
          country: 'CO',
          city: municipality || '',
          address: address || '',
          ipAddress: '0.0.0.0',
        },
      };

      const headers = buildSisteHeaders(vendorId, storeId, subscriptionKey, scOrigen);

      // Step 1: Create transaction (G-ALI-08)
      const createRes = await fetch(`${baseUrl}/pay/create`, {
        method: 'POST',
        headers,
        body: JSON.stringify(sistePayload),
      });

      const createData: any = await createRes.json();

      if (!createRes.ok || createData.errorCode !== 0) {
        console.error('Sistecredito create error:', createData);
        res.status(502).json({
          success: false,
          error: createData?.message || createData?.data?.description || 'Error al crear transacción en Sistecredito.',
        });
        return;
      }

      const transactionId: string = createData?.data?._id;
      if (!transactionId) {
        res.status(502).json({ success: false, error: 'Sistecredito no devolvió ID de transacción.' });
        return;
      }

      // Store transaction ID in order notes for webhook reconciliation
      await pool.query(
        "UPDATE storefront_orders SET notes = CONCAT(notes, ?) WHERE id = ?",
        [` [SC_TXN:${transactionId}]`, orderId]
      );

      // Check if redirect URL already available in create response
      let redirectUrl: string | null =
        createData?.data?.paymentMethodResponse?.paymentRedirectUrl || null;

      // Step 2: Poll GetTransactionResponse until URL is ready (G-ALI-08)
      if (!redirectUrl || redirectUrl.trim() === '') {
        redirectUrl = await pollSisteRedirectUrl(transactionId, headers, baseUrl);
      }

      if (!redirectUrl) {
        console.error('Sistecredito: no redirect URL after polling. transactionId:', transactionId);
        res.status(502).json({ success: false, error: 'Sistecredito no devolvió URL de pago. Intenta de nuevo.' });
        return;
      }

      res.status(201).json({
        success: true,
        data: { orderId, orderNumber, total, applicationUrl: redirectUrl },
      });
    } catch (error) {
      console.error('Sistecredito application error:', error);
      res.status(500).json({ success: false, error: 'Error al crear la solicitud de crédito con Sistecredito.' });
    }
  }
);

// =============================================
// PUBLIC: Webhook de MercadoPago
// =============================================
router.post('/mercadopago-webhook', async (req: Request, res: Response) => {
  try {
    // Load MP credentials from DB / env
    let mpToken = config.mp.accessToken;
    let mpWebhookSecret: string | null = null;
    const [psRows] = await pool.query(
      "SELECT setting_key, setting_value FROM platform_settings WHERE setting_key IN ('mp_access_token','mp_webhook_secret')"
    ) as any;
    for (const r of psRows) {
      if (r.setting_key === 'mp_access_token' && !mpToken) mpToken = r.setting_value;
      if (r.setting_key === 'mp_webhook_secret') mpWebhookSecret = r.setting_value;
    }

    // Verify MercadoPago HMAC-SHA256 signature
    // MP signature header format: "ts=<timestamp>,v1=<hmac>"
    if (mpWebhookSecret) {
      const sigHeader = req.headers['x-signature'] as string || '';
      const requestId = req.headers['x-request-id'] as string || '';
      const dataId = (req.query['data.id'] || req.body?.data?.id) as string || '';
      const tsMatch = sigHeader.match(/ts=([^,]+)/);
      const v1Match = sigHeader.match(/v1=([^,]+)/);

      if (!tsMatch || !v1Match) {
        audit.webhookInvalidSignature('mercadopago', req.ip);
        res.status(401).json({ error: 'Invalid signature' });
        return;
      }

      const ts = tsMatch[1];
      const receivedHmac = v1Match[1];
      const manifest = `id:${dataId};request-date:${ts};`;
      const expectedHmac = crypto
        .createHmac('sha256', mpWebhookSecret)
        .update(manifest)
        .digest('hex');

      if (!crypto.timingSafeEqual(Buffer.from(receivedHmac), Buffer.from(expectedHmac))) {
        audit.webhookInvalidSignature('mercadopago', req.ip);
        res.status(401).json({ error: 'Invalid signature' });
        return;
      }
    }

    const topic = req.query.topic || req.body?.type;
    const paymentId = req.query['data.id'] || req.body?.data?.id;

    if (!mpToken || !paymentId || (topic !== 'payment' && topic !== 'payment')) {
      res.status(200).json({ received: true });
      return;
    }

    // Fetch payment details from MP API
    const mpRes = await fetch(`https://api.mercadopago.com/v1/payments/${paymentId}`, {
      headers: { Authorization: `Bearer ${mpToken}` },
    });

    if (!mpRes.ok) {
      console.error('MP webhook: failed to fetch payment', paymentId);
      res.status(200).json({ received: true });
      return;
    }

    const payment = await mpRes.json() as any;
    const orderId = payment.external_reference;
    const mpStatus = (payment.status || '').toLowerCase();

    if (!orderId) {
      res.status(200).json({ received: true });
      return;
    }

    if (mpStatus === 'approved') {
      await pool.query(
        "UPDATE storefront_orders SET status = 'confirmado' WHERE id = ? AND status = 'pendiente'",
        [orderId]
      );
      console.log(`MP webhook: order ${orderId} confirmed (payment ${paymentId})`);
    } else if (mpStatus === 'rejected' || mpStatus === 'cancelled') {
      await pool.query(
        "UPDATE storefront_orders SET status = 'cancelado' WHERE id = ? AND status = 'pendiente'",
        [orderId]
      );
      console.log(`MP webhook: order ${orderId} cancelled (${mpStatus})`);
    }

    res.status(200).json({ received: true });
  } catch (error) {
    console.error('MP webhook error:', error);
    res.status(200).json({ received: true }); // always 200 to prevent MP retries
  }
});

// =============================================
// PUBLIC: Webhook de Sistecredito
// =============================================
// Sistecredito pasarela webhook (G-ALI-08 notificaciones)
// Receives POST with same structure as GetTransactionResponse
// Field: transactionStatus / invoice / _id
router.post('/sistecredito-webhook', async (req: Request, res: Response) => {
  try {
    // The pasarela sends body with transactionStatus, invoice, _id (G-ALI-08)
    const body = req.body;
    const transactionStatus: string = body?.transactionStatus || '';
    const invoice: string = body?.invoice || '';       // orderNumber
    const transactionId: string = body?._id || '';

    if (!invoice && !transactionId) {
      res.status(200).json({ received: true });
      return;
    }

    // Verify notification by querying the pasarela GET endpoint (anti-fraud, G-ALI-08)
    // Only verify if credentials are available — don't block if creds missing
    try {
      const { vendorId, storeId, subscriptionKey, baseUrl, scOrigen } = await loadSisteCredentials();
      if (vendorId && storeId && subscriptionKey && transactionId) {
        const headers = buildSisteHeaders(vendorId, storeId, subscriptionKey, scOrigen);
        const verifyRes = await fetch(`${baseUrl}/pay/GetTransactionResponse?transactionId=${transactionId}`, { headers });
        if (verifyRes.ok) {
          const verifyData: any = await verifyRes.json();
          const verifiedStatus: string = verifyData?.data?.transactionStatus || '';
          const verifiedInvoice: string = verifyData?.data?.invoice || '';
          // Cross-check key fields
          if (verifiedStatus && verifiedStatus !== transactionStatus) {
            console.warn(`Sistecredito webhook: status mismatch notif=${transactionStatus} verified=${verifiedStatus}`);
            res.status(200).json({ received: true });
            return;
          }
          if (verifiedInvoice && invoice && verifiedInvoice !== invoice) {
            console.warn(`Sistecredito webhook: invoice mismatch notif=${invoice} verified=${verifiedInvoice}`);
            res.status(200).json({ received: true });
            return;
          }
        }
      }
    } catch (verifyErr) {
      console.warn('Sistecredito webhook: could not verify with GET, proceeding:', verifyErr);
    }

    // Find order by invoice (orderNumber) or by SC_TXN tag in notes
    let orderRows: any[] = [];
    if (invoice) {
      const [rows] = await pool.query(
        "SELECT id, status FROM storefront_orders WHERE order_number = ? AND payment_method = 'sistecredito' LIMIT 1",
        [invoice]
      ) as any;
      orderRows = rows;
    }
    if ((!orderRows || orderRows.length === 0) && transactionId) {
      const [rows] = await pool.query(
        "SELECT id, status FROM storefront_orders WHERE notes LIKE ? AND payment_method = 'sistecredito' LIMIT 1",
        [`%SC_TXN:${transactionId}%`]
      ) as any;
      orderRows = rows;
    }

    if (!orderRows || orderRows.length === 0) {
      console.warn('Sistecredito webhook: order not found for invoice:', invoice, 'txn:', transactionId);
      res.status(200).json({ received: true });
      return;
    }

    const order = orderRows[0];

    if (transactionStatus === 'Approved' && order.status === 'pendiente') {
      await pool.query(
        "UPDATE storefront_orders SET status = 'confirmado' WHERE id = ?",
        [order.id]
      );
      console.log(`Sistecredito webhook: order ${order.id} confirmed (Approved)`);
    } else if (['Rejected', 'Cancelled', 'Expired', 'Abandoned', 'Failed'].includes(transactionStatus)) {
      await pool.query(
        "UPDATE storefront_orders SET status = 'cancelado' WHERE id = ? AND status = 'pendiente'",
        [order.id]
      );
      console.log(`Sistecredito webhook: order ${order.id} cancelled (${transactionStatus})`);
    }

    res.status(200).json({ received: true });
  } catch (error) {
    console.error('Sistecredito webhook error:', error);
    res.status(200).json({ received: true }); // always 200 to avoid pasarela retries
  }
});

// =============================================
// PUBLIC: Cancelar orden de pasarela abandonada
// =============================================
// Called by frontend when user returns with ?mp=failure or ?mp=pending without paying
router.put('/cancel-gateway/:orderId', async (req: Request, res: Response) => {
  try {
    const { orderId } = req.params;
    if (!orderId) {
      res.status(400).json({ success: false, error: 'orderId requerido' });
      return;
    }
    // Only cancel if the order is still pending (not yet paid/confirmed)
    await pool.query(
      "UPDATE storefront_orders SET status = 'cancelado' WHERE id = ? AND payment_method IN ('mercadopago', 'addi', 'sistecredito') AND status = 'pendiente'",
      [orderId]
    );
    res.json({ success: true });
  } catch (error) {
    console.error('Cancel gateway order error:', error);
    res.status(500).json({ success: false, error: 'Error al cancelar orden' });
  }
});

// =============================================
// AUTHENTICATED: Endpoints para comerciantes
// =============================================
router.use(authenticate);

// GET /api/orders — Listar pedidos del tenant
router.get(
  '/',
  [
    query('page').optional().isInt({ min: 1 }),
    query('limit').optional().isInt({ min: 1, max: 100 }),
    query('status').optional().notEmpty(),
    query('search').optional().notEmpty(),
    validateRequest,
  ],
  async (req: Request, res: Response, _next: NextFunction) => {
    try {
      const tenantId = (req as any).user.tenantId;
      const page = parseInt(req.query.page as string) || 1;
      const limit = parseInt(req.query.limit as string) || 20;
      const offset = (page - 1) * limit;
      const status = req.query.status as string | undefined;
      const search = req.query.search as string | undefined;

      let whereClause = 'WHERE o.tenant_id = ?';
      const params: any[] = [tenantId];

      if (status) {
        whereClause += ' AND o.status = ?';
        params.push(status);
      } else {
        // Exclude MP/ADDI/Sistecredito orders that are still 'pendiente' (user abandoned checkout without paying)
        whereClause += " AND NOT (o.payment_method IN ('mercadopago', 'addi', 'sistecredito') AND o.status = 'pendiente')";
      }

      if (search) {
        whereClause += ' AND (o.customer_name LIKE ? OR o.order_number LIKE ? OR o.customer_phone LIKE ?)';
        const searchTerm = `%${search}%`;
        params.push(searchTerm, searchTerm, searchTerm);
      }

      // Count
      const [countResult] = await pool.query(
        `SELECT COUNT(*) as total FROM storefront_orders o ${whereClause}`,
        params
      ) as any;
      const total = countResult[0].total;

      // Get orders
      const [orders] = await pool.query(
        `SELECT o.id, o.order_number as orderNumber, o.customer_name as customerName,
                o.customer_phone as customerPhone, o.customer_email as customerEmail,
                o.customer_cedula as customerCedula, o.department, o.municipality,
                o.address, o.neighborhood, o.delivery_latitude as deliveryLatitude,
                o.delivery_longitude as deliveryLongitude, o.notes, o.subtotal,
                o.shipping_cost as shippingCost, o.discount, o.total, o.status,
                o.payment_method as paymentMethod, o.delivery_driver_id as deliveryDriverId,
                o.delivery_status as deliveryStatus, d.name as driverName,
                o.created_at as createdAt, o.updated_at as updatedAt
         FROM storefront_orders o
         LEFT JOIN users d ON d.id = o.delivery_driver_id
         ${whereClause}
         ORDER BY o.created_at DESC
         LIMIT ? OFFSET ?`,
        [...params, limit, offset]
      ) as any;

      // Get items for each order
      for (const order of orders) {
        const [items] = await pool.query(
          `SELECT oi.id, oi.product_id as productId, oi.product_name as productName,
                  oi.product_image as productImage, oi.quantity, oi.unit_price as unitPrice,
                  oi.original_price as originalPrice, oi.discount_percent as discountPercent,
                  oi.total_price as totalPrice, oi.size, oi.color
           FROM storefront_order_items oi
           WHERE oi.order_id = ?`,
          [order.id]
        ) as any;
        order.items = items;
      }

      res.json({
        success: true,
        data: {
          orders,
          pagination: { total, page, limit, pages: Math.ceil(total / limit) }
        }
      });
    } catch (error) {
      console.error('Get orders error:', error);
      res.status(500).json({ success: false, error: 'Error al obtener pedidos' });
    }
  }
);

// GET /api/orders/stats — Estadísticas de pedidos
router.get('/stats', async (req: Request, res: Response) => {
  try {
    const tenantId = (req as any).user.tenantId;

    const [stats] = await pool.query(
      `SELECT
        COUNT(*) as totalOrders,
        SUM(CASE WHEN status = 'pendiente' THEN 1 ELSE 0 END) as pending,
        SUM(CASE WHEN status = 'confirmado' THEN 1 ELSE 0 END) as confirmed,
        SUM(CASE WHEN status = 'preparando' THEN 1 ELSE 0 END) as preparing,
        SUM(CASE WHEN status = 'enviado' THEN 1 ELSE 0 END) as shipped,
        SUM(CASE WHEN status = 'entregado' THEN 1 ELSE 0 END) as delivered,
        SUM(CASE WHEN status = 'cancelado' THEN 1 ELSE 0 END) as cancelled,
        SUM(CASE WHEN status != 'cancelado' THEN total ELSE 0 END) as totalRevenue
       FROM storefront_orders
       WHERE tenant_id = ?
         AND NOT (payment_method IN ('mercadopago', 'addi', 'sistecredito') AND status = 'pendiente')`,
      [tenantId]
    ) as any;

    res.json({ success: true, data: stats[0] });
  } catch (error) {
    console.error('Order stats error:', error);
    res.status(500).json({ success: false, error: 'Error al obtener estadísticas' });
  }
});

// GET /api/orders/:id — Detalle de un pedido
router.get('/:id', async (req: Request, res: Response) => {
  try {
    const tenantId = (req as any).user.tenantId;
    const orderId = req.params.id;

    const [orders] = await pool.query(
      `SELECT o.id, o.order_number as orderNumber, o.customer_name as customerName,
              o.customer_phone as customerPhone, o.customer_email as customerEmail,
              o.customer_cedula as customerCedula, o.department, o.municipality,
              o.address, o.neighborhood, o.notes, o.subtotal, o.shipping_cost as shippingCost,
              o.discount, o.total, o.status, o.payment_method as paymentMethod,
              o.created_at as createdAt, o.updated_at as updatedAt
       FROM storefront_orders o
       WHERE o.id = ? AND o.tenant_id = ?`,
      [orderId, tenantId]
    ) as any;

    if (orders.length === 0) {
      res.status(404).json({ success: false, error: 'Pedido no encontrado' });
      return;
    }

    const [items] = await pool.query(
      `SELECT oi.id, oi.product_id as productId, oi.product_name as productName,
              oi.product_image as productImage, oi.quantity, oi.unit_price as unitPrice,
              oi.total_price as totalPrice, oi.size, oi.color
       FROM storefront_order_items oi
       WHERE oi.order_id = ?`,
      [orderId]
    ) as any;

    res.json({ success: true, data: { ...orders[0], items } });
  } catch (error) {
    console.error('Get order error:', error);
    res.status(500).json({ success: false, error: 'Error al obtener pedido' });
  }
});

// PUT /api/orders/:id/status — Actualizar estado del pedido
router.put(
  '/:id/status',
  [
    param('id').notEmpty(),
    body('status').isIn(['pendiente', 'confirmado', 'preparando', 'enviado', 'entregado', 'cancelado'])
      .withMessage('Estado inválido'),
    validateRequest,
  ],
  async (req: Request, res: Response, _next: NextFunction) => {
    const connection = await pool.getConnection();
    try {
      await connection.beginTransaction();

      const tenantId = (req as any).user.tenantId;
      const userId = (req as any).user.id;
      const userName = (req as any).user.name || 'Sistema';
      const orderId = req.params.id;
      const { status } = req.body;

      // Get current order
      const [orderRows] = await connection.query(
        `SELECT o.*, o.order_number as orderNumber, o.customer_name as customerName,
                o.customer_phone as customerPhone, o.customer_email as customerEmail,
                o.customer_cedula as customerCedula
         FROM storefront_orders o
         WHERE o.id = ? AND o.tenant_id = ? FOR UPDATE`,
        [orderId, tenantId]
      ) as any;

      if (orderRows.length === 0) {
        await connection.rollback();
        res.status(404).json({ success: false, error: 'Pedido no encontrado' });
        return;
      }

      const order = orderRows[0];

      // Prevent re-delivering or re-cancelling
      if (order.status === 'entregado') {
        await connection.rollback();
        res.status(400).json({ success: false, error: 'El pedido ya fue entregado y facturado' });
        return;
      }
      if (order.status === 'cancelado') {
        await connection.rollback();
        res.status(400).json({ success: false, error: 'El pedido ya fue cancelado' });
        return;
      }

      // Update order status
      await connection.query(
        'UPDATE storefront_orders SET status = ? WHERE id = ?',
        [status, orderId]
      );

      let invoiceNumber: string | null = null;

      // ================================================================
      // When marked as "entregado" → Generate sale + deduct stock
      // ================================================================
      if (status === 'entregado') {
        // Get order items
        const [orderItems] = await connection.query(
          `SELECT oi.product_id as productId, oi.product_name as productName,
                  oi.quantity, oi.unit_price as unitPrice, oi.original_price as originalPrice,
                  oi.discount_percent as discountPercent, oi.total_price as totalPrice
           FROM storefront_order_items oi
           WHERE oi.order_id = ?`,
          [orderId]
        ) as any;

        // Generate invoice number
        const [seqRows] = await connection.query(
          'SELECT current_number, prefix FROM invoice_sequence WHERE tenant_id = ? FOR UPDATE',
          [tenantId]
        ) as any;

        let currentNumber = 0;
        let prefix = 'FAC';

        if (!seqRows || seqRows.length === 0) {
          // Initialize sequence if it doesn't exist
          await connection.query(
            "INSERT INTO invoice_sequence (tenant_id, prefix, current_number) VALUES (?, 'FAC', 0)",
            [tenantId]
          );
        } else {
          currentNumber = seqRows[0].current_number;
          prefix = seqRows[0].prefix || 'FAC';
        }

        currentNumber += 1;
        invoiceNumber = `${prefix}-${currentNumber.toString().padStart(5, '0')}`;

        await connection.query(
          'UPDATE invoice_sequence SET current_number = ? WHERE tenant_id = ?',
          [currentNumber, tenantId]
        );

        // Calculate totals
        const subtotal = orderItems.reduce((sum: number, item: any) => sum + Number(item.totalPrice), 0);
        const taxRate = 0.19;
        const tax = subtotal * taxRate;
        const total = subtotal + tax;

        // Check for active cash session
        const [activeSessionRows] = await connection.query(
          'SELECT id FROM cash_sessions WHERE status = ? AND tenant_id = ? LIMIT 1',
          ['abierta', tenantId]
        ) as any;
        const cashSessionId = activeSessionRows.length > 0 ? activeSessionRows[0].id : null;

        const saleId = uuidv4();

        // Insert sale
        await connection.query(
          `INSERT INTO sales (id, tenant_id, invoice_number, customer_id, customer_name, customer_phone, customer_email,
            subtotal, tax, discount, total, payment_method, amount_paid, change_amount, seller_id, seller_name, cash_session_id, notes, status)
           VALUES (?, ?, ?, NULL, ?, ?, ?, ?, ?, ?, ?, 'transferencia', ?, 0, ?, ?, ?, ?, 'completada')`,
          [
            saleId, tenantId, invoiceNumber,
            order.customer_name, order.customer_phone, order.customer_email,
            subtotal, tax, Number(order.discount) || 0, total,
            total, // amount_paid = total (paid in full)
            userId, userName, cashSessionId,
            `Pedido online ${order.order_number}`
          ]
        );

        // Insert sale items + deduct stock + register stock movements
        for (const item of orderItems) {
          const itemId = uuidv4();

          // Get product SKU and current stock
          let productSku = 'ONLINE';
          let previousStock = 0;
          if (item.productId) {
            const [prodRows] = await connection.query(
              'SELECT sku, stock FROM products WHERE id = ? FOR UPDATE',
              [item.productId]
            ) as any;
            if (prodRows.length > 0) {
              productSku = prodRows[0].sku;
              previousStock = prodRows[0].stock;

              // Deduct stock
              await connection.query(
                'UPDATE products SET stock = stock - ? WHERE id = ? AND tenant_id = ?',
                [item.quantity, item.productId, tenantId]
              );

              // Register stock movement
              await connection.query(
                `INSERT INTO stock_movements (id, tenant_id, product_id, type, quantity, previous_stock, new_stock, reason, reference_id, user_id)
                 VALUES (?, ?, ?, 'venta', ?, ?, ?, ?, ?, ?)`,
                [
                  uuidv4(), tenantId, item.productId,
                  item.quantity, previousStock, previousStock - item.quantity,
                  `Venta online ${invoiceNumber}`, saleId, userId
                ]
              );
            }
          }

          // Insert sale item (unit_price = precio original, discount = % descuento, subtotal = precio final * cantidad)
          const saleUnitPrice = item.originalPrice || item.unitPrice;
          const saleDiscount = item.discountPercent || 0;
          await connection.query(
            `INSERT INTO sale_items (id, tenant_id, sale_id, product_id, product_name, product_sku, quantity, unit_price, discount, subtotal)
             VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
            [itemId, tenantId, saleId, item.productId, item.productName, productSku, item.quantity, saleUnitPrice, saleDiscount, Number(item.totalPrice)]
          );
        }

        // Link order to the generated sale
        await connection.query(
          'UPDATE storefront_orders SET payment_method = ? WHERE id = ?',
          [`Factura: ${invoiceNumber}`, orderId]
        );
      }

      // ================================================================
      // When cancelled → restore stock if it was already deducted (entregado can't be cancelled above, so this handles other states)
      // ================================================================
      if (status === 'cancelado') {
        // No stock was deducted yet since stock only deducts on "entregado"
        // Just mark as cancelled — no stock changes needed
      }

      await connection.commit();

      res.json({
        success: true,
        data: {
          id: orderId,
          status,
          ...(invoiceNumber ? { invoiceNumber, message: `Factura ${invoiceNumber} generada y stock descontado` } : {})
        }
      });
    } catch (error) {
      await connection.rollback();
      console.error('Update order status error:', error);
      res.status(500).json({ success: false, error: 'Error al actualizar estado' });
    } finally {
      connection.release();
    }
  }
);

export const ordersRoutes = router;
