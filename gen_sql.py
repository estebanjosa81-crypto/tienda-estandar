#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Generator for inventario_perfummua.sql
Reads inventariperfummua.md and produces the SQL file.
"""

import re
import os

MD_PATH = r"C:\Users\esteb\Downloads\perfum mua\inventariperfummua.md"
SQL_PATH = r"C:\Users\esteb\Downloads\perfum mua\backend\inventario_perfummua.sql"
TENANT_ID = "d46bec36-5259-4b5b-83c7-01f1e6ea5dcd"

# ── helpers ──────────────────────────────────────────────────────────────────

def parse_price(raw: str) -> int:
    """'$1.000,00' → 1000"""
    raw = raw.strip()
    raw = raw.lstrip("$")
    # remove thousands separators (.) and decimal comma
    raw = raw.replace(".", "").replace(",", ".")
    try:
        return int(float(raw))
    except ValueError:
        return 0


def clean_name(articulo: str) -> str:
    """
    Strip brand/type prefix (up to first '-' before the product name)
    and gender suffix.
    """
    # Order matters: longer patterns must come first
    prefixes = [
        r"^ORI-VS CREMA ",
        r"^ORI-VS SPLASH ",
        r"^ORI-VS ",
        r"^ORI-CREMA ",
        r"^ORI-AEROSOL-",
        r"^ORI-",
        r"^REP-SPLASH ACRILICOS-",
        r"^REP-SPLASH ",
        r"^REP-KITS ",
        r"^REP-VS CREMA ",
        r"^REP-VS SPLASH ",
        r"^REP-AEROSOL-",
        r"^REP-",
        r"^VIDAN-MANTEQUILLA BLIME-",
        r"^VIDAN-MANTEQUILLA BRILLO-",
        r"^VIDAN-CREMA TOCADOR-",
        r"^VIDAN-MINI CREMA SHIMMER-",
        r"^VIDAN-MINI CREMAS SHIMMER-",
        r"^VIDAN-MINI MANTEQUILLA-",
        r"^VIDAN-MINI MANTEQUILLAS-",
        r"^VIDAN-MINI SPLASH-",
        r"^VIDAN-MANTEQUILLA-",
        r"^VIDAN-",
        r"^ESENCIA HS-",
        r"^ESENCIA PB-",
        r"^ESENCIA ",
        r"^DIFUSOR-",
        r"^DIFUSOR ",
        r"^AROMATIZANTE-",
        r"^CREMA-",
        r"^FRASCO-",
        r"^CREMAS-",
        r"^PURPURE-BRILLI BRILLI-",
        r"^PURPURE-MINI MANTEQUILLA BELLOTA-",
        r"^PURPURE-MINI MANTEQUILLA-",
        r"^PURPURE-MANTEQUILLA-",
        r"^PURPURE-MINI SPLASH-",
        r"^PURPURE-KITS-",
        r"^PURPURE-",
        r"^PERFUME-",
        r"^PM-SHIMMER ",
        r"^PM-SPLASH ",
        r"^PM CARRO-",
        r"^PM ",
        r"^SPLASH-",
        r"^AGUA DE LINOS-",
        r"^EXT-[^-]+-",       # EXT-BRAND-
    ]

    name = articulo
    for pat in prefixes:
        m = re.match(pat, name, re.IGNORECASE)
        if m:
            name = name[m.end():]
            break

    # Remove gender suffix
    name = re.sub(r"-(FEM|MAS|UNI|NIÑO|NIÑA|FEMENINO|MASCULINO)$", "", name, flags=re.IGNORECASE)
    return name.strip()


def get_category(articulo: str, categoria: str) -> str:
    gender_suffixes = {
        "MAS": "cat-pm-caballeros",
        "FEM": "cat-pm-damas",
        "UNI": "cat-pm-unisex",
        "NIÑO": "cat-pm-unisex",
        "NIÑA": "cat-pm-unisex",
        "FEMENINO": "cat-pm-damas",
        "MASCULINO": "cat-pm-caballeros",
    }
    # detect suffix
    m = re.search(r"-(FEM|MAS|UNI|NIÑO|NIÑA|FEMENINO|MASCULINO)$", articulo, re.IGNORECASE)
    if m:
        suf = m.group(1).upper()
        return gender_suffixes.get(suf, "cat-pm-cremas")

    cat_upper = categoria.upper()
    # normalize accents
    cat_norm = cat_upper.replace("Í","I").replace("É","E").replace("Á","A").replace("Ó","O").replace("Ú","U")
    if cat_norm in ("CORPORAL", "COMPLEMENTARIO", "BELLEZA", "HOGAR", "ENVASES", "INSUMOS", "PERFUMERIA"):
        return "cat-pm-cremas"
    # PERFUMERÍA without suffix
    return "cat-pm-cremas"


def get_sede_id(sede_raw: str) -> str:
    s = sede_raw.strip().lower()
    if "2" in s:
        return "sede-pm-2"
    return "sede-pm-1"


def sql_str(s):
    if s is None:
        return "NULL"
    return "'" + s.replace("'", "''") + "'"


# ── read data ────────────────────────────────────────────────────────────────

rows = []
header_count = 0

with open(MD_PATH, encoding="utf-8") as f:
    for line in f:
        line = line.strip()
        if not line:
            continue
        parts = line.split(";")
        if len(parts) < 8:
            continue
        codigo, articulo, categoria, linea, existencias, costo, preventa, sede = (
            parts[0].strip(),
            parts[1].strip(),
            parts[2].strip(),
            parts[3].strip(),
            parts[4].strip(),
            parts[5].strip(),
            parts[6].strip(),
            parts[7].strip(),
        )
        # skip header lines
        if codigo.lower() == "código":
            header_count += 1
            continue
        rows.append({
            "codigo": codigo,
            "articulo": articulo,
            "categoria": categoria,
            "linea": linea,
            "existencias": existencias,
            "costo": costo,
            "preventa": preventa,
            "sede": sede,
        })

print(f"Loaded {len(rows)} data rows (skipped {header_count} headers)")

# ── assign IDs (handle duplicates) ──────────────────────────────────────────
# Key: (codigo, sede_key)  → might repeat when same code appears for diff articles in same sede
# Also same code in both sedes gets s1/s2 suffix

from collections import defaultdict

# First pass: find codes that appear in both sedes
code_sedes = defaultdict(set)
for r in rows:
    code_sedes[r["codigo"]].add(get_sede_id(r["sede"]))

code_in_both = {c for c, ss in code_sedes.items() if len(ss) > 1}

# Second pass: assign IDs
# Track (base_id) → count of times seen, to apply -b -c suffixes
id_counter = {}   # base_id → next suffix index (0 = first, 1 = -b, 2 = -c …)
suffix_letters = ['', '-b', '-c', '-d', '-e', '-f', '-g', '-h']

assigned_ids = set()

for r in rows:
    codigo = r["codigo"]
    sede_id = get_sede_id(r["sede"])

    if codigo in code_in_both:
        # s1 / s2 suffix
        sede_short = "s1" if sede_id == "sede-pm-1" else "s2"
        base_id = f"prod-pm-{sede_short}-{codigo}"
        base_sku = f"PM-{sede_short.upper()}-{codigo.upper()}"
    else:
        base_id = f"prod-pm-{codigo}"
        base_sku = f"PM-{codigo.upper()}"

    # Now handle duplicates within the same base_id
    if base_id not in id_counter:
        id_counter[base_id] = 0
    else:
        id_counter[base_id] += 1

    idx = id_counter[base_id]
    suf = suffix_letters[idx] if idx < len(suffix_letters) else f"-{idx}"

    final_id = base_id + suf
    final_sku = base_sku + suf.upper()

    # Paranoia: ensure truly unique
    orig = final_id
    extra = 0
    while final_id in assigned_ids:
        extra += 1
        final_id = orig + f"-x{extra}"
        final_sku = base_sku + suf.upper() + f"-X{extra}"

    assigned_ids.add(final_id)
    r["id"] = final_id
    r["sku"] = final_sku
    r["name"] = r["articulo"]
    r["category_id"] = get_category(r["articulo"], r["categoria"])
    r["sede_id"] = sede_id
    r["stock"] = int(r["existencias"]) if r["existencias"] else 0
    r["purchase_price"] = parse_price(r["costo"])
    r["sale_price"] = parse_price(r["preventa"])

print(f"Unique IDs assigned: {len(assigned_ids)}")
assert len(assigned_ids) == len(rows), "DUPLICATE IDs DETECTED!"

# ── group rows for sectioned output ─────────────────────────────────────────

sede1 = [r for r in rows if r["sede_id"] == "sede-pm-1"]
sede2 = [r for r in rows if r["sede_id"] == "sede-pm-2"]

def section_key_s1(r):
    cat = r["categoria"].upper()
    linea = r["linea"].upper()
    if cat == "COMPLEMENTARIO":
        return ("1-COMPLEMENTARIO", linea)
    if cat == "CORPORAL":
        return ("2-CORPORAL", linea)
    if cat == "HOGAR":
        return ("3-HOGAR", linea)
    if cat == "PERFUMERÍA":
        line_map = {
            "EXTRACTO": "4-PERFUMERÍA EXTRACTO",
            "ORIGINAL": "5-PERFUMERÍA ORIGINAL",
            "RÉPLICA": "6-PERFUMERÍA RÉPLICA",
            "REPLICA": "6-PERFUMERÍA RÉPLICA",
        }
        return (line_map.get(linea, "7-PERFUMERÍA VARIOS"), linea)
    return ("8-OTROS", linea)

def section_key_s2(r):
    cat = r["categoria"].upper()
    # normalize: strip accents for comparison
    cat_norm = cat.replace("Í", "I").replace("É", "E").replace("Á", "A").replace("Ó", "O").replace("Ú", "U")
    linea = r["linea"].upper()
    if cat_norm == "HOGAR":
        return ("1-HOGAR", linea)
    if cat_norm == "BELLEZA":
        return ("2-BELLEZA", linea)
    if cat_norm == "ENVASES":
        return ("3-ENVASES", linea)
    if cat_norm in ("INSUMOS", "PERFUMERIA", "PERFUMERÍA"):
        return ("4-PERFUMERÍA SEDE 2", linea)
    return ("5-OTROS", linea)

from itertools import groupby

def group_by_section(rows_list, key_fn):
    # sort then group
    sorted_rows = sorted(rows_list, key=key_fn)
    groups = []
    for key, grp in groupby(sorted_rows, key=lambda r: key_fn(r)[0]):
        groups.append((key, list(grp)))
    return groups

# ── SQL generation ───────────────────────────────────────────────────────────

INSERT_COLS = (
    "id, tenant_id, name, articulo, category, product_type, sku, stock, "
    "reorder_point, entry_date, purchase_price, sale_price, presentation, notes, sede_id"
)

def row_values(r):
    return (
        f"({sql_str(r['id'])}, {sql_str(TENANT_ID)}, "
        f"{sql_str(r['name'])}, {sql_str(r['articulo'])}, "
        f"{sql_str(r['category_id'])}, 'cosmetica', "
        f"{sql_str(r['sku'])}, {r['stock']}, 0, '2026-03-16', "
        f"{r['purchase_price']}, {r['sale_price']}, NULL, "
        f"{sql_str('Código: ' + r['codigo'])}, {sql_str(r['sede_id'])})"
    )


def write_section_inserts(out_lines, section_name, section_rows):
    out_lines.append(f"\n-- {section_name}")
    # chunk into <=200
    chunk_size = 200
    for i in range(0, len(section_rows), chunk_size):
        chunk = section_rows[i:i+chunk_size]
        out_lines.append(f"INSERT INTO products ({INSERT_COLS}) VALUES")
        vals = [row_values(r) for r in chunk]
        out_lines.append(",\n".join(vals) + ";")


lines = []
lines.append("USE stockpro_db;")
lines.append("")
lines.append("-- ============================================================")
lines.append("-- SEDES")
lines.append("-- ============================================================")
lines.append(f"""INSERT INTO sedes (id, tenant_id, name, address) VALUES
('sede-pm-1', '{TENANT_ID}', 'Sede 1', NULL),
('sede-pm-2', '{TENANT_ID}', 'Sede 2', NULL)
ON DUPLICATE KEY UPDATE name = VALUES(name);""")

lines.append("")
lines.append("-- ============================================================")
lines.append("-- CATEGORÍAS")
lines.append("-- ============================================================")
lines.append(f"""INSERT INTO categories (id, tenant_id, name, description) VALUES
('cat-pm-caballeros', '{TENANT_ID}', 'Caballeros', 'Perfumes y productos masculinos'),
('cat-pm-damas',      '{TENANT_ID}', 'Damas',      'Perfumes y productos femeninos'),
('cat-pm-unisex',     '{TENANT_ID}', 'Unisex',     'Perfumes y productos unisex'),
('cat-pm-cremas',     '{TENANT_ID}', 'Cremas',     'Cremas corporales y productos de cuidado')
ON DUPLICATE KEY UPDATE name = VALUES(name);""")

lines.append("")
lines.append("-- ============================================================")
lines.append("-- PRODUCTOS SEDE 1")
lines.append("-- ============================================================")

s1_groups = group_by_section(sede1, section_key_s1)
for sec_key, sec_rows in s1_groups:
    # pretty section name
    sec_display = sec_key.split("-", 1)[1] if "-" in sec_key else sec_key
    write_section_inserts(lines, f"SEDE 1 — {sec_display} ({len(sec_rows)} filas)", sec_rows)

lines.append("")
lines.append("-- ============================================================")
lines.append("-- PRODUCTOS SEDE 2")
lines.append("-- ============================================================")

s2_groups = group_by_section(sede2, section_key_s2)
for sec_key, sec_rows in s2_groups:
    sec_display = sec_key.split("-", 1)[1] if "-" in sec_key else sec_key
    write_section_inserts(lines, f"SEDE 2 — {sec_display} ({len(sec_rows)} filas)", sec_rows)

sql_output = "\n".join(lines) + "\n"

# ── write output ──────────────────────────────────────────────────────────────
os.makedirs(os.path.dirname(SQL_PATH), exist_ok=True)
with open(SQL_PATH, "w", encoding="utf-8") as f:
    f.write(sql_output)

print(f"Written: {SQL_PATH}")

# ── verification ─────────────────────────────────────────────────────────────
product_rows = [l for l in sql_output.split("\n") if l.strip().startswith("('prod-pm-")]
print(f"Product INSERT value rows: {len(product_rows)}")

# Check for duplicate IDs in the SQL
import re as _re
ids_in_sql = _re.findall(r"'(prod-pm-[^']+)'", sql_output)
# only first occurrence per line (the id column)
# More precise: extract just the first field of each values row
id_values = _re.findall(r"\('(prod-pm-[^']+)',", sql_output)
dupes = [x for x in id_values if id_values.count(x) > 1]
if dupes:
    print(f"WARNING: duplicate IDs in SQL: {set(dupes)}")
else:
    print("No duplicate IDs found in SQL output.")

print(f"Total sede 1 rows: {len(sede1)}")
print(f"Total sede 2 rows: {len(sede2)}")
print(f"Grand total: {len(rows)}")
