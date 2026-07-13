-- ============================================
-- Revenue Trend: Monthly Revenue (FY2017)
-- Purpose: Understand revenue trajectory across the year - 
-- growing, flat, or declining? Identify any anomalous months.
-- Timeframe: Jan 1 - Dec 31, 2017
--
-- NOTE: This query was originally run against a version of the 
-- view that had a fan-out bug (customers table was duplicated, 
-- doubling all SUM(price) results). Corrected after the customers 
-- table was fixed - see Lesson #24. Figures below are verified 
-- correct (sum of all months ≈ $6.16M, matching Block 3's total).
--
-- Finding: Clear growth trend across the year - revenue grows 
-- roughly 6x from January (~$120K) to peak months. November stands 
-- out as a spike (~$1.01M), about 52% higher than October and 36% 
-- higher than December. Likely explanation: Black Friday retail 
-- activity (Nov), though this is an inference, not confirmed by a 
-- specific event flag in the data.
-- ============================================

SELECT
    DATE_TRUNC('month', order_purchase_timestamp) AS order_month,
    SUM(price) AS monthly_revenue
FROM olist.v_master_orders
WHERE order_purchase_timestamp >= '2017-01-01' AND order_purchase_timestamp < '2018-01-01'
GROUP BY order_month
ORDER BY order_month ASC;