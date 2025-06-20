------ Retail Sales Analysis Project
--- Create Database
drop if exists SQL_Retail_Sales;
Create Database SQL_Retail_Sales;

--- Create Tables
drop table if exists retail_sales; -- drop in case run again while the table is already existed
Create table retail_sales (
			transactions_id	INT Primary key,	
			sale_date	DATE,
			sale_time	TIME,
			customer_id	INT,
			gender	VARCHAR(15),
			age	INT,
			category	VARCHAR(15),
			quantity	INT,
			price_per_unit	FLOAT,
			cogs	FLOAT,
			total_sale	FLOAT
)

--- check if the dataset is imported successfully
select * from retail_sales;

--- Data cleaning -- check if NULL exists in the table and delete the rows contain NULL
select * from retail_sales
where 
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
    quantity is null
    or
    cogs is null
    or
    total_sale is null;
    
-- 
DELETE from retail_sales
where 
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
    quantity is null
    or
    cogs is null
    or
    total_sale is null;

------ Data Exploration

-- How many sales are there ?
select count(*) as total_sale from retail_sales;
-- How many different customers are there ?
select count(distinct customer_id) as total_sales from retail_sales;
-- How many categories that has been sold ?
select distinct category from retail_sales;


------ Data Analysis
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'

select *
from retail_sales
where sale_date = '2022-11-05';


-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022

select 
  *
from retail_sales
where 
    category = 'Clothing'
    and 
    TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
    and
    quantity >= 4


-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

select 
    category,
    SUM(total_sale) as net_sale,
    count(*) as total_orders
from retail_sales
groupby 1

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

select
    ROUND(avg(age), 2) as avg_age
from retail_sales
where category = 'Beauty'


-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

select * from retail_sales
where total_sale > 1000


-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

select 
    category,
    gender,
    count(*) as total_trans
from retail_sales
group
    by 
    category,
    gender
orDER by 1


-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

select 
       year,
       month,
    avg_sale
from 
(    
select 
    extract(YEAR from sale_date) as year,
    extract(MONTH from sale_date) as month,
    avg(total_sale) as avg_sale,
    rank()over(PARTITION by extract(YEAR from sale_date) order by avg(total_sale) DESC) as rank
from retail_sales
groupby 1, 2
) as t1
where rank = 1
    
-- orDER by 1, 3 DESC

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 

select 
    customer_id,
    SUM(total_sale) as total_sales
from retail_sales
groupby 1
order by 2 DESC
limit 5

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.


select 
    category,    
    count(distinct customer_id) as cnt_unique_cs
from retail_sales
groupby category



-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)

with hourly_sale
as
(
select *,
    case
        when extract(hour from sale_time) < 12 then 'Morning'
        when extract(hour from sale_time) between 12 and 17 then 'Afternoon'
        ELSE 'Evening'
    end as shift
from retail_sales
)
select 
    shift,
    count(*) as total_orders    
from hourly_sale
groupby shift

-- End of project
