-- Migration: Add presentations columns to products table
ALTER TABLE products
  ADD COLUMN presentations_enabled BOOLEAN NOT NULL DEFAULT FALSE
    COMMENT 'Habilita selector de presentaciones en la tienda';

ALTER TABLE products
  ADD COLUMN presentations JSON NULL
    COMMENT 'Array de presentaciones [{size, price}]';
