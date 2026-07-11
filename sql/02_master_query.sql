-- ============================================
-- Master Query: Order Items + Orders + Products
-- Purpose: Combines item-level data with order 
-- status/dates and product category for analysis.
-- Base table: order_items (most granular — item-level)
--
-- Note: 1,603 rows (~1.4%) have an empty product_category_name
-- in the source data. Labeled as 'uncategorized' rather than 
-- dropped, to preserve revenue accuracy in aggregations.
-- ============================================

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
    END AS product_category_name
FROM olist.olist_order_items_dataset oi
JOIN olist.olist_orders_dataset o ON oi.order_id = o.order_id
JOIN olist.olist_products_dataset p ON oi.product_id = p.product_id;