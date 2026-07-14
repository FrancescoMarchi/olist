-- ============================================
-- Revenue Opportunity Sizing (FY2017)
-- Purpose: Quantify the scale of two growth opportunities 
-- identified in the core analysis (Blocks 2 and 6), using 
-- conservative, clearly-labeled "what if" scenarios.
--
-- IMPORTANT: These are NOT predictive forecasts. This is 
-- historical, observational data - no controlled experiment 
-- (e.g., A/B test) was run to validate these scenarios. The 
-- figures below illustrate the scale of opportunity based on 
-- real, current numbers, not a guaranteed outcome of any action.
-- ============================================


-- ============================================
-- Scenario 1: Cross-sell / basket-building opportunity
-- Source figures: Block 2 (Order Structure)
-- ============================================

-- Step 1: Average item price across 2017
SELECT ROUND(AVG(price)::numeric, 2) AS avg_item_price
FROM olist.v_master_orders
WHERE order_purchase_timestamp >= '2017-01-01' AND order_purchase_timestamp < '2018-01-01';
-- Result: $121.02

-- Reference figures already established in Block 2:
-- Single-item orders: 40,135
-- Total 2017 revenue: $6,155,860 (Block 3)

-- Scenario math (calculated manually from the figures above):
-- At 10% conversion: 40,135 * 0.10 = 4,014 orders add 1 item each
-- Incremental revenue: 4,014 * $121.02 = $485,796
-- As % of total revenue: $485,796 / $6,155,860 ≈ 7.9%

-- FINDING: If 10% of single-item orders added one more average-priced 
-- item, this would add approximately $485,796 in revenue - a 7.9% 
-- uplift on 2017's total.


-- ============================================
-- Scenario 2: Geographic long-tail opportunity
-- Source figures: Block 6 (Geographic Revenue)
-- ============================================

-- Step 1: Combined revenue from all states EXCEPT the top 3 (SP, RJ, MG)
SELECT SUM(total_revenue) AS long_tail_revenue
FROM (
    SELECT customer_state, SUM(price) AS total_revenue
    FROM olist.v_master_orders
    WHERE order_purchase_timestamp >= '2017-01-01' AND order_purchase_timestamp < '2018-01-01'
    GROUP BY customer_state
    ORDER BY total_revenue DESC
    OFFSET 3
) AS remaining_states;
-- Result: $2,313,898 (combined revenue across 24 states)
-- Average per state: $2,313,898 / 24 ≈ $96,412
-- (compare to MG, the 3rd-largest state alone: $723,227 - Block 6)

-- Scenario math (calculated manually from the figures above):
-- A 10% uplift across this long tail: $2,313,898 * 0.10 = $231,390
-- As % of total revenue: $231,390 / $6,155,860 ≈ 3.8%

-- FINDING: Even a modest 10% uplift across the 24 non-top-3 states 
-- would add approximately $231,390 - a 3.8% uplift on 2017's total 
-- revenue. Worth investigating whether this gap reflects genuine 
-- lower demand or a marketing/logistics reach limitation.


-- ============================================
-- Combined potential (Scenario 1 + Scenario 2)
-- ============================================
-- $485,796 + $231,390 = $717,186
-- $717,186 / $6,155,860 ≈ 11.7%

-- FINDING: Together, these two conservative scenarios represent 
-- roughly $717,000 in potential incremental revenue - about 11.7% 
-- of 2017's total - without requiring a single new customer 
-- acquisition channel, purely from optimizing existing order and 
-- geographic behavior.