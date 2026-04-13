-- ============================================================
-- Migración: mejoras en facturas de compra
-- 1. sale_price en purchase_invoice_items (para mostrar precio de venta al momento de la compra)
-- 2. mixed_efectivo_amount y mixed_transferencia_amount en purchase_invoices (desglose pago mixto)
-- Segura para re-ejecutar
-- ============================================================

USE stockpro_db;

SET @db = DATABASE();

-- 1. Agregar sale_price a purchase_invoice_items
SET @col1 = (
  SELECT COUNT(*) FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = @db AND TABLE_NAME = 'purchase_invoice_items' AND COLUMN_NAME = 'sale_price'
);
SET @sql1 = IF(@col1 = 0,
  'ALTER TABLE purchase_invoice_items ADD COLUMN sale_price DECIMAL(12,2) NULL AFTER unit_cost',
  'SELECT "sale_price ya existe en purchase_invoice_items"'
);
PREPARE stmt FROM @sql1; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- 2. Agregar mixed_efectivo_amount a purchase_invoices
SET @col2 = (
  SELECT COUNT(*) FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = @db AND TABLE_NAME = 'purchase_invoices' AND COLUMN_NAME = 'mixed_efectivo_amount'
);
SET @sql2 = IF(@col2 = 0,
  'ALTER TABLE purchase_invoices ADD COLUMN mixed_efectivo_amount DECIMAL(12,2) NULL AFTER payment_method',
  'SELECT "mixed_efectivo_amount ya existe en purchase_invoices"'
);
PREPARE stmt FROM @sql2; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- 3. Agregar mixed_transferencia_amount a purchase_invoices
SET @col3 = (
  SELECT COUNT(*) FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = @db AND TABLE_NAME = 'purchase_invoices' AND COLUMN_NAME = 'mixed_transferencia_amount'
);
SET @sql3 = IF(@col3 = 0,
  'ALTER TABLE purchase_invoices ADD COLUMN mixed_transferencia_amount DECIMAL(12,2) NULL AFTER mixed_efectivo_amount',
  'SELECT "mixed_transferencia_amount ya existe en purchase_invoices"'
);
PREPARE stmt FROM @sql3; EXECUTE stmt; DEALLOCATE PREPARE stmt;
