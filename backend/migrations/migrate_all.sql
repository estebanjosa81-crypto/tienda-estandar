-- ============================================================
-- Migración consolidada — stockpro_db
-- Segura para re-ejecutar: cada paso verifica si ya existe
-- antes de aplicar el cambio.
-- Compatible con MySQL 5.7+ y 8.0+
-- ============================================================
USE stockpro_db;

SET @db = DATABASE();

-- ------------------------------------------------------------
-- 1. Tabla: sedes
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS sedes (
  id VARCHAR(36) PRIMARY KEY,
  tenant_id VARCHAR(36) NOT NULL,
  name VARCHAR(100) NOT NULL,
  address VARCHAR(500) NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (tenant_id) REFERENCES tenants(id) ON DELETE CASCADE,
  INDEX idx_sedes_tenant (tenant_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------
-- 2. Tabla: printers
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS printers (
  id VARCHAR(36) PRIMARY KEY,
  tenant_id VARCHAR(36) NOT NULL,
  name VARCHAR(100) NOT NULL,
  connection_type ENUM('lan','usb','bluetooth') NOT NULL DEFAULT 'lan',
  ip VARCHAR(45) NULL,
  port INT NOT NULL DEFAULT 9100,
  paper_width SMALLINT NOT NULL DEFAULT 80,
  is_active TINYINT(1) NOT NULL DEFAULT 1,
  assigned_module ENUM('caja','cocina','bar','factura') NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (tenant_id) REFERENCES tenants(id) ON DELETE CASCADE,
  INDEX idx_printers_tenant (tenant_id),
  INDEX idx_printers_module (tenant_id, assigned_module)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------
-- 3. Columna: employee_cargos.permissions
-- ------------------------------------------------------------
SET @sql = (SELECT IF(
  (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
   WHERE TABLE_SCHEMA = @db AND TABLE_NAME = 'employee_cargos' AND COLUMN_NAME = 'permissions') = 0,
  'ALTER TABLE `employee_cargos` ADD COLUMN `permissions` JSON NULL COMMENT ''Permisos granulares del cargo: ["ventas","inventario",...]''',
  'SELECT ''[skip] employee_cargos.permissions ya existe'''
));
PREPARE _s FROM @sql; EXECUTE _s; DEALLOCATE PREPARE _s;

-- ------------------------------------------------------------
-- 4. Columna: store_info.product_card_style
-- ------------------------------------------------------------
SET @sql = (SELECT IF(
  (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
   WHERE TABLE_SCHEMA = @db AND TABLE_NAME = 'store_info' AND COLUMN_NAME = 'product_card_style') = 0,
  'ALTER TABLE `store_info` ADD COLUMN `product_card_style` VARCHAR(20) NULL DEFAULT ''style1'' COMMENT ''Estilo de tarjeta de producto: style1 o style2''',
  'SELECT ''[skip] store_info.product_card_style ya existe'''
));
PREPARE _s FROM @sql; EXECUTE _s; DEALLOCATE PREPARE _s;

-- ------------------------------------------------------------
-- 5. Columna: store_info.allow_contraentrega
-- ------------------------------------------------------------
SET @sql = (SELECT IF(
  (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
   WHERE TABLE_SCHEMA = @db AND TABLE_NAME = 'store_info' AND COLUMN_NAME = 'allow_contraentrega') = 0,
  'ALTER TABLE `store_info` ADD COLUMN `allow_contraentrega` TINYINT(1) NOT NULL DEFAULT 1 COMMENT ''1 = permite pago contraentrega en checkout, 0 = solo métodos en línea''',
  'SELECT ''[skip] store_info.allow_contraentrega ya existe'''
));
PREPARE _s FROM @sql; EXECUTE _s; DEALLOCATE PREPARE _s;

-- ------------------------------------------------------------
-- 6. Columna: store_info.online_discount_enabled
-- ------------------------------------------------------------
SET @sql = (SELECT IF(
  (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
   WHERE TABLE_SCHEMA = @db AND TABLE_NAME = 'store_info' AND COLUMN_NAME = 'online_discount_enabled') = 0,
  'ALTER TABLE `store_info` ADD COLUMN `online_discount_enabled` TINYINT(1) NOT NULL DEFAULT 0 COMMENT ''1 = descuento activo para pagos en línea''',
  'SELECT ''[skip] store_info.online_discount_enabled ya existe'''
));
PREPARE _s FROM @sql; EXECUTE _s; DEALLOCATE PREPARE _s;

-- ------------------------------------------------------------
-- 7. Columna: products.sede_id
-- ------------------------------------------------------------
SET @sql = (SELECT IF(
  (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
   WHERE TABLE_SCHEMA = @db AND TABLE_NAME = 'products' AND COLUMN_NAME = 'sede_id') = 0,
  'ALTER TABLE `products` ADD COLUMN `sede_id` VARCHAR(36) NULL COMMENT ''Sede a la que pertenece el producto (NULL = todas las sedes)''',
  'SELECT ''[skip] products.sede_id ya existe'''
));
PREPARE _s FROM @sql; EXECUTE _s; DEALLOCATE PREPARE _s;

-- ------------------------------------------------------------
-- 8. Columna: sales.sede_id
-- ------------------------------------------------------------
SET @sql = (SELECT IF(
  (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
   WHERE TABLE_SCHEMA = @db AND TABLE_NAME = 'sales' AND COLUMN_NAME = 'sede_id') = 0,
  'ALTER TABLE `sales` ADD COLUMN `sede_id` VARCHAR(36) NULL DEFAULT NULL',
  'SELECT ''[skip] sales.sede_id ya existe'''
));
PREPARE _s FROM @sql; EXECUTE _s; DEALLOCATE PREPARE _s;

-- ------------------------------------------------------------
-- 9. Índice: sales.idx_sales_sede_id
-- ------------------------------------------------------------
SET @sql = IF(
  (SELECT COUNT(*) FROM INFORMATION_SCHEMA.STATISTICS
   WHERE TABLE_SCHEMA = @db AND TABLE_NAME = 'sales' AND INDEX_NAME = 'idx_sales_sede_id') = 0,
  'CREATE INDEX idx_sales_sede_id ON sales(sede_id)',
  'SELECT ''[skip] índice idx_sales_sede_id ya existe'''
);
PREPARE _s FROM @sql; EXECUTE _s; DEALLOCATE PREPARE _s;

-- ------------------------------------------------------------
-- 10. Columna: users.data_encrypted
-- ------------------------------------------------------------
SET @sql = (SELECT IF(
  (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
   WHERE TABLE_SCHEMA = @db AND TABLE_NAME = 'users' AND COLUMN_NAME = 'data_encrypted') = 0,
  'ALTER TABLE `users` ADD COLUMN `data_encrypted` TINYINT(1) NOT NULL DEFAULT 0 COMMENT ''1 = campos sensibles cifrados con AES-256''',
  'SELECT ''[skip] users.data_encrypted ya existe'''
));
PREPARE _s FROM @sql; EXECUTE _s; DEALLOCATE PREPARE _s;

-- ============================================================
-- Migración 004: Reserva de inventario y soporte de reembolsos
-- ============================================================

-- ------------------------------------------------------------
-- 11. Tabla: inventory_holds
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
-- 12. Columna: storefront_orders.gateway_payment_id
-- ------------------------------------------------------------
SET @sql = (SELECT IF(
  (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
   WHERE TABLE_SCHEMA = @db AND TABLE_NAME = 'storefront_orders' AND COLUMN_NAME = 'gateway_payment_id') = 0,
  'ALTER TABLE `storefront_orders` ADD COLUMN `gateway_payment_id` VARCHAR(255) NULL COMMENT ''ID del pago en pasarela para reembolsos''',
  'SELECT ''[skip] storefront_orders.gateway_payment_id ya existe'''
));
PREPARE _s FROM @sql; EXECUTE _s; DEALLOCATE PREPARE _s;

-- ------------------------------------------------------------
-- 13. Columna: storefront_orders.refund_status
-- ------------------------------------------------------------
SET @sql = (SELECT IF(
  (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
   WHERE TABLE_SCHEMA = @db AND TABLE_NAME = 'storefront_orders' AND COLUMN_NAME = 'refund_status') = 0,
  'ALTER TABLE `storefront_orders` ADD COLUMN `refund_status` VARCHAR(20) NULL COMMENT ''Estado del reembolso: NULL, pending, refunded, manual''',
  'SELECT ''[skip] storefront_orders.refund_status ya existe'''
));
PREPARE _s FROM @sql; EXECUTE _s; DEALLOCATE PREPARE _s;
