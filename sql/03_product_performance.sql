-- ============================================
-- Product Performance: Revenue by Category (FY2017)
-- Purpose: Identify top/bottom performing product categories by revenue
-- Timeframe: Jan 1 - Dec 31, 2017 (see README for scoping rationale)
--
-- Finding: Top 3 categories are closely clustered in revenue -
-- no single dominant category. 'uncategorized' (1.4% of rows) 
-- ranks 17th of 73 by revenue - disproportionate to its row count.
-- ============================================

SELECT
    product_category_name,
    SUM(price) AS total_revenue
FROM olist.v_master_orders
WHERE order_purchase_timestamp >= '2017-01-01' AND order_purchase_timestamp < '2018-01-01'
GROUP BY product_category_name
ORDER BY total_revenue DESC;