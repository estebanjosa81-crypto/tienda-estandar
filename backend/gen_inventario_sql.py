#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
gen_inventario_sql.py — Perfum Mua
===================================
Lee inventario_raw.csv (formato ID;Artículo;Existencias),
asigna categoría y nombre limpio a cada artículo,
unifica duplicados sumando stock, y genera inventario_perfummua.sql.

Uso:
    python backend/gen_inventario_sql.py
Salida:
    backend/inventario_perfummua.sql
"""

import uuid
import os
from datetime import date

TENANT = "d46bec36-5259-4b5b-83c7-01f1e6ea5dcd"
TODAY  = date.today().isoformat()
INPUT  = os.path.join(os.path.dirname(__file__), "inventario_raw.csv")
OUTPUT = os.path.join(os.path.dirname(__file__), "inventario_perfummua.sql")

# ─── Sufijos de género ────────────────────────────────────────────────────────
GENDER_MAP = {
    "-FEMENINO": "mujer",   "-FEM":       "mujer",
    "-MASCULINO": "hombre", "-MAS":       "hombre",
    "-UNI":       "unisex",
    "-NIÑO":      "niño",   "-NIÑA":      "niña",
}

def detect_gender(article: str):
    a = article.upper()
    for suf, g in GENDER_MAP.items():
        if a.endswith(suf):
            return g
    return None

def strip_gender(article: str) -> str:
    a = article.upper()
    for suf in GENDER_MAP:
        if a.endswith(suf):
            return article[: -len(suf)]
    return article


# ─── Categorización ───────────────────────────────────────────────────────────
def categorize(article: str) -> str:
    a = article.upper().strip()

    if a.startswith("EXT-"):
        return "EXTRACTOS"

    # INSUMOS (envases, empaques, materiales, códigos)
    insumos = ("FRASCO-", "BOLSA ", "CAJA ", "ENVASE", "DECANT ", "BONO REGALO",
               "COD DISPONIBLE", "CREMA-SATINADA BRILLO")
    if any(a.startswith(p) for p in insumos):
        return "INSUMOS"
    if a in ("MUSK TAHARA", "FEROMONAS", "FEROMONAS X 10 GOTAS"):
        return "INSUMOS"

    # HOGAR (aromatizantes, difusores, esencias, carro)
    hogar = ("AROMATIZANTE-", "DIFUSOR-", "DIFUSOR- ", "ESENCIA HS-",
             "ESENCIA PB-", "AGUA DE LINOS-", "PM CARRO-", "PEBETERO")
    if any(a.startswith(p) for p in hogar) or a == "PEBETERO":
        return "HOGAR"

    # CREMAS
    cremas = ("CREMAS-", "CREMA-", "REP-VS CREMA", "ORI-VS CREMA",
              "VIDAN-CREMA TOCADOR", "VIDAN-MINI CREMA SHIMMER",
              "VIDAN-MINI CREMAS SHIMMER")
    if any(a.startswith(p) for p in cremas):
        return "CREMAS"

    # INFANTIL  (PM-SPLASH para niños/niñas)
    if a.startswith("PM-") and ("-NIÑO" in a or "-NIÑA" in a):
        return "INFANTIL"
    if a.startswith("KITS-NIÑO") or a.startswith("KITS-NIÑA"):
        return "INFANTIL"

    # CORPORAL (splashes, shimmer, mantequillas, splashes Victoria's Secret originales)
    corporal = ("PURPURE-", "VIDAN-MANTEQUILLA", "VIDAN-MINI MANTEQUILLA",
                "VIDAN-MINI SPLASH", "ORI-VS SPLASH", "ORI-CREMA",
                "SPLASH-", "PERFUME-CABELLO", "SPLASH-BODY SPRAY")
    if any(a.startswith(p) for p in corporal):
        return "CORPORAL"
    if a.startswith("PM-") and ("SPLASH" in a or "SHIMMER" in a):
        return "CORPORAL"
    if a.startswith("PM-"):
        return "CORPORAL"

    # Catch-all VIDAN (mantequillas/splashes no capturados arriba)
    if a.startswith("VIDAN-"):
        return "CORPORAL"

    # PERFUMERIA (réplicas, originales, kits, aerosoles, splashes acrílicos)
    if a.startswith("REP-") or a.startswith("ORI-") or \
       a.startswith("KITS-") or a.startswith("PURPURE-KITS-"):
        return "PERFUMERIA"

    # Casos sueltos
    if a.startswith("PROMOCION") or a == "PROMOCION":
        return "PERFUMERIA"

    return "PERFUMERIA"


PRODUCT_TYPE_MAP = {
    "EXTRACTOS":  "perfumes",
    "PERFUMERIA": "perfumes",
    "CREMAS":     "cosmetica",
    "CORPORAL":   "cosmetica",
    "INFANTIL":   "cosmetica",
    "HOGAR":      "hogar",
    "INSUMOS":    "otros",
}

def product_type(cat: str) -> str:
    return PRODUCT_TYPE_MAP.get(cat, "otros")


# ─── Nombre limpio ────────────────────────────────────────────────────────────
# Prefijos a eliminar del nombre visible (en orden de mayor a menor longitud)
_STRIP_PREFIXES = sorted([
    "EXT-", "REP-", "PM-", "CREMAS-", "CREMA-", "FRASCO-",
    "AROMATIZANTE-", "DIFUSOR- ", "DIFUSOR-", "ESENCIA HS-", "ESENCIA PB-",
    "AGUA DE LINOS-", "PM CARRO-", "PURPURE-", "VIDAN-", "ORI-",
    "SPLASH-", "PERFUME-",
], key=len, reverse=True)

def clean_name(article: str) -> str:
    name = article
    for pfx in _STRIP_PREFIXES:
        if name.upper().startswith(pfx.upper()):
            name = name[len(pfx):].strip()
            break
    name = strip_gender(name).strip()
    # Reemplaza guiones restantes por ' - ' y aplica title case
    name = name.replace("-", " - ").title()
    # Ajuste: "De" → "de", "Y" → "y", "La" → "la", "El" → "el", etc.
    for word in (" De ", " Y ", " La ", " El ", " Los ", " Las ", " En ",
                  " Con ", " Por ", " Para ", " Del ", " Al "):
        name = name.replace(word, word.lower())
    return name.strip()


# ─── Marca ────────────────────────────────────────────────────────────────────
def get_brand(article: str):
    a = article.upper()
    if a.startswith("VIDAN-"):
        return "Vidan"
    if a.startswith("PURPURE-"):
        return "Purpure"
    if a.startswith("PM-") or a.startswith("PM CARRO-"):
        return "Perfum Mua"
    # EXT-BRAND-PRODUCT-GENDER / REP- / ORI-
    for pfx in ("EXT-", "REP-", "ORI-"):
        if a.startswith(pfx):
            remaining = strip_gender(article[len(pfx):])
            if "-" in remaining:
                brand = remaining.split("-")[0].strip()
                return brand.title()
            return None
    return None


# ─── Utilidades SQL ───────────────────────────────────────────────────────────
def esc(val) -> str:
    if val is None:
        return "NULL"
    return "'" + str(val).replace("'", "''") + "'"


# ─── Main ─────────────────────────────────────────────────────────────────────
def main():
    if not os.path.exists(INPUT):
        print(f"ERROR: no se encontró {INPUT}")
        return

    # 1. Leer y agregar por nombre de artículo (suma stock)
    rows: dict[str, int] = {}
    skipped = 0
    with open(INPUT, encoding="utf-8") as f:
        for line in f:
            line = line.strip()
            if not line or line.upper().startswith("ID;"):
                continue
            parts = line.split(";")
            if len(parts) < 2:
                skipped += 1
                continue
            article = parts[1].strip()
            if not article:
                skipped += 1
                continue
            raw_stock = parts[2].strip() if len(parts) > 2 else ""
            try:
                stock = int(float(raw_stock)) if raw_stock else 0
            except ValueError:
                stock = 0
            rows[article] = rows.get(article, 0) + stock

    items = sorted(rows.items())   # orden alfabético para legibilidad
    print(f"  Artículos únicos : {len(items)}")
    print(f"  Líneas ignoradas : {skipped}")

    # 2. Generar SQL
    lines = []
    lines.append("USE stockpro_db;")
    lines.append("")
    lines.append(f"SET @tid = '{TENANT}' COLLATE utf8mb4_unicode_ci;")
    lines.append("")
    lines.append("-- ================================================================")
    lines.append(f"-- INVENTARIO PERFUM MUA — {len(items)} productos")
    lines.append(f"-- Generado: {TODAY}")
    lines.append("-- sale_price = 0.00 → actualizar antes de publicar en tienda.")
    lines.append("-- ================================================================")
    lines.append("")

    # Inserción en lotes de 500 para evitar queries gigantes
    BATCH = 500
    batches = [items[i:i+BATCH] for i in range(0, len(items), BATCH)]

    for batch_num, batch in enumerate(batches, 1):
        lines.append(f"-- Lote {batch_num}/{len(batches)}")
        lines.append("INSERT INTO products")
        lines.append("    (id, tenant_id, name, articulo, category, product_type,")
        lines.append("     brand, sku, stock, purchase_price, sale_price,")
        lines.append("     entry_date, gender, reorder_point)")
        lines.append("VALUES")

        for idx, (article, stock) in enumerate(batch):
            uid   = str(uuid.uuid4())
            sku   = f"PMUA{batch_num * 1000 + idx:04d}"[:50]
            cat   = categorize(article)
            ptype = product_type(cat)
            name  = clean_name(article)
            brand = get_brand(article)
            gender = detect_gender(article)
            comma  = "" if idx == len(batch) - 1 else ","

            lines.append(
                f"    ({esc(uid)}, @tid, {esc(name)}, {esc(article)}, "
                f"{esc(cat)}, {esc(ptype)}, {esc(brand)}, {esc(sku)}, "
                f"{stock}, 0.00, 0.00, {esc(TODAY)}, {esc(gender)}, 5){comma}"
            )

        lines.append(";")
        lines.append("")

    lines.append("SELECT CONCAT('Productos cargados: ', @@warning_count) AS INFO;")
    lines.append("")

    # Resumen por categoría
    from collections import Counter
    cat_counts = Counter(categorize(art) for art, _ in items)
    lines.append("-- ── Resumen por categoría ──────────────────────────────────────")
    for cat, cnt in sorted(cat_counts.items()):
        lines.append(f"--   {cat:<15} {cnt:>4} productos")
    lines.append("-- ─────────────────────────────────────────────────────────────")

    sql_text = "\n".join(lines) + "\n"
    with open(OUTPUT, "w", encoding="utf-8") as f:
        f.write(sql_text)

    print(f"  SQL generado     : {OUTPUT}")
    print("\n  Distribución por categoría:")
    for cat, cnt in sorted(cat_counts.items()):
        print(f"    {cat:<15} {cnt:>4}")


if __name__ == "__main__":
    main()
