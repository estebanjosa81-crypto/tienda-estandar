#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# Genera recetasperfummua.sql con todos los 239 extractos
import sys
import io
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

extractos = [
    ("s1-208", "9 PM REBEL"),
    ("s1-213", "9 PM"),
    ("s1-002", "CORVUS"),
    ("s1-003", "KARPOS"),
    ("s1-001", "PEGASUS"),
    ("s1-004", "VEGA"),
    ("s1-006", "MAS"),
    ("s1-005", "AMBER OUD AQUA DUBAI"),
    ("s1-007", "AMBER OUD GOLD EDITION"),
    ("s1-008", "BLUE SEDUCTION"),
    ("2003",   "ANGEL KISS"),
    ("s1-009", "CLOUD PINK"),
    ("s1-010", "CLOUD"),
    ("s1-011", "SWEET LIKE CANDY"),
    ("s1-012", "THANK U NEXT"),
    ("s1-013", "CLUB DE NUIT INTENSE"),
    ("s1-233", "CLUB DE NUIT MALEKA"),
    ("s1-235", "ISLAND BREEZE"),
    ("s1-217", "ODYSSEY CHOCOLAT"),
    ("s1-205", "ODYSSEY MANDARIN SKY"),
    ("s1-211", "YUM YUM"),
    ("s1-014", "AZZARO POUR HOMME"),
    ("s1-015", "CRAZY FOR YOU"),
    ("s1-016", "BHARARA BLEU"),
    ("s1-210", "BHARARA CHOCOLATE"),
    ("s1-017", "BHARARA KING"),
    ("s1-238", "BHARARA NICHE"),
    ("s1-201", "BHARARA ROSE"),
    ("s1-018", "BLEECKER STREET"),
    ("s1-019", "FANTASY"),
    ("s1-020", "MIDNIGHT FANTASY"),
    ("s1-021", "BURBERRY HER"),
    ("s1-022", "BURBERRY"),
    ("s1-023", "AQVA MARINE"),
    ("s1-024", "BLV"),
    ("s1-025", "BVLGARI MAN IN BLACK"),
    ("s1-026", "OMNIA CORAL"),
    ("s1-027", "OMNIA CRYSTALLINE"),
    ("s1-028", "OMNIA PINK SAPPHIRE"),
    ("s1-029", "CK ONE"),
    ("s1-030", "CKIN2U"),
    ("s1-031", "212 HEROES FOREVER"),
    ("s1-032", "212 HEROES"),
    ("s1-033", "212 SEXY"),
    ("s1-034", "212 VIP BLACK RED"),
    ("s1-035", "212 VIP BLACK"),
    ("s1-036", "212 VIP PARTY FEVER"),
    ("s1-037", "212 VIP ROSE RED"),
    ("s1-038", "212 VIP ROSE"),
    ("s1-039", "212 VIP"),
    ("s1-040", "212 VIP"),
    ("s1-041", "212"),
    ("s1-042", "212"),
    ("s1-043", "BAD BOY COBALT"),
    ("s1-044", "BAD BOY"),
    ("s1-045", "CAROLINA HERRERA"),
    ("s1-046", "CH"),
    ("s1-047", "CH"),
    ("s1-048", "GOOD GIRL BLUSH"),
    ("s1-049", "GOOD GIRL"),
    ("s1-231", "LA BOMBA"),
    ("s1-050", "BOUQUET IDEALE"),
    ("s1-051", "ALLURE SPORT"),
    ("s1-052", "BLEU DE CHANEL"),
    ("s1-226", "CHANCE EAU TENDRE"),
    ("s1-053", "CHANCE"),
    ("s1-054", "COCO MADEMOISELLE"),
    ("s1-055", "N5"),
    ("s1-060", "DIOR HOMME INTENSE"),
    ("s1-056", "FAHRENHEIT"),
    ("s1-057", "JADORE"),
    ("s1-058", "MISS DIOR BOUQUET"),
    ("s1-059", "SAUVAGE ELIXIR"),
    ("s1-061", "SAUVAGE"),
    ("s1-062", "AVENTUS HER"),
    ("s1-063", "AVENTUS"),
    ("s1-220", "QUEEN OF SILK"),
    ("s1-064", "SILVER MOUNTAIN WATER"),
    ("s1-065", "CR7 ORIGINIS"),
    ("s1-066", "LEGACY"),
    ("s1-067", "BAD INTENSE"),
    ("s1-068", "DIESEL PLUS PLUS"),
    ("s1-069", "K"),
    ("s1-070", "LIGHT BLUE"),
    ("s1-230", "NITRO ELIXIR"),
    ("s1-234", "NITRO RED"),
    ("s1-071", "AGUA DE SOL"),
    ("s1-223", "MIAMI BLOSSOM"),
    ("s1-073", "SORBETTO ROSSO"),
    ("s1-074", "TAJ SUNSET"),
    ("s1-075", "DORSAY"),
    ("s1-076", "FACONNABLE"),
    ("s1-077", "BIANCO LATTE"),
    ("s1-078", "ARSENAL"),
    ("s1-079", "ACQUA DI GIO PROFONDO"),
    ("s1-080", "ACQUA DI GIO"),
    ("s1-081", "STRONGER WITH YOU"),
    ("s1-082", "GIVENCHY BLUE"),
    ("s1-083", "GIVENCHY"),
    ("s1-084", "GUCCI GUILTY POUR HOMME"),
    ("s1-085", "BOSS BOTTLED NIGHT"),
    ("s1-086", "BOSS BOTTLED UNLIMITED"),
    ("s1-087", "HUGO BOSS"),
    ("s1-088", "HUGO RED"),
    ("s1-239", "IL FEMME"),
    ("s1-089", "ISSEY MIYAKE"),
    ("s1-090", "ISSEY MIYAKE"),
    ("s1-091", "JEAN PASCAL"),
    ("s1-207", "DIVINE"),
    ("s1-092", "JEAN PAUL GAULTIER LE MALE"),
    ("s1-093", "LE BEAU"),
    ("s1-094", "LE MALE ELIXIR"),
    ("s1-095", "SCANDAL"),
    ("s1-096", "SCANDAL"),
    ("s1-097", "ULTRA MALE"),
    ("s1-098", "ALMAZ"),
    ("s1-204", "DAHAB"),
    ("s1-099", "FLOWER BY KENZO"),
    ("s1-100", "BFF"),
    ("s1-101", "LACOSTE BLANC"),
    ("s1-102", "LACOSTE ESSENTIAL"),
    ("s1-103", "LACOSTE NOIR"),
    ("s1-104", "LACOSTE RED"),
    ("s1-105", "LACOSTE WOMAN"),
    ("s1-106", "TOUCH OF PINK"),
    ("s1-107", "LA VIDA ES BELLA FLORAL"),
    ("s1-108", "LA VIDA ES BELLA"),
    ("s1-215", "AFEEF"),
    ("s1-110", "AL NOBLE AMEER"),
    ("s1-111", "AMETHYST"),
    ("s1-227", "ART OF UNIVERSE"),
    ("s1-112", "ASAD"),
    ("s1-237", "ECLAIRE"),
    ("s1-117", "EMEER"),
    ("s1-113", "HAYA"),
    ("s1-114", "HONOR Y GLORY"),
    ("s1-225", "KHAMRAH DUKHAN"),
    ("s1-115", "KHAMRAH"),
    ("s1-229", "MALLOW MADNESS"),
    ("s1-218", "MAYAR"),
    ("s1-109", "NOBLE BLUSH"),
    ("s1-116", "OUD FOR GLORY"),
    ("s1-118", "QAED AL FURSAN"),
    ("s1-119", "RAMZ SILVER"),
    ("s1-120", "SHAHEEN GOLD"),
    ("s1-121", "SUBLIME"),
    ("s1-232", "VAINILLA FREAK"),
    ("s1-206", "VICTORIA"),
    ("s1-122", "YARA CANDY"),
    ("s1-123", "YARA"),
    ("s1-124", "SANTAL 33"),
    ("s1-125", "SOLO"),
    ("s1-126", "LOLITA LEMPICKA"),
    ("s1-127", "SUMMER HAMMER"),
    ("s1-214", "SUN GRIA"),
    ("s1-209", "IMAGINATION"),
    ("s1-128", "L\u00b4IMMENSITE"),
    ("s1-221", "OMBRE NOMADE"),
    ("s1-129", "OUD MARACUJA"),
    ("s1-130", "BACCARAT ROUGE 540"),
    ("s1-212", "RED TOBACCO"),
    ("s1-131", "DAISY LOVE"),
    ("s1-132", "ARABIANS TONKA"),
    ("s1-133", "NEPAL AOUD"),
    ("s1-134", "STARRY NIGHT"),
    ("s1-135", "STARWALKER"),
    ("s1-136", "MOSCHINO FOREVER"),
    ("s1-137", "TOY 2 BUBBLE GUM"),
    ("s1-138", "TOY 2 PEARL"),
    ("s1-139", "TOY 2"),
    ("s1-140", "TOY BOY"),
    ("s1-141", "NAUTICA VOYAGE"),
    ("s1-142", "AMBER ROUGE"),
    ("s1-143", "VELVET GOLD"),
    ("s1-144", "OSCAR DE LA RENTA"),
    ("s1-145", "1 MILLION ELIXIR"),
    ("s1-146", "1 MILLION INTENSE"),
    ("s1-147", "1 MILLION LUCKY"),
    ("s1-148", "1 MILLION PRIVE"),
    ("s1-149", "1 MILLION ROYAL"),
    ("s1-150", "1 MILLION"),
    ("s1-151", "BLACK XS AFRODISIACA"),
    ("s1-152", "BLACK XS"),
    ("s1-153", "FAME"),
    ("s1-154", "INVICTUS INTENSE"),
    ("s1-155", "INVICTUS LEGEND"),
    ("s1-222", "INVICTUS VICTORY ABSOLU"),
    ("s1-156", "INVICTUS VICTORY ELIXIR"),
    ("s1-157", "INVICTUS VICTORY"),
    ("s1-158", "INVICTUS"),
    ("s1-159", "LADY MILLION GOLD"),
    ("s1-160", "LADY MILLION"),
    ("s1-161", "OLYMPEA"),
    ("s1-162", "PHANTOM INTENSE"),
    ("s1-163", "PURE XS"),
    ("s1-164", "PURE XS"),
    ("s1-236", "ALTHAIR"),
    ("s1-165", "DELINA"),
    ("s1-166", "KALAN"),
    ("s1-167", "LAYTON"),
    ("s1-168", "CAN CAN"),
    ("s1-169", "DAZZLE"),
    ("s1-170", "HEIRESS"),
    ("s1-171", "PARIS HILTON"),
    ("s1-172", "ROSE RUSH"),
    ("s1-173", "360 PURPLE"),
    ("s1-174", "360"),
    ("s1-175", "360"),
    ("s1-228", "PARADOXE"),
    ("s1-176", "POLO BLUE"),
    ("s1-177", "POLO RED"),
    ("s1-178", "RALPH"),
    ("s1-219", "SWEET TOOTH"),
    ("s1-179", "SELENA GOMEZ"),
    ("s1-180", "ELIXIR"),
    ("s1-181", "SOFIA"),
    ("s1-182", "LAPIDUS POUR HOMME"),
    ("s1-183", "ANGEL"),
    ("s1-184", "ANGEL"),
    ("s1-185", "TOMMY GIRL"),
    ("s1-186", "TOMMY"),
    ("s1-216", "DONNA BORN ROMA EXTRADOSE"),
    ("s1-224", "DONNA CLASICA"),
    ("s1-187", "UOMO BORN IN ROMA INTENSE"),
    ("s1-188", "BRIGHT CRYSTAL"),
    ("s1-189", "DYLAN PURPLE"),
    ("s1-190", "DYLAN TURQUOISE"),
    ("s1-203", "EROS ENERGY"),
    ("s1-191", "EROS"),
    ("s1-192", "BOMBSHELL"),
    ("s1-193", "COCONUT PASSION"),
    ("s1-194", "SWISS ARMY"),
    ("s1-195", "ERBA PURA"),
    ("s1-202", "NAXOS"),
    ("s1-196", "OHM"),
    ("s1-197", "SOLO"),
    ("s1-198", "BABYCAT"),
    ("s1-199", "BLACK OPIUM"),
    ("s1-200", "Y"),
]

assert len(extractos) == 239, f"Se esperaban 239 extractos, se encontraron {len(extractos)}"

lines = []
lines.append("-- ============================================================")
lines.append("-- RECETAS COMPLETAS: Perfumes terminados BOM (Bill of Materials)")
lines.append("-- Tenant: d46bec36-5259-4b5b-83c7-01f1e6ea5dcd (Perfum Mua)")
lines.append(f"-- {len(extractos)} extractos x 3 presentaciones = {len(extractos)*3} productos terminados")
lines.append(f"-- {len(extractos)*3*3} registros de recetas (3 ingredientes x 3 tamanos)")
lines.append("-- Ejecutar: mysql -u root -p stockpro_db < recetasperfummua.sql")
lines.append("-- NOTA: Requiere que inventario_perfummua.sql ya haya sido ejecutado")
lines.append("-- ============================================================")
lines.append("")
lines.append("USE stockpro_db;")
lines.append("")
lines.append("-- ============================================================")
lines.append("-- 1. TABLA DE RECETAS")
lines.append("-- ============================================================")
lines.append("CREATE TABLE IF NOT EXISTS product_recipes (")
lines.append("    id VARCHAR(36) PRIMARY KEY,")
lines.append("    tenant_id VARCHAR(36) NOT NULL,")
lines.append("    product_id VARCHAR(36) NOT NULL,")
lines.append("    ingredient_id VARCHAR(36) NOT NULL,")
lines.append("    quantity DECIMAL(10,3) NOT NULL,")
lines.append("    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,")
lines.append("    FOREIGN KEY (tenant_id) REFERENCES tenants(id) ON DELETE CASCADE,")
lines.append("    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,")
lines.append("    FOREIGN KEY (ingredient_id) REFERENCES products(id) ON DELETE RESTRICT,")
lines.append("    INDEX idx_recipe_product (product_id),")
lines.append("    INDEX idx_recipe_tenant (tenant_id)")
lines.append(") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;")
lines.append("")
lines.append("-- ============================================================")
lines.append("-- 2. VARIABLES")
lines.append("-- ============================================================")
lines.append("SET @tid    = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' COLLATE utf8mb4_unicode_ci;")
lines.append("SET @env30  = 'prod-pm-2002' COLLATE utf8mb4_unicode_ci; -- ENVASE LACOSTE 30ML  ($4)")
lines.append("SET @env100 = 'prod-pm-2004' COLLATE utf8mb4_unicode_ci; -- ENVASE LACOSTE 100ML ($1,900)")
lines.append("SET @caj30  = 'prod-pm-2005' COLLATE utf8mb4_unicode_ci; -- CAJA 30-50ML         ($0)")
lines.append("SET @caj100 = 'prod-pm-2006' COLLATE utf8mb4_unicode_ci; -- CAJA 100ML           ($0)")
lines.append("SET @env50  = 'prod-pm-2007' COLLATE utf8mb4_unicode_ci; -- ENVASE LACOSTE 50ML  ($600)")
lines.append("")
lines.append("-- ============================================================")
lines.append("-- 3. CATEGORIA PERFUMERIA (si no existe)")
lines.append("-- ============================================================")
lines.append("INSERT IGNORE INTO categories (id, tenant_id, name, description) VALUES")
lines.append("('cat-pm-perfumeria', @tid, 'Perfumería', 'Perfumes terminados: originales y réplicas');")
lines.append("")
lines.append("-- ============================================================")
lines.append("-- 4. LIMPIAR DATOS PREVIOS (idempotente)")
lines.append("-- ============================================================")
lines.append("DELETE FROM product_recipes WHERE tenant_id = @tid AND product_id LIKE 'PERF-%';")
lines.append("DELETE FROM products WHERE tenant_id = @tid AND id LIKE 'PERF-%';")
lines.append("")

# ---- PRODUCTOS 30ML ----
lines.append("-- ============================================================")
lines.append("-- 5. PRODUCTOS TERMINADOS 30ML")
lines.append("--    Costo BOM: 13*1700 + 4 + 0 = $22,104 (redondeado a $22,000 segun cliente)")
lines.append("--    Precio venta: $65,000")
lines.append("-- ============================================================")
lines.append("INSERT INTO products (id, tenant_id, name, articulo, category, product_type, sku, stock, reorder_point, entry_date, purchase_price, sale_price, presentation, notes, sede_id) VALUES")
prod30_rows = []
for code, name in extractos:
    pid = f"PERF-{code}-030"
    sku = f"PM-PERF-{code.upper()}-030"
    ext_id = f"prod-pm-{code}"
    prod30_rows.append(
        f"('{pid}', @tid, '{name} 30ML', 'PERF-{name} 30ML', 'cat-pm-perfumeria', 'perfumes', '{sku}', 0, 0, CURDATE(), 22000, 65000, '30ML', 'Extracto: {ext_id}', 'sede-pm-1')"
    )
lines.append(",\n".join(prod30_rows) + ";")
lines.append("")

# ---- PRODUCTOS 50ML ----
lines.append("-- ============================================================")
lines.append("-- 6. PRODUCTOS TERMINADOS 50ML")
lines.append("--    Costo BOM: 22*1700 + 600 + 0 = $38,000")
lines.append("--    Precio venta: $90,000")
lines.append("-- ============================================================")
lines.append("INSERT INTO products (id, tenant_id, name, articulo, category, product_type, sku, stock, reorder_point, entry_date, purchase_price, sale_price, presentation, notes, sede_id) VALUES")
prod50_rows = []
for code, name in extractos:
    pid = f"PERF-{code}-050"
    sku = f"PM-PERF-{code.upper()}-050"
    ext_id = f"prod-pm-{code}"
    prod50_rows.append(
        f"('{pid}', @tid, '{name} 50ML', 'PERF-{name} 50ML', 'cat-pm-perfumeria', 'perfumes', '{sku}', 0, 0, CURDATE(), 38000, 90000, '50ML', 'Extracto: {ext_id}', 'sede-pm-1')"
    )
lines.append(",\n".join(prod50_rows) + ";")
lines.append("")

# ---- PRODUCTOS 100ML ----
lines.append("-- ============================================================")
lines.append("-- 7. PRODUCTOS TERMINADOS 100ML")
lines.append("--    Costo BOM: 43*1700 + 1900 + 0 = $75,000")
lines.append("--    Precio venta: $150,000")
lines.append("-- ============================================================")
lines.append("INSERT INTO products (id, tenant_id, name, articulo, category, product_type, sku, stock, reorder_point, entry_date, purchase_price, sale_price, presentation, notes, sede_id) VALUES")
prod100_rows = []
for code, name in extractos:
    pid = f"PERF-{code}-100"
    sku = f"PM-PERF-{code.upper()}-100"
    ext_id = f"prod-pm-{code}"
    prod100_rows.append(
        f"('{pid}', @tid, '{name} 100ML', 'PERF-{name} 100ML', 'cat-pm-perfumeria', 'perfumes', '{sku}', 0, 0, CURDATE(), 75000, 150000, '100ML', 'Extracto: {ext_id}', 'sede-pm-1')"
    )
lines.append(",\n".join(prod100_rows) + ";")
lines.append("")

# ---- RECETAS BOM ----
lines.append("-- ============================================================")
lines.append("-- 8. RECETAS BOM")
lines.append("--    30ML  = 13 extracto + 1 envase 30ML  + 1 caja 30-50ML")
lines.append("--    50ML  = 22 extracto + 1 envase 50ML  + 1 caja 30-50ML")
lines.append("--    100ML = 43 extracto + 1 envase 100ML + 1 caja 100ML")
lines.append("-- ============================================================")

# Split into batches of 80 extractos to avoid very long INSERT statements
BATCH = 80
all_recipe_rows = []
for code, name in extractos:
    ext_id = f"prod-pm-{code}"
    p30  = f"PERF-{code}-030"
    p50  = f"PERF-{code}-050"
    p100 = f"PERF-{code}-100"
    # 30ML
    all_recipe_rows.append(f"(UUID(), @tid, '{p30}',  '{ext_id}', 13)")
    all_recipe_rows.append(f"(UUID(), @tid, '{p30}',  @env30, 1)")
    all_recipe_rows.append(f"(UUID(), @tid, '{p30}',  @caj30, 1)")
    # 50ML
    all_recipe_rows.append(f"(UUID(), @tid, '{p50}',  '{ext_id}', 22)")
    all_recipe_rows.append(f"(UUID(), @tid, '{p50}',  @env50, 1)")
    all_recipe_rows.append(f"(UUID(), @tid, '{p50}',  @caj30, 1)")
    # 100ML
    all_recipe_rows.append(f"(UUID(), @tid, '{p100}', '{ext_id}', 43)")
    all_recipe_rows.append(f"(UUID(), @tid, '{p100}', @env100, 1)")
    all_recipe_rows.append(f"(UUID(), @tid, '{p100}', @caj100, 1)")

# Write in batches of 800 rows
batch_size = 800
for i in range(0, len(all_recipe_rows), batch_size):
    batch = all_recipe_rows[i:i+batch_size]
    start_ext = i // 9 + 1
    end_ext   = min((i + batch_size) // 9, len(extractos))
    lines.append(f"-- Recetas extractos {start_ext}-{end_ext}")
    lines.append("INSERT INTO product_recipes (id, tenant_id, product_id, ingredient_id, quantity) VALUES")
    lines.append(",\n".join(batch) + ";")
    lines.append("")

# ---- VERIFICACION ----
lines.append("-- ============================================================")
lines.append("-- 9. VERIFICACION")
lines.append("-- ============================================================")
lines.append("SELECT CONCAT('Productos terminados creados: ', COUNT(*)) AS resultado")
lines.append("FROM products WHERE tenant_id = @tid AND id LIKE 'PERF-%';")
lines.append("")
lines.append("SELECT CONCAT('Recetas creadas: ', COUNT(*)) AS resultado")
lines.append("FROM product_recipes WHERE tenant_id = @tid AND product_id LIKE 'PERF-%';")
lines.append("")
lines.append("SELECT")
lines.append("    p.name AS Perfume,")
lines.append("    p.presentation AS Presentacion,")
lines.append("    CONCAT('$', FORMAT(p.purchase_price, 0)) AS 'Costo BOM',")
lines.append("    CONCAT('$', FORMAT(p.sale_price, 0)) AS 'Precio Venta',")
lines.append("    CONCAT(ROUND((p.sale_price - p.purchase_price) / p.sale_price * 100, 1), '%') AS Margen,")
lines.append("    (SELECT FLOOR(MIN(CASE WHEN pr.quantity > 0 THEN ing.stock / pr.quantity ELSE 0 END))")
lines.append("     FROM product_recipes pr")
lines.append("     JOIN products ing ON ing.id = pr.ingredient_id")
lines.append("     WHERE pr.product_id = p.id) AS 'Stock Disponible BOM'")
lines.append("FROM products p")
lines.append("WHERE p.tenant_id = @tid AND p.id LIKE 'PERF-s1-001-%'")
lines.append("ORDER BY p.sale_price;")
lines.append("")
lines.append("SELECT 'Seed ejecutado correctamente. Los perfumes apareceran en el POS con su receta BOM.' AS RESULTADO;")

output = "\n".join(lines)
# Write directly to file with UTF-8 encoding
with open("recetasperfummua.sql", "w", encoding="utf-8") as f:
    f.write(output)
print(f"Generado: recetasperfummua.sql ({len(lines)} lineas, {len(extractos)} extractos, {len(extractos)*3} productos, {len(all_recipe_rows)} recetas)")
