# 📊 E-Commerce Revenue & Product Analytics
> **Revenue is growing, but concentrated in a handful of categories, states, and one-time buyers — here's where the business should focus next.**

Full analytics pipeline: **PostgreSQL → Python (pandas) → Power BI**

---

# 🧭 Executive Summary

This project analyzes one year (FY2017) of order-level data from Olist, a Brazilian e-commerce marketplace, to understand what drives revenue and where the business is exposed to concentration risk.

Through **SQL-based analysis**, **light Python feature engineering**, and a **two-page Power BI executive dashboard**, the analysis reveals:

- **Revenue grew roughly 6x** over the course of 2017, with a sharp November spike likely tied to Black Friday
- **Product revenue is highly concentrated** — the top 15 of 73 categories generate 77.7% of total revenue
- **Geographic revenue is even more concentrated** — just 3 of 27 states (São Paulo, Rio de Janeiro, Minas Gerais) generate 62.4% of revenue, with São Paulo alone outselling the next two states combined
- **The business is acquisition-driven, not retention-driven** — 90% of orders are single-item, and only 2.8% of customers made more than one purchase in the year

The result is a clear, evidence-based picture of where this business's revenue actually comes from, and where it's most exposed if that concentration were to shift.

---

# 🧩 Business Question

**How can this e-commerce company increase revenue by optimizing product performance and order behavior?**

This is broken down into four analytical focus areas:

1. **Product performance** — which categories/products drive revenue, and which underperform?
2. **Order structure** — how big is a typical order, and how much revenue does it generate?
3. **Revenue concentration** — is revenue spread evenly, or concentrated in a few contributors?
4. **Purchase patterns** — do customers return, or is this a one-time-purchase business?

Two additional angles were added during the project to deepen the analysis: **revenue trend over time** and **geographic concentration**.

*Explicitly out of scope: customer retention/churn modeling, RFM segmentation, and marketing ROI — these are covered in a separate, related project (see "Relationship to Other Projects" below).*

---

# 📁 Dataset

**Source:** [Brazilian E-Commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) (Kaggle)

Of the 9 available tables, 6 were used:
- `orders` — one row per order (status, timestamps, customer link)
- `order_items` — one row per item within an order (price, freight, product link) — the most granular table, used as the analytical base
- `products` — product category and attributes
- `customers` — customer location and unique customer identifier
- `order_payments` — payment details (imported and cleaned, not used in final analysis)
- `product_category_name_translation` — category name lookup (Portuguese → English reference)

`geolocation` and `order_reviews` were excluded — out of scope for this project's focus areas.

**Analysis timeframe:** Full calendar year 2017 (Jan 1 – Dec 31). Chosen for completeness and clarity — the dataset's early months (Sept–Dec 2016) have very low order volume (a ramp-up period), and the final available month (Sept 2018) is a partial, cut-off month. 2017 is the first full, stable calendar year in the data.

---

# ⚙️ Workflow Overview

## 1️⃣ Data Understanding & Cleaning (PostgreSQL)

- Mapped table relationships and grain before writing any analysis
- Fixed column types across all tables (CSV imports default every column to text, including dates)
- Handled the distinction between empty strings (`''`) and true `NULL` values throughout
- Built a single analytical view (`v_master_orders`) joining item-level data with order, product, and customer information

## 2️⃣ SQL Analysis (6 blocks)

- **Product Performance** — revenue, volume, and average price by category (top and bottom performers)
- **Order Structure** — items per order and revenue per order
- **Revenue Concentration** — Pareto (80/20-style) analysis by category
- **Purchase Patterns** — repeat customer rate
- **Revenue Trend** — monthly revenue across the year
- **Geographic Revenue** — revenue by customer state, with concentration analysis

## 3️⃣ Light Python (pandas)

- Exported the master view and performed light cleaning/feature engineering: proper date typing, a `year_month` field for time-based analysis, and a `single_item_order` flag
- Kept intentionally minimal — SQL remained the primary analysis engine throughout, consistent with the project's scope

## 4️⃣ Power BI Dashboard

- Two-page executive dashboard, connected live to PostgreSQL
- Insight-driven headlines and subtitles on each page, KPI cards, annotated charts
- Deliberately simpler data model than a star schema — a single flat analytical view, appropriate for this project's scope (see note below)

---

# 🔎 A Note on Data Quality

A significant, unplanned part of this project was discovering and resolving a data integrity issue: **3 of the 6 imported tables (`order_items`, `customers`, `order_payments`) had been accidentally duplicated during initial CSV import** — each containing exactly double its expected row count.

This was caught progressively, not all at once:
- The `order_items` duplication was caught early, during initial data exploration, by comparing the imported row count against the known correct dataset size
- The `customers` duplication was only discovered much later, while connecting Power BI — and its effects had already silently propagated into two SQL analysis blocks (Revenue Trend and Geographic Revenue) that were built *after* `customers` was joined into the master view but *before* the duplication was known about. Every dollar figure in those two blocks was, temporarily, exactly double the correct value.
- A full integrity sweep across all six tables caught the third instance (`order_payments`), unused in the final analysis but fixed for consistency

**Why this matters:** none of these bugs produced an error message. Every query ran successfully and every chart rendered plausibly — the only way to catch them was by cross-checking numbers against independently known reference values (the published dataset's documented row counts, and totals calculated at different points in the project). All affected figures were identified, corrected, and re-verified before being included in the final analysis below. A full log of this process, along with 23 other technical lessons from the project, is available in `docs/lessons_log.md`.

---

# 🧠 Key Findings

## 1️⃣ Revenue grew significantly across 2017 — with a clear seasonal spike

Monthly revenue grew roughly **6x** from January (~$120K) to the year's later months, with **November standing out at ~$1.01M** — about 52% above October and 36% above December. This is a plausible Black Friday effect, based on timing, though not confirmed by an explicit event flag in the data.

## 2️⃣ Revenue is heavily concentrated by product category

The **top 15 of 73 categories generate 77.7% of total revenue** — a near-textbook Pareto pattern. At the other extreme, the lowest-performing category generated just $152 across the entire year, roughly 3,278x less than the top category.

## 3️⃣ Revenue is even more concentrated by geography

Just **3 of 27 states — São Paulo, Rio de Janeiro, and Minas Gerais — generate 62.4% of all revenue.** São Paulo alone ($2.21M) outsells the next two states *combined* ($1.63M).

## 4️⃣ This is an acquisition-driven business, not a retention-driven one

**90% of orders contain exactly one item** (average: 1.14 items/order), and **only 2.8% of customers made more than one purchase** in 2017 (average: 1.03 orders/customer). Combined, these findings point to a business that depends heavily on constantly acquiring new, one-time buyers rather than deepening existing customer relationships.

---

# 📊 Power BI Dashboard

## Page 1 — Executive Summary
*"Revenue Is Growing, But Concentrated in Few Categories and Repeat Buyers Are Rare"*

![Executive Summary](docs/visuals/dashboard_page1_executive_summary.png)

KPI cards (Total Revenue, Avg Revenue per Order, % Single-Item Orders, % Repeat Customers), a Monthly Revenue Trend chart annotated with the November seasonal spike, and a Revenue Concentration (Pareto) chart with the top-15 threshold highlighted directly on the data.

## Page 2 — Product & Geography Deep Dive
*"São Paulo and a Handful of Categories Drive the Business"*

![Product & Geography Deep Dive](docs/visuals/dashboard_page2_product_geography.png)

Revenue by State and Top 10 Categories by Revenue, both with data labels and concentration call-outs, showing exactly where the top-line findings come from.

*(See `/bi` folder for the .pbix file.)*

---

# 🚀 Recommendations

Recommendations 1 and 2 below are sized using conservative, clearly-labeled "what if" scenarios calculated directly from this dataset — not predictive forecasts. They are meant to illustrate the *scale* of opportunity, not guarantee an outcome; no controlled experiment (e.g., A/B test) was run to validate them, since this is historical, observational data rather than experimental data.

1. **Invest in cross-sell and bundling strategies.**
With 90% of orders single-item (average basket size: 1.14 items), there is substantial, quantifiable room to grow revenue per order. **If just 10% of single-item orders (4,014 of 40,135) added one more average-priced item ($121.02), that would add approximately $485,796 in revenue — a 7.9% uplift on 2017's total.** Tactically: "frequently bought together" prompts, bundle discounts, or free-shipping thresholds tied to a second item.

2. **Investigate and invest in the geographic long tail.**
The 24 states outside the top 3 (SP, RJ, MG) generate just $2.31M combined — averaging only $96K per state, a fraction of 3rd-place MG's $723K. **Even a modest 10% uplift across this long tail would add approximately $231,390 — a 3.8% uplift** on 2017's total revenue. This is worth investigating specifically: is this a genuine demand gap, or a marketing/logistics reach problem?

   **Combined, these two conservative scenarios represent roughly $717,000 in potential incremental revenue — about 11.7% of 2017's total — without requiring a single new customer acquisition channel.**

3. **Treat the top 15 categories as strategic priorities.** These categories drive 77.7% of revenue; inventory reliability, marketing spend, and seller support should be weighted accordingly. The bottom-performing categories are candidates for review — either discontinuation or investigation into why they're underperforming (visibility, pricing, or genuine low demand).

4. **Build toward a repeat-purchase strategy.** A 2.8% repeat rate is low for an e-commerce business; even modest improvements here (post-purchase email flows, loyalty incentives, replenishment reminders for consumable categories) could meaningfully shift the revenue mix from acquisition-dependent to retention-supported.

5. **Prepare proactively for seasonal demand.** The November spike suggests seasonal events (e.g., Black Friday) meaningfully move revenue — inventory and logistics planning should anticipate this rather than react to it.

---

# 🧰 Tools & Technologies

- **Database:** PostgreSQL
- **Analysis:** SQL (primary engine — joins, aggregations, window functions, CTEs)
- **Light transformation:** Python (pandas)
- **BI:** Power BI (DAX measures, live PostgreSQL connection)
- **Data Types:** Text, Numeric, Timestamp, Boolean

---

# 📁 Repository Structure

    olist-ecommerce-analytics/
    │
    ├── bi/                 → Power BI (.pbix) file & dashboard screenshots
    ├── data/                → Exported CSVs (cleaned, feature-engineered)
    ├── docs/
    │   └── lessons_log.md  → Full technical lessons log (24 entries)
    ├── python/              → clean_features.py
    ├── sql/
    │   ├── 01_data_cleaning.sql
    │   ├── 02_master_query.sql
    │   ├── 03_product_performance.sql
    │   ├── 04_order_structure.sql
    │   ├── 05_revenue_concentration.sql
    │   ├── 06_purchase_patterns.sql
    │   ├── 07_revenue_trend.sql
    │   └── 08_geographic_revenue.sql
    └── README.md

---

# 🔗 Relationship to Other Projects

This project is deliberately scoped to complement, not duplicate, a related project analyzing **customer churn and retention** for a telecom company (see that project's README for details — star-schema data model, cohort/tenure analysis, risk segmentation). 

Where that project asks *"why do customers leave, and who's at risk?"*, this project asks *"where does revenue actually come from, and how concentrated is it?"* — together, they demonstrate both customer-lifecycle analytics and commercial/revenue analytics capability.

---

# 💬 Summary

This project demonstrates a complete analytics workflow:

> **SQL analysis → light Python feature engineering → Power BI storytelling**

Beyond the technical execution, it reflects a methodical, evidence-based approach to analysis — including catching, diagnosing, and correcting a real data integrity issue mid-project, and re-verifying every downstream finding once it was fixed, rather than assuming a single fix was sufficient.

---

**Author:** Francesco Marchì
📍 Ho Chi Minh City, Vietnam
📧 marchi.frncsc@gmail.com
🔗 LinkedIn: https://www.linkedin.com/in/francesco-march%C3%AC-115657205/
