USE stockpro_db;

-- ============================================================
-- UNIFICACION DE EXTRACTOS (EXT-) - AMBAS SEDES
-- Tenant: d46bec36-5259-4b5b-83c7-01f1e6ea5dcd
-- Productos en S1+S2: stock sumado, sede_id=NULL, S2 eliminado
-- Solo S1 o solo S2: sede_id=NULL (disponible en ambas sedes)
-- Match por campo articulo + sede_id + tenant_id
-- ============================================================

-- ============================================================
-- PARTE 1: Productos en AMBAS sedes (232 productos)
-- Stock = S1 + S2, registro S1 queda global, S2 se elimina
-- ============================================================

-- EXT-AFNAN-9 PM-MAS (S1=288, S2=374, Total=662)
UPDATE products SET stock = 662, sede_id = NULL WHERE articulo = 'EXT-AFNAN-9 PM-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-AFNAN-9 PM-MAS' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-AHLI-CORVUS-FEM (S1=192, S2=315, Total=507)
UPDATE products SET stock = 507, sede_id = NULL WHERE articulo = 'EXT-AHLI-CORVUS-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-AHLI-CORVUS-FEM' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-AHLI-KARPOS-UNI (S1=116, S2=134, Total=250)
UPDATE products SET stock = 250, sede_id = NULL WHERE articulo = 'EXT-AHLI-KARPOS-UNI' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-AHLI-KARPOS-UNI' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-AHLI-PEGASUS-UNI (S1=179, S2=206, Total=385)
UPDATE products SET stock = 385, sede_id = NULL WHERE articulo = 'EXT-AHLI-PEGASUS-UNI' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-AHLI-PEGASUS-UNI' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-AHLI-VEGA-UNI (S1=255, S2=218, Total=473)
UPDATE products SET stock = 473, sede_id = NULL WHERE articulo = 'EXT-AHLI-VEGA-UNI' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-AHLI-VEGA-UNI' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-AL HARAMAIN-AMBER OUD AQUA DUBAI-UNI (S1=184, S2=223, Total=407)
UPDATE products SET stock = 407, sede_id = NULL WHERE articulo = 'EXT-AL HARAMAIN-AMBER OUD AQUA DUBAI-UNI' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-AL HARAMAIN-AMBER OUD AQUA DUBAI-UNI' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-AL HARAMAIN-AMBER OUD GOLD EDITION-UNI (S1=136, S2=263, Total=399)
UPDATE products SET stock = 399, sede_id = NULL WHERE articulo = 'EXT-AL HARAMAIN-AMBER OUD GOLD EDITION-UNI' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-AL HARAMAIN-AMBER OUD GOLD EDITION-UNI' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-ANTONIO BANDERAS-BLUE SEDUCTION-MAS (S1=155, S2=137, Total=292)
UPDATE products SET stock = 292, sede_id = NULL WHERE articulo = 'EXT-ANTONIO BANDERAS-BLUE SEDUCTION-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-ANTONIO BANDERAS-BLUE SEDUCTION-MAS' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-ARIANA GRANDE-ANGEL KISS-FEM (S1=329, S2=337, Total=666)
UPDATE products SET stock = 666, sede_id = NULL WHERE articulo = 'EXT-ARIANA GRANDE-ANGEL KISS-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-ARIANA GRANDE-ANGEL KISS-FEM' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-ARIANA GRANDE-CLOUD PINK-FEM (S1=201, S2=365, Total=566)
UPDATE products SET stock = 566, sede_id = NULL WHERE articulo = 'EXT-ARIANA GRANDE-CLOUD PINK-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-ARIANA GRANDE-CLOUD PINK-FEM' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-ARIANA GRANDE-CLOUD-FEM (S1=335, S2=359, Total=694)
UPDATE products SET stock = 694, sede_id = NULL WHERE articulo = 'EXT-ARIANA GRANDE-CLOUD-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-ARIANA GRANDE-CLOUD-FEM' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-ARIANA GRANDE-SWEET LIKE CANDY-FEM (S1=132, S2=267, Total=399)
UPDATE products SET stock = 399, sede_id = NULL WHERE articulo = 'EXT-ARIANA GRANDE-SWEET LIKE CANDY-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-ARIANA GRANDE-SWEET LIKE CANDY-FEM' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-ARIANA GRANDE-THANK U NEXT-FEM (S1=178, S2=278, Total=456)
UPDATE products SET stock = 456, sede_id = NULL WHERE articulo = 'EXT-ARIANA GRANDE-THANK U NEXT-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-ARIANA GRANDE-THANK U NEXT-FEM' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-ARMAF-CLUB DE NUIT INTENSE-MAS (S1=120, S2=326, Total=446)
UPDATE products SET stock = 446, sede_id = NULL WHERE articulo = 'EXT-ARMAF-CLUB DE NUIT INTENSE-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-ARMAF-CLUB DE NUIT INTENSE-MAS' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-ARMAF-CLUB DE NUIT MALEKA-FEM (S1=239, S2=311, Total=550)
UPDATE products SET stock = 550, sede_id = NULL WHERE articulo = 'EXT-ARMAF-CLUB DE NUIT MALEKA-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-ARMAF-CLUB DE NUIT MALEKA-FEM' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-ARMAF-ISLAND BREEZE-FEM (S1=285, S2=230, Total=515)
UPDATE products SET stock = 515, sede_id = NULL WHERE articulo = 'EXT-ARMAF-ISLAND BREEZE-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-ARMAF-ISLAND BREEZE-FEM' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-ARMAF-ODYSSEY CHOCOLAT-UNI (S1=119, S2=182, Total=301)
UPDATE products SET stock = 301, sede_id = NULL WHERE articulo = 'EXT-ARMAF-ODYSSEY CHOCOLAT-UNI' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-ARMAF-ODYSSEY CHOCOLAT-UNI' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-ARMAF-ODYSSEY MANDARIN SKY-MAS (S1=415, S2=119, Total=534)
UPDATE products SET stock = 534, sede_id = NULL WHERE articulo = 'EXT-ARMAF-ODYSSEY MANDARIN SKY-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-ARMAF-ODYSSEY MANDARIN SKY-MAS' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-ARMAF-YUM YUM-FEM (S1=162, S2=224, Total=386)
UPDATE products SET stock = 386, sede_id = NULL WHERE articulo = 'EXT-ARMAF-YUM YUM-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-ARMAF-YUM YUM-FEM' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-AZZARO-AZZARO POUR HOMME-MAS (S1=116, S2=109, Total=225)
UPDATE products SET stock = 225, sede_id = NULL WHERE articulo = 'EXT-AZZARO-AZZARO POUR HOMME-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-AZZARO-AZZARO POUR HOMME-MAS' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-BBW-CRAZY FOR YOU-FEM (S1=176, S2=265, Total=441)
UPDATE products SET stock = 441, sede_id = NULL WHERE articulo = 'EXT-BBW-CRAZY FOR YOU-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-BBW-CRAZY FOR YOU-FEM' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-BHARARA-BHARARA BLEU-MAS (S1=154, S2=224, Total=378)
UPDATE products SET stock = 378, sede_id = NULL WHERE articulo = 'EXT-BHARARA-BHARARA BLEU-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-BHARARA-BHARARA BLEU-MAS' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-BHARARA-BHARARA KING-MAS (S1=233, S2=408, Total=641)
UPDATE products SET stock = 641, sede_id = NULL WHERE articulo = 'EXT-BHARARA-BHARARA KING-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-BHARARA-BHARARA KING-MAS' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-BHARARA-BHARARA NICHE-UNI (S1=262, S2=200, Total=462)
UPDATE products SET stock = 462, sede_id = NULL WHERE articulo = 'EXT-BHARARA-BHARARA NICHE-UNI' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-BHARARA-BHARARA NICHE-UNI' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-BOND N9-BLEECKER STREET-UNI (S1=144, S2=102, Total=246)
UPDATE products SET stock = 246, sede_id = NULL WHERE articulo = 'EXT-BOND N9-BLEECKER STREET-UNI' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-BOND N9-BLEECKER STREET-UNI' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-BORNTOSTANDOUT-DRUNK LOVERS-UNI (S1=250, S2=250, Total=500)
UPDATE products SET stock = 500, sede_id = NULL WHERE articulo = 'EXT-BORNTOSTANDOUT-DRUNK LOVERS-UNI' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-BORNTOSTANDOUT-DRUNK LOVERS-UNI' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-BRITNEY SPEARS-FANTASY-FEM (S1=218, S2=179, Total=397)
UPDATE products SET stock = 397, sede_id = NULL WHERE articulo = 'EXT-BRITNEY SPEARS-FANTASY-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-BRITNEY SPEARS-FANTASY-FEM' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-BRITNEY SPEARS-MIDNIGHT FANTASY-FEM (S1=75, S2=39, Total=114)
UPDATE products SET stock = 114, sede_id = NULL WHERE articulo = 'EXT-BRITNEY SPEARS-MIDNIGHT FANTASY-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-BRITNEY SPEARS-MIDNIGHT FANTASY-FEM' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-BURBERRY-BURBERRY HER-FEM (S1=156, S2=243, Total=399)
UPDATE products SET stock = 399, sede_id = NULL WHERE articulo = 'EXT-BURBERRY-BURBERRY HER-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-BURBERRY-BURBERRY HER-FEM' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-BURBERRY-BURBERRY-FEM (S1=147, S2=279, Total=426)
UPDATE products SET stock = 426, sede_id = NULL WHERE articulo = 'EXT-BURBERRY-BURBERRY-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-BURBERRY-BURBERRY-FEM' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-BVLGARI-AQVA MARINE-MAS (S1=235, S2=196, Total=431)
UPDATE products SET stock = 431, sede_id = NULL WHERE articulo = 'EXT-BVLGARI-AQVA MARINE-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-BVLGARI-AQVA MARINE-MAS' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-BVLGARI-BLV-FEM (S1=196, S2=136, Total=332)
UPDATE products SET stock = 332, sede_id = NULL WHERE articulo = 'EXT-BVLGARI-BLV-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-BVLGARI-BLV-FEM' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-BVLGARI-BVLGARI MAN IN BLACK-MAS (S1=161, S2=239, Total=400)
UPDATE products SET stock = 400, sede_id = NULL WHERE articulo = 'EXT-BVLGARI-BVLGARI MAN IN BLACK-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-BVLGARI-BVLGARI MAN IN BLACK-MAS' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-BVLGARI-OMNIA CORAL-FEM (S1=187, S2=158, Total=345)
UPDATE products SET stock = 345, sede_id = NULL WHERE articulo = 'EXT-BVLGARI-OMNIA CORAL-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-BVLGARI-OMNIA CORAL-FEM' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-BVLGARI-OMNIA CRYSTALLINE-FEM (S1=172, S2=273, Total=445)
UPDATE products SET stock = 445, sede_id = NULL WHERE articulo = 'EXT-BVLGARI-OMNIA CRYSTALLINE-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-BVLGARI-OMNIA CRYSTALLINE-FEM' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-BVLGARI-OMNIA PINK SAPPHIRE-FEM (S1=291, S2=196, Total=487)
UPDATE products SET stock = 487, sede_id = NULL WHERE articulo = 'EXT-BVLGARI-OMNIA PINK SAPPHIRE-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-BVLGARI-OMNIA PINK SAPPHIRE-FEM' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-CALVIN KLEIN-CK ONE-UNI (S1=274, S2=71, Total=345)
UPDATE products SET stock = 345, sede_id = NULL WHERE articulo = 'EXT-CALVIN KLEIN-CK ONE-UNI' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-CALVIN KLEIN-CK ONE-UNI' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-CALVIN KLEIN-CKIN2U-FEM (S1=159, S2=175, Total=334)
UPDATE products SET stock = 334, sede_id = NULL WHERE articulo = 'EXT-CALVIN KLEIN-CKIN2U-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-CALVIN KLEIN-CKIN2U-FEM' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-CAROLINA HERRERA-212 HEROES FOREVER-MAS (S1=332, S2=294, Total=626)
UPDATE products SET stock = 626, sede_id = NULL WHERE articulo = 'EXT-CAROLINA HERRERA-212 HEROES FOREVER-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-CAROLINA HERRERA-212 HEROES FOREVER-MAS' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-CAROLINA HERRERA-212 HEROES-FEM (S1=263, S2=262, Total=525)
UPDATE products SET stock = 525, sede_id = NULL WHERE articulo = 'EXT-CAROLINA HERRERA-212 HEROES-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-CAROLINA HERRERA-212 HEROES-FEM' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-CAROLINA HERRERA-212 SEXY-FEM (S1=170, S2=142, Total=312)
UPDATE products SET stock = 312, sede_id = NULL WHERE articulo = 'EXT-CAROLINA HERRERA-212 SEXY-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-CAROLINA HERRERA-212 SEXY-FEM' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-CAROLINA HERRERA-212 VIP BLACK RED-MAS (S1=230, S2=194, Total=424)
UPDATE products SET stock = 424, sede_id = NULL WHERE articulo = 'EXT-CAROLINA HERRERA-212 VIP BLACK RED-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-CAROLINA HERRERA-212 VIP BLACK RED-MAS' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-CAROLINA HERRERA-212 VIP BLACK-MAS (S1=195, S2=332, Total=527)
UPDATE products SET stock = 527, sede_id = NULL WHERE articulo = 'EXT-CAROLINA HERRERA-212 VIP BLACK-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-CAROLINA HERRERA-212 VIP BLACK-MAS' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-CAROLINA HERRERA-212 VIP PARTY FEVER-MAS (S1=363, S2=214, Total=577)
UPDATE products SET stock = 577, sede_id = NULL WHERE articulo = 'EXT-CAROLINA HERRERA-212 VIP PARTY FEVER-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-CAROLINA HERRERA-212 VIP PARTY FEVER-MAS' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-CAROLINA HERRERA-212 VIP ROSE RED-FEM (S1=255, S2=215, Total=470)
UPDATE products SET stock = 470, sede_id = NULL WHERE articulo = 'EXT-CAROLINA HERRERA-212 VIP ROSE RED-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-CAROLINA HERRERA-212 VIP ROSE RED-FEM' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-CAROLINA HERRERA-212 VIP ROSE-FEM (S1=167, S2=372, Total=539)
UPDATE products SET stock = 539, sede_id = NULL WHERE articulo = 'EXT-CAROLINA HERRERA-212 VIP ROSE-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-CAROLINA HERRERA-212 VIP ROSE-FEM' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-CAROLINA HERRERA-212 VIP-FEM (S1=246, S2=195, Total=441)
UPDATE products SET stock = 441, sede_id = NULL WHERE articulo = 'EXT-CAROLINA HERRERA-212 VIP-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-CAROLINA HERRERA-212 VIP-FEM' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-CAROLINA HERRERA-212 VIP-MAS (S1=268, S2=482, Total=750)
UPDATE products SET stock = 750, sede_id = NULL WHERE articulo = 'EXT-CAROLINA HERRERA-212 VIP-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-CAROLINA HERRERA-212 VIP-MAS' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-CAROLINA HERRERA-212-FEM (S1=207, S2=154, Total=361)
UPDATE products SET stock = 361, sede_id = NULL WHERE articulo = 'EXT-CAROLINA HERRERA-212-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-CAROLINA HERRERA-212-FEM' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-CAROLINA HERRERA-212-MAS (S1=234, S2=350, Total=584)
UPDATE products SET stock = 584, sede_id = NULL WHERE articulo = 'EXT-CAROLINA HERRERA-212-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-CAROLINA HERRERA-212-MAS' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-CAROLINA HERRERA-BAD BOY COBALT-MAS (S1=172, S2=230, Total=402)
UPDATE products SET stock = 402, sede_id = NULL WHERE articulo = 'EXT-CAROLINA HERRERA-BAD BOY COBALT-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-CAROLINA HERRERA-BAD BOY COBALT-MAS' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-CAROLINA HERRERA-BAD BOY-MAS (S1=190, S2=187, Total=377)
UPDATE products SET stock = 377, sede_id = NULL WHERE articulo = 'EXT-CAROLINA HERRERA-BAD BOY-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-CAROLINA HERRERA-BAD BOY-MAS' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-CAROLINA HERRERA-CAROLINA HERRERA-FEM (S1=127, S2=250, Total=377)
UPDATE products SET stock = 377, sede_id = NULL WHERE articulo = 'EXT-CAROLINA HERRERA-CAROLINA HERRERA-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-CAROLINA HERRERA-CAROLINA HERRERA-FEM' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-CAROLINA HERRERA-CH-FEM (S1=292, S2=254, Total=546)
UPDATE products SET stock = 546, sede_id = NULL WHERE articulo = 'EXT-CAROLINA HERRERA-CH-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-CAROLINA HERRERA-CH-FEM' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-CAROLINA HERRERA-CH-MAS (S1=384, S2=210, Total=594)
UPDATE products SET stock = 594, sede_id = NULL WHERE articulo = 'EXT-CAROLINA HERRERA-CH-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-CAROLINA HERRERA-CH-MAS' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-CAROLINA HERRERA-GOOD GIRL BLUSH-FEM (S1=295, S2=182, Total=477)
UPDATE products SET stock = 477, sede_id = NULL WHERE articulo = 'EXT-CAROLINA HERRERA-GOOD GIRL BLUSH-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-CAROLINA HERRERA-GOOD GIRL BLUSH-FEM' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-CAROLINA HERRERA-GOOD GIRL-FEM (S1=181, S2=221, Total=402)
UPDATE products SET stock = 402, sede_id = NULL WHERE articulo = 'EXT-CAROLINA HERRERA-GOOD GIRL-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-CAROLINA HERRERA-GOOD GIRL-FEM' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-CAROLINA HERRERA-LA BOMBA-FEM (S1=340, S2=241, Total=581)
UPDATE products SET stock = 581, sede_id = NULL WHERE articulo = 'EXT-CAROLINA HERRERA-LA BOMBA-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-CAROLINA HERRERA-LA BOMBA-FEM' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-CASAMORATI-BOUQUET IDEALE-FEM (S1=233, S2=263, Total=496)
UPDATE products SET stock = 496, sede_id = NULL WHERE articulo = 'EXT-CASAMORATI-BOUQUET IDEALE-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-CASAMORATI-BOUQUET IDEALE-FEM' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-CHANEL-ALLURE SPORT-MAS (S1=198, S2=170, Total=368)
UPDATE products SET stock = 368, sede_id = NULL WHERE articulo = 'EXT-CHANEL-ALLURE SPORT-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-CHANEL-ALLURE SPORT-MAS' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-CHANEL-BLEU DE CHANEL-MAS (S1=146, S2=164, Total=310)
UPDATE products SET stock = 310, sede_id = NULL WHERE articulo = 'EXT-CHANEL-BLEU DE CHANEL-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-CHANEL-BLEU DE CHANEL-MAS' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-CHANEL-CHANCE EAU TENDRE-FEM (S1=111, S2=73, Total=184)
UPDATE products SET stock = 184, sede_id = NULL WHERE articulo = 'EXT-CHANEL-CHANCE EAU TENDRE-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-CHANEL-CHANCE EAU TENDRE-FEM' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-CHANEL-CHANCE-FEM (S1=240, S2=150, Total=390)
UPDATE products SET stock = 390, sede_id = NULL WHERE articulo = 'EXT-CHANEL-CHANCE-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-CHANEL-CHANCE-FEM' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-CHANEL-COCO MADEMOISELLE-FEM (S1=180, S2=165, Total=345)
UPDATE products SET stock = 345, sede_id = NULL WHERE articulo = 'EXT-CHANEL-COCO MADEMOISELLE-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-CHANEL-COCO MADEMOISELLE-FEM' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-CHANEL-N5-FEM (S1=366, S2=239, Total=605)
UPDATE products SET stock = 605, sede_id = NULL WHERE articulo = 'EXT-CHANEL-N5-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-CHANEL-N5-FEM' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-CHRISTIAN DIOR-DIOR HOMME INTENSE-MAS (S1=190, S2=169, Total=359)
UPDATE products SET stock = 359, sede_id = NULL WHERE articulo = 'EXT-CHRISTIAN DIOR-DIOR HOMME INTENSE-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-CHRISTIAN DIOR-DIOR HOMME INTENSE-MAS' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-CHRISTIAN DIOR-FAHRENHEIT-MAS (S1=126, S2=132, Total=258)
UPDATE products SET stock = 258, sede_id = NULL WHERE articulo = 'EXT-CHRISTIAN DIOR-FAHRENHEIT-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-CHRISTIAN DIOR-FAHRENHEIT-MAS' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-CHRISTIAN DIOR-JADORE-FEM (S1=79, S2=149, Total=228)
UPDATE products SET stock = 228, sede_id = NULL WHERE articulo = 'EXT-CHRISTIAN DIOR-JADORE-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-CHRISTIAN DIOR-JADORE-FEM' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-CHRISTIAN DIOR-MISS DIOR BOUQUET-FEM (S1=333, S2=207, Total=540)
UPDATE products SET stock = 540, sede_id = NULL WHERE articulo = 'EXT-CHRISTIAN DIOR-MISS DIOR BOUQUET-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-CHRISTIAN DIOR-MISS DIOR BOUQUET-FEM' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-CHRISTIAN DIOR-SAUVAGE ELIXIR-MAS (S1=153, S2=208, Total=361)
UPDATE products SET stock = 361, sede_id = NULL WHERE articulo = 'EXT-CHRISTIAN DIOR-SAUVAGE ELIXIR-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-CHRISTIAN DIOR-SAUVAGE ELIXIR-MAS' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-CHRISTIAN DIOR-SAUVAGE-MAS (S1=245, S2=313, Total=558)
UPDATE products SET stock = 558, sede_id = NULL WHERE articulo = 'EXT-CHRISTIAN DIOR-SAUVAGE-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-CHRISTIAN DIOR-SAUVAGE-MAS' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-CREED-AVENTUS HER-FEM (S1=254, S2=225, Total=479)
UPDATE products SET stock = 479, sede_id = NULL WHERE articulo = 'EXT-CREED-AVENTUS HER-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-CREED-AVENTUS HER-FEM' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-CREED-AVENTUS-MAS (S1=222, S2=377, Total=599)
UPDATE products SET stock = 599, sede_id = NULL WHERE articulo = 'EXT-CREED-AVENTUS-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-CREED-AVENTUS-MAS' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-CREED-QUEEN OF SILK-FEM (S1=276, S2=351, Total=627)
UPDATE products SET stock = 627, sede_id = NULL WHERE articulo = 'EXT-CREED-QUEEN OF SILK-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-CREED-QUEEN OF SILK-FEM' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-CREED-SILVER MOUNTAIN WATER-MAS (S1=136, S2=225, Total=361)
UPDATE products SET stock = 361, sede_id = NULL WHERE articulo = 'EXT-CREED-SILVER MOUNTAIN WATER-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-CREED-SILVER MOUNTAIN WATER-MAS' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-CRISTIANO RONALDO-CR7 ORIGINIS-MAS (S1=234, S2=102, Total=336)
UPDATE products SET stock = 336, sede_id = NULL WHERE articulo = 'EXT-CRISTIANO RONALDO-CR7 ORIGINIS-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-CRISTIANO RONALDO-CR7 ORIGINIS-MAS' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-CRISTIANO RONALDO-LEGACY-MAS (S1=146, S2=157, Total=303)
UPDATE products SET stock = 303, sede_id = NULL WHERE articulo = 'EXT-CRISTIANO RONALDO-LEGACY-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-CRISTIANO RONALDO-LEGACY-MAS' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-DIESEL-BAD INTENSE-MAS (S1=72, S2=204, Total=276)
UPDATE products SET stock = 276, sede_id = NULL WHERE articulo = 'EXT-DIESEL-BAD INTENSE-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-DIESEL-BAD INTENSE-MAS' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-DIESEL-DIESEL PLUS PLUS-MAS (S1=159, S2=146, Total=305)
UPDATE products SET stock = 305, sede_id = NULL WHERE articulo = 'EXT-DIESEL-DIESEL PLUS PLUS-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-DIESEL-DIESEL PLUS PLUS-MAS' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-DOLCE Y GABBANA-K-MAS (S1=273, S2=306, Total=579)
UPDATE products SET stock = 579, sede_id = NULL WHERE articulo = 'EXT-DOLCE Y GABBANA-K-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-DOLCE Y GABBANA-K-MAS' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-DOLCE Y GABBANA-LIGHT BLUE-FEM (S1=245, S2=122, Total=367)
UPDATE products SET stock = 367, sede_id = NULL WHERE articulo = 'EXT-DOLCE Y GABBANA-LIGHT BLUE-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-DOLCE Y GABBANA-LIGHT BLUE-FEM' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-DUMONT PARIS-NITRO ELIXIR-MAS (S1=184, S2=111, Total=295)
UPDATE products SET stock = 295, sede_id = NULL WHERE articulo = 'EXT-DUMONT PARIS-NITRO ELIXIR-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-DUMONT PARIS-NITRO ELIXIR-MAS' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-DUMONT PARIS-NITRO RED-MAS (S1=156, S2=175, Total=331)
UPDATE products SET stock = 331, sede_id = NULL WHERE articulo = 'EXT-DUMONT PARIS-NITRO RED-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-DUMONT PARIS-NITRO RED-MAS' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-ESCADA-AGUA DE SOL-FEM (S1=246, S2=531, Total=777)
UPDATE products SET stock = 777, sede_id = NULL WHERE articulo = 'EXT-ESCADA-AGUA DE SOL-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-ESCADA-AGUA DE SOL-FEM' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-ESCADA-MIAMI BLOSSOM-FEM (S1=321, S2=361, Total=682)
UPDATE products SET stock = 682, sede_id = NULL WHERE articulo = 'EXT-ESCADA-MIAMI BLOSSOM-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-ESCADA-MIAMI BLOSSOM-FEM' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-ESCADA-SORBETTO ROSSO-FEM (S1=219, S2=258, Total=477)
UPDATE products SET stock = 477, sede_id = NULL WHERE articulo = 'EXT-ESCADA-SORBETTO ROSSO-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-ESCADA-SORBETTO ROSSO-FEM' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-ESCADA-TAJ SUNSET-FEM (S1=277, S2=321, Total=598)
UPDATE products SET stock = 598, sede_id = NULL WHERE articulo = 'EXT-ESCADA-TAJ SUNSET-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-ESCADA-TAJ SUNSET-FEM' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-ESIKA-DORSAY-MAS (S1=51, S2=204, Total=255)
UPDATE products SET stock = 255, sede_id = NULL WHERE articulo = 'EXT-ESIKA-DORSAY-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-ESIKA-DORSAY-MAS' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-FACONNABLE-FACONNABLE-MAS (S1=233, S2=211, Total=444)
UPDATE products SET stock = 444, sede_id = NULL WHERE articulo = 'EXT-FACONNABLE-FACONNABLE-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-FACONNABLE-FACONNABLE-MAS' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-GIARDINI DI TOSCANA-BIANCO LATTE-UNI (S1=255, S2=417, Total=672)
UPDATE products SET stock = 672, sede_id = NULL WHERE articulo = 'EXT-GIARDINI DI TOSCANA-BIANCO LATTE-UNI' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-GIARDINI DI TOSCANA-BIANCO LATTE-UNI' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-GILLES CANTUEL-ARSENAL-MAS (S1=201, S2=210, Total=411)
UPDATE products SET stock = 411, sede_id = NULL WHERE articulo = 'EXT-GILLES CANTUEL-ARSENAL-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-GILLES CANTUEL-ARSENAL-MAS' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-GIORGIO ARMANI-ACQUA DI GIO PROFONDO-MAS (S1=448, S2=268, Total=716)
UPDATE products SET stock = 716, sede_id = NULL WHERE articulo = 'EXT-GIORGIO ARMANI-ACQUA DI GIO PROFONDO-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-GIORGIO ARMANI-ACQUA DI GIO PROFONDO-MAS' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-GIORGIO ARMANI-ACQUA DI GIO-MAS (S1=229, S2=66, Total=295)
UPDATE products SET stock = 295, sede_id = NULL WHERE articulo = 'EXT-GIORGIO ARMANI-ACQUA DI GIO-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-GIORGIO ARMANI-ACQUA DI GIO-MAS' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-GIORGIO ARMANI-STRONGER WITH YOU-MAS (S1=338, S2=370, Total=708)
UPDATE products SET stock = 708, sede_id = NULL WHERE articulo = 'EXT-GIORGIO ARMANI-STRONGER WITH YOU-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-GIORGIO ARMANI-STRONGER WITH YOU-MAS' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-GIVENCHY-GIVENCHY BLUE-MAS (S1=395, S2=183, Total=578)
UPDATE products SET stock = 578, sede_id = NULL WHERE articulo = 'EXT-GIVENCHY-GIVENCHY BLUE-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-GIVENCHY-GIVENCHY BLUE-MAS' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-GIVENCHY-GIVENCHY-MAS (S1=240, S2=187, Total=427)
UPDATE products SET stock = 427, sede_id = NULL WHERE articulo = 'EXT-GIVENCHY-GIVENCHY-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-GIVENCHY-GIVENCHY-MAS' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-GUCCI-GUCCI GUILTY POUR HOMME-MAS (S1=188, S2=279, Total=467)
UPDATE products SET stock = 467, sede_id = NULL WHERE articulo = 'EXT-GUCCI-GUCCI GUILTY POUR HOMME-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-GUCCI-GUCCI GUILTY POUR HOMME-MAS' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-HUGO BOSS-BOSS BOTTLED NIGHT-MAS (S1=246, S2=171, Total=417)
UPDATE products SET stock = 417, sede_id = NULL WHERE articulo = 'EXT-HUGO BOSS-BOSS BOTTLED NIGHT-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-HUGO BOSS-BOSS BOTTLED NIGHT-MAS' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-HUGO BOSS-BOSS BOTTLED UNLIMITED-MAS (S1=290, S2=276, Total=566)
UPDATE products SET stock = 566, sede_id = NULL WHERE articulo = 'EXT-HUGO BOSS-BOSS BOTTLED UNLIMITED-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-HUGO BOSS-BOSS BOTTLED UNLIMITED-MAS' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-HUGO BOSS-HUGO BOSS-MAS (S1=120, S2=215, Total=335)
UPDATE products SET stock = 335, sede_id = NULL WHERE articulo = 'EXT-HUGO BOSS-HUGO BOSS-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-HUGO BOSS-HUGO BOSS-MAS' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-HUGO BOSS-HUGO RED-MAS (S1=412, S2=493, Total=905)
UPDATE products SET stock = 905, sede_id = NULL WHERE articulo = 'EXT-HUGO BOSS-HUGO RED-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-HUGO BOSS-HUGO RED-MAS' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-ILMIN-IL FEMME-UNI (S1=312, S2=200, Total=512)
UPDATE products SET stock = 512, sede_id = NULL WHERE articulo = 'EXT-ILMIN-IL FEMME-UNI' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-ILMIN-IL FEMME-UNI' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-ISSEY MIYAKE-ISSEY MIYAKE-FEM (S1=125, S2=339, Total=464)
UPDATE products SET stock = 464, sede_id = NULL WHERE articulo = 'EXT-ISSEY MIYAKE-ISSEY MIYAKE-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-ISSEY MIYAKE-ISSEY MIYAKE-FEM' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-ISSEY MIYAKE-ISSEY MIYAKE-MAS (S1=232, S2=149, Total=381)
UPDATE products SET stock = 381, sede_id = NULL WHERE articulo = 'EXT-ISSEY MIYAKE-ISSEY MIYAKE-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-ISSEY MIYAKE-ISSEY MIYAKE-MAS' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-JEAN PASCAL-JEAN PASCAL-MAS (S1=154, S2=255, Total=409)
UPDATE products SET stock = 409, sede_id = NULL WHERE articulo = 'EXT-JEAN PASCAL-JEAN PASCAL-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-JEAN PASCAL-JEAN PASCAL-MAS' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-JEAN PAUL GAULTIER-DIVINE-FEM (S1=181, S2=203, Total=384)
UPDATE products SET stock = 384, sede_id = NULL WHERE articulo = 'EXT-JEAN PAUL GAULTIER-DIVINE-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-JEAN PAUL GAULTIER-DIVINE-FEM' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-JEAN PAUL GAULTIER-JEAN PAUL GAULTIER LE MALE-MAS (S1=258, S2=154, Total=412)
UPDATE products SET stock = 412, sede_id = NULL WHERE articulo = 'EXT-JEAN PAUL GAULTIER-JEAN PAUL GAULTIER LE MALE-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-JEAN PAUL GAULTIER-JEAN PAUL GAULTIER LE MALE-MAS' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-JEAN PAUL GAULTIER-LE BEAU-MAS (S1=169, S2=153, Total=322)
UPDATE products SET stock = 322, sede_id = NULL WHERE articulo = 'EXT-JEAN PAUL GAULTIER-LE BEAU-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-JEAN PAUL GAULTIER-LE BEAU-MAS' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-JEAN PAUL GAULTIER-LE MALE ELIXIR-MAS (S1=191, S2=126, Total=317)
UPDATE products SET stock = 317, sede_id = NULL WHERE articulo = 'EXT-JEAN PAUL GAULTIER-LE MALE ELIXIR-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-JEAN PAUL GAULTIER-LE MALE ELIXIR-MAS' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-JEAN PAUL GAULTIER-SCANDAL-FEM (S1=283, S2=281, Total=564)
UPDATE products SET stock = 564, sede_id = NULL WHERE articulo = 'EXT-JEAN PAUL GAULTIER-SCANDAL-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-JEAN PAUL GAULTIER-SCANDAL-FEM' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-JEAN PAUL GAULTIER-SCANDAL-MAS (S1=169, S2=256, Total=425)
UPDATE products SET stock = 425, sede_id = NULL WHERE articulo = 'EXT-JEAN PAUL GAULTIER-SCANDAL-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-JEAN PAUL GAULTIER-SCANDAL-MAS' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-JEAN PAUL GAULTIER-ULTRA MALE-MAS (S1=269, S2=304, Total=573)
UPDATE products SET stock = 573, sede_id = NULL WHERE articulo = 'EXT-JEAN PAUL GAULTIER-ULTRA MALE-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-JEAN PAUL GAULTIER-ULTRA MALE-MAS' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-KAJAL-ALMAZ-UNI (S1=362, S2=214, Total=576)
UPDATE products SET stock = 576, sede_id = NULL WHERE articulo = 'EXT-KAJAL-ALMAZ-UNI' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-KAJAL-ALMAZ-UNI' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-KENZO-FLOWER BY KENZO-FEM (S1=144, S2=181, Total=325)
UPDATE products SET stock = 325, sede_id = NULL WHERE articulo = 'EXT-KENZO-FLOWER BY KENZO-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-KENZO-FLOWER BY KENZO-FEM' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-KIM KARDASHIAN-BFF-FEM (S1=246, S2=362, Total=608)
UPDATE products SET stock = 608, sede_id = NULL WHERE articulo = 'EXT-KIM KARDASHIAN-BFF-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-KIM KARDASHIAN-BFF-FEM' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-LACOSTE-LACOSTE BLANC-MAS (S1=255, S2=164, Total=419)
UPDATE products SET stock = 419, sede_id = NULL WHERE articulo = 'EXT-LACOSTE-LACOSTE BLANC-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-LACOSTE-LACOSTE BLANC-MAS' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-LACOSTE-LACOSTE ESSENTIAL-MAS (S1=250, S2=223, Total=473)
UPDATE products SET stock = 473, sede_id = NULL WHERE articulo = 'EXT-LACOSTE-LACOSTE ESSENTIAL-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-LACOSTE-LACOSTE ESSENTIAL-MAS' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-LACOSTE-LACOSTE NOIR-MAS (S1=237, S2=144, Total=381)
UPDATE products SET stock = 381, sede_id = NULL WHERE articulo = 'EXT-LACOSTE-LACOSTE NOIR-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-LACOSTE-LACOSTE NOIR-MAS' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-LACOSTE-LACOSTE RED-MAS (S1=387, S2=153, Total=540)
UPDATE products SET stock = 540, sede_id = NULL WHERE articulo = 'EXT-LACOSTE-LACOSTE RED-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-LACOSTE-LACOSTE RED-MAS' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-LACOSTE-LACOSTE WOMAN-FEM (S1=179, S2=259, Total=438)
UPDATE products SET stock = 438, sede_id = NULL WHERE articulo = 'EXT-LACOSTE-LACOSTE WOMAN-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-LACOSTE-LACOSTE WOMAN-FEM' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-LACOSTE-TOUCH OF PINK-FEM (S1=453, S2=258, Total=711)
UPDATE products SET stock = 711, sede_id = NULL WHERE articulo = 'EXT-LACOSTE-TOUCH OF PINK-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-LACOSTE-TOUCH OF PINK-FEM' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-LANCOME-LA VIDA ES BELLA FLORAL-FEM (S1=217, S2=159, Total=376)
UPDATE products SET stock = 376, sede_id = NULL WHERE articulo = 'EXT-LANCOME-LA VIDA ES BELLA FLORAL-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-LANCOME-LA VIDA ES BELLA FLORAL-FEM' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-LANCOME-LA VIDA ES BELLA-FEM (S1=386, S2=122, Total=508)
UPDATE products SET stock = 508, sede_id = NULL WHERE articulo = 'EXT-LANCOME-LA VIDA ES BELLA-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-LANCOME-LA VIDA ES BELLA-FEM' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-LATTAFA-AFEEF-UNI (S1=106, S2=370, Total=476)
UPDATE products SET stock = 476, sede_id = NULL WHERE articulo = 'EXT-LATTAFA-AFEEF-UNI' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-LATTAFA-AFEEF-UNI' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-LATTAFA-AL NOBLE AMEER-UNI (S1=229, S2=163, Total=392)
UPDATE products SET stock = 392, sede_id = NULL WHERE articulo = 'EXT-LATTAFA-AL NOBLE AMEER-UNI' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-LATTAFA-AL NOBLE AMEER-UNI' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-LATTAFA-AMETHYST-UNI (S1=177, S2=280, Total=457)
UPDATE products SET stock = 457, sede_id = NULL WHERE articulo = 'EXT-LATTAFA-AMETHYST-UNI' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-LATTAFA-AMETHYST-UNI' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-LATTAFA-ART OF UNIVERSE-UNI (S1=180, S2=243, Total=423)
UPDATE products SET stock = 423, sede_id = NULL WHERE articulo = 'EXT-LATTAFA-ART OF UNIVERSE-UNI' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-LATTAFA-ART OF UNIVERSE-UNI' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-LATTAFA-ASAD-MAS (S1=102, S2=210, Total=312)
UPDATE products SET stock = 312, sede_id = NULL WHERE articulo = 'EXT-LATTAFA-ASAD-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-LATTAFA-ASAD-MAS' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-LATTAFA-BERRY ON TOP-FEM (S1=250, S2=193, Total=443)
UPDATE products SET stock = 443, sede_id = NULL WHERE articulo = 'EXT-LATTAFA-BERRY ON TOP-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-LATTAFA-BERRY ON TOP-FEM' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-LATTAFA-ECLAIRE-FEM (S1=293, S2=258, Total=551)
UPDATE products SET stock = 551, sede_id = NULL WHERE articulo = 'EXT-LATTAFA-ECLAIRE-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-LATTAFA-ECLAIRE-FEM' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-LATTAFA-EMEER-UNI (S1=237, S2=137, Total=374)
UPDATE products SET stock = 374, sede_id = NULL WHERE articulo = 'EXT-LATTAFA-EMEER-UNI' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-LATTAFA-EMEER-UNI' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-LATTAFA-HAYA-FEM (S1=232, S2=439, Total=671)
UPDATE products SET stock = 671, sede_id = NULL WHERE articulo = 'EXT-LATTAFA-HAYA-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-LATTAFA-HAYA-FEM' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-LATTAFA-HONOR Y GLORY-UNI (S1=257, S2=237, Total=494)
UPDATE products SET stock = 494, sede_id = NULL WHERE articulo = 'EXT-LATTAFA-HONOR Y GLORY-UNI' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-LATTAFA-HONOR Y GLORY-UNI' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-LATTAFA-KHAMRAH DUKHAN-UNI (S1=189, S2=147, Total=336)
UPDATE products SET stock = 336, sede_id = NULL WHERE articulo = 'EXT-LATTAFA-KHAMRAH DUKHAN-UNI' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-LATTAFA-KHAMRAH DUKHAN-UNI' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-LATTAFA-KHAMRAH-UNI (S1=145, S2=212, Total=357)
UPDATE products SET stock = 357, sede_id = NULL WHERE articulo = 'EXT-LATTAFA-KHAMRAH-UNI' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-LATTAFA-KHAMRAH-UNI' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-LATTAFA-MALLOW MADNESS-FEM (S1=398, S2=282, Total=680)
UPDATE products SET stock = 680, sede_id = NULL WHERE articulo = 'EXT-LATTAFA-MALLOW MADNESS-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-LATTAFA-MALLOW MADNESS-FEM' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-LATTAFA-MAYAR-FEM (S1=372, S2=310, Total=682)
UPDATE products SET stock = 682, sede_id = NULL WHERE articulo = 'EXT-LATTAFA-MAYAR-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-LATTAFA-MAYAR-FEM' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-LATTAFA-NOBLE BLUSH-FEM (S1=238, S2=407, Total=645)
UPDATE products SET stock = 645, sede_id = NULL WHERE articulo = 'EXT-LATTAFA-NOBLE BLUSH-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-LATTAFA-NOBLE BLUSH-FEM' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-LATTAFA-OUD FOR GLORY-UNI (S1=313, S2=162, Total=475)
UPDATE products SET stock = 475, sede_id = NULL WHERE articulo = 'EXT-LATTAFA-OUD FOR GLORY-UNI' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-LATTAFA-OUD FOR GLORY-UNI' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-LATTAFA-QAED AL FURSAN-UNI (S1=358, S2=387, Total=745)
UPDATE products SET stock = 745, sede_id = NULL WHERE articulo = 'EXT-LATTAFA-QAED AL FURSAN-UNI' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-LATTAFA-QAED AL FURSAN-UNI' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-LATTAFA-RAMZ SILVER-UNI (S1=58, S2=145, Total=203)
UPDATE products SET stock = 203, sede_id = NULL WHERE articulo = 'EXT-LATTAFA-RAMZ SILVER-UNI' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-LATTAFA-RAMZ SILVER-UNI' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-LATTAFA-SHAHEEN GOLD-UNI (S1=98, S2=177, Total=275)
UPDATE products SET stock = 275, sede_id = NULL WHERE articulo = 'EXT-LATTAFA-SHAHEEN GOLD-UNI' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-LATTAFA-SHAHEEN GOLD-UNI' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-LATTAFA-SUBLIME-UNI (S1=208, S2=219, Total=427)
UPDATE products SET stock = 427, sede_id = NULL WHERE articulo = 'EXT-LATTAFA-SUBLIME-UNI' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-LATTAFA-SUBLIME-UNI' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-LATTAFA-TERIAQ INTENSE-UNI (S1=258, S2=150, Total=408)
UPDATE products SET stock = 408, sede_id = NULL WHERE articulo = 'EXT-LATTAFA-TERIAQ INTENSE-UNI' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-LATTAFA-TERIAQ INTENSE-UNI' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-LATTAFA-VAINILLA FREAK-FEM (S1=187, S2=157, Total=344)
UPDATE products SET stock = 344, sede_id = NULL WHERE articulo = 'EXT-LATTAFA-VAINILLA FREAK-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-LATTAFA-VAINILLA FREAK-FEM' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-LATTAFA-YARA CANDY-FEM (S1=102, S2=148, Total=250)
UPDATE products SET stock = 250, sede_id = NULL WHERE articulo = 'EXT-LATTAFA-YARA CANDY-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-LATTAFA-YARA CANDY-FEM' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-LATTAFA-YARA ELIXIR-FEM (S1=250, S2=237, Total=487)
UPDATE products SET stock = 487, sede_id = NULL WHERE articulo = 'EXT-LATTAFA-YARA ELIXIR-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-LATTAFA-YARA ELIXIR-FEM' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-LATTAFA-YARA-FEM (S1=298, S2=217, Total=515)
UPDATE products SET stock = 515, sede_id = NULL WHERE articulo = 'EXT-LATTAFA-YARA-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-LATTAFA-YARA-FEM' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-LE LABO-SANTAL 33-UNI (S1=84, S2=322, Total=406)
UPDATE products SET stock = 406, sede_id = NULL WHERE articulo = 'EXT-LE LABO-SANTAL 33-UNI' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-LE LABO-SANTAL 33-UNI' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-LOEWE-SOLO-MAS (S1=186, S2=425, Total=611)
UPDATE products SET stock = 611, sede_id = NULL WHERE articulo = 'EXT-LOEWE-SOLO-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-LOEWE-SOLO-MAS' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-LOLITA LEMPICKA-LOLITA LEMPICKA-FEM (S1=77, S2=158, Total=235)
UPDATE products SET stock = 235, sede_id = NULL WHERE articulo = 'EXT-LOLITA LEMPICKA-LOLITA LEMPICKA-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-LOLITA LEMPICKA-LOLITA LEMPICKA-FEM' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-LORENZO PAZZAGLIA-SUMMER HAMMER-UNI (S1=285, S2=203, Total=488)
UPDATE products SET stock = 488, sede_id = NULL WHERE articulo = 'EXT-LORENZO PAZZAGLIA-SUMMER HAMMER-UNI' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-LORENZO PAZZAGLIA-SUMMER HAMMER-UNI' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-LORENZO PAZZAGLIA-SUN GRIA-UNI (S1=194, S2=177, Total=371)
UPDATE products SET stock = 371, sede_id = NULL WHERE articulo = 'EXT-LORENZO PAZZAGLIA-SUN GRIA-UNI' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-LORENZO PAZZAGLIA-SUN GRIA-UNI' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-LOUIS VOUITTON-L IMMENSITE-MAS (S1=237, S2=211, Total=448)
UPDATE products SET stock = 448, sede_id = NULL WHERE articulo = 'EXT-LOUIS VOUITTON-L IMMENSITE-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-LOUIS VOUITTON-L IMMENSITE-MAS' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-LOUIS VOUITTON-OMBRE NOMADE-MAS (S1=155, S2=128, Total=283)
UPDATE products SET stock = 283, sede_id = NULL WHERE articulo = 'EXT-LOUIS VOUITTON-OMBRE NOMADE-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-LOUIS VOUITTON-OMBRE NOMADE-MAS' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-MAISON CRIVELLI-OUD MARACUJA-UNI (S1=213, S2=96, Total=309)
UPDATE products SET stock = 309, sede_id = NULL WHERE articulo = 'EXT-MAISON CRIVELLI-OUD MARACUJA-UNI' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-MAISON CRIVELLI-OUD MARACUJA-UNI' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-MAISON FRANCIS KURKDJIAN-BACCARAT ROUGE 540-UNI (S1=176, S2=209, Total=385)
UPDATE products SET stock = 385, sede_id = NULL WHERE articulo = 'EXT-MAISON FRANCIS KURKDJIAN-BACCARAT ROUGE 540-UNI' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-MAISON FRANCIS KURKDJIAN-BACCARAT ROUGE 540-UNI' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-MANCERA-RED TOBACCO-UNI (S1=185, S2=179, Total=364)
UPDATE products SET stock = 364, sede_id = NULL WHERE articulo = 'EXT-MANCERA-RED TOBACCO-UNI' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-MANCERA-RED TOBACCO-UNI' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-MARC JACOBS-DAISY LOVE-FEM (S1=208, S2=259, Total=467)
UPDATE products SET stock = 467, sede_id = NULL WHERE articulo = 'EXT-MARC JACOBS-DAISY LOVE-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-MARC JACOBS-DAISY LOVE-FEM' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-MONTALE-ARABIANS TONKA-UNI (S1=133, S2=174, Total=307)
UPDATE products SET stock = 307, sede_id = NULL WHERE articulo = 'EXT-MONTALE-ARABIANS TONKA-UNI' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-MONTALE-ARABIANS TONKA-UNI' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-MONTALE-NEPAL AOUD-FEM (S1=233, S2=209, Total=442)
UPDATE products SET stock = 442, sede_id = NULL WHERE articulo = 'EXT-MONTALE-NEPAL AOUD-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-MONTALE-NEPAL AOUD-FEM' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-MONTBLANC-STARWALKER-MAS (S1=222, S2=338, Total=560)
UPDATE products SET stock = 560, sede_id = NULL WHERE articulo = 'EXT-MONTBLANC-STARWALKER-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-MONTBLANC-STARWALKER-MAS' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-MOSCHINO-MOSCHINO FOREVER-MAS (S1=372, S2=209, Total=581)
UPDATE products SET stock = 581, sede_id = NULL WHERE articulo = 'EXT-MOSCHINO-MOSCHINO FOREVER-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-MOSCHINO-MOSCHINO FOREVER-MAS' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-MOSCHINO-TOY 2 BUBBLE GUM-FEM (S1=289, S2=156, Total=445)
UPDATE products SET stock = 445, sede_id = NULL WHERE articulo = 'EXT-MOSCHINO-TOY 2 BUBBLE GUM-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-MOSCHINO-TOY 2 BUBBLE GUM-FEM' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-MOSCHINO-TOY 2 PEARL-UNI (S1=309, S2=165, Total=474)
UPDATE products SET stock = 474, sede_id = NULL WHERE articulo = 'EXT-MOSCHINO-TOY 2 PEARL-UNI' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-MOSCHINO-TOY 2 PEARL-UNI' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-MOSCHINO-TOY 2-FEM (S1=86, S2=84, Total=170)
UPDATE products SET stock = 170, sede_id = NULL WHERE articulo = 'EXT-MOSCHINO-TOY 2-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-MOSCHINO-TOY 2-FEM' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-MOSCHINO-TOY BOY-MAS (S1=267, S2=171, Total=438)
UPDATE products SET stock = 438, sede_id = NULL WHERE articulo = 'EXT-MOSCHINO-TOY BOY-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-MOSCHINO-TOY BOY-MAS' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-NAUTICA-NAUTICA VOYAGE-MAS (S1=232, S2=237, Total=469)
UPDATE products SET stock = 469, sede_id = NULL WHERE articulo = 'EXT-NAUTICA-NAUTICA VOYAGE-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-NAUTICA-NAUTICA VOYAGE-MAS' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-ORIENTICA-AMBER ROUGE-UNI (S1=130, S2=296, Total=426)
UPDATE products SET stock = 426, sede_id = NULL WHERE articulo = 'EXT-ORIENTICA-AMBER ROUGE-UNI' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-ORIENTICA-AMBER ROUGE-UNI' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-ORIENTICA-VELVET GOLD-FEM (S1=140, S2=253, Total=393)
UPDATE products SET stock = 393, sede_id = NULL WHERE articulo = 'EXT-ORIENTICA-VELVET GOLD-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-ORIENTICA-VELVET GOLD-FEM' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-OSCAR DE LA RENTA-OSCAR DE LA RENTA-MAS (S1=185, S2=117, Total=302)
UPDATE products SET stock = 302, sede_id = NULL WHERE articulo = 'EXT-OSCAR DE LA RENTA-OSCAR DE LA RENTA-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-OSCAR DE LA RENTA-OSCAR DE LA RENTA-MAS' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-PACO RABANNE-1 MILLION ELIXIR-MAS (S1=241, S2=359, Total=600)
UPDATE products SET stock = 600, sede_id = NULL WHERE articulo = 'EXT-PACO RABANNE-1 MILLION ELIXIR-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-PACO RABANNE-1 MILLION ELIXIR-MAS' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-PACO RABANNE-1 MILLION INTENSE-MAS (S1=68, S2=166, Total=234)
UPDATE products SET stock = 234, sede_id = NULL WHERE articulo = 'EXT-PACO RABANNE-1 MILLION INTENSE-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-PACO RABANNE-1 MILLION INTENSE-MAS' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-PACO RABANNE-1 MILLION LUCKY-MAS (S1=159, S2=247, Total=406)
UPDATE products SET stock = 406, sede_id = NULL WHERE articulo = 'EXT-PACO RABANNE-1 MILLION LUCKY-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-PACO RABANNE-1 MILLION LUCKY-MAS' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-PACO RABANNE-1 MILLION PRIVE-MAS (S1=272, S2=142, Total=414)
UPDATE products SET stock = 414, sede_id = NULL WHERE articulo = 'EXT-PACO RABANNE-1 MILLION PRIVE-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-PACO RABANNE-1 MILLION PRIVE-MAS' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-PACO RABANNE-1 MILLION ROYAL-MAS (S1=285, S2=348, Total=633)
UPDATE products SET stock = 633, sede_id = NULL WHERE articulo = 'EXT-PACO RABANNE-1 MILLION ROYAL-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-PACO RABANNE-1 MILLION ROYAL-MAS' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-PACO RABANNE-1 MILLION-MAS (S1=421, S2=382, Total=803)
UPDATE products SET stock = 803, sede_id = NULL WHERE articulo = 'EXT-PACO RABANNE-1 MILLION-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-PACO RABANNE-1 MILLION-MAS' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-PACO RABANNE-BLACK XS AFRODISIACA-MAS (S1=216, S2=304, Total=520)
UPDATE products SET stock = 520, sede_id = NULL WHERE articulo = 'EXT-PACO RABANNE-BLACK XS AFRODISIACA-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-PACO RABANNE-BLACK XS AFRODISIACA-MAS' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-PACO RABANNE-BLACK XS-MAS (S1=126, S2=266, Total=392)
UPDATE products SET stock = 392, sede_id = NULL WHERE articulo = 'EXT-PACO RABANNE-BLACK XS-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-PACO RABANNE-BLACK XS-MAS' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-PACO RABANNE-FAME-FEM (S1=232, S2=150, Total=382)
UPDATE products SET stock = 382, sede_id = NULL WHERE articulo = 'EXT-PACO RABANNE-FAME-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-PACO RABANNE-FAME-FEM' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-PACO RABANNE-INVICTUS INTENSE-MAS (S1=600, S2=236, Total=836)
UPDATE products SET stock = 836, sede_id = NULL WHERE articulo = 'EXT-PACO RABANNE-INVICTUS INTENSE-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-PACO RABANNE-INVICTUS INTENSE-MAS' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-PACO RABANNE-INVICTUS LEGEND-MAS (S1=215, S2=106, Total=321)
UPDATE products SET stock = 321, sede_id = NULL WHERE articulo = 'EXT-PACO RABANNE-INVICTUS LEGEND-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-PACO RABANNE-INVICTUS LEGEND-MAS' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-PACO RABANNE-INVICTUS VICTORY ELIXIR-MAS (S1=343, S2=49, Total=392)
UPDATE products SET stock = 392, sede_id = NULL WHERE articulo = 'EXT-PACO RABANNE-INVICTUS VICTORY ELIXIR-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-PACO RABANNE-INVICTUS VICTORY ELIXIR-MAS' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-PACO RABANNE-INVICTUS VICTORY-MAS (S1=102, S2=158, Total=260)
UPDATE products SET stock = 260, sede_id = NULL WHERE articulo = 'EXT-PACO RABANNE-INVICTUS VICTORY-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-PACO RABANNE-INVICTUS VICTORY-MAS' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-PACO RABANNE-INVICTUS-MAS (S1=260, S2=39, Total=299)
UPDATE products SET stock = 299, sede_id = NULL WHERE articulo = 'EXT-PACO RABANNE-INVICTUS-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-PACO RABANNE-INVICTUS-MAS' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-PACO RABANNE-LADY MILLION GOLD-FEM (S1=228, S2=273, Total=501)
UPDATE products SET stock = 501, sede_id = NULL WHERE articulo = 'EXT-PACO RABANNE-LADY MILLION GOLD-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-PACO RABANNE-LADY MILLION GOLD-FEM' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-PACO RABANNE-LADY MILLION-FEM (S1=200, S2=236, Total=436)
UPDATE products SET stock = 436, sede_id = NULL WHERE articulo = 'EXT-PACO RABANNE-LADY MILLION-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-PACO RABANNE-LADY MILLION-FEM' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-PACO RABANNE-OLYMPEA-FEM (S1=67, S2=145, Total=212)
UPDATE products SET stock = 212, sede_id = NULL WHERE articulo = 'EXT-PACO RABANNE-OLYMPEA-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-PACO RABANNE-OLYMPEA-FEM' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-PACO RABANNE-PHANTOM INTENSE-MAS (S1=217, S2=192, Total=409)
UPDATE products SET stock = 409, sede_id = NULL WHERE articulo = 'EXT-PACO RABANNE-PHANTOM INTENSE-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-PACO RABANNE-PHANTOM INTENSE-MAS' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-PACO RABANNE-PURE XS-FEM (S1=196, S2=276, Total=472)
UPDATE products SET stock = 472, sede_id = NULL WHERE articulo = 'EXT-PACO RABANNE-PURE XS-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-PACO RABANNE-PURE XS-FEM' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-PACO RABANNE-PURE XS-MAS (S1=93, S2=181, Total=274)
UPDATE products SET stock = 274, sede_id = NULL WHERE articulo = 'EXT-PACO RABANNE-PURE XS-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-PACO RABANNE-PURE XS-MAS' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-PARFUMS DE MARLY-ALTHAIR-MAS (S1=182, S2=287, Total=469)
UPDATE products SET stock = 469, sede_id = NULL WHERE articulo = 'EXT-PARFUMS DE MARLY-ALTHAIR-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-PARFUMS DE MARLY-ALTHAIR-MAS' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-PARFUMS DE MARLY-DELINA-FEM (S1=201, S2=126, Total=327)
UPDATE products SET stock = 327, sede_id = NULL WHERE articulo = 'EXT-PARFUMS DE MARLY-DELINA-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-PARFUMS DE MARLY-DELINA-FEM' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-PARFUMS DE MARLY-KALAN-UNI (S1=323, S2=163, Total=486)
UPDATE products SET stock = 486, sede_id = NULL WHERE articulo = 'EXT-PARFUMS DE MARLY-KALAN-UNI' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-PARFUMS DE MARLY-KALAN-UNI' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-PARFUMS DE MARLY-LAYTON-UNI (S1=384, S2=274, Total=658)
UPDATE products SET stock = 658, sede_id = NULL WHERE articulo = 'EXT-PARFUMS DE MARLY-LAYTON-UNI' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-PARFUMS DE MARLY-LAYTON-UNI' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-PARIS HILTON-CAN CAN-FEM (S1=272, S2=257, Total=529)
UPDATE products SET stock = 529, sede_id = NULL WHERE articulo = 'EXT-PARIS HILTON-CAN CAN-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-PARIS HILTON-CAN CAN-FEM' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-PARIS HILTON-DAZZLE-FEM (S1=161, S2=114, Total=275)
UPDATE products SET stock = 275, sede_id = NULL WHERE articulo = 'EXT-PARIS HILTON-DAZZLE-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-PARIS HILTON-DAZZLE-FEM' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-PARIS HILTON-HEIRESS-FEM (S1=313, S2=252, Total=565)
UPDATE products SET stock = 565, sede_id = NULL WHERE articulo = 'EXT-PARIS HILTON-HEIRESS-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-PARIS HILTON-HEIRESS-FEM' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-PARIS HILTON-PARIS HILTON-FEM (S1=213, S2=291, Total=504)
UPDATE products SET stock = 504, sede_id = NULL WHERE articulo = 'EXT-PARIS HILTON-PARIS HILTON-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-PARIS HILTON-PARIS HILTON-FEM' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-PARIS HILTON-ROSE RUSH-FEM (S1=315, S2=154, Total=469)
UPDATE products SET stock = 469, sede_id = NULL WHERE articulo = 'EXT-PARIS HILTON-ROSE RUSH-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-PARIS HILTON-ROSE RUSH-FEM' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-PERRY ELLIS-360 PURPLE-FEM (S1=284, S2=276, Total=560)
UPDATE products SET stock = 560, sede_id = NULL WHERE articulo = 'EXT-PERRY ELLIS-360 PURPLE-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-PERRY ELLIS-360 PURPLE-FEM' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-PERRY ELLIS-360-FEM (S1=200, S2=225, Total=425)
UPDATE products SET stock = 425, sede_id = NULL WHERE articulo = 'EXT-PERRY ELLIS-360-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-PERRY ELLIS-360-FEM' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-PERRY ELLIS-360-MAS (S1=86, S2=178, Total=264)
UPDATE products SET stock = 264, sede_id = NULL WHERE articulo = 'EXT-PERRY ELLIS-360-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-PERRY ELLIS-360-MAS' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-PRADA-PARADOXE-FEM (S1=277, S2=333, Total=610)
UPDATE products SET stock = 610, sede_id = NULL WHERE articulo = 'EXT-PRADA-PARADOXE-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-PRADA-PARADOXE-FEM' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-RALPH LAUREN-POLO BLUE-MAS (S1=134, S2=226, Total=360)
UPDATE products SET stock = 360, sede_id = NULL WHERE articulo = 'EXT-RALPH LAUREN-POLO BLUE-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-RALPH LAUREN-POLO BLUE-MAS' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-RALPH LAUREN-POLO RED-MAS (S1=144, S2=265, Total=409)
UPDATE products SET stock = 409, sede_id = NULL WHERE articulo = 'EXT-RALPH LAUREN-POLO RED-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-RALPH LAUREN-POLO RED-MAS' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-RALPH LAUREN-RALPH-FEM (S1=173, S2=239, Total=412)
UPDATE products SET stock = 412, sede_id = NULL WHERE articulo = 'EXT-RALPH LAUREN-RALPH-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-RALPH LAUREN-RALPH-FEM' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-SABRINA CARPENTER-SWEET TOOTH-FEM (S1=228, S2=152, Total=380)
UPDATE products SET stock = 380, sede_id = NULL WHERE articulo = 'EXT-SABRINA CARPENTER-SWEET TOOTH-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-SABRINA CARPENTER-SWEET TOOTH-FEM' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-SELENA GOMEZ-SELENA GOMEZ-FEM (S1=137, S2=222, Total=359)
UPDATE products SET stock = 359, sede_id = NULL WHERE articulo = 'EXT-SELENA GOMEZ-SELENA GOMEZ-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-SELENA GOMEZ-SELENA GOMEZ-FEM' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-SHAKIRA-ELIXIR-FEM (S1=252, S2=207, Total=459)
UPDATE products SET stock = 459, sede_id = NULL WHERE articulo = 'EXT-SHAKIRA-ELIXIR-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-SHAKIRA-ELIXIR-FEM' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-SOFIA VERGARA-SOFIA-FEM (S1=273, S2=307, Total=580)
UPDATE products SET stock = 580, sede_id = NULL WHERE articulo = 'EXT-SOFIA VERGARA-SOFIA-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-SOFIA VERGARA-SOFIA-FEM' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-TED LAPIDUS-LAPIDUS POUR HOMME-MAS (S1=322, S2=230, Total=552)
UPDATE products SET stock = 552, sede_id = NULL WHERE articulo = 'EXT-TED LAPIDUS-LAPIDUS POUR HOMME-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-TED LAPIDUS-LAPIDUS POUR HOMME-MAS' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-THIERRY MUGLER-ANGEL-FEM (S1=127, S2=113, Total=240)
UPDATE products SET stock = 240, sede_id = NULL WHERE articulo = 'EXT-THIERRY MUGLER-ANGEL-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-THIERRY MUGLER-ANGEL-FEM' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-THIERRY MUGLER-ANGEL-MAS (S1=192, S2=93, Total=285)
UPDATE products SET stock = 285, sede_id = NULL WHERE articulo = 'EXT-THIERRY MUGLER-ANGEL-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-THIERRY MUGLER-ANGEL-MAS' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-TOMMY HILFIGER-TOMMY GIRL-FEM (S1=70, S2=169, Total=239)
UPDATE products SET stock = 239, sede_id = NULL WHERE articulo = 'EXT-TOMMY HILFIGER-TOMMY GIRL-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-TOMMY HILFIGER-TOMMY GIRL-FEM' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-TOMMY HILFIGER-TOMMY-MAS (S1=352, S2=257, Total=609)
UPDATE products SET stock = 609, sede_id = NULL WHERE articulo = 'EXT-TOMMY HILFIGER-TOMMY-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-TOMMY HILFIGER-TOMMY-MAS' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-VALENTINO-DONNA BORN ROMA EXTRADOSE-FEM (S1=292, S2=284, Total=576)
UPDATE products SET stock = 576, sede_id = NULL WHERE articulo = 'EXT-VALENTINO-DONNA BORN ROMA EXTRADOSE-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-VALENTINO-DONNA BORN ROMA EXTRADOSE-FEM' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-VALENTINO-UOMO BORN IN ROMA INTENSE-MAS (S1=160, S2=171, Total=331)
UPDATE products SET stock = 331, sede_id = NULL WHERE articulo = 'EXT-VALENTINO-UOMO BORN IN ROMA INTENSE-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-VALENTINO-UOMO BORN IN ROMA INTENSE-MAS' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-VERSACE-BRIGHT CRYSTAL-FEM (S1=129, S2=194, Total=323)
UPDATE products SET stock = 323, sede_id = NULL WHERE articulo = 'EXT-VERSACE-BRIGHT CRYSTAL-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-VERSACE-BRIGHT CRYSTAL-FEM' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-VERSACE-DYLAN PURPLE-FEM (S1=587, S2=426, Total=1013)
UPDATE products SET stock = 1013, sede_id = NULL WHERE articulo = 'EXT-VERSACE-DYLAN PURPLE-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-VERSACE-DYLAN PURPLE-FEM' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-VERSACE-DYLAN TURQUOISE-FEM (S1=199, S2=238, Total=437)
UPDATE products SET stock = 437, sede_id = NULL WHERE articulo = 'EXT-VERSACE-DYLAN TURQUOISE-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-VERSACE-DYLAN TURQUOISE-FEM' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-VERSACE-EROS ENERGY-MAS (S1=172, S2=150, Total=322)
UPDATE products SET stock = 322, sede_id = NULL WHERE articulo = 'EXT-VERSACE-EROS ENERGY-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-VERSACE-EROS ENERGY-MAS' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-VERSACE-EROS-MAS (S1=315, S2=291, Total=606)
UPDATE products SET stock = 606, sede_id = NULL WHERE articulo = 'EXT-VERSACE-EROS-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-VERSACE-EROS-MAS' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-VICTORIA SECRET-BOMBSHELL-FEM (S1=113, S2=199, Total=312)
UPDATE products SET stock = 312, sede_id = NULL WHERE articulo = 'EXT-VICTORIA SECRET-BOMBSHELL-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-VICTORIA SECRET-BOMBSHELL-FEM' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-VICTORIA SECRET-COCONUT PASSION-FEM (S1=134, S2=300, Total=434)
UPDATE products SET stock = 434, sede_id = NULL WHERE articulo = 'EXT-VICTORIA SECRET-COCONUT PASSION-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-VICTORIA SECRET-COCONUT PASSION-FEM' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-VICTORINOX-SWISS ARMY-MAS (S1=58, S2=49, Total=107)
UPDATE products SET stock = 107, sede_id = NULL WHERE articulo = 'EXT-VICTORINOX-SWISS ARMY-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-VICTORINOX-SWISS ARMY-MAS' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-XERJOFF-ERBA PURA-UNI (S1=187, S2=183, Total=370)
UPDATE products SET stock = 370, sede_id = NULL WHERE articulo = 'EXT-XERJOFF-ERBA PURA-UNI' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-XERJOFF-ERBA PURA-UNI' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-YANBAL-OHM-MAS (S1=135, S2=290, Total=425)
UPDATE products SET stock = 425, sede_id = NULL WHERE articulo = 'EXT-YANBAL-OHM-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-YANBAL-OHM-MAS' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-YANBAL-SOLO-MAS (S1=234, S2=213, Total=447)
UPDATE products SET stock = 447, sede_id = NULL WHERE articulo = 'EXT-YANBAL-SOLO-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-YANBAL-SOLO-MAS' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-YVES SAINT LAURENT-BABYCAT-FEM (S1=285, S2=260, Total=545)
UPDATE products SET stock = 545, sede_id = NULL WHERE articulo = 'EXT-YVES SAINT LAURENT-BABYCAT-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-YVES SAINT LAURENT-BABYCAT-FEM' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-YVES SAINT LAURENT-BLACK OPIUM-FEM (S1=67, S2=261, Total=328)
UPDATE products SET stock = 328, sede_id = NULL WHERE articulo = 'EXT-YVES SAINT LAURENT-BLACK OPIUM-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-YVES SAINT LAURENT-BLACK OPIUM-FEM' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-YVES SAINT LAURENT-Y-MAS (S1=278, S2=213, Total=491)
UPDATE products SET stock = 491, sede_id = NULL WHERE articulo = 'EXT-YVES SAINT LAURENT-Y-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' LIMIT 1;
DELETE FROM products WHERE articulo = 'EXT-YVES SAINT LAURENT-Y-MAS' AND sede_id IS NOT NULL AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- ============================================================
-- PARTE 2: Solo en S1 (122 productos) -> pasan a globales
-- ============================================================

-- EXT-ACQUA DI PARMA-BERGAMOTTO DI CALABRIA-UNI (S1=103)
UPDATE products SET stock = 103, sede_id = NULL WHERE articulo = 'EXT-ACQUA DI PARMA-BERGAMOTTO DI CALABRIA-UNI' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-AHLI-OVERDOSE-UNI (S1=70)
UPDATE products SET stock = 70, sede_id = NULL WHERE articulo = 'EXT-AHLI-OVERDOSE-UNI' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-AL HARAMAIN-AMBER OUD DUBAI NIGHT-UNI (S1=137)
UPDATE products SET stock = 137, sede_id = NULL WHERE articulo = 'EXT-AL HARAMAIN-AMBER OUD DUBAI NIGHT-UNI' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-AL HARAMAIN-AMBER OUD TOBACCO-UNI (S1=414)
UPDATE products SET stock = 414, sede_id = NULL WHERE articulo = 'EXT-AL HARAMAIN-AMBER OUD TOBACCO-UNI' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-AL HARAMAIN-LAVENTURE BLANCHE-FEM (S1=147)
UPDATE products SET stock = 147, sede_id = NULL WHERE articulo = 'EXT-AL HARAMAIN-LAVENTURE BLANCHE-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-AL HARAMAIN-MADINAH-UNI (S1=146)
UPDATE products SET stock = 146, sede_id = NULL WHERE articulo = 'EXT-AL HARAMAIN-MADINAH-UNI' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-ARIANA GRANDE-MOD BLUSH-FEM (S1=115)
UPDATE products SET stock = 115, sede_id = NULL WHERE articulo = 'EXT-ARIANA GRANDE-MOD BLUSH-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-ARMAF-CLUB DE NUIT SILLAGE-UNI (S1=26)
UPDATE products SET stock = 26, sede_id = NULL WHERE articulo = 'EXT-ARMAF-CLUB DE NUIT SILLAGE-UNI' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-AVON-K VIDA FEM-FEM (S1=135)
UPDATE products SET stock = 135, sede_id = NULL WHERE articulo = 'EXT-AVON-K VIDA FEM-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-CACHAREL-AMOR AMOR-FEM (S1=193)
UPDATE products SET stock = 193, sede_id = NULL WHERE articulo = 'EXT-CACHAREL-AMOR AMOR-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-CALVIN KLEIN-ESCAPE-FEM (S1=58)
UPDATE products SET stock = 58, sede_id = NULL WHERE articulo = 'EXT-CALVIN KLEIN-ESCAPE-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-CALVIN KLEIN-ETERNITY-MAS (S1=192)
UPDATE products SET stock = 192, sede_id = NULL WHERE articulo = 'EXT-CALVIN KLEIN-ETERNITY-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-CAROLINA HERRERA-212 SEXY-MAS (S1=35)
UPDATE products SET stock = 35, sede_id = NULL WHERE articulo = 'EXT-CAROLINA HERRERA-212 SEXY-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-CAROLINA HERRERA-212 VIP BLACK EXTRA-MAS (S1=345)
UPDATE products SET stock = 345, sede_id = NULL WHERE articulo = 'EXT-CAROLINA HERRERA-212 VIP BLACK EXTRA-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-CAROLINA HERRERA-212 VIP ROSE EXTRA-FEM (S1=339)
UPDATE products SET stock = 339, sede_id = NULL WHERE articulo = 'EXT-CAROLINA HERRERA-212 VIP ROSE EXTRA-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-CAROLINA HERRERA-212 VIP WILD PARTY-FEM (S1=201)
UPDATE products SET stock = 201, sede_id = NULL WHERE articulo = 'EXT-CAROLINA HERRERA-212 VIP WILD PARTY-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-CAROLINA HERRERA-212 VIP WINS-FEM (S1=215)
UPDATE products SET stock = 215, sede_id = NULL WHERE articulo = 'EXT-CAROLINA HERRERA-212 VIP WINS-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-CAROLINA HERRERA-212 VIP WINS-MAS (S1=327)
UPDATE products SET stock = 327, sede_id = NULL WHERE articulo = 'EXT-CAROLINA HERRERA-212 VIP WINS-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-CAROLINA HERRERA-CAROLINA HERRERA-MAS (S1=400)
UPDATE products SET stock = 400, sede_id = NULL WHERE articulo = 'EXT-CAROLINA HERRERA-CAROLINA HERRERA-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-CAROLINA HERRERA-CH BEAUTIES-FEM (S1=69)
UPDATE products SET stock = 69, sede_id = NULL WHERE articulo = 'EXT-CAROLINA HERRERA-CH BEAUTIES-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-CAROLINA HERRERA-CHIC FOR MEN-MAS (S1=74)
UPDATE products SET stock = 74, sede_id = NULL WHERE articulo = 'EXT-CAROLINA HERRERA-CHIC FOR MEN-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-CAROLINA HERRERA-VERY GLAM-FEM (S1=22)
UPDATE products SET stock = 22, sede_id = NULL WHERE articulo = 'EXT-CAROLINA HERRERA-VERY GLAM-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-CAROLINA HERRERA-VERY GOOD GIRL-FEM (S1=254)
UPDATE products SET stock = 254, sede_id = NULL WHERE articulo = 'EXT-CAROLINA HERRERA-VERY GOOD GIRL-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-CARTIER-EAU DE CARTIER-UNI (S1=92)
UPDATE products SET stock = 92, sede_id = NULL WHERE articulo = 'EXT-CARTIER-EAU DE CARTIER-UNI' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-CREED-CARMINA-FEM (S1=181)
UPDATE products SET stock = 181, sede_id = NULL WHERE articulo = 'EXT-CREED-CARMINA-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-CREED-GREEN IRISH TWEED-MAS (S1=100)
UPDATE products SET stock = 100, sede_id = NULL WHERE articulo = 'EXT-CREED-GREEN IRISH TWEED-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-DIESEL-FUEL FOR LIFE-MAS (S1=121)
UPDATE products SET stock = 121, sede_id = NULL WHERE articulo = 'EXT-DIESEL-FUEL FOR LIFE-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-DIESEL-ONLY THE BRAVE-MAS (S1=86)
UPDATE products SET stock = 86, sede_id = NULL WHERE articulo = 'EXT-DIESEL-ONLY THE BRAVE-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-DIESEL-SPIRIT OF THE BRAVE-MAS (S1=125)
UPDATE products SET stock = 125, sede_id = NULL WHERE articulo = 'EXT-DIESEL-SPIRIT OF THE BRAVE-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-DOLCE Y GABBANA-DEVOTION-FEM (S1=0)
UPDATE products SET stock = 0, sede_id = NULL WHERE articulo = 'EXT-DOLCE Y GABBANA-DEVOTION-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-DOLCE Y GABBANA-DOLCE Y GABBANA POUR HOMME-MAS (S1=108)
UPDATE products SET stock = 108, sede_id = NULL WHERE articulo = 'EXT-DOLCE Y GABBANA-DOLCE Y GABBANA POUR HOMME-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-DOLCE Y GABBANA-DOLCE Y GABBANA-FEM (S1=119)
UPDATE products SET stock = 119, sede_id = NULL WHERE articulo = 'EXT-DOLCE Y GABBANA-DOLCE Y GABBANA-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-DOLCE Y GABBANA-PINEAPPLE-FEM (S1=67)
UPDATE products SET stock = 67, sede_id = NULL WHERE articulo = 'EXT-DOLCE Y GABBANA-PINEAPPLE-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-ELIZABETH TAYLOR-DIAMANTES BLANCOS-FEM (S1=62)
UPDATE products SET stock = 62, sede_id = NULL WHERE articulo = 'EXT-ELIZABETH TAYLOR-DIAMANTES BLANCOS-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-ENRIQUE IGLESIAS-ADRENALINE-MAS (S1=72)
UPDATE products SET stock = 72, sede_id = NULL WHERE articulo = 'EXT-ENRIQUE IGLESIAS-ADRENALINE-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-ESCADA-BORN IN PARADISE-FEM (S1=304)
UPDATE products SET stock = 304, sede_id = NULL WHERE articulo = 'EXT-ESCADA-BORN IN PARADISE-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-ESCADA-CHERRY IN THE AIR-FEM (S1=86)
UPDATE products SET stock = 86, sede_id = NULL WHERE articulo = 'EXT-ESCADA-CHERRY IN THE AIR-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-ESCADA-FIESTA CARIOCA-FEM (S1=19)
UPDATE products SET stock = 19, sede_id = NULL WHERE articulo = 'EXT-ESCADA-FIESTA CARIOCA-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-ESCADA-MOON SPARKLE-FEM (S1=75)
UPDATE products SET stock = 75, sede_id = NULL WHERE articulo = 'EXT-ESCADA-MOON SPARKLE-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-ESIKA-WINNER SPORT-MAS (S1=316)
UPDATE products SET stock = 316, sede_id = NULL WHERE articulo = 'EXT-ESIKA-WINNER SPORT-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-FRED HAYMAN-273-FEM (S1=261)
UPDATE products SET stock = 261, sede_id = NULL WHERE articulo = 'EXT-FRED HAYMAN-273-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-GIORGIO ARMANI-ACQUA DI GIO ABSOLU-MAS (S1=352)
UPDATE products SET stock = 352, sede_id = NULL WHERE articulo = 'EXT-GIORGIO ARMANI-ACQUA DI GIO ABSOLU-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-GIVENCHY-INTERDIT-FEM (S1=226)
UPDATE products SET stock = 226, sede_id = NULL WHERE articulo = 'EXT-GIVENCHY-INTERDIT-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-GIVENCHY-ORGANZA-FEM (S1=264)
UPDATE products SET stock = 264, sede_id = NULL WHERE articulo = 'EXT-GIVENCHY-ORGANZA-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-GUESS-GUESS GIRL-FEM (S1=49)
UPDATE products SET stock = 49, sede_id = NULL WHERE articulo = 'EXT-GUESS-GUESS GIRL-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-HUGO BOSS-BOSS IN MOTION-MAS (S1=215)
UPDATE products SET stock = 215, sede_id = NULL WHERE articulo = 'EXT-HUGO BOSS-BOSS IN MOTION-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-HUGO BOSS-BOSS ORANGE-MAS (S1=331)
UPDATE products SET stock = 331, sede_id = NULL WHERE articulo = 'EXT-HUGO BOSS-BOSS ORANGE-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-HUGO BOSS-BOSS THE SCENT ABSOLUTE-MAS (S1=255)
UPDATE products SET stock = 255, sede_id = NULL WHERE articulo = 'EXT-HUGO BOSS-BOSS THE SCENT ABSOLUTE-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-HUGO BOSS-THE SCENT PURE ACCORD-MAS (S1=42)
UPDATE products SET stock = 42, sede_id = NULL WHERE articulo = 'EXT-HUGO BOSS-THE SCENT PURE ACCORD-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-HUGO BOSS-XX-FEM (S1=99)
UPDATE products SET stock = 99, sede_id = NULL WHERE articulo = 'EXT-HUGO BOSS-XX-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-ILMIN-IL EGO-UNI (S1=220)
UPDATE products SET stock = 220, sede_id = NULL WHERE articulo = 'EXT-ILMIN-IL EGO-UNI' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-ILMIN-IL KAKUNO-UNI (S1=167)
UPDATE products SET stock = 167, sede_id = NULL WHERE articulo = 'EXT-ILMIN-IL KAKUNO-UNI' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-INITIO-MUSK THERAPY-UNI (S1=125)
UPDATE products SET stock = 125, sede_id = NULL WHERE articulo = 'EXT-INITIO-MUSK THERAPY-UNI' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-JEAN PAUL GAULTIER-JEAN PAUL GAULTIER-FEM (S1=109)
UPDATE products SET stock = 109, sede_id = NULL WHERE articulo = 'EXT-JEAN PAUL GAULTIER-JEAN PAUL GAULTIER-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-JESUS DEL POZO-HALLOWEEN-MAS (S1=0)
UPDATE products SET stock = 0, sede_id = NULL WHERE articulo = 'EXT-JESUS DEL POZO-HALLOWEEN-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-KATY PERRY-MEOW-FEM (S1=173)
UPDATE products SET stock = 173, sede_id = NULL WHERE articulo = 'EXT-KATY PERRY-MEOW-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-KILLIAN-ROLLING IN LOVE-UNI (S1=50)
UPDATE products SET stock = 50, sede_id = NULL WHERE articulo = 'EXT-KILLIAN-ROLLING IN LOVE-UNI' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-LACOSTE-LACOSTE MAGNETIC-FEM (S1=98)
UPDATE products SET stock = 98, sede_id = NULL WHERE articulo = 'EXT-LACOSTE-LACOSTE MAGNETIC-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-LACOSTE-SPARKLING-FEM (S1=199)
UPDATE products SET stock = 199, sede_id = NULL WHERE articulo = 'EXT-LACOSTE-SPARKLING-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-LATTAFA-AMEER AL OUDH INTENSE-UNI (S1=0)
UPDATE products SET stock = 0, sede_id = NULL WHERE articulo = 'EXT-LATTAFA-AMEER AL OUDH INTENSE-UNI' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-LATTAFA-HER CONFESSION-FEM (S1=265)
UPDATE products SET stock = 265, sede_id = NULL WHERE articulo = 'EXT-LATTAFA-HER CONFESSION-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-LATTAFA-MAYAR CHERRY INTENSE-UNI (S1=263)
UPDATE products SET stock = 263, sede_id = NULL WHERE articulo = 'EXT-LATTAFA-MAYAR CHERRY INTENSE-UNI' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-LATTAFA-SEHR-UNI (S1=368)
UPDATE products SET stock = 368, sede_id = NULL WHERE articulo = 'EXT-LATTAFA-SEHR-UNI' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-LE LABO-MATCHA 26-UNI (S1=109)
UPDATE products SET stock = 109, sede_id = NULL WHERE articulo = 'EXT-LE LABO-MATCHA 26-UNI' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-LOEWE-LOEWE 7-MAS (S1=101)
UPDATE products SET stock = 101, sede_id = NULL WHERE articulo = 'EXT-LOEWE-LOEWE 7-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-LOUIS VOUITTON-ATTRAPE REVES-FEM (S1=194)
UPDATE products SET stock = 194, sede_id = NULL WHERE articulo = 'EXT-LOUIS VOUITTON-ATTRAPE REVES-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-MANCERA-INSTANT CRUSH-UNI (S1=233)
UPDATE products SET stock = 233, sede_id = NULL WHERE articulo = 'EXT-MANCERA-INSTANT CRUSH-UNI' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-MANCERA-JARDIN EXCLUSIF-UNI (S1=139)
UPDATE products SET stock = 139, sede_id = NULL WHERE articulo = 'EXT-MANCERA-JARDIN EXCLUSIF-UNI' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-MANCERA-SILVER BLUE-UNI (S1=24)
UPDATE products SET stock = 24, sede_id = NULL WHERE articulo = 'EXT-MANCERA-SILVER BLUE-UNI' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-MERCEDEZ BENZ-MERCEDEZ BENZ IN RED-FEM (S1=78)
UPDATE products SET stock = 78, sede_id = NULL WHERE articulo = 'EXT-MERCEDEZ BENZ-MERCEDEZ BENZ IN RED-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-MONTALE-INTENSE CAFE-UNI (S1=212)
UPDATE products SET stock = 212, sede_id = NULL WHERE articulo = 'EXT-MONTALE-INTENSE CAFE-UNI' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-MONTALE-STARRY NIGHT-UNI (S1=242)
UPDATE products SET stock = 242, sede_id = NULL WHERE articulo = 'EXT-MONTALE-STARRY NIGHT-UNI' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-MONTBLANC-EXPLORER-MAS (S1=321)
UPDATE products SET stock = 321, sede_id = NULL WHERE articulo = 'EXT-MONTBLANC-EXPLORER-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-MONTBLANC-LEGEND RED-MAS (S1=201)
UPDATE products SET stock = 201, sede_id = NULL WHERE articulo = 'EXT-MONTBLANC-LEGEND RED-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-MONTBLANC-LEGEND-MAS (S1=276)
UPDATE products SET stock = 276, sede_id = NULL WHERE articulo = 'EXT-MONTBLANC-LEGEND-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-MOSCHINO-FUNNY-FEM (S1=204)
UPDATE products SET stock = 204, sede_id = NULL WHERE articulo = 'EXT-MOSCHINO-FUNNY-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-NINNA RICCI-LES MONSTRES DE NINA RICCI LUNA-FEM (S1=418)
UPDATE products SET stock = 418, sede_id = NULL WHERE articulo = 'EXT-NINNA RICCI-LES MONSTRES DE NINA RICCI LUNA-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-NINOS-ARRURU-UNI (S1=22)
UPDATE products SET stock = 22, sede_id = NULL WHERE articulo = 'EXT-NINOS-ARRURU-UNI' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-NINOS-COOL BOY-MAS (S1=81)
UPDATE products SET stock = 81, sede_id = NULL WHERE articulo = 'EXT-NINOS-COOL BOY-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-NINOS-DOLLY GIRL-FEM (S1=75)
UPDATE products SET stock = 75, sede_id = NULL WHERE articulo = 'EXT-NINOS-DOLLY GIRL-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-NINOS-GALAXY-MAS (S1=92)
UPDATE products SET stock = 92, sede_id = NULL WHERE articulo = 'EXT-NINOS-GALAXY-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-NINOS-MIMITOS-MAS (S1=129)
UPDATE products SET stock = 129, sede_id = NULL WHERE articulo = 'EXT-NINOS-MIMITOS-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-NINOS-PRETTY IN PINK-FEM (S1=239)
UPDATE products SET stock = 239, sede_id = NULL WHERE articulo = 'EXT-NINOS-PRETTY IN PINK-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-NINOS-SWEET CREAM-FEM (S1=29)
UPDATE products SET stock = 29, sede_id = NULL WHERE articulo = 'EXT-NINOS-SWEET CREAM-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-ORIENTICA-AZURE FANTASY-UNI (S1=178)
UPDATE products SET stock = 178, sede_id = NULL WHERE articulo = 'EXT-ORIENTICA-AZURE FANTASY-UNI' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-ORIENTICA-OUD SAFFRON-UNI (S1=274)
UPDATE products SET stock = 274, sede_id = NULL WHERE articulo = 'EXT-ORIENTICA-OUD SAFFRON-UNI' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-PACO RABANNE-BLACK XS BE LEGEND-MAS (S1=263)
UPDATE products SET stock = 263, sede_id = NULL WHERE articulo = 'EXT-PACO RABANNE-BLACK XS BE LEGEND-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-PACO RABANNE-BLACK XS L EXCES-MAS (S1=180)
UPDATE products SET stock = 180, sede_id = NULL WHERE articulo = 'EXT-PACO RABANNE-BLACK XS L EXCES-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-PACO RABANNE-BLACK XS POTION-FEM (S1=225)
UPDATE products SET stock = 225, sede_id = NULL WHERE articulo = 'EXT-PACO RABANNE-BLACK XS POTION-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-PACO RABANNE-BLACK XS POTION-MAS (S1=29)
UPDATE products SET stock = 29, sede_id = NULL WHERE articulo = 'EXT-PACO RABANNE-BLACK XS POTION-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-PACO RABANNE-LADY MILLION LUCKY-FEM (S1=93)
UPDATE products SET stock = 93, sede_id = NULL WHERE articulo = 'EXT-PACO RABANNE-LADY MILLION LUCKY-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-PACO RABANNE-PHANTOM LEGION-MAS (S1=110)
UPDATE products SET stock = 110, sede_id = NULL WHERE articulo = 'EXT-PACO RABANNE-PHANTOM LEGION-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-PACO RABANNE-PHANTOM-MAS (S1=221)
UPDATE products SET stock = 221, sede_id = NULL WHERE articulo = 'EXT-PACO RABANNE-PHANTOM-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-PACO RABANNE-PURE XS NIGHT-MAS (S1=219)
UPDATE products SET stock = 219, sede_id = NULL WHERE articulo = 'EXT-PACO RABANNE-PURE XS NIGHT-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-PARFUMS DE MARLY-PEGASUS-UNI (S1=99)
UPDATE products SET stock = 99, sede_id = NULL WHERE articulo = 'EXT-PARFUMS DE MARLY-PEGASUS-UNI' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-PARFUMS DE MARLY-SEDLEY-UNI (S1=297)
UPDATE products SET stock = 297, sede_id = NULL WHERE articulo = 'EXT-PARFUMS DE MARLY-SEDLEY-UNI' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-PARIS HILTON-PARIS HILTON-MAS (S1=352)
UPDATE products SET stock = 352, sede_id = NULL WHERE articulo = 'EXT-PARIS HILTON-PARIS HILTON-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-PARIS HILTON-PASSPORT IN PARIS-FEM (S1=81)
UPDATE products SET stock = 81, sede_id = NULL WHERE articulo = 'EXT-PARIS HILTON-PASSPORT IN PARIS-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-PERRY ELLIS-360 CORAL-FEM (S1=80)
UPDATE products SET stock = 80, sede_id = NULL WHERE articulo = 'EXT-PERRY ELLIS-360 CORAL-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-PERRY ELLIS-360 RED-MAS (S1=187)
UPDATE products SET stock = 187, sede_id = NULL WHERE articulo = 'EXT-PERRY ELLIS-360 RED-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-RALPH LAUREN-RALPH CLUB-MAS (S1=264)
UPDATE products SET stock = 264, sede_id = NULL WHERE articulo = 'EXT-RALPH LAUREN-RALPH CLUB-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-REYANE TRADITION-INSURRECTION-MAS (S1=35)
UPDATE products SET stock = 35, sede_id = NULL WHERE articulo = 'EXT-REYANE TRADITION-INSURRECTION-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-RIHANNA-KISS-FEM (S1=335)
UPDATE products SET stock = 335, sede_id = NULL WHERE articulo = 'EXT-RIHANNA-KISS-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-ROGER GALLET-MARIA FARINA-MAS (S1=178)
UPDATE products SET stock = 178, sede_id = NULL WHERE articulo = 'EXT-ROGER GALLET-MARIA FARINA-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-SHAKIRA-ROCK-FEM (S1=350)
UPDATE products SET stock = 350, sede_id = NULL WHERE articulo = 'EXT-SHAKIRA-ROCK-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-SOL DE JANEIRO-CHEIROSA 68-FEM (S1=303)
UPDATE products SET stock = 303, sede_id = NULL WHERE articulo = 'EXT-SOL DE JANEIRO-CHEIROSA 68-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-THIERRY MUGLER-ANGEL NOVA-FEM (S1=102)
UPDATE products SET stock = 102, sede_id = NULL WHERE articulo = 'EXT-THIERRY MUGLER-ANGEL NOVA-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-TIZIANA TERENZI-KIRKE-UNI (S1=254)
UPDATE products SET stock = 254, sede_id = NULL WHERE articulo = 'EXT-TIZIANA TERENZI-KIRKE-UNI' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-VALENTINO-DONNA BORN IN ROMA-FEM (S1=147)
UPDATE products SET stock = 147, sede_id = NULL WHERE articulo = 'EXT-VALENTINO-DONNA BORN IN ROMA-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-VALENTINO-VALENTINO UOMO-MAS (S1=155)
UPDATE products SET stock = 155, sede_id = NULL WHERE articulo = 'EXT-VALENTINO-VALENTINO UOMO-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-VERSACE-EAU FRAICHE-MAS (S1=289)
UPDATE products SET stock = 289, sede_id = NULL WHERE articulo = 'EXT-VERSACE-EAU FRAICHE-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-VERSACE-EROS FLAME-MAS (S1=179)
UPDATE products SET stock = 179, sede_id = NULL WHERE articulo = 'EXT-VERSACE-EROS FLAME-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-VICTORIA SECRET-JUICED BERRY-FEM (S1=184)
UPDATE products SET stock = 184, sede_id = NULL WHERE articulo = 'EXT-VICTORIA SECRET-JUICED BERRY-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-VICTORIA SECRET-VAINILLA-FEM (S1=57)
UPDATE products SET stock = 57, sede_id = NULL WHERE articulo = 'EXT-VICTORIA SECRET-VAINILLA-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-YANBAL-CCORI ROSE-FEM (S1=101)
UPDATE products SET stock = 101, sede_id = NULL WHERE articulo = 'EXT-YANBAL-CCORI ROSE-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-YANBAL-CELOS-FEM (S1=205)
UPDATE products SET stock = 205, sede_id = NULL WHERE articulo = 'EXT-YANBAL-CELOS-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-YANBAL-CIELO-FEM (S1=59)
UPDATE products SET stock = 59, sede_id = NULL WHERE articulo = 'EXT-YANBAL-CIELO-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-YANBAL-GAIA-FEM (S1=348)
UPDATE products SET stock = 348, sede_id = NULL WHERE articulo = 'EXT-YANBAL-GAIA-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-YANBAL-OSADIA-FEM (S1=139)
UPDATE products SET stock = 139, sede_id = NULL WHERE articulo = 'EXT-YANBAL-OSADIA-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-YANBAL-OSADIA-MAS (S1=164)
UPDATE products SET stock = 164, sede_id = NULL WHERE articulo = 'EXT-YANBAL-OSADIA-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-YANBAL-TEMPTATION-FEM (S1=245)
UPDATE products SET stock = 245, sede_id = NULL WHERE articulo = 'EXT-YANBAL-TEMPTATION-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-YANBAL-TEMPTATION-MAS (S1=238)
UPDATE products SET stock = 238, sede_id = NULL WHERE articulo = 'EXT-YANBAL-TEMPTATION-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- ============================================================
-- PARTE 3: Solo en S2 (11 productos) -> pasan a globales
-- ============================================================

-- EXT-AFNAN-9 PM REBEL-UNI (S2=275)
UPDATE products SET stock = 275, sede_id = NULL WHERE articulo = 'EXT-AFNAN-9 PM REBEL-UNI' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-AL HARAMAIN AMBER OUD DUBAI NIGHT-MAS (S2=491)
UPDATE products SET stock = 491, sede_id = NULL WHERE articulo = 'EXT-AL HARAMAIN AMBER OUD DUBAI NIGHT-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-BHARARA-BHARARA CHOCOLATE-UNI (S2=274)
UPDATE products SET stock = 274, sede_id = NULL WHERE articulo = 'EXT-BHARARA-BHARARA CHOCOLATE-UNI' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-BHARARA-BHARARA ROSE-FEM (S2=242)
UPDATE products SET stock = 242, sede_id = NULL WHERE articulo = 'EXT-BHARARA-BHARARA ROSE-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-KAJAL-DAHAB-FEM (S2=339)
UPDATE products SET stock = 339, sede_id = NULL WHERE articulo = 'EXT-KAJAL-DAHAB-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-LATTAFA-VICTORIA-UNI (S2=87)
UPDATE products SET stock = 87, sede_id = NULL WHERE articulo = 'EXT-LATTAFA-VICTORIA-UNI' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-LOUIS VOUITTON-IMAGINATION-MAS (S2=216)
UPDATE products SET stock = 216, sede_id = NULL WHERE articulo = 'EXT-LOUIS VOUITTON-IMAGINATION-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-MONTALE-STARRY NIGHT-FEM (S2=248)
UPDATE products SET stock = 248, sede_id = NULL WHERE articulo = 'EXT-MONTALE-STARRY NIGHT-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-PACO RABANNE-INVICTUS VICTORY ABSOLU-MAS (S2=309)
UPDATE products SET stock = 309, sede_id = NULL WHERE articulo = 'EXT-PACO RABANNE-INVICTUS VICTORY ABSOLU-MAS' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-VALENTINO-DONNA CLASICA-FEM (S2=197)
UPDATE products SET stock = 197, sede_id = NULL WHERE articulo = 'EXT-VALENTINO-DONNA CLASICA-FEM' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';

-- EXT-XERJOFF-NAXOS-UNI (S2=249)
UPDATE products SET stock = 249, sede_id = NULL WHERE articulo = 'EXT-XERJOFF-NAXOS-UNI' AND tenant_id = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd';
