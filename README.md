# 🛒 Bloom Mart Retail Sales Analysis

## 📊 Retail Sales Analytics Project — Nigeria, 2025

This project analyzes retail sales data from **Bloom Mart**, a fictional Nigerian retail business, to identify revenue trends, regional performance, product category performance, and opportunities for business improvement.

The project demonstrates a complete data analytics workflow, starting from raw data quality assessment and SQL analysis through Excel data cleaning and Power BI dashboard development.

---

## 📌 Project Overview

Bloom Mart operates across multiple Nigerian locations and sells products across several retail categories.

The objective of this project is to transform raw retail transaction data into meaningful business insights that can support management decision-making.

### Business Questions

The analysis focuses on questions such as:

- How much revenue did Bloom Mart generate?
- Which region generated the highest revenue?
- Which product categories performed best?
- Which months generated the highest and lowest revenue?
- Are there data quality issues that could affect analysis?
- How can Bloom Mart improve revenue performance?

---

# 🎯 Project Objectives

The main objectives were to:

1. Audit the quality of the raw retail sales data.
2. Identify duplicates and missing values.
3. Standardize inconsistent data.
4. Validate sales and revenue calculations.
5. Analyze revenue by region.
6. Analyze revenue by product category.
7. Analyze monthly revenue trends.
8. Build summary tables using Excel PivotTables.
9. Create an interactive Power BI dashboard.
10. Generate actionable business insights and recommendations.

---

# 🛠️ Tools & Technologies

| Tool | Purpose |
|---|---|
| PostgreSQL | Data quality audit and SQL analysis |
| Excel | Data cleaning, validation and analysis |
| Power Query | Data transformation and cleaning |
| Excel PivotTables | Revenue summaries |
| Excel Charts | Visual analysis |
| Power BI | Interactive dashboard |
| GitHub | Project documentation and portfolio |

---

# 🔄 Project Workflow

The project followed this workflow:

Raw Dataset  
↓  
PostgreSQL Data Quality Audit  
↓  
SQL Analysis  
↓  
Excel Data Cleaning  
↓  
Power Query Transformation  
↓  
PivotTable Analysis  
↓  
Excel Charts  
↓  
Power BI Data Modeling & Dashboard  
↓  
Business Insights & Recommendations  
↓  
GitHub Portfolio

---

# 🗄️ 1. PostgreSQL Data Quality Audit

The raw retail sales dataset was first examined using PostgreSQL.

The audit focused on:

- Duplicate Order IDs
- Missing values
- Invalid dates
- Inconsistent region names
- Inconsistent product categories
- Suspicious numerical values
- Revenue validation
- Overall record count

SQL was also used to answer business questions and validate the results later reproduced in Excel and Power BI.

### Example SQL Analysis

```sql
SELECT
    COUNT(*) AS transactions,
    SUM(total_sales_ngn) AS total_revenue,
    AVG(total_sales_ngn) AS average_sale,
    MAX(total_sales_ngn) AS highest_sale,
    MIN(total_sales_ngn) AS lowest_sale
FROM retail_sales;