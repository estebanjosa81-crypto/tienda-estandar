import { Request, Response } from 'express';
import {
  getSyncStatus,
  runSync,
  resetSyncCursors,
  receiveSalesFromLocal,
  receivePurchasesFromLocal,
  receiveCustomersFromLocal,
  receiveProductsFromLocal,
  receiveMovementsFromLocal,
  receiveCashSessionsFromLocal,
  receiveCreditPaymentsFromLocal,
  receiveCategoriesFromLocal,
  receiveOrdersFromLocal,
  receiveRecipesFromLocal,
  receiveSuppliersFromLocal,
  getChangesSince,
} from './sync.service';
import { config } from '../../config/env';

/**
 * GET /api/sync/status
 * Devuelve el estado actual del servicio de sync.
 * Usado por el frontend para mostrar el indicador online/offline.
 */
export async function getStatus(req: Request, res: Response): Promise<void> {
  const status = getSyncStatus();
  res.json({ success: true, data: status });
}

/**
 * POST /api/sync/trigger
 * Dispara un ciclo de sync manualmente desde el frontend.
 */
export async function triggerSync(req: Request, res: Response): Promise<void> {
  try {
    const result = await runSync();
    const status = getSyncStatus();
    res.json({ success: true, data: { ...result, ...status } });
  } catch (err: any) {
    res.status(500).json({ success: false, error: err.message });
  }
}

/**
 * POST /api/sync/force-resync
 * Reinicia todos los cursores de pull a EPOCH y dispara un sync completo.
 * Útil para recuperar datos que no se descargaron (ventas, clientes, fiados, etc.)
 * Solo funciona en instancias locales (IS_LOCAL_INSTANCE=true).
 */
export async function forceResync(req: Request, res: Response): Promise<void> {
  try {
    resetSyncCursors();
    const result = await runSync();
    const status = getSyncStatus();
    res.json({ success: true, data: { ...result, ...status, message: 'Resync completo iniciado desde el principio del historial' } });
  } catch (err: any) {
    res.status(500).json({ success: false, error: err.message });
  }
}

/**
 * POST /api/sync/receive-sales
 * ENDPOINT DE LA NUBE: recibe ventas creadas offline desde el local.
 * Protegido con x-sync-secret header.
 */
export async function receiveSales(req: Request, res: Response): Promise<void> {
  const secret = req.headers['x-sync-secret'];
  if (!config.sync.secret || secret !== config.sync.secret) {
    res.status(401).json({ success: false, error: 'No autorizado' });
    return;
  }

  const { sales } = req.body;
  if (!Array.isArray(sales) || sales.length === 0) {
    res.status(400).json({ success: false, error: 'Sin datos' });
    return;
  }

  try {
    const result = await receiveSalesFromLocal(sales);
    res.json({ success: true, data: result });
  } catch (err: any) {
    console.error('[Sync] Error recibiendo ventas:', err);
    res.status(500).json({ success: false, error: err.message });
  }
}

// ─── Helpers para endpoints de recepción (NUBE) ──────────────────────────────

function requireSyncSecret(req: Request, res: Response): boolean {
  const secret = req.headers['x-sync-secret'];
  if (!config.sync.secret || secret !== config.sync.secret) {
    res.status(401).json({ success: false, error: 'No autorizado' });
    return false;
  }
  return true;
}

export async function receiveCustomers(req: Request, res: Response): Promise<void> {
  if (!requireSyncSecret(req, res)) return;
  const { customers } = req.body;
  if (!Array.isArray(customers) || customers.length === 0) {
    res.status(400).json({ success: false, error: 'Sin datos' }); return;
  }
  try {
    const result = await receiveCustomersFromLocal(customers);
    res.json({ success: true, data: result });
  } catch (err: any) {
    console.error('[Sync] Error recibiendo clientes:', err);
    res.status(500).json({ success: false, error: err.message });
  }
}

export async function receiveProducts(req: Request, res: Response): Promise<void> {
  if (!requireSyncSecret(req, res)) return;
  const { products } = req.body;
  if (!Array.isArray(products) || products.length === 0) {
    res.status(400).json({ success: false, error: 'Sin datos' }); return;
  }
  try {
    const result = await receiveProductsFromLocal(products);
    res.json({ success: true, data: result });
  } catch (err: any) {
    console.error('[Sync] Error recibiendo productos:', err);
    res.status(500).json({ success: false, error: err.message });
  }
}

export async function receiveMovements(req: Request, res: Response): Promise<void> {
  if (!requireSyncSecret(req, res)) return;
  const { movements } = req.body;
  if (!Array.isArray(movements) || movements.length === 0) {
    res.status(400).json({ success: false, error: 'Sin datos' }); return;
  }
  try {
    const result = await receiveMovementsFromLocal(movements);
    res.json({ success: true, data: result });
  } catch (err: any) {
    console.error('[Sync] Error recibiendo movimientos:', err);
    res.status(500).json({ success: false, error: err.message });
  }
}

export async function receiveCashSessions(req: Request, res: Response): Promise<void> {
  if (!requireSyncSecret(req, res)) return;
  const { sessions } = req.body;
  if (!Array.isArray(sessions) || sessions.length === 0) {
    res.status(400).json({ success: false, error: 'Sin datos' }); return;
  }
  try {
    const result = await receiveCashSessionsFromLocal(sessions);
    res.json({ success: true, data: result });
  } catch (err: any) {
    console.error('[Sync] Error recibiendo sesiones de caja:', err);
    res.status(500).json({ success: false, error: err.message });
  }
}

export async function receiveCreditPayments(req: Request, res: Response): Promise<void> {
  if (!requireSyncSecret(req, res)) return;
  const { payments } = req.body;
  if (!Array.isArray(payments) || payments.length === 0) {
    res.status(400).json({ success: false, error: 'Sin datos' }); return;
  }
  try {
    const result = await receiveCreditPaymentsFromLocal(payments);
    res.json({ success: true, data: result });
  } catch (err: any) {
    console.error('[Sync] Error recibiendo pagos de crédito:', err);
    res.status(500).json({ success: false, error: err.message });
  }
}

export async function receiveCategories(req: Request, res: Response): Promise<void> {
  if (!requireSyncSecret(req, res)) return;
  const { categories } = req.body;
  if (!Array.isArray(categories) || categories.length === 0) {
    res.status(400).json({ success: false, error: 'Sin datos' }); return;
  }
  try {
    const result = await receiveCategoriesFromLocal(categories);
    res.json({ success: true, data: result });
  } catch (err: any) {
    console.error('[Sync] Error recibiendo categorías:', err);
    res.status(500).json({ success: false, error: err.message });
  }
}

export async function receiveOrders(req: Request, res: Response): Promise<void> {
  if (!requireSyncSecret(req, res)) return;
  const { orders } = req.body;
  if (!Array.isArray(orders) || orders.length === 0) {
    res.status(400).json({ success: false, error: 'Sin datos' }); return;
  }
  try {
    const result = await receiveOrdersFromLocal(orders);
    res.json({ success: true, data: result });
  } catch (err: any) {
    console.error('[Sync] Error recibiendo pedidos:', err);
    res.status(500).json({ success: false, error: err.message });
  }
}

export async function receiveRecipes(req: Request, res: Response): Promise<void> {
  if (!requireSyncSecret(req, res)) return;
  const { recipes } = req.body;
  if (!Array.isArray(recipes) || recipes.length === 0) {
    res.status(400).json({ success: false, error: 'Sin datos' }); return;
  }
  try {
    const result = await receiveRecipesFromLocal(recipes);
    res.json({ success: true, data: result });
  } catch (err: any) {
    console.error('[Sync] Error recibiendo recetas:', err);
    res.status(500).json({ success: false, error: err.message });
  }
}

export async function receiveSuppliers(req: Request, res: Response): Promise<void> {
  if (!requireSyncSecret(req, res)) return;
  const { suppliers } = req.body;
  if (!Array.isArray(suppliers) || suppliers.length === 0) {
    res.status(400).json({ success: false, error: 'Sin datos' }); return;
  }
  try {
    const result = await receiveSuppliersFromLocal(suppliers);
    res.json({ success: true, data: result });
  } catch (err: any) {
    console.error('[Sync] Error recibiendo proveedores:', err);
    res.status(500).json({ success: false, error: err.message });
  }
}

/**
 * GET /api/sync/changes?since=ISO_TIMESTAMP&tenantId=UUID
 * ENDPOINT DE LA NUBE: retorna productos y clientes modificados desde `since`.
 * El local lo llama para hacer el PULL (bajar cambios de la nube).
 * Protegido con x-sync-secret header.
 */
export async function getChanges(req: Request, res: Response): Promise<void> {
  const secret = req.headers['x-sync-secret'];
  if (!config.sync.secret || secret !== config.sync.secret) {
    res.status(401).json({ success: false, error: 'No autorizado' });
    return;
  }

  const { tenantId, cursors: cursorsRaw, since } = req.query as {
    tenantId?: string; cursors?: string; since?: string;
  };
  if (!tenantId) {
    res.status(400).json({ success: false, error: 'Parámetro tenantId requerido' });
    return;
  }

  // Compatibilidad: si viene el formato viejo (since=...) lo convertimos
  let parsedCursors: Record<string, { since: string; afterId: string }> = {};
  if (cursorsRaw) {
    try { parsedCursors = JSON.parse(cursorsRaw); } catch {
      res.status(400).json({ success: false, error: 'Formato de cursors inválido (JSON)' });
      return;
    }
  } else if (since) {
    // Formato legado: un solo cursor para todos
    parsedCursors = Object.fromEntries(
      ['products','customers','sales','purchases','movements','cashSessions','creditPayments','categories']
        .map((e) => [e, { since, afterId: '' }])
    );
  } else {
    res.status(400).json({ success: false, error: 'Se requiere cursors o since' });
    return;
  }

  try {
    const data = await getChangesSince(tenantId, parsedCursors);
    res.json({ success: true, ...data });
  } catch (err: any) {
    console.error('[Sync] Error en GET /changes:', err);
    res.status(500).json({ success: false, error: err.message });
  }
}

/**
 * POST /api/sync/receive-purchases
 * ENDPOINT DE LA NUBE: recibe compras creadas offline desde el local.
 * Protegido con x-sync-secret header.
 */
export async function receivePurchases(req: Request, res: Response): Promise<void> {
  const secret = req.headers['x-sync-secret'];
  if (!config.sync.secret || secret !== config.sync.secret) {
    res.status(401).json({ success: false, error: 'No autorizado' });
    return;
  }

  const { purchases } = req.body;
  if (!Array.isArray(purchases) || purchases.length === 0) {
    res.status(400).json({ success: false, error: 'Sin datos' });
    return;
  }

  try {
    const result = await receivePurchasesFromLocal(purchases);
    res.json({ success: true, data: result });
  } catch (err: any) {
    console.error('[Sync] Error recibiendo compras:', err);
    res.status(500).json({ success: false, error: err.message });
  }
}
