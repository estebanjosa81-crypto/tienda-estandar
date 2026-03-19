-- ============================================================
-- RESET COMPLETO: Perfum Mua
-- Tenant: d46bec36-5259-4b5b-83c7-01f1e6ea5dcd
-- Elimina todos los datos del tenant en orden correcto
-- (respeta restricciones FK RESTRICT)
-- Luego re-ejecutar:
--   1. inventario_perfummua.sql
--   2. recetasperfummua.sql
-- ============================================================

USE stockpro_db;

SET @tid = 'tenant-demo-001' COLLATE utf8mb4_unicode_ci;

START TRANSACTION;

-- 1) Recetas BOM (ingredient_id → products: RESTRICT, va primero)
DELETE FROM product_recipes
WHERE tenant_id = @tid;

-- 2) Items de ventas (product_id → products: RESTRICT)
DELETE FROM sale_items
WHERE tenant_id = @tid;

-- 3) Items de facturas de compra (product_id → products: RESTRICT)
DELETE FROM purchase_invoice_items
WHERE tenant_id = @tid;

-- 4) Productos (sin dependencias bloqueantes ya)
DELETE FROM products
WHERE tenant_id = @tid;

-- 5) Categorías
DELETE FROM categories
WHERE tenant_id = @tid;

COMMIT;

SELECT CONCAT('Reset completado para tenant: ', @tid) AS RESULTADO;
