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