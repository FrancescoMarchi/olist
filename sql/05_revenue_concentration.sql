-- ============================================
-- Revenue Concentration: Pareto Analysis by Category (FY2017)
-- Purpose: Determine whether revenue is concentrated in a small 
-- number of top categories, or spread evenly - informs where 
-- the business should focus retention/growth efforts.
-- Timeframe: Jan 1 - Dec 31, 2017
--
-- Finding: Top 15 categories (~20% of 73 total) generate 77.7% 
-- of total revenue - closely matches the classic Pareto (80/20) 
-- pattern. Revenue is meaningfully concentrated, not evenly spread.
-- Strategic implication: protecting/growing these top 15 categories 
-- matters disproportionately; the long tail (~58 categories) 
-- contributes a much smaller share collectively.
-- ============================================

SELECT 
    ROUND(SUM(CASE WHEN revenue_rank <= 15 THEN total_revenue ELSE 0 END)::numeric, 2) AS top15_revenue,
    ROUND(SUM(total_revenue)::numeric, 2) AS total_revenue,
    ROUND((100.0 * SUM(CASE WHEN revenue_rank <= 15 THEN total_revenue ELSE 0 END) / SUM(total_revenue))::numeric, 1) AS pct_revenue_from_top15
FROM (
    SELECT 
        product_category_name,
        SUM(price) AS total_revenue,
        ROW_NUMBER() OVER (ORDER BY SUM(price) DESC) AS revenue_rank
    FROM olist.v_master_orders
    WHERE order_purchase_timestamp >= '2017-01-01' AND order_purchase_timestamp < '2018-01-01'
    GROUP BY product_category_name
) AS ranked_categories;