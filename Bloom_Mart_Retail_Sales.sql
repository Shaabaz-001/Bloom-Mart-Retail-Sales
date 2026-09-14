-- Bloom Mart Retail Sales Analysis
-- PostgreSQL | Table creation
-- Source dataset: retail_sales.csv
-- Purpose: create the table for the retail sales project.

DROP TABLE IF EXISTS retail_sales;

CREATE TABLE retail_sales (
    order_id VARCHAR(20),
    order_date DATE,
    region VARCHAR(50),
    store_name VARCHAR(100),
    product_category VARCHAR(100),
    product_name VARCHAR(150),
    quantity INT,
    unit_price_ngn NUMERIC(12,2),
    total_sales_ngn NUMERIC(14,2),
    customer_segment VARCHAR(50)
);

-- Verify the table structure after importing the CSV:
-- SELECT * FROM retail_sales LIMIT 10;
SELECT * FROM retail_sales LIMIT 10;

-- SELECT COUNT(*) FROM retail_sales;
SELECT COUNT(*) FROM retail_sales;


- Bloom Mart Retail Sales Analysis
-- PostgreSQL | Data Quality Audit
-- Purpose: inspect the raw/staging data before analysis.

-- 1. Overall row and order-ID check
SELECT
    COUNT(*) AS total_rows,
    COUNT(order_id) AS non_null_order_ids,
    COUNT(DISTINCT order_id) AS unique_order_ids
FROM retail_sales;

-- 2. Duplicate order IDs
SELECT
    order_id,
    COUNT(*) AS duplicate_count
FROM retail_sales
WHERE order_id IS NOT NULL
GROUP BY order_id
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC, order_id;

-- 3. Missing values across the main fields
SELECT
    COUNT(*) FILTER (WHERE order_id IS NULL OR BTRIM(order_id) = '') AS missing_order_id,
    COUNT(*) FILTER (WHERE order_date IS NULL) AS missing_order_date,
    COUNT(*) FILTER (WHERE region IS NULL OR BTRIM(region) = '') AS missing_region,
    COUNT(*) FILTER (WHERE store_name IS NULL OR BTRIM(store_name) = '') AS missing_store_name,
    COUNT(*) FILTER (WHERE product_category IS NULL OR BTRIM(product_category) = '') AS missing_category,
    COUNT(*) FILTER (WHERE product_name IS NULL OR BTRIM(product_name) = '') AS missing_product_name,
    COUNT(*) FILTER (WHERE quantity IS NULL) AS missing_quantity,
    COUNT(*) FILTER (WHERE unit_price_ngn IS NULL) AS missing_unit_price,
    COUNT(*) FILTER (WHERE total_sales_ngn IS NULL) AS missing_total_sales,
    COUNT(*) FILTER (WHERE customer_segment IS NULL OR BTRIM(customer_segment) = '') AS missing_customer_segment
FROM retail_sales;

-- 4. Distinct regions - useful for detecting spelling/format inconsistencies
SELECT DISTINCT region
FROM retail_sales
ORDER BY region;

-- 5. Identify the known Port Harcourt variants
SELECT
    region,
    COUNT(*) AS row_count
FROM retail_sales
WHERE LOWER(REPLACE(BTRIM(region), '-', ' ')) LIKE '%port%harcourt%'
   OR LOWER(BTRIM(region)) = 'ph'
GROUP BY region
ORDER BY row_count DESC;

-- 6. Invalid/suspicious quantities
SELECT *
FROM retail_sales
WHERE quantity IS NULL OR quantity <= 0
ORDER BY order_date, order_id;

-- 7. Invalid/suspicious prices
SELECT *
FROM retail_sales
WHERE unit_price_ngn IS NULL OR unit_price_ngn <= 0
ORDER BY order_date, order_id;

-- 8. Invalid/suspicious sales amounts
SELECT *
FROM retail_sales
WHERE total_sales_ngn IS NULL OR total_sales_ngn <= 0
ORDER BY order_date, order_id;

-- 9. Validate the transaction-level revenue calculation
SELECT
    order_id,
    quantity,
    unit_price_ngn,
    total_sales_ngn,
    quantity * unit_price_ngn AS calculated_sales
FROM retail_sales
WHERE ROUND(quantity * unit_price_ngn, 2)
      <> ROUND(total_sales_ngn, 2);

-- 10. Date range
SELECT
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date
FROM retail_sales;


-- Bloom Mart Retail Sales Analysis
-- PostgreSQL | Business Analysis Queries
-- Table used after cleaning: retail_sales_clean
-- Core business questions:
-- 1. Total revenue and order count by region.
-- 2. Top five product categories by revenue.
-- 3. Monthly revenue trend.

-- =========================================================
-- BUSINESS QUESTION 1
-- Total revenue and order count by region
-- =========================================================

SELECT
    region,
    COUNT(order_id) AS order_count,
    SUM(total_sales_ngn) AS total_revenue
FROM retail_sales_clean
GROUP BY region
ORDER BY total_revenue DESC;

-- =========================================================
-- BUSINESS QUESTION 2
-- Top five product categories by revenue
-- =========================================================

SELECT
    product_category,
    SUM(total_sales_ngn) AS total_revenue
FROM retail_sales_clean
GROUP BY product_category
ORDER BY total_revenue DESC
LIMIT 5;

-- =========================================================
-- BUSINESS QUESTION 3
-- Monthly revenue trend
-- =========================================================

SELECT
    EXTRACT(YEAR FROM order_date) AS sales_year,
    EXTRACT(MONTH FROM order_date) AS month_number,
    TO_CHAR(order_date, 'Month') AS month_name,
    SUM(total_sales_ngn) AS total_revenue
FROM retail_sales_clean
GROUP BY
    EXTRACT(YEAR FROM order_date),
    EXTRACT(MONTH FROM order_date),
    TO_CHAR(order_date, 'Month')
ORDER BY sales_year, month_number;

-- =========================================================
-- Executive summary
-- =========================================================

SELECT
    COUNT(*) AS transactions,
    COUNT(DISTINCT order_id) AS unique_orders,
    SUM(quantity) AS units_sold,
    SUM(total_sales_ngn) AS total_revenue,
    ROUND(AVG(total_sales_ngn), 2) AS average_transaction,
    MAX(total_sales_ngn) AS highest_transaction,
    MIN(total_sales_ngn) AS lowest_transaction
FROM retail_sales_clean;

-- =========================================================
-- Revenue by customer segment
-- =========================================================

SELECT
    customer_segment,
    COUNT(*) AS transactions,
    SUM(total_sales_ngn) AS total_revenue,
    ROUND(AVG(total_sales_ngn), 2) AS average_transaction
FROM retail_sales_clean
GROUP BY customer_segment
ORDER BY total_revenue DESC;

-- =========================================================
-- Top 10 products by revenue
-- =========================================================

SELECT
    product_name,
    SUM(quantity) AS units_sold,
    SUM(total_sales_ngn) AS total_revenue
FROM retail_sales_clean
GROUP BY product_name
ORDER BY total_revenue DESC
LIMIT 10;


-- Bloom Mart Retail Sales Analysis
-- PostgreSQL | Revenue Reconciliation
-- Purpose: verify that SQL totals agree with the cleaned Excel analysis.

-- 1. Overall revenue reconciliation
SELECT
    COUNT(*) AS transactions,
    SUM(total_sales_ngn) AS total_revenue
FROM retail_sales_clean;


-- 2. Region-level reconciliation
SELECT
    region,
    COUNT(order_id) AS order_count,
    SUM(total_sales_ngn) AS revenue
FROM retail_sales_clean
GROUP BY region
ORDER BY revenue DESC;


-- 3. Product-category reconciliation
SELECT
    product_category,
    SUM(total_sales_ngn) AS revenue
FROM retail_sales_clean
GROUP BY product_category
ORDER BY revenue DESC;


-- 4. Monthly reconciliation
SELECT
    EXTRACT(MONTH FROM order_date)::INT AS month_number,
    TO_CHAR(order_date, 'Month') AS month_name,
    SUM(total_sales_ngn) AS revenue
FROM retail_sales_clean
GROUP BY
    EXTRACT(MONTH FROM order_date),
    TO_CHAR(order_date, 'Month')
ORDER BY month_number;


-- Expected final reconciliation from the completed Excel analysis:
-- Total Revenue = ₦27,121,239
-- Region total  = ₦27,121,239
-- Category total = ₦27,121,239
-- Monthly total = ₦27,121,239
