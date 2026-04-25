-- ============================================================
-- Migración 004: Reserva de inventario y soporte de reembolsos
-- Segura para re-ejecutar — cada paso verifica si ya existe.
-- Compatible con MySQL 5.7+ y 8.0+
-- ============================================================
USE stockpro_db;

SET @db = DATABASE();

-- ------------------------------------------------------------
-- 1. Tabla: inventory_holds
--    Reserva temporal de stock durante el proceso de checkout.
--    Se elimina cuando la orden se confirma, entrega o cancela.
--    expires_at es red de seguridad: el scheduler la usa para
--    limpiar holds huérfanos si la lógica de negocio falla.
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS inventory_holds (
  id         VARCHAR(36)  NOT NULL,
  order_id   VARCHAR(36)  NOT NULL,
  product_id VARCHAR(36)  NOT NULL,
  tenant_id  VARCHAR(36)  NOT NULL,
  quantity   INT          NOT NULL,
  expires_at TIMESTAMP    NOT NULL,
  created_at TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  INDEX idx_holds_product (product_id),
  INDEX idx_holds_order   (order_id),
  INDEX idx_holds_tenant  (tenant_id),
  INDEX idx_holds_expires (expires_at),
  CONSTRAINT fk_holds_order FOREIGN KEY (order_id)
    REFERENCES storefront_orders(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------
-- 2. Columna: storefront_orders.gateway_payment_id
--    Almacena el ID de pago de la pasarela para poder ejecutar
--    reembolsos programáticos desde el panel de administración.
--    MP: payment_id numérico · Addi: orderId · Siste: _id
-- ------------------------------------------------------------
SET @sql = (SELECT IF(
  (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
   WHERE TABLE_SCHEMA = @db
     AND TABLE_NAME   = 'storefront_orders'
     AND COLUMN_NAME  = 'gateway_payment_id') = 0,
  'ALTER TABLE `storefront_orders` ADD COLUMN `gateway_payment_id` VARCHAR(255) NULL COMMENT ''ID del pago en la pasarela para reembolsos (MP payment_id, Addi orderId, Siste _id)''',
  'SELECT ''[skip] storefront_orders.gateway_payment_id ya existe'''
));
PREPARE _s FROM @sql; EXECUTE _s; DEALLOCATE PREPARE _s;

-- ------------------------------------------------------------
-- 3. Columna: storefront_orders.refund_status
--    Registra el estado del reembolso para trazabilidad.
--    NULL = sin reembolso · 'pending' · 'refunded' · 'manual'
-- ------------------------------------------------------------
SET @sql = (SELECT IF(
  (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
   WHERE TABLE_SCHEMA = @db
     AND TABLE_NAME   = 'storefront_orders'
     AND COLUMN_NAME  = 'refund_status') = 0,
  'ALTER TABLE `storefront_orders` ADD COLUMN `refund_status` VARCHAR(20) NULL COMMENT ''Estado del reembolso: NULL, pending, refunded, manual''',
  'SELECT ''[skip] storefront_orders.refund_status ya existe'''
));
PREPARE _s FROM @sql; EXECUTE _s; DEALLOCATE PREPARE _s;

-- ------------------------------------------------------------
-- FIN Migración 004
-- ------------------------------------------------------------
