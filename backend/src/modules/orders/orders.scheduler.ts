import pool from '../../config/database';

const GATEWAY_METHODS = ['mercadopago', 'addi', 'sistecredito'];
const EXPIRY_HOURS = 3;
const INTERVAL_MS = 60 * 60 * 1000; // 1 hora

let schedulerTimer: ReturnType<typeof setInterval> | null = null;

async function expireAbandonedOrders(): Promise<void> {
  try {
    // Get IDs first so we can release holds
    const [rows]: any = await pool.query(
      `SELECT id FROM storefront_orders
       WHERE status = 'pendiente'
         AND payment_method IN (${GATEWAY_METHODS.map(() => '?').join(',')})
         AND created_at < NOW() - INTERVAL ? HOUR`,
      [...GATEWAY_METHODS, EXPIRY_HOURS]
    );

    if (!rows || rows.length === 0) return;

    const ids: string[] = rows.map((r: any) => r.id);

    // Cancel orders
    const [result]: any = await pool.query(
      `UPDATE storefront_orders
       SET status = 'cancelado',
           notes  = CONCAT(IFNULL(notes, ''), ' | Cancelado automáticamente por abandono de pasarela de pago')
       WHERE id IN (${ids.map(() => '?').join(',')})`,
      ids
    );

    // Release inventory holds (ON DELETE CASCADE also handles this, but explicit is safer)
    if (ids.length > 0) {
      await pool.query(
        `DELETE FROM inventory_holds WHERE order_id IN (${ids.map(() => '?').join(',')})`,
        ids
      );
    }

    const affected: number = result?.affectedRows ?? 0;
    if (affected > 0) {
      console.log(`[OrdersScheduler] ${affected} pedido(s) abandonado(s) cancelado(s) y hold(s) liberado(s) (>${EXPIRY_HOURS}h pendiente)`);
    }
  } catch (err) {
    console.error('[OrdersScheduler] Error al expirar pedidos abandonados:', err);
  }
}

async function cleanupExpiredHolds(): Promise<void> {
  try {
    const [result]: any = await pool.query(
      `DELETE FROM inventory_holds WHERE expires_at < NOW()`
    );
    const affected: number = result?.affectedRows ?? 0;
    if (affected > 0) {
      console.log(`[OrdersScheduler] ${affected} hold(s) expirado(s) limpiado(s)`);
    }
  } catch (err) {
    console.error('[OrdersScheduler] Error al limpiar holds expirados:', err);
  }
}

export function startOrdersScheduler(): void {
  console.log(`[OrdersScheduler] Iniciado — limpieza de pedidos abandonados cada ${INTERVAL_MS / 3_600_000}h`);

  // Ejecutar al arrancar para limpiar cualquier acumulado previo
  expireAbandonedOrders();
  cleanupExpiredHolds();

  schedulerTimer = setInterval(() => {
    expireAbandonedOrders();
    cleanupExpiredHolds();
  }, INTERVAL_MS);
}

export function stopOrdersScheduler(): void {
  if (schedulerTimer) {
    clearInterval(schedulerTimer);
    schedulerTimer = null;
  }
}
