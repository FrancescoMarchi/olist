-- ============================================
-- Revenue Trend: Monthly Revenue (FY2017)
-- Purpose: Understand revenue trajectory across the year - 
-- growing, flat, or declining? Identify any anomalous months.
-- Timeframe: Jan 1 - Dec 31, 2017
--
-- Finding: Clear growth trend across the year - revenue grows 
-- roughly 5-6x from January (~$240K) to peak months (~$1.2-2M). 
-- November stands out as a sharp outlier (~$2.02M), about 50% 
-- higher than October and December. Likely explanation: Black 
-- Friday retail activity (Nov), though this is an inference, not 
-- confirmed by a specific event flag in the data.
-- ============================================

SELECT
    DATE_TRUNC('month', order_purchase_timestamp) AS order_month,
    SUM(price) AS monthly_revenue
FROM olist.v_master_orders
WHERE order_purchase_timestamp >= '2017-01-01' AND order_purchase_timestamp < '2018-01-01'
GROUP BY order_month
ORDER BY order_month ASC;