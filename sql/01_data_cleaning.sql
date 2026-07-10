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