-- ============================================================
-- LIMPIEZA TRANSACCIONAL: Perfum Mua
-- Tenant: d46bec36-5259-4b5b-83c7-01f1e6ea5dcd
--
-- Elimina TODO el historial de ventas, caja, créditos,
-- movimientos de stock, pedidos online y productos.
-- NO toca: categorías, clientes, usuarios.
-- ============================================================

USE stockpro_db;

SET @tid = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' COLLATE utf8mb4_unicode_ci;

START TRANSACTION;

-- ============================================================
-- 1. VENTAS
-- ============================================================

-- Items de venta (FK → sales, products)
DELETE FROM sale_items
WHERE tenant_id = @tid;

-- Pagos de crédito (FK → sales)
DELETE FROM credit_payments
WHERE tenant_id = @tid;

-- Ventas (cabecera)
DELETE FROM sales
WHERE tenant_id = @tid;

-- ============================================================
-- 2. CAJA / SESIONES
-- ============================================================

-- Movimientos de caja (tiene tenant_id propio)
DELETE FROM cash_movements
WHERE tenant_id = @tid;

-- Sesiones de caja
DELETE FROM cash_sessions
WHERE tenant_id = @tid;

-- ============================================================
-- 3. STOCK — movimientos históricos
-- ============================================================

DELETE FROM stock_movements
WHERE tenant_id = @tid;

-- ============================================================
-- 4. PEDIDOS ONLINE (storefront)
-- ============================================================

-- Items de pedidos (no tiene tenant_id — se filtra por order_id)
DELETE FROM storefront_order_items
WHERE order_id IN (
    SELECT id FROM storefront_orders WHERE tenant_id = @tid
);

-- Pedidos online (cabecera)
DELETE FROM storefront_orders
WHERE tenant_id = @tid;

-- ============================================================
-- 5. NOTIFICACIONES generadas por ventas/pedidos
-- ============================================================

DELETE FROM merchant_notifications
WHERE tenant_id = @tid;

-- ============================================================
-- 6. SECUENCIAS — reiniciar contadores de facturas
-- ============================================================

UPDATE invoice_sequence
SET current_number = 0
WHERE tenant_id = @tid;

UPDATE payment_receipt_sequence
SET current_number = 0
WHERE tenant_id = @tid;

-- ============================================================
-- 7. PRODUCTOS (sin tocar categorías)
-- ============================================================

-- Recetas BOM (evita FK RESTRICT por ingredient_id)
DELETE FROM product_recipes
WHERE tenant_id = @tid;

-- Items de compras (evita FK RESTRICT en productos)
DELETE FROM purchase_invoice_items
WHERE tenant_id = @tid;

-- Productos
DELETE FROM products
WHERE tenant_id = @tid;

COMMIT;

-- ============================================================
-- VERIFICACIÓN — todo debe mostrar 0
-- ============================================================

SELECT
    (SELECT COUNT(*) FROM sales                  WHERE tenant_id = @tid) AS ventas,
    (SELECT COUNT(*) FROM sale_items             WHERE tenant_id = @tid) AS items_venta,
    (SELECT COUNT(*) FROM credit_payments        WHERE tenant_id = @tid) AS pagos_credito,
    (SELECT COUNT(*) FROM cash_sessions          WHERE tenant_id = @tid) AS sesiones_caja,
    (SELECT COUNT(*) FROM cash_movements         WHERE tenant_id = @tid) AS movimientos_caja,
    (SELECT COUNT(*) FROM stock_movements        WHERE tenant_id = @tid) AS movimientos_stock,
    (SELECT COUNT(*) FROM storefront_orders      WHERE tenant_id = @tid) AS pedidos_online,
    (SELECT COUNT(*) FROM merchant_notifications WHERE tenant_id = @tid) AS notificaciones,
    (SELECT COUNT(*) FROM products               WHERE tenant_id = @tid) AS productos;

SELECT CONCAT('Limpieza completada para tenant: ', @tid) AS RESULTADO;

-- ============================================================
-- OPCIONAL: limpiar clientes (descomentar si se necesita)
-- ============================================================
-- DELETE FROM customers WHERE tenant_id = @tid;
