-- Adds meta_pixel_id column to store_info for per-tenant Facebook Pixel tracking
ALTER TABLE store_info
  ADD COLUMN IF NOT EXISTS meta_pixel_id VARCHAR(50) NULL DEFAULT NULL;
