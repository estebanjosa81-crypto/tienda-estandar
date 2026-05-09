-- Migración: columnas para integración Alegra / DIAN
-- Ejecutar una sola vez en la base de datos

ALTER TABLE sales
  ADD COLUMN alegra_id      VARCHAR(100) NULL AFTER notes,
  ADD COLUMN cufe           VARCHAR(500) NULL AFTER alegra_id,
  ADD COLUMN dian_status    VARCHAR(50)  NULL AFTER cufe,
  ADD COLUMN alegra_pdf_url TEXT         NULL AFTER dian_status;

-- Variables de entorno requeridas en .env del backend:
-- ALEGRA_EMAIL=tu-email@alegra.com
-- ALEGRA_TOKEN=tu-token-de-alegra
-- ALEGRA_NUMBER_TEMPLATE_ID=1        (ID de la plantilla de numeración en Alegra)
-- ALEGRA_TAX_ID=3                    (ID del impuesto IVA 19% en tu cuenta Alegra)

-- Alternativa: registrar en platform_settings (admin):
-- INSERT INTO platform_settings (setting_key, setting_value) VALUES
--   ('alegra_email',               'tu-email@alegra.com'),
--   ('alegra_token',               'tu-token'),
--   ('alegra_number_template_id',  '1'),
--   ('alegra_tax_id',              '3'),
--   ('alegra_enabled',             'true');
