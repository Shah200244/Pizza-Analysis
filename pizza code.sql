create database Shahid;
use Shahid;
select * from [Copy of Data_Model_-_Pizza_Sales];
--Total Revenue 
select sum(total_price) as Total_Revenue
into dbo.Total_Revenue
from [Copy of Data_Model_-_Pizza_Sales];

select * from Total_Revenue;

--Total Quantity
select sum(quantity) as Total_Quantity
into dbo.Total_Quantity
from [Copy of Data_Model_-_Pizza_Sales];

select * from Total_Quantity;

--Average order value
2. Average_Order_Value
SELECT 
    CAST(SUM(total_price) / COUNT(DISTINCT order_id) AS DECIMAL(10, 2)) AS avg_order_value
	into dbo.Average_Order_Value
FROM 
    [Copy of Data_Model_-_Pizza_Sales];

--Total order
select count(distinct order_id) as Total_order
into dbo.Total_order
from [Copy of Data_Model_-_Pizza_Sales];

--Average pizza per order
5. Average Pizza Per Order
SELECT cast( 
    CAST(SUM(quantity) AS DECIMAL(10,2)) / 
    CAST(COUNT(order_id) AS DECIMAL(10,2)) AS DECIMAL(10,2)) AS Avg_pizza_per_order
	into dbo.Avg_pizza_per_order
FROM 
    [Copy of Data_Model_-_Pizza_Sales];

select * from Avg_pizza_per_order;

--Daily Trend for Total order
select DATENAME(DW, order_date) as Order_Day, COUNT(distinct order_id) as Total_orders
into dbo.Daily_Trend_for_Total_Orders
from [Copy of Data_Model_-_Pizza_Sales]
group by DATENAME(DW,order_date)
order by Total_orders;

select * from Daily_Trend_for_Total_Orders;

--Monthly Trend for Orders
SELECT 
    DATENAME(MONTH, order_date) AS month_name,
    COUNT(DISTINCT order_id) AS total_orders
	into dbo.monthly_trends_for_orders
FROM 
     [Copy of Data_Model_-_Pizza_Sales]
GROUP BY 
    DATENAME(MONTH, order_date);

select * from monthly_trends_for_orders;

--Percentage of sales by pizza category 
SELECT 
    pizza_category,
    CAST(SUM(total_price) AS DECIMAL(10,2)) AS Total_Revenue,
    CAST(
        SUM(total_price) * 100.0 / 
        (SELECT SUM(total_price) FROM [Copy of Data_Model_-_Pizza_Sales])
    AS DECIMAL(10,2)) AS pct
	into dbo.Percentage_of_sales_by_pizza_category
FROM 
    [Copy of Data_Model_-_Pizza_Sales]
GROUP BY 
    pizza_category;

select * from Percentage_of_sales_by_pizza_category;

--Percentage of sales by pizza size
SELECT 
    pizza_size, 
    CAST(SUM(total_price) AS DECIMAL(10,2)) AS Total_Revenue,
    CAST(
        SUM(total_price) * 100.0 / 
        (SELECT SUM(total_price) FROM  [Copy of Data_Model_-_Pizza_Sales])
    AS DECIMAL(10,2)) AS PCT
	into dbo.percentage_of_sales_by_pizza_size
FROM 
 [Copy of Data_Model_-_Pizza_Sales]
 GROUP BY 
    pizza_size;

select * from percentage_of_sales_by_pizza_size;

--Q10. Total Pizzas Sold by Pizza Category
SELECT pizza_category, SUM(quantity) AS Total_Quantity_Sold
into dbo.Total_Pizzas_Sold_by_Pizza_Category
FROM  [Copy of Data_Model_-_Pizza_Sales]
WHERE MONTH (order_date) = 2
GROUP BY pizza_category
ORDER BY Total_Quantity_Sold DESC;

select * from Total_Pizzas_Sold_by_Pizza_Category;

--Top 5 Pizzas by Revenue
SELECT Top 5 pizza_name, SUM(total_price) AS Total_Revenue
into dbo.Top_5_Pizzas_by_Revenue
FROM  [Copy of Data_Model_-_Pizza_Sales]
GROUP BY pizza_name
ORDER BY Total_Revenue DESC

--Bottom five pizza by revenue
select * from  Top_5_Pizzas_by_Revenue;
SELECT Top 5 pizza_name, SUM(total_price) AS Total_Revenue
into dbo.Bottom_5_Pizzas_by_Revenue
FROM  [Copy of Data_Model_-_Pizza_Sales]
GROUP BY pizza_name
ORDER BY Total_Revenue 

select * from Bottom_5_Pizzas_by_Revenue

--Q13. Top 5 Pizzas by Total Orders
SELECT TOP 5 pizza_name, COUNT(DISTINCT order_id) AS Total_Orders
into dbo.Top_5_Pizza_by_Total_Orders
FROM[Copy of Data_Model_-_Pizza_Sales]
GROUP BY pizza_name
ORDER BY Total_Orders DESC;

select * from  Top_5_Pizza_by_Total_Orders

--Bottom 5 pizza by total order
SELECT TOP 5 pizza_name, COUNT(DISTINCT order_id) AS Total_Orders
into dbo.Bottom_5_Pizzas_by_Total_Orders
FROM[Copy of Data_Model_-_Pizza_Sales]
GROUP BY pizza_name
ORDER BY Total_Orders ;
 
select * from  Bottom_5_Pizzas_by_Total_Orders

--Top 5 pizza by quantity
SELECT TOP 5 pizza_name, SUM(quantity) AS Total_Pizza_Sold
into dbo.Top_5_Pizzas_by_Quantity
FROM [Copy of Data_Model_-_Pizza_Sales]
GROUP BY pizza_name
ORDER BY Total_Pizza_Sold DESC;

select * from Top_5_Pizzas_by_Quantity

--Bottom 5 pizza by quantity
SELECT TOP 5 pizza_name, SUM(quantity) AS Total_Pizza_Sold
into dbo.Bottom_5_Pizzas_by_Quantity
FROM [Copy of Data_Model_-_Pizza_Sales]
GROUP BY pizza_name
ORDER BY Total_Pizza_Sold;

select * from Bottom_5_Pizzas_by_Quantity

--Busiest day times 
SELECT 
    DATENAME(WEEKDAY, order_date) AS day_of_week,
    DATEPART(HOUR, order_time) AS hour_of_day,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(quantity) AS total_pizzas
INTO dbo.Busiest_Day_Times
FROM  [Copy of Data_Model_-_Pizza_Sales] 
GROUP BY 
    DATENAME(WEEKDAY, order_date),
    DATEPART(HOUR, order_time);

select * from dbo.Busiest_Day_Times

--Peak period pizza
SELECT 
    DATEPART(HOUR, order_time) AS hour_of_day,
    COUNT(*) AS total_orders,
    SUM(quantity) AS total_pizzas
INTO dbo.Peak_Period_Pizzas
FROM  [Copy of Data_Model_-_Pizza_Sales] 
WHERE DATEPART(HOUR, order_time) IN (12, 13, 18, 19)
GROUP BY DATEPART(HOUR, order_time)
ORDER BY DATEPART(HOUR, order_time);

select * from Peak_Period_Pizzas

--Pizza sales performance
SELECT 
    pizza_name,
    SUM(quantity) AS total_sold
	into dbo.Pizza_Sales_Performance
FROM [Copy of Data_Model_-_Pizza_Sales] 
GROUP BY pizza_name;

select * from Pizza_Sales_Performance

--seating_capacity_utilizations_pct
WITH hourly_orders AS (
    SELECT 
        CAST(order_date AS DATE) AS order_day,
        DATEPART(HOUR, order_time) AS order_hour,
        COUNT(DISTINCT order_id) AS total_orders
    FROM [Copy of Data_Model_-_Pizza_Sales] 
    GROUP BY CAST(order_date AS DATE), DATEPART(HOUR, order_time)
),
ranked_hours AS (
    SELECT *,
           RANK() OVER (PARTITION BY order_day ORDER BY total_orders DESC) AS hour_rank
    FROM hourly_orders
)
SELECT 
    order_day,
    order_hour AS peak_hour,
    total_orders AS peak_orders,
    total_orders * 2 AS estimated_guests,
    90 AS total_guest_capacity,
    CAST(ROUND((total_orders * 2.0 / 90.0) * 100.0, 2) AS DECIMAL(5,2)) AS seating_capacity_utilization_pct
	into dbo.seating_capacity_utilizations_pct
FROM ranked_hours
WHERE hour_rank = 1
ORDER BY order_day;

select * from seating_capacity_utilizations_pct

drop table seating_capacity_utilization_pct