-- ============================================================
-- Capstone Project: Fuel Cost Impact on Trucking Operations
-- Author: Jacquelyn L Pickard
-- Tool: SQLite (compatible with BigQuery / PostgreSQL with minor adjustments)
-- Description: All SQL queries used in Phase 3 (Process) and Phase 4 (Analyze)
-- ============================================================


-- ============================================================
-- SECTION 1: DATA EXPLORATION
-- Goal: Understand the shape and quality of the raw data before cleaning
-- ============================================================

-- 1.1 Preview the diesel price table
-- What it does: Shows the first 10 rows so we can confirm columns loaded correctly
SELECT *
FROM diesel_prices
LIMIT 10;


-- 1.2 Count total records and date range
-- What it does: Tells us how many weeks of data we have and what years are covered
SELECT
    COUNT(*)            AS total_records,
    MIN(date)           AS earliest_date,
    MAX(date)           AS latest_date
FROM diesel_prices;


-- 1.3 Check for missing (NULL) values by column
-- What it does: Flags any columns with gaps we need to handle during cleaning
SELECT
    COUNT(*) - COUNT(national_price)    AS missing_national,
    COUNT(*) - COUNT(east_coast)        AS missing_east_coast,
    COUNT(*) - COUNT(midwest)           AS missing_midwest,
    COUNT(*) - COUNT(gulf_coast)        AS missing_gulf_coast,
    COUNT(*) - COUNT(rocky_mountain)    AS missing_rocky_mtn,
    COUNT(*) - COUNT(west_coast)        AS missing_west_coast
FROM diesel_prices;


-- 1.4 Check for duplicate dates
-- What it does: Ensures we don't have the same week recorded twice
SELECT
    date,
    COUNT(*) AS occurrences
FROM diesel_prices
GROUP BY date
HAVING COUNT(*) > 1
ORDER BY date;


-- ============================================================
-- SECTION 2: CLEANING QUERIES
-- Goal: Prepare data for analysis by standardizing and filtering
-- ============================================================

-- 2.1 Remove rows with NULL national price
-- What it does: Drops the small number of weeks where no national price was recorded
-- Note: We keep regional NULLs since not all regions reported in early years
DELETE FROM diesel_prices
WHERE national_price IS NULL;


-- 2.2 Create a clean working table with parsed date parts
-- What it does: Adds year, month, and quarter columns so we can group by time period easily
CREATE TABLE diesel_prices_clean AS
SELECT
    date,
    CAST(strftime('%Y', date) AS INTEGER)   AS year,
    CAST(strftime('%m', date) AS INTEGER)   AS month,
    CASE
        WHEN CAST(strftime('%m', date) AS INTEGER) BETWEEN 1 AND 3  THEN 'Q1'
        WHEN CAST(strftime('%m', date) AS INTEGER) BETWEEN 4 AND 6  THEN 'Q2'
        WHEN CAST(strftime('%m', date) AS INTEGER) BETWEEN 7 AND 9  THEN 'Q3'
        ELSE 'Q4'
    END                                     AS quarter,
    national_price,
    east_coast,
    midwest,
    gulf_coast,
    rocky_mountain,
    west_coast
FROM diesel_prices
ORDER BY date ASC;


-- ============================================================
-- SECTION 3: TREND ANALYSIS
-- Goal: Understand how diesel prices have changed over time
-- ============================================================

-- 3.1 Annual average national diesel price
-- What it does: Summarizes each year into a single average price
-- Why it matters: Shows the long-term trend clearly for non-technical readers
SELECT
    year,
    ROUND(AVG(national_price), 3)   AS avg_national_price,
    ROUND(MIN(national_price), 3)   AS min_price,
    ROUND(MAX(national_price), 3)   AS max_price,
    ROUND(MAX(national_price) - MIN(national_price), 3) AS price_range
FROM diesel_prices_clean
GROUP BY year
ORDER BY year;


-- 3.2 Year-over-year price change
-- What it does: Calculates how much prices changed from one year to the next
-- Why it matters: Helps identify which years had the most dramatic impact on operations
SELECT
    year,
    ROUND(AVG(national_price), 3) AS avg_price,
    ROUND(AVG(national_price) - LAG(AVG(national_price)) OVER (ORDER BY year), 3) AS yoy_change,
    ROUND(
        (AVG(national_price) - LAG(AVG(national_price)) OVER (ORDER BY year))
        / LAG(AVG(national_price)) OVER (ORDER BY year) * 100, 1
    ) AS yoy_pct_change
FROM diesel_prices_clean
GROUP BY year
ORDER BY year;


-- ============================================================
-- SECTION 4: SEASONAL ANALYSIS
-- Goal: Find recurring monthly/quarterly price patterns
-- ============================================================

-- 4.1 Average price by month (across all years)
-- What it does: Shows which months are historically cheapest and most expensive
-- Why it matters: Helps operations teams anticipate when to hedge or tighten budgets
SELECT
    month,
    CASE month
        WHEN 1 THEN 'January'   WHEN 2 THEN 'February'
        WHEN 3 THEN 'March'     WHEN 4 THEN 'April'
        WHEN 5 THEN 'May'       WHEN 6 THEN 'June'
        WHEN 7 THEN 'July'      WHEN 8 THEN 'August'
        WHEN 9 THEN 'September' WHEN 10 THEN 'October'
        WHEN 11 THEN 'November' WHEN 12 THEN 'December'
    END AS month_name,
    ROUND(AVG(national_price), 3) AS avg_price_all_years
FROM diesel_prices_clean
GROUP BY month
ORDER BY month;


-- 4.2 Average price by quarter
-- What it does: Summarizes seasonal patterns into four business-planning periods
SELECT
    quarter,
    ROUND(AVG(national_price), 3) AS avg_national_price,
    ROUND(AVG(gulf_coast), 3)     AS avg_gulf_coast,
    ROUND(AVG(west_coast), 3)     AS avg_west_coast
FROM diesel_prices_clean
GROUP BY quarter
ORDER BY quarter;


-- ============================================================
-- SECTION 5: REGIONAL ANALYSIS
-- Goal: Compare diesel prices across U.S. regions
-- ============================================================

-- 5.1 All-time average price by region
-- What it does: Shows which regions consistently pay more or less for diesel
-- Why it matters: Lane profitability analysis should account for these structural differences
SELECT
    ROUND(AVG(east_coast), 3)       AS avg_east_coast,
    ROUND(AVG(midwest), 3)          AS avg_midwest,
    ROUND(AVG(gulf_coast), 3)       AS avg_gulf_coast,
    ROUND(AVG(rocky_mountain), 3)   AS avg_rocky_mtn,
    ROUND(AVG(west_coast), 3)       AS avg_west_coast,
    ROUND(AVG(national_price), 3)   AS avg_national
FROM diesel_prices_clean;


-- 5.2 West Coast premium over Gulf Coast (the most expensive vs. cheapest)
-- What it does: Calculates the cost difference carriers face on transcontinental lanes
-- Why it matters: A $0.40/gal premium over 600 miles at 6mpg = ~$40 extra per load
SELECT
    year,
    ROUND(AVG(west_coast), 3)   AS avg_west_coast,
    ROUND(AVG(gulf_coast), 3)   AS avg_gulf_coast,
    ROUND(AVG(west_coast) - AVG(gulf_coast), 3) AS west_coast_premium
FROM diesel_prices_clean
GROUP BY year
ORDER BY year;


-- ============================================================
-- SECTION 6: VOLATILITY ANALYSIS
-- Goal: Measure price instability over time
-- ============================================================

-- 6.1 Standard deviation of weekly prices by year
-- What it does: Measures how "jumpy" prices were in each year
-- Why it matters: High volatility years = harder to budget; lower = more predictable
SELECT
    year,
    ROUND(AVG(national_price), 3)   AS avg_price,
    -- SQLite doesn't have built-in STDDEV; Python handles this in the notebook
    ROUND(MAX(national_price) - MIN(national_price), 3) AS price_range,
    COUNT(*) AS weeks_of_data
FROM diesel_prices_clean
GROUP BY year
ORDER BY year;


-- 6.2 Identify the 10 biggest single-week price jumps
-- What it does: Surfaces the most extreme price shock weeks in the dataset
-- Why it matters: These events stress-test fuel surcharge and budgeting policies
SELECT
    date,
    national_price,
    LAG(national_price) OVER (ORDER BY date) AS prev_week_price,
    ROUND(national_price - LAG(national_price) OVER (ORDER BY date), 3) AS week_over_week_change
FROM diesel_prices_clean
ORDER BY ABS(national_price - LAG(national_price) OVER (ORDER BY date)) DESC
LIMIT 10;


-- ============================================================
-- SECTION 7: JOINING WITH OPERATIONAL COST DATA
-- Goal: Correlate diesel prices with trucking cost-per-mile
-- ============================================================

-- 7.1 Join annual diesel average with ATRI operational cost data
-- What it does: Creates a combined table we can use for correlation analysis
-- Why it matters: Tests whether higher fuel prices actually raise total cost per mile
SELECT
    d.year,
    ROUND(AVG(d.national_price), 3) AS avg_diesel_price,
    o.fuel_cost_per_mile,
    o.total_cost_per_mile,
    ROUND(o.fuel_cost_per_mile / o.total_cost_per_mile * 100, 1) AS fuel_pct_of_total
FROM diesel_prices_clean d
JOIN operational_costs o ON d.year = o.year
GROUP BY d.year, o.fuel_cost_per_mile, o.total_cost_per_mile
ORDER BY d.year;