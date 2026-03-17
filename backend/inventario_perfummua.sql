USE stockpro_db;

-- ============================================================
-- LIMPIEZA PREVIA (idempotente — elimina datos del tenant)
-- ============================================================
SET @tid = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' COLLATE utf8mb4_unicode_ci;

DELETE FROM product_recipes        WHERE tenant_id = @tid;
DELETE FROM sale_items             WHERE tenant_id = @tid;
DELETE FROM purchase_invoice_items WHERE tenant_id = @tid;
DELETE FROM products               WHERE tenant_id = @tid;
DELETE FROM categories             WHERE tenant_id = @tid;

-- Asegurar que el ENUM de product_type incluye todos los valores necesarios
ALTER TABLE products MODIFY COLUMN product_type ENUM(
    'general', 'alimentos', 'bebidas', 'ropa', 'electronica',
    'farmacia', 'ferreteria', 'libreria', 'juguetes', 'cosmetica',
    'perfumes', 'deportes', 'hogar', 'mascotas', 'otros', 'insumos'
) NOT NULL DEFAULT 'general';

-- ============================================================
-- SEDES
-- ============================================================
INSERT INTO sedes (id, tenant_id, name, address) VALUES
('sede-pm-1', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'Sede 1', NULL),
('sede-pm-2', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'Sede 2', NULL)
ON DUPLICATE KEY UPDATE name = VALUES(name);

-- ============================================================
-- CATEGORÍAS
-- ============================================================
INSERT INTO categories (id, tenant_id, name, description) VALUES
('CABALLEROS',  'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'Caballeros',  'Perfumes y productos masculinos'),
('DAMAS',       'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'Damas',       'Perfumes y productos femeninos'),
('UNISEX',      'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'Unisex',      'Perfumes y productos unisex'),
('INFANTIL',    'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'Infantil',    'Productos para niños y niñas'),
('CREMAS',      'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'Cremas',      'Cremas corporales y productos de cuidado'),
('CORPORAL',    'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'Corporal',    'Productos corporales (cremas, splashes, shimmer, mantequillas)'),
('HOGAR',       'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'Hogar',       'Productos para el hogar y ambientación'),
('INSUMOS',     'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'Insumos',     'Insumos, envases y materiales'),
('EXTRACTOS',   'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'Extractos',   'Extractos de perfume — se venden por receta'),
('PERFUMERIA',  'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'Perfumería',  'Perfumes originales y réplicas')
ON DUPLICATE KEY UPDATE name = VALUES(name);

-- ============================================================
-- PRODUCTOS SEDE 1
-- ============================================================

-- SEDE 1 — CORPORAL (169 filas)
INSERT INTO products (id, tenant_id, name, articulo, category, product_type, sku, stock, reorder_point, entry_date, purchase_price, sale_price, presentation, notes, sede_id) VALUES
('prod-pm-390', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'FEROMONAS', 'FEROMONAS', 'CREMAS', 'cosmetica', 'PM-390', 5, 0, '2026-03-16', 4000, 10000, NULL, 'Código: 390', 'sede-pm-1'),
('prod-pm-391', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'MUSK TAHARA', 'MUSK TAHARA', 'CREMAS', 'cosmetica', 'PM-391', 21, 0, '2026-03-16', 2600, 8000, NULL, 'Código: 391', 'sede-pm-1'),
('prod-pm-s1-620', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'VAINILLA CAKE', 'PURPURE-KITS-VAINILLA CAKE', 'CREMAS', 'cosmetica', 'PM-S1-620', 0, 0, '2026-03-16', 18410, 32000, NULL, 'Código: 620', 'sede-pm-1'),
('prod-pm-500', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'SATINADA BRILLO', 'CREMA-SATINADA BRILLO', 'CREMAS', 'cosmetica', 'PM-500', 4, 0, '2026-03-16', 14500, 24000, NULL, 'Código: 500', 'sede-pm-1'),
('prod-pm-1089', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'INEBRIANTE', 'ORI-CREMA INEBRIANTE-FEM', 'DAMAS', 'cosmetica', 'PM-1089', 1, 0, '2026-03-16', 49500, 99900, NULL, 'Código: 1089', 'sede-pm-1'),
('prod-pm-1090', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'STRAX', 'ORI-CREMA STRAX-UNI', 'UNISEX', 'cosmetica', 'PM-1090', 2, 0, '2026-03-16', 26500, 53000, NULL, 'Código: 1090', 'sede-pm-1'),
('prod-pm-437', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'AMBER APERITIF', 'ORI-VS CREMA AMBER APERITIF-FEM', 'DAMAS', 'cosmetica', 'PM-437', 1, 0, '2026-03-16', 48721, 110000, NULL, 'Código: 437', 'sede-pm-1'),
('prod-pm-414', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'AMBER ROMANCE', 'ORI-VS CREMA AMBER ROMANCE-FEM', 'DAMAS', 'cosmetica', 'PM-414', 1, 0, '2026-03-16', 57000, 110000, NULL, 'Código: 414', 'sede-pm-1'),
('prod-pm-415', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'AQUA KISS', 'ORI-VS CREMA AQUA KISS-FEM', 'DAMAS', 'cosmetica', 'PM-415', 0, 0, '2026-03-16', 58000, 110000, NULL, 'Código: 415', 'sede-pm-1'),
('prod-pm-412', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'BARE VAINILLA', 'ORI-VS CREMA BARE VAINILLA-FEM', 'DAMAS', 'cosmetica', 'PM-412', 3, 0, '2026-03-16', 58000, 110000, NULL, 'Código: 412', 'sede-pm-1'),
('prod-pm-413', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'COCONUT PASSION', 'ORI-VS CREMA COCONUT PASSION-FEM', 'DAMAS', 'cosmetica', 'PM-413', 2, 0, '2026-03-16', 59000, 110000, NULL, 'Código: 413', 'sede-pm-1'),
('prod-pm-411', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LOVE SPELL', 'ORI-VS CREMA LOVE SPELL-FEM', 'DAMAS', 'cosmetica', 'PM-411', 1, 0, '2026-03-16', 57000, 110000, NULL, 'Código: 411', 'sede-pm-1'),
('prod-pm-416', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'MIDNIGHT BLOOM', 'ORI-VS CREMA MIDNIGHT BLOOM-FEM', 'DAMAS', 'cosmetica', 'PM-416', 1, 0, '2026-03-16', 57000, 110000, NULL, 'Código: 416', 'sede-pm-1'),
('prod-pm-439', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'NEON TROPIC', 'ORI-VS CREMA NEON TROPIC-FEM', 'DAMAS', 'cosmetica', 'PM-439', 1, 0, '2026-03-16', 48721, 110000, NULL, 'Código: 439', 'sede-pm-1'),
('prod-pm-410', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'PURE SEDUCTION', 'ORI-VS CREMA PURE SEDUCTION-FEM', 'DAMAS', 'cosmetica', 'PM-410', 2, 0, '2026-03-16', 59000, 110000, NULL, 'Código: 410', 'sede-pm-1'),
('prod-pm-436', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ROMANTIC', 'ORI-VS CREMA ROMANTIC-FEM', 'DAMAS', 'cosmetica', 'PM-436', 1, 0, '2026-03-16', 48721, 110000, NULL, 'Código: 436', 'sede-pm-1'),
('prod-pm-435', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'RUSH', 'ORI-VS CREMA RUSH-FEM', 'DAMAS', 'cosmetica', 'PM-435', 1, 0, '2026-03-16', 48721, 110000, NULL, 'Código: 435', 'sede-pm-1'),
('prod-pm-409', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'VELVET PETALS', 'ORI-VS CREMA VELVET PETALS-FEM', 'DAMAS', 'cosmetica', 'PM-409', 2, 0, '2026-03-16', 59000, 110000, NULL, 'Código: 409', 'sede-pm-1'),
('prod-pm-438', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'WILD NEROLI', 'ORI-VS CREMA WILD NEROLI-FEM', 'DAMAS', 'cosmetica', 'PM-438', 1, 0, '2026-03-16', 48721, 110000, NULL, 'Código: 438', 'sede-pm-1'),
('prod-pm-516', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', '29K AMBER', 'VIDAN-CREMA TOCADOR-29K AMBER', 'CREMAS', 'cosmetica', 'PM-516', 3, 0, '2026-03-16', 14517, 29000, NULL, 'Código: 516', 'sede-pm-1'),
('prod-pm-514', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', '29K LOVELY', 'VIDAN-CREMA TOCADOR-29K LOVELY', 'CREMAS', 'cosmetica', 'PM-514', 2, 0, '2026-03-16', 14517, 29000, NULL, 'Código: 514', 'sede-pm-1'),
('prod-pm-515', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', '29K SPELL', 'VIDAN-CREMA TOCADOR-29K SPELL', 'CREMAS', 'cosmetica', 'PM-515', 3, 0, '2026-03-16', 14517, 29000, NULL, 'Código: 515', 'sede-pm-1'),
('prod-pm-513', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', '29K VAINILLA', 'VIDAN-CREMA TOCADOR-29K VAINILLA', 'CREMAS', 'cosmetica', 'PM-513', 3, 0, '2026-03-16', 14517, 29000, NULL, 'Código: 513', 'sede-pm-1'),
('prod-pm-517', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'BOMBOM', 'VIDAN-CREMA TOCADOR-BOMBOM', 'CREMAS', 'cosmetica', 'PM-517', 2, 0, '2026-03-16', 14517, 29000, NULL, 'Código: 517', 'sede-pm-1'),
('prod-pm-512', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'FLOWER DREAMS', 'VIDAN-CREMA TOCADOR-FLOWER DREAMS', 'CREMAS', 'cosmetica', 'PM-512', 2, 0, '2026-03-16', 14517, 29000, NULL, 'Código: 512', 'sede-pm-1'),
('prod-pm-511', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'MANGO DREAMS', 'VIDAN-CREMA TOCADOR-MANGO DREAMS', 'CREMAS', 'cosmetica', 'PM-511', 2, 0, '2026-03-16', 14517, 29000, NULL, 'Código: 511', 'sede-pm-1'),
('prod-pm-510', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'PURE DREMS', 'VIDAN-CREMA TOCADOR-PURE DREMS', 'CREMAS', 'cosmetica', 'PM-510', 2, 0, '2026-03-16', 14517, 29000, NULL, 'Código: 510', 'sede-pm-1'),
('prod-pm-526', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'COCO', 'VIDAN-MANTEQUILLA BLIME-COCO', 'CREMAS', 'cosmetica', 'PM-526', 2, 0, '2026-03-16', 15467, 30000, NULL, 'Código: 526', 'sede-pm-1'),
('prod-pm-531', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'FRESH', 'VIDAN-MANTEQUILLA BLIME-FRESH', 'CREMAS', 'cosmetica', 'PM-531', 2, 0, '2026-03-16', 15467, 30000, NULL, 'Código: 531', 'sede-pm-1'),
('prod-pm-530', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'FRUTOS ROJOS', 'VIDAN-MANTEQUILLA BLIME-FRUTOS ROJOS', 'CREMAS', 'cosmetica', 'PM-530', 3, 0, '2026-03-16', 15467, 30000, NULL, 'Código: 530', 'sede-pm-1'),
('prod-pm-529', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'MANDARINA', 'VIDAN-MANTEQUILLA BLIME-MANDARINA', 'CREMAS', 'cosmetica', 'PM-529', 0, 0, '2026-03-16', 15467, 30000, NULL, 'Código: 529', 'sede-pm-1'),
('prod-pm-528', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'MARACUYA', 'VIDAN-MANTEQUILLA BLIME-MARACUYA', 'CREMAS', 'cosmetica', 'PM-528', 1, 0, '2026-03-16', 15467, 30000, NULL, 'Código: 528', 'sede-pm-1'),
('prod-pm-532', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'NARANJA', 'VIDAN-MANTEQUILLA BLIME-NARANJA', 'CREMAS', 'cosmetica', 'PM-532', 2, 0, '2026-03-16', 15467, 30000, NULL, 'Código: 532', 'sede-pm-1'),
('prod-pm-527', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'PIÑA COLADA', 'VIDAN-MANTEQUILLA BLIME-PIÑA COLADA', 'CREMAS', 'cosmetica', 'PM-527', 2, 0, '2026-03-16', 15467, 30000, NULL, 'Código: 527', 'sede-pm-1'),
('prod-pm-537', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', '29K AMBER', 'VIDAN-MANTEQUILLA BRILLO-29K AMBER', 'CREMAS', 'cosmetica', 'PM-537', 1, 0, '2026-03-16', 15467, 30000, NULL, 'Código: 537', 'sede-pm-1'),
('prod-pm-532-b', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', '29K AQUA', 'VIDAN-MANTEQUILLA BRILLO-29K AQUA', 'CREMAS', 'cosmetica', 'PM-532-B', 2, 0, '2026-03-16', 15467, 30000, NULL, 'Código: 532', 'sede-pm-1'),
('prod-pm-536', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', '29K LOVELY', 'VIDAN-MANTEQUILLA BRILLO-29K LOVELY', 'CREMAS', 'cosmetica', 'PM-536', 1, 0, '2026-03-16', 15467, 30000, NULL, 'Código: 536', 'sede-pm-1'),
('prod-pm-535', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', '29K VAINILLA', 'VIDAN-MANTEQUILLA BRILLO-29K VAINILLA', 'CREMAS', 'cosmetica', 'PM-535', 1, 0, '2026-03-16', 15467, 30000, NULL, 'Código: 535', 'sede-pm-1'),
('prod-pm-539', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'BOMBOM', 'VIDAN-MANTEQUILLA BRILLO-BOMBOM', 'CREMAS', 'cosmetica', 'PM-539', 1, 0, '2026-03-16', 15467, 30000, NULL, 'Código: 539', 'sede-pm-1'),
('prod-pm-533', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'COCO DREAMS', 'VIDAN-MANTEQUILLA BRILLO-COCO DREAMS', 'CREMAS', 'cosmetica', 'PM-533', 0, 0, '2026-03-16', 15467, 30000, NULL, 'Código: 533', 'sede-pm-1'),
('prod-pm-532-c', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'MANGO DREAMS', 'VIDAN-MANTEQUILLA BRILLO-MANGO DREAMS', 'CREMAS', 'cosmetica', 'PM-532-C', 1, 0, '2026-03-16', 15467, 30000, NULL, 'Código: 532', 'sede-pm-1'),
('prod-pm-534', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'PURE DREAMS', 'VIDAN-MANTEQUILLA BRILLO-PURE DREAMS', 'CREMAS', 'cosmetica', 'PM-534', 1, 0, '2026-03-16', 15467, 30000, NULL, 'Código: 534', 'sede-pm-1'),
('prod-pm-531-b', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'SKY DREAMS', 'VIDAN-MANTEQUILLA BRILLO-SKY DREAMS', 'CREMAS', 'cosmetica', 'PM-531-B', 4, 0, '2026-03-16', 15467, 30000, NULL, 'Código: 531', 'sede-pm-1'),
('prod-pm-548', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', '29K AMBER', 'VIDAN-MINI CREMA SHIMMER-29K AMBER', 'CREMAS', 'cosmetica', 'PM-548', 2, 0, '2026-03-16', 5717, 10000, NULL, 'Código: 548', 'sede-pm-1'),
('prod-pm-550', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', '29K BOMB', 'VIDAN-MINI CREMA SHIMMER-29K BOMB', 'CREMAS', 'cosmetica', 'PM-550', 1, 0, '2026-03-16', 5717, 10000, NULL, 'Código: 550', 'sede-pm-1'),
('prod-pm-546', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', '29K LOVELY', 'VIDAN-MINI CREMA SHIMMER-29K LOVELY', 'CREMAS', 'cosmetica', 'PM-546', 3, 0, '2026-03-16', 5717, 10000, NULL, 'Código: 546', 'sede-pm-1'),
('prod-pm-547', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', '29K SPELL', 'VIDAN-MINI CREMA SHIMMER-29K SPELL', 'CREMAS', 'cosmetica', 'PM-547', 3, 0, '2026-03-16', 5717, 10000, NULL, 'Código: 547', 'sede-pm-1'),
('prod-pm-545', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', '29K VAINILLA', 'VIDAN-MINI CREMA SHIMMER-29K VAINILLA', 'CREMAS', 'cosmetica', 'PM-545', 2, 0, '2026-03-16', 5717, 10000, NULL, 'Código: 545', 'sede-pm-1'),
('prod-pm-549', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'BOMBOM', 'VIDAN-MINI CREMA SHIMMER-BOMBOM', 'CREMAS', 'cosmetica', 'PM-549', 4, 0, '2026-03-16', 5717, 10000, NULL, 'Código: 549', 'sede-pm-1'),
('prod-pm-542', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'COCO DREAMS', 'VIDAN-MINI CREMA SHIMMER-COCO DREAMS', 'CREMAS', 'cosmetica', 'PM-542', 2, 0, '2026-03-16', 5717, 10000, NULL, 'Código: 542', 'sede-pm-1'),
('prod-pm-543', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'FLOWER DREAMS', 'VIDAN-MINI CREMA SHIMMER-FLOWER DREAMS', 'CREMAS', 'cosmetica', 'PM-543', 2, 0, '2026-03-16', 5717, 10000, NULL, 'Código: 543', 'sede-pm-1'),
('prod-pm-541', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'MANGO DREAMS', 'VIDAN-MINI CREMA SHIMMER-MANGO DREAMS', 'CREMAS', 'cosmetica', 'PM-541', 3, 0, '2026-03-16', 5717, 10000, NULL, 'Código: 541', 'sede-pm-1'),
('prod-pm-544', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'PURE DREAMS', 'VIDAN-MINI CREMA SHIMMER-PURE DREAMS', 'CREMAS', 'cosmetica', 'PM-544', 3, 0, '2026-03-16', 5717, 10100, NULL, 'Código: 544', 'sede-pm-1'),
('prod-pm-540', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'SKY DREAMS', 'VIDAN-MINI CREMA SHIMMER-SKY DREAMS', 'CREMAS', 'cosmetica', 'PM-540', 2, 0, '2026-03-16', 5717, 10000, NULL, 'Código: 540', 'sede-pm-1'),
('prod-pm-525', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'BABY DREAMS', 'VIDAN-MINI MANTEQUILLA-BABY DREAMS', 'CREMAS', 'cosmetica', 'PM-525', 1, 0, '2026-03-16', 9317, 18000, NULL, 'Código: 525', 'sede-pm-1'),
('prod-pm-522', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'DOLL DREAMS', 'VIDAN-MINI MANTEQUILLA-DOLL DREAMS', 'CREMAS', 'cosmetica', 'PM-522', 2, 0, '2026-03-16', 9317, 18000, NULL, 'Código: 522', 'sede-pm-1'),
('prod-pm-521', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'NIGHT DREAMS', 'VIDAN-MINI MANTEQUILLA-NIGHT DREAMS', 'CREMAS', 'cosmetica', 'PM-521', 2, 0, '2026-03-16', 9317, 18000, NULL, 'Código: 521', 'sede-pm-1'),
('prod-pm-523', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'SHINE DREAMS', 'VIDAN-MINI MANTEQUILLA-SHINE DREAMS', 'CREMAS', 'cosmetica', 'PM-523', 4, 0, '2026-03-16', 9317, 18000, NULL, 'Código: 523', 'sede-pm-1'),
('prod-pm-524', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'SUGAR DREAMS', 'VIDAN-MINI MANTEQUILLA-SUGAR DREAMS', 'CREMAS', 'cosmetica', 'PM-524', 3, 0, '2026-03-16', 9317, 18000, NULL, 'Código: 524', 'sede-pm-1'),
('prod-pm-520', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'WAVES', 'VIDAN-MINI MANTEQUILLA-WAVES', 'CREMAS', 'cosmetica', 'PM-520', 6, 0, '2026-03-16', 9317, 18000, NULL, 'Código: 520', 'sede-pm-1'),
('prod-pm-600', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'COCO BLANCO', 'PURPURE-BRILLI BRILLI-COCO BLANCO', 'CREMAS', 'cosmetica', 'PM-600', 1, 0, '2026-03-16', 9410, 20000, NULL, 'Código: 600', 'sede-pm-1'),
('prod-pm-s1-601', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'FRUTAL MORADO', 'PURPURE-BRILLI BRILLI-FRUTAL MORADO', 'CREMAS', 'cosmetica', 'PM-S1-601', 0, 0, '2026-03-16', 9410, 20000, NULL, 'Código: 601', 'sede-pm-1'),
('prod-pm-s1-602', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'VAINILLA ROJO', 'PURPURE-BRILLI BRILLI-VAINILLA ROJO', 'CREMAS', 'cosmetica', 'PM-S1-602', 0, 0, '2026-03-16', 9410, 20000, NULL, 'Código: 602', 'sede-pm-1'),
('prod-pm-s1-619', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'SWEET LYCHEE', 'PURPURE-MANTEQUILLA-SWEET LYCHEE', 'CREMAS', 'cosmetica', 'PM-S1-619', 1, 0, '2026-03-16', 14810, 30000, NULL, 'Código: 619', 'sede-pm-1'),
('prod-pm-s1-610', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'BUBBLE GUM', 'PURPURE-MINI MANTEQUILLA BELLOTA-BUBBLE GUM', 'CREMAS', 'cosmetica', 'PM-S1-610', 1, 0, '2026-03-16', 8410, 15000, NULL, 'Código: 610', 'sede-pm-1'),
('prod-pm-s1-612', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'CANDY BUM', 'PURPURE-MINI MANTEQUILLA BELLOTA-CANDY BUM', 'CREMAS', 'cosmetica', 'PM-S1-612', 1, 0, '2026-03-16', 8410, 15000, NULL, 'Código: 612', 'sede-pm-1'),
('prod-pm-s1-611', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'CARAMEL CRUSH', 'PURPURE-MINI MANTEQUILLA BELLOTA-CARAMEL CRUSH', 'CREMAS', 'cosmetica', 'PM-S1-611', 1, 0, '2026-03-16', 8410, 15000, NULL, 'Código: 611', 'sede-pm-1'),
('prod-pm-s1-613', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'STRAWBERRY', 'PURPURE-MINI MANTEQUILLA BELLOTA-STRAWBERRY', 'CREMAS', 'cosmetica', 'PM-S1-613', 1, 0, '2026-03-16', 8410, 15000, NULL, 'Código: 613', 'sede-pm-1'),
('prod-pm-s1-617', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'COCONUT SHINE', 'PURPURE-MINI MANTEQUILLA-COCONUT SHINE', 'CREMAS', 'cosmetica', 'PM-S1-617', 0, 0, '2026-03-16', 7110, 13100, NULL, 'Código: 617', 'sede-pm-1'),
('prod-pm-s1-616', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'GIRLBOSS', 'PURPURE-MINI MANTEQUILLA-GIRLBOSS', 'CREMAS', 'cosmetica', 'PM-S1-616', 0, 0, '2026-03-16', 7110, 13100, NULL, 'Código: 616', 'sede-pm-1'),
('prod-pm-s1-618', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'SEXY CHAMPAGNE', 'PURPURE-MINI MANTEQUILLA-SEXY CHAMPAGNE', 'CREMAS', 'cosmetica', 'PM-S1-618', 0, 0, '2026-03-16', 7110, 13000, NULL, 'Código: 618', 'sede-pm-1'),
('prod-pm-s1-614', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'VAINILLA DREAMS', 'PURPURE-MINI MANTEQUILLA-VAINILLA DREAMS', 'CREMAS', 'cosmetica', 'PM-S1-614', 1, 0, '2026-03-16', 7110, 13000, NULL, 'Código: 614', 'sede-pm-1'),
('prod-pm-s1-615', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'WATERMELON', 'PURPURE-MINI MANTEQUILLA-WATERMELON', 'CREMAS', 'cosmetica', 'PM-S1-615', 1, 0, '2026-03-16', 7110, 13000, NULL, 'Código: 615', 'sede-pm-1'),
('prod-pm-505', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'CABELLO MAGIC SHINE', 'PERFUME-CABELLO MAGIC SHINE', 'CREMAS', 'cosmetica', 'PM-505', 9, 0, '2026-03-16', 15650, 26000, NULL, 'Código: 505', 'sede-pm-1'),
('prod-pm-s1-327', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'PINK', 'PM-SHIMMER PINK-FEM', 'DAMAS', 'cosmetica', 'PM-S1-327', 0, 0, '2026-03-16', 13200, 25000, NULL, 'Código: 327', 'sede-pm-1'),
('prod-pm-s1-326', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'SCANDAL', 'PM-SHIMMER SCANDAL-FEM', 'DAMAS', 'cosmetica', 'PM-S1-326', 0, 0, '2026-03-16', 13200, 25000, NULL, 'Código: 326', 'sede-pm-1'),
('prod-pm-s1-325', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'VELVET PETALS', 'PM-SHIMMER VELVET PETALS-FEM', 'DAMAS', 'cosmetica', 'PM-S1-325', 0, 0, '2026-03-16', 13200, 25000, NULL, 'Código: 325', 'sede-pm-1'),
('prod-pm-431', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'AMBER APERITIF', 'ORI-VS SPLASH AMBER APERITIF-FEM', 'DAMAS', 'cosmetica', 'PM-431', 1, 0, '2026-03-16', 48721, 110000, NULL, 'Código: 431', 'sede-pm-1'),
('prod-pm-405', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'AMBER ROMANCE', 'ORI-VS SPLASH AMBER ROMANCE-FEM', 'DAMAS', 'cosmetica', 'PM-405', 1, 0, '2026-03-16', 57000, 110000, NULL, 'Código: 405', 'sede-pm-1'),
('prod-pm-408', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'AQUA KISS', 'ORI-VS SPLASH AQUA KISS-FEM', 'DAMAS', 'cosmetica', 'PM-408', 0, 0, '2026-03-16', 57000, 110000, NULL, 'Código: 408', 'sede-pm-1'),
('prod-pm-402', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'BARE VAINILLA', 'ORI-VS SPLASH BARE VAINILLA-FEM', 'DAMAS', 'cosmetica', 'PM-402', 3, 0, '2026-03-16', 58000, 110000, NULL, 'Código: 402', 'sede-pm-1'),
('prod-pm-403', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'COCONUT PASSION', 'ORI-VS SPLASH COCONUT PASSION-FEM', 'DAMAS', 'cosmetica', 'PM-403', 3, 0, '2026-03-16', 59000, 110000, NULL, 'Código: 403', 'sede-pm-1'),
('prod-pm-433', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ELECTRIC MANGO', 'ORI-VS SPLASH ELECTRIC MANGO-FEM', 'DAMAS', 'cosmetica', 'PM-433', 1, 0, '2026-03-16', 48721, 110000, NULL, 'Código: 433', 'sede-pm-1'),
('prod-pm-407', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LOVE SPELL', 'ORI-VS SPLASH LOVE SPELL-FEM', 'DAMAS', 'cosmetica', 'PM-407', 1, 0, '2026-03-16', 57000, 110000, NULL, 'Código: 407', 'sede-pm-1'),
('prod-pm-404', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'MIDNIGHT BLOOM', 'ORI-VS SPLASH MIDNIGHT BLOOM-FEM', 'DAMAS', 'cosmetica', 'PM-404', 2, 0, '2026-03-16', 57000, 110000, NULL, 'Código: 404', 'sede-pm-1'),
('prod-pm-434', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'NEON TROPIC', 'ORI-VS SPLASH NEON TROPIC-FEM', 'DAMAS', 'cosmetica', 'PM-434', 1, 0, '2026-03-16', 48721, 110000, NULL, 'Código: 434', 'sede-pm-1'),
('prod-pm-401', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'PURE SEDUCTION', 'ORI-VS SPLASH PURE SEDUCTION-FEM', 'DAMAS', 'cosmetica', 'PM-401', 1, 0, '2026-03-16', 58000, 110000, NULL, 'Código: 401', 'sede-pm-1'),
('prod-pm-430', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ROMANTIC', 'ORI-VS SPLASH ROMANTIC-FEM', 'DAMAS', 'cosmetica', 'PM-430', 1, 0, '2026-03-16', 48721, 110000, NULL, 'Código: 430', 'sede-pm-1'),
('prod-pm-429', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'RUSH', 'ORI-VS SPLASH RUSH-FEM', 'DAMAS', 'cosmetica', 'PM-429', 1, 0, '2026-03-16', 48721, 110000, NULL, 'Código: 429', 'sede-pm-1'),
('prod-pm-400', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'STRAWBERRIES CHAMP', 'ORI-VS SPLASH STRAWBERRIES CHAMP-FEM', 'DAMAS', 'cosmetica', 'PM-400', 2, 0, '2026-03-16', 57000, 110000, NULL, 'Código: 400', 'sede-pm-1'),
('prod-pm-428', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'TEMPTATION', 'ORI-VS SPLASH TEMPTATION-FEM', 'DAMAS', 'cosmetica', 'PM-428', 1, 0, '2026-03-16', 48721, 110000, NULL, 'Código: 428', 'sede-pm-1'),
('prod-pm-406', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'VELVET PETALS', 'ORI-VS SPLASH VELVET PETALS-FEM', 'DAMAS', 'cosmetica', 'PM-406', 1, 0, '2026-03-16', 59000, 110000, NULL, 'Código: 406', 'sede-pm-1'),
('prod-pm-432', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'WILD NEROLI', 'ORI-VS SPLASH WILD NEROLI-FEM', 'DAMAS', 'cosmetica', 'PM-432', 1, 0, '2026-03-16', 48721, 110000, NULL, 'Código: 432', 'sede-pm-1'),
('prod-pm-393', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'AQUA KISS', 'PM-SPLASH AQUA KISS-FEM', 'DAMAS', 'cosmetica', 'PM-393', 5, 0, '2026-03-16', 10500, 22000, NULL, 'Código: 393', 'sede-pm-1'),
('prod-pm-399', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ARRURU', 'PM-SPLASH ARRURU-UNI', 'UNISEX', 'cosmetica', 'PM-399', 0, 0, '2026-03-16', 9092, 22000, NULL, 'Código: 399', 'sede-pm-1'),
('prod-pm-427', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'BATMAN', 'PM-SPLASH BATMAN-NIÑO', 'INFANTIL', 'cosmetica', 'PM-427', 4, 0, '2026-03-16', 9092, 22000, NULL, 'Código: 427', 'sede-pm-1'),
('prod-pm-397', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'BLUE SQUAD', 'PM-SPLASH BLUE SQUAD-NIÑO', 'INFANTIL', 'cosmetica', 'PM-397', 3, 0, '2026-03-16', 10500, 22000, NULL, 'Código: 397', 'sede-pm-1'),
('prod-pm-s1-302', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'BOSS BOTTLED UNL', 'PM-SPLASH BOSS BOTTLED UNL-MAS', 'CABALLEROS', 'cosmetica', 'PM-S1-302', 9, 0, '2026-03-16', 10500, 22000, NULL, 'Código: 302', 'sede-pm-1'),
('prod-pm-424', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'BUBBLE GUMMER', 'PM-SPLASH BUBBLE GUMMER-UNI', 'UNISEX', 'cosmetica', 'PM-424', 1, 0, '2026-03-16', 9092, 22000, NULL, 'Código: 424', 'sede-pm-1'),
('prod-pm-s1-321', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'BUENA CHICA', 'PM-SPLASH BUENA CHICA-FEM', 'DAMAS', 'cosmetica', 'PM-S1-321', 3, 0, '2026-03-16', 10500, 22000, NULL, 'Código: 321', 'sede-pm-1'),
('prod-pm-s1-319', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'CAN CAN', 'PM-SPLASH CAN CAN-FEM', 'DAMAS', 'cosmetica', 'PM-S1-319', 5, 0, '2026-03-16', 10500, 22000, NULL, 'Código: 319', 'sede-pm-1'),
('prod-pm-421', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'CAPITAN AMERICA', 'PM-SPLASH CAPITAN AMERICA-NIÑO', 'INFANTIL', 'cosmetica', 'PM-421', 4, 0, '2026-03-16', 9092, 22000, NULL, 'Código: 421', 'sede-pm-1'),
('prod-pm-425', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'CARNAVAL 62', 'PM-SPLASH CARNAVAL 62-FEM', 'DAMAS', 'cosmetica', 'PM-425', 3, 0, '2026-03-16', 10500, 22000, NULL, 'Código: 425', 'sede-pm-1'),
('prod-pm-442', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'CARNAVAL 68', 'PM-SPLASH CARNAVAL 68-FEM', 'DAMAS', 'cosmetica', 'PM-442', 4, 0, '2026-03-16', 10500, 22000, NULL, 'Código: 442', 'sede-pm-1'),
('prod-pm-s1-318', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'CHOCOLATE', 'PM-SPLASH CHOCOLATE-FEM', 'DAMAS', 'cosmetica', 'PM-S1-318', 8, 0, '2026-03-16', 10500, 22000, NULL, 'Código: 318', 'sede-pm-1'),
('prod-pm-s1-320', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'COCONUT PASSION', 'PM-SPLASH COCONUT PASSION-FEM', 'DAMAS', 'cosmetica', 'PM-S1-320', 6, 0, '2026-03-16', 10500, 22000, NULL, 'Código: 320', 'sede-pm-1'),
('prod-pm-395', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'COOL BOY', 'PM-SPLASH COOL BOY-NIÑO', 'INFANTIL', 'cosmetica', 'PM-395', 2, 0, '2026-03-16', 10500, 22000, NULL, 'Código: 395', 'sede-pm-1'),
('prod-pm-418', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'FROZEN', 'PM-SPLASH FROZEN-NIÑA', 'INFANTIL', 'cosmetica', 'PM-418', 1, 0, '2026-03-16', 9092, 22000, NULL, 'Código: 418', 'sede-pm-1'),
('prod-pm-s1-312', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'FRUITS', 'PM-SPLASH FRUITS-FEM', 'DAMAS', 'cosmetica', 'PM-S1-312', 6, 0, '2026-03-16', 10500, 22000, NULL, 'Código: 312', 'sede-pm-1'),
('prod-pm-420', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'GLAM ANGEL', 'PM-SPLASH GLAM ANGEL-NIÑA', 'INFANTIL', 'cosmetica', 'PM-420', 6, 0, '2026-03-16', 10500, 22000, NULL, 'Código: 420', 'sede-pm-1'),
('prod-pm-s1-317', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'HEIRESS', 'PM-SPLASH HEIRESS-FEM', 'DAMAS', 'cosmetica', 'PM-S1-317', 8, 0, '2026-03-16', 10500, 22000, NULL, 'Código: 317', 'sede-pm-1'),
('prod-pm-s1-304', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'INVICTUS', 'PM-SPLASH INVICTUS-MAS', 'CABALLEROS', 'cosmetica', 'PM-S1-304', 7, 0, '2026-03-16', 10500, 22000, NULL, 'Código: 304', 'sede-pm-1'),
('prod-pm-s1-313', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'JUICED BERRY', 'PM-SPLASH JUICED BERRY-FEM', 'DAMAS', 'cosmetica', 'PM-S1-313', 5, 0, '2026-03-16', 10500, 22000, NULL, 'Código: 313', 'sede-pm-1'),
('prod-pm-s1-300', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LACOSTE RED', 'PM-SPLASH LACOSTE RED-MAS', 'CABALLEROS', 'cosmetica', 'PM-S1-300', 6, 0, '2026-03-16', 10500, 22000, NULL, 'Código: 300', 'sede-pm-1'),
('prod-pm-s1-323', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'MANGO', 'PM-SPLASH MANGO-FEM', 'DAMAS', 'cosmetica', 'PM-S1-323', 8, 0, '2026-03-16', 10500, 22000, NULL, 'Código: 323', 'sede-pm-1'),
('prod-pm-422', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'MARIO BROSS', 'PM-SPLASH MARIO BROSS-NIÑO', 'INFANTIL', 'cosmetica', 'PM-422', 1, 0, '2026-03-16', 9092, 22000, NULL, 'Código: 422', 'sede-pm-1'),
('prod-pm-417', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'MONSTER HIGH', 'PM-SPLASH MONSTER HIGH-NIÑA', 'INFANTIL', 'cosmetica', 'PM-417', 2, 0, '2026-03-16', 9092, 22000, NULL, 'Código: 417', 'sede-pm-1'),
('prod-pm-s1-303', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'NAUTICO', 'PM-SPLASH NAUTICO-MAS', 'CABALLEROS', 'cosmetica', 'PM-S1-303', 6, 0, '2026-03-16', 10500, 22000, NULL, 'Código: 303', 'sede-pm-1'),
('prod-pm-398', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'PHANTOM LEGION', 'PM-SPLASH PHANTOM LEGION-NIÑO', 'INFANTIL', 'cosmetica', 'PM-398', 2, 0, '2026-03-16', 10500, 22000, NULL, 'Código: 398', 'sede-pm-1'),
('prod-pm-426', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'PINK CHIFFON', 'PM-SPLASH PINK CHIFFON-FEM', 'DAMAS', 'cosmetica', 'PM-426', 5, 0, '2026-03-16', 10500, 22000, NULL, 'Código: 426', 'sede-pm-1'),
('prod-pm-s1-301', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'POWER MIX', 'PM-SPLASH POWER MIX-MAS', 'CABALLEROS', 'cosmetica', 'PM-S1-301', 5, 0, '2026-03-16', 10500, 22000, NULL, 'Código: 301', 'sede-pm-1'),
('prod-pm-419', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'PRINCESA SOFIA', 'PM-SPLASH PRINCESA SOFIA-NIÑA', 'INFANTIL', 'cosmetica', 'PM-419', 6, 0, '2026-03-16', 9092, 22000, NULL, 'Código: 419', 'sede-pm-1'),
('prod-pm-s1-315', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'PURE SEDUCTION', 'PM-SPLASH PURE SEDUCTION-FEM', 'DAMAS', 'cosmetica', 'PM-S1-315', 4, 0, '2026-03-16', 10500, 22000, NULL, 'Código: 315', 'sede-pm-1'),
('prod-pm-s1-314', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'SANDIA', 'PM-SPLASH SANDIA-FEM', 'DAMAS', 'cosmetica', 'PM-S1-314', 5, 0, '2026-03-16', 10500, 22000, NULL, 'Código: 314', 'sede-pm-1'),
('prod-pm-s1-310', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'SCANDALOUS', 'PM-SPLASH SCANDALOUS-FEM', 'DAMAS', 'cosmetica', 'PM-S1-310', 7, 0, '2026-03-16', 10500, 22000, NULL, 'Código: 310', 'sede-pm-1'),
('prod-pm-423', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'SUAVE CARICIA', 'PM-SPLASH SUAVE CARICIA-UNI', 'UNISEX', 'cosmetica', 'PM-423', 6, 0, '2026-03-16', 9092, 22000, NULL, 'Código: 423', 'sede-pm-1'),
('prod-pm-444', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'TALCO', 'PM-SPLASH TALCO-FEM', 'DAMAS', 'cosmetica', 'PM-444', 6, 0, '2026-03-16', 10500, 22000, NULL, 'Código: 444', 'sede-pm-1'),
('prod-pm-s1-322', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'V DAME AMOR', 'PM-SPLASH V DAME AMOR-FEM', 'DAMAS', 'cosmetica', 'PM-S1-322', 5, 0, '2026-03-16', 10500, 22000, NULL, 'Código: 322', 'sede-pm-1'),
('prod-pm-s1-311', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'V RUSH', 'PM-SPLASH V RUSH-FEM', 'DAMAS', 'cosmetica', 'PM-S1-311', 8, 0, '2026-03-16', 10500, 22000, NULL, 'Código: 311', 'sede-pm-1'),
('prod-pm-396', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'VAINILLA LACE', 'PM-SPLASH VAINILLA LACE-NIÑA', 'INFANTIL', 'cosmetica', 'PM-396', 2, 0, '2026-03-16', 10500, 22000, NULL, 'Código: 396', 'sede-pm-1'),
('prod-pm-s1-316', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'VAINILLA', 'PM-SPLASH VAINILLA-FEM', 'DAMAS', 'cosmetica', 'PM-S1-316', 10, 0, '2026-03-16', 10500, 22000, NULL, 'Código: 316', 'sede-pm-1'),
('prod-pm-s1-324', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'VELVET PETALS', 'PM-SPLASH VELVET PETALS-FEM', 'DAMAS', 'cosmetica', 'PM-S1-324', 8, 0, '2026-03-16', 10500, 22000, NULL, 'Código: 324', 'sede-pm-1'),
('prod-pm-394', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'WOOD NOIR', 'PM-SPLASH WOOD NOIR-MAS', 'CABALLEROS', 'cosmetica', 'PM-394', 7, 0, '2026-03-16', 10500, 22000, NULL, 'Código: 394', 'sede-pm-1'),
('prod-pm-s1-609', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ADDICTION GIRL', 'PURPURE-MINI SPLASH-ADDICTION GIRL', 'CREMAS', 'cosmetica', 'PM-S1-609', 3, 0, '2026-03-16', 9910, 18100, NULL, 'Código: 609', 'sede-pm-1'),
('prod-pm-s1-607', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'BIRTHDAY CAKE', 'PURPURE-MINI SPLASH-BIRTHDAY CAKE', 'CREMAS', 'cosmetica', 'PM-S1-607', 1, 0, '2026-03-16', 9910, 18100, NULL, 'Código: 607', 'sede-pm-1'),
('prod-pm-s1-604', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'CANDY BUM', 'PURPURE-MINI SPLASH-CANDY BUM', 'CREMAS', 'cosmetica', 'PM-S1-604', 1, 0, '2026-03-16', 9910, 18100, NULL, 'Código: 604', 'sede-pm-1'),
('prod-pm-s1-605', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'COCONUT SHINE', 'PURPURE-MINI SPLASH-COCONUT SHINE', 'CREMAS', 'cosmetica', 'PM-S1-605', 1, 0, '2026-03-16', 9910, 18100, NULL, 'Código: 605', 'sede-pm-1'),
('prod-pm-s1-606', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'SEXY CHAMPAGNE', 'PURPURE-MINI SPLASH-SEXY CHAMPAGNE', 'CREMAS', 'cosmetica', 'PM-S1-606', 3, 0, '2026-03-16', 9910, 18100, NULL, 'Código: 606', 'sede-pm-1'),
('prod-pm-s1-608', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'SWEET LYCHEE', 'PURPURE-MINI SPLASH-SWEET LYCHEE', 'CREMAS', 'cosmetica', 'PM-S1-608', 2, 0, '2026-03-16', 9910, 18000, NULL, 'Código: 608', 'sede-pm-1'),
('prod-pm-s1-603', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'VAINILLA DREAMS', 'PURPURE-MINI SPLASH-VAINILLA DREAMS', 'CREMAS', 'cosmetica', 'PM-S1-603', 1, 0, '2026-03-16', 9910, 18100, NULL, 'Código: 603', 'sede-pm-1'),
('prod-pm-582', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', '1 MILLON', 'REP-SPLASH ACRILICOS-1 MILLON-MAS', 'CABALLEROS', 'cosmetica', 'PM-582', 0, 0, '2026-03-16', 11500, 22000, NULL, 'Código: 582', 'sede-pm-1'),
('prod-pm-589', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'AMBER OUD GOLD', 'REP-SPLASH ACRILICOS-AMBER OUD GOLD-UNI', 'UNISEX', 'cosmetica', 'PM-589', 1, 0, '2026-03-16', 11500, 22000, NULL, 'Código: 589', 'sede-pm-1'),
('prod-pm-589-b', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'AMETHYSTE', 'REP-SPLASH ACRILICOS-AMETHYSTE-UNI', 'UNISEX', 'cosmetica', 'PM-589-B', 2, 0, '2026-03-16', 11500, 22000, NULL, 'Código: 589', 'sede-pm-1'),
('prod-pm-587', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ARI', 'REP-SPLASH ACRILICOS-ARI-FEM', 'DAMAS', 'cosmetica', 'PM-587', 1, 0, '2026-03-16', 11500, 22000, NULL, 'Código: 587', 'sede-pm-1'),
('prod-pm-585', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ASAD', 'REP-SPLASH ACRILICOS-ASAD-MAS', 'CABALLEROS', 'cosmetica', 'PM-585', 2, 0, '2026-03-16', 11500, 22000, NULL, 'Código: 585', 'sede-pm-1'),
('prod-pm-581', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'BHARARA KING', 'REP-SPLASH ACRILICOS-BHARARA KING-MAS', 'CABALLEROS', 'cosmetica', 'PM-581', 2, 0, '2026-03-16', 11500, 22000, NULL, 'Código: 581', 'sede-pm-1'),
('prod-pm-586', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'CLOUD', 'REP-SPLASH ACRILICOS-CLOUD-FEM', 'DAMAS', 'cosmetica', 'PM-586', 2, 0, '2026-03-16', 11500, 22000, NULL, 'Código: 586', 'sede-pm-1'),
('prod-pm-595', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'CLUB DE NUIT INTENSE', 'REP-SPLASH ACRILICOS-CLUB DE NUIT INTENSE-MAS', 'CABALLEROS', 'cosmetica', 'PM-595', 1, 0, '2026-03-16', 11500, 22000, NULL, 'Código: 595', 'sede-pm-1'),
('prod-pm-590', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'DELINHA', 'REP-SPLASH ACRILICOS-DELINHA-FEM', 'DAMAS', 'cosmetica', 'PM-590', 1, 0, '2026-03-16', 11500, 22000, NULL, 'Código: 590', 'sede-pm-1'),
('prod-pm-588', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'EMEER', 'REP-SPLASH ACRILICOS-EMEER-UNI', 'UNISEX', 'cosmetica', 'PM-588', 1, 0, '2026-03-16', 11500, 22000, NULL, 'Código: 588', 'sede-pm-1'),
('prod-pm-593', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'HAYA', 'REP-SPLASH ACRILICOS-HAYA-FEM', 'DAMAS', 'cosmetica', 'PM-593', 1, 0, '2026-03-16', 11500, 22000, NULL, 'Código: 593', 'sede-pm-1'),
('prod-pm-592', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'HEIRES', 'REP-SPLASH ACRILICOS-HEIRES-FEM', 'DAMAS', 'cosmetica', 'PM-592', 0, 0, '2026-03-16', 11500, 22000, NULL, 'Código: 592', 'sede-pm-1'),
('prod-pm-596', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'HONOR Y GLORY', 'REP-SPLASH ACRILICOS-HONOR Y GLORY-UNI', 'UNISEX', 'cosmetica', 'PM-596', 1, 0, '2026-03-16', 11500, 22000, NULL, 'Código: 596', 'sede-pm-1'),
('prod-pm-583', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'INVICTUS', 'REP-SPLASH ACRILICOS-INVICTUS-MAS', 'CABALLEROS', 'cosmetica', 'PM-583', 1, 0, '2026-03-16', 11500, 22000, NULL, 'Código: 583', 'sede-pm-1'),
('prod-pm-594', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'MANDARIN SKY', 'REP-SPLASH ACRILICOS-MANDARIN SKY-MAS', 'CABALLEROS', 'cosmetica', 'PM-594', 1, 0, '2026-03-16', 11500, 22000, NULL, 'Código: 594', 'sede-pm-1'),
('prod-pm-584', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'NAUTICA VOYAGE', 'REP-SPLASH ACRILICOS-NAUTICA VOYAGE-MAS', 'CABALLEROS', 'cosmetica', 'PM-584', 2, 0, '2026-03-16', 11500, 22000, NULL, 'Código: 584', 'sede-pm-1'),
('prod-pm-560', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'SANTAL 33', 'REP-SPLASH ACRILICOS-SANTAL 33-UNI', 'UNISEX', 'cosmetica', 'PM-560', 1, 0, '2026-03-16', 11500, 22000, NULL, 'Código: 560', 'sede-pm-1'),
('prod-pm-591', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'STARRY NIGHT', 'REP-SPLASH ACRILICOS-STARRY NIGHT-UNI', 'UNISEX', 'cosmetica', 'PM-591', 1, 0, '2026-03-16', 11500, 22000, NULL, 'Código: 591', 'sede-pm-1'),
('prod-pm-588-b', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'SWEET LIKE CANDY', 'REP-SPLASH ACRILICOS-SWEET LIKE CANDY-FEM', 'DAMAS', 'cosmetica', 'PM-588-B', 1, 0, '2026-03-16', 11500, 22000, NULL, 'Código: 588', 'sede-pm-1'),
('prod-pm-589-c', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'TOY PEARL', 'REP-SPLASH ACRILICOS-TOY PEARL-UNI', 'UNISEX', 'cosmetica', 'PM-589-C', 1, 0, '2026-03-16', 11500, 22000, NULL, 'Código: 589', 'sede-pm-1'),
('prod-pm-580', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'UOMO BORN IN ROMA', 'REP-SPLASH ACRILICOS-UOMO BORN IN ROMA-MAS', 'CABALLEROS', 'cosmetica', 'PM-580', 1, 0, '2026-03-16', 11500, 22000, NULL, 'Código: 580', 'sede-pm-1'),
('prod-pm-s1-1004', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'YARA', 'ORI-AEROSOL-YARA-FEM', 'DAMAS', 'cosmetica', 'PM-S1-1004', 3, 0, '2026-03-16', 39900, 80000, NULL, 'Código: 1004', 'sede-pm-1'),
('prod-pm-552', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', '29K AMBER', 'VIDAN-MINI SPLASH-29K AMBER', 'CREMAS', 'cosmetica', 'PM-552', 0, 0, '2026-03-16', 5717, 10000, NULL, 'Código: 552', 'sede-pm-1'),
('prod-pm-554', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', '29K AQUA', 'VIDAN-MINI SPLASH-29K AQUA', 'CREMAS', 'cosmetica', 'PM-554', 0, 0, '2026-03-16', 5717, 10000, NULL, 'Código: 554', 'sede-pm-1'),
('prod-pm-551', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', '29K BOMB', 'VIDAN-MINI SPLASH-29K BOMB', 'CREMAS', 'cosmetica', 'PM-551', 1, 0, '2026-03-16', 5717, 10000, NULL, 'Código: 551', 'sede-pm-1'),
('prod-pm-553', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', '29K SPELL', 'VIDAN-MINI SPLASH-29K SPELL', 'CREMAS', 'cosmetica', 'PM-553', 0, 0, '2026-03-16', 5717, 10000, NULL, 'Código: 553', 'sede-pm-1'),
('prod-pm-557', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'BOMBOM', 'VIDAN-MINI SPLASH-BOMBOM', 'CREMAS', 'cosmetica', 'PM-557', 0, 0, '2026-03-16', 5717, 10000, NULL, 'Código: 557', 'sede-pm-1'),
('prod-pm-555', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'MANGO DREAMS', 'VIDAN-MINI SPLASH-MANGO DREAMS', 'CREMAS', 'cosmetica', 'PM-555', 0, 0, '2026-03-16', 5717, 10000, NULL, 'Código: 555', 'sede-pm-1'),
('prod-pm-556', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'PURE DREAMS', 'VIDAN-MINI SPLASH-PURE DREAMS', 'CREMAS', 'cosmetica', 'PM-556', 0, 0, '2026-03-16', 5717, 10000, NULL, 'Código: 556', 'sede-pm-1');

-- SEDE 1 — HOGAR (62 filas)
INSERT INTO products (id, tenant_id, name, articulo, category, product_type, sku, stock, reorder_point, entry_date, purchase_price, sale_price, presentation, notes, sede_id) VALUES
('prod-pm-s1-330', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ALGODON', 'AROMATIZANTE-ALGODON', 'HOGAR', 'cosmetica', 'PM-S1-330', 3, 0, '2026-03-16', 8000, 15000, NULL, 'Código: 330', 'sede-pm-1'),
('prod-pm-s1-334', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'CHICLE BOMBON', 'AROMATIZANTE-CHICLE BOMBON', 'HOGAR', 'cosmetica', 'PM-S1-334', 5, 0, '2026-03-16', 8000, 15000, NULL, 'Código: 334', 'sede-pm-1'),
('prod-pm-443', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'CITRONELA LEMON', 'AROMATIZANTE-CITRONELA LEMON', 'HOGAR', 'cosmetica', 'PM-443', 6, 0, '2026-03-16', 8000, 15000, NULL, 'Código: 443', 'sede-pm-1'),
('prod-pm-s1-332', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'COCO', 'AROMATIZANTE-COCO', 'HOGAR', 'cosmetica', 'PM-S1-332', 7, 0, '2026-03-16', 8000, 15000, NULL, 'Código: 332', 'sede-pm-1'),
('prod-pm-s1-336', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'FRUITS', 'AROMATIZANTE-FRUITS', 'HOGAR', 'cosmetica', 'PM-S1-336', 6, 0, '2026-03-16', 8000, 15000, NULL, 'Código: 336', 'sede-pm-1'),
('prod-pm-s1-331', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'FRUTOS ROJOS', 'AROMATIZANTE-FRUTOS ROJOS', 'HOGAR', 'cosmetica', 'PM-S1-331', 1, 0, '2026-03-16', 8000, 15000, NULL, 'Código: 331', 'sede-pm-1'),
('prod-pm-s1-333', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'KIWI', 'AROMATIZANTE-KIWI', 'HOGAR', 'cosmetica', 'PM-S1-333', 8, 0, '2026-03-16', 8000, 15000, NULL, 'Código: 333', 'sede-pm-1'),
('prod-pm-s1-337', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LAVANDA FRESH', 'AROMATIZANTE-LAVANDA FRESH', 'HOGAR', 'cosmetica', 'PM-S1-337', 3, 0, '2026-03-16', 8000, 15000, NULL, 'Código: 337', 'sede-pm-1'),
('prod-pm-s1-335', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'VAINILLA', 'AROMATIZANTE-VAINILLA', 'HOGAR', 'cosmetica', 'PM-S1-335', 6, 0, '2026-03-16', 8000, 15000, NULL, 'Código: 335', 'sede-pm-1'),
('prod-pm-366', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ARANDANO MORA CAR', 'PM CARRO-ARANDANO MORA CAR', 'HOGAR', 'cosmetica', 'PM-366', 4, 0, '2026-03-16', 8000, 15000, NULL, 'Código: 366', 'sede-pm-1'),
('prod-pm-364', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'AUDI', 'PM CARRO-AUDI', 'HOGAR', 'cosmetica', 'PM-364', 1, 0, '2026-03-16', 8000, 15000, NULL, 'Código: 364', 'sede-pm-1'),
('prod-pm-365', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'CHEVROLET', 'PM CARRO-CHEVROLET', 'HOGAR', 'cosmetica', 'PM-365', 1, 0, '2026-03-16', 8000, 15000, NULL, 'Código: 365', 'sede-pm-1'),
('prod-pm-361', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'FRESCO CHUSPIANTE', 'PM CARRO-FRESCO CHUSPIANTE', 'HOGAR', 'cosmetica', 'PM-361', 4, 0, '2026-03-16', 8000, 15000, NULL, 'Código: 361', 'sede-pm-1'),
('prod-pm-362', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'SANDIA FRAPE', 'PM CARRO-SANDIA FRAPE', 'HOGAR', 'cosmetica', 'PM-362', 7, 0, '2026-03-16', 8000, 15000, NULL, 'Código: 362', 'sede-pm-1'),
('prod-pm-363', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'TOYOTA', 'PM CARRO-TOYOTA', 'HOGAR', 'cosmetica', 'PM-363', 1, 0, '2026-03-16', 8000, 15000, NULL, 'Código: 363', 'sede-pm-1'),
('prod-pm-360', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'XTREME CAR', 'PM CARRO-XTREME CAR', 'HOGAR', 'cosmetica', 'PM-360', 2, 0, '2026-03-16', 8000, 15000, NULL, 'Código: 360', 'sede-pm-1'),
('prod-pm-440', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'AMBROSIA VAINILLA', 'DIFUSOR-AMBROSIA VAINILLA', 'HOGAR', 'cosmetica', 'PM-440', 5, 0, '2026-03-16', 9300, 15000, NULL, 'Código: 440', 'sede-pm-1'),
('prod-pm-403-b', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'BRISA TROPICAL', 'DIFUSOR-BRISA TROPICAL', 'HOGAR', 'cosmetica', 'PM-403-B', 4, 0, '2026-03-16', 9300, 15000, NULL, 'Código: 403', 'sede-pm-1'),
('prod-pm-s1-347', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'CAFE MOCKA', 'DIFUSOR-CAFE MOCKA', 'HOGAR', 'cosmetica', 'PM-S1-347', 0, 0, '2026-03-16', 9300, 15000, NULL, 'Código: 347', 'sede-pm-1'),
('prod-pm-s1-348', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'CITRUS', 'DIFUSOR-CITRUS', 'HOGAR', 'cosmetica', 'PM-S1-348', 5, 0, '2026-03-16', 9300, 15000, NULL, 'Código: 348', 'sede-pm-1'),
('prod-pm-402-b', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ELEGANT', 'DIFUSOR-ELEGANT', 'HOGAR', 'cosmetica', 'PM-402-B', 5, 0, '2026-03-16', 9300, 15000, NULL, 'Código: 402', 'sede-pm-1'),
('prod-pm-404-b', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'FRESCA BRISA', 'DIFUSOR-FRESCA BRISA', 'HOGAR', 'cosmetica', 'PM-404-B', 2, 0, '2026-03-16', 9300, 15000, NULL, 'Código: 404', 'sede-pm-1'),
('prod-pm-s1-343', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'FRUTOS ROJOS', 'DIFUSOR-FRUTOS ROJOS', 'HOGAR', 'cosmetica', 'PM-S1-343', 1, 0, '2026-03-16', 9300, 15000, NULL, 'Código: 343', 'sede-pm-1'),
('prod-pm-s1-346', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'KIWI', 'DIFUSOR-KIWI', 'HOGAR', 'cosmetica', 'PM-S1-346', 3, 0, '2026-03-16', 9300, 15000, NULL, 'Código: 346', 'sede-pm-1'),
('prod-pm-349', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'KOLA PINK', 'DIFUSOR-KOLA PINK', 'HOGAR', 'cosmetica', 'PM-349', 3, 0, '2026-03-16', 9300, 15000, NULL, 'Código: 349', 'sede-pm-1'),
('prod-pm-441', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'MANZANA CANELA', 'DIFUSOR-MANZANA CANELA', 'HOGAR', 'cosmetica', 'PM-441', 5, 0, '2026-03-16', 9300, 15000, NULL, 'Código: 441', 'sede-pm-1'),
('prod-pm-s1-341', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'MARACUYA', 'DIFUSOR-MARACUYA', 'HOGAR', 'cosmetica', 'PM-S1-341', 0, 0, '2026-03-16', 9300, 15000, NULL, 'Código: 341', 'sede-pm-1'),
('prod-pm-s1-345', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'MELON', 'DIFUSOR-MELON', 'HOGAR', 'cosmetica', 'PM-S1-345', 2, 0, '2026-03-16', 9300, 15000, NULL, 'Código: 345', 'sede-pm-1'),
('prod-pm-s1-340', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'PIÑA', 'DIFUSOR-PIÑA', 'HOGAR', 'cosmetica', 'PM-S1-340', 3, 0, '2026-03-16', 9300, 15000, NULL, 'Código: 340', 'sede-pm-1'),
('prod-pm-350', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'PINO', 'DIFUSOR-PINO', 'HOGAR', 'cosmetica', 'PM-350', 10, 0, '2026-03-16', 9300, 15000, NULL, 'Código: 350', 'sede-pm-1'),
('prod-pm-405-b', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ROJOS SILVESTRES', 'DIFUSOR-ROJOS SILVESTRES', 'HOGAR', 'cosmetica', 'PM-405-B', 4, 0, '2026-03-16', 9300, 15000, NULL, 'Código: 405', 'sede-pm-1'),
('prod-pm-351', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'TUTTY FRUTTY', 'DIFUSOR-TUTTY FRUTTY', 'HOGAR', 'cosmetica', 'PM-351', 6, 0, '2026-03-16', 9300, 15000, NULL, 'Código: 351', 'sede-pm-1'),
('prod-pm-s1-342', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'VAINILLA', 'DIFUSOR-VAINILLA', 'HOGAR', 'cosmetica', 'PM-S1-342', 3, 0, '2026-03-16', 9300, 15000, NULL, 'Código: 342', 'sede-pm-1'),
('prod-pm-s1-344', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'VAINILLA TOST', 'DIFUSOR-VAINILLA TOST', 'HOGAR', 'cosmetica', 'PM-S1-344', 3, 0, '2026-03-16', 9300, 15000, NULL, 'Código: 344', 'sede-pm-1'),
('prod-pm-370', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'BLACK BERRY', 'ESENCIA HS-BLACK BERRY', 'HOGAR', 'cosmetica', 'PM-370', 7, 0, '2026-03-16', 5300, 10000, NULL, 'Código: 370', 'sede-pm-1'),
('prod-pm-375', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'BRISA MARINA', 'ESENCIA HS-BRISA MARINA', 'HOGAR', 'cosmetica', 'PM-375', 2, 0, '2026-03-16', 5300, 10000, NULL, 'Código: 375', 'sede-pm-1'),
('prod-pm-378', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'CASCARA MANDARINA', 'ESENCIA HS-CASCARA MANDARINA', 'HOGAR', 'cosmetica', 'PM-378', 4, 0, '2026-03-16', 5300, 10000, NULL, 'Código: 378', 'sede-pm-1'),
('prod-pm-381', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'COCO VAINILLA', 'ESENCIA HS-COCO VAINILLA', 'HOGAR', 'cosmetica', 'PM-381', 4, 0, '2026-03-16', 5300, 10000, NULL, 'Código: 381', 'sede-pm-1'),
('prod-pm-372', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'FANTASIA FRUTAL', 'ESENCIA HS-FANTASIA FRUTAL', 'HOGAR', 'cosmetica', 'PM-372', 0, 0, '2026-03-16', 5300, 10000, NULL, 'Código: 372', 'sede-pm-1'),
('prod-pm-374', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'FLORES ALGODON', 'ESENCIA HS-FLORES ALGODON', 'HOGAR', 'cosmetica', 'PM-374', 2, 0, '2026-03-16', 5300, 10000, NULL, 'Código: 374', 'sede-pm-1'),
('prod-pm-371', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'FRUTOS AMARILLOS', 'ESENCIA HS-FRUTOS AMARILLOS', 'HOGAR', 'cosmetica', 'PM-371', 5, 0, '2026-03-16', 5300, 10000, NULL, 'Código: 371', 'sede-pm-1'),
('prod-pm-379', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'FRUTOS ROJOS', 'ESENCIA HS-FRUTOS ROJOS', 'HOGAR', 'cosmetica', 'PM-379', 2, 0, '2026-03-16', 5300, 10000, NULL, 'Código: 379', 'sede-pm-1'),
('prod-pm-380', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'MARACUYA', 'ESENCIA HS-MARACUYA', 'HOGAR', 'cosmetica', 'PM-380', 3, 0, '2026-03-16', 5300, 10000, NULL, 'Código: 380', 'sede-pm-1'),
('prod-pm-377', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'MENTA FRESCA', 'ESENCIA HS-MENTA FRESCA', 'HOGAR', 'cosmetica', 'PM-377', 0, 0, '2026-03-16', 5300, 10000, NULL, 'Código: 377', 'sede-pm-1'),
('prod-pm-376', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ROLLOS CANELA', 'ESENCIA HS-ROLLOS CANELA', 'HOGAR', 'cosmetica', 'PM-376', 3, 0, '2026-03-16', 5300, 10000, NULL, 'Código: 376', 'sede-pm-1'),
('prod-pm-373', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'TUTTY FRUTTY', 'ESENCIA HS-TUTTY FRUTTY', 'HOGAR', 'cosmetica', 'PM-373', 0, 0, '2026-03-16', 5300, 10000, NULL, 'Código: 373', 'sede-pm-1'),
('prod-pm-385', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'CANELA', 'ESENCIA PB-CANELA', 'HOGAR', 'cosmetica', 'PM-385', 2, 0, '2026-03-16', 4200, 8000, NULL, 'Código: 385', 'sede-pm-1'),
('prod-pm-382', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'CANNES AIR', 'ESENCIA PB-CANNES AIR', 'HOGAR', 'cosmetica', 'PM-382', 2, 0, '2026-03-16', 4200, 8000, NULL, 'Código: 382', 'sede-pm-1'),
('prod-pm-389', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'COCO', 'ESENCIA PB-COCO', 'HOGAR', 'cosmetica', 'PM-389', 2, 0, '2026-03-16', 4200, 8000, NULL, 'Código: 389', 'sede-pm-1'),
('prod-pm-383', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'FRAMBUESA', 'ESENCIA PB-FRAMBUESA', 'HOGAR', 'cosmetica', 'PM-383', 0, 0, '2026-03-16', 4200, 8000, NULL, 'Código: 383', 'sede-pm-1'),
('prod-pm-386', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'FRESCO BAMBOO', 'ESENCIA PB-FRESCO BAMBOO', 'HOGAR', 'cosmetica', 'PM-386', 0, 0, '2026-03-16', 4200, 8000, NULL, 'Código: 386', 'sede-pm-1'),
('prod-pm-388', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LIMON', 'ESENCIA PB-LIMON', 'HOGAR', 'cosmetica', 'PM-388', 2, 0, '2026-03-16', 4200, 8000, NULL, 'Código: 388', 'sede-pm-1'),
('prod-pm-381-b', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'SANDALO', 'ESENCIA PB-SANDALO', 'HOGAR', 'cosmetica', 'PM-381-B', 3, 0, '2026-03-16', 4200, 8000, NULL, 'Código: 381', 'sede-pm-1'),
('prod-pm-384', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'TUTTY FRUTTY', 'ESENCIA PB-TUTTY FRUTTY', 'HOGAR', 'cosmetica', 'PM-384', 2, 0, '2026-03-16', 4200, 8000, NULL, 'Código: 384', 'sede-pm-1'),
('prod-pm-387', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'VAINILLA', 'ESENCIA PB-VAINILLA', 'HOGAR', 'cosmetica', 'PM-387', 1, 0, '2026-03-16', 4200, 8000, NULL, 'Código: 387', 'sede-pm-1'),
('prod-pm-392', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'PEBETERO', 'PEBETERO', 'HOGAR', 'cosmetica', 'PM-392', 9, 0, '2026-03-16', 24509, 45000, NULL, 'Código: 392', 'sede-pm-1'),
('prod-pm-354', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ALGODON', 'AGUA DE LINOS-ALGODON', 'HOGAR', 'cosmetica', 'PM-354', 4, 0, '2026-03-16', 5700, 15000, NULL, 'Código: 354', 'sede-pm-1'),
('prod-pm-355', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'FRESCURA DE ALGODON', 'AGUA DE LINOS-FRESCURA DE ALGODON', 'HOGAR', 'cosmetica', 'PM-355', 5, 0, '2026-03-16', 5700, 15000, NULL, 'Código: 355', 'sede-pm-1'),
('prod-pm-352', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'FRUTOS ROJOS', 'AGUA DE LINOS-FRUTOS ROJOS', 'HOGAR', 'cosmetica', 'PM-352', 10, 0, '2026-03-16', 5700, 15000, NULL, 'Código: 352', 'sede-pm-1'),
('prod-pm-s1-338', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'GOLD', 'AGUA DE LINOS-GOLD', 'HOGAR', 'cosmetica', 'PM-S1-338', 6, 0, '2026-03-16', 5700, 15000, NULL, 'Código: 338', 'sede-pm-1'),
('prod-pm-353', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'TAF PINK', 'AGUA DE LINOS-TAF PINK', 'HOGAR', 'cosmetica', 'PM-353', 6, 0, '2026-03-16', 5700, 15000, NULL, 'Código: 353', 'sede-pm-1'),
('prod-pm-s1-339', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'VAINILLA', 'AGUA DE LINOS-VAINILLA', 'HOGAR', 'cosmetica', 'PM-S1-339', 7, 0, '2026-03-16', 5700, 15000, NULL, 'Código: 339', 'sede-pm-1');

-- SEDE 1 — PERFUMERÍA ORIGINAL (210 filas)
INSERT INTO products (id, tenant_id, name, articulo, category, product_type, sku, stock, reorder_point, entry_date, purchase_price, sale_price, presentation, notes, sede_id) VALUES
('prod-pm-942', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'AFNAN-9 AM DIVE', 'ORI-AFNAN-9 AM DIVE-UNI', 'UNISEX', 'cosmetica', 'PM-942', 1, 0, '2026-03-16', 180000, 295000, NULL, 'Código: 942', 'sede-pm-1'),
('prod-pm-1043', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'AFNAN-9 PM ELIXIR', 'ORI-AFNAN-9 PM ELIXIR-MAS', 'CABALLEROS', 'cosmetica', 'PM-1043', 3, 0, '2026-03-16', 149000, 330000, NULL, 'Código: 1043', 'sede-pm-1'),
('prod-pm-s1-1024', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'AFNAN-9 PM REBEL', 'ORI-AFNAN-9 PM REBEL-UNI', 'UNISEX', 'cosmetica', 'PM-S1-1024', 1, 0, '2026-03-16', 147000, 295000, NULL, 'Código: 1024', 'sede-pm-1'),
('prod-pm-938', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'AFNAN-9 PM', 'ORI-AFNAN-9 PM-MAS', 'CABALLEROS', 'cosmetica', 'PM-938', 3, 0, '2026-03-16', 120000, 260000, NULL, 'Código: 938', 'sede-pm-1'),
('prod-pm-1042', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'AFNAN-KIANA CRUSH', 'ORI-AFNAN-KIANA CRUSH-FEM', 'DAMAS', 'cosmetica', 'PM-1042', 3, 0, '2026-03-16', 133000, 300000, NULL, 'Código: 1042', 'sede-pm-1'),
('prod-pm-s1-989', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'AFNAN-ORNAMENT', 'ORI-AFNAN-ORNAMENT-FEM', 'DAMAS', 'cosmetica', 'PM-S1-989', 2, 0, '2026-03-16', 89881, 200000, NULL, 'Código: 989', 'sede-pm-1'),
('prod-pm-983', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'AGATHA RUIZ PRADA-GOTAS DE COLOR', 'ORI-AGATHA RUIZ PRADA-GOTAS DE COLOR-FEM', 'DAMAS', 'cosmetica', 'PM-983', 2, 0, '2026-03-16', 110000, 199000, NULL, 'Código: 983', 'sede-pm-1'),
('prod-pm-1113', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'AHLI-OVERDOSE', 'ORI-AHLI-OVERDOSE-UNI', 'UNISEX', 'cosmetica', 'PM-1113', 0, 0, '2026-03-16', 297300, 570000, NULL, 'Código: 1113', 'sede-pm-1'),
('prod-pm-939', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'AL HARAMAIN-AMBER OUD GOLD', 'ORI-AL HARAMAIN-AMBER OUD GOLD-UNI', 'UNISEX', 'cosmetica', 'PM-939', 2, 0, '2026-03-16', 165486, 300000, NULL, 'Código: 939', 'sede-pm-1'),
('prod-pm-s1-1019', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'AL REHAB-CHOCO MUSK', 'ORI-AL REHAB-CHOCO MUSK-UNI', 'UNISEX', 'cosmetica', 'PM-S1-1019', 1, 0, '2026-03-16', 55000, 110000, NULL, 'Código: 1019', 'sede-pm-1'),
('prod-pm-947', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ANTONIO BANDERAS-BLUE SEDUCTION', 'ORI-ANTONIO BANDERAS-BLUE SEDUCTION-FEM', 'DAMAS', 'cosmetica', 'PM-947', 2, 0, '2026-03-16', 92300, 185000, NULL, 'Código: 947', 'sede-pm-1'),
('prod-pm-946', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ANTONIO BANDERAS-BLUE SEDUCTION', 'ORI-ANTONIO BANDERAS-BLUE SEDUCTION-MAS', 'CABALLEROS', 'cosmetica', 'PM-946', 1, 0, '2026-03-16', 105000, 190000, NULL, 'Código: 946', 'sede-pm-1'),
('prod-pm-1041', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ARABIYAT PRESTIGE-ASHAA NEROLI', 'ORI-ARABIYAT PRESTIGE-ASHAA NEROLI-UNI', 'UNISEX', 'cosmetica', 'PM-1041', 2, 0, '2026-03-16', 142358, 315000, NULL, 'Código: 1041', 'sede-pm-1'),
('prod-pm-1035', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ARABIYAT PRESTIGE-FONDUE LAVA LUSH', 'ORI-ARABIYAT PRESTIGE-FONDUE LAVA LUSH-UNI', 'UNISEX', 'cosmetica', 'PM-1035', 3, 0, '2026-03-16', 164473, 330000, NULL, 'Código: 1035', 'sede-pm-1'),
('prod-pm-1039', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ARABIYAT PRESTIGE-HABIB', 'ORI-ARABIYAT PRESTIGE-HABIB-MAS', 'CABALLEROS', 'cosmetica', 'PM-1039', 2, 0, '2026-03-16', 150000, 320000, NULL, 'Código: 1039', 'sede-pm-1'),
('prod-pm-1040', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ARABIYAT PRESTIGE-HABIBA', 'ORI-ARABIYAT PRESTIGE-HABIBA-FEM', 'DAMAS', 'cosmetica', 'PM-1040', 3, 0, '2026-03-16', 150000, 320000, NULL, 'Código: 1040', 'sede-pm-1'),
('prod-pm-997', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ARABIYAT PRESTIGE-LA DI DA', 'ORI-ARABIYAT PRESTIGE-LA DI DA-FEM', 'DAMAS', 'cosmetica', 'PM-997', 3, 0, '2026-03-16', 150000, 315000, NULL, 'Código: 997', 'sede-pm-1'),
('prod-pm-998', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ARABIYAT PRESTIGE-LA DI DA', 'ORI-ARABIYAT PRESTIGE-LA DI DA-MAS', 'CABALLEROS', 'cosmetica', 'PM-998', 2, 0, '2026-03-16', 146190, 315000, NULL, 'Código: 998', 'sede-pm-1'),
('prod-pm-1036', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ARABIYAT PRESTIGE-LUTFAH FIRST LOVE', 'ORI-ARABIYAT PRESTIGE-LUTFAH FIRST LOVE-FEM', 'DAMAS', 'cosmetica', 'PM-1036', 3, 0, '2026-03-16', 152410, 325000, NULL, 'Código: 1036', 'sede-pm-1'),
('prod-pm-996', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ARABIYAT PRESTIGE-MAHAD AL DHAHAB', 'ORI-ARABIYAT PRESTIGE-MAHAD AL DHAHAB-UNI', 'UNISEX', 'cosmetica', 'PM-996', 3, 0, '2026-03-16', 141800, 325000, NULL, 'Código: 996', 'sede-pm-1'),
('prod-pm-968', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ARIANA GRANDE-CLOUD PINK', 'ORI-ARIANA GRANDE-CLOUD PINK-FEM', 'DAMAS', 'cosmetica', 'PM-968', 1, 0, '2026-03-16', 226000, 420000, NULL, 'Código: 968', 'sede-pm-1'),
('prod-pm-921', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ARIANA GRANDE-CLOUD', 'ORI-ARIANA GRANDE-CLOUD-FEM', 'DAMAS', 'cosmetica', 'PM-921', 0, 0, '2026-03-16', 280000, 450000, NULL, 'Código: 921', 'sede-pm-1'),
('prod-pm-980', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ARIANA GRANDE-SWEET LIKE CANDY', 'ORI-ARIANA GRANDE-SWEET LIKE CANDY-FEM', 'DAMAS', 'cosmetica', 'PM-980', 0, 0, '2026-03-16', 235000, 420000, NULL, 'Código: 980', 'sede-pm-1'),
('prod-pm-922', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ARIANA GRANDE-THANK U NEXT', 'ORI-ARIANA GRANDE-THANK U NEXT-FEM', 'DAMAS', 'cosmetica', 'PM-922', 1, 0, '2026-03-16', 265000, 450000, NULL, 'Código: 922', 'sede-pm-1'),
('prod-pm-1102', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ARMAF-CLUB DE NUIT BLING', 'ORI-ARMAF-CLUB DE NUIT BLING-MAS', 'CABALLEROS', 'cosmetica', 'PM-1102', 3, 0, '2026-03-16', 179700, 360000, NULL, 'Código: 1102', 'sede-pm-1'),
('prod-pm-1048', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ARMAF-CLUB DE NUIT ICONIC', 'ORI-ARMAF-CLUB DE NUIT ICONIC-MAS', 'CABALLEROS', 'cosmetica', 'PM-1048', 3, 0, '2026-03-16', 157200, 315000, NULL, 'Código: 1048', 'sede-pm-1'),
('prod-pm-911', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ARMAF-CLUB DE NUIT INTENSE', 'ORI-ARMAF-CLUB DE NUIT INTENSE-MAS', 'CABALLEROS', 'cosmetica', 'PM-911', 0, 0, '2026-03-16', 124200, 260000, NULL, 'Código: 911', 'sede-pm-1'),
('prod-pm-999', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ARMAF-CLUB DE NUIT MALEKA', 'ORI-ARMAF-CLUB DE NUIT MALEKA-FEM', 'DAMAS', 'cosmetica', 'PM-999', 3, 0, '2026-03-16', 189000, 350000, NULL, 'Código: 999', 'sede-pm-1'),
('prod-pm-s1-1056', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ARMAF-CLUB DE NUIT PRECIEUX IV', 'ORI-ARMAF-CLUB DE NUIT PRECIEUX IV-FEM', 'DAMAS', 'cosmetica', 'PM-S1-1056', 2, 0, '2026-03-16', 216212, 399000, NULL, 'Código: 1056', 'sede-pm-1'),
('prod-pm-949', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ARMAF-CLUB DE NUIT SILLAGE', 'ORI-ARMAF-CLUB DE NUIT SILLAGE-UNI', 'UNISEX', 'cosmetica', 'PM-949', 3, 0, '2026-03-16', 147214, 285000, NULL, 'Código: 949', 'sede-pm-1'),
('prod-pm-1078', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ARMAF-CLUB DE NUIT UNTOLD', 'ORI-ARMAF-CLUB DE NUIT UNTOLD-UNI', 'UNISEX', 'cosmetica', 'PM-1078', 2, 0, '2026-03-16', 163000, 295000, NULL, 'Código: 1078', 'sede-pm-1'),
('prod-pm-s1-1010', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ARMAF-CLUB DE NUIT WOMAN', 'ORI-ARMAF-CLUB DE NUIT WOMAN-FEM', 'DAMAS', 'cosmetica', 'PM-S1-1010', 2, 0, '2026-03-16', 115000, 250000, NULL, 'Código: 1010', 'sede-pm-1'),
('prod-pm-1071', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ARMAF-ISLAND BLISS', 'ORI-ARMAF-ISLAND BLISS-FEM', 'DAMAS', 'cosmetica', 'PM-1071', 2, 0, '2026-03-16', 179385, 360000, NULL, 'Código: 1071', 'sede-pm-1'),
('prod-pm-s1-1060', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ARMAF-ISLAND BREEZE', 'ORI-ARMAF-ISLAND BREEZE-FEM', 'DAMAS', 'cosmetica', 'PM-S1-1060', 3, 0, '2026-03-16', 183000, 390000, NULL, 'Código: 1060', 'sede-pm-1'),
('prod-pm-950', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ARMAF-ODYSSEY AQUA', 'ORI-ARMAF-ODYSSEY AQUA-MAS', 'CABALLEROS', 'cosmetica', 'PM-950', 2, 0, '2026-03-16', 100522, 250000, NULL, 'Código: 950', 'sede-pm-1'),
('prod-pm-962', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ARMAF-ODYSSEY CANDEE', 'ORI-ARMAF-ODYSSEY CANDEE-FEM', 'DAMAS', 'cosmetica', 'PM-962', 0, 0, '2026-03-16', 250000, 420000, NULL, 'Código: 962', 'sede-pm-1'),
('prod-pm-1047', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ARMAF-ODYSSEY MANDARIN SKY ELIXIR', 'ORI-ARMAF-ODYSSEY MANDARIN SKY ELIXIR-MAS', 'CABALLEROS', 'cosmetica', 'PM-1047', 3, 0, '2026-03-16', 162779, 320000, NULL, 'Código: 1047', 'sede-pm-1'),
('prod-pm-941', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ARMAF-ODYSSEY MANDARIN SKY', 'ORI-ARMAF-ODYSSEY MANDARIN SKY-MAS', 'CABALLEROS', 'cosmetica', 'PM-941', 0, 0, '2026-03-16', 127760, 275000, NULL, 'Código: 941', 'sede-pm-1'),
('prod-pm-992', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ARMAF-ODYSSEY WHITE EDITION', 'ORI-ARMAF-ODYSSEY WHITE EDITION-MAS', 'CABALLEROS', 'cosmetica', 'PM-992', 3, 0, '2026-03-16', 115412, 250000, NULL, 'Código: 992', 'sede-pm-1'),
('prod-pm-s1-990', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ARMAF-SPACE AGE', 'ORI-ARMAF-SPACE AGE-FEM', 'DAMAS', 'cosmetica', 'PM-S1-990', 0, 0, '2026-03-16', 95097, 239000, NULL, 'Código: 990', 'sede-pm-1'),
('prod-pm-s1-991', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ARMAF-TAG HER', 'ORI-ARMAF-TAG HER-FEM', 'DAMAS', 'cosmetica', 'PM-S1-991', 2, 0, '2026-03-16', 94000, 200000, NULL, 'Código: 991', 'sede-pm-1'),
('prod-pm-1072', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ARMAF-TAG HIM UOMO ROSSO', 'ORI-ARMAF-TAG HIM UOMO ROSSO-MAS', 'CABALLEROS', 'cosmetica', 'PM-1072', 3, 0, '2026-03-16', 130368, 265000, NULL, 'Código: 1072', 'sede-pm-1'),
('prod-pm-971', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ARMAF-YUM YUM', 'ORI-ARMAF-YUM YUM-FEM', 'DAMAS', 'cosmetica', 'PM-971', 2, 0, '2026-03-16', 170000, 360000, NULL, 'Código: 971', 'sede-pm-1'),
('prod-pm-978', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'AZZARO-AZZARO POUR HOMME', 'ORI-AZZARO-AZZARO POUR HOMME-MAS', 'CABALLEROS', 'cosmetica', 'PM-978', 1, 0, '2026-03-16', 143000, 275000, NULL, 'Código: 978', 'sede-pm-1'),
('prod-pm-965', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'BEVERLY HILLS-TOUCH', 'ORI-BEVERLY HILLS-TOUCH-FEM', 'DAMAS', 'cosmetica', 'PM-965', 1, 0, '2026-03-16', 93000, 190000, NULL, 'Código: 965', 'sede-pm-1'),
('prod-pm-1033', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'BH MAST PERFUME-GORGEOUS BLUSH', 'ORI-BH MAST PERFUME-GORGEOUS BLUSH-FEM', 'DAMAS', 'cosmetica', 'PM-1033', 2, 0, '2026-03-16', 108300, 255000, NULL, 'Código: 1033', 'sede-pm-1'),
('prod-pm-1097', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'BH MAST PERFUME-IVORY', 'ORI-BH MAST PERFUME-IVORY-MAS', 'CABALLEROS', 'cosmetica', 'PM-1097', 3, 0, '2026-03-16', 125302, 275000, NULL, 'Código: 1097', 'sede-pm-1'),
('prod-pm-1061', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'BH MAST PERFUME-ROME EXTRADOSE', 'ORI-BH MAST PERFUME-ROME EXTRADOSE-MAS', 'CABALLEROS', 'cosmetica', 'PM-1061', 1, 0, '2026-03-16', 126466, 285000, NULL, 'Código: 1061', 'sede-pm-1'),
('prod-pm-1100', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'BH MAST PERFUME-ROME PARADOXE', 'ORI-BH MAST PERFUME-ROME PARADOXE-FEM', 'DAMAS', 'cosmetica', 'PM-1100', 3, 0, '2026-03-16', 112000, 255000, NULL, 'Código: 1100', 'sede-pm-1'),
('prod-pm-s1-1003', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'BH MAST PERFUME-ROME POUR FEMME', 'ORI-BH MAST PERFUME-ROME POUR FEMME-FEM', 'DAMAS', 'cosmetica', 'PM-S1-1003', 3, 0, '2026-03-16', 114141, 250000, NULL, 'Código: 1003', 'sede-pm-1'),
('prod-pm-s1-1021', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'BH MAST PERFUME-ROME POUR HOMME', 'ORI-BH MAST PERFUME-ROME POUR HOMME-MAS', 'CABALLEROS', 'cosmetica', 'PM-S1-1021', 2, 0, '2026-03-16', 112000, 250000, NULL, 'Código: 1021', 'sede-pm-1'),
('prod-pm-s1-1067', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'BHARARA-CHAMPAGNE PINK', 'ORI-BHARARA-CHAMPAGNE PINK-FEM', 'DAMAS', 'cosmetica', 'PM-S1-1067', 2, 0, '2026-03-16', 101103, 250000, NULL, 'Código: 1067', 'sede-pm-1'),
('prod-pm-1038', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'BHARARA-ENIGMA', 'ORI-BHARARA-ENIGMA-UNI', 'UNISEX', 'cosmetica', 'PM-1038', 2, 0, '2026-03-16', 196641, 365000, NULL, 'Código: 1038', 'sede-pm-1'),
('prod-pm-929', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'BHARARA-KING', 'ORI-BHARARA-KING-MAS', 'CABALLEROS', 'cosmetica', 'PM-929', 2, 0, '2026-03-16', 183000, 380000, NULL, 'Código: 929', 'sede-pm-1'),
('prod-pm-1050', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'BHARARA-NICHE FEMME', 'ORI-BHARARA-NICHE FEMME-FEM', 'DAMAS', 'cosmetica', 'PM-1050', 1, 0, '2026-03-16', 191960, 370000, NULL, 'Código: 1050', 'sede-pm-1'),
('prod-pm-1079', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'BHARARA-NICHE', 'ORI-BHARARA-NICHE-UNI', 'UNISEX', 'cosmetica', 'PM-1079', 3, 0, '2026-03-16', 185740, 360000, NULL, 'Código: 1079', 'sede-pm-1'),
('prod-pm-928', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'BILLIE EILISH-EILISH', 'ORI-BILLIE EILISH-EILISH-FEM', 'DAMAS', 'cosmetica', 'PM-928', 1, 0, '2026-03-16', 280000, 489000, NULL, 'Código: 928', 'sede-pm-1'),
('prod-pm-945', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'BRITNEY SPEARS-FANTASY', 'ORI-BRITNEY SPEARS-FANTASY-FEM', 'DAMAS', 'cosmetica', 'PM-945', 1, 0, '2026-03-16', 88300, 195000, NULL, 'Código: 945', 'sede-pm-1'),
('prod-pm-s1-1011', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'BURBERRY-BURBERRY CLASSIC', 'ORI-BURBERRY-BURBERRY CLASSIC-FEM', 'DAMAS', 'cosmetica', 'PM-S1-1011', 3, 0, '2026-03-16', 153000, 289000, NULL, 'Código: 1011', 'sede-pm-1'),
('prod-pm-s1-1022', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'BURBERRY-BURBERRY HER', 'ORI-BURBERRY-BURBERRY HER-FEM', 'DAMAS', 'cosmetica', 'PM-S1-1022', 1, 0, '2026-03-16', 391536, 655000, NULL, 'Código: 1022', 'sede-pm-1'),
('prod-pm-s1-1054', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'BVLGARI-OMNIA PINK SAPHIRE', 'ORI-BVLGARI-OMNIA PINK SAPHIRE-FEM', 'DAMAS', 'cosmetica', 'PM-S1-1054', 0, 0, '2026-03-16', 293000, 545000, NULL, 'Código: 1054', 'sede-pm-1'),
('prod-pm-s1-1028', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'CALVIN KLEIN-CK BE', 'ORI-CALVIN KLEIN-CK BE-MAS', 'CABALLEROS', 'cosmetica', 'PM-S1-1028', 2, 0, '2026-03-16', 92000, 200000, NULL, 'Código: 1028', 'sede-pm-1'),
('prod-pm-916', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'CALVIN KLEIN-CK IN2U', 'ORI-CALVIN KLEIN-CK IN2U-FEM', 'DAMAS', 'cosmetica', 'PM-916', 2, 0, '2026-03-16', 107000, 210000, NULL, 'Código: 916', 'sede-pm-1'),
('prod-pm-s1-1027', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'CALVIN KLEIN-CK ONE', 'ORI-CALVIN KLEIN-CK ONE-UNI', 'UNISEX', 'cosmetica', 'PM-S1-1027', 1, 0, '2026-03-16', 114000, 215000, NULL, 'Código: 1027', 'sede-pm-1'),
('prod-pm-1075', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'CALVIN KLEIN-CK SHOCK', 'ORI-CALVIN KLEIN-CK SHOCK-FEM', 'DAMAS', 'cosmetica', 'PM-1075', 0, 0, '2026-03-16', 144000, 260000, NULL, 'Código: 1075', 'sede-pm-1'),
('prod-pm-1092', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'CAROLINA HERRERA-212 SEXY', 'ORI-CAROLINA HERRERA-212 SEXY-FEM', 'DAMAS', 'cosmetica', 'PM-1092', 1, 0, '2026-03-16', 298000, 520000, NULL, 'Código: 1092', 'sede-pm-1'),
('prod-pm-s1-1012', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'CAROLINA HERRERA-212 VIP ROSE', 'ORI-CAROLINA HERRERA-212 VIP ROSE-FEM', 'DAMAS', 'cosmetica', 'PM-S1-1012', 1, 0, '2026-03-16', 375000, 669000, NULL, 'Código: 1012', 'sede-pm-1'),
('prod-pm-904', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'CAROLINA HERRERA-212 VIP', 'ORI-CAROLINA HERRERA-212 VIP-MAS', 'CABALLEROS', 'cosmetica', 'PM-904', 0, 0, '2026-03-16', 235000, 410000, NULL, 'Código: 904', 'sede-pm-1'),
('prod-pm-905', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'CAROLINA HERRERA-212', 'ORI-CAROLINA HERRERA-212-MAS', 'CABALLEROS', 'cosmetica', 'PM-905', 1, 0, '2026-03-16', 247300, 495000, NULL, 'Código: 905', 'sede-pm-1'),
('prod-pm-924', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'CAROLINA HERRERA-GOOD GIRL', 'ORI-CAROLINA HERRERA-GOOD GIRL-FEM', 'DAMAS', 'cosmetica', 'PM-924', 0, 0, '2026-03-16', 435000, 660000, NULL, 'Código: 924', 'sede-pm-1'),
('prod-pm-907', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'CRISTIANO RONALDO-CR7 ORIGINS', 'ORI-CRISTIANO RONALDO-CR7 ORIGINS-MAS', 'CABALLEROS', 'cosmetica', 'PM-907', 0, 0, '2026-03-16', 160000, 270000, NULL, 'Código: 907', 'sede-pm-1'),
('prod-pm-943', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'DIESEL-DIESEL PLUS', 'ORI-DIESEL-DIESEL PLUS-MAS', 'CABALLEROS', 'cosmetica', 'PM-943', 1, 0, '2026-03-16', 33000, 100000, NULL, 'Código: 943', 'sede-pm-1'),
('prod-pm-926', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'DIESEL-DIESEL ZERO PLUS', 'ORI-DIESEL-DIESEL ZERO PLUS-FEM', 'DAMAS', 'cosmetica', 'PM-926', 1, 0, '2026-03-16', 32300, 100000, NULL, 'Código: 926', 'sede-pm-1'),
('prod-pm-1112', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'DIESEL-DIESEL ZERO PLUS', 'ORI-DIESEL-DIESEL ZERO PLUS-MAS', 'CABALLEROS', 'cosmetica', 'PM-1112', 3, 0, '2026-03-16', 32300, 100000, NULL, 'Código: 1112', 'sede-pm-1'),
('prod-pm-s1-1008', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'DOLCE GABBANA-KING', 'ORI-DOLCE GABBANA-KING-MAS', 'CABALLEROS', 'cosmetica', 'PM-S1-1008', 1, 0, '2026-03-16', 194000, 369000, NULL, 'Código: 1008', 'sede-pm-1'),
('prod-pm-s1-1009', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'DOLCE GABBANA-LIGHT BLUE', 'ORI-DOLCE GABBANA-LIGHT BLUE-FEM', 'DAMAS', 'cosmetica', 'PM-S1-1009', 1, 0, '2026-03-16', 223000, 410000, NULL, 'Código: 1009', 'sede-pm-1'),
('prod-pm-1101', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'DUMONT PARIS-NITRO ELIXIR', 'ORI-DUMONT PARIS-NITRO ELIXIR-MAS', 'CABALLEROS', 'cosmetica', 'PM-1101', 1, 0, '2026-03-16', 155900, 325000, NULL, 'Código: 1101', 'sede-pm-1'),
('prod-pm-1098', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'DUMONT PARIS-NITRO RED INTENSELY', 'ORI-DUMONT PARIS-NITRO RED INTENSELY-MAS', 'CABALLEROS', 'cosmetica', 'PM-1098', 3, 0, '2026-03-16', 162700, 335000, NULL, 'Código: 1098', 'sede-pm-1'),
('prod-pm-982', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'DUMONT PARIS-NITRO RED POUR HOMME', 'ORI-DUMONT PARIS-NITRO RED POUR HOMME-MAS', 'CABALLEROS', 'cosmetica', 'PM-982', 0, 0, '2026-03-16', 165000, 295000, NULL, 'Código: 982', 'sede-pm-1'),
('prod-pm-1034', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'DUMONT PARIS-SOPRANO ICE', 'ORI-DUMONT PARIS-SOPRANO ICE-UNI', 'UNISEX', 'cosmetica', 'PM-1034', 2, 0, '2026-03-16', 135120, 275000, NULL, 'Código: 1034', 'sede-pm-1'),
('prod-pm-1070', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'EMPER-ARABIA BON VOYAGE', 'ORI-EMPER-ARABIA BON VOYAGE-FEM', 'DAMAS', 'cosmetica', 'PM-1070', 2, 0, '2026-03-16', 98930, 210000, NULL, 'Código: 1070', 'sede-pm-1'),
('prod-pm-972', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'EMPER-STALLION 53', 'ORI-EMPER-STALLION 53-UNI', 'UNISEX', 'cosmetica', 'PM-972', 1, 0, '2026-03-16', 135000, 245000, NULL, 'Código: 972', 'sede-pm-1'),
('prod-pm-966', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ESCADA-SORBETTO ROSSO', 'ORI-ESCADA-SORBETTO ROSSO-FEM', 'DAMAS', 'cosmetica', 'PM-966', 1, 0, '2026-03-16', 175000, 300000, NULL, 'Código: 966', 'sede-pm-1'),
('prod-pm-954', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'FCB BARCELONA', 'ORI-FCB BARCELONA-UNI', 'UNISEX', 'cosmetica', 'PM-954', 0, 0, '2026-03-16', 90000, 165000, NULL, 'Código: 954', 'sede-pm-1'),
('prod-pm-s1-1064', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'FRAGANCE WORLD-AETHER EXTRAIT', 'ORI-FRAGANCE WORLD-AETHER EXTRAIT-UNI', 'UNISEX', 'cosmetica', 'PM-S1-1064', 2, 0, '2026-03-16', 173296, 335000, NULL, 'Código: 1064', 'sede-pm-1'),
('prod-pm-993', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'FRAGANCE WORLD-CARAMEL MACCHIATO', 'ORI-FRAGANCE WORLD-CARAMEL MACCHIATO-UNI', 'UNISEX', 'cosmetica', 'PM-993', 3, 0, '2026-03-16', 100314, 250000, NULL, 'Código: 993', 'sede-pm-1'),
('prod-pm-s1-1059', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'FRAGANCE WORLD-LIQUID BRUN', 'ORI-FRAGANCE WORLD-LIQUID BRUN-UNI', 'UNISEX', 'cosmetica', 'PM-S1-1059', 3, 0, '2026-03-16', 141000, 319000, NULL, 'Código: 1059', 'sede-pm-1'),
('prod-pm-1049', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'FRAGANCE WORLD-VENENO NEGRO', 'ORI-FRAGANCE WORLD-VENENO NEGRO-UNI', 'UNISEX', 'cosmetica', 'PM-1049', 2, 0, '2026-03-16', 180288, 360000, NULL, 'Código: 1049', 'sede-pm-1'),
('prod-pm-s1-1063', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'FRAGANCE WORLD-VULCAN BAIE', 'ORI-FRAGANCE WORLD-VULCAN BAIE-FEM', 'DAMAS', 'cosmetica', 'PM-S1-1063', 3, 0, '2026-03-16', 194751, 360000, NULL, 'Código: 1063', 'sede-pm-1'),
('prod-pm-906', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'GILLES CANTUEL-ARSENAL BLUE', 'ORI-GILLES CANTUEL-ARSENAL BLUE-MAS', 'CABALLEROS', 'cosmetica', 'PM-906', 0, 0, '2026-03-16', 90000, 185000, NULL, 'Código: 906', 'sede-pm-1'),
('prod-pm-940', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'GILLES CANTUEL-ARSENAL RED', 'ORI-GILLES CANTUEL-ARSENAL RED-MAS', 'CABALLEROS', 'cosmetica', 'PM-940', 1, 0, '2026-03-16', 90000, 185000, NULL, 'Código: 940', 'sede-pm-1'),
('prod-pm-s1-1006', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'GIORGIO ARMANI-ACQUA DI GIO PROFONDO EDP', 'ORI-GIORGIO ARMANI-ACQUA DI GIO PROFONDO EDP-MAS', 'CABALLEROS', 'cosmetica', 'PM-S1-1006', 2, 0, '2026-03-16', 409743, 699000, NULL, 'Código: 1006', 'sede-pm-1'),
('prod-pm-1099', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'GRANDEUR TUBBES-BERRY EXPLOSION', 'ORI-GRANDEUR TUBBES-BERRY EXPLOSION-UNI', 'UNISEX', 'cosmetica', 'PM-1099', 2, 0, '2026-03-16', 59000, 145000, NULL, 'Código: 1099', 'sede-pm-1'),
('prod-pm-1103', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'GRANDEUR TUBBES-PASSION FRUIT MOJITO', 'ORI-GRANDEUR TUBBES-PASSION FRUIT MOJITO-UNI', 'UNISEX', 'cosmetica', 'PM-1103', 2, 0, '2026-03-16', 59000, 145000, NULL, 'Código: 1103', 'sede-pm-1'),
('prod-pm-1104', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'GRANDEUR TUBBES-STRAWBERRY CHEESECAKE', 'ORI-GRANDEUR TUBBES-STRAWBERRY CHEESECAKE-UNI', 'UNISEX', 'cosmetica', 'PM-1104', 1, 0, '2026-03-16', 49900, 145000, NULL, 'Código: 1104', 'sede-pm-1'),
('prod-pm-977', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'GUCCI-GUCCI GUILTY POUR HOMME', 'ORI-GUCCI-GUCCI GUILTY POUR HOMME-MAS', 'CABALLEROS', 'cosmetica', 'PM-977', 1, 0, '2026-03-16', 305000, 545000, NULL, 'Código: 977', 'sede-pm-1'),
('prod-pm-1087', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'HINODE-EMPIRE ICON', 'ORI-HINODE-EMPIRE ICON-MAS', 'CABALLEROS', 'cosmetica', 'PM-1087', 0, 0, '2026-03-16', 94500, 189000, NULL, 'Código: 1087', 'sede-pm-1'),
('prod-pm-1083', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'HINODE-EMPIRE Y CREMA', 'ORI-HINODE-EMPIRE Y CREMA-FEM', 'DAMAS', 'cosmetica', 'PM-1083', 1, 0, '2026-03-16', 107000, 214000, NULL, 'Código: 1083', 'sede-pm-1'),
('prod-pm-s1-1051', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'HINODE-INEBRIANTE', 'ORI-HINODE-INEBRIANTE-MAS', 'CABALLEROS', 'cosmetica', 'PM-S1-1051', 1, 0, '2026-03-16', 173000, 300000, NULL, 'Código: 1051', 'sede-pm-1'),
('prod-pm-1088', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'HINODE-KIT MINI EMPIRE', 'ORI-HINODE-KIT MINI EMPIRE-MAS', 'CABALLEROS', 'cosmetica', 'PM-1088', 1, 0, '2026-03-16', 94500, 189000, NULL, 'Código: 1088', 'sede-pm-1'),
('prod-pm-1086', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'HINODE-LATTITUDE EXPEDITION', 'ORI-HINODE-LATTITUDE EXPEDITION-MAS', 'CABALLEROS', 'cosmetica', 'PM-1086', 0, 0, '2026-03-16', 75000, 150000, NULL, 'Código: 1086', 'sede-pm-1'),
('prod-pm-1080', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'HINODE-LURE', 'ORI-HINODE-LURE-FEM', 'DAMAS', 'cosmetica', 'PM-1080', 0, 0, '2026-03-16', 69500, 139000, NULL, 'Código: 1080', 'sede-pm-1'),
('prod-pm-1082', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'HINODE-REBELLE MADNESS', 'ORI-HINODE-REBELLE MADNESS-FEM', 'DAMAS', 'cosmetica', 'PM-1082', 0, 0, '2026-03-16', 75000, 150000, NULL, 'Código: 1082', 'sede-pm-1'),
('prod-pm-1081', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'HINODE-SPOT SUNSET', 'ORI-HINODE-SPOT SUNSET-FEM', 'DAMAS', 'cosmetica', 'PM-1081', 0, 0, '2026-03-16', 74000, 148000, NULL, 'Código: 1081', 'sede-pm-1'),
('prod-pm-1084', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'HINODE-VIBEZ', 'ORI-HINODE-VIBEZ-FEM', 'DAMAS', 'cosmetica', 'PM-1084', 0, 0, '2026-03-16', 77500, 155000, NULL, 'Código: 1084', 'sede-pm-1'),
('prod-pm-1085', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'HINODE-VIBEZ', 'ORI-HINODE-VIBEZ-MAS', 'CABALLEROS', 'cosmetica', 'PM-1085', 0, 0, '2026-03-16', 77500, 155000, NULL, 'Código: 1085', 'sede-pm-1'),
('prod-pm-908', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ISSEY MIYAKE-ISSEY MIYAKE', 'ORI-ISSEY MIYAKE-ISSEY MIYAKE-MAS', 'CABALLEROS', 'cosmetica', 'PM-908', 1, 0, '2026-03-16', 170000, 340000, NULL, 'Código: 908', 'sede-pm-1'),
('prod-pm-1096', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ISSEY MIYAKE-SET 2 PCS', 'ORI-ISSEY MIYAKE-SET 2 PCS-MAS', 'CABALLEROS', 'cosmetica', 'PM-1096', 1, 0, '2026-03-16', 150600, 380000, NULL, 'Código: 1096', 'sede-pm-1'),
('prod-pm-948', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'JEAN PAUL GAULTIER-LE MALE ELIXIR', 'ORI-JEAN PAUL GAULTIER-LE MALE ELIXIR-MAS', 'CABALLEROS', 'cosmetica', 'PM-948', 1, 0, '2026-03-16', 433000, 755000, NULL, 'Código: 948', 'sede-pm-1'),
('prod-pm-985', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'JO MILANO-GAME OF SPADES ROYALE', 'ORI-JO MILANO-GAME OF SPADES ROYALE-UNI', 'UNISEX', 'cosmetica', 'PM-985', 2, 0, '2026-03-16', 270156, 485000, NULL, 'Código: 985', 'sede-pm-1'),
('prod-pm-s1-1014', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'KHADLAJ-ISLAND', 'ORI-KHADLAJ-ISLAND-UNI', 'UNISEX', 'cosmetica', 'PM-S1-1014', 2, 0, '2026-03-16', 125000, 265000, NULL, 'Código: 1014', 'sede-pm-1'),
('prod-pm-975', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LACOSTE- L12.12. BLANC', 'ORI-LACOSTE- L12.12. BLANC-MAS', 'CABALLEROS', 'cosmetica', 'PM-975', 1, 0, '2026-03-16', 235000, 420000, NULL, 'Código: 975', 'sede-pm-1'),
('prod-pm-s1-986', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LACOSTE-TOUCH OF PINK', 'ORI-LACOSTE-TOUCH OF PINK-FEM', 'DAMAS', 'cosmetica', 'PM-S1-986', 1, 0, '2026-03-16', 187000, 400000, NULL, 'Código: 986', 'sede-pm-1'),
('prod-pm-1046', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LATTAFA-AFEEF', 'ORI-LATTAFA-AFEEF-UNI', 'UNISEX', 'cosmetica', 'PM-1046', 1, 0, '2026-03-16', 131900, 300000, NULL, 'Código: 1046', 'sede-pm-1'),
('prod-pm-957', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LATTAFA-AJWAD', 'ORI-LATTAFA-AJWAD-UNI', 'UNISEX', 'cosmetica', 'PM-957', 3, 0, '2026-03-16', 93000, 219000, NULL, 'Código: 957', 'sede-pm-1'),
('prod-pm-937', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LATTAFA-AL NOBLE AMEER', 'ORI-LATTAFA-AL NOBLE AMEER-UNI', 'UNISEX', 'cosmetica', 'PM-937', 0, 0, '2026-03-16', 155000, 270000, NULL, 'Código: 937', 'sede-pm-1'),
('prod-pm-936', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LATTAFA-AL NOBLE SAFEER', 'ORI-LATTAFA-AL NOBLE SAFEER-UNI', 'UNISEX', 'cosmetica', 'PM-936', 1, 0, '2026-03-16', 92335, 250000, NULL, 'Código: 936', 'sede-pm-1'),
('prod-pm-933', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LATTAFA-AMETHYST', 'ORI-LATTAFA-AMETHYST-UNI', 'UNISEX', 'cosmetica', 'PM-933', 2, 0, '2026-03-16', 100000, 250000, NULL, 'Código: 933', 'sede-pm-1'),
('prod-pm-1105', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LATTAFA-ANGHAM', 'ORI-LATTAFA-ANGHAM-UNI', 'UNISEX', 'cosmetica', 'PM-1105', 2, 0, '2026-03-16', 123000, 265000, NULL, 'Código: 1105', 'sede-pm-1'),
('prod-pm-s1-1030', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LATTAFA-ANSAAM GOLD', 'ORI-LATTAFA-ANSAAM GOLD-UNI', 'UNISEX', 'cosmetica', 'PM-S1-1030', 2, 0, '2026-03-16', 112000, 265500, NULL, 'Código: 1030', 'sede-pm-1'),
('prod-pm-984', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LATTAFA-ART OF UNIVERSE', 'ORI-LATTAFA-ART OF UNIVERSE-UNI', 'UNISEX', 'cosmetica', 'PM-984', 2, 0, '2026-03-16', 260000, 460000, NULL, 'Código: 984', 'sede-pm-1'),
('prod-pm-s1-1065', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LATTAFA-ASAD BOURBON', 'ORI-LATTAFA-ASAD BOURBON-MAS', 'CABALLEROS', 'cosmetica', 'PM-S1-1065', 3, 0, '2026-03-16', 113300, 255000, NULL, 'Código: 1065', 'sede-pm-1'),
('prod-pm-1077', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LATTAFA-ASAD ELIXIR', 'ORI-LATTAFA-ASAD ELIXIR-MAS', 'CABALLEROS', 'cosmetica', 'PM-1077', 2, 0, '2026-03-16', 137000, 325000, NULL, 'Código: 1077', 'sede-pm-1'),
('prod-pm-910', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LATTAFA-ASAD', 'ORI-LATTAFA-ASAD-MAS', 'CABALLEROS', 'cosmetica', 'PM-910', 2, 0, '2026-03-16', 100000, 240000, NULL, 'Código: 910', 'sede-pm-1'),
('prod-pm-s1-1057', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LATTAFA-ATHEERI', 'ORI-LATTAFA-ATHEERI-UNI', 'UNISEX', 'cosmetica', 'PM-S1-1057', 3, 0, '2026-03-16', 145976, 285000, NULL, 'Código: 1057', 'sede-pm-1'),
('prod-pm-s1-1066', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LATTAFA-BERRY ON TOP', 'ORI-LATTAFA-BERRY ON TOP-UNI', 'UNISEX', 'cosmetica', 'PM-S1-1066', 1, 0, '2026-03-16', 171339, 339000, NULL, 'Código: 1066', 'sede-pm-1'),
('prod-pm-s1-1023', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LATTAFA-ECLAIRE', 'ORI-LATTAFA-ECLAIRE-FEM', 'DAMAS', 'cosmetica', 'PM-S1-1023', 1, 0, '2026-03-16', 120000, 260000, NULL, 'Código: 1023', 'sede-pm-1'),
('prod-pm-958', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LATTAFA-EMEER', 'ORI-LATTAFA-EMEER-UNI', 'UNISEX', 'cosmetica', 'PM-958', 3, 0, '2026-03-16', 145269, 309000, NULL, 'Código: 958', 'sede-pm-1'),
('prod-pm-s1-1005', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LATTAFA-FAKHAR GOLD EXT', 'ORI-LATTAFA-FAKHAR GOLD EXT-UNI', 'UNISEX', 'cosmetica', 'PM-S1-1005', 2, 0, '2026-03-16', 95000, 240000, NULL, 'Código: 1005', 'sede-pm-1'),
('prod-pm-979', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LATTAFA-FAKHAR ROSE', 'ORI-LATTAFA-FAKHAR ROSE-FEM', 'DAMAS', 'cosmetica', 'PM-979', 3, 0, '2026-03-16', 114385, 250000, NULL, 'Código: 979', 'sede-pm-1'),
('prod-pm-960', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LATTAFA-FAKHAR', 'ORI-LATTAFA-FAKHAR-MAS', 'CABALLEROS', 'cosmetica', 'PM-960', 0, 0, '2026-03-16', 130000, 255000, NULL, 'Código: 960', 'sede-pm-1'),
('prod-pm-1037', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LATTAFA-FIRE ON ICE', 'ORI-LATTAFA-FIRE ON ICE-UNI', 'UNISEX', 'cosmetica', 'PM-1037', 2, 0, '2026-03-16', 170505, 345000, NULL, 'Código: 1037', 'sede-pm-1'),
('prod-pm-923', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LATTAFA-HAYA', 'ORI-LATTAFA-HAYA-FEM', 'DAMAS', 'cosmetica', 'PM-923', 2, 0, '2026-03-16', 99000, 250000, NULL, 'Código: 923', 'sede-pm-1'),
('prod-pm-994', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LATTAFA-HAYAATI', 'ORI-LATTAFA-HAYAATI-MAS', 'CABALLEROS', 'cosmetica', 'PM-994', 1, 0, '2026-03-16', 85709, 240000, NULL, 'Código: 994', 'sede-pm-1'),
('prod-pm-959', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LATTAFA-HER CONFESSION', 'ORI-LATTAFA-HER CONFESSION-FEM', 'DAMAS', 'cosmetica', 'PM-959', 1, 0, '2026-03-16', 270000, 460000, NULL, 'Código: 959', 'sede-pm-1'),
('prod-pm-964', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LATTAFA-HONOR Y GLORY', 'ORI-LATTAFA-HONOR Y GLORY-UNI', 'UNISEX', 'cosmetica', 'PM-964', 3, 0, '2026-03-16', 99500, 250000, NULL, 'Código: 964', 'sede-pm-1'),
('prod-pm-1106', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LATTAFA-ISHQ AL SHUYUKH SILVER', 'ORI-LATTAFA-ISHQ AL SHUYUKH SILVER-MAS', 'CABALLEROS', 'cosmetica', 'PM-1106', 1, 0, '2026-03-16', 102000, 245000, NULL, 'Código: 1106', 'sede-pm-1'),
('prod-pm-s1-1007', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LATTAFA-KHAMRAH DUKHAN', 'ORI-LATTAFA-KHAMRAH DUKHAN-UNI', 'UNISEX', 'cosmetica', 'PM-S1-1007', 4, 0, '2026-03-16', 122554, 275000, NULL, 'Código: 1007', 'sede-pm-1'),
('prod-pm-973', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LATTAFA-KHAMRAH QAHWA', 'ORI-LATTAFA-KHAMRAH QAHWA-UNI', 'UNISEX', 'cosmetica', 'PM-973', 2, 0, '2026-03-16', 113000, 260000, NULL, 'Código: 973', 'sede-pm-1'),
('prod-pm-932', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LATTAFA-KHAMRAH', 'ORI-LATTAFA-KHAMRAH-UNI', 'UNISEX', 'cosmetica', 'PM-932', 3, 0, '2026-03-16', 107200, 250000, NULL, 'Código: 932', 'sede-pm-1'),
('prod-pm-s1-1062', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LATTAFA-MALLOW MADNESS', 'ORI-LATTAFA-MALLOW MADNESS-UNI', 'UNISEX', 'cosmetica', 'PM-S1-1062', 3, 0, '2026-03-16', 171339, 339000, NULL, 'Código: 1062', 'sede-pm-1'),
('prod-pm-s1-1029', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LATTAFA-MAYAR CHERRY INTENSE', 'ORI-LATTAFA-MAYAR CHERRY INTENSE-FEM', 'DAMAS', 'cosmetica', 'PM-S1-1029', 2, 0, '2026-03-16', 112000, 250000, NULL, 'Código: 1029', 'sede-pm-1'),
('prod-pm-925', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LATTAFA-MAYAR', 'ORI-LATTAFA-MAYAR-FEM', 'DAMAS', 'cosmetica', 'PM-925', 2, 0, '2026-03-16', 116221, 250000, NULL, 'Código: 925', 'sede-pm-1'),
('prod-pm-1093', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LATTAFA-MUSAMAM WHITE INTENSE', 'ORI-LATTAFA-MUSAMAM WHITE INTENSE-UNI', 'UNISEX', 'cosmetica', 'PM-1093', 3, 0, '2026-03-16', 133000, 295000, NULL, 'Código: 1093', 'sede-pm-1'),
('prod-pm-1031', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LATTAFA-NEBRAS', 'ORI-LATTAFA-NEBRAS-UNI', 'UNISEX', 'cosmetica', 'PM-1031', 3, 0, '2026-03-16', 104000, 260000, NULL, 'Código: 1031', 'sede-pm-1'),
('prod-pm-s1-270', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LATTAFA-NOBLE BLUSH', 'ORI-LATTAFA-NOBLE BLUSH-FEM', 'DAMAS', 'cosmetica', 'PM-S1-270', 2, 0, '2026-03-16', 107170, 250000, NULL, 'Código: 270', 'sede-pm-1'),
('prod-pm-935', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LATTAFA-OUD FOR GLORY', 'ORI-LATTAFA-OUD FOR GLORY-UNI', 'UNISEX', 'cosmetica', 'PM-935', 2, 0, '2026-03-16', 110339, 250000, NULL, 'Código: 935', 'sede-pm-1'),
('prod-pm-1107', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LATTAFA-PISA', 'ORI-LATTAFA-PISA-UNI', 'UNISEX', 'cosmetica', 'PM-1107', 2, 0, '2026-03-16', 137600, 295000, NULL, 'Código: 1107', 'sede-pm-1'),
('prod-pm-967', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LATTAFA-QAED AL FURSAN UNLIMITED', 'ORI-LATTAFA-QAED AL FURSAN UNLIMITED-UNI', 'UNISEX', 'cosmetica', 'PM-967', 2, 0, '2026-03-16', 79700, 205000, NULL, 'Código: 967', 'sede-pm-1'),
('prod-pm-s1-1013', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LATTAFA-QAED AL FURSAN UNTAMED', 'ORI-LATTAFA-QAED AL FURSAN UNTAMED-UNI', 'UNISEX', 'cosmetica', 'PM-S1-1013', 2, 0, '2026-03-16', 102000, 229000, NULL, 'Código: 1013', 'sede-pm-1'),
('prod-pm-953', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LATTAFA-QAED AL FURSAN', 'ORI-LATTAFA-QAED AL FURSAN-UNI', 'UNISEX', 'cosmetica', 'PM-953', 1, 0, '2026-03-16', 115000, 210000, NULL, 'Código: 953', 'sede-pm-1'),
('prod-pm-s1-1002', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LATTAFA-RAMZ SILVER', 'ORI-LATTAFA-RAMZ SILVER-UNI', 'UNISEX', 'cosmetica', 'PM-S1-1002', 3, 0, '2026-03-16', 80000, 225000, NULL, 'Código: 1002', 'sede-pm-1'),
('prod-pm-961', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LATTAFA-SHAHEEN GOLD', 'ORI-LATTAFA-SHAHEEN GOLD-UNI', 'UNISEX', 'cosmetica', 'PM-961', 1, 0, '2026-03-16', 114760, 260000, NULL, 'Código: 961', 'sede-pm-1'),
('prod-pm-934', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LATTAFA-SUBLIME', 'ORI-LATTAFA-SUBLIME-UNI', 'UNISEX', 'cosmetica', 'PM-934', 2, 0, '2026-03-16', 101200, 250000, NULL, 'Código: 934', 'sede-pm-1'),
('prod-pm-s1-1026', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LATTAFA-TERIAQ INTENSE', 'ORI-LATTAFA-TERIAQ INTENSE-UNI', 'UNISEX', 'cosmetica', 'PM-S1-1026', 2, 0, '2026-03-16', 123104, 290000, NULL, 'Código: 1026', 'sede-pm-1'),
('prod-pm-981', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LATTAFA-THE KINGDOM', 'ORI-LATTAFA-THE KINGDOM-MAS', 'CABALLEROS', 'cosmetica', 'PM-981', 3, 0, '2026-03-16', 106000, 275000, NULL, 'Código: 981', 'sede-pm-1'),
('prod-pm-s1-1025', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LATTAFA-VICTORIA', 'ORI-LATTAFA-VICTORIA-UNI', 'UNISEX', 'cosmetica', 'PM-S1-1025', 0, 0, '2026-03-16', 136000, 260000, NULL, 'Código: 1025', 'sede-pm-1'),
('prod-pm-956', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LATTAFA-YARA CANDY', 'ORI-LATTAFA-YARA CANDY-FEM', 'DAMAS', 'cosmetica', 'PM-956', 2, 0, '2026-03-16', 116408, 280000, NULL, 'Código: 956', 'sede-pm-1'),
('prod-pm-1076', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LATTAFA-YARA ELIXIR', 'ORI-LATTAFA-YARA ELIXIR-FEM', 'DAMAS', 'cosmetica', 'PM-1076', 1, 0, '2026-03-16', 137000, 325000, NULL, 'Código: 1076', 'sede-pm-1'),
('prod-pm-920', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LATTAFA-YARA MOI', 'ORI-LATTAFA-YARA MOI-FEM', 'DAMAS', 'cosmetica', 'PM-920', 2, 0, '2026-03-16', 102468, 250000, NULL, 'Código: 920', 'sede-pm-1'),
('prod-pm-919', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LATTAFA-YARA', 'ORI-LATTAFA-YARA-FEM', 'DAMAS', 'cosmetica', 'PM-919', 3, 0, '2026-03-16', 110250, 250000, NULL, 'Código: 919', 'sede-pm-1'),
('prod-pm-1068', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'MACARENA-ANARCHY THE REBEL ONE', 'ORI-MACARENA-ANARCHY THE REBEL ONE-FEM', 'DAMAS', 'cosmetica', 'PM-1068', 1, 0, '2026-03-16', 202555, 385000, NULL, 'Código: 1068', 'sede-pm-1'),
('prod-pm-995', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'MAISON ALHAMBRA-DELILAH BLANC', 'ORI-MAISON ALHAMBRA-DELILAH BLANC-FEM', 'DAMAS', 'cosmetica', 'PM-995', 1, 0, '2026-03-16', 83622, 199000, NULL, 'Código: 995', 'sede-pm-1'),
('prod-pm-951', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'MAISON ALHAMBRA-DELILAH', 'ORI-MAISON ALHAMBRA-DELILAH-FEM', 'DAMAS', 'cosmetica', 'PM-951', 1, 0, '2026-03-16', 125000, 220000, NULL, 'Código: 951', 'sede-pm-1'),
('prod-pm-952', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'MAISON ALHAMBRA-JEAN LOWE IMMORTEL', 'ORI-MAISON ALHAMBRA-JEAN LOWE IMMORTEL-MAS', 'CABALLEROS', 'cosmetica', 'PM-952', 0, 0, '2026-03-16', 170000, 290000, NULL, 'Código: 952', 'sede-pm-1'),
('prod-pm-s1-1058', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'MAISON ALHAMBRA-JEAN LOWE VIBE', 'ORI-MAISON ALHAMBRA-JEAN LOWE VIBE-MAS', 'CABALLEROS', 'cosmetica', 'PM-S1-1058', 2, 0, '2026-03-16', 136221, 285000, NULL, 'Código: 1058', 'sede-pm-1'),
('prod-pm-969', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'MONTBLANC-STARWALKER', 'ORI-MONTBLANC-STARWALKER-MAS', 'CABALLEROS', 'cosmetica', 'PM-969', 0, 0, '2026-03-16', 140000, 265000, NULL, 'Código: 969', 'sede-pm-1'),
('prod-pm-917', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'MOSCHINO-FRESH GOLD', 'ORI-MOSCHINO-FRESH GOLD-FEM', 'DAMAS', 'cosmetica', 'PM-917', 0, 0, '2026-03-16', 210000, 325000, NULL, 'Código: 917', 'sede-pm-1'),
('prod-pm-1095', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'MOSCHINO-FUNNY', 'ORI-MOSCHINO-FUNNY-FEM', 'DAMAS', 'cosmetica', 'PM-1095', 0, 0, '2026-03-16', 178000, 280000, NULL, 'Código: 1095', 'sede-pm-1'),
('prod-pm-901', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'NAUTICA-NAUTICA VOYAGE', 'ORI-NAUTICA-NAUTICA VOYAGE-MAS', 'CABALLEROS', 'cosmetica', 'PM-901', 4, 0, '2026-03-16', 67300, 175000, NULL, 'Código: 901', 'sede-pm-1'),
('prod-pm-976', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'NUSUK-ANA AL AWWAL WHITE', 'ORI-NUSUK-ANA AL AWWAL WHITE-UNI', 'UNISEX', 'cosmetica', 'PM-976', 2, 0, '2026-03-16', 115000, 225000, NULL, 'Código: 976', 'sede-pm-1'),
('prod-pm-931', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ORIENTICA-AMBER NOIR', 'ORI-ORIENTICA-AMBER NOIR-UNI', 'UNISEX', 'cosmetica', 'PM-931', 1, 0, '2026-03-16', 300000, 470000, NULL, 'Código: 931', 'sede-pm-1'),
('prod-pm-930', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ORIENTICA-AMBER ROUGE', 'ORI-ORIENTICA-AMBER ROUGE-UNI', 'UNISEX', 'cosmetica', 'PM-930', 0, 0, '2026-03-16', 285000, 485000, NULL, 'Código: 930', 'sede-pm-1'),
('prod-pm-1108', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ORIENTICA-DYNASTY', 'ORI-ORIENTICA-DYNASTY-MAS', 'CABALLEROS', 'cosmetica', 'PM-1108', 2, 0, '2026-03-16', 241800, 490000, NULL, 'Código: 1108', 'sede-pm-1'),
('prod-pm-1109', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ORIENTICA-NOBLE', 'ORI-ORIENTICA-NOBLE-MAS', 'CABALLEROS', 'cosmetica', 'PM-1109', 2, 0, '2026-03-16', 241800, 490000, NULL, 'Código: 1109', 'sede-pm-1'),
('prod-pm-1110', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ORIENTICA-VICTORY', 'ORI-ORIENTICA-VICTORY-MAS', 'CABALLEROS', 'cosmetica', 'PM-1110', 2, 0, '2026-03-16', 241800, 490000, NULL, 'Código: 1110', 'sede-pm-1'),
('prod-pm-1074', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'PACO RABANNE-1 MILLION ROYAL', 'ORI-PACO RABANNE-1 MILLION ROYAL-MAS', 'CABALLEROS', 'cosmetica', 'PM-1074', 0, 0, '2026-03-16', 365000, 570000, NULL, 'Código: 1074', 'sede-pm-1'),
('prod-pm-912', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'PACO RABANNE-1 MILLION', 'ORI-PACO RABANNE-1 MILLION-MAS', 'CABALLEROS', 'cosmetica', 'PM-912', 0, 0, '2026-03-16', 310000, 500000, NULL, 'Código: 912', 'sede-pm-1'),
('prod-pm-902', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'PACO RABANNE-INVICTUS', 'ORI-PACO RABANNE-INVICTUS-MAS', 'CABALLEROS', 'cosmetica', 'PM-902', 1, 0, '2026-03-16', 305000, 510000, NULL, 'Código: 902', 'sede-pm-1'),
('prod-pm-1000', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'PARIS CORNER-MANGO BLISS', 'ORI-PARIS CORNER-MANGO BLISS-UNI', 'UNISEX', 'cosmetica', 'PM-1000', 2, 0, '2026-03-16', 140000, 295000, NULL, 'Código: 1000', 'sede-pm-1'),
('prod-pm-913', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'PARIS HILTON-CAN CAN', 'ORI-PARIS HILTON-CAN CAN-FEM', 'DAMAS', 'cosmetica', 'PM-913', 1, 0, '2026-03-16', 125000, 215000, NULL, 'Código: 913', 'sede-pm-1'),
('prod-pm-915', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'PARIS HILTON-HEIRESS', 'ORI-PARIS HILTON-HEIRESS-FEM', 'DAMAS', 'cosmetica', 'PM-915', 1, 0, '2026-03-16', 137300, 250000, NULL, 'Código: 915', 'sede-pm-1'),
('prod-pm-914', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'PARIS HILTON-PARIS HILTON', 'ORI-PARIS HILTON-PARIS HILTON-FEM', 'DAMAS', 'cosmetica', 'PM-914', 1, 0, '2026-03-16', 122300, 230000, NULL, 'Código: 914', 'sede-pm-1'),
('prod-pm-974', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'PARIS HILTON-ROSE RUSH', 'ORI-PARIS HILTON-ROSE RUSH-FEM', 'DAMAS', 'cosmetica', 'PM-974', 1, 0, '2026-03-16', 132300, 250000, NULL, 'Código: 974', 'sede-pm-1'),
('prod-pm-918', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'PERRY ELLIS-360 CLASICA', 'ORI-PERRY ELLIS-360 CLASICA-FEM', 'DAMAS', 'cosmetica', 'PM-918', 1, 0, '2026-03-16', 128000, 240000, NULL, 'Código: 918', 'sede-pm-1'),
('prod-pm-s1-1053', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'PERRY ELLIS-360 COLLECTION', 'ORI-PERRY ELLIS-360 COLLECTION-FEM', 'DAMAS', 'cosmetica', 'PM-S1-1053', 0, 0, '2026-03-16', 143000, 265000, NULL, 'Código: 1053', 'sede-pm-1'),
('prod-pm-1032', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'PERRY ELLIS-360 CORAL', 'ORI-PERRY ELLIS-360 CORAL-FEM', 'DAMAS', 'cosmetica', 'PM-1032', 0, 0, '2026-03-16', 140000, 250000, NULL, 'Código: 1032', 'sede-pm-1'),
('prod-pm-s1-1052', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'PERRY ELLIS-360 PURPLE', 'ORI-PERRY ELLIS-360 PURPLE-FEM', 'DAMAS', 'cosmetica', 'PM-S1-1052', 1, 0, '2026-03-16', 127300, 255000, NULL, 'Código: 1052', 'sede-pm-1'),
('prod-pm-944', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'PINO SILVESTRE-PINO SILVESTRE ORIGINAL', 'ORI-PINO SILVESTRE-PINO SILVESTRE ORIGINAL-MAS', 'CABALLEROS', 'cosmetica', 'PM-944', 2, 0, '2026-03-16', 87300, 185000, NULL, 'Código: 944', 'sede-pm-1'),
('prod-pm-1111', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'RASASI-HAWAS ICE', 'ORI-RASASI-HAWAS ICE-MAS', 'CABALLEROS', 'cosmetica', 'PM-1111', 2, 0, '2026-03-16', 134000, 285000, NULL, 'Código: 1111', 'sede-pm-1'),
('prod-pm-1091', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'RASASI-HAWAS TROPICAL', 'ORI-RASASI-HAWAS TROPICAL-MAS', 'CABALLEROS', 'cosmetica', 'PM-1091', 2, 0, '2026-03-16', 183000, 350000, NULL, 'Código: 1091', 'sede-pm-1'),
('prod-pm-1073', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'RASASI-HAWAS', 'ORI-RASASI-HAWAS-MAS', 'CABALLEROS', 'cosmetica', 'PM-1073', 2, 0, '2026-03-16', 153000, 290000, NULL, 'Código: 1073', 'sede-pm-1'),
('prod-pm-927', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'RAVE-NOW WOMAN', 'ORI-RAVE-NOW WOMAN-FEM', 'DAMAS', 'cosmetica', 'PM-927', 1, 0, '2026-03-16', 210000, 386000, NULL, 'Código: 927', 'sede-pm-1'),
('prod-pm-s1-988', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'RAYHAAN-ELIXIR', 'ORI-RAYHAAN-ELIXIR-UNI', 'UNISEX', 'cosmetica', 'PM-S1-988', 3, 0, '2026-03-16', 108000, 250000, NULL, 'Código: 988', 'sede-pm-1'),
('prod-pm-s1-1001', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'RAYHAAN-PACIFIC AQUA', 'ORI-RAYHAAN-PACIFIC AQUA-MAS', 'CABALLEROS', 'cosmetica', 'PM-S1-1001', 0, 0, '2026-03-16', 92000, 230000, NULL, 'Código: 1001', 'sede-pm-1'),
('prod-pm-s1-987', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'RAYHAAN-TIGER', 'ORI-RAYHAAN-TIGER-UNI', 'UNISEX', 'cosmetica', 'PM-S1-987', 3, 0, '2026-03-16', 106500, 250000, NULL, 'Código: 987', 'sede-pm-1'),
('prod-pm-955', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'REAL MADRID', 'ORI-REAL MADRID-MAS', 'CABALLEROS', 'cosmetica', 'PM-955', 0, 0, '2026-03-16', 90000, 165000, NULL, 'Código: 955', 'sede-pm-1'),
('prod-pm-s1-1017', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'SET CLUB DE NUIT INTENSE 4PCS', 'ORI-SET CLUB DE NUIT INTENSE 4PCS-MAS', 'CABALLEROS', 'cosmetica', 'PM-S1-1017', 0, 0, '2026-03-16', 181000, 355000, NULL, 'Código: 1017', 'sede-pm-1'),
('prod-pm-s1-1015', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'SET KHAMRAH 3PCS', 'ORI-SET KHAMRAH 3PCS-UNI', 'UNISEX', 'cosmetica', 'PM-S1-1015', 0, 0, '2026-03-16', 145000, 320000, NULL, 'Código: 1015', 'sede-pm-1'),
('prod-pm-1045', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'SET MINI BADEE AL OUD COLLECTION', 'ORI-SET MINI BADEE AL OUD COLLECTION-UNI', 'UNISEX', 'cosmetica', 'PM-1045', 5, 0, '2026-03-16', 112000, 250000, NULL, 'Código: 1045', 'sede-pm-1');
INSERT INTO products (id, tenant_id, name, articulo, category, product_type, sku, stock, reorder_point, entry_date, purchase_price, sale_price, presentation, notes, sede_id) VALUES
('prod-pm-s1-1016', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'SET MINI ORIENTICA 5PCS', 'ORI-SET MINI ORIENTICA 5PCS-UNI', 'UNISEX', 'cosmetica', 'PM-S1-1016', 1, 0, '2026-03-16', 149000, 320000, NULL, 'Código: 1016', 'sede-pm-1'),
('prod-pm-s1-1055', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'SET MINI VICTORIA SECRET', 'ORI-SET MINI VICTORIA SECRET-FEM', 'DAMAS', 'cosmetica', 'PM-S1-1055', 0, 0, '2026-03-16', 50000, 200000, NULL, 'Código: 1055', 'sede-pm-1'),
('prod-pm-1044', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'SET MINI YARA COLLECTION', 'ORI-SET MINI YARA COLLECTION-FEM', 'DAMAS', 'cosmetica', 'PM-1044', 2, 0, '2026-03-16', 125000, 260000, NULL, 'Código: 1044', 'sede-pm-1'),
('prod-pm-1069', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'SET ODYSSEY MANDARIN SKY 4PCS', 'ORI-SET ODYSSEY MANDARIN SKY 4PCS-MAS', 'CABALLEROS', 'cosmetica', 'PM-1069', 0, 0, '2026-03-16', 204506, 370000, NULL, 'Código: 1069', 'sede-pm-1'),
('prod-pm-s1-1018', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'SET TAG HER 4PCS', 'ORI-SET TAG HER 4PCS-FEM', 'DAMAS', 'cosmetica', 'PM-S1-1018', 1, 0, '2026-03-16', 131000, 320000, NULL, 'Código: 1018', 'sede-pm-1'),
('prod-pm-903', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'TED LAPIDUS PARIS-LAPIDUS', 'ORI-TED LAPIDUS PARIS-LAPIDUS-MAS', 'CABALLEROS', 'cosmetica', 'PM-903', 1, 0, '2026-03-16', 87300, 180000, NULL, 'Código: 903', 'sede-pm-1'),
('prod-pm-1094', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'VALENTINO-UOMO BORN IN ROMA INTENSE', 'ORI-VALENTINO-UOMO BORN IN ROMA INTENSE-MAS', 'CABALLEROS', 'cosmetica', 'PM-1094', 1, 0, '2026-03-16', 520000, 790000, NULL, 'Código: 1094', 'sede-pm-1'),
('prod-pm-963', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'VERSACE-EROS CLASICA', 'ORI-VERSACE-EROS CLASICA-MAS', 'CABALLEROS', 'cosmetica', 'PM-963', 1, 0, '2026-03-16', 270000, 480000, NULL, 'Código: 963', 'sede-pm-1'),
('prod-pm-909', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'VICTORINOX-SWISS ARMY CLASSIC', 'ORI-VICTORINOX-SWISS ARMY CLASSIC-MAS', 'CABALLEROS', 'cosmetica', 'PM-909', 2, 0, '2026-03-16', 97400, 205000, NULL, 'Código: 909', 'sede-pm-1'),
('prod-pm-s1-1020', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'YARA MUKHAMARIA VASELINE', 'ORI-YARA MUKHAMARIA VASELINE-FEM', 'DAMAS', 'cosmetica', 'PM-S1-1020', 3, 0, '2026-03-16', 56000, 110000, NULL, 'Código: 1020', 'sede-pm-1');

-- SEDE 1 — PERFUMERÍA RÉPLICA (10 filas)
INSERT INTO products (id, tenant_id, name, articulo, category, product_type, sku, stock, reorder_point, entry_date, purchase_price, sale_price, presentation, notes, sede_id) VALUES
('prod-pm-562', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', '1 MILLON LUCKY', 'REP-KITS 1 MILLON LUCKY-MAS', 'CABALLEROS', 'cosmetica', 'PM-562', 1, 0, '2026-03-16', 24000, 50000, NULL, 'Código: 562', 'sede-pm-1'),
('prod-pm-561', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', '1 MILLON', 'REP-KITS 1 MILLON-MAS', 'CABALLEROS', 'cosmetica', 'PM-561', 1, 0, '2026-03-16', 24000, 50000, NULL, 'Código: 561', 'sede-pm-1'),
('prod-pm-560-b', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', '212 VIP', 'REP-KITS 212 VIP-MAS', 'CABALLEROS', 'cosmetica', 'PM-560-B', 1, 0, '2026-03-16', 24000, 50000, NULL, 'Código: 560', 'sede-pm-1'),
('prod-pm-565', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'AMBER ROUGE', 'REP-KITS AMBER ROUGE-UNI', 'UNISEX', 'cosmetica', 'PM-565', 0, 0, '2026-03-16', 24000, 50000, NULL, 'Código: 565', 'sede-pm-1'),
('prod-pm-563', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ASAD', 'REP-KITS ASAD-MAS', 'CABALLEROS', 'cosmetica', 'PM-563', 1, 0, '2026-03-16', 24000, 50000, NULL, 'Código: 563', 'sede-pm-1'),
('prod-pm-563-b', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'INVICTUS', 'REP-KITS INVICTUS-MAS', 'CABALLEROS', 'cosmetica', 'PM-563-B', 1, 0, '2026-03-16', 24000, 50000, NULL, 'Código: 563', 'sede-pm-1'),
('prod-pm-568', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'SWEET LIKE CANDY', 'REP-KITS SWEET LIKE CANDY-FEM', 'DAMAS', 'cosmetica', 'PM-568', 0, 0, '2026-03-16', 24000, 50000, NULL, 'Código: 568', 'sede-pm-1'),
('prod-pm-564', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'TOY 2 BUBBLE GUM', 'REP-KITS TOY 2 BUBBLE GUM-FEM', 'DAMAS', 'cosmetica', 'PM-564', 0, 0, '2026-03-16', 24000, 50000, NULL, 'Código: 564', 'sede-pm-1'),
('prod-pm-567', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'YARA CANDY', 'REP-KITS YARA CANDY-FEM', 'DAMAS', 'cosmetica', 'PM-567', 0, 0, '2026-03-16', 24000, 50000, NULL, 'Código: 567', 'sede-pm-1'),
('prod-pm-566', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'YARA', 'REP-KITS YARA-FEM', 'DAMAS', 'cosmetica', 'PM-566', 0, 0, '2026-03-16', 24000, 50000, NULL, 'Código: 566', 'sede-pm-1');

-- ============================================================
-- PRODUCTOS SEDE 2
-- ============================================================

-- SEDE 2 — HOGAR (70 filas)
INSERT INTO products (id, tenant_id, name, articulo, category, product_type, sku, stock, reorder_point, entry_date, purchase_price, sale_price, presentation, notes, sede_id) VALUES
('prod-pm-1227', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ALGODON', 'AROMATIZANTE-ALGODON', 'HOGAR', 'cosmetica', 'PM-1227', 3, 0, '2026-03-16', 6000, 15000, NULL, 'Código: 1227', 'sede-pm-2'),
('prod-pm-1223', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'CAN CAN', 'AROMATIZANTE-CAN CAN', 'HOGAR', 'cosmetica', 'PM-1223', 3, 0, '2026-03-16', 6000, 15000, NULL, 'Código: 1223', 'sede-pm-2'),
('prod-pm-1228', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'CANELA', 'AROMATIZANTE-CANELA', 'HOGAR', 'cosmetica', 'PM-1228', 0, 0, '2026-03-16', 6000, 15000, NULL, 'Código: 1228', 'sede-pm-2'),
('prod-pm-1222', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'CHICLE BOMBON', 'AROMATIZANTE-CHICLE BOMBON', 'HOGAR', 'cosmetica', 'PM-1222', 4, 0, '2026-03-16', 6000, 15000, NULL, 'Código: 1222', 'sede-pm-2'),
('prod-pm-1220', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'COCO', 'AROMATIZANTE-COCO', 'HOGAR', 'cosmetica', 'PM-1220', 2, 0, '2026-03-16', 6000, 15000, NULL, 'Código: 1220', 'sede-pm-2'),
('prod-pm-1234', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'DESERT', 'AROMATIZANTE-DESERT', 'HOGAR', 'cosmetica', 'PM-1234', 0, 0, '2026-03-16', 6000, 15000, NULL, 'Código: 1234', 'sede-pm-2'),
('prod-pm-1231', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'FLORAL', 'AROMATIZANTE-FLORAL', 'HOGAR', 'cosmetica', 'PM-1231', 0, 0, '2026-03-16', 6000, 15000, NULL, 'Código: 1231', 'sede-pm-2'),
('prod-pm-1230', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'FLORENSE', 'AROMATIZANTE-FLORENSE', 'HOGAR', 'cosmetica', 'PM-1230', 0, 0, '2026-03-16', 6000, 15000, NULL, 'Código: 1230', 'sede-pm-2'),
('prod-pm-1232', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'FRESCO BAMBU', 'AROMATIZANTE-FRESCO BAMBU', 'HOGAR', 'cosmetica', 'PM-1232', 5, 0, '2026-03-16', 6000, 15000, NULL, 'Código: 1232', 'sede-pm-2'),
('prod-pm-1224', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'FRUTOS ROJOS', 'AROMATIZANTE-FRUTOS ROJOS', 'HOGAR', 'cosmetica', 'PM-1224', 5, 0, '2026-03-16', 6000, 15000, NULL, 'Código: 1224', 'sede-pm-2'),
('prod-pm-1217', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'KIWI', 'AROMATIZANTE-KIWI', 'HOGAR', 'cosmetica', 'PM-1217', 0, 0, '2026-03-16', 6000, 15000, NULL, 'Código: 1217', 'sede-pm-2'),
('prod-pm-1229', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LAVANDA FRESH', 'AROMATIZANTE-LAVANDA FRESH', 'HOGAR', 'cosmetica', 'PM-1229', 4, 0, '2026-03-16', 6000, 15000, NULL, 'Código: 1229', 'sede-pm-2'),
('prod-pm-1226', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LIMON', 'AROMATIZANTE-LIMON', 'HOGAR', 'cosmetica', 'PM-1226', 1, 0, '2026-03-16', 6000, 15000, NULL, 'Código: 1226', 'sede-pm-2'),
('prod-pm-1225', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'MANDARINA', 'AROMATIZANTE-MANDARINA', 'HOGAR', 'cosmetica', 'PM-1225', 1, 0, '2026-03-16', 6000, 15000, NULL, 'Código: 1225', 'sede-pm-2'),
('prod-pm-1236', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'MENTA', 'AROMATIZANTE-MENTA', 'HOGAR', 'cosmetica', 'PM-1236', 0, 0, '2026-03-16', 6000, 15000, NULL, 'Código: 1236', 'sede-pm-2'),
('prod-pm-1219', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'SANDALO', 'AROMATIZANTE-SANDALO', 'HOGAR', 'cosmetica', 'PM-1219', 1, 0, '2026-03-16', 6000, 15000, NULL, 'Código: 1219', 'sede-pm-2'),
('prod-pm-1233', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'TALCO', 'AROMATIZANTE-TALCO', 'HOGAR', 'cosmetica', 'PM-1233', 0, 0, '2026-03-16', 6000, 15000, NULL, 'Código: 1233', 'sede-pm-2'),
('prod-pm-1221', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'VAINILLA', 'AROMATIZANTE-VAINILLA', 'HOGAR', 'cosmetica', 'PM-1221', 5, 0, '2026-03-16', 6000, 15000, NULL, 'Código: 1221', 'sede-pm-2'),
('prod-pm-1415', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'KIWI TORONJA', 'DIFUSOR- KIWI TORONJA', 'HOGAR', 'cosmetica', 'PM-1415', 3, 0, '2026-03-16', 8000, 15000, NULL, 'Código: 1415', 'sede-pm-2'),
('prod-pm-1344', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'AMBROSIA VAINILLA', 'DIFUSOR-AMBROSIA VAINILLA', 'HOGAR', 'cosmetica', 'PM-1344', 2, 0, '2026-03-16', 4000, 15000, NULL, 'Código: 1344', 'sede-pm-2'),
('prod-pm-1208', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ARMONIA', 'DIFUSOR-ARMONIA', 'HOGAR', 'cosmetica', 'PM-1208', 0, 0, '2026-03-16', 8000, 15000, NULL, 'Código: 1208', 'sede-pm-2'),
('prod-pm-1207', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'BRISA TROPICAL', 'DIFUSOR-BRISA TROPICAL', 'HOGAR', 'cosmetica', 'PM-1207', 1, 0, '2026-03-16', 10666, 15000, NULL, 'Código: 1207', 'sede-pm-2'),
('prod-pm-1241', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'CITRUS', 'DIFUSOR-CITRUS', 'HOGAR', 'cosmetica', 'PM-1241', 9, 0, '2026-03-16', 8000, 15000, NULL, 'Código: 1241', 'sede-pm-2'),
('prod-pm-1209', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ELEGANT', 'DIFUSOR-ELEGANT', 'HOGAR', 'cosmetica', 'PM-1209', 0, 0, '2026-03-16', 8000, 15000, NULL, 'Código: 1209', 'sede-pm-2'),
('prod-pm-1215', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'FRESAS Y FRAMBUESA', 'DIFUSOR-FRESAS Y FRAMBUESA', 'HOGAR', 'cosmetica', 'PM-1215', 0, 0, '2026-03-16', 8000, 15000, NULL, 'Código: 1215', 'sede-pm-2'),
('prod-pm-1214', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'FRESCA BRISA', 'DIFUSOR-FRESCA BRISA', 'HOGAR', 'cosmetica', 'PM-1214', 1, 0, '2026-03-16', 10666, 15000, NULL, 'Código: 1214', 'sede-pm-2'),
('prod-pm-1210', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'FUNNY', 'DIFUSOR-FUNNY', 'HOGAR', 'cosmetica', 'PM-1210', 0, 0, '2026-03-16', 8000, 15000, NULL, 'Código: 1210', 'sede-pm-2'),
('prod-pm-1216', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'KIWI', 'DIFUSOR-KIWI', 'HOGAR', 'cosmetica', 'PM-1216', 3, 0, '2026-03-16', 8000, 15000, NULL, 'Código: 1216', 'sede-pm-2'),
('prod-pm-1240', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'KOLA PINK', 'DIFUSOR-KOLA PINK', 'HOGAR', 'cosmetica', 'PM-1240', 1, 0, '2026-03-16', 8000, 15000, NULL, 'Código: 1240', 'sede-pm-2'),
('prod-pm-1243', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LIMONADA DE COCO', 'DIFUSOR-LIMONADA DE COCO', 'HOGAR', 'cosmetica', 'PM-1243', 0, 0, '2026-03-16', 9300, 15000, NULL, 'Código: 1243', 'sede-pm-2'),
('prod-pm-1202', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'MANZANA CANELA', 'DIFUSOR-MANZANA CANELA', 'HOGAR', 'cosmetica', 'PM-1202', 2, 0, '2026-03-16', 8000, 15000, NULL, 'Código: 1202', 'sede-pm-2'),
('prod-pm-1239', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'MARACUYA', 'DIFUSOR-MARACUYA', 'HOGAR', 'cosmetica', 'PM-1239', 6, 0, '2026-03-16', 10666, 15000, NULL, 'Código: 1239', 'sede-pm-2'),
('prod-pm-1206', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'MELON', 'DIFUSOR-MELON', 'HOGAR', 'cosmetica', 'PM-1206', 5, 0, '2026-03-16', 8000, 15000, NULL, 'Código: 1206', 'sede-pm-2'),
('prod-pm-1213', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'PIÑA', 'DIFUSOR-PIÑA', 'HOGAR', 'cosmetica', 'PM-1213', 1, 0, '2026-03-16', 8000, 15000, NULL, 'Código: 1213', 'sede-pm-2'),
('prod-pm-1205', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'PINO', 'DIFUSOR-PINO', 'HOGAR', 'cosmetica', 'PM-1205', 2, 0, '2026-03-16', 10666, 15000, NULL, 'Código: 1205', 'sede-pm-2'),
('prod-pm-1204', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ROJOS SILVESTRES', 'DIFUSOR-ROJOS SILVESTRES', 'HOGAR', 'cosmetica', 'PM-1204', 0, 0, '2026-03-16', 8000, 15000, NULL, 'Código: 1204', 'sede-pm-2'),
('prod-pm-1244', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'TUTTY FRUTTY', 'DIFUSOR-TUTTY FRUTTY', 'HOGAR', 'cosmetica', 'PM-1244', 3, 0, '2026-03-16', 9300, 15000, NULL, 'Código: 1244', 'sede-pm-2'),
('prod-pm-1211', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'VAINILLA', 'DIFUSOR-VAINILLA', 'HOGAR', 'cosmetica', 'PM-1211', 0, 0, '2026-03-16', 10666, 15000, NULL, 'Código: 1211', 'sede-pm-2'),
('prod-pm-1242', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'VAINILLA TOST', 'DIFUSOR-VAINILLA TOST', 'HOGAR', 'cosmetica', 'PM-1242', 9, 0, '2026-03-16', 8000, 15000, NULL, 'Código: 1242', 'sede-pm-2'),
('prod-pm-1468', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ARANDANO MORA CAR', 'PM CARRO-ARANDANO MORA CAR', 'HOGAR', 'cosmetica', 'PM-1468', 2, 0, '2026-03-16', 8000, 15000, NULL, 'Código: 1468', 'sede-pm-2'),
('prod-pm-1246', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'CARRO AUDI', 'PM CARRO-CARRO AUDI', 'HOGAR', 'cosmetica', 'PM-1246', 1, 0, '2026-03-16', 8000, 15000, NULL, 'Código: 1246', 'sede-pm-2'),
('prod-pm-1218', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'CARRO NUEVO', 'PM CARRO-CARRO NUEVO', 'HOGAR', 'cosmetica', 'PM-1218', 1, 0, '2026-03-16', 6000, 15000, NULL, 'Código: 1218', 'sede-pm-2'),
('prod-pm-1247', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'CHEVROLET', 'PM CARRO-CHEVROLET', 'HOGAR', 'cosmetica', 'PM-1247', 2, 0, '2026-03-16', 8000, 15000, NULL, 'Código: 1247', 'sede-pm-2'),
('prod-pm-1238', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'FRESCO CHUSPIANTE', 'PM CARRO-FRESCO CHUSPIANTE', 'HOGAR', 'cosmetica', 'PM-1238', 5, 0, '2026-03-16', 8000, 15000, NULL, 'Código: 1238', 'sede-pm-2'),
('prod-pm-1237', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'SANDIA FRAPE', 'PM CARRO-SANDIA FRAPE', 'HOGAR', 'cosmetica', 'PM-1237', 4, 0, '2026-03-16', 8000, 15000, NULL, 'Código: 1237', 'sede-pm-2'),
('prod-pm-1245', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'TOYOTA', 'PM CARRO-TOYOTA', 'HOGAR', 'cosmetica', 'PM-1245', 0, 0, '2026-03-16', 8000, 15000, NULL, 'Código: 1245', 'sede-pm-2'),
('prod-pm-1469', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'XTREM CAR', 'PM CARRO-XTREM CAR', 'HOGAR', 'cosmetica', 'PM-1469', 2, 0, '2026-03-16', 8000, 15000, NULL, 'Código: 1469', 'sede-pm-2'),
('prod-pm-1271', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'BLACK XS', 'ESENCIA HS-BLACK XS', 'HOGAR', 'cosmetica', 'PM-1271', 3, 0, '2026-03-16', 4777, 10000, NULL, 'Código: 1271', 'sede-pm-2'),
('prod-pm-1396', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'BRISA MARINA', 'ESENCIA HS-BRISA MARINA', 'HOGAR', 'cosmetica', 'PM-1396', 2, 0, '2026-03-16', 4777, 10000, NULL, 'Código: 1396', 'sede-pm-2'),
('prod-pm-1403', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'COCO VAINILLA', 'ESENCIA HS-COCO VAINILLA', 'HOGAR', 'cosmetica', 'PM-1403', 2, 0, '2026-03-16', 4777, 10000, NULL, 'Código: 1403', 'sede-pm-2'),
('prod-pm-1404', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'FANTASIA FRUTAL', 'ESENCIA HS-FANTASIA FRUTAL', 'HOGAR', 'cosmetica', 'PM-1404', 2, 0, '2026-03-16', 4777, 10000, NULL, 'Código: 1404', 'sede-pm-2'),
('prod-pm-1398', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'FLORES ALGODON', 'ESENCIA HS-FLORES ALGODON', 'HOGAR', 'cosmetica', 'PM-1398', 2, 0, '2026-03-16', 4777, 10000, NULL, 'Código: 1398', 'sede-pm-2'),
('prod-pm-1405', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'FRUTOS AMARILLOS', 'ESENCIA HS-FRUTOS AMARILLOS', 'HOGAR', 'cosmetica', 'PM-1405', 2, 0, '2026-03-16', 4777, 10000, NULL, 'Código: 1405', 'sede-pm-2'),
('prod-pm-1401', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'FRUTOS ROJOS', 'ESENCIA HS-FRUTOS ROJOS', 'HOGAR', 'cosmetica', 'PM-1401', 1, 0, '2026-03-16', 4777, 10000, NULL, 'Código: 1401', 'sede-pm-2'),
('prod-pm-1407', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'INVICTUS', 'ESENCIA HS-INVICTUS', 'HOGAR', 'cosmetica', 'PM-1407', 1, 0, '2026-03-16', 4777, 10000, NULL, 'Código: 1407', 'sede-pm-2'),
('prod-pm-1406', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'MANDARINA', 'ESENCIA HS-MANDARINA', 'HOGAR', 'cosmetica', 'PM-1406', 2, 0, '2026-03-16', 4777, 10000, NULL, 'Código: 1406', 'sede-pm-2'),
('prod-pm-1397', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'MARACUYA', 'ESENCIA HS-MARACUYA', 'HOGAR', 'cosmetica', 'PM-1397', 2, 0, '2026-03-16', 4777, 10000, NULL, 'Código: 1397', 'sede-pm-2'),
('prod-pm-1400', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'MENTA FRESCA', 'ESENCIA HS-MENTA FRESCA', 'HOGAR', 'cosmetica', 'PM-1400', 2, 0, '2026-03-16', 4777, 10000, NULL, 'Código: 1400', 'sede-pm-2'),
('prod-pm-1395', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'NAUTICO', 'ESENCIA HS-NAUTICO', 'HOGAR', 'cosmetica', 'PM-1395', 3, 0, '2026-03-16', 4777, 10000, NULL, 'Código: 1395', 'sede-pm-2'),
('prod-pm-1399', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ROLLOS DE CANELA', 'ESENCIA HS-ROLLOS DE CANELA', 'HOGAR', 'cosmetica', 'PM-1399', 0, 0, '2026-03-16', 4777, 10000, NULL, 'Código: 1399', 'sede-pm-2'),
('prod-pm-1402', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'TUTTY FRUTTY', 'ESENCIA HS-TUTTY FRUTTY', 'HOGAR', 'cosmetica', 'PM-1402', 3, 0, '2026-03-16', 4777, 10000, NULL, 'Código: 1402', 'sede-pm-2'),
('prod-pm-1414', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'BLACK XS', 'ESENCIA PB-BLACK XS', 'HOGAR', 'cosmetica', 'PM-1414', 2, 0, '2026-03-16', 2000, 5000, NULL, 'Código: 1414', 'sede-pm-2'),
('prod-pm-1409', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'CANELA', 'ESENCIA PB-CANELA', 'HOGAR', 'cosmetica', 'PM-1409', 1, 0, '2026-03-16', 2000, 5000, NULL, 'Código: 1409', 'sede-pm-2'),
('prod-pm-1412', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'COCO', 'ESENCIA PB-COCO', 'HOGAR', 'cosmetica', 'PM-1412', 1, 0, '2026-03-16', 2000, 5000, NULL, 'Código: 1412', 'sede-pm-2'),
('prod-pm-1413', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'FLORENSE', 'ESENCIA PB-FLORENSE', 'HOGAR', 'cosmetica', 'PM-1413', 1, 0, '2026-03-16', 2000, 5000, NULL, 'Código: 1413', 'sede-pm-2'),
('prod-pm-1272', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'KIWI', 'ESENCIA PB-KIWI', 'HOGAR', 'cosmetica', 'PM-1272', 2, 0, '2026-03-16', 2000, 5000, NULL, 'Código: 1272', 'sede-pm-2'),
('prod-pm-1410', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LIMON', 'ESENCIA PB-LIMON', 'HOGAR', 'cosmetica', 'PM-1410', 1, 0, '2026-03-16', 2000, 5000, NULL, 'Código: 1410', 'sede-pm-2'),
('prod-pm-1408', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'SANDALO', 'ESENCIA PB-SANDALO', 'HOGAR', 'cosmetica', 'PM-1408', 4, 0, '2026-03-16', 2000, 5000, NULL, 'Código: 1408', 'sede-pm-2'),
('prod-pm-1411', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'VAINILLA', 'ESENCIA PB-VAINILLA', 'HOGAR', 'cosmetica', 'PM-1411', 2, 0, '2026-03-16', 2000, 5000, NULL, 'Código: 1411', 'sede-pm-2'),
('prod-pm-1273', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'PEBETERO', 'PEBETERO', 'HOGAR', 'cosmetica', 'PM-1273', 11, 0, '2026-03-16', 24520, 40000, NULL, 'Código: 1273', 'sede-pm-2');

-- SEDE 2 — BELLEZA (181 filas)
INSERT INTO products (id, tenant_id, name, articulo, category, product_type, sku, stock, reorder_point, entry_date, purchase_price, sale_price, presentation, notes, sede_id) VALUES
('prod-pm-s2-1063', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'CREMA BIOMILK', 'CREMAS-CREMA BIOMILK', 'CREMAS', 'cosmetica', 'PM-S2-1063', 1, 0, '2026-03-16', 28000, 42000, NULL, 'Código: 1063', 'sede-pm-2'),
('prod-pm-s2-1065', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'CREMA SATINADA BOSLEY', 'CREMAS-CREMA SATINADA BOSLEY', 'CREMAS', 'cosmetica', 'PM-S2-1065', 9, 0, '2026-03-16', 14500, 24000, NULL, 'Código: 1065', 'sede-pm-2'),
('prod-pm-s2-1062', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'CREMAS CABALLERO SURTIDAS', 'CREMAS-CREMAS CABALLERO SURTIDAS', 'CREMAS', 'cosmetica', 'PM-S2-1062', 0, 0, '2026-03-16', 10000, 22000, NULL, 'Código: 1062', 'sede-pm-2'),
('prod-pm-s2-1067', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'PEARL COLLECTION- ALMENDRAS', 'CREMAS-PEARL COLLECTION- ALMENDRAS', 'CREMAS', 'cosmetica', 'PM-S2-1067', 10, 0, '2026-03-16', 17500, 30000, NULL, 'Código: 1067', 'sede-pm-2'),
('prod-pm-s2-1066', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'PEARL COLLECTION- AVENA', 'CREMAS-PEARL COLLECTION- AVENA', 'CREMAS', 'cosmetica', 'PM-S2-1066', 10, 0, '2026-03-16', 17500, 30000, NULL, 'Código: 1066', 'sede-pm-2'),
('prod-pm-s2-1064', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'PEARL COLLECTION- FLOR DE CEREZO', 'CREMAS-PEARL COLLECTION- FLOR DE CEREZO', 'CREMAS', 'cosmetica', 'PM-S2-1064', 8, 0, '2026-03-16', 17500, 30000, NULL, 'Código: 1064', 'sede-pm-2'),
('prod-pm-1416', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'PEARL COLLECTION- FRUTOS ROJOS', 'CREMAS-PEARL COLLECTION- FRUTOS ROJOS', 'CREMAS', 'cosmetica', 'PM-1416', 9, 0, '2026-03-16', 17500, 30000, NULL, 'Código: 1416', 'sede-pm-2'),
('prod-pm-s2-1057', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'AQUA KISS', 'REP-VS CREMA AQUA KISS-FEM', 'DAMAS', 'cosmetica', 'PM-S2-1057', 2, 0, '2026-03-16', 11000, 22000, NULL, 'Código: 1057', 'sede-pm-2'),
('prod-pm-s2-1055', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'BOMBSHEL', 'REP-VS CREMA BOMBSHEL-FEM', 'DAMAS', 'cosmetica', 'PM-S2-1055', 2, 0, '2026-03-16', 11000, 22000, NULL, 'Código: 1055', 'sede-pm-2'),
('prod-pm-s2-1054', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'CHIFFON PINK', 'REP-VS CREMA CHIFFON PINK-FEM', 'DAMAS', 'cosmetica', 'PM-S2-1054', 3, 0, '2026-03-16', 13000, 22000, NULL, 'Código: 1054', 'sede-pm-2'),
('prod-pm-s2-1059', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'COCONUT PASSION', 'REP-VS CREMA COCONUT PASSION-FEM', 'DAMAS', 'cosmetica', 'PM-S2-1059', 2, 0, '2026-03-16', 13000, 22000, NULL, 'Código: 1059', 'sede-pm-2'),
('prod-pm-s2-1052', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'JUICED BERRY', 'REP-VS CREMA JUICED BERRY-FEM', 'DAMAS', 'cosmetica', 'PM-S2-1052', 3, 0, '2026-03-16', 13000, 22000, NULL, 'Código: 1052', 'sede-pm-2'),
('prod-pm-s2-1058', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LOVE SPELL', 'REP-VS CREMA LOVE SPELL-FEM', 'DAMAS', 'cosmetica', 'PM-S2-1058', 0, 0, '2026-03-16', 12000, 22000, NULL, 'Código: 1058', 'sede-pm-2'),
('prod-pm-s2-1060', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'MANGO TEMPTATION', 'REP-VS CREMA MANGO TEMPTATION-FEM', 'DAMAS', 'cosmetica', 'PM-S2-1060', 3, 0, '2026-03-16', 11000, 22000, NULL, 'Código: 1060', 'sede-pm-2'),
('prod-pm-s2-1056', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'PURE SEDUCTION', 'REP-VS CREMA PURE SEDUCTION-FEM', 'DAMAS', 'cosmetica', 'PM-S2-1056', 3, 0, '2026-03-16', 12000, 22000, NULL, 'Código: 1056', 'sede-pm-2'),
('prod-pm-s2-1051', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'SANDIA', 'REP-VS CREMA SANDIA-FEM', 'DAMAS', 'cosmetica', 'PM-S2-1051', 3, 0, '2026-03-16', 11000, 22000, NULL, 'Código: 1051', 'sede-pm-2'),
('prod-pm-s2-1053', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'VAINILLA LACE', 'REP-VS CREMA VAINILLA LACE-FEM', 'DAMAS', 'cosmetica', 'PM-S2-1053', 2, 0, '2026-03-16', 12000, 22000, NULL, 'Código: 1053', 'sede-pm-2'),
('prod-pm-1364', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', '29K AMBER', 'VIDAN-CREMA TOCADOR-29K AMBER', 'CREMAS', 'cosmetica', 'PM-1364', 2, 0, '2026-03-16', 16900, 29000, NULL, 'Código: 1364', 'sede-pm-2'),
('prod-pm-1368', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', '29K LOVELY', 'VIDAN-CREMA TOCADOR-29K LOVELY', 'CREMAS', 'cosmetica', 'PM-1368', 0, 0, '2026-03-16', 14517, 29000, NULL, 'Código: 1368', 'sede-pm-2'),
('prod-pm-1365', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', '29K SPELL', 'VIDAN-CREMA TOCADOR-29K SPELL', 'CREMAS', 'cosmetica', 'PM-1365', 3, 0, '2026-03-16', 16900, 29000, NULL, 'Código: 1365', 'sede-pm-2'),
('prod-pm-1367', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', '29K VAINILLA', 'VIDAN-CREMA TOCADOR-29K VAINILLA', 'CREMAS', 'cosmetica', 'PM-1367', 1, 0, '2026-03-16', 14517, 29000, NULL, 'Código: 1367', 'sede-pm-2'),
('prod-pm-1366', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'BOMBOM', 'VIDAN-CREMA TOCADOR-BOMBOM', 'CREMAS', 'cosmetica', 'PM-1366', 2, 0, '2026-03-16', 16900, 29000, NULL, 'Código: 1366', 'sede-pm-2'),
('prod-pm-1369', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'FLOWER DREAMS', 'VIDAN-CREMA TOCADOR-FLOWER DREAMS', 'CREMAS', 'cosmetica', 'PM-1369', 1, 0, '2026-03-16', 14517, 29000, NULL, 'Código: 1369', 'sede-pm-2'),
('prod-pm-1363', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'MANGO DREAMS', 'VIDAN-CREMA TOCADOR-MANGO DREAMS', 'CREMAS', 'cosmetica', 'PM-1363', 2, 0, '2026-03-16', 16900, 29000, NULL, 'Código: 1363', 'sede-pm-2'),
('prod-pm-1370', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'PURE DREAM', 'VIDAN-CREMA TOCADOR-PURE DREAM', 'CREMAS', 'cosmetica', 'PM-1370', 1, 0, '2026-03-16', 14517, 29000, NULL, 'Código: 1370', 'sede-pm-2'),
('prod-pm-1424', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', '29K AMBER', 'VIDAN-MINI CREMAS SHIMMER-29K AMBER', 'CREMAS', 'cosmetica', 'PM-1424', 2, 0, '2026-03-16', 5717, 10000, NULL, 'Código: 1424', 'sede-pm-2'),
('prod-pm-1425', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', '29K BOMB', 'VIDAN-MINI CREMAS SHIMMER-29K BOMB', 'CREMAS', 'cosmetica', 'PM-1425', 2, 0, '2026-03-16', 5717, 10000, NULL, 'Código: 1425', 'sede-pm-2'),
('prod-pm-1426', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', '29K LOVELY', 'VIDAN-MINI CREMAS SHIMMER-29K LOVELY', 'CREMAS', 'cosmetica', 'PM-1426', 3, 0, '2026-03-16', 5717, 10000, NULL, 'Código: 1426', 'sede-pm-2'),
('prod-pm-1427', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', '29K SPELL', 'VIDAN-MINI CREMAS SHIMMER-29K SPELL', 'CREMAS', 'cosmetica', 'PM-1427', 4, 0, '2026-03-16', 5717, 10000, NULL, 'Código: 1427', 'sede-pm-2'),
('prod-pm-1428', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', '29K VAINILLA', 'VIDAN-MINI CREMAS SHIMMER-29K VAINILLA', 'CREMAS', 'cosmetica', 'PM-1428', 2, 0, '2026-03-16', 5717, 10000, NULL, 'Código: 1428', 'sede-pm-2'),
('prod-pm-1429', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'BOMBOM', 'VIDAN-MINI CREMAS SHIMMER-BOMBOM', 'CREMAS', 'cosmetica', 'PM-1429', 3, 0, '2026-03-16', 5717, 10000, NULL, 'Código: 1429', 'sede-pm-2'),
('prod-pm-1430', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'COCO DREAMS', 'VIDAN-MINI CREMAS SHIMMER-COCO DREAMS', 'CREMAS', 'cosmetica', 'PM-1430', 2, 0, '2026-03-16', 5717, 10000, NULL, 'Código: 1430', 'sede-pm-2'),
('prod-pm-1431', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'FLOWER DREAMS', 'VIDAN-MINI CREMAS SHIMMER-FLOWER DREAMS', 'CREMAS', 'cosmetica', 'PM-1431', 2, 0, '2026-03-16', 5717, 10000, NULL, 'Código: 1431', 'sede-pm-2'),
('prod-pm-1432', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'MANGO DREAMS', 'VIDAN-MINI CREMAS SHIMMER-MANGO DREAMS', 'CREMAS', 'cosmetica', 'PM-1432', 2, 0, '2026-03-16', 5717, 10000, NULL, 'Código: 1432', 'sede-pm-2'),
('prod-pm-1433', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'PURE DREAMS', 'VIDAN-MINI CREMAS SHIMMER-PURE DREAMS', 'CREMAS', 'cosmetica', 'PM-1433', 2, 0, '2026-03-16', 5717, 10000, NULL, 'Código: 1433', 'sede-pm-2'),
('prod-pm-1434', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'SKY DREAMS', 'VIDAN-MINI CREMAS SHIMMER-SKY DREAMS', 'CREMAS', 'cosmetica', 'PM-1434', 1, 0, '2026-03-16', 5717, 10000, NULL, 'Código: 1434', 'sede-pm-2'),
('prod-pm-1447', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'COCO BLANCO', 'PURPURE-BRILLI BRILLI-COCO BLANCO', 'CREMAS', 'cosmetica', 'PM-1447', 1, 0, '2026-03-16', 9410, 20000, NULL, 'Código: 1447', 'sede-pm-2'),
('prod-pm-1448', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'FRUTAL MORADO', 'PURPURE-BRILLI BRILLI-FRUTAL MORADO', 'CREMAS', 'cosmetica', 'PM-1448', 1, 0, '2026-03-16', 9410, 20000, NULL, 'Código: 1448', 'sede-pm-2'),
('prod-pm-1449', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'VAINILLA ROJO', 'PURPURE-BRILLI BRILLI-VAINILLA ROJO', 'CREMAS', 'cosmetica', 'PM-1449', 0, 0, '2026-03-16', 9410, 20000, NULL, 'Código: 1449', 'sede-pm-2'),
('prod-pm-1466', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'SWEET LYCHE', 'PURPURE-MANTEQUILLA-SWEET LYCHE', 'CREMAS', 'cosmetica', 'PM-1466', 0, 0, '2026-03-16', 14810, 30000, NULL, 'Código: 1466', 'sede-pm-2'),
('prod-pm-1462', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'BUBBLE GUM', 'PURPURE-MINI MANTEQUILLA BELLOTA-BUBBLE GUM', 'CREMAS', 'cosmetica', 'PM-1462', 1, 0, '2026-03-16', 8410, 15000, NULL, 'Código: 1462', 'sede-pm-2'),
('prod-pm-1464', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'CANDY BUM', 'PURPURE-MINI MANTEQUILLA BELLOTA-CANDY BUM', 'CREMAS', 'cosmetica', 'PM-1464', 0, 0, '2026-03-16', 8410, 15000, NULL, 'Código: 1464', 'sede-pm-2'),
('prod-pm-1463', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'CARAMEL CRUSH', 'PURPURE-MINI MANTEQUILLA BELLOTA-CARAMEL CRUSH', 'CREMAS', 'cosmetica', 'PM-1463', 1, 0, '2026-03-16', 8410, 15000, NULL, 'Código: 1463', 'sede-pm-2'),
('prod-pm-1465', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'STRAWBERRY', 'PURPURE-MINI MANTEQUILLA BELLOTA-STRAWBERRY', 'CREMAS', 'cosmetica', 'PM-1465', 1, 0, '2026-03-16', 8410, 15000, NULL, 'Código: 1465', 'sede-pm-2'),
('prod-pm-1461', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'COCONUT SHINE', 'PURPURE-MINI MANTEQUILLA-COCONUT SHINE', 'CREMAS', 'cosmetica', 'PM-1461', 0, 0, '2026-03-16', 7110, 13000, NULL, 'Código: 1461', 'sede-pm-2'),
('prod-pm-1459', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'GIRLBOSS', 'PURPURE-MINI MANTEQUILLA-GIRLBOSS', 'CREMAS', 'cosmetica', 'PM-1459', 2, 0, '2026-03-16', 7110, 13000, NULL, 'Código: 1459', 'sede-pm-2'),
('prod-pm-1460', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'SEXY CHAMPAGNE', 'PURPURE-MINI MANTEQUILLA-SEXY CHAMPAGNE', 'CREMAS', 'cosmetica', 'PM-1460', 1, 0, '2026-03-16', 7110, 13000, NULL, 'Código: 1460', 'sede-pm-2'),
('prod-pm-1457', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'VAINILLA', 'PURPURE-MINI MANTEQUILLA-VAINILLA', 'CREMAS', 'cosmetica', 'PM-1457', 1, 0, '2026-03-16', 7110, 13000, NULL, 'Código: 1457', 'sede-pm-2'),
('prod-pm-1458', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'WATERMELON', 'PURPURE-MINI MANTEQUILLA-WATERMELON', 'CREMAS', 'cosmetica', 'PM-1458', 1, 0, '2026-03-16', 7110, 13000, NULL, 'Código: 1458', 'sede-pm-2'),
('prod-pm-1374', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'COCO', 'VIDAN-MANTEQUILLA BLIME-COCO', 'CREMAS', 'cosmetica', 'PM-1374', 2, 0, '2026-03-16', 17600, 30000, NULL, 'Código: 1374', 'sede-pm-2'),
('prod-pm-1376', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'FRESH', 'VIDAN-MANTEQUILLA BLIME-FRESH', 'CREMAS', 'cosmetica', 'PM-1376', 2, 0, '2026-03-16', 17600, 30000, NULL, 'Código: 1376', 'sede-pm-2'),
('prod-pm-1372', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'FRUTOS ROJOS', 'VIDAN-MANTEQUILLA BLIME-FRUTOS ROJOS', 'CREMAS', 'cosmetica', 'PM-1372', 1, 0, '2026-03-16', 17600, 30000, NULL, 'Código: 1372', 'sede-pm-2'),
('prod-pm-1373', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'MARACUYA', 'VIDAN-MANTEQUILLA BLIME-MARACUYA', 'CREMAS', 'cosmetica', 'PM-1373', 1, 0, '2026-03-16', 17600, 30000, NULL, 'Código: 1373', 'sede-pm-2'),
('prod-pm-1371', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'NARANJA', 'VIDAN-MANTEQUILLA BLIME-NARANJA', 'CREMAS', 'cosmetica', 'PM-1371', 3, 0, '2026-03-16', 17600, 30000, NULL, 'Código: 1371', 'sede-pm-2'),
('prod-pm-1375', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'PIÑA COLADA', 'VIDAN-MANTEQUILLA BLIME-PIÑA COLADA', 'CREMAS', 'cosmetica', 'PM-1375', 0, 0, '2026-03-16', 17600, 30000, NULL, 'Código: 1375', 'sede-pm-2'),
('prod-pm-1444', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', '29K AMBER', 'VIDAN-MANTEQUILLA BRILLO-29K AMBER', 'CREMAS', 'cosmetica', 'PM-1444', 1, 0, '2026-03-16', 15467, 30000, NULL, 'Código: 1444', 'sede-pm-2'),
('prod-pm-1443', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', '29K LOVELY', 'VIDAN-MANTEQUILLA BRILLO-29K LOVELY', 'CREMAS', 'cosmetica', 'PM-1443', 1, 0, '2026-03-16', 15467, 30000, NULL, 'Código: 1443', 'sede-pm-2'),
('prod-pm-1442', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', '29K VAINILLA', 'VIDAN-MANTEQUILLA BRILLO-29K VAINILLA', 'CREMAS', 'cosmetica', 'PM-1442', 1, 0, '2026-03-16', 15467, 30000, NULL, 'Código: 1442', 'sede-pm-2'),
('prod-pm-1445', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'BOMBOM', 'VIDAN-MANTEQUILLA BRILLO-BOMBOM', 'CREMAS', 'cosmetica', 'PM-1445', 1, 0, '2026-03-16', 15467, 30000, NULL, 'Código: 1445', 'sede-pm-2'),
('prod-pm-1440', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'COCO DREAMS', 'VIDAN-MANTEQUILLA BRILLO-COCO DREAMS', 'CREMAS', 'cosmetica', 'PM-1440', 1, 0, '2026-03-16', 15467, 30000, NULL, 'Código: 1440', 'sede-pm-2'),
('prod-pm-1439', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'MANGO DREAMS', 'VIDAN-MANTEQUILLA BRILLO-MANGO DREAMS', 'CREMAS', 'cosmetica', 'PM-1439', 1, 0, '2026-03-16', 15467, 30000, NULL, 'Código: 1439', 'sede-pm-2'),
('prod-pm-1441', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'PURE DREAMS', 'VIDAN-MANTEQUILLA BRILLO-PURE DREAMS', 'CREMAS', 'cosmetica', 'PM-1441', 1, 0, '2026-03-16', 15467, 30000, NULL, 'Código: 1441', 'sede-pm-2'),
('prod-pm-1438', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'SKY DREAMS', 'VIDAN-MANTEQUILLA BRILLO-SKY DREAMS', 'CREMAS', 'cosmetica', 'PM-1438', 1, 0, '2026-03-16', 15467, 30000, NULL, 'Código: 1438', 'sede-pm-2'),
('prod-pm-1423', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'BABY DREAMS', 'VIDAN-MINI MANTEQUILLAS-BABY DREAMS', 'CREMAS', 'cosmetica', 'PM-1423', 1, 0, '2026-03-16', 9317, 18000, NULL, 'Código: 1423', 'sede-pm-2'),
('prod-pm-1421', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'DOLL DREAMS', 'VIDAN-MINI MANTEQUILLAS-DOLL DREAMS', 'CREMAS', 'cosmetica', 'PM-1421', 3, 0, '2026-03-16', 9317, 18000, NULL, 'Código: 1421', 'sede-pm-2'),
('prod-pm-1419', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'NIGHT DREAMS', 'VIDAN-MINI MANTEQUILLAS-NIGHT DREAMS', 'CREMAS', 'cosmetica', 'PM-1419', 2, 0, '2026-03-16', 9317, 18000, NULL, 'Código: 1419', 'sede-pm-2'),
('prod-pm-1420', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'SHINE DREAMS', 'VIDAN-MINI MANTEQUILLAS-SHINE DREAMS', 'CREMAS', 'cosmetica', 'PM-1420', 3, 0, '2026-03-16', 9317, 18000, NULL, 'Código: 1420', 'sede-pm-2'),
('prod-pm-1422', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'SUGAR DREAMS', 'VIDAN-MINI MANTEQUILLAS-SUGAR DREAMS', 'CREMAS', 'cosmetica', 'PM-1422', 2, 0, '2026-03-16', 9317, 18000, NULL, 'Código: 1422', 'sede-pm-2'),
('prod-pm-1418', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'WAVES', 'VIDAN-MINI MANTEQUILLAS-WAVES', 'CREMAS', 'cosmetica', 'PM-1418', 2, 0, '2026-03-16', 9317, 18000, NULL, 'Código: 1418', 'sede-pm-2'),
('prod-pm-1176', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'PINK', 'PM-SHIMMER PINK-FEM', 'DAMAS', 'cosmetica', 'PM-1176', 0, 0, '2026-03-16', 13115, 25000, NULL, 'Código: 1176', 'sede-pm-2'),
('prod-pm-1178', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'SCANDALOUS', 'PM-SHIMMER SCANDALOUS-FEM', 'DAMAS', 'cosmetica', 'PM-1178', 0, 0, '2026-03-16', 13115, 25000, NULL, 'Código: 1178', 'sede-pm-2'),
('prod-pm-1177', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'VELVET', 'PM-SHIMMER VELVET-FEMENINO', 'DAMAS', 'cosmetica', 'PM-1177', 0, 0, '2026-03-16', 13115, 25000, NULL, 'Código: 1177', 'sede-pm-2'),
('prod-pm-879', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'AQUA KISS', 'PM-SPLASH AQUA KISS-FEM', 'DAMAS', 'cosmetica', 'PM-879', 4, 0, '2026-03-16', 10500, 22000, NULL, 'Código: 879', 'sede-pm-2'),
('prod-pm-1129', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ARRURU', 'PM-SPLASH ARRURU-UNI', 'UNISEX', 'cosmetica', 'PM-1129', 2, 0, '2026-03-16', 10000, 22000, NULL, 'Código: 1129', 'sede-pm-2'),
('prod-pm-s2-157', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'BATMAN', 'PM-SPLASH BATMAN-NIÑO', 'UNISEX', 'cosmetica', 'PM-S2-157', 4, 0, '2026-03-16', 9092, 22000, NULL, 'Código: 157', 'sede-pm-2'),
('prod-pm-1125', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'BLUE SEDUCTION', 'PM-SPLASH BLUE SEDUCTION-MAS', 'CABALLEROS', 'cosmetica', 'PM-1125', 1, 0, '2026-03-16', 8000, 22000, NULL, 'Código: 1125', 'sede-pm-2'),
('prod-pm-1124', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'BLUE SQUAD', 'PM-SPLASH BLUE SQUAD-MAS', 'CABALLEROS', 'cosmetica', 'PM-1124', 2, 0, '2026-03-16', 8000, 22000, NULL, 'Código: 1124', 'sede-pm-2'),
('prod-pm-1153', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'BOSS BOTTLE UNL', 'PM-SPLASH BOSS BOTTLE UNL-MAS', 'CABALLEROS', 'cosmetica', 'PM-1153', 5, 0, '2026-03-16', 8000, 22000, NULL, 'Código: 1153', 'sede-pm-2'),
('prod-pm-878', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'BUBBLE GUMMER', 'PM-SPLASH BUBBLE GUMMER-UNI', 'UNISEX', 'cosmetica', 'PM-878', 1, 0, '2026-03-16', 9092, 22000, NULL, 'Código: 878', 'sede-pm-2'),
('prod-pm-1140', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'BUENA CHICA', 'PM-SPLASH BUENA CHICA-FEM', 'DAMAS', 'cosmetica', 'PM-1140', 6, 0, '2026-03-16', 8000, 22000, NULL, 'Código: 1140', 'sede-pm-2'),
('prod-pm-1143', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'CAN CAN', 'PM-SPLASH CAN CAN-FEM', 'DAMAS', 'cosmetica', 'PM-1143', 7, 0, '2026-03-16', 10000, 22000, NULL, 'Código: 1143', 'sede-pm-2'),
('prod-pm-s2-018', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'CAPITAN AMERICA', 'PM-SPLASH CAPITAN AMERICA-NIÑO', 'UNISEX', 'cosmetica', 'PM-S2-018', 5, 0, '2026-03-16', 9092, 22000, NULL, 'Código: 018', 'sede-pm-2'),
('prod-pm-744', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'CARNAVAL 62', 'PM-SPLASH CARNAVAL 62-FEM', 'DAMAS', 'cosmetica', 'PM-744', 9, 0, '2026-03-16', 10500, 22000, NULL, 'Código: 744', 'sede-pm-2'),
('prod-pm-622', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'CARNAVAL 68', 'PM-SPLASH CARNAVAL 68-FEM', 'DAMAS', 'cosmetica', 'PM-622', 2, 0, '2026-03-16', 10500, 22000, NULL, 'Código: 622', 'sede-pm-2'),
('prod-pm-1150', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'CHIFON ROSA', 'PM-SPLASH CHIFON ROSA-FEM', 'DAMAS', 'cosmetica', 'PM-1150', 6, 0, '2026-03-16', 8000, 22000, NULL, 'Código: 1150', 'sede-pm-2'),
('prod-pm-1182', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'CHOCOLATE', 'PM-SPLASH CHOCOLATE-FEM', 'DAMAS', 'cosmetica', 'PM-1182', 4, 0, '2026-03-16', 11000, 22000, NULL, 'Código: 1182', 'sede-pm-2'),
('prod-pm-1145', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'CITRUS MELON', 'PM-SPLASH CITRUS MELON-FEM', 'DAMAS', 'cosmetica', 'PM-1145', 10, 0, '2026-03-16', 8000, 22000, NULL, 'Código: 1145', 'sede-pm-2'),
('prod-pm-1133', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'COCO VAINILLA', 'PM-SPLASH COCO VAINILLA-FEM', 'DAMAS', 'cosmetica', 'PM-1133', 0, 0, '2026-03-16', 8000, 22000, NULL, 'Código: 1133', 'sede-pm-2'),
('prod-pm-1130', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'COCONUT PASSION', 'PM-SPLASH COCONUT PASSION-FEM', 'DAMAS', 'cosmetica', 'PM-1130', 9, 0, '2026-03-16', 8000, 22000, NULL, 'Código: 1130', 'sede-pm-2'),
('prod-pm-1149', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'FRESA', 'PM-SPLASH FRESA-FEM', 'DAMAS', 'cosmetica', 'PM-1149', 9, 0, '2026-03-16', 8000, 22000, NULL, 'Código: 1149', 'sede-pm-2'),
('prod-pm-874', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'FROZEN', 'PM-SPLASH FROZEN-NIÑA', 'UNISEX', 'cosmetica', 'PM-874', 0, 0, '2026-03-16', 9092, 22000, NULL, 'Código: 874', 'sede-pm-2'),
('prod-pm-1151', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'FRUITS', 'PM-SPLASH FRUITS-FEM', 'DAMAS', 'cosmetica', 'PM-1151', 10, 0, '2026-03-16', 8000, 22000, NULL, 'Código: 1151', 'sede-pm-2'),
('prod-pm-1127', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'GIRL POWER', 'PM-SPLASH GIRL POWER-FEM', 'DAMAS', 'cosmetica', 'PM-1127', 0, 0, '2026-03-16', 8000, 22000, NULL, 'Código: 1127', 'sede-pm-2'),
('prod-pm-1126', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'GLAM ANGEL', 'PM-SPLASH GLAM ANGEL-FEM', 'DAMAS', 'cosmetica', 'PM-1126', 6, 0, '2026-03-16', 8000, 22000, NULL, 'Código: 1126', 'sede-pm-2'),
('prod-pm-1142', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'HEIRESS', 'PM-SPLASH HEIRESS-FEM', 'DAMAS', 'cosmetica', 'PM-1142', 8, 0, '2026-03-16', 10000, 22000, NULL, 'Código: 1142', 'sede-pm-2'),
('prod-pm-1155', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'INVICTUS', 'PM-SPLASH INVICTUS-MAS', 'CABALLEROS', 'cosmetica', 'PM-1155', 5, 0, '2026-03-16', 10000, 22000, NULL, 'Código: 1155', 'sede-pm-2'),
('prod-pm-1180', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'JUICED BERRY', 'PM-SPLASH JUICED BERRY-FEM', 'DAMAS', 'cosmetica', 'PM-1180', 3, 0, '2026-03-16', 12000, 22000, NULL, 'Código: 1180', 'sede-pm-2'),
('prod-pm-1157', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LACOSTE RED', 'PM-SPLASH LACOSTE RED-MAS', 'CABALLEROS', 'cosmetica', 'PM-1157', 9, 0, '2026-03-16', 8000, 22000, NULL, 'Código: 1157', 'sede-pm-2'),
('prod-pm-1148', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'MANGO', 'PM-SPLASH MANGO-FEM', 'DAMAS', 'cosmetica', 'PM-1148', 10, 0, '2026-03-16', 8000, 22000, NULL, 'Código: 1148', 'sede-pm-2'),
('prod-pm-s2-203', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'MARIO BROSS', 'PM-SPLASH MARIO BROSS-NIÑO', 'UNISEX', 'cosmetica', 'PM-S2-203', 0, 0, '2026-03-16', 9092, 22000, NULL, 'Código: 203', 'sede-pm-2'),
('prod-pm-876', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'MONSTER HIGHT', 'PM-SPLASH MONSTER HIGHT-NIÑA', 'UNISEX', 'cosmetica', 'PM-876', 1, 0, '2026-03-16', 9092, 22000, NULL, 'Código: 876', 'sede-pm-2'),
('prod-pm-1156', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'NAUTICO', 'PM-SPLASH NAUTICO-MAS', 'CABALLEROS', 'cosmetica', 'PM-1156', 10, 0, '2026-03-16', 10000, 22000, NULL, 'Código: 1156', 'sede-pm-2'),
('prod-pm-1158', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'NOT SEET', 'PM-SPLASH NOT SEET-MAS', 'CABALLEROS', 'cosmetica', 'PM-1158', 10, 0, '2026-03-16', 10000, 22000, NULL, 'Código: 1158', 'sede-pm-2'),
('prod-pm-1137', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'PARIS PASSION', 'PM-SPLASH PARIS PASSION-FEM', 'DAMAS', 'cosmetica', 'PM-1137', 0, 0, '2026-03-16', 8000, 22000, NULL, 'Código: 1137', 'sede-pm-2'),
('prod-pm-1147', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'PERA', 'PM-SPLASH PERA-FEM', 'DAMAS', 'cosmetica', 'PM-1147', 3, 0, '2026-03-16', 8000, 22000, NULL, 'Código: 1147', 'sede-pm-2'),
('prod-pm-1123', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'PHANTOM LEGION', 'PM-SPLASH PHANTOM LEGION-MAS', 'CABALLEROS', 'cosmetica', 'PM-1123', 2, 0, '2026-03-16', 10000, 22000, NULL, 'Código: 1123', 'sede-pm-2'),
('prod-pm-1139', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'PINK', 'PM-SPLASH PINK-FEM', 'DAMAS', 'cosmetica', 'PM-1139', 5, 0, '2026-03-16', 8000, 22000, NULL, 'Código: 1139', 'sede-pm-2'),
('prod-pm-1138', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'PONY STRUCKS', 'PM-SPLASH PONY STRUCKS-FEM', 'DAMAS', 'cosmetica', 'PM-1138', 4, 0, '2026-03-16', 8000, 22000, NULL, 'Código: 1138', 'sede-pm-2'),
('prod-pm-1154', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'POWER MIX', 'PM-SPLASH POWER MIX-MAS', 'CABALLEROS', 'cosmetica', 'PM-1154', 2, 0, '2026-03-16', 10000, 22000, NULL, 'Código: 1154', 'sede-pm-2'),
('prod-pm-1141', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'PURE SEDUCTION', 'PM-SPLASH PURE SEDUCTION-FEM', 'DAMAS', 'cosmetica', 'PM-1141', 7, 0, '2026-03-16', 10000, 22000, NULL, 'Código: 1141', 'sede-pm-2'),
('prod-pm-1152', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'SANDIA', 'PM-SPLASH SANDIA-FEM', 'DAMAS', 'cosmetica', 'PM-1152', 7, 0, '2026-03-16', 8000, 22000, NULL, 'Código: 1152', 'sede-pm-2'),
('prod-pm-s2-201', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'SAUVAGE', 'PM-SPLASH SAUVAGE-MAS', 'CABALLEROS', 'cosmetica', 'PM-S2-201', 8, 0, '2026-03-16', 11000, 22000, NULL, 'Código: 201', 'sede-pm-2'),
('prod-pm-1179', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'SCANDALOUS', 'PM-SPLASH SCANDALOUS-FEM', 'DAMAS', 'cosmetica', 'PM-1179', 4, 0, '2026-03-16', 10000, 22000, NULL, 'Código: 1179', 'sede-pm-2'),
('prod-pm-875', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'SIRENITA', 'PM-SPLASH SIRENITA-NIÑA', 'UNISEX', 'cosmetica', 'PM-875', 3, 0, '2026-03-16', 9092, 22000, NULL, 'Código: 875', 'sede-pm-2'),
('prod-pm-877', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'SUAVE CARICIA', 'PM-SPLASH SUAVE CARICIA-UNI', 'UNISEX', 'cosmetica', 'PM-877', 3, 0, '2026-03-16', 9092, 22000, NULL, 'Código: 877', 'sede-pm-2'),
('prod-pm-1144', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'TALCO', 'PM-SPLASH TALCO-FEM', 'DAMAS', 'cosmetica', 'PM-1144', 6, 0, '2026-03-16', 8000, 22000, NULL, 'Código: 1144', 'sede-pm-2'),
('prod-pm-1131', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'V DAME AMOR', 'PM-SPLASH V DAME AMOR-FEM', 'DAMAS', 'cosmetica', 'PM-1131', 4, 0, '2026-03-16', 8000, 22000, NULL, 'Código: 1131', 'sede-pm-2'),
('prod-pm-1132', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'V RUSH', 'PM-SPLASH V RUSH-FEM', 'DAMAS', 'cosmetica', 'PM-1132', 9, 0, '2026-03-16', 8000, 22000, NULL, 'Código: 1132', 'sede-pm-2'),
('prod-pm-1136', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'V SEDUCTORA', 'PM-SPLASH V SEDUCTORA-FEM', 'DAMAS', 'cosmetica', 'PM-1136', 8, 0, '2026-03-16', 8000, 22000, NULL, 'Código: 1136', 'sede-pm-2'),
('prod-pm-1135', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'VAINILLA', 'PM-SPLASH VAINILLA-FEM', 'DAMAS', 'cosmetica', 'PM-1135', 7, 0, '2026-03-16', 8000, 22000, NULL, 'Código: 1135', 'sede-pm-2'),
('prod-pm-1181', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'VELVET PETALS', 'PM-SPLASH VELVET PETALS-FEM', 'DAMAS', 'cosmetica', 'PM-1181', 10, 0, '2026-03-16', 10000, 22000, NULL, 'Código: 1181', 'sede-pm-2'),
('prod-pm-1134', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'VERY SEXY', 'PM-SPLASH VERY SEXY-FEM', 'DAMAS', 'cosmetica', 'PM-1134', 9, 0, '2026-03-16', 8000, 22000, NULL, 'Código: 1134', 'sede-pm-2'),
('prod-pm-1455', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ADDICTION GIRL', 'PURPURE-MINI SPLASH-ADDICTION GIRL', 'CREMAS', 'cosmetica', 'PM-1455', 1, 0, '2026-03-16', 9910, 18000, NULL, 'Código: 1455', 'sede-pm-2'),
('prod-pm-1453', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'BIRTHDAY CAKE', 'PURPURE-MINI SPLASH-BIRTHDAY CAKE', 'CREMAS', 'cosmetica', 'PM-1453', 2, 0, '2026-03-16', 9910, 18000, NULL, 'Código: 1453', 'sede-pm-2'),
('prod-pm-1451', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'CANDY BUM', 'PURPURE-MINI SPLASH-CANDY BUM', 'CREMAS', 'cosmetica', 'PM-1451', 0, 0, '2026-03-16', 9910, 18000, NULL, 'Código: 1451', 'sede-pm-2'),
('prod-pm-1454', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'COCONUT SHINE', 'PURPURE-MINI SPLASH-COCONUT SHINE', 'CREMAS', 'cosmetica', 'PM-1454', 2, 0, '2026-03-16', 9910, 18000, NULL, 'Código: 1454', 'sede-pm-2'),
('prod-pm-1452', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'SEXY CHAMPAGNE', 'PURPURE-MINI SPLASH-SEXY CHAMPAGNE', 'CREMAS', 'cosmetica', 'PM-1452', 1, 0, '2026-03-16', 9910, 18000, NULL, 'Código: 1452', 'sede-pm-2'),
('prod-pm-1456', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'SWEET LYCHEE', 'PURPURE-MINI SPLASH-SWEET LYCHEE', 'CREMAS', 'cosmetica', 'PM-1456', 0, 0, '2026-03-16', 9910, 18000, NULL, 'Código: 1456', 'sede-pm-2'),
('prod-pm-1450', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'VAINILLA DREAMS', 'PURPURE-MINI SPLASH-VAINILLA DREAMS', 'CREMAS', 'cosmetica', 'PM-1450', 2, 0, '2026-03-16', 9910, 18000, NULL, 'Código: 1450', 'sede-pm-2'),
('prod-pm-1484', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'AMBER ROUGE', 'REP-AEROSOL-AMBER ROUGE-UNI', 'UNISEX', 'cosmetica', 'PM-1484', 1, 0, '2026-03-16', 16000, 30000, NULL, 'Código: 1484', 'sede-pm-2'),
('prod-pm-1485', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'AMETHYST', 'REP-AEROSOL-AMETHYST-UNI', 'UNISEX', 'cosmetica', 'PM-1485', 1, 0, '2026-03-16', 16000, 30000, NULL, 'Código: 1485', 'sede-pm-2'),
('prod-pm-1482', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'BHARARA KING', 'REP-AEROSOL-BHARARA KING-MAS', 'CABALLEROS', 'cosmetica', 'PM-1482', 1, 0, '2026-03-16', 16000, 30000, NULL, 'Código: 1482', 'sede-pm-2'),
('prod-pm-1483', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'HAYA', 'REP-AEROSOL-HAYA-FEM', 'DAMAS', 'cosmetica', 'PM-1483', 1, 0, '2026-03-16', 16000, 30000, NULL, 'Código: 1483', 'sede-pm-2'),
('prod-pm-1480', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'HONOR Y GLORY', 'REP-AEROSOL-HONOR Y GLORY-UNI', 'UNISEX', 'cosmetica', 'PM-1480', 1, 0, '2026-03-16', 16000, 30000, NULL, 'Código: 1480', 'sede-pm-2'),
('prod-pm-1475', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'KHAMRAH', 'REP-AEROSOL-KHAMRAH-UNI', 'UNISEX', 'cosmetica', 'PM-1475', 1, 0, '2026-03-16', 16000, 30000, NULL, 'Código: 1475', 'sede-pm-2'),
('prod-pm-s2-019', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'NOBLE BLUSH', 'REP-AEROSOL-NOBLE BLUSH-FEM', 'DAMAS', 'cosmetica', 'PM-S2-019', 1, 0, '2026-03-16', 16000, 30000, NULL, 'Código: 019', 'sede-pm-2'),
('prod-pm-1477', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ODYSSEY MANDARIN SKY', 'REP-AEROSOL-ODYSSEY MANDARIN SKY-MAS', 'CABALLEROS', 'cosmetica', 'PM-1477', 1, 0, '2026-03-16', 16000, 30000, NULL, 'Código: 1477', 'sede-pm-2'),
('prod-pm-1476', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'OUD FOR GLORY', 'REP-AEROSOL-OUD FOR GLORY-UNI', 'UNISEX', 'cosmetica', 'PM-1476', 1, 0, '2026-03-16', 16000, 30000, NULL, 'Código: 1476', 'sede-pm-2'),
('prod-pm-1478', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ROYAL AMBER', 'REP-AEROSOL-ROYAL AMBER-UNI', 'UNISEX', 'cosmetica', 'PM-1478', 1, 0, '2026-03-16', 16000, 30000, NULL, 'Código: 1478', 'sede-pm-2'),
('prod-pm-1481', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'VELVET GOLD', 'REP-AEROSOL-VELVET GOLD-FEM', 'DAMAS', 'cosmetica', 'PM-1481', 0, 0, '2026-03-16', 16000, 30000, NULL, 'Código: 1481', 'sede-pm-2'),
('prod-pm-1479', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'YARA CANDY', 'REP-AEROSOL-YARA CANDY-FEM', 'DAMAS', 'cosmetica', 'PM-1479', 1, 0, '2026-03-16', 16000, 30000, NULL, 'Código: 1479', 'sede-pm-2'),
('prod-pm-1417', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', '1 MILLON', 'REP-SPLASH ACRILICOS-1 MILLON-MAS', 'CABALLEROS', 'cosmetica', 'PM-1417', 1, 0, '2026-03-16', 11000, 22000, NULL, 'Código: 1417', 'sede-pm-2'),
('prod-pm-1391', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'AMBER OUD GOLD', 'REP-SPLASH ACRILICOS-AMBER OUD GOLD-UNI', 'UNISEX', 'cosmetica', 'PM-1391', 0, 0, '2026-03-16', 10000, 22000, NULL, 'Código: 1391', 'sede-pm-2'),
('prod-pm-1388', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'AMBER ROUGE', 'REP-SPLASH ACRILICOS-AMBER ROUGE-UNI', 'UNISEX', 'cosmetica', 'PM-1388', 1, 0, '2026-03-16', 10000, 22000, NULL, 'Código: 1388', 'sede-pm-2'),
('prod-pm-1385', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ASAD BOURBON', 'REP-SPLASH ACRILICOS-ASAD BOURBON-MAS', 'CABALLEROS', 'cosmetica', 'PM-1385', 0, 0, '2026-03-16', 10000, 22000, NULL, 'Código: 1385', 'sede-pm-2'),
('prod-pm-1390', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ASAD', 'REP-SPLASH ACRILICOS-ASAD-MAS', 'CABALLEROS', 'cosmetica', 'PM-1390', 0, 0, '2026-03-16', 10000, 22000, NULL, 'Código: 1390', 'sede-pm-2'),
('prod-pm-1381', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'DELIHNA', 'REP-SPLASH ACRILICOS-DELIHNA-FEM', 'DAMAS', 'cosmetica', 'PM-1381', 1, 0, '2026-03-16', 10000, 22000, NULL, 'Código: 1381', 'sede-pm-2'),
('prod-pm-1380', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'HAYA', 'REP-SPLASH ACRILICOS-HAYA-FEM', 'DAMAS', 'cosmetica', 'PM-1380', 1, 0, '2026-03-16', 10000, 22000, NULL, 'Código: 1380', 'sede-pm-2'),
('prod-pm-1389', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'HONOR Y GLORY', 'REP-SPLASH ACRILICOS-HONOR Y GLORY-UNI', 'UNISEX', 'cosmetica', 'PM-1389', 1, 0, '2026-03-16', 10000, 22000, NULL, 'Código: 1389', 'sede-pm-2'),
('prod-pm-1387', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'KHAMRAH', 'REP-SPLASH ACRILICOS-KHAMRAH-UNI', 'UNISEX', 'cosmetica', 'PM-1387', 2, 0, '2026-03-16', 10000, 22000, NULL, 'Código: 1387', 'sede-pm-2'),
('prod-pm-1384', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'MANDARIN SKY', 'REP-SPLASH ACRILICOS-MANDARIN SKY-MAS', 'CABALLEROS', 'cosmetica', 'PM-1384', 1, 0, '2026-03-16', 10000, 22000, NULL, 'Código: 1384', 'sede-pm-2'),
('prod-pm-1392', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'NAUTICA VOYAGE', 'REP-SPLASH ACRILICOS-NAUTICA VOYAGE-MAS', 'CABALLEROS', 'cosmetica', 'PM-1392', 0, 0, '2026-03-16', 10000, 22000, NULL, 'Código: 1392', 'sede-pm-2'),
('prod-pm-1386', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'SANTAL 33', 'REP-SPLASH ACRILICOS-SANTAL 33-UNI', 'UNISEX', 'cosmetica', 'PM-1386', 1, 0, '2026-03-16', 10000, 22000, NULL, 'Código: 1386', 'sede-pm-2'),
('prod-pm-1379', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'SWEET LIKE CANDY', 'REP-SPLASH ACRILICOS-SWEET LIKE CANDY-FEM', 'DAMAS', 'cosmetica', 'PM-1379', 1, 0, '2026-03-16', 10000, 22000, NULL, 'Código: 1379', 'sede-pm-2'),
('prod-pm-1378', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'THANK U NEXT', 'REP-SPLASH ACRILICOS-THANK U NEXT-FEM', 'DAMAS', 'cosmetica', 'PM-1378', 2, 0, '2026-03-16', 10000, 22000, NULL, 'Código: 1378', 'sede-pm-2'),
('prod-pm-1122', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'TOY PEARL', 'REP-SPLASH ACRILICOS-TOY PEARL-UNI', 'UNISEX', 'cosmetica', 'PM-1122', 1, 0, '2026-03-16', 11000, 22000, NULL, 'Código: 1122', 'sede-pm-2'),
('prod-pm-1377', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'YARA CANDY', 'REP-SPLASH ACRILICOS-YARA CANDY-FEM', 'DAMAS', 'cosmetica', 'PM-1377', 2, 0, '2026-03-16', 11000, 22000, NULL, 'Código: 1377', 'sede-pm-2'),
('prod-pm-1382', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'YARA MOI', 'REP-SPLASH ACRILICOS-YARA MOI-FEM', 'DAMAS', 'cosmetica', 'PM-1382', 0, 0, '2026-03-16', 10000, 22000, NULL, 'Código: 1382', 'sede-pm-2'),
('prod-pm-1383', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'YARA', 'REP-SPLASH ACRILICOS-YARA-FEM', 'DAMAS', 'cosmetica', 'PM-1383', 1, 0, '2026-03-16', 11000, 22000, NULL, 'Código: 1383', 'sede-pm-2'),
('prod-pm-1171', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'APPLE SWIRL', 'REP-VS SPLASH APPLE SWIRL-FEM', 'DAMAS', 'cosmetica', 'PM-1171', 2, 0, '2026-03-16', 10000, 22000, NULL, 'Código: 1171', 'sede-pm-2'),
('prod-pm-1166', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'AQUA KISS', 'REP-VS SPLASH AQUA KISS-FEM', 'DAMAS', 'cosmetica', 'PM-1166', 2, 0, '2026-03-16', 10000, 22000, NULL, 'Código: 1166', 'sede-pm-2'),
('prod-pm-1167', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'BOMBSHELL', 'REP-VS SPLASH BOMBSHELL-FEM', 'DAMAS', 'cosmetica', 'PM-1167', 2, 0, '2026-03-16', 12000, 22000, NULL, 'Código: 1167', 'sede-pm-2'),
('prod-pm-1169', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'CHIFFON PINK', 'REP-VS SPLASH CHIFFON PINK-FEM', 'DAMAS', 'cosmetica', 'PM-1169', 3, 0, '2026-03-16', 11000, 22000, NULL, 'Código: 1169', 'sede-pm-2'),
('prod-pm-1173', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'COCONUT PASSION', 'REP-VS SPLASH COCONUT PASSION-FEM', 'DAMAS', 'cosmetica', 'PM-1173', 3, 0, '2026-03-16', 11000, 22000, NULL, 'Código: 1173', 'sede-pm-2'),
('prod-pm-1162', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ENDLESS LOVE', 'REP-VS SPLASH ENDLESS LOVE-FEM', 'DAMAS', 'cosmetica', 'PM-1162', 3, 0, '2026-03-16', 10000, 22000, NULL, 'Código: 1162', 'sede-pm-2'),
('prod-pm-1175', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'GUMDSOP', 'REP-VS SPLASH GUMDSOP-FEM', 'DAMAS', 'cosmetica', 'PM-1175', 0, 0, '2026-03-16', 11000, 22000, NULL, 'Código: 1175', 'sede-pm-2'),
('prod-pm-1165', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'JUICED BERRY', 'REP-VS SPLASH JUICED BERRY-FEM', 'DAMAS', 'cosmetica', 'PM-1165', 3, 0, '2026-03-16', 11000, 22000, NULL, 'Código: 1165', 'sede-pm-2'),
('prod-pm-1170', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'JUNGLE PARTY', 'REP-VS SPLASH JUNGLE PARTY-FEM', 'DAMAS', 'cosmetica', 'PM-1170', 1, 0, '2026-03-16', 10000, 22000, NULL, 'Código: 1170', 'sede-pm-2'),
('prod-pm-1160', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LOVE SPELL', 'REP-VS SPLASH LOVE SPELL-FEM', 'DAMAS', 'cosmetica', 'PM-1160', 3, 0, '2026-03-16', 11000, 22000, NULL, 'Código: 1160', 'sede-pm-2'),
('prod-pm-1168', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'MANGO TEMPTATION', 'REP-VS SPLASH MANGO TEMPTATION-FEM', 'DAMAS', 'cosmetica', 'PM-1168', 3, 0, '2026-03-16', 12000, 22000, NULL, 'Código: 1168', 'sede-pm-2'),
('prod-pm-1164', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'MARINE CHILL', 'REP-VS SPLASH MARINE CHILL-FEM', 'DAMAS', 'cosmetica', 'PM-1164', 2, 0, '2026-03-16', 10000, 22000, NULL, 'Código: 1164', 'sede-pm-2'),
('prod-pm-1163', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'MIDNIGHT BLOOM', 'REP-VS SPLASH MIDNIGHT BLOOM-FEM', 'DAMAS', 'cosmetica', 'PM-1163', 2, 0, '2026-03-16', 11000, 22000, NULL, 'Código: 1163', 'sede-pm-2'),
('prod-pm-1172', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'PURE SEDUCTION', 'REP-VS SPLASH PURE SEDUCTION-FEM', 'DAMAS', 'cosmetica', 'PM-1172', 1, 0, '2026-03-16', 11000, 22000, NULL, 'Código: 1172', 'sede-pm-2'),
('prod-pm-1161', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'SANDIA', 'REP-VS SPLASH SANDIA-FEM', 'DAMAS', 'cosmetica', 'PM-1161', 0, 0, '2026-03-16', 11000, 22000, NULL, 'Código: 1161', 'sede-pm-2'),
('prod-pm-1393', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'VAINILA BUTTER', 'REP-VS SPLASH VAINILA BUTTER-FEM', 'DAMAS', 'cosmetica', 'PM-1393', 1, 0, '2026-03-16', 11000, 22000, NULL, 'Código: 1393', 'sede-pm-2'),
('prod-pm-1159', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'VAINILLA LACE', 'REP-VS SPLASH VAINILLA LACE-FEM', 'DAMAS', 'cosmetica', 'PM-1159', 1, 0, '2026-03-16', 11000, 22000, NULL, 'Código: 1159', 'sede-pm-2'),
('prod-pm-1174', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'VELVET PETALS', 'REP-VS SPLASH VELVET PETALS-FEM', 'DAMAS', 'cosmetica', 'PM-1174', 0, 0, '2026-03-16', 11000, 22000, NULL, 'Código: 1174', 'sede-pm-2'),
('prod-pm-1183', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'PM WOOD NOIR', 'SPLASH-PM WOOD NOIR-MASCULINO', 'CABALLEROS', 'cosmetica', 'PM-1183', 5, 0, '2026-03-16', 11000, 22000, NULL, 'Código: 1183', 'sede-pm-2'),
('prod-pm-1436', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', '29K SPELL', 'VIDAN-MINI SPLASH-29K SPELL', 'CREMAS', 'cosmetica', 'PM-1436', 0, 0, '2026-03-16', 1, 10000, NULL, 'Código: 1436', 'sede-pm-2'),
('prod-pm-1435', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'BOMBOM', 'VIDAN-MINI SPLASH-BOMBOM', 'CREMAS', 'cosmetica', 'PM-1435', 1, 0, '2026-03-16', 1, 10000, NULL, 'Código: 1435', 'sede-pm-2'),
('prod-pm-1437', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'PURE DREAMS', 'VIDAN-MINI SPLASH-PURE DREAMS', 'CREMAS', 'cosmetica', 'PM-1437', 0, 0, '2026-03-16', 1, 10000, NULL, 'Código: 1437', 'sede-pm-2');

-- SEDE 2 — ENVASES (76 filas)
INSERT INTO products (id, tenant_id, name, articulo, category, product_type, sku, stock, reorder_point, entry_date, purchase_price, sale_price, presentation, notes, sede_id) VALUES
('prod-pm-1333', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ATLANTE CLEAR 30 ML', 'FRASCO-ATLANTE CLEAR 30 ML', 'INSUMOS', 'cosmetica', 'PM-1333', 49, 0, '2026-03-16', 947, 2000, NULL, 'Código: 1333', 'sede-pm-2'),
('prod-pm-1334', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ATLANTE CLEAR 70 ML', 'FRASCO-ATLANTE CLEAR 70 ML', 'INSUMOS', 'cosmetica', 'PM-1334', 47, 0, '2026-03-16', 1202, 3000, NULL, 'Código: 1334', 'sede-pm-2'),
('prod-pm-1329', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'SECRET CLEAR 110 ML', 'FRASCO-SECRET CLEAR 110 ML', 'INSUMOS', 'cosmetica', 'PM-1329', 49, 0, '2026-03-16', 1861, 4000, NULL, 'Código: 1329', 'sede-pm-2'),
('prod-pm-1328', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'SECRET CLEAR 60 ML', 'FRASCO-SECRET CLEAR 60 ML', 'INSUMOS', 'cosmetica', 'PM-1328', 33, 0, '2026-03-16', 1104, 3000, NULL, 'Código: 1328', 'sede-pm-2'),
('prod-pm-1331', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'SWARO 60 ML', 'FRASCO-SWARO 60 ML', 'INSUMOS', 'cosmetica', 'PM-1331', 48, 0, '2026-03-16', 1485, 3000, NULL, 'Código: 1331', 'sede-pm-2'),
('prod-pm-1330', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'SWARO CLEAR 30 ML', 'FRASCO-SWARO CLEAR 30 ML', 'INSUMOS', 'cosmetica', 'PM-1330', 40, 0, '2026-03-16', 977, 2000, NULL, 'Código: 1330', 'sede-pm-2'),
('prod-pm-1332', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'SWARO CLEAR BOTTLE 110 ML', 'FRASCO-SWARO CLEAR BOTTLE 110 ML', 'INSUMOS', 'cosmetica', 'PM-1332', 36, 0, '2026-03-16', 2269, 4000, NULL, 'Código: 1332', 'sede-pm-2'),
('prod-pm-1341', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'MINIMALIST 50 ML', 'FRASCO- MINIMALIST 50 ML', 'INSUMOS', 'cosmetica', 'PM-1341', 68, 0, '2026-03-16', 3164, 6000, NULL, 'Código: 1341', 'sede-pm-2'),
('prod-pm-1298', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', '212 VIP 60 ML', 'FRASCO-212 VIP 60 ML', 'INSUMOS', 'cosmetica', 'PM-1298', 0, 0, '2026-03-16', 6500, 12000, NULL, 'Código: 1298', 'sede-pm-2'),
('prod-pm-1316', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', '212 VIP 80 ML', 'FRASCO-212 VIP 80 ML', 'INSUMOS', 'cosmetica', 'PM-1316', 8, 0, '2026-03-16', 7000, 13000, NULL, 'Código: 1316', 'sede-pm-2'),
('prod-pm-s2-071', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ABUDABI 50 ML', 'FRASCO-ABUDABI 50 ML', 'INSUMOS', 'cosmetica', 'PM-S2-071', 9, 0, '2026-03-16', 7060, 12000, NULL, 'Código: 071', 'sede-pm-2'),
('prod-pm-1296', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ARABE 60 ML', 'FRASCO-ARABE 60 ML', 'INSUMOS', 'cosmetica', 'PM-1296', 0, 0, '2026-03-16', 5880, 10000, NULL, 'Código: 1296', 'sede-pm-2'),
('prod-pm-1356', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'BERRY 30 ML', 'FRASCO-BERRY 30 ML', 'INSUMOS', 'cosmetica', 'PM-1356', 12, 0, '2026-03-16', 3905, 7000, NULL, 'Código: 1356', 'sede-pm-2'),
('prod-pm-1358', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'BIANCA 30 ML', 'FRASCO-BIANCA 30 ML', 'INSUMOS', 'cosmetica', 'PM-1358', 11, 0, '2026-03-16', 5205, 10000, NULL, 'Código: 1358', 'sede-pm-2'),
('prod-pm-1289', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'BOSS 30 ML', 'FRASCO-BOSS 30 ML', 'INSUMOS', 'cosmetica', 'PM-1289', 19, 0, '2026-03-16', 3800, 8000, NULL, 'Código: 1289', 'sede-pm-2'),
('prod-pm-1295', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'BOSS 60 ML', 'FRASCO-BOSS 60 ML', 'INSUMOS', 'cosmetica', 'PM-1295', 5, 0, '2026-03-16', 4000, 8000, NULL, 'Código: 1295', 'sede-pm-2'),
('prod-pm-1317', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'BVLAGRI 60 ML', 'FRASCO-BVLAGRI 60 ML', 'INSUMOS', 'cosmetica', 'PM-1317', 4, 0, '2026-03-16', 5600, 10000, NULL, 'Código: 1317', 'sede-pm-2'),
('prod-pm-1319', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'CACHE 100 ML', 'FRASCO-CACHE 100 ML', 'INSUMOS', 'cosmetica', 'PM-1319', 43, 0, '2026-03-16', 3378, 6000, NULL, 'Código: 1319', 'sede-pm-2'),
('prod-pm-1309', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'CALAVERA 60 ML', 'FRASCO-CALAVERA 60 ML', 'INSUMOS', 'cosmetica', 'PM-1309', 0, 0, '2026-03-16', 6500, 12000, NULL, 'Código: 1309', 'sede-pm-2'),
('prod-pm-1292', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'CARTIER 30 ML', 'FRASCO-CARTIER 30 ML', 'INSUMOS', 'cosmetica', 'PM-1292', 4, 0, '2026-03-16', 2600, 5000, NULL, 'Código: 1292', 'sede-pm-2'),
('prod-pm-1281', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'CHAMPIONS 30 ML', 'FRASCO-CHAMPIONS 30 ML', 'INSUMOS', 'cosmetica', 'PM-1281', 22, 0, '2026-03-16', 4406, 8000, NULL, 'Código: 1281', 'sede-pm-2'),
('prod-pm-1311', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'CHAMPIONS 60 ML', 'FRASCO-CHAMPIONS 60 ML', 'INSUMOS', 'cosmetica', 'PM-1311', 6, 0, '2026-03-16', 4500, 10000, NULL, 'Código: 1311', 'sede-pm-2'),
('prod-pm-1307', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'CHATEAU 60 ML', 'FRASCO-CHATEAU 60 ML', 'INSUMOS', 'cosmetica', 'PM-1307', 241, 0, '2026-03-16', 2971, 6000, NULL, 'Código: 1307', 'sede-pm-2'),
('prod-pm-1305', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'CORAZON 60 ML', 'FRASCO-CORAZON 60 ML', 'INSUMOS', 'cosmetica', 'PM-1305', 102, 0, '2026-03-16', 5000, 10000, NULL, 'Código: 1305', 'sede-pm-2'),
('prod-pm-1312', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'CREED 60 ML', 'FRASCO-CREED 60 ML', 'INSUMOS', 'cosmetica', 'PM-1312', 0, 0, '2026-03-16', 7000, 12000, NULL, 'Código: 1312', 'sede-pm-2'),
('prod-pm-1285', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'CUADRADO BLUE 30 ML', 'FRASCO-CUADRADO BLUE 30 ML', 'INSUMOS', 'cosmetica', 'PM-1285', 0, 0, '2026-03-16', 2600, 5000, NULL, 'Código: 1285', 'sede-pm-2'),
('prod-pm-s2-204', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'CURVE 50ML', 'FRASCO-CURVE 50ML', 'INSUMOS', 'cosmetica', 'PM-S2-204', 2, 0, '2026-03-16', 6370, 10000, NULL, 'Código: 204', 'sede-pm-2'),
('prod-pm-1294', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'DISCO 30 ML', 'FRASCO-DISCO 30 ML', 'INSUMOS', 'cosmetica', 'PM-1294', 1, 0, '2026-03-16', 2000, 4000, NULL, 'Código: 1294', 'sede-pm-2'),
('prod-pm-1291', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'DUBAI 30 ML', 'FRASCO-DUBAI 30 ML', 'INSUMOS', 'cosmetica', 'PM-1291', 36, 0, '2026-03-16', 3437, 7000, NULL, 'Código: 1291', 'sede-pm-2'),
('prod-pm-1306', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'DUBAI 60 ML', 'FRASCO-DUBAI 60 ML', 'INSUMOS', 'cosmetica', 'PM-1306', 15, 0, '2026-03-16', 3800, 7000, NULL, 'Código: 1306', 'sede-pm-2'),
('prod-pm-1338', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'EMIR 30 ML', 'FRASCO-EMIR 30 ML', 'INSUMOS', 'cosmetica', 'PM-1338', 1, 0, '2026-03-16', 3290, 6000, NULL, 'Código: 1338', 'sede-pm-2'),
('prod-pm-1357', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'FUTURA- FEMENINO 30 ML', 'FRASCO-FUTURA- FEMENINO 30 ML', 'INSUMOS', 'cosmetica', 'PM-1357', 11, 0, '2026-03-16', 8505, 10000, NULL, 'Código: 1357', 'sede-pm-2'),
('prod-pm-1355', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'FUTURISTA- MASCULINO- 30 ML', 'FRASCO-FUTURISTA- MASCULINO- 30 ML', 'INSUMOS', 'cosmetica', 'PM-1355', 19, 0, '2026-03-16', 4855, 10000, NULL, 'Código: 1355', 'sede-pm-2'),
('prod-pm-1315', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'GATO 80 ML', 'FRASCO-GATO 80 ML', 'INSUMOS', 'cosmetica', 'PM-1315', 0, 0, '2026-03-16', 6500, 12000, NULL, 'Código: 1315', 'sede-pm-2'),
('prod-pm-1313', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'GRANADA 100 ML', 'FRASCO-GRANADA 100 ML', 'INSUMOS', 'cosmetica', 'PM-1313', 0, 0, '2026-03-16', 5000, 10000, NULL, 'Código: 1313', 'sede-pm-2'),
('prod-pm-1297', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'GUITARRA 60 ML', 'FRASCO-GUITARRA 60 ML', 'INSUMOS', 'cosmetica', 'PM-1297', 23, 0, '2026-03-16', 5165, 9000, NULL, 'Código: 1297', 'sede-pm-2'),
('prod-pm-1284', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ISSEY MIYAKE 30 ML', 'FRASCO-ISSEY MIYAKE 30 ML', 'INSUMOS', 'cosmetica', 'PM-1284', 0, 0, '2026-03-16', 3500, 6000, NULL, 'Código: 1284', 'sede-pm-2'),
('prod-pm-1303', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'JPG 60 ML', 'FRASCO-JPG 60 ML', 'INSUMOS', 'cosmetica', 'PM-1303', 19, 0, '2026-03-16', 3800, 8000, NULL, 'Código: 1303', 'sede-pm-2'),
('prod-pm-s2-047', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'KHALIFA 50 ML', 'FRASCO-KHALIFA 50 ML', 'INSUMOS', 'cosmetica', 'PM-S2-047', 11, 0, '2026-03-16', 6833, 10000, NULL, 'Código: 047', 'sede-pm-2'),
('prod-pm-1320', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LA VIDA ES BELLA 110 ML', 'FRASCO-LA VIDA ES BELLA 110 ML', 'INSUMOS', 'cosmetica', 'PM-1320', 1, 0, '2026-03-16', 6000, 10000, NULL, 'Código: 1320', 'sede-pm-2'),
('prod-pm-1301', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LA VIDA ES BELLA 60 ML', 'FRASCO-LA VIDA ES BELLA 60 ML', 'INSUMOS', 'cosmetica', 'PM-1301', 0, 0, '2026-03-16', 3700, 9000, NULL, 'Código: 1301', 'sede-pm-2'),
('prod-pm-1318', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LACOSTE 100 ML', 'FRASCO-LACOSTE 100 ML', 'INSUMOS', 'cosmetica', 'PM-1318', 12, 0, '2026-03-16', 6600, 10000, NULL, 'Código: 1318', 'sede-pm-2'),
('prod-pm-1360', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LACOSTE 30 ML', 'FRASCO-LACOSTE 30 ML', 'INSUMOS', 'cosmetica', 'PM-1360', 12, 0, '2026-03-16', 3305, 8000, NULL, 'Código: 1360', 'sede-pm-2'),
('prod-pm-1359', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LINA 30 ML', 'FRASCO-LINA 30 ML', 'INSUMOS', 'cosmetica', 'PM-1359', 11, 0, '2026-03-16', 4105, 8000, NULL, 'Código: 1359', 'sede-pm-2'),
('prod-pm-1362', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LUNAIRE 50 ML', 'FRASCO-LUNAIRE 50 ML', 'INSUMOS', 'cosmetica', 'PM-1362', 10, 0, '2026-03-16', 5205, 10000, NULL, 'Código: 1362', 'sede-pm-2'),
('prod-pm-1282', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'MANZANA 30 ML', 'FRASCO-MANZANA 30 ML', 'INSUMOS', 'cosmetica', 'PM-1282', 0, 0, '2026-03-16', 3300, 7000, NULL, 'Código: 1282', 'sede-pm-2'),
('prod-pm-1339', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'MARIPOSA DORADA 100 ML', 'FRASCO-MARIPOSA DORADA 100 ML', 'INSUMOS', 'cosmetica', 'PM-1339', 16, 0, '2026-03-16', 7239, 12000, NULL, 'Código: 1339', 'sede-pm-2'),
('prod-pm-1287', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'MEDIA LUNA 30 ML', 'FRASCO-MEDIA LUNA 30 ML', 'INSUMOS', 'cosmetica', 'PM-1287', 1, 0, '2026-03-16', 2500, 5000, NULL, 'Código: 1287', 'sede-pm-2'),
('prod-pm-1286', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'MILLION 30 ML', 'FRASCO-MILLION 30 ML', 'INSUMOS', 'cosmetica', 'PM-1286', 1, 0, '2026-03-16', 3500, 6000, NULL, 'Código: 1286', 'sede-pm-2'),
('prod-pm-1310', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'MONTBLANC 65 ML', 'FRASCO-MONTBLANC 65 ML', 'INSUMOS', 'cosmetica', 'PM-1310', 6, 0, '2026-03-16', 6000, 10000, NULL, 'Código: 1310', 'sede-pm-2'),
('prod-pm-1288', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'OSO 30 ML', 'FRASCO-OSO 30 ML', 'INSUMOS', 'cosmetica', 'PM-1288', 25, 0, '2026-03-16', 4605, 10000, NULL, 'Código: 1288', 'sede-pm-2'),
('prod-pm-1302', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'PACO XS 60 ML', 'FRASCO-PACO XS 60 ML', 'INSUMOS', 'cosmetica', 'PM-1302', 0, 0, '2026-03-16', 4500, 9000, NULL, 'Código: 1302', 'sede-pm-2'),
('prod-pm-s2-035', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'PASSION CORAZON 100ML', 'FRASCO-PASSION CORAZON 100ML', 'INSUMOS', 'cosmetica', 'PM-S2-035', 11, 0, '2026-03-16', 7965, 12000, NULL, 'Código: 035', 'sede-pm-2'),
('prod-pm-1354', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'PATINETA 30 ML', 'FRASCO-PATINETA 30 ML', 'INSUMOS', 'cosmetica', 'PM-1354', 11, 0, '2026-03-16', 4700, 8000, NULL, 'Código: 1354', 'sede-pm-2'),
('prod-pm-1314', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'PUÑO DIESEL 100 ML', 'FRASCO-PUÑO DIESEL 100 ML', 'INSUMOS', 'cosmetica', 'PM-1314', 4, 0, '2026-03-16', 6500, 12000, NULL, 'Código: 1314', 'sede-pm-2'),
('prod-pm-1308', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'PUÑO DIESEL 60 ML', 'FRASCO-PUÑO DIESEL 60 ML', 'INSUMOS', 'cosmetica', 'PM-1308', 2, 0, '2026-03-16', 4000, 7000, NULL, 'Código: 1308', 'sede-pm-2'),
('prod-pm-1361', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'SCANDAL 50 ML', 'FRASCO-SCANDAL 50 ML', 'INSUMOS', 'cosmetica', 'PM-1361', 11, 0, '2026-03-16', 5305, 10000, NULL, 'Código: 1361', 'sede-pm-2'),
('prod-pm-1335', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'SINGLE 100 ML', 'FRASCO-SINGLE 100 ML', 'INSUMOS', 'cosmetica', 'PM-1335', 52, 0, '2026-03-16', 3727, 6000, NULL, 'Código: 1335', 'sede-pm-2'),
('prod-pm-1280', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'SINGLE CLEAR 30 ML', 'FRASCO-SINGLE CLEAR 30 ML', 'INSUMOS', 'cosmetica', 'PM-1280', 7, 0, '2026-03-16', 1823, 3000, NULL, 'Código: 1280', 'sede-pm-2'),
('prod-pm-1293', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'SINGLE COLORES 30 ML', 'FRASCO-SINGLE COLORES 30 ML', 'INSUMOS', 'cosmetica', 'PM-1293', 71, 0, '2026-03-16', 2200, 5000, NULL, 'Código: 1293', 'sede-pm-2'),
('prod-pm-1446', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'SINGLE COLORES ECO 30 ML', 'FRASCO-SINGLE COLORES ECO 30 ML', 'INSUMOS', 'cosmetica', 'PM-1446', 112, 0, '2026-03-16', 1500, 3000, NULL, 'Código: 1446', 'sede-pm-2'),
('prod-pm-1290', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'TACON 30 ML', 'FRASCO-TACON 30 ML', 'INSUMOS', 'cosmetica', 'PM-1290', 12, 0, '2026-03-16', 5500, 10000, NULL, 'Código: 1290', 'sede-pm-2'),
('prod-pm-1283', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'TORRE 30ML', 'FRASCO-TORRE 30ML', 'INSUMOS', 'cosmetica', 'PM-1283', 12, 0, '2026-03-16', 5200, 10000, NULL, 'Código: 1283', 'sede-pm-2'),
('prod-pm-1299', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'TORRE IFEL 60 ML', 'FRASCO-TORRE IFEL 60 ML', 'INSUMOS', 'cosmetica', 'PM-1299', 11, 0, '2026-03-16', 8000, 12000, NULL, 'Código: 1299', 'sede-pm-2'),
('prod-pm-1336', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'VALENTINO 30 ML', 'FRASCO-VALENTINO 30 ML', 'INSUMOS', 'cosmetica', 'PM-1336', 12, 0, '2026-03-16', 3500, 8000, NULL, 'Código: 1336', 'sede-pm-2'),
('prod-pm-1304', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'VALENTINO 50 ML', 'FRASCO-VALENTINO 50 ML', 'INSUMOS', 'cosmetica', 'PM-1304', 14, 0, '2026-03-16', 5000, 10000, NULL, 'Código: 1304', 'sede-pm-2'),
('prod-pm-1342', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'XERFOJ 30 ML', 'FRASCO-XERFOJ 30 ML', 'INSUMOS', 'cosmetica', 'PM-1342', 15, 0, '2026-03-16', 3505, 8000, NULL, 'Código: 1342', 'sede-pm-2'),
('prod-pm-1300', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'XERJOFF 50 ML', 'FRASCO-XERJOFF 50 ML', 'INSUMOS', 'cosmetica', 'PM-1300', 7, 0, '2026-03-16', 4700, 10000, NULL, 'Código: 1300', 'sede-pm-2'),
('prod-pm-1323', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'PERFUMERO 15 ML', 'FRASCO-PERFUMERO 15 ML', 'INSUMOS', 'cosmetica', 'PM-1323', 145, 0, '2026-03-16', 1148, 2000, NULL, 'Código: 1323', 'sede-pm-2'),
('prod-pm-1325', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'PERFUMERO CLASIC 3 ML', 'FRASCO-PERFUMERO CLASIC 3 ML', 'INSUMOS', 'cosmetica', 'PM-1325', 196, 0, '2026-03-16', 779, 1000, NULL, 'Código: 1325', 'sede-pm-2'),
('prod-pm-1324', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'PERFUMERO CLASIC 8 ML', 'FRASCO-PERFUMERO CLASIC 8 ML', 'INSUMOS', 'cosmetica', 'PM-1324', 71, 0, '2026-03-16', 880, 2000, NULL, 'Código: 1324', 'sede-pm-2'),
('prod-pm-1321', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'PERFUMERO RECARGABLE 5 ML', 'FRASCO-PERFUMERO RECARGABLE 5 ML', 'INSUMOS', 'cosmetica', 'PM-1321', 52, 0, '2026-03-16', 3695, 8000, NULL, 'Código: 1321', 'sede-pm-2'),
('prod-pm-1340', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'PERFUMERO RECARGABLE 8ML', 'FRASCO-PERFUMERO RECARGABLE 8ML', 'INSUMOS', 'cosmetica', 'PM-1340', 2, 0, '2026-03-16', 3695, 10000, NULL, 'Código: 1340', 'sede-pm-2'),
('prod-pm-1327', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ROLL ON 18 ML', 'FRASCO-ROLL ON 18 ML', 'INSUMOS', 'cosmetica', 'PM-1327', 16, 0, '2026-03-16', 1786, 3000, NULL, 'Código: 1327', 'sede-pm-2'),
('prod-pm-1326', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ROLL ON 7 ML', 'FRASCO-ROLL ON 7 ML', 'INSUMOS', 'cosmetica', 'PM-1326', 129, 0, '2026-03-16', 630, 1000, NULL, 'Código: 1326', 'sede-pm-2'),
('prod-pm-1322', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'VIPET 60 ML', 'FRASCO-VIPET 60 ML', 'INSUMOS', 'cosmetica', 'PM-1322', 171, 0, '2026-03-16', 1753, 4000, NULL, 'Código: 1322', 'sede-pm-2');

-- SEDE 2 — PERFUMERÍA SEDE 2 (686 filas)
INSERT INTO products (id, tenant_id, name, articulo, category, product_type, sku, stock, reorder_point, entry_date, purchase_price, sale_price, presentation, notes, sede_id) VALUES
('prod-pm-1340-b', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'PROMOCION', 'PROMOCION', 'CREMAS', 'cosmetica', 'PM-1340-B', 7, 0, '2026-03-16', 10000, 10000, NULL, 'Código: 1340', 'sede-pm-2'),
('prod-pm-1201', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'FEROMONAS', 'FEROMONAS', 'CREMAS', 'cosmetica', 'PM-1201', 7, 0, '2026-03-16', 4000, 10000, NULL, 'Código: 1201', 'sede-pm-2'),
('prod-pm-309', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'FEROMONAS X 10 GOTAS', 'FEROMONAS X 10 GOTAS', 'CREMAS', 'cosmetica', 'PM-309', 183, 0, '2026-03-16', 400, 1000, NULL, 'Código: 309', 'sede-pm-2'),
('prod-pm-1343', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'PRINCESA SOFIA', 'PM-SPLASH PRINCESA SOFIA-NIÑA', 'UNISEX', 'cosmetica', 'PM-1343', 3, 0, '2026-03-16', 10000, 22000, NULL, 'Código: 1343', 'sede-pm-2'),
('prod-pm-s2-1008', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'KITS', 'KITS-NIÑA', 'UNISEX', 'cosmetica', 'PM-S2-1008', 2, 0, '2026-03-16', 9800, 17000, NULL, 'Código: 1008', 'sede-pm-2'),
('prod-pm-s2-1009', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'KITS', 'KITS-NIÑO', 'UNISEX', 'cosmetica', 'PM-S2-1009', 7, 0, '2026-03-16', 9800, 17000, NULL, 'Código: 1009', 'sede-pm-2'),
('prod-pm-1467', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'VAINILLA CAKE', 'PURPURE-KITS-VAINILLA CAKE', 'CREMAS', 'cosmetica', 'PM-1467', 1, 0, '2026-03-16', 18410, 32000, NULL, 'Código: 1467', 'sede-pm-2'),
('prod-pm-s2-1022', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ARIANA GRANDE CLOUD', 'REP-KITS ARIANA GRANDE CLOUD-FEM', 'DAMAS', 'cosmetica', 'PM-S2-1022', 1, 0, '2026-03-16', 24000, 50000, NULL, 'Código: 1022', 'sede-pm-2'),
('prod-pm-1473', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ARIANA GRANDE THANK U NEXT', 'REP-KITS ARIANA GRANDE THANK U NEXT-FEM', 'DAMAS', 'cosmetica', 'PM-1473', 1, 0, '2026-03-16', 24000, 50000, NULL, 'Código: 1473', 'sede-pm-2'),
('prod-pm-1472', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ARIANA GRANDE-SWEET LIKE CANDY', 'REP-KITS ARIANA GRANDE-SWEET LIKE CANDY-FEM', 'DAMAS', 'cosmetica', 'PM-1472', 1, 0, '2026-03-16', 24000, 50000, NULL, 'Código: 1472', 'sede-pm-2'),
('prod-pm-s2-1019', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'BRITNEY SPEARS FANTASY', 'REP-KITS BRITNEY SPEARS FANTASY-FEM', 'DAMAS', 'cosmetica', 'PM-S2-1019', 0, 0, '2026-03-16', 23000, 50000, NULL, 'Código: 1019', 'sede-pm-2'),
('prod-pm-s2-1012', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'CAROLINA HERRERA 212 VIP ROSE', 'REP-KITS CAROLINA HERRERA 212 VIP ROSE-FEM', 'DAMAS', 'cosmetica', 'PM-S2-1012', 1, 0, '2026-03-16', 24000, 50000, NULL, 'Código: 1012', 'sede-pm-2'),
('prod-pm-s2-1001', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'CAROLINA HERRERA 212 VIP', 'REP-KITS CAROLINA HERRERA 212 VIP-MAS', 'CABALLEROS', 'cosmetica', 'PM-S2-1001', 0, 0, '2026-03-16', 20000, 50000, NULL, 'Código: 1001', 'sede-pm-2'),
('prod-pm-s2-1016', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'CAROLINA HERRERA 212', 'REP-KITS CAROLINA HERRERA 212-MAS', 'CABALLEROS', 'cosmetica', 'PM-S2-1016', 1, 0, '2026-03-16', 20000, 50000, NULL, 'Código: 1016', 'sede-pm-2'),
('prod-pm-s2-1017', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'CAROLINA HERRERA GOOD GIRL', 'REP-KITS CAROLINA HERRERA GOOD GIRL-FEM', 'DAMAS', 'cosmetica', 'PM-S2-1017', 0, 0, '2026-03-16', 22000, 50000, NULL, 'Código: 1017', 'sede-pm-2'),
('prod-pm-s2-1015', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'HUGO BOSS BOSS BOTTLED UNLIMITED', 'REP-KITS HUGO BOSS BOSS BOTTLED UNLIMITED-MAS', 'CABALLEROS', 'cosmetica', 'PM-S2-1015', 1, 0, '2026-03-16', 20000, 50000, NULL, 'Código: 1015', 'sede-pm-2'),
('prod-pm-s2-1003', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ISSEY MIYAKE ISSEY MIYAKE', 'REP-KITS ISSEY MIYAKE ISSEY MIYAKE-MAS', 'CABALLEROS', 'cosmetica', 'PM-S2-1003', 1, 0, '2026-03-16', 20000, 50000, NULL, 'Código: 1003', 'sede-pm-2'),
('prod-pm-s2-1021', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'JEAN PAUL GAULTIER SCANDAL', 'REP-KITS JEAN PAUL GAULTIER SCANDAL-MAS', 'CABALLEROS', 'cosmetica', 'PM-S2-1021', 1, 0, '2026-03-16', 28000, 50000, NULL, 'Código: 1021', 'sede-pm-2'),
('prod-pm-s2-1014', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LACOSTE LACOSTE RED', 'REP-KITS LACOSTE LACOSTE RED-MAS', 'CABALLEROS', 'cosmetica', 'PM-S2-1014', 1, 0, '2026-03-16', 20000, 50000, NULL, 'Código: 1014', 'sede-pm-2'),
('prod-pm-1349', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LATAFFA YARA CANDY', 'REP-KITS LATAFFA YARA CANDY-FEM', 'DAMAS', 'cosmetica', 'PM-1349', 0, 0, '2026-03-16', 24000, 50000, NULL, 'Código: 1349', 'sede-pm-2'),
('prod-pm-s2-1024', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LATTAFA AMETHYST', 'REP-KITS LATTAFA AMETHYST-UNI', 'UNISEX', 'cosmetica', 'PM-S2-1024', 1, 0, '2026-03-16', 23000, 50000, NULL, 'Código: 1024', 'sede-pm-2'),
('prod-pm-s2-1028', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LATTAFA ASAD', 'REP-KITS LATTAFA ASAD-MAS', 'CABALLEROS', 'cosmetica', 'PM-S2-1028', 0, 0, '2026-03-16', 28000, 50000, NULL, 'Código: 1028', 'sede-pm-2'),
('prod-pm-s2-1030', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LATTAFA HONOR Y GLORY', 'REP-KITS LATTAFA HONOR Y GLORY-UNI', 'UNISEX', 'cosmetica', 'PM-S2-1030', 1, 0, '2026-03-16', 23000, 50000, NULL, 'Código: 1030', 'sede-pm-2'),
('prod-pm-s2-1025', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LATTAFA SUBLIME', 'REP-KITS LATTAFA SUBLIME-UNI', 'UNISEX', 'cosmetica', 'PM-S2-1025', 0, 0, '2026-03-16', 23000, 50000, NULL, 'Código: 1025', 'sede-pm-2'),
('prod-pm-s2-1026', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LATTAFA YARA', 'REP-KITS LATTAFA YARA-FEM', 'DAMAS', 'cosmetica', 'PM-S2-1026', 1, 0, '2026-03-16', 24000, 50000, NULL, 'Código: 1026', 'sede-pm-2'),
('prod-pm-s2-1027', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'MONTALE STARRY NIGHT', 'REP-KITS MONTALE STARRY NIGHT-FEM', 'DAMAS', 'cosmetica', 'PM-S2-1027', 1, 0, '2026-03-16', 28000, 50000, NULL, 'Código: 1027', 'sede-pm-2'),
('prod-pm-s2-1010', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'MOSCHINO TOY 2 BUBBLE GUM', 'REP-KITS MOSCHINO TOY 2 BUBBLE GUM-FEM', 'DAMAS', 'cosmetica', 'PM-S2-1010', 0, 0, '2026-03-16', 20000, 50000, NULL, 'Código: 1010', 'sede-pm-2'),
('prod-pm-s2-1023', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'MOSCHINO TOY 2 PEARL', 'REP-KITS MOSCHINO TOY 2 PEARL-UNI', 'UNISEX', 'cosmetica', 'PM-S2-1023', 0, 0, '2026-03-16', 28000, 50000, NULL, 'Código: 1023', 'sede-pm-2'),
('prod-pm-s2-1007', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'MOSCHINO TOY 2', 'REP-KITS MOSCHINO TOY 2-FEM', 'DAMAS', 'cosmetica', 'PM-S2-1007', 0, 0, '2026-03-16', 27000, 50000, NULL, 'Código: 1007', 'sede-pm-2'),
('prod-pm-s2-1005', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'MOSCHINO TOY BOY', 'REP-KITS MOSCHINO TOY BOY-MAS', 'CABALLEROS', 'cosmetica', 'PM-S2-1005', 1, 0, '2026-03-16', 22000, 50000, NULL, 'Código: 1005', 'sede-pm-2'),
('prod-pm-s2-1029', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ORIENTICA AMBER ROUGE', 'REP-KITS ORIENTICA AMBER ROUGE-UNI', 'UNISEX', 'cosmetica', 'PM-S2-1029', 0, 0, '2026-03-16', 28000, 50000, NULL, 'Código: 1029', 'sede-pm-2'),
('prod-pm-s2-1020', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ORIENTICA VELVET GOLD', 'REP-KITS ORIENTICA VELVET GOLD-FEM', 'DAMAS', 'cosmetica', 'PM-S2-1020', 1, 0, '2026-03-16', 23000, 50000, NULL, 'Código: 1020', 'sede-pm-2'),
('prod-pm-s2-1013', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'PACO RABANNE 1 MILLION LUCKY', 'REP-KITS PACO RABANNE 1 MILLION LUCKY-MAS', 'CABALLEROS', 'cosmetica', 'PM-S2-1013', 0, 0, '2026-03-16', 20000, 50000, NULL, 'Código: 1013', 'sede-pm-2'),
('prod-pm-s2-1004', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'PACO RABANNE 1 MILLION', 'REP-KITS PACO RABANNE 1 MILLION-MAS', 'CABALLEROS', 'cosmetica', 'PM-S2-1004', 0, 0, '2026-03-16', 20000, 50000, NULL, 'Código: 1004', 'sede-pm-2'),
('prod-pm-s2-1002', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'PACO RABANNE INVICTUS', 'REP-KITS PACO RABANNE INVICTUS-MAS', 'CABALLEROS', 'cosmetica', 'PM-S2-1002', 0, 0, '2026-03-16', 20000, 50000, NULL, 'Código: 1002', 'sede-pm-2'),
('prod-pm-s2-1018', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'PACO RABANNE OLYMPEA', 'REP-KITS PACO RABANNE OLYMPEA-FEM', 'DAMAS', 'cosmetica', 'PM-S2-1018', 0, 0, '2026-03-16', 23000, 50000, NULL, 'Código: 1018', 'sede-pm-2'),
('prod-pm-s2-1006', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'PARIS HILTON CAN CAN', 'REP-KITS PARIS HILTON CAN CAN-FEM', 'DAMAS', 'cosmetica', 'PM-S2-1006', 1, 0, '2026-03-16', 27000, 50000, NULL, 'Código: 1006', 'sede-pm-2'),
('prod-pm-s2-1011', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'PARIS HILTON PARIS HILTON', 'REP-KITS PARIS HILTON PARIS HILTON-FEM', 'DAMAS', 'cosmetica', 'PM-S2-1011', 0, 0, '2026-03-16', 27000, 50000, NULL, 'Código: 1011', 'sede-pm-2'),
('prod-pm-816', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'AFNAN-9 AM DIVE', 'REP-AFNAN-9 AM DIVE-UNI', 'UNISEX', 'cosmetica', 'PM-816', 1, 0, '2026-03-16', 72000, 130000, NULL, 'Código: 816', 'sede-pm-2'),
('prod-pm-782', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'AFNAN-9 AM SALMON', 'REP-AFNAN-9 AM SALMON-FEM', 'DAMAS', 'cosmetica', 'PM-782', 0, 0, '2026-03-16', 45000, 100000, NULL, 'Código: 782', 'sede-pm-2'),
('prod-pm-892', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'AFNAN-9 PM ELIXIR', 'REP-AFNAN-9 PM ELIXIR-MAS', 'CABALLEROS', 'cosmetica', 'PM-892', 2, 0, '2026-03-16', 62000, 125000, NULL, 'Código: 892', 'sede-pm-2'),
('prod-pm-781', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'AFNAN-9 PM MORADA', 'REP-AFNAN-9 PM MORADA-FEM', 'DAMAS', 'cosmetica', 'PM-781', 1, 0, '2026-03-16', 45000, 100000, NULL, 'Código: 781', 'sede-pm-2'),
('prod-pm-883', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'AFNAN-9 PM REBEL', 'REP-AFNAN-9 PM REBEL-UNI', 'UNISEX', 'cosmetica', 'PM-883', 2, 0, '2026-03-16', 62000, 130000, NULL, 'Código: 883', 'sede-pm-2'),
('prod-pm-783', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'AFNAN-9 PM', 'REP-AFNAN-9 PM-MAS', 'CABALLEROS', 'cosmetica', 'PM-783', 2, 0, '2026-03-16', 46000, 95000, NULL, 'Código: 783', 'sede-pm-2'),
('prod-pm-820', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'AHLI-CORVUS', 'REP-AHLI-CORVUS-FEM', 'DAMAS', 'cosmetica', 'PM-820', 0, 0, '2026-03-16', 57000, 100000, NULL, 'Código: 820', 'sede-pm-2'),
('prod-pm-706', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'AHLI-VEGA', 'REP-AHLI-VEGA-UNI', 'UNISEX', 'cosmetica', 'PM-706', 1, 0, '2026-03-16', 57000, 100000, NULL, 'Código: 706', 'sede-pm-2'),
('prod-pm-710', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'AL HARAMAIN-AMBER OUD GOLD', 'REP-AL HARAMAIN-AMBER OUD GOLD-UNI', 'UNISEX', 'cosmetica', 'PM-710', 2, 0, '2026-03-16', 71000, 145000, NULL, 'Código: 710', 'sede-pm-2'),
('prod-pm-778', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'AL HARAMAIN-L AVENTURE BLANCHE', 'REP-AL HARAMAIN-L AVENTURE BLANCHE-UNI', 'UNISEX', 'cosmetica', 'PM-778', 1, 0, '2026-03-16', 60000, 125000, NULL, 'Código: 778', 'sede-pm-2'),
('prod-pm-766', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ANTONIO BANDERAS-BLUE SEDUCTION', 'REP-ANTONIO BANDERAS-BLUE SEDUCTION-FEM', 'DAMAS', 'cosmetica', 'PM-766', 1, 0, '2026-03-16', 34000, 80000, NULL, 'Código: 766', 'sede-pm-2');
INSERT INTO products (id, tenant_id, name, articulo, category, product_type, sku, stock, reorder_point, entry_date, purchase_price, sale_price, presentation, notes, sede_id) VALUES
('prod-pm-861', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ARD AL KHALEEJ-GHALA ZAYED LUXURY GOLD', 'REP-ARD AL KHALEEJ-GHALA ZAYED LUXURY GOLD-MAS', 'CABALLEROS', 'cosmetica', 'PM-861', 1, 0, '2026-03-16', 77000, 145000, NULL, 'Código: 861', 'sede-pm-2'),
('prod-pm-772', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ARIANA GRANDE-ARI', 'REP-ARIANA GRANDE-ARI-FEM', 'DAMAS', 'cosmetica', 'PM-772', 1, 0, '2026-03-16', 47000, 97000, NULL, 'Código: 772', 'sede-pm-2'),
('prod-pm-771', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ARIANA GRANDE-CLOUD PINK', 'REP-ARIANA GRANDE-CLOUD PINK-FEM', 'DAMAS', 'cosmetica', 'PM-771', 0, 0, '2026-03-16', 57000, 125000, NULL, 'Código: 771', 'sede-pm-2'),
('prod-pm-721', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ARIANA GRANDE-CLOUD', 'REP-ARIANA GRANDE-CLOUD-FEM', 'DAMAS', 'cosmetica', 'PM-721', 2, 0, '2026-03-16', 56000, 120000, NULL, 'Código: 721', 'sede-pm-2'),
('prod-pm-770', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ARIANA GRANDE-MOD BLUSH', 'REP-ARIANA GRANDE-MOD BLUSH-FEM', 'DAMAS', 'cosmetica', 'PM-770', 0, 0, '2026-03-16', 50000, 110000, NULL, 'Código: 770', 'sede-pm-2'),
('prod-pm-719', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ARIANA GRANDE-MOON LIGHT', 'REP-ARIANA GRANDE-MOON LIGHT-FEM', 'DAMAS', 'cosmetica', 'PM-719', 1, 0, '2026-03-16', 37000, 85000, NULL, 'Código: 719', 'sede-pm-2'),
('prod-pm-713', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ARIANA GRANDE-REM', 'REP-ARIANA GRANDE-REM-FEM', 'DAMAS', 'cosmetica', 'PM-713', 1, 0, '2026-03-16', 60000, 115000, NULL, 'Código: 713', 'sede-pm-2'),
('prod-pm-822', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ARIANA GRANDE-THANK U NEXT 2.0', 'REP-ARIANA GRANDE-THANK U NEXT 2.0-FEM', 'DAMAS', 'cosmetica', 'PM-822', 0, 0, '2026-03-16', 62000, 125000, NULL, 'Código: 822', 'sede-pm-2'),
('prod-pm-769', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ARIANA GRANDE-THANK U NEXT', 'REP-ARIANA GRANDE-THANK U NEXT-FEM', 'DAMAS', 'cosmetica', 'PM-769', 2, 0, '2026-03-16', 56000, 120000, NULL, 'Código: 769', 'sede-pm-2'),
('prod-pm-708', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ARMAF-CLUB DE NUIT INTENSE', 'REP-ARMAF-CLUB DE NUIT INTENSE-MAS', 'CABALLEROS', 'cosmetica', 'PM-708', 2, 0, '2026-03-16', 67000, 130000, NULL, 'Código: 708', 'sede-pm-2'),
('prod-pm-886', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ARMAF-CLUB DE NUIT MALEKA', 'REP-ARMAF-CLUB DE NUIT MALEKA-FEM', 'DAMAS', 'cosmetica', 'PM-886', 2, 0, '2026-03-16', 72000, 135000, NULL, 'Código: 886', 'sede-pm-2'),
('prod-pm-866', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ARMAF-CLUB DE NUIT MILESTONE', 'REP-ARMAF-CLUB DE NUIT MILESTONE-UNI', 'UNISEX', 'cosmetica', 'PM-866', 1, 0, '2026-03-16', 71000, 155000, NULL, 'Código: 866', 'sede-pm-2'),
('prod-pm-1352', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ARMAF-CLUB DE NUIT SILLAGE', 'REP-ARMAF-CLUB DE NUIT SILLAGE-UNI', 'UNISEX', 'cosmetica', 'PM-1352', 1, 0, '2026-03-16', 72000, 135000, NULL, 'Código: 1352', 'sede-pm-2'),
('prod-pm-827', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ARMAF-CLUB DE NUIT UNTOLD', 'REP-ARMAF-CLUB DE NUIT UNTOLD-UNI', 'UNISEX', 'cosmetica', 'PM-827', 2, 0, '2026-03-16', 72000, 140000, NULL, 'Código: 827', 'sede-pm-2'),
('prod-pm-881', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ARMAF-ISLAND BLISS', 'REP-ARMAF-ISLAND BLISS-FEM', 'DAMAS', 'cosmetica', 'PM-881', 2, 0, '2026-03-16', 85000, 160000, NULL, 'Código: 881', 'sede-pm-2'),
('prod-pm-868', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ARMAF-ODYSSEY CANDEE', 'REP-ARMAF-ODYSSEY CANDEE-FEM', 'DAMAS', 'cosmetica', 'PM-868', 1, 0, '2026-03-16', 67000, 135000, NULL, 'Código: 868', 'sede-pm-2'),
('prod-pm-858', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ARMAF-ODYSSEY MANDARIN SKY', 'REP-ARMAF-ODYSSEY MANDARIN SKY-MAS', 'CABALLEROS', 'cosmetica', 'PM-858', 2, 0, '2026-03-16', 60000, 120000, NULL, 'Código: 858', 'sede-pm-2'),
('prod-pm-870', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ARMAF-ODYSSEY MEGA', 'REP-ARMAF-ODYSSEY MEGA-MAS', 'CABALLEROS', 'cosmetica', 'PM-870', 1, 0, '2026-03-16', 62000, 125000, NULL, 'Código: 870', 'sede-pm-2'),
('prod-pm-872', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ARMAF-ODYSSEY SPECTRA', 'REP-ARMAF-ODYSSEY SPECTRA-UNI', 'UNISEX', 'cosmetica', 'PM-872', 1, 0, '2026-03-16', 67000, 125000, NULL, 'Código: 872', 'sede-pm-2'),
('prod-pm-624', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ARMAF-YUM YUM', 'REP-ARMAF-YUM YUM-FEM', 'DAMAS', 'cosmetica', 'PM-624', 1, 0, '2026-03-16', 87000, 160000, NULL, 'Código: 624', 'sede-pm-2'),
('prod-pm-799', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'BHARARA-BHARARA BLEU', 'REP-BHARARA-BHARARA BLEU-MAS', 'CABALLEROS', 'cosmetica', 'PM-799', 1, 0, '2026-03-16', 95000, 195000, NULL, 'Código: 799', 'sede-pm-2'),
('prod-pm-855', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'BHARARA-BHARARA KING PARFUM', 'REP-BHARARA-BHARARA KING PARFUM-MAS', 'CABALLEROS', 'cosmetica', 'PM-855', 0, 0, '2026-03-16', 102000, 160000, NULL, 'Código: 855', 'sede-pm-2'),
('prod-pm-801', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'BHARARA-BHARARA KING', 'REP-BHARARA-BHARARA KING-MAS', 'CABALLEROS', 'cosmetica', 'PM-801', 2, 0, '2026-03-16', 77000, 150000, NULL, 'Código: 801', 'sede-pm-2'),
('prod-pm-802', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'BHARARA-NICHE FEMME', 'REP-BHARARA-NICHE FEMME-FEM', 'DAMAS', 'cosmetica', 'PM-802', 1, 0, '2026-03-16', 81000, 150000, NULL, 'Código: 802', 'sede-pm-2'),
('prod-pm-821', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'BHARARA-ROSE', 'REP-BHARARA-ROSE-FEM', 'DAMAS', 'cosmetica', 'PM-821', 1, 0, '2026-03-16', 82000, 150000, NULL, 'Código: 821', 'sede-pm-2'),
('prod-pm-842', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'BHARARA-VIKING BEIRUT', 'REP-BHARARA-VIKING BEIRUT-MAS', 'CABALLEROS', 'cosmetica', 'PM-842', 1, 0, '2026-03-16', 93000, 170000, NULL, 'Código: 842', 'sede-pm-2'),
('prod-pm-840', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'BHARARA-VIKING CAIRO', 'REP-BHARARA-VIKING CAIRO-UNI', 'UNISEX', 'cosmetica', 'PM-840', 1, 0, '2026-03-16', 93000, 170000, NULL, 'Código: 840', 'sede-pm-2'),
('prod-pm-841', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'BHARARA-VIKING KASHMIR', 'REP-BHARARA-VIKING KASHMIR-UNI', 'UNISEX', 'cosmetica', 'PM-841', 1, 0, '2026-03-16', 92000, 160000, NULL, 'Código: 841', 'sede-pm-2'),
('prod-pm-716', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'BOND N9-BLEECKER STREET', 'REP-BOND N9-BLEECKER STREET-UNI', 'UNISEX', 'cosmetica', 'PM-716', 2, 0, '2026-03-16', 82000, 150000, NULL, 'Código: 716', 'sede-pm-2'),
('prod-pm-750', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'BRITNEY SPEARS-FANTASY', 'REP-BRITNEY SPEARS-FANTASY-FEM', 'DAMAS', 'cosmetica', 'PM-750', 1, 0, '2026-03-16', 35000, 80000, NULL, 'Código: 750', 'sede-pm-2'),
('prod-pm-749', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'BRITNEY SPEARS-MIDNIGHT FANTASY', 'REP-BRITNEY SPEARS-MIDNIGHT FANTASY-FEM', 'DAMAS', 'cosmetica', 'PM-749', 0, 0, '2026-03-16', 37000, 80000, NULL, 'Código: 749', 'sede-pm-2'),
('prod-pm-765', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'BURBERRY-BURBERRY HER', 'REP-BURBERRY-BURBERRY HER-FEM', 'DAMAS', 'cosmetica', 'PM-765', 1, 0, '2026-03-16', 42000, 90000, NULL, 'Código: 765', 'sede-pm-2'),
('prod-pm-761', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'BURBERRY-BURBERRY', 'REP-BURBERRY-BURBERRY-FEM', 'DAMAS', 'cosmetica', 'PM-761', 1, 0, '2026-03-16', 37000, 80000, NULL, 'Código: 761', 'sede-pm-2'),
('prod-pm-668', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'BVLGARI-AQVA ATLANTIQVE', 'REP-BVLGARI-AQVA ATLANTIQVE-MAS', 'CABALLEROS', 'cosmetica', 'PM-668', 1, 0, '2026-03-16', 37000, 85000, NULL, 'Código: 668', 'sede-pm-2'),
('prod-pm-669', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'BVLGARI-BVLGARI MAN IN BLACK', 'REP-BVLGARI-BVLGARI MAN IN BLACK-MAS', 'CABALLEROS', 'cosmetica', 'PM-669', 1, 0, '2026-03-16', 37000, 85000, NULL, 'Código: 669', 'sede-pm-2'),
('prod-pm-837', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'BVLGARI-OMNIA CRYSTALLINE', 'REP-BVLGARI-OMNIA CRYSTALLINE-FEM', 'DAMAS', 'cosmetica', 'PM-837', 1, 0, '2026-03-16', 37000, 80000, NULL, 'Código: 837', 'sede-pm-2'),
('prod-pm-788', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'BVLGARI-OMNIA MARY KATRANTZOU', 'REP-BVLGARI-OMNIA MARY KATRANTZOU-FEM', 'DAMAS', 'cosmetica', 'PM-788', 1, 0, '2026-03-16', 40000, 90000, NULL, 'Código: 788', 'sede-pm-2'),
('prod-pm-729', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'CALVIN KLEIN-CK IN2U', 'REP-CALVIN KLEIN-CK IN2U-FEM', 'DAMAS', 'cosmetica', 'PM-729', 0, 0, '2026-03-16', 47000, 90000, NULL, 'Código: 729', 'sede-pm-2'),
('prod-pm-763', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'CALVIN KLEIN-CK ONE SHOCK', 'REP-CALVIN KLEIN-CK ONE SHOCK-FEM', 'DAMAS', 'cosmetica', 'PM-763', 1, 0, '2026-03-16', 37000, 85000, NULL, 'Código: 763', 'sede-pm-2'),
('prod-pm-677', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'CALVIN KLEIN-CK ONE', 'REP-CALVIN KLEIN-CK ONE-UNI', 'UNISEX', 'cosmetica', 'PM-677', 1, 0, '2026-03-16', 37000, 80000, NULL, 'Código: 677', 'sede-pm-2'),
('prod-pm-851', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'CALVIN KLEIN-ETERNITY', 'REP-CALVIN KLEIN-ETERNITY-FEM', 'DAMAS', 'cosmetica', 'PM-851', 1, 0, '2026-03-16', 43000, 85000, NULL, 'Código: 851', 'sede-pm-2'),
('prod-pm-626', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'CAROLINA HERRERA-212 HEROES', 'REP-CAROLINA HERRERA-212 HEROES-MAS', 'CABALLEROS', 'cosmetica', 'PM-626', 1, 0, '2026-03-16', 60000, 95000, NULL, 'Código: 626', 'sede-pm-2'),
('prod-pm-733', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'CAROLINA HERRERA-212 SEXY', 'REP-CAROLINA HERRERA-212 SEXY-FEM', 'DAMAS', 'cosmetica', 'PM-733', 2, 0, '2026-03-16', 35000, 80000, NULL, 'Código: 733', 'sede-pm-2'),
('prod-pm-635', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'CAROLINA HERRERA-212 SEXY', 'REP-CAROLINA HERRERA-212 SEXY-MAS', 'CABALLEROS', 'cosmetica', 'PM-635', 0, 0, '2026-03-16', 35000, 80000, NULL, 'Código: 635', 'sede-pm-2'),
('prod-pm-637', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'CAROLINA HERRERA-212 VIP BLACK', 'REP-CAROLINA HERRERA-212 VIP BLACK-MAS', 'CABALLEROS', 'cosmetica', 'PM-637', 2, 0, '2026-03-16', 34000, 85000, NULL, 'Código: 637', 'sede-pm-2'),
('prod-pm-636', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'CAROLINA HERRERA-212 VIP RED', 'REP-CAROLINA HERRERA-212 VIP RED-MAS', 'CABALLEROS', 'cosmetica', 'PM-636', 0, 0, '2026-03-16', 35000, 80000, NULL, 'Código: 636', 'sede-pm-2'),
('prod-pm-735', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'CAROLINA HERRERA-212 VIP ROSE I LOVE NY', 'REP-CAROLINA HERRERA-212 VIP ROSE I LOVE NY-FEM', 'DAMAS', 'cosmetica', 'PM-735', 2, 0, '2026-03-16', 40000, 90000, NULL, 'Código: 735', 'sede-pm-2'),
('prod-pm-734', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'CAROLINA HERRERA-212 VIP ROSE RED', 'REP-CAROLINA HERRERA-212 VIP ROSE RED-FEM', 'DAMAS', 'cosmetica', 'PM-734', 1, 0, '2026-03-16', 50000, 80000, NULL, 'Código: 734', 'sede-pm-2'),
('prod-pm-731', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'CAROLINA HERRERA-212 VIP ROSE', 'REP-CAROLINA HERRERA-212 VIP ROSE-FEM', 'DAMAS', 'cosmetica', 'PM-731', 1, 0, '2026-03-16', 34000, 85000, NULL, 'Código: 731', 'sede-pm-2'),
('prod-pm-736', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'CAROLINA HERRERA-212 VIP WILD PARTY', 'REP-CAROLINA HERRERA-212 VIP WILD PARTY-FEM', 'DAMAS', 'cosmetica', 'PM-736', 2, 0, '2026-03-16', 37000, 80000, NULL, 'Código: 736', 'sede-pm-2'),
('prod-pm-640', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'CAROLINA HERRERA-212 VIP WILD PARTY', 'REP-CAROLINA HERRERA-212 VIP WILD PARTY-MAS', 'CABALLEROS', 'cosmetica', 'PM-640', 1, 0, '2026-03-16', 37000, 80000, NULL, 'Código: 640', 'sede-pm-2'),
('prod-pm-815', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'CAROLINA HERRERA-212 VIP WINS', 'REP-CAROLINA HERRERA-212 VIP WINS-MAS', 'CABALLEROS', 'cosmetica', 'PM-815', 1, 0, '2026-03-16', 37000, 80000, NULL, 'Código: 815', 'sede-pm-2'),
('prod-pm-732', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'CAROLINA HERRERA-212 VIP', 'REP-CAROLINA HERRERA-212 VIP-FEM', 'DAMAS', 'cosmetica', 'PM-732', 1, 0, '2026-03-16', 34000, 80000, NULL, 'Código: 732', 'sede-pm-2'),
('prod-pm-639', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'CAROLINA HERRERA-212 VIP', 'REP-CAROLINA HERRERA-212 VIP-MAS', 'CABALLEROS', 'cosmetica', 'PM-639', 3, 0, '2026-03-16', 34000, 80000, NULL, 'Código: 639', 'sede-pm-2'),
('prod-pm-730', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'CAROLINA HERRERA-212', 'REP-CAROLINA HERRERA-212-FEM', 'DAMAS', 'cosmetica', 'PM-730', 1, 0, '2026-03-16', 34000, 80000, NULL, 'Código: 730', 'sede-pm-2'),
('prod-pm-638', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'CAROLINA HERRERA-212', 'REP-CAROLINA HERRERA-212-MAS', 'CABALLEROS', 'cosmetica', 'PM-638', 4, 0, '2026-03-16', 35000, 80000, NULL, 'Código: 638', 'sede-pm-2'),
('prod-pm-813', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'CAROLINA HERRERA-BAD BOY', 'REP-CAROLINA HERRERA-BAD BOY-MAS', 'CABALLEROS', 'cosmetica', 'PM-813', 1, 0, '2026-03-16', 40000, 90000, NULL, 'Código: 813', 'sede-pm-2'),
('prod-pm-s2-614', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'CAROLINA HERRERA-CH MEN', 'REP-CAROLINA HERRERA-CH MEN-MAS', 'CABALLEROS', 'cosmetica', 'PM-S2-614', 2, 0, '2026-03-16', 35000, 80000, NULL, 'Código: 614', 'sede-pm-2'),
('prod-pm-699', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'CAROLINA HERRERA-CH', 'REP-CAROLINA HERRERA-CH-FEM', 'DAMAS', 'cosmetica', 'PM-699', 0, 0, '2026-03-16', 35000, 80000, NULL, 'Código: 699', 'sede-pm-2'),
('prod-pm-1470', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'CAROLINA HERRERA-GOOD GIRL BLUSH ELIXIR', 'REP-CAROLINA HERRERA-GOOD GIRL BLUSH ELIXIR-FEM', 'DAMAS', 'cosmetica', 'PM-1470', 1, 0, '2026-03-16', 37000, 85000, NULL, 'Código: 1470', 'sede-pm-2'),
('prod-pm-722', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'CAROLINA HERRERA-GOOD GIRL BLUSH FASHION AMARILLA', 'REP-CAROLINA HERRERA-GOOD GIRL BLUSH FASHION AMARILLA-FEM', 'DAMAS', 'cosmetica', 'PM-722', 0, 0, '2026-03-16', 35000, 90000, NULL, 'Código: 722', 'sede-pm-2'),
('prod-pm-773', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'CAROLINA HERRERA-GOOD GIRL BLUSH', 'REP-CAROLINA HERRERA-GOOD GIRL BLUSH-FEM', 'DAMAS', 'cosmetica', 'PM-773', 0, 0, '2026-03-16', 37000, 85000, NULL, 'Código: 773', 'sede-pm-2'),
('prod-pm-819', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'CAROLINA HERRERA-GOOD GIRL FANTASTIC PINK', 'REP-CAROLINA HERRERA-GOOD GIRL FANTASTIC PINK-FEM', 'DAMAS', 'cosmetica', 'PM-819', 0, 0, '2026-03-16', 47000, 95000, NULL, 'Código: 819', 'sede-pm-2'),
('prod-pm-817', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'CAROLINA HERRERA-GOOD GIRL GOLD', 'REP-CAROLINA HERRERA-GOOD GIRL GOLD-FEM', 'DAMAS', 'cosmetica', 'PM-817', 1, 0, '2026-03-16', 42000, 90000, NULL, 'Código: 817', 'sede-pm-2'),
('prod-pm-682', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'CAROLINA HERRERA-GOOD GIRL', 'REP-CAROLINA HERRERA-GOOD GIRL-FEM', 'DAMAS', 'cosmetica', 'PM-682', 1, 0, '2026-03-16', 37000, 90000, NULL, 'Código: 682', 'sede-pm-2'),
('prod-pm-718', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'CASAMORATI-ITALICA', 'REP-CASAMORATI-ITALICA-UNI', 'UNISEX', 'cosmetica', 'PM-718', 1, 0, '2026-03-16', 67000, 125000, NULL, 'Código: 718', 'sede-pm-2'),
('prod-pm-679', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'CHANEL-ALLURE SPORT', 'REP-CHANEL-ALLURE SPORT-MAS', 'CABALLEROS', 'cosmetica', 'PM-679', 1, 0, '2026-03-16', 37000, 85000, NULL, 'Código: 679', 'sede-pm-2'),
('prod-pm-646', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'CHANEL-BLEU DE CHANEL', 'REP-CHANEL-BLEU DE CHANEL-MAS', 'CABALLEROS', 'cosmetica', 'PM-646', 2, 0, '2026-03-16', 35000, 80000, NULL, 'Código: 646', 'sede-pm-2'),
('prod-pm-741', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'CHANEL-CHANCE', 'REP-CHANEL-CHANCE-FEM', 'DAMAS', 'cosmetica', 'PM-741', 1, 0, '2026-03-16', 37000, 80000, NULL, 'Código: 741', 'sede-pm-2'),
('prod-pm-739', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'CHANEL-CHANEL N5', 'REP-CHANEL-CHANEL N5-FEM', 'DAMAS', 'cosmetica', 'PM-739', 1, 0, '2026-03-16', 37000, 80000, NULL, 'Código: 739', 'sede-pm-2'),
('prod-pm-740', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'CHANEL-COCO MADEMOISELLE', 'REP-CHANEL-COCO MADEMOISELLE-FEM', 'DAMAS', 'cosmetica', 'PM-740', 1, 0, '2026-03-16', 35000, 80000, NULL, 'Código: 740', 'sede-pm-2'),
('prod-pm-s2-615', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'CHRISTIAN DIOR-FAHRENHEIT', 'REP-CHRISTIAN DIOR-FAHRENHEIT-MAS', 'CABALLEROS', 'cosmetica', 'PM-S2-615', 2, 0, '2026-03-16', 34600, 80000, NULL, 'Código: 615', 'sede-pm-2'),
('prod-pm-714', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'CHRISTIAN DIOR-JADORE', 'REP-CHRISTIAN DIOR-JADORE-FEM', 'DAMAS', 'cosmetica', 'PM-714', 1, 0, '2026-03-16', 35000, 80000, NULL, 'Código: 714', 'sede-pm-2'),
('prod-pm-628', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'CHRISTIAN DIOR-SAUVAGE DIOR', 'REP-CHRISTIAN DIOR-SAUVAGE DIOR-MAS', 'CABALLEROS', 'cosmetica', 'PM-628', 1, 0, '2026-03-16', 37000, 80000, NULL, 'Código: 628', 'sede-pm-2'),
('prod-pm-s2-606', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'CREED-AVENTUS', 'REP-CREED-AVENTUS-MAS', 'CABALLEROS', 'cosmetica', 'PM-S2-606', 2, 0, '2026-03-16', 35000, 80000, NULL, 'Código: 606', 'sede-pm-2'),
('prod-pm-s2-608', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'CREED-GREEN IRISH TWEED', 'REP-CREED-GREEN IRISH TWEED-MAS', 'CABALLEROS', 'cosmetica', 'PM-S2-608', 2, 0, '2026-03-16', 41500, 90000, NULL, 'Código: 608', 'sede-pm-2'),
('prod-pm-s2-607', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'CREED-SILVER MOUNTAIN WATER', 'REP-CREED-SILVER MOUNTAIN WATER-MAS', 'CABALLEROS', 'cosmetica', 'PM-S2-607', 2, 0, '2026-03-16', 35000, 85000, NULL, 'Código: 607', 'sede-pm-2'),
('prod-pm-695', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'CREED-SPRING FLOWER', 'REP-CREED-SPRING FLOWER-FEM', 'DAMAS', 'cosmetica', 'PM-695', 1, 0, '2026-03-16', 37000, 80000, NULL, 'Código: 695', 'sede-pm-2'),
('prod-pm-s2-613', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'CREED-VIRGIN ISLAND WATER', 'REP-CREED-VIRGIN ISLAND WATER-MAS', 'CABALLEROS', 'cosmetica', 'PM-S2-613', 1, 0, '2026-03-16', 35000, 80000, NULL, 'Código: 613', 'sede-pm-2'),
('prod-pm-1351', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'CRISTIAN DIOR-MISS DIOR', 'REP-CRISTIAN DIOR-MISS DIOR-FEM', 'DAMAS', 'cosmetica', 'PM-1351', 2, 0, '2026-03-16', 47000, 95000, NULL, 'Código: 1351', 'sede-pm-2'),
('prod-pm-678', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'DIESEL-DIESEL PLUS PLUS', 'REP-DIESEL-DIESEL PLUS PLUS-MAS', 'CABALLEROS', 'cosmetica', 'PM-678', 1, 0, '2026-03-16', 27000, 60000, NULL, 'Código: 678', 'sede-pm-2'),
('prod-pm-852', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'DIESEL-DIESEL SORBETTO ROSSO', 'REP-DIESEL-DIESEL SORBETTO ROSSO-FEM', 'DAMAS', 'cosmetica', 'PM-852', 0, 0, '2026-03-16', 30000, 60000, NULL, 'Código: 852', 'sede-pm-2'),
('prod-pm-828', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'DIESEL-KARPOS', 'REP-DIESEL-KARPOS-UNI', 'UNISEX', 'cosmetica', 'PM-828', 1, 0, '2026-03-16', 27000, 50000, NULL, 'Código: 828', 'sede-pm-2'),
('prod-pm-709', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'DIESEL-LOQUITO POR TI', 'REP-DIESEL-LOQUITO POR TI-FEM', 'DAMAS', 'cosmetica', 'PM-709', 0, 0, '2026-03-16', 27000, 60000, NULL, 'Código: 709', 'sede-pm-2'),
('prod-pm-632', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'DIESEL-ONLY THE BRAVE', 'REP-DIESEL-ONLY THE BRAVE-MAS', 'CABALLEROS', 'cosmetica', 'PM-632', 1, 0, '2026-03-16', 37000, 80000, NULL, 'Código: 632', 'sede-pm-2'),
('prod-pm-642', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'DIESEL-SPIRIT THE BRAVE', 'REP-DIESEL-SPIRIT THE BRAVE-MAS', 'CABALLEROS', 'cosmetica', 'PM-642', 1, 0, '2026-03-16', 34000, 80000, NULL, 'Código: 642', 'sede-pm-2'),
('prod-pm-818', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'DOLCE Y GABBANA-DEVOTION', 'REP-DOLCE Y GABBANA-DEVOTION-FEM', 'DAMAS', 'cosmetica', 'PM-818', 1, 0, '2026-03-16', 42000, 90000, NULL, 'Código: 818', 'sede-pm-2'),
('prod-pm-627', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'DOLCE Y GABBANA-K-MASC', 'REP-DOLCE Y GABBANA-K-MASC', 'CREMAS', 'cosmetica', 'PM-627', 2, 0, '2026-03-16', 34600, 85000, NULL, 'Código: 627', 'sede-pm-2'),
('prod-pm-686', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'DOLCE Y GABBANA-LIGHT BLUE ITALIAN LOVE', 'REP-DOLCE Y GABBANA-LIGHT BLUE ITALIAN LOVE-FEM', 'DAMAS', 'cosmetica', 'PM-686', 1, 0, '2026-03-16', 37000, 80000, NULL, 'Código: 686', 'sede-pm-2'),
('prod-pm-645', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'DOLCE Y GABBANA-LIGHT BLUE ITALIAN ZEST', 'REP-DOLCE Y GABBANA-LIGHT BLUE ITALIAN ZEST-MAS', 'CABALLEROS', 'cosmetica', 'PM-645', 0, 0, '2026-03-16', 37000, 80000, NULL, 'Código: 645', 'sede-pm-2'),
('prod-pm-685', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'DOLCE Y GABBANA-LIGHT BLUE', 'REP-DOLCE Y GABBANA-LIGHT BLUE-FEM', 'DAMAS', 'cosmetica', 'PM-685', 2, 0, '2026-03-16', 34000, 80000, NULL, 'Código: 685', 'sede-pm-2'),
('prod-pm-644', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'DOLCE Y GABBANA-LIGHT BLUE', 'REP-DOLCE Y GABBANA-LIGHT BLUE-MAS', 'CABALLEROS', 'cosmetica', 'PM-644', 2, 0, '2026-03-16', 35000, 80000, NULL, 'Código: 644', 'sede-pm-2'),
('prod-pm-751', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'DOLCE Y GABBANA-Q', 'REP-DOLCE Y GABBANA-Q-FEM', 'DAMAS', 'cosmetica', 'PM-751', 0, 0, '2026-03-16', 45000, 105000, NULL, 'Código: 751', 'sede-pm-2'),
('prod-pm-696', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'DONNA KARAN-BE DELICIOUS', 'REP-DONNA KARAN-BE DELICIOUS-FEM', 'DAMAS', 'cosmetica', 'PM-696', 0, 0, '2026-03-16', 37000, 80000, NULL, 'Código: 696', 'sede-pm-2'),
('prod-pm-1350', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'DUMONT PARIS NITRO RED', 'REP-DUMONT PARIS NITRO RED-MAS', 'CABALLEROS', 'cosmetica', 'PM-1350', 2, 0, '2026-03-16', 67000, 125000, NULL, 'Código: 1350', 'sede-pm-2'),
('prod-pm-724', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ESCADA-AGUA DE SOL', 'REP-ESCADA-AGUA DE SOL-FEM', 'DAMAS', 'cosmetica', 'PM-724', 1, 0, '2026-03-16', 37000, 80000, NULL, 'Código: 724', 'sede-pm-2'),
('prod-pm-1128', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ESCADA-MIAMI BLOSSOM', 'REP-ESCADA-MIAMI BLOSSOM-FEM', 'DAMAS', 'cosmetica', 'PM-1128', 1, 0, '2026-03-16', 37000, 85000, NULL, 'Código: 1128', 'sede-pm-2'),
('prod-pm-823', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ESCADA-SORBETTO ROSSO', 'REP-ESCADA-SORBETTO ROSSO-FEM', 'DAMAS', 'cosmetica', 'PM-823', 2, 0, '2026-03-16', 37000, 80000, NULL, 'Código: 823', 'sede-pm-2'),
('prod-pm-871', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'GIARDINI DI TOSCANA-BIANCO LATTE', 'REP-GIARDINI DI TOSCANA-BIANCO LATTE-UNI', 'UNISEX', 'cosmetica', 'PM-871', 3, 0, '2026-03-16', 62000, 130000, NULL, 'Código: 871', 'sede-pm-2'),
('prod-pm-860', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'GIORGIO ARMANI-ACQUA DI GIO ABSOLU', 'REP-GIORGIO ARMANI-ACQUA DI GIO ABSOLU-MAS', 'CABALLEROS', 'cosmetica', 'PM-860', 1, 0, '2026-03-16', 42000, 85000, NULL, 'Código: 860', 'sede-pm-2'),
('prod-pm-s2-603', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'GIORGIO ARMANI-ACQUA DI GIO PROFONDO', 'REP-GIORGIO ARMANI-ACQUA DI GIO PROFONDO-MAS', 'CABALLEROS', 'cosmetica', 'PM-S2-603', 2, 0, '2026-03-16', 35000, 85000, NULL, 'Código: 603', 'sede-pm-2'),
('prod-pm-s2-604', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'GIORGIO ARMANI-ACQUA DI GIO PROFUMO', 'REP-GIORGIO ARMANI-ACQUA DI GIO PROFUMO-MAS', 'CABALLEROS', 'cosmetica', 'PM-S2-604', 2, 0, '2026-03-16', 34000, 80000, NULL, 'Código: 604', 'sede-pm-2'),
('prod-pm-s2-605', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'GIORGIO ARMANI-ACQUA DI GIO', 'REP-GIORGIO ARMANI-ACQUA DI GIO-MAS', 'CABALLEROS', 'cosmetica', 'PM-S2-605', 1, 0, '2026-03-16', 35000, 80000, NULL, 'Código: 605', 'sede-pm-2'),
('prod-pm-738', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'GIORGIO ARMANI-AIR DI GIOIA', 'REP-GIORGIO ARMANI-AIR DI GIOIA-FEM', 'DAMAS', 'cosmetica', 'PM-738', 1, 0, '2026-03-16', 37000, 80000, NULL, 'Código: 738', 'sede-pm-2'),
('prod-pm-662', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'GIORGIO ARMANI-ARMANI CODE', 'REP-GIORGIO ARMANI-ARMANI CODE-MAS', 'CABALLEROS', 'cosmetica', 'PM-662', 1, 0, '2026-03-16', 37000, 80000, NULL, 'Código: 662', 'sede-pm-2'),
('prod-pm-688', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'GIORGIO ARMANI-IN LOVE WITH YOU', 'REP-GIORGIO ARMANI-IN LOVE WITH YOU-FEM', 'DAMAS', 'cosmetica', 'PM-688', 1, 0, '2026-03-16', 37000, 85000, NULL, 'Código: 688', 'sede-pm-2'),
('prod-pm-844', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'GIORGIO ARMANI-MY WAY', 'REP-GIORGIO ARMANI-MY WAY-FEM', 'DAMAS', 'cosmetica', 'PM-844', 1, 0, '2026-03-16', 43000, 85000, NULL, 'Código: 844', 'sede-pm-2'),
('prod-pm-758', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'GIORGIO ARMANI-SI', 'REP-GIORGIO ARMANI-SI-FEM', 'DAMAS', 'cosmetica', 'PM-758', 1, 0, '2026-03-16', 37000, 85000, NULL, 'Código: 758', 'sede-pm-2'),
('prod-pm-1471', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'GIORGIO ARMANI-STRONGER WITH YOU INTENSE', 'REP-GIORGIO ARMANI-STRONGER WITH YOU INTENSE-MAS', 'CABALLEROS', 'cosmetica', 'PM-1471', 1, 0, '2026-03-16', 42000, 90000, NULL, 'Código: 1471', 'sede-pm-2'),
('prod-pm-623', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'GIVENCHY-GIVENCHY POUR HOMME', 'REP-GIVENCHY-GIVENCHY POUR HOMME-MAS', 'CABALLEROS', 'cosmetica', 'PM-623', 1, 0, '2026-03-16', 37000, 80000, NULL, 'Código: 623', 'sede-pm-2'),
('prod-pm-673', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'HUGO BOSS-BOSS BOTTLED NIGHT', 'REP-HUGO BOSS-BOSS BOTTLED NIGHT-MAS', 'CABALLEROS', 'cosmetica', 'PM-673', 1, 0, '2026-03-16', 34000, 85000, NULL, 'Código: 673', 'sede-pm-2'),
('prod-pm-672', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'HUGO BOSS-BOSS BOTTLED UNLIMITED', 'REP-HUGO BOSS-BOSS BOTTLED UNLIMITED-MAS', 'CABALLEROS', 'cosmetica', 'PM-672', 1, 0, '2026-03-16', 38000, 85000, NULL, 'Código: 672', 'sede-pm-2'),
('prod-pm-633', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'HUGO BOSS-BOSS IN MOTION', 'REP-HUGO BOSS-BOSS IN MOTION-MAS', 'CABALLEROS', 'cosmetica', 'PM-633', 1, 0, '2026-03-16', 35000, 80000, NULL, 'Código: 633', 'sede-pm-2'),
('prod-pm-671', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'HUGO BOSS-BOSS THE SCENT ABSOLUTE', 'REP-HUGO BOSS-BOSS THE SCENT ABSOLUTE-MAS', 'CABALLEROS', 'cosmetica', 'PM-671', 1, 0, '2026-03-16', 35000, 85000, NULL, 'Código: 671', 'sede-pm-2'),
('prod-pm-843', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'HUGO BOSS-DARK BLUE', 'REP-HUGO BOSS-DARK BLUE-MAS', 'CABALLEROS', 'cosmetica', 'PM-843', 1, 0, '2026-03-16', 42000, 85000, NULL, 'Código: 843', 'sede-pm-2'),
('prod-pm-674', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'HUGO BOSS-HUGO MAN', 'REP-HUGO BOSS-HUGO MAN-MAS', 'CABALLEROS', 'cosmetica', 'PM-674', 1, 0, '2026-03-16', 35000, 80000, NULL, 'Código: 674', 'sede-pm-2'),
('prod-pm-745', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'HUGO BOSS-XX', 'REP-HUGO BOSS-XX-FEM', 'DAMAS', 'cosmetica', 'PM-745', 1, 0, '2026-03-16', 37000, 80000, NULL, 'Código: 745', 'sede-pm-2'),
('prod-pm-670', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'HUGO BOSS-XY', 'REP-HUGO BOSS-XY-MAS', 'CABALLEROS', 'cosmetica', 'PM-670', 1, 0, '2026-03-16', 37000, 80000, NULL, 'Código: 670', 'sede-pm-2'),
('prod-pm-715', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ILMIN-IL OOMPH', 'REP-ILMIN-IL OOMPH-UNI', 'UNISEX', 'cosmetica', 'PM-715', 1, 0, '2026-03-16', 70000, 130000, NULL, 'Código: 715', 'sede-pm-2'),
('prod-pm-661', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ISSEY MIYAKE-ISSEY MIYAKE POLARIS', 'REP-ISSEY MIYAKE-ISSEY MIYAKE POLARIS-MAS', 'CABALLEROS', 'cosmetica', 'PM-661', 1, 0, '2026-03-16', 37000, 85000, NULL, 'Código: 661', 'sede-pm-2'),
('prod-pm-754', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ISSEY MIYAKE-ISSEY MIYAKE', 'REP-ISSEY MIYAKE-ISSEY MIYAKE-FEM', 'DAMAS', 'cosmetica', 'PM-754', 1, 0, '2026-03-16', 37000, 85000, NULL, 'Código: 754', 'sede-pm-2'),
('prod-pm-659', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ISSEY MIYAKE-ISSEY MIYAKE', 'REP-ISSEY MIYAKE-ISSEY MIYAKE-MAS', 'CABALLEROS', 'cosmetica', 'PM-659', 1, 0, '2026-03-16', 35000, 80000, NULL, 'Código: 659', 'sede-pm-2'),
('prod-pm-717', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'JEAN PAUL GAULTIER-CLASSIQUE', 'REP-JEAN PAUL GAULTIER-CLASSIQUE-FEM', 'DAMAS', 'cosmetica', 'PM-717', 1, 0, '2026-03-16', 62000, 110000, NULL, 'Código: 717', 'sede-pm-2'),
('prod-pm-869', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'JEAN PAUL GAULTIER-DIVINE', 'REP-JEAN PAUL GAULTIER-DIVINE-FEM', 'DAMAS', 'cosmetica', 'PM-869', 1, 0, '2026-03-16', 62000, 135000, NULL, 'Código: 869', 'sede-pm-2'),
('prod-pm-833', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'JEAN PAUL GAULTIER-JEAN PAUL GAULTIER LE MALE', 'REP-JEAN PAUL GAULTIER-JEAN PAUL GAULTIER LE MALE-MAS', 'CABALLEROS', 'cosmetica', 'PM-833', 0, 0, '2026-03-16', 62000, 110000, NULL, 'Código: 833', 'sede-pm-2'),
('prod-pm-684', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'JEAN PAUL GAULTIER-LA BELLE', 'REP-JEAN PAUL GAULTIER-LA BELLE-FEM', 'DAMAS', 'cosmetica', 'PM-684', 1, 0, '2026-03-16', 37000, 90000, NULL, 'Código: 684', 'sede-pm-2'),
('prod-pm-s2-602', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'JEAN PAUL GAULTIER-LE BEAU', 'REP-JEAN PAUL GAULTIER-LE BEAU-MAS', 'CABALLEROS', 'cosmetica', 'PM-S2-602', 1, 0, '2026-03-16', 72000, 135000, NULL, 'Código: 602', 'sede-pm-2'),
('prod-pm-893', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'JEAN PAUL GAULTIER-LE MALE ELIXIR', 'REP-JEAN PAUL GAULTIER-LE MALE ELIXIR-MAS', 'CABALLEROS', 'cosmetica', 'PM-893', 2, 0, '2026-03-16', 70000, 135000, NULL, 'Código: 893', 'sede-pm-2'),
('prod-pm-705', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'JEAN PAUL GAULTIER-SCANDAL GOLD', 'REP-JEAN PAUL GAULTIER-SCANDAL GOLD-FEM', 'DAMAS', 'cosmetica', 'PM-705', 1, 0, '2026-03-16', 60000, 115000, NULL, 'Código: 705', 'sede-pm-2'),
('prod-pm-701', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'JEAN PAUL GAULTIER-SCANDAL', 'REP-JEAN PAUL GAULTIER-SCANDAL-FEM', 'DAMAS', 'cosmetica', 'PM-701', 1, 0, '2026-03-16', 37000, 85000, NULL, 'Código: 701', 'sede-pm-2'),
('prod-pm-s2-617', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'JEAN PAUL GAULTIER-SCANDAL', 'REP-JEAN PAUL GAULTIER-SCANDAL-MAS', 'CABALLEROS', 'cosmetica', 'PM-S2-617', 1, 0, '2026-03-16', 45000, 90000, NULL, 'Código: 617', 'sede-pm-2'),
('prod-pm-s2-601', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'JEAN PAUL GAULTIER-ULTRA MALE', 'REP-JEAN PAUL GAULTIER-ULTRA MALE-MAS', 'CABALLEROS', 'cosmetica', 'PM-S2-601', 1, 0, '2026-03-16', 50000, 115000, NULL, 'Código: 601', 'sede-pm-2'),
('prod-pm-836', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'JESUS DEL POZO-HALLOWEEN', 'REP-JESUS DEL POZO-HALLOWEEN-FEM', 'DAMAS', 'cosmetica', 'PM-836', 1, 0, '2026-03-16', 38000, 80000, NULL, 'Código: 836', 'sede-pm-2'),
('prod-pm-687', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'JUICY COUTURE-VIVA LA JUICY', 'REP-JUICY COUTURE-VIVA LA JUICY-FEM', 'DAMAS', 'cosmetica', 'PM-687', 1, 0, '2026-03-16', 37000, 80000, NULL, 'Código: 687', 'sede-pm-2'),
('prod-pm-849', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'KATY PERRY-MEOW WHITE', 'REP-KATY PERRY-MEOW WHITE-FEM', 'DAMAS', 'cosmetica', 'PM-849', 1, 0, '2026-03-16', 37000, 80000, NULL, 'Código: 849', 'sede-pm-2'),
('prod-pm-755', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'KATY PERRY-MEOW', 'REP-KATY PERRY-MEOW-FEM', 'DAMAS', 'cosmetica', 'PM-755', 1, 0, '2026-03-16', 35000, 80000, NULL, 'Código: 755', 'sede-pm-2'),
('prod-pm-824', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'KATY PERRY-PURR ROSADA', 'REP-KATY PERRY-PURR ROSADA-FEM', 'DAMAS', 'cosmetica', 'PM-824', 1, 0, '2026-03-16', 37000, 80000, NULL, 'Código: 824', 'sede-pm-2'),
('prod-pm-848', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'KENZO-FLOWER', 'REP-KENZO-FLOWER-FEM', 'DAMAS', 'cosmetica', 'PM-848', 0, 0, '2026-03-16', 38000, 80000, NULL, 'Código: 848', 'sede-pm-2'),
('prod-pm-s2-611', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LACOSTE-ESSENTIAL', 'REP-LACOSTE-ESSENTIAL-MAS', 'CABALLEROS', 'cosmetica', 'PM-S2-611', 1, 0, '2026-03-16', 37000, 85000, NULL, 'Código: 611', 'sede-pm-2'),
('prod-pm-s2-609', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LACOSTE-LACOSTE BLANC', 'REP-LACOSTE-LACOSTE BLANC-MAS', 'CABALLEROS', 'cosmetica', 'PM-S2-609', 1, 0, '2026-03-16', 35000, 80000, NULL, 'Código: 609', 'sede-pm-2'),
('prod-pm-s2-610', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LACOSTE-LACOSTE NOIR', 'REP-LACOSTE-LACOSTE NOIR-MAS', 'CABALLEROS', 'cosmetica', 'PM-S2-610', 1, 0, '2026-03-16', 37000, 80000, NULL, 'Código: 610', 'sede-pm-2'),
('prod-pm-s2-612', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LACOSTE-LACOSTE RED', 'REP-LACOSTE-LACOSTE RED-MAS', 'CABALLEROS', 'cosmetica', 'PM-S2-612', 1, 0, '2026-03-16', 35000, 80000, NULL, 'Código: 612', 'sede-pm-2'),
('prod-pm-743', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LACOSTE-NATURAL', 'REP-LACOSTE-NATURAL-FEM', 'DAMAS', 'cosmetica', 'PM-743', 1, 0, '2026-03-16', 37000, 80000, NULL, 'Código: 743', 'sede-pm-2'),
('prod-pm-742', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LACOSTE-SPARKLING', 'REP-LACOSTE-SPARKLING-FEM', 'DAMAS', 'cosmetica', 'PM-742', 1, 0, '2026-03-16', 35000, 80000, NULL, 'Código: 742', 'sede-pm-2'),
('prod-pm-752', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LACOSTE-TOUCH OF PINK', 'REP-LACOSTE-TOUCH OF PINK-FEM', 'DAMAS', 'cosmetica', 'PM-752', 1, 0, '2026-03-16', 37000, 85000, NULL, 'Código: 752', 'sede-pm-2'),
('prod-pm-690', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LANCOME-LA VIDA ES BELLA', 'REP-LANCOME-LA VIDA ES BELLA-FEM', 'DAMAS', 'cosmetica', 'PM-690', 2, 0, '2026-03-16', 35000, 80000, NULL, 'Código: 690', 'sede-pm-2'),
('prod-pm-1346', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LATAFFA-HIS CONFESSION', 'REP-LATAFFA-HIS CONFESSION-MAS', 'CABALLEROS', 'cosmetica', 'PM-1346', 1, 0, '2026-03-16', 77000, 140000, NULL, 'Código: 1346', 'sede-pm-2'),
('prod-pm-1345', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LATAFFA-TERIAQ INTENSE', 'REP-LATAFFA-TERIAQ INTENSE-UNI', 'UNISEX', 'cosmetica', 'PM-1345', 2, 0, '2026-03-16', 76000, 155000, NULL, 'Código: 1345', 'sede-pm-2'),
('prod-pm-829', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LATTAFA-AJWAD PINK TO PINK', 'REP-LATTAFA-AJWAD PINK TO PINK-UNI', 'UNISEX', 'cosmetica', 'PM-829', 0, 0, '2026-03-16', 82000, 150000, NULL, 'Código: 829', 'sede-pm-2'),
('prod-pm-830', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LATTAFA-AJWAD', 'REP-LATTAFA-AJWAD-UNI', 'UNISEX', 'cosmetica', 'PM-830', 1, 0, '2026-03-16', 72000, 140000, NULL, 'Código: 830', 'sede-pm-2'),
('prod-pm-779', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LATTAFA-AMETHYST', 'REP-LATTAFA-AMETHYST-UNI', 'UNISEX', 'cosmetica', 'PM-779', 2, 0, '2026-03-16', 72000, 140000, NULL, 'Código: 779', 'sede-pm-2'),
('prod-pm-s2-986', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LATTAFA-ART OF UNIVERSE', 'REP-LATTAFA-ART OF UNIVERSE-UNI', 'UNISEX', 'cosmetica', 'PM-S2-986', 2, 0, '2026-03-16', 92000, 160000, NULL, 'Código: 986', 'sede-pm-2'),
('prod-pm-790', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LATTAFA-ASAD BOURBON', 'REP-LATTAFA-ASAD BOURBON-MAS', 'CABALLEROS', 'cosmetica', 'PM-790', 1, 0, '2026-03-16', 47000, 125000, NULL, 'Código: 790', 'sede-pm-2'),
('prod-pm-812', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LATTAFA-ASAD ZANZIBAR', 'REP-LATTAFA-ASAD ZANZIBAR-MAS', 'CABALLEROS', 'cosmetica', 'PM-812', 1, 0, '2026-03-16', 46000, 120000, NULL, 'Código: 812', 'sede-pm-2'),
('prod-pm-784', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LATTAFA-ASAD', 'REP-LATTAFA-ASAD-MAS', 'CABALLEROS', 'cosmetica', 'PM-784', 2, 0, '2026-03-16', 47000, 115000, NULL, 'Código: 784', 'sede-pm-2'),
('prod-pm-1337', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LATTAFA-BERRY ON TOP', 'REP-LATTAFA-BERRY ON TOP-FEM', 'DAMAS', 'cosmetica', 'PM-1337', 1, 0, '2026-03-16', 76000, 160000, NULL, 'Código: 1337', 'sede-pm-2'),
('prod-pm-698', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LATTAFA-ECLAIRE', 'REP-LATTAFA-ECLAIRE-FEM', 'DAMAS', 'cosmetica', 'PM-698', 1, 0, '2026-03-16', 91000, 160000, NULL, 'Código: 698', 'sede-pm-2'),
('prod-pm-s2-192', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LATTAFA-EMEER', 'REP-LATTAFA-EMEER-UNI', 'UNISEX', 'cosmetica', 'PM-S2-192', 1, 0, '2026-03-16', 81000, 150000, NULL, 'Código: 192', 'sede-pm-2'),
('prod-pm-711', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LATTAFA-ETERNAL OUD', 'REP-LATTAFA-ETERNAL OUD-UNI', 'UNISEX', 'cosmetica', 'PM-711', 1, 0, '2026-03-16', 40000, 90000, NULL, 'Código: 711', 'sede-pm-2'),
('prod-pm-s2-163', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LATTAFA-FAKHAR BLACK', 'REP-LATTAFA-FAKHAR BLACK-MAS', 'CABALLEROS', 'cosmetica', 'PM-S2-163', 0, 0, '2026-03-16', 71000, 140000, NULL, 'Código: 163', 'sede-pm-2'),
('prod-pm-884', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LATTAFA-FAKHAR GOLD', 'REP-LATTAFA-FAKHAR GOLD-UNI', 'UNISEX', 'cosmetica', 'PM-884', 2, 0, '2026-03-16', 72000, 140000, NULL, 'Código: 884', 'sede-pm-2'),
('prod-pm-s2-202', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LATTAFA-FAKHAR ROSE', 'REP-LATTAFA-FAKHAR ROSE-FEM', 'DAMAS', 'cosmetica', 'PM-S2-202', 1, 0, '2026-03-16', 87000, 155000, NULL, 'Código: 202', 'sede-pm-2'),
('prod-pm-856', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LATTAFA-HAYA', 'REP-LATTAFA-HAYA-FEM', 'DAMAS', 'cosmetica', 'PM-856', 2, 0, '2026-03-16', 77000, 155000, NULL, 'Código: 856', 'sede-pm-2'),
('prod-pm-894', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LATTAFA-HER CONFESSION', 'REP-LATTAFA-HER CONFESSION-FEM', 'DAMAS', 'cosmetica', 'PM-894', 1, 0, '2026-03-16', 82000, 145000, NULL, 'Código: 894', 'sede-pm-2'),
('prod-pm-775', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LATTAFA-HONOR Y GLORY', 'REP-LATTAFA-HONOR Y GLORY-UNI', 'UNISEX', 'cosmetica', 'PM-775', 1, 0, '2026-03-16', 72000, 140000, NULL, 'Código: 775', 'sede-pm-2'),
('prod-pm-882', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LATTAFA-KHAMRAH DUKHAN', 'REP-LATTAFA-KHAMRAH DUKHAN-UNI', 'UNISEX', 'cosmetica', 'PM-882', 3, 0, '2026-03-16', 72000, 145000, NULL, 'Código: 882', 'sede-pm-2'),
('prod-pm-867', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LATTAFA-KHAMRAH QAHWA', 'REP-LATTAFA-KHAMRAH QAHWA-UNI', 'UNISEX', 'cosmetica', 'PM-867', 2, 0, '2026-03-16', 75000, 140000, NULL, 'Código: 867', 'sede-pm-2'),
('prod-pm-811', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LATTAFA-KHAMRAH', 'REP-LATTAFA-KHAMRAH-UNI', 'UNISEX', 'cosmetica', 'PM-811', 3, 0, '2026-03-16', 72000, 145000, NULL, 'Código: 811', 'sede-pm-2'),
('prod-pm-720', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LATTAFA-MAAHIR', 'REP-LATTAFA-MAAHIR-MAS', 'CABALLEROS', 'cosmetica', 'PM-720', 0, 0, '2026-03-16', 45000, 100000, NULL, 'Código: 720', 'sede-pm-2'),
('prod-pm-863', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LATTAFA-MAYAR NATURAL INTENSE', 'REP-LATTAFA-MAYAR NATURAL INTENSE-FEM', 'DAMAS', 'cosmetica', 'PM-863', 0, 0, '2026-03-16', 92000, 160000, NULL, 'Código: 863', 'sede-pm-2'),
('prod-pm-862', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LATTAFA-MAYAR', 'REP-LATTAFA-MAYAR-FEM', 'DAMAS', 'cosmetica', 'PM-862', 1, 0, '2026-03-16', 71000, 140000, NULL, 'Código: 862', 'sede-pm-2'),
('prod-pm-885', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LATTAFA-MUSAMAM', 'REP-LATTAFA-MUSAMAM-UNI', 'UNISEX', 'cosmetica', 'PM-885', 0, 0, '2026-03-16', 72000, 130000, NULL, 'Código: 885', 'sede-pm-2'),
('prod-pm-865', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LATTAFA-NOBLE BLUSH', 'REP-LATTAFA-NOBLE BLUSH-FEM', 'DAMAS', 'cosmetica', 'PM-865', 1, 0, '2026-03-16', 86000, 165000, NULL, 'Código: 865', 'sede-pm-2'),
('prod-pm-774', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LATTAFA-OUD FOR GLORY', 'REP-LATTAFA-OUD FOR GLORY-UNI', 'UNISEX', 'cosmetica', 'PM-774', 2, 0, '2026-03-16', 72000, 130000, NULL, 'Código: 774', 'sede-pm-2'),
('prod-pm-859', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LATTAFA-OUD ROSES', 'REP-LATTAFA-OUD ROSES-UNI', 'UNISEX', 'cosmetica', 'PM-859', 0, 0, '2026-03-16', 87000, 155000, NULL, 'Código: 859', 'sede-pm-2'),
('prod-pm-776', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LATTAFA-QAED AL FURSAN', 'REP-LATTAFA-QAED AL FURSAN-UNI', 'UNISEX', 'cosmetica', 'PM-776', 1, 0, '2026-03-16', 62000, 115000, NULL, 'Código: 776', 'sede-pm-2'),
('prod-pm-857', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LATTAFA-SHAHEEN GOLD', 'REP-LATTAFA-SHAHEEN GOLD-UNI', 'UNISEX', 'cosmetica', 'PM-857', 1, 0, '2026-03-16', 87000, 150000, NULL, 'Código: 857', 'sede-pm-2'),
('prod-pm-780', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LATTAFA-SUBLIME', 'REP-LATTAFA-SUBLIME-UNI', 'UNISEX', 'cosmetica', 'PM-780', 2, 0, '2026-03-16', 71500, 140000, NULL, 'Código: 780', 'sede-pm-2'),
('prod-pm-1353', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LATTAFA-VICTORIA', 'REP-LATTAFA-VICTORIA-UNI', 'UNISEX', 'cosmetica', 'PM-1353', 1, 0, '2026-03-16', 87000, 150000, NULL, 'Código: 1353', 'sede-pm-2'),
('prod-pm-864', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LATTAFA-YARA CANDY', 'REP-LATTAFA-YARA CANDY-FEM', 'DAMAS', 'cosmetica', 'PM-864', 1, 0, '2026-03-16', 45000, 120000, NULL, 'Código: 864', 'sede-pm-2'),
('prod-pm-786', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LATTAFA-YARA MOI', 'REP-LATTAFA-YARA MOI-FEM', 'DAMAS', 'cosmetica', 'PM-786', 1, 0, '2026-03-16', 46000, 120000, NULL, 'Código: 786', 'sede-pm-2'),
('prod-pm-787', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LATTAFA-YARA TOUS', 'REP-LATTAFA-YARA TOUS-FEM', 'DAMAS', 'cosmetica', 'PM-787', 1, 0, '2026-03-16', 75000, 135000, NULL, 'Código: 787', 'sede-pm-2'),
('prod-pm-785', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LATTAFA-YARA', 'REP-LATTAFA-YARA-FEM', 'DAMAS', 'cosmetica', 'PM-785', 3, 0, '2026-03-16', 47000, 120000, NULL, 'Código: 785', 'sede-pm-2'),
('prod-pm-791', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LE LABO-BERGAMOTE 22', 'REP-LE LABO-BERGAMOTE 22-UNI', 'UNISEX', 'cosmetica', 'PM-791', 1, 0, '2026-03-16', 42000, 95000, NULL, 'Código: 791', 'sede-pm-2'),
('prod-pm-798', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LE LABO-SANTAL 33', 'REP-LE LABO-SANTAL 33-UNI', 'UNISEX', 'cosmetica', 'PM-798', 1, 0, '2026-03-16', 41600, 95000, NULL, 'Código: 798', 'sede-pm-2'),
('prod-pm-631', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LOEWE-SOLO', 'REP-LOEWE-SOLO-MAS', 'CABALLEROS', 'cosmetica', 'PM-631', 1, 0, '2026-03-16', 42000, 90000, NULL, 'Código: 631', 'sede-pm-2'),
('prod-pm-1348', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LOUIS VUITTON CALIFORNIA- FEM', 'REP-LOUIS VUITTON CALIFORNIA- FEM', 'CREMAS', 'cosmetica', 'PM-1348', 0, 0, '2026-03-16', 50000, 100000, NULL, 'Código: 1348', 'sede-pm-2'),
('prod-pm-676', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LOUIS VUITTON-OMBRE NOMADE', 'REP-LOUIS VUITTON-OMBRE NOMADE-MAS', 'CABALLEROS', 'cosmetica', 'PM-676', 1, 0, '2026-03-16', 57000, 100000, NULL, 'Código: 676', 'sede-pm-2'),
('prod-pm-692', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'LOUIS VUITTON-SPELL ON YOU', 'REP-LOUIS VUITTON-SPELL ON YOU-FEM', 'DAMAS', 'cosmetica', 'PM-692', 1, 0, '2026-03-16', 45000, 98000, NULL, 'Código: 692', 'sede-pm-2'),
('prod-pm-797', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'MAISON FRANCIS KURKDJIAN-BACCARAT ROUGE 540', 'REP-MAISON FRANCIS KURKDJIAN-BACCARAT ROUGE 540-UNI', 'UNISEX', 'cosmetica', 'PM-797', 1, 0, '2026-03-16', 46000, 100000, NULL, 'Código: 797', 'sede-pm-2'),
('prod-pm-800', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'MANCERA-INSTANT CRUSH', 'REP-MANCERA-INSTANT CRUSH-UNI', 'UNISEX', 'cosmetica', 'PM-800', 1, 0, '2026-03-16', 37000, 90000, NULL, 'Código: 800', 'sede-pm-2'),
('prod-pm-847', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'MANCERA-ROSES VAINILLE', 'REP-MANCERA-ROSES VAINILLE-FEM', 'DAMAS', 'cosmetica', 'PM-847', 1, 0, '2026-03-16', 43000, 90000, NULL, 'Código: 847', 'sede-pm-2'),
('prod-pm-764', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'MARC JACOBS-DECADENCE', 'REP-MARC JACOBS-DECADENCE-FEM', 'DAMAS', 'cosmetica', 'PM-764', 0, 0, '2026-03-16', 62000, 130000, NULL, 'Código: 764', 'sede-pm-2'),
('prod-pm-641', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'MERCEDEZ BENZ-INTENSE', 'REP-MERCEDEZ BENZ-INTENSE-MAS', 'CABALLEROS', 'cosmetica', 'PM-641', 0, 0, '2026-03-16', 37000, 80000, NULL, 'Código: 641', 'sede-pm-2'),
('prod-pm-759', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'MERCEDEZ BENZ-MERCEDEZ BENZ INTENSE', 'REP-MERCEDEZ BENZ-MERCEDEZ BENZ INTENSE-FEM', 'DAMAS', 'cosmetica', 'PM-759', 1, 0, '2026-03-16', 37000, 80000, NULL, 'Código: 759', 'sede-pm-2'),
('prod-pm-666', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'MONTALE-ARABIANS TONKA', 'REP-MONTALE-ARABIANS TONKA-UNI', 'UNISEX', 'cosmetica', 'PM-666', 0, 0, '2026-03-16', 37000, 85000, NULL, 'Código: 666', 'sede-pm-2'),
('prod-pm-792', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'MONTALE-INTENSE CAFE', 'REP-MONTALE-INTENSE CAFE-FEM', 'DAMAS', 'cosmetica', 'PM-792', 1, 0, '2026-03-16', 40000, 90000, NULL, 'Código: 792', 'sede-pm-2'),
('prod-pm-794', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'MONTALE-STARRY NIGHT', 'REP-MONTALE-STARRY NIGHT-FEM', 'DAMAS', 'cosmetica', 'PM-794', 1, 0, '2026-03-16', 37000, 85000, NULL, 'Código: 794', 'sede-pm-2'),
('prod-pm-880', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'MONTBLANC-EXPLORER', 'REP-MONTBLANC-EXPLORER-MAS', 'CABALLEROS', 'cosmetica', 'PM-880', 1, 0, '2026-03-16', 41600, 90000, NULL, 'Código: 880', 'sede-pm-2'),
('prod-pm-675', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'MONTBLANC-LEGEND SPIRIT', 'REP-MONTBLANC-LEGEND SPIRIT-MAS', 'CABALLEROS', 'cosmetica', 'PM-675', 2, 0, '2026-03-16', 35000, 85000, NULL, 'Código: 675', 'sede-pm-2');
INSERT INTO products (id, tenant_id, name, articulo, category, product_type, sku, stock, reorder_point, entry_date, purchase_price, sale_price, presentation, notes, sede_id) VALUES
('prod-pm-s2-616', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'MONTBLANC-STARWALKER', 'REP-MONTBLANC-STARWALKER-MAS', 'CABALLEROS', 'cosmetica', 'PM-S2-616', 1, 0, '2026-03-16', 37000, 80000, NULL, 'Código: 616', 'sede-pm-2'),
('prod-pm-726', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'MOSCHINO-CHEAP I LOVE LOVE', 'REP-MOSCHINO-CHEAP I LOVE LOVE-FEM', 'DAMAS', 'cosmetica', 'PM-726', 1, 0, '2026-03-16', 37000, 85000, NULL, 'Código: 726', 'sede-pm-2'),
('prod-pm-728', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'MOSCHINO-FRESH GOLD', 'REP-MOSCHINO-FRESH GOLD-FEM', 'DAMAS', 'cosmetica', 'PM-728', 0, 0, '2026-03-16', 62000, 115000, NULL, 'Código: 728', 'sede-pm-2'),
('prod-pm-725', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'MOSCHINO-FRESH PINK', 'REP-MOSCHINO-FRESH PINK-FEM', 'DAMAS', 'cosmetica', 'PM-725', 0, 0, '2026-03-16', 62000, 115000, NULL, 'Código: 725', 'sede-pm-2'),
('prod-pm-691', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'MOSCHINO-FUNNY', 'REP-MOSCHINO-FUNNY-FEM', 'DAMAS', 'cosmetica', 'PM-691', 1, 0, '2026-03-16', 37000, 85000, NULL, 'Código: 691', 'sede-pm-2'),
('prod-pm-767', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'MOSCHINO-TOY 2 BUBBLE GUM', 'REP-MOSCHINO-TOY 2 BUBBLE GUM-FEM', 'DAMAS', 'cosmetica', 'PM-767', 1, 0, '2026-03-16', 51000, 120000, NULL, 'Código: 767', 'sede-pm-2'),
('prod-pm-727', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'MOSCHINO-TOY 2 PEARL', 'REP-MOSCHINO-TOY 2 PEARL-UNI', 'UNISEX', 'cosmetica', 'PM-727', 1, 0, '2026-03-16', 65000, 120000, NULL, 'Código: 727', 'sede-pm-2'),
('prod-pm-768', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'MOSCHINO-TOY 2', 'REP-MOSCHINO-TOY 2-FEM', 'DAMAS', 'cosmetica', 'PM-768', 1, 0, '2026-03-16', 51000, 120000, NULL, 'Código: 768', 'sede-pm-2'),
('prod-pm-656', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'MOSCHINO-TOY BOY', 'REP-MOSCHINO-TOY BOY-MAS', 'CABALLEROS', 'cosmetica', 'PM-656', 0, 0, '2026-03-16', 52000, 125000, NULL, 'Código: 656', 'sede-pm-2'),
('prod-pm-s2-620', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'NAUTICA-NAUTICA VOYAGE', 'REP-NAUTICA-NAUTICA VOYAGE-MAS', 'CABALLEROS', 'cosmetica', 'PM-S2-620', 1, 0, '2026-03-16', 34000, 80000, NULL, 'Código: 620', 'sede-pm-2'),
('prod-pm-796', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'NUSUK-ANA AL AWWAL BLUE', 'REP-NUSUK-ANA AL AWWAL BLUE-UNI', 'UNISEX', 'cosmetica', 'PM-796', 1, 0, '2026-03-16', 55000, 115000, NULL, 'Código: 796', 'sede-pm-2'),
('prod-pm-795', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'NUSUK-ANA AL AWWAL RED', 'REP-NUSUK-ANA AL AWWAL RED-UNI', 'UNISEX', 'cosmetica', 'PM-795', 1, 0, '2026-03-16', 62000, 115000, NULL, 'Código: 795', 'sede-pm-2'),
('prod-pm-809', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ORIENTICA-AMBER NOIR', 'REP-ORIENTICA-AMBER NOIR-UNI', 'UNISEX', 'cosmetica', 'PM-809', 1, 0, '2026-03-16', 70000, 160000, NULL, 'Código: 809', 'sede-pm-2'),
('prod-pm-806', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ORIENTICA-AMBER ROUGE', 'REP-ORIENTICA-AMBER ROUGE-UNI', 'UNISEX', 'cosmetica', 'PM-806', 2, 0, '2026-03-16', 67000, 130000, NULL, 'Código: 806', 'sede-pm-2'),
('prod-pm-807', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ORIENTICA-OUD SAFFRON', 'REP-ORIENTICA-OUD SAFFRON-UNI', 'UNISEX', 'cosmetica', 'PM-807', 0, 0, '2026-03-16', 65000, 135000, NULL, 'Código: 807', 'sede-pm-2'),
('prod-pm-789', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ORIENTICA-ROYAL AMBER', 'REP-ORIENTICA-ROYAL AMBER-UNI', 'UNISEX', 'cosmetica', 'PM-789', 1, 0, '2026-03-16', 65000, 140000, NULL, 'Código: 789', 'sede-pm-2'),
('prod-pm-810', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ORIENTICA-ROYAL BLEU', 'REP-ORIENTICA-ROYAL BLEU-UNI', 'UNISEX', 'cosmetica', 'PM-810', 1, 0, '2026-03-16', 80000, 160000, NULL, 'Código: 810', 'sede-pm-2'),
('prod-pm-808', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ORIENTICA-VELVET GOLD', 'REP-ORIENTICA-VELVET GOLD-FEM', 'DAMAS', 'cosmetica', 'PM-808', 1, 0, '2026-03-16', 65000, 135000, NULL, 'Código: 808', 'sede-pm-2'),
('prod-pm-663', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'PACO RABANNE-1 MILLION ELIXIR', 'REP-PACO RABANNE-1 MILLION ELIXIR-MAS', 'CABALLEROS', 'cosmetica', 'PM-663', 0, 0, '2026-03-16', 37000, 90000, NULL, 'Código: 663', 'sede-pm-2'),
('prod-pm-839', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'PACO RABANNE-1 MILLION GOLDEN OUD', 'REP-PACO RABANNE-1 MILLION GOLDEN OUD-MAS', 'CABALLEROS', 'cosmetica', 'PM-839', 1, 0, '2026-03-16', 42000, 90000, NULL, 'Código: 839', 'sede-pm-2'),
('prod-pm-647', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'PACO RABANNE-1 MILLION LUCKY', 'REP-PACO RABANNE-1 MILLION LUCKY-MAS', 'CABALLEROS', 'cosmetica', 'PM-647', 3, 0, '2026-03-16', 35000, 80000, NULL, 'Código: 647', 'sede-pm-2'),
('prod-pm-664', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'PACO RABANNE-1 MILLION PRIVE', 'REP-PACO RABANNE-1 MILLION PRIVE-MAS', 'CABALLEROS', 'cosmetica', 'PM-664', 1, 0, '2026-03-16', 34000, 80000, NULL, 'Código: 664', 'sede-pm-2'),
('prod-pm-665', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'PACO RABANNE-1 MILLION ROYAL', 'REP-PACO RABANNE-1 MILLION ROYAL-MAS', 'CABALLEROS', 'cosmetica', 'PM-665', 1, 0, '2026-03-16', 35000, 85000, NULL, 'Código: 665', 'sede-pm-2'),
('prod-pm-667', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'PACO RABANNE-1 MILLION', 'REP-PACO RABANNE-1 MILLION-MAS', 'CABALLEROS', 'cosmetica', 'PM-667', 3, 0, '2026-03-16', 34000, 80000, NULL, 'Código: 667', 'sede-pm-2'),
('prod-pm-654', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'PACO RABANNE-BLACK XS AFRODISIAQUE', 'REP-PACO RABANNE-BLACK XS AFRODISIAQUE-MAS', 'CABALLEROS', 'cosmetica', 'PM-654', 1, 0, '2026-03-16', 37000, 80000, NULL, 'Código: 654', 'sede-pm-2'),
('prod-pm-683', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'PACO RABANNE-BLACK XS BLAON EXCESS', 'REP-PACO RABANNE-BLACK XS BLAON EXCESS-FEM', 'DAMAS', 'cosmetica', 'PM-683', 0, 0, '2026-03-16', 37000, 85000, NULL, 'Código: 683', 'sede-pm-2'),
('prod-pm-655', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'PACO RABANNE-BLACK XS LEXCES', 'REP-PACO RABANNE-BLACK XS LEXCES-MAS', 'CABALLEROS', 'cosmetica', 'PM-655', 2, 0, '2026-03-16', 37000, 80000, NULL, 'Código: 655', 'sede-pm-2'),
('prod-pm-653', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'PACO RABANNE-BLACK XS', 'REP-PACO RABANNE-BLACK XS-MAS', 'CABALLEROS', 'cosmetica', 'PM-653', 2, 0, '2026-03-16', 35000, 80000, NULL, 'Código: 653', 'sede-pm-2'),
('prod-pm-762', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'PACO RABANNE-FAME', 'REP-PACO RABANNE-FAME-FEM', 'DAMAS', 'cosmetica', 'PM-762', 1, 0, '2026-03-16', 47000, 100000, NULL, 'Código: 762', 'sede-pm-2'),
('prod-pm-652', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'PACO RABANNE-INVICTUS INTENSE', 'REP-PACO RABANNE-INVICTUS INTENSE-MAS', 'CABALLEROS', 'cosmetica', 'PM-652', 1, 0, '2026-03-16', 37000, 85000, NULL, 'Código: 652', 'sede-pm-2'),
('prod-pm-625', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'PACO RABANNE-INVICTUS LEGEND-MASC', 'REP-PACO RABANNE-INVICTUS LEGEND-MASC', 'CREMAS', 'cosmetica', 'PM-625', 2, 0, '2026-03-16', 34000, 80000, NULL, 'Código: 625', 'sede-pm-2'),
('prod-pm-650', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'PACO RABANNE-INVICTUS VICTORY ELIXIR', 'REP-PACO RABANNE-INVICTUS VICTORY ELIXIR-MAS', 'CABALLEROS', 'cosmetica', 'PM-650', 1, 0, '2026-03-16', 35000, 85000, NULL, 'Código: 650', 'sede-pm-2'),
('prod-pm-814', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'PACO RABANNE-INVICTUS VICTORY', 'REP-PACO RABANNE-INVICTUS VICTORY-MAS', 'CABALLEROS', 'cosmetica', 'PM-814', 1, 0, '2026-03-16', 35000, 80000, NULL, 'Código: 814', 'sede-pm-2'),
('prod-pm-651', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'PACO RABANNE-INVICTUS', 'REP-PACO RABANNE-INVICTUS-MAS', 'CABALLEROS', 'cosmetica', 'PM-651', 2, 0, '2026-03-16', 34000, 80000, NULL, 'Código: 651', 'sede-pm-2'),
('prod-pm-702', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'PACO RABANNE-LADY MILLION', 'REP-PACO RABANNE-LADY MILLION-FEM', 'DAMAS', 'cosmetica', 'PM-702', 1, 0, '2026-03-16', 37000, 80000, NULL, 'Código: 702', 'sede-pm-2'),
('prod-pm-873', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'PACO RABANNE-MILLION GOLD', 'REP-PACO RABANNE-MILLION GOLD-MAS', 'CABALLEROS', 'cosmetica', 'PM-873', 0, 0, '2026-03-16', 42000, 90000, NULL, 'Código: 873', 'sede-pm-2'),
('prod-pm-747', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'PACO RABANNE-OLYMPEA', 'REP-PACO RABANNE-OLYMPEA-FEM', 'DAMAS', 'cosmetica', 'PM-747', 1, 0, '2026-03-16', 38500, 85000, NULL, 'Código: 747', 'sede-pm-2'),
('prod-pm-657', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'PACO RABANNE-PHANTOM', 'REP-PACO RABANNE-PHANTOM-MAS', 'CABALLEROS', 'cosmetica', 'PM-657', 1, 0, '2026-03-16', 46000, 90000, NULL, 'Código: 657', 'sede-pm-2'),
('prod-pm-630', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'PACO RABANNE-PURE XS', 'REP-PACO RABANNE-PURE XS-MAS', 'CABALLEROS', 'cosmetica', 'PM-630', 1, 0, '2026-03-16', 35000, 80000, NULL, 'Código: 630', 'sede-pm-2'),
('prod-pm-1394', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'PACO RABBANNE BLACK XS- FEM', 'REP-PACO RABBANNE BLACK XS- FEM', 'CREMAS', 'cosmetica', 'PM-1394', 0, 0, '2026-03-16', 37000, 80000, NULL, 'Código: 1394', 'sede-pm-2'),
('prod-pm-697', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'PARFUMS DE MARLY-DELINA EXCLUSIF', 'REP-PARFUMS DE MARLY-DELINA EXCLUSIF-FEM', 'DAMAS', 'cosmetica', 'PM-697', 1, 0, '2026-03-16', 37000, 90000, NULL, 'Código: 697', 'sede-pm-2'),
('prod-pm-805', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'PARFUMS DE MARLY-KALAN', 'REP-PARFUMS DE MARLY-KALAN-UNI', 'UNISEX', 'cosmetica', 'PM-805', 1, 0, '2026-03-16', 90000, 195000, NULL, 'Código: 805', 'sede-pm-2'),
('prod-pm-804', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'PARFUMS DE MARLY-LAYTON', 'REP-PARFUMS DE MARLY-LAYTON-UNI', 'UNISEX', 'cosmetica', 'PM-804', 1, 0, '2026-03-16', 71000, 150000, NULL, 'Código: 804', 'sede-pm-2'),
('prod-pm-803', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'PARFUMS DE MARLY-PEGASUS', 'REP-PARFUMS DE MARLY-PEGASUS-MAS', 'CABALLEROS', 'cosmetica', 'PM-803', 1, 0, '2026-03-16', 90000, 195000, NULL, 'Código: 803', 'sede-pm-2'),
('prod-pm-1347', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'PARIS CORNER-MARSHMALLOW', 'REP-PARIS CORNER-MARSHMALLOW-FEM', 'DAMAS', 'cosmetica', 'PM-1347', 1, 0, '2026-03-16', 62000, 130000, NULL, 'Código: 1347', 'sede-pm-2'),
('prod-pm-689', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'PARIS HILTON-CAN CAN', 'REP-PARIS HILTON-CAN CAN-FEM', 'DAMAS', 'cosmetica', 'PM-689', 2, 0, '2026-03-16', 35000, 80000, NULL, 'Código: 689', 'sede-pm-2'),
('prod-pm-704', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'PARIS HILTON-DAZZLE', 'REP-PARIS HILTON-DAZZLE-FEM', 'DAMAS', 'cosmetica', 'PM-704', 1, 0, '2026-03-16', 37000, 80000, NULL, 'Código: 704', 'sede-pm-2'),
('prod-pm-753', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'PARIS HILTON-GOLD RUSH', 'REP-PARIS HILTON-GOLD RUSH-FEM', 'DAMAS', 'cosmetica', 'PM-753', 1, 0, '2026-03-16', 46000, 95000, NULL, 'Código: 753', 'sede-pm-2'),
('prod-pm-737', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'PARIS HILTON-HEIRESS', 'REP-PARIS HILTON-HEIRESS-FEM', 'DAMAS', 'cosmetica', 'PM-737', 1, 0, '2026-03-16', 34000, 80000, NULL, 'Código: 737', 'sede-pm-2'),
('prod-pm-723', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'PARIS HILTON-PARIS HILTON', 'REP-PARIS HILTON-PARIS HILTON-FEM', 'DAMAS', 'cosmetica', 'PM-723', 1, 0, '2026-03-16', 34000, 80000, NULL, 'Código: 723', 'sede-pm-2'),
('prod-pm-621', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'PARIS HILTON-PARIS HILTON', 'REP-PARIS HILTON-PARIS HILTON-MAS', 'CABALLEROS', 'cosmetica', 'PM-621', 1, 0, '2026-03-16', 37000, 80000, NULL, 'Código: 621', 'sede-pm-2'),
('prod-pm-s2-160', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'PARIS HILTON-ROSE RUSH', 'REP-PARIS HILTON-ROSE RUSH-FEM', 'DAMAS', 'cosmetica', 'PM-S2-160', 0, 0, '2026-03-16', 42000, 90000, NULL, 'Código: 160', 'sede-pm-2'),
('prod-pm-660', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'PENHALIGONS-LORD GEORGE', 'REP-PENHALIGONS-LORD GEORGE-MAS', 'CABALLEROS', 'cosmetica', 'PM-660', 0, 0, '2026-03-16', 65000, 135000, NULL, 'Código: 660', 'sede-pm-2'),
('prod-pm-700', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'PEPE JEANS-CELEBRATE', 'REP-PEPE JEANS-CELEBRATE-FEM', 'DAMAS', 'cosmetica', 'PM-700', 1, 0, '2026-03-16', 45000, 90000, NULL, 'Código: 700', 'sede-pm-2'),
('prod-pm-703', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'PEPE JEANS-PEPE JEANS LONDON', 'REP-PEPE JEANS-PEPE JEANS LONDON-FEM', 'DAMAS', 'cosmetica', 'PM-703', 0, 0, '2026-03-16', 45000, 90000, NULL, 'Código: 703', 'sede-pm-2'),
('prod-pm-707', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'PERRY ELLIS-360 CLASICA', 'REP-PERRY ELLIS-360 CLASICA-FEM', 'DAMAS', 'cosmetica', 'PM-707', 1, 0, '2026-03-16', 34000, 80000, NULL, 'Código: 707', 'sede-pm-2'),
('prod-pm-648', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'PERRY ELLIS-360 CLASICA-MASC', 'REP-PERRY ELLIS-360 CLASICA-MASC', 'CREMAS', 'cosmetica', 'PM-648', 1, 0, '2026-03-16', 37000, 80000, NULL, 'Código: 648', 'sede-pm-2'),
('prod-pm-643', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'RALPH LAUREN-POLO BLUE', 'REP-RALPH LAUREN-POLO BLUE-MAS', 'CABALLEROS', 'cosmetica', 'PM-643', 1, 0, '2026-03-16', 35000, 80000, NULL, 'Código: 643', 'sede-pm-2'),
('prod-pm-649', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'RALPH LAUREN-POLO RED', 'REP-RALPH LAUREN-POLO RED-MAS', 'CABALLEROS', 'cosmetica', 'PM-649', 2, 0, '2026-03-16', 33000, 80000, NULL, 'Código: 649', 'sede-pm-2'),
('prod-pm-757', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'RALPH LAUREN-RALPH FRESH', 'REP-RALPH LAUREN-RALPH FRESH-FEM', 'DAMAS', 'cosmetica', 'PM-757', 1, 0, '2026-03-16', 37000, 80000, NULL, 'Código: 757', 'sede-pm-2'),
('prod-pm-756', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'RALPH LAUREN-RALPH', 'REP-RALPH LAUREN-RALPH-FEM', 'DAMAS', 'cosmetica', 'PM-756', 1, 0, '2026-03-16', 35000, 80000, NULL, 'Código: 756', 'sede-pm-2'),
('prod-pm-834', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'RASASI-HAWAS FOR HER', 'REP-RASASI-HAWAS FOR HER-FEM', 'DAMAS', 'cosmetica', 'PM-834', 1, 0, '2026-03-16', 52000, 95000, NULL, 'Código: 834', 'sede-pm-2'),
('prod-pm-831', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'RASASI-HAWAS FOR HIM', 'REP-RASASI-HAWAS FOR HIM-MAS', 'CABALLEROS', 'cosmetica', 'PM-831', 2, 0, '2026-03-16', 52000, 95000, NULL, 'Código: 831', 'sede-pm-2'),
('prod-pm-1203', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'RAVE-NOW WOMAN', 'REP-RAVE-NOW WOMAN-FEM', 'DAMAS', 'cosmetica', 'PM-1203', 1, 0, '2026-03-16', 72000, 140000, NULL, 'Código: 1203', 'sede-pm-2'),
('prod-pm-854', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'SOFIA VERGARA-SOFIA', 'REP-SOFIA VERGARA-SOFIA-FEM', 'DAMAS', 'cosmetica', 'PM-854', 1, 0, '2026-03-16', 42000, 90000, NULL, 'Código: 854', 'sede-pm-2'),
('prod-pm-658', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'TED LAPIDUS PARIS-LAPIDUS', 'REP-TED LAPIDUS PARIS-LAPIDUS-MAS', 'CABALLEROS', 'cosmetica', 'PM-658', 1, 0, '2026-03-16', 37000, 80000, NULL, 'Código: 658', 'sede-pm-2'),
('prod-pm-825', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'THIERRY MUGLER-ALIEN', 'REP-THIERRY MUGLER-ALIEN-FEM', 'DAMAS', 'cosmetica', 'PM-825', 1, 0, '2026-03-16', 37000, 80000, NULL, 'Código: 825', 'sede-pm-2'),
('prod-pm-693', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'TOMMY HILFIGER-TOMMY NOW GIRL', 'REP-TOMMY HILFIGER-TOMMY NOW GIRL-FEM', 'DAMAS', 'cosmetica', 'PM-693', 1, 0, '2026-03-16', 37000, 80000, NULL, 'Código: 693', 'sede-pm-2'),
('prod-pm-746', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'VALENTINO-DONNA', 'REP-VALENTINO-DONNA-FEM', 'DAMAS', 'cosmetica', 'PM-746', 1, 0, '2026-03-16', 47000, 90000, NULL, 'Código: 746', 'sede-pm-2'),
('prod-pm-832', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'VALENTINO-UOMO BORN IN ROMA INTENSE', 'REP-VALENTINO-UOMO BORN IN ROMA INTENSE-MAS', 'CABALLEROS', 'cosmetica', 'PM-832', 2, 0, '2026-03-16', 47000, 95000, NULL, 'Código: 832', 'sede-pm-2'),
('prod-pm-850', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'VALENTINO-UOMO', 'REP-VALENTINO-UOMO-MAS', 'CABALLEROS', 'cosmetica', 'PM-850', 1, 0, '2026-03-16', 35000, 80000, NULL, 'Código: 850', 'sede-pm-2'),
('prod-pm-838', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'VERSACE-BRIGHT CRYSTAL ABSOLU', 'REP-VERSACE-BRIGHT CRYSTAL ABSOLU-FEM', 'DAMAS', 'cosmetica', 'PM-838', 1, 0, '2026-03-16', 43000, 90000, NULL, 'Código: 838', 'sede-pm-2'),
('prod-pm-748', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'VERSACE-BRIGHT CRYSTAL', 'REP-VERSACE-BRIGHT CRYSTAL-FEM', 'DAMAS', 'cosmetica', 'PM-748', 1, 0, '2026-03-16', 35000, 80000, NULL, 'Código: 748', 'sede-pm-2'),
('prod-pm-634', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'VERSACE-DYLAN BLUE', 'REP-VERSACE-DYLAN BLUE-MAS', 'CABALLEROS', 'cosmetica', 'PM-634', 0, 0, '2026-03-16', 42000, 85000, NULL, 'Código: 634', 'sede-pm-2'),
('prod-pm-846', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'VERSACE-DYLAN PURPLE', 'REP-VERSACE-DYLAN PURPLE-FEM', 'DAMAS', 'cosmetica', 'PM-846', 2, 0, '2026-03-16', 47000, 90000, NULL, 'Código: 846', 'sede-pm-2'),
('prod-pm-s2-618', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'VERSACE-EAU FRAICHE', 'REP-VERSACE-EAU FRAICHE-MAS', 'CABALLEROS', 'cosmetica', 'PM-S2-618', 1, 0, '2026-03-16', 35000, 80000, NULL, 'Código: 618', 'sede-pm-2'),
('prod-pm-680', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'VERSACE-EROS FLAME', 'REP-VERSACE-EROS FLAME-MAS', 'CABALLEROS', 'cosmetica', 'PM-680', 2, 0, '2026-03-16', 34000, 80000, NULL, 'Código: 680', 'sede-pm-2'),
('prod-pm-681', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'VERSACE-EROS', 'REP-VERSACE-EROS-MAS', 'CABALLEROS', 'cosmetica', 'PM-681', 2, 0, '2026-03-16', 35000, 80000, NULL, 'Código: 681', 'sede-pm-2'),
('prod-pm-793', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'VERSACE-YELLOW DIAMOND', 'REP-VERSACE-YELLOW DIAMOND-FEM', 'DAMAS', 'cosmetica', 'PM-793', 0, 0, '2026-03-16', 37000, 85000, NULL, 'Código: 793', 'sede-pm-2'),
('prod-pm-826', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'VICTORIA SECRET-BOMBSHELL INTENSE', 'REP-VICTORIA SECRET-BOMBSHELL INTENSE-FEM', 'DAMAS', 'cosmetica', 'PM-826', 0, 0, '2026-03-16', 34000, 85000, NULL, 'Código: 826', 'sede-pm-2'),
('prod-pm-845', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'VICTORIA SECRET-BOMBSHELL SEDUCTION', 'REP-VICTORIA SECRET-BOMBSHELL SEDUCTION-FEM', 'DAMAS', 'cosmetica', 'PM-845', 0, 0, '2026-03-16', 35000, 80000, NULL, 'Código: 845', 'sede-pm-2'),
('prod-pm-760', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'VICTORIA SECRET-BOMBSHELL', 'REP-VICTORIA SECRET-BOMBSHELL-FEM', 'DAMAS', 'cosmetica', 'PM-760', 1, 0, '2026-03-16', 37000, 85000, NULL, 'Código: 760', 'sede-pm-2'),
('prod-pm-s2-619', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'VICTORINOX-SWISS ARMY CLASSIC', 'REP-VICTORINOX-SWISS ARMY CLASSIC-MAS', 'CABALLEROS', 'cosmetica', 'PM-S2-619', 2, 0, '2026-03-16', 34000, 80000, NULL, 'Código: 619', 'sede-pm-2'),
('prod-pm-629', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'VIKTOR ROLF-SPICEBOMB', 'REP-VIKTOR ROLF-SPICEBOMB-MAS', 'CABALLEROS', 'cosmetica', 'PM-629', 1, 0, '2026-03-16', 37000, 80000, NULL, 'Código: 629', 'sede-pm-2'),
('prod-pm-853', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'XERJOFF-ERBA PURA', 'REP-XERJOFF-ERBA PURA-UNI', 'UNISEX', 'cosmetica', 'PM-853', 0, 0, '2026-03-16', 93000, 160000, NULL, 'Código: 853', 'sede-pm-2'),
('prod-pm-835', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'YVES SAINT LAURENT-YVES SAINT LAURENT', 'REP-YVES SAINT LAURENT-YVES SAINT LAURENT-MAS', 'CABALLEROS', 'cosmetica', 'PM-835', 1, 0, '2026-03-16', 43000, 85000, NULL, 'Código: 835', 'sede-pm-2');

-- SEDE 1 — INSUMOS (7 filas: bolsas, cajas, envases)
-- INSERT IGNORE: cajas y envases pueden ya existir si se ejecuto recetasperfummua.sql primero
INSERT IGNORE INTO products (id, tenant_id, name, articulo, category, product_type, sku, stock, reorder_point, entry_date, purchase_price, sale_price, presentation, notes, sede_id) VALUES
('prod-pm-2001', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'BOLSA ECOLÓGICA GRANDE', 'BOLSA ECOLÓGICA GRANDE', 'INSUMOS', 'insumos', 'PM-2001', 1064, 0, '2026-03-16', 1000, 1000, NULL, 'Código: 2001', 'sede-pm-1'),
('prod-pm-2000', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'BOLSA ECOLÓGICA PEQUEÑA', 'BOLSA ECOLÓGICA PEQUEÑA', 'INSUMOS', 'insumos', 'PM-2000', 936, 0, '2026-03-16', 1000, 1000, NULL, 'Código: 2000', 'sede-pm-1'),
('prod-pm-2006', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'CAJA 100 ML', 'CAJA 100 ML', 'INSUMOS', 'insumos', 'PM-2006', 344, 0, '2026-03-16', 1600, 1600, NULL, 'Código: 2006', 'sede-pm-1'),
('prod-pm-2005', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'CAJA 30-50 ML', 'CAJA 30-50 ML', 'INSUMOS', 'insumos', 'PM-2005', 341, 0, '2026-03-16', 1800, 1800, NULL, 'Código: 2005', 'sede-pm-1'),
('prod-pm-2004', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ENVASE LACOSTE 100ML', 'ENVASE LACOSTE 100ML', 'INSUMOS', 'insumos', 'PM-2004', 936, 0, '2026-03-16', 2847, 2900, NULL, 'Código: 2004', 'sede-pm-1'),
('prod-pm-2002', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ENVASE-LACOSTE 30ML', 'ENVASE-LACOSTE 30ML', 'INSUMOS', 'insumos', 'PM-2002', 776, 0, '2026-03-16', 2738, 2800, NULL, 'Código: 2002', 'sede-pm-1'),
('prod-pm-2007', 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd', 'ENVASE-LACOSTE 50 ML', 'ENVASE-LACOSTE 50 ML', 'INSUMOS', 'insumos', 'PM-2007', 992, 0, '2026-03-16', 2808, 2900, NULL, 'Código: 2007', 'sede-pm-1');

-- Actualizar stock y precios reales de cajas/envases (por si vinieron de recetasperfummua.sql con stock=0)
UPDATE products SET stock = 344, purchase_price = 1600, sale_price = 1600 WHERE id = 'prod-pm-2006' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';
UPDATE products SET stock = 341, purchase_price = 1800, sale_price = 1800 WHERE id = 'prod-pm-2005' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';
UPDATE products SET stock = 936, purchase_price = 2847, sale_price = 2900 WHERE id = 'prod-pm-2004' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';
UPDATE products SET stock = 776, purchase_price = 2738, sale_price = 2800 WHERE id = 'prod-pm-2002' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';
UPDATE products SET stock = 992, purchase_price = 2808, sale_price = 2900 WHERE id = 'prod-pm-2007' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- ============================================================
-- ACTUALIZACION DE CATEGORIAS Y LINEAS (brand)
-- Reclasifica todos los productos segun inventariperfummua.md
-- ============================================================

-- ============================================================
-- ACTUALIZACION: Categorias y campo brand (Linea) segun inventariperfummua.md
-- Ejecutar despues de los INSERTs de inventario_perfummua.sql
-- ============================================================

SET @tid = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' COLLATE utf8mb4_unicode_ci;


-- SEDE 1 - INSUMOS: Envases
UPDATE products SET category = 'INSUMOS', brand = 'Envase'
WHERE tenant_id = @tid AND sede_id = 'sede-pm-1' AND articulo LIKE 'ENVASE%';

-- SEDE 1 - INSUMOS: Cajas
UPDATE products SET category = 'INSUMOS', brand = 'Caja'
WHERE tenant_id = @tid AND sede_id = 'sede-pm-1' AND articulo LIKE 'CAJA%';

-- SEDE 1 - INSUMOS: Bolsas
UPDATE products SET category = 'INSUMOS', brand = 'Bolsa Eco'
WHERE tenant_id = @tid AND sede_id = 'sede-pm-1' AND articulo LIKE 'BOLSA%';

-- SEDE 1 - CORPORAL: VS Cremas
UPDATE products SET category = 'CORPORAL', brand = 'Crema', product_type = 'cosmetica'
WHERE tenant_id = @tid AND sede_id = 'sede-pm-1'
  AND (articulo LIKE 'ORI-VS CREMA%' OR articulo LIKE 'ORI-CREMA%');

-- SEDE 1 - CORPORAL: VS Splash
UPDATE products SET category = 'CORPORAL', brand = 'Splash', product_type = 'cosmetica'
WHERE tenant_id = @tid AND sede_id = 'sede-pm-1' AND articulo LIKE 'ORI-VS SPLASH%';

-- SEDE 1 - CORPORAL: Aerosol corporal
UPDATE products SET category = 'CORPORAL', brand = 'Splash', product_type = 'cosmetica'
WHERE tenant_id = @tid AND sede_id = 'sede-pm-1' AND articulo LIKE 'ORI-AEROSOL%';

-- SEDE 1 - CORPORAL: Cremas Vidan y generales
UPDATE products SET category = 'CORPORAL', brand = 'Crema', product_type = 'cosmetica'
WHERE tenant_id = @tid AND sede_id = 'sede-pm-1'
  AND (articulo LIKE 'VIDAN-CREMA%' OR articulo LIKE 'CREMA-%' OR articulo LIKE 'VIDAN-MINI CREMA%');

-- SEDE 1 - CORPORAL: Mantequillas
UPDATE products SET category = 'CORPORAL', brand = 'Mantequilla', product_type = 'cosmetica'
WHERE tenant_id = @tid AND sede_id = 'sede-pm-1' AND articulo LIKE '%MANTEQUILLA%';

-- SEDE 1 - CORPORAL: Mini Splash Vidan
UPDATE products SET category = 'CORPORAL', brand = 'Splash', product_type = 'cosmetica'
WHERE tenant_id = @tid AND sede_id = 'sede-pm-1' AND articulo LIKE 'VIDAN-MINI SPLASH%';

-- SEDE 1 - CORPORAL: PM Splash y REP Splash acrilicos
UPDATE products SET category = 'CORPORAL', brand = 'Splash', product_type = 'cosmetica'
WHERE tenant_id = @tid AND sede_id = 'sede-pm-1'
  AND (articulo LIKE 'PM-SPLASH%' OR articulo LIKE 'REP-SPLASH%' OR articulo LIKE 'PURPURE-MINI SPLASH%');

-- SEDE 1 - CORPORAL: Shimmer
UPDATE products SET category = 'CORPORAL', brand = 'Shimmer', product_type = 'cosmetica'
WHERE tenant_id = @tid AND sede_id = 'sede-pm-1'
  AND (articulo LIKE 'PM-SHIMMER%' OR articulo LIKE 'PERFUME-CABELLO%');

-- SEDE 1 - CORPORAL: Glitter Brilli Brilli
UPDATE products SET category = 'CORPORAL', brand = 'Glitter', product_type = 'cosmetica'
WHERE tenant_id = @tid AND sede_id = 'sede-pm-1' AND articulo LIKE 'PURPURE-BRILLI%';

-- SEDE 1 - CORPORAL: Kits
UPDATE products SET category = 'CORPORAL', brand = 'Kits', product_type = 'cosmetica'
WHERE tenant_id = @tid AND sede_id = 'sede-pm-1' AND articulo LIKE 'PURPURE-KITS%';

-- SEDE 1 - CORPORAL: Adicional (Feromonas, Musk Tahara)
UPDATE products SET category = 'CORPORAL', brand = 'Adicional', product_type = 'cosmetica'
WHERE tenant_id = @tid AND sede_id = 'sede-pm-1' AND articulo IN ('FEROMONAS', 'MUSK TAHARA');

-- SEDE 1 - INFANTIL: Splash para niños y niñas (sobreescribe CORPORAL para productos infantiles)
UPDATE products SET category = 'INFANTIL', brand = 'Infantil', product_type = 'cosmetica'
WHERE tenant_id = @tid AND sede_id = 'sede-pm-1'
  AND (articulo LIKE 'PM-SPLASH%-NI_O' OR articulo LIKE 'PM-SPLASH%-NI_A');

-- SEDE 1 - HOGAR: Textiles (Agua de Linos)
UPDATE products SET category = 'HOGAR', brand = 'Textiles', product_type = 'hogar'
WHERE tenant_id = @tid AND sede_id = 'sede-pm-1' AND articulo LIKE 'AGUA DE LINOS%';

-- SEDE 1 - HOGAR: Aromatizantes y PM Carro
UPDATE products SET category = 'HOGAR', brand = 'Aromatizante', product_type = 'hogar'
WHERE tenant_id = @tid AND sede_id = 'sede-pm-1'
  AND (articulo LIKE 'AROMATIZANTE%' OR articulo LIKE 'PM CARRO%');

-- SEDE 1 - HOGAR: Difusores
UPDATE products SET category = 'HOGAR', brand = 'Difusores', product_type = 'hogar'
WHERE tenant_id = @tid AND sede_id = 'sede-pm-1' AND articulo LIKE 'DIFUSOR%';

-- SEDE 1 - HOGAR: Esencias Hidrosolubles
UPDATE products SET category = 'HOGAR', brand = 'Esencias Hidrosolubles', product_type = 'hogar'
WHERE tenant_id = @tid AND sede_id = 'sede-pm-1' AND articulo LIKE 'ESENCIA HS%';

-- SEDE 1 - HOGAR: Esencias Pebetero
UPDATE products SET category = 'HOGAR', brand = 'Esencias Pebetero', product_type = 'hogar'
WHERE tenant_id = @tid AND sede_id = 'sede-pm-1' AND articulo LIKE 'ESENCIA PB%';

-- SEDE 1 - HOGAR: Pebetero
UPDATE products SET category = 'HOGAR', brand = 'Pebetero', product_type = 'hogar'
WHERE tenant_id = @tid AND sede_id = 'sede-pm-1' AND articulo = 'PEBETERO';

-- SEDE 1 - CABALLEROS/DAMAS/UNISEX: Los ORI- ya tienen su categoria por genero desde el INSERT.
-- No se reclasifican a PERFUMERIA; quedan en CABALLEROS, DAMAS o UNISEX segun el sufijo -MAS/-FEM/-UNI.

-- SEDE 1 - PERFUMERIA: Kits réplica
UPDATE products SET category = 'PERFUMERIA', brand = 'Kit Replica', product_type = 'perfumes'
WHERE tenant_id = @tid AND sede_id = 'sede-pm-1' AND articulo LIKE 'REP-KITS%';

-- SEDE 2 - CORPORAL: base (la mayoría son productos corporales; se refinará con los UPDATE siguientes)
UPDATE products SET category = 'CORPORAL', product_type = 'cosmetica'
WHERE tenant_id = @tid AND sede_id = 'sede-pm-2';


-- SEDE 2 - CORPORAL: Splashes PM, Replica, VS, Acrilicos, mini splashes
UPDATE products SET category = 'CORPORAL', brand = 'Splash', product_type = 'cosmetica'
WHERE tenant_id = @tid AND sede_id = 'sede-pm-2'
  AND (articulo LIKE 'PM-SPLASH%'
    OR articulo LIKE 'REP-SPLASH%'
    OR articulo LIKE 'REP-VS SPLASH%'
    OR articulo LIKE 'SPLASH-PM%'
    OR articulo LIKE 'PURPURE-MINI SPLASH%'
    OR articulo LIKE 'VIDAN-MINI SPLASH%');

-- SEDE 2 - CORPORAL: Shimmer / Glitter
UPDATE products SET category = 'CORPORAL', brand = 'Glitter', product_type = 'cosmetica'
WHERE tenant_id = @tid AND sede_id = 'sede-pm-2' AND articulo LIKE 'PURPURE-BRILLI%';

-- SEDE 2 - INFANTIL: Splashes para niñas y niños
UPDATE products SET category = 'INFANTIL', brand = 'Infantil', product_type = 'cosmetica'
WHERE tenant_id = @tid AND sede_id = 'sede-pm-2'
  AND (articulo LIKE '%NIÑA%' OR articulo LIKE '%NIÑO%' OR articulo LIKE '%NI_A%' OR articulo LIKE '%NI_O%');

-- SEDE 2 - sublineas (brand only)
UPDATE products SET brand = 'Splash'
WHERE tenant_id = @tid AND sede_id = 'sede-pm-2'
  AND articulo LIKE '%SPLASH%';

UPDATE products SET brand = 'Crema'
WHERE tenant_id = @tid AND sede_id = 'sede-pm-2' AND articulo LIKE 'CREMAS-%';

UPDATE products SET brand = 'Mantequilla'
WHERE tenant_id = @tid AND sede_id = 'sede-pm-2' AND articulo LIKE '%MANTEQUILLA%';

UPDATE products SET brand = 'Glitter'
WHERE tenant_id = @tid AND sede_id = 'sede-pm-2' AND articulo LIKE 'PURPURE-BRILLI%';

UPDATE products SET brand = 'Shimmer'
WHERE tenant_id = @tid AND sede_id = 'sede-pm-2' AND articulo LIKE 'PM-SHIMMER%';

UPDATE products SET category = 'PERFUMERIA', brand = 'Original', product_type = 'perfumes'
WHERE tenant_id = @tid AND sede_id = 'sede-pm-2'
  AND articulo LIKE 'ORI-%' AND articulo NOT LIKE 'ORI-VS%';

UPDATE products SET category = 'PERFUMERIA', brand = 'Replica', product_type = 'perfumes'
WHERE tenant_id = @tid AND sede_id = 'sede-pm-2'
  AND articulo LIKE 'REP-%'
  AND articulo NOT LIKE 'REP-AEROSOL%'
  AND articulo NOT LIKE 'REP-SPLASH%'
  AND articulo NOT LIKE 'REP-VS SPLASH%'
  AND articulo NOT LIKE 'REP-VS CREMA%'
  AND articulo NOT LIKE 'REP-KITS%';

-- SEDE 2 - PERFUMERIA: Aerosoles (perfumes en formato aerosol)
UPDATE products SET category = 'PERFUMERIA', brand = 'Aerosol', product_type = 'perfumes'
WHERE tenant_id = @tid AND sede_id = 'sede-pm-2' AND articulo LIKE 'REP-AEROSOL%';

-- SEDE 2 - PERFUMERIA: Kits réplica
UPDATE products SET category = 'PERFUMERIA', brand = 'Kit Replica', product_type = 'perfumes'
WHERE tenant_id = @tid AND sede_id = 'sede-pm-2' AND articulo LIKE 'REP-KITS%';

-- SEDE 2 - CORPORAL: VS Cremas (cremas corporales marca Victoria's Secret)
UPDATE products SET category = 'CORPORAL', brand = 'Crema', product_type = 'cosmetica'
WHERE tenant_id = @tid AND sede_id = 'sede-pm-2' AND articulo LIKE 'REP-VS CREMA%';

-- SEDE 2 - HOGAR: Aromatizantes, difusores y productos del hogar
UPDATE products SET category = 'HOGAR', product_type = 'hogar'
WHERE tenant_id = @tid AND sede_id = 'sede-pm-2'
  AND (articulo LIKE 'AROMATIZANTE%'
    OR articulo LIKE 'DIFUSOR%'
    OR articulo LIKE 'ESENCIA HS%'
    OR articulo LIKE 'ESENCIA PB%'
    OR articulo LIKE 'AGUA DE LINOS%'
    OR articulo LIKE 'PM CARRO%'
    OR articulo = 'PEBETERO');

-- SEDE 2 - INSUMOS: Frascos y envases
UPDATE products SET category = 'INSUMOS', product_type = 'insumos'
WHERE tenant_id = @tid AND sede_id = 'sede-pm-2'
  AND (articulo LIKE 'FRASCO%'
    OR articulo LIKE 'CAJA%'
    OR articulo LIKE 'BOLSA%'
    OR articulo LIKE 'ENVASE%');
