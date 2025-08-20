COPY RETAIL_SALES(transactions_id,sale_date,sale_time,customer_id,gender,age,category,quantiy,price_per_unit,cogs,total_sale)
FROM 'C:\Program Files\PostgreSQL\17\data\SQL - Retail Sales Analysis_utf .csv'
DELIMITER','
CSV HEADER;
ALTER TABLE retail_sales
ALTER COLUMN cogs TYPE NUMERIC;

COPY RETAIL_SALES(transactions_id, sale_date, sale_time, customer_id, gender, age, category, quantiy, price_per_unit,cogs, total_Sale)
FROM 'C:\Program Files\PostgreSQL\17\data\SQL - Retail Sales Analysis_utf .csv'
DELIMITER ','
CSV HEADER;
select* from RETAIL_SALES;
--
SELECT * FROM RETAIL_SALES
WHERE transactions_id is null
--
SELECT * FROM RETAIL_SALES
WHERE sale_date is null

--
SELECT * FROM RETAIL_SALES
WHERE 
    transactions_id is null
     or
	 sale_date is null
	 or
	 sale_time is null
	 or
	 gender is null
	 or 
     category is null
	 or
	 quantiy is null
	 or
	 price_per_unit is null
	 or
	 cogs is null
	 or 
	 total_sale is null
	 -- DATA CLEANING
	 delete from RETAIL_SALES
	 WHERE 
    transactions_id is null
     or
	 sale_date is null
	 or
	 sale_time is null
	 or
	 gender is null
	 or 
     category is null
	 or
	 quantiy is null
	 or
	 price_per_unit is null
	 or
	 cogs is null
	 or 
	 total_sale is null
	 SELECT COUNT(*)
	 FROM RETAIL_SALES
	 -- DATA EXPLORATION
	 -- HOW MANY unique customer  WE HAVE
	 SELECT COUNT(DISTINCT customer_id) AS total_sale from RETAIL_SALES
	 
-- unique category
	  SELECT DISTINCT category  from RETAIL_SALES
	  -- data analysis &  business key problems
	  -- SELECT COUNT(DISTINCT customer_id) AS total_sale from RETAIL_SALES
	  select * from RETAIL_SALES
	  WHERE sale_date='2022-11-05';
	  --Retrieve all transactions where the category is 'Clothing' and the quantity sold is more than or equal to 4 in the month of Nov-2022.
	  select* from RETAIL_SALES
	  WHERE category='Clothing'
	  and to_char(sale_date,'yyyy-mm')='2022-11'
	  and quantiy>=4;

--Calculate the total sales (total_sale) for each category.
select 
category,
sum(total_sale) as net_sale,
count(*) as total_orders
from RETAIL_SALES
group by category;

--Find the average age of customers who purchased items from the 'Beauty' category.
SELECT
    ROUND(AVG(age), 2) AS avg_age
FROM RETAIL_SALES
WHERE category = 'Beauty';

--Find all transactions where the total_sale is greater than 1000.
select * from RETAIL_SALES
WHERE total_sale>1000;

--Find the total number of transactions (transaction_id) made by each gender in each category.
select gender,
category,
count(*) as transaction_id
from RETAIL_SALES
GROUP BY gender,category;

--Calculate the average sale for each month and find out the best selling month in each year.
select year,month,avg_sale
from(
select
 TO_CHAR (sale_date,'mon') as month,
 TO_CHAR (sale_date,'yyyy') as year,
 avg(total_sale) as avg_sale,
 rank() over(partition by TO_CHAR (sale_date,'yyyy') 
 order by avg(total_sale)desc)as best_seller
from RETAIL_SALES
group by  TO_CHAR (sale_date,'yyyy'),
          TO_CHAR (sale_date,'mon')

) ranked
where best_seller=1
order by year;


--Find the top 5 customers based on the highest total sales.
select 
customer_id,
sum(total_sale) as total_sales
from RETAIL_SALES
GROUP BY customer_id
ORDER BY total_sales desc
limit 5;

--Find the number of unique customers who purchased items from each category.
select 
category,
count(distinct customer_id) as unique_customer
from RETAIL_SALES
group by category;

--Create each shift and number of orders (Morning <12, Afternoon between 12 & 17, Evening >17).
select 
case 
when extract(hour from sale_time)<12 then 'morning'
when extract(hour from sale_time) between 12 and 17 then 'afternoon'
else 'evening'
end as shift,
count(*) as number_of_orders
from RETAIL_SALES
GROUP BY shift
order by shift;


