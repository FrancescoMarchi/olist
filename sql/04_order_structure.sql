-- ============================================
-- Order Structure: Items per Order (FY2017)
-- Purpose: Understand typical basket size - are customers 
-- buying single items or building multi-item baskets?
-- Timeframe: Jan 1 - Dec 31, 2017
--
-- Finding: 90% of orders (40,135 of 44,579) contain exactly 
-- 1 item. Average items per order is just 1.14. This suggests 
-- minimal basket-building behavior - significant opportunity 
-- for cross-sell/bundling strategies to grow revenue per order.
-- ============================================

SELECT 
    COUNT(*) AS total_orders,
    SUM(CASE WHEN items_in_order = 1 THEN 1 ELSE 0 END) AS single_item_orders,
    ROUND(AVG(items_in_order)::numeric, 2) AS avg_items_per_order,
    ROUND(100.0 * SUM(CASE WHEN items_in_order = 1 THEN 1 ELSE 0 END) / COUNT(*), 1) AS pct_single_item_orders
FROM (
    SELECT
        order_id,
        COUNT(*) AS items_in_order
    FROM olist.v_master_orders
    WHERE order_purchase_timestamp >= '2017-01-01' AND order_purchase_timestamp < '2018-01-01'
    GROUP BY order_id
) AS order_counts;