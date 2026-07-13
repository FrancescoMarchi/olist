-- ============================================
-- Geographic Revenue Revenue by Customer State (FY2017)
-- Purpose Understand geographic concentration of revenue - 
-- is the business nationally distributed or regionally dependent
-- Timeframe Jan 1 - Dec 31, 2017
--
-- Finding Extreme geographic concentration. SP (São Paulo) alone 
-- generates $4.43M - more than RJ and MG (2nd and 3rd) combined. 
-- Top 3 states (SP, RJ, MG) of 27 total generate 62.4% of all 
-- revenue. Lowest state (RR) generated just $2,810 all year - a 
-- ~1,575x gap vs. SP. This mirrors the concentration pattern seen 
-- in Block 3 (categories) and bottom-performer analysis - revenue 
-- concentration is a consistent theme across this business, whether 
-- viewed by product or by geography.
-- ============================================

SELECT
    customer_state,
    SUM(price) AS total_revenue,
    COUNT() AS items_sold
FROM olist.v_master_orders
WHERE order_purchase_timestamp = '2017-01-01' AND order_purchase_timestamp  '2018-01-01'
GROUP BY customer_state
ORDER BY total_revenue DESC;

-- Concentration check top 3 states as % of total revenue
SELECT 
    ROUND(SUM(CASE WHEN state_rank = 3 THEN total_revenue ELSE 0 END)numeric, 2) AS top3_states_revenue,
    ROUND(SUM(total_revenue)numeric, 2) AS total_revenue,
    ROUND((100.0  SUM(CASE WHEN state_rank = 3 THEN total_revenue ELSE 0 END)  SUM(total_revenue))numeric, 1) AS pct_revenue_from_top3_states
FROM (
    SELECT 
        customer_state,
        SUM(price) AS total_revenue,
        ROW_NUMBER() OVER (ORDER BY SUM(price) DESC) AS state_rank
    FROM olist.v_master_orders
    WHERE order_purchase_timestamp = '2017-01-01' AND order_purchase_timestamp  '2018-01-01'
    GROUP BY customer_state
) AS ranked_states;