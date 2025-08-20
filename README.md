🛒 Retail Sales SQL Analysis

This project contains SQL scripts for analyzing a Retail Sales dataset using PostgreSQL.
It covers data import, cleaning, exploration, and business-driven analysis with real-world queries.

📂 Project Structure

retail_sales.sql → Complete SQL script (import, cleaning, queries)

⚙️ Technologies Used

PostgreSQL 17

SQL Features:

COPY for data import

CASE, GROUP BY, ORDER BY

Window functions (RANK())

Date/Time functions (TO_CHAR, EXTRACT)
## 🔑 Steps Performed  

### 1. 📥 Data Import  

```sql
COPY RETAIL_SALES(transactions_id, sale_date, sale_time, customer_id, gender, age, category, quantiy, price_per_unit, cogs, total_sale)
FROM 'C:\Program Files\PostgreSQL\17\data\SQL - Retail Sales Analysis_utf.csv'
DELIMITER ','
CSV HEADER;

ALTER TABLE retail_sales
ALTER COLUMN cogs TYPE NUMERIC;
Data loaded from CSV into RETAIL_SALES table.

Changed cogs column type to numeric.
```
### 2. 🧹 Data Cleaning

Checked for NULL values in all critical columns (transactions_id, sale_date, sale_time, gender, etc.)

Deleted rows with missing data.
```sql
DELETE FROM RETAIL_SALES
WHERE transactions_id IS NULL
   OR sale_date IS NULL
   OR sale_time IS NULL
   OR gender IS NULL
   OR category IS NULL
   OR quantiy IS NULL
   OR price_per_unit IS NULL
   OR cogs IS NULL
   OR total_sale IS NULL;
```
### 3. 🔎 Data Exploration

Count unique customers
```sql
SELECT COUNT(DISTINCT customer_id) AS total_customers
FROM RETAIL_SALES;
Unique categories
SELECT DISTINCT category
FROM RETAIL_SALES;
```
### 4. 📊 Business Analysis Queries

Transactions in Nov-2022 where category is Clothing and quantity ≥ 4
```sql
SELECT *
FROM RETAIL_SALES
WHERE category = 'Clothing'
  AND TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
  AND quantiy >= 4;
```
### Total sales by category
```sql
SELECT category,
       SUM(total_sale) AS net_sale,
       COUNT(*) AS total_orders
FROM RETAIL_SALES
GROUP BY category;
```
### Average age of Beauty customers
```sql
SELECT ROUND(AVG(age), 2) AS avg_age
FROM RETAIL_SALES
WHERE category = 'Beauty';
```
### Transactions with total_sale > 1000
```sql
SELECT *
FROM RETAIL_SALES
WHERE total_sale > 1000;
```
### Transactions by gender and category
```sql
SELECT gender,
       category,
       COUNT(*) AS transaction_count
FROM RETAIL_SALES
GROUP BY gender, category;
```
### Best selling month in each year
```sql
SELECT year, month, avg_sale
FROM (
    SELECT TO_CHAR(sale_date, 'Mon') AS month,
           TO_CHAR(sale_date, 'YYYY') AS year,
           AVG(total_sale) AS avg_sale,
           RANK() OVER (PARTITION BY TO_CHAR(sale_date, 'YYYY')
                        ORDER BY AVG(total_sale) DESC) AS best_seller
    FROM RETAIL_SALES
    GROUP BY TO_CHAR(sale_date, 'YYYY'),
             TO_CHAR(sale_date, 'Mon')
) ranked
WHERE best_seller = 1
ORDER BY year;
```

### Top 5 customers by total sales
```sql
SELECT customer_id,
       SUM(total_sale) AS total_sales
FROM RETAIL_SALES
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;

```
### Unique customers per category
```sql
SELECT category,
       COUNT(DISTINCT customer_id) AS unique_customers
FROM RETAIL_SALES
GROUP BY category;

```
### Orders by shift (Morning, Afternoon, Evening)
```sql
SELECT CASE 
           WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
           WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
           ELSE 'Evening'
       END AS shift,
       COUNT(*) AS number_of_orders
FROM RETAIL_SALES
GROUP BY shift
ORDER BY shift;
```
📌 Key Learnings

Applying SQL for real-world business insights

Using advanced SQL functions: CASE, RANK(), DISTINCT COUNT, time/date functions

Performing customer and sales segmentation

🚀 Future Improvements

Add visualizations using Python (Pandas/Matplotlib) or Power BI

Automate reporting with stored procedures

Extend dataset with marketing and inventory data

✍️ Author: [Rakesh Gupta]
📅 Project: Retail Sales SQL Analysis
