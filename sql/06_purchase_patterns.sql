-- ============================================
-- Purchase Patterns (Light): Repeat Customer Rate (FY2017)
-- Purpose: Light view of customer purchase behavior - do 
-- customers return, or is the business driven by one-time buyers?
-- (Not a full retention/RFM analysis - out of scope per project brief)
-- Timeframe: Jan 1 - Dec 31, 2017
--
-- Finding: Only 2.8% of customers (1,227 of 43,225) made more 
-- than one order in 2017. Average orders per customer: 1.03.
-- Consistent with Block 2 findings (90% single-item orders) - 
-- this is a business built on one-time transactions, not repeat 
-- relationships. Reinforces cross-sell/bundling as a growth lever, 
-- since customer acquisition (not retention) currently drives revenue.
-- ============================================

SELECT 
    COUNT(*) AS total_customers,
    SUM(CASE WHEN orders_count > 1 THEN 1 ELSE 0 END) AS repeat_customers,
    ROUND(100.0 * SUM(CASE WHEN orders_count > 1 THEN 1 ELSE 0 END) / COUNT(*), 1) AS pct_repeat_customers,
    ROUND(AVG(orders_count)::numeric, 2) AS avg_orders_per_customer
FROM (
    SELECT
        customer_unique_id,
        COUNT(DISTINCT order_id) AS orders_count
    FROM olist.v_master_orders
    WHERE order_purchase_timestamp >= '2017-01-01' AND order_purchase_timestamp < '2018-01-01'
    GROUP BY customer_unique_id
) AS customer_orders;