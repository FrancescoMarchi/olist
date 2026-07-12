-- ============================================
-- Master Query: Order Items + Orders + Products + Customers
-- Purpose: Combines item-level data with order status/dates, 
-- product category, and customer identity for analysis.
-- Base table: order_items (most granular — item-level)
--
-- Notes:
-- - 1,603 rows (~1.4%) have an empty product_category_name in the
--   source data. Labeled as 'uncategorized' rather than dropped,
--   to preserve revenue accuracy in aggregations.
-- - customer_unique_id (from olist_customers_dataset) added to 
--   support purchase-pattern analysis. Note: customer_id changes 
--   per order for the same person; customer_unique_id is the 
--   correct key for identifying a unique customer across orders.
-- ============================================

CREATE OR REPLACE VIEW olist.v_master_orders AS
SELECT
    oi.product_id,
    oi.price,
    oi.order_id,
    oi.freight_value,
    o.customer_id,
    o.order_purchase_timestamp,
    o.order_status,
    CASE
        WHEN p.product_category_name = '' THEN 'uncategorized'
        ELSE p.product_category_name
    END AS product_category_name,
    c.customer_unique_id
FROM olist.olist_order_items_dataset oi
JOIN olist.olist_orders_dataset o ON oi.order_id = o.order_id
JOIN olist.olist_products_dataset p ON oi.product_id = p.product_id
JOIN olist.olist_customers_dataset c ON o.customer_id = c.customer_id;