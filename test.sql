-- Create TABLE
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
            (
                transaction_id INT PRIMARY KEY,	
                sale_date DATE,	 
                sale_time TIME,	
                customer_id	INT,
                gender	VARCHAR(15),
                age	INT,
                category VARCHAR(15),	
                quantity	INT,
                price_per_unit FLOAT,	
                cogs	FLOAT,
                total_sale FLOAT
            );

SELECT * FROM retail_sales
LIMIT 10;

--number of rows in the dataset
select count(*) from retail_sales

--data cleaning

--return all rows that are null by checking multiple colums
select * from retail_sales
WHERE
	transaction_id is null
	OR
	cogs is null
	OR
	sale_date is null 
	OR
	customer_id is null 
	OR
	gender is null 
	OR
	age is null 
	OR
	category is null 
	OR
	quantity is null 
		OR
	price_per_unit is null 
		OR
	cogs is null 
		OR
	total_sale is null 


--delete all null rows
delete from retail_sales
WHERE
	transaction_id is null
	OR
	cogs is null
	OR
	sale_date is null 
	OR
	customer_id is null 
	OR
	gender is null 
	OR
	age is null 
	OR
	category is null 
	OR
	quantity is null 
		OR
	price_per_unit is null 
		OR
	cogs is null 
		OR
	total_sale is null 

-- data exploration

--total sales
select count(*) as total_sales from retail_sales


--how many unique customers we have?
select count(DISTINCT customer_id) as customers from retail_sales

--how many unique customers we have?
select DISTINCT category as categories from retail_sales

--Write a SQL query to retrieve all transactions where the category is 'Clothing’ 
--and the quantity is greater than 2 for the month of November 2020.

select * from retail_sales 
where 
	to_char(sale_date, 'YYYY-MM') ='2022-11'
	AND
	category = 'Clothing'
	AND quantity >=4

--Write a SQL query to calculate the total sales (total_sale) for each category.
select SUM(total_sale) as total_sales, category from retail_sales 
group by (category)

--Write a SQL query to find the average age of customers 
--who purchased items from the 'Beauty' category.
select avg(age) as avg_age, category from retail_sales 
where category = 'Beauty'
group by (category)

--Write a SQL query to find all transactions where the total_sale is greater than 1000.
select * from retail_sales 
where total_sale > 1000

--Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
select count(*) as num_transactions, gender, category from retail_sales 
group by gender, category
order by 1

--Write a SQL query to calculate the average sale for each month. Find out the best-selling month in each year.
select * from (
	select 
		extract(year from sale_date) as year,
		extract(month from sale_date) as month,
		avg(total_sale) as total_sales_per_month,
		rank() over(partition by extract(year from sale_date) order by avg(total_sale) desc) as rank
	from retail_sales 
	group by year, month
	order by year, total_sales_per_month desc
) where rank = 1; 


--Write a SQL query to find the top 5 customers based on the highest total sales.
select customer_id, sum(total_sale) as sales from retail_sales
group by customer_id
order by sales desc
limit 5; 

--Write a SQL query to find the number of unique customers 
--who purchased items from each category.
select t.category, count(t.customer_id) from (
	select 
		customer_id,
		category
	from retail_sales
	group by category, customer_id
) as t group by category

--Write a SQL query to create each shift and the number of orders 
--(Example: Morning <=12, Afternoon Between 12 & 17, Evening >17).
with hourly_sale as(
	select *,
			case 
				when extract(hour from sale_time) < 12 then 'Morning'
				when extract(hour from sale_time) between 12 AND 17 then 'Afternoon'
				else 'Evening'
			end as shift
	from retail_sales
)

select shift, count(*) 
from hourly_sale
group by shift;

--end of project

