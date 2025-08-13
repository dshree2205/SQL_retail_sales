CREATE DATABASE p1_retail_db;
drop database pizzhut;

CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);
SELECT * FROM retail_sales
LIMIT 10;
SELECT 
COUNT(*)
 FROM retail_sales;
 SELECT * FROM retail_sales
 WHERE transactions_id IS NULL;
SELECT * FROM retail_sales
WHERE sale_date IS NULL;
SELECT * FROM retail_sales
WHERE sale_time IS NULL;
SELECT * FROM retail_sales
WHERE
     transactions_id IS NULL
     OR
     sale_date IS NULL
     OR 
     sale_time IS NULL
     OR 
     gender IS NULL
     OR 
     category IS NULL
     OR 
     quantity IS NULL
     OR
     cogs IS NULL
     OR 
     total_sale IS NULL;
     
     
     

##DATA EXPLORATION 
##HOW MANY SALES WE HAVE ?
SELECT COUNT(*) AS total_sale FROM retail_sales;
##how many uniuque customer we have ?
select count(DISTINCT customer_id) as total_sales from retail_sales;

SELECT DISTINCT category FROM retail_sales;

##DATA aNALYSIS & BUSINESS KEY PROBLEMS &ANSWERS.
##Write a SQL query to retrieve all columns for sales made on '2022-11-05:
SELECT * 
FROM retail_sales 
WHERE sale_date = '2022-11-05';
##Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
SELECT *  
FROM retail_sales  
WHERE category = 'Clothing'  
  AND DATE_FORMAT(sale_date, '%Y-%m') = '2022-11'  
  AND quantity >= 4;
##Q3.Write a SQL query to calculate the total sales (total_sale) for each category.:
SELECT
  category,
  SUM(total_sale) AS net_sale,
  COUNT(*) AS total_orders
FROM retail_sales
GROUP BY category;

##4.Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:
SELECT 
ROUND(AVG(age), 2) as avg_age
FROM retail_sales
WHERE category = 'Beauty';
##5.Write a SQL query to find all transactions where the total_sale is greater than 1000
SELECT *FROM retail_sales
WHERE total_sale> 1000;
##6.Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:
SELECT 
category,
gender,
count(*) as total_trans
from retail_sales
group by
category,
gender
order by 1 ;
##7.Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:
SELECT 
    year,
    month,
    avg_sale
FROM 
(
    SELECT 
        YEAR(sale_date) AS year,
        MONTH(sale_date) AS month,
        AVG(total_sale) AS avg_sale,
        RANK() OVER (PARTITION BY YEAR(sale_date) ORDER BY AVG(total_sale) DESC) AS `rank`
    FROM retail_sales
    GROUP BY year, month
) AS t1
WHERE `rank` = 1;
#8.**Write a SQL query to find the top 5 customers based on the highest total sales **:
SELECT 
    customer_id,
    SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5
##9Write a SQL query to find the number of unique customers who purchased items from each category.:
SELECT 
    category,    
    COUNT(DISTINCT customer_id) AS cnt_unique_cs
FROM retail_sales
GROUP BY category
ORDER BY cnt_unique_cs DESC;

###10.Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):
WITH hourly_sale AS (
    SELECT *,
        CASE
            WHEN HOUR(sale_time) < 12 THEN 'Morning'
            WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
        END AS shift
    FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) AS total_orders    
FROM hourly_sale
GROUP BY shift;
