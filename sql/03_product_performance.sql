-- ============================================
-- Product Performance: Revenue by Category (FY2017)
-- Purpose: Identify top/bottom performing product categories by revenue
-- Timeframe: Jan 1 - Dec 31, 2017 (see README for scoping rationale)
--
-- Findings:
-- 1. Top 3 categories are closely clustered in revenue - no single 
--    dominant category.
-- 2. 'uncategorized' (1.4% of rows) ranks 17th of 73 by revenue - 
--    disproportionate to its row count.
-- 3. Top category (cama_mesa_banho) leads on BOTH revenue and volume -
--    broad-based demand, not a single high-value outlier.
-- 4. relogios_presentes (watches/gifts) achieves near-identical revenue 
--    to the top category with less than half the item volume - driven 
--    by 2x+ higher average price. A high-value, not high-volume, category.
-- ============================================

SELECT
    product_category_name,
    SUM(price) AS total_revenue,
    COUNT(*) AS items_sold,
    ROUND(AVG(price)::numeric, 2) AS avg_price
FROM olist.v_master_orders
WHERE order_purchase_timestamp >= '2017-01-01' AND order_purchase_timestamp < '2018-01-01'
GROUP BY product_category_name
ORDER BY