-- ============================================
-- Olist E-commerce Analytics Project
-- 01_data_cleaning.sql
-- Purpose: Fix column types on olist_orders_dataset
-- (CSV import defaults all columns to text/varchar)
-- ============================================

-- Convert order_purchase_timestamp to timestamp
ALTER TABLE olist.olist_orders_dataset
ALTER COLUMN order_purchase_timestamp TYPE timestamp
USING order_purchase_timestamp::timestamp;

-- order_approved_at: normalize blanks, then convert
UPDATE olist.olist_orders_dataset
SET order_approved_at = NULL
WHERE order_approved_at = '';

ALTER TABLE olist.olist_orders_dataset
ALTER COLUMN order_approved_at TYPE timestamp
USING order_approved_at::timestamp;

-- order_delivered_carrier_date: normalize blanks, then convert
UPDATE olist.olist_orders_dataset
SET order_delivered_carrier_date = NULL
WHERE order_delivered_carrier_date = '';

ALTER TABLE olist.olist_orders_dataset
ALTER COLUMN order_delivered_carrier_date TYPE timestamp
USING order_delivered_carrier_date::timestamp;

-- order_delivered_customer_date: normalize blanks, then convert
UPDATE olist.olist_orders_dataset
SET order_delivered_customer_date = NULL
WHERE order_delivered_customer_date = '';

ALTER TABLE olist.olist_orders_dataset
ALTER COLUMN order_delivered_customer_date TYPE timestamp
USING order_delivered_customer_date::timestamp;

-- order_estimated_delivery_date: no blanks found, direct convert
ALTER TABLE olist.olist_orders_dataset
ALTER COLUMN order_estimated_delivery_date TYPE timestamp
USING order_estimated_delivery_date::timestamp;

-- ============================================
-- Table: olist_order_items_dataset
-- Purpose: Fix column types (price, freight_value 
-- imported correctly as float4 — only shipping_limit_date needed fixing)
-- ============================================

-- Check for empty strings first (result: 0, no UPDATE needed)
-- SELECT COUNT(*) FROM olist.olist_order_items_dataset WHERE shipping_limit_date = '';

-- Convert shipping_limit_date to timestamp
ALTER TABLE olist.olist_order_items_dataset
ALTER COLUMN shipping_limit_date TYPE timestamp
USING shipping_limit_date::timestamp;

-- ============================================
-- FIX: olist_order_items_dataset duplication
-- Root cause: accidental double-import during Phase 1 
-- (likely during CSV import retry after reviews_dataset error)
-- Discovered: row count was 225,300 instead of expected ~112,650
-- ============================================

TRUNCATE TABLE olist.olist_order_items_dataset;
-- Re-imported olist_order_items_dataset.csv via DBeaver Import Data wizard

-- Re-applied type fix after re-import (re-import resets column types to varchar)
ALTER TABLE olist.olist_order_items_dataset
ALTER COLUMN shipping_limit_date TYPE timestamp
USING shipping_limit_date::timestamp;

-- Verified: no empty strings found (COUNT = 0), no UPDATE needed
-- Verified: row count now 112,650 (correct)