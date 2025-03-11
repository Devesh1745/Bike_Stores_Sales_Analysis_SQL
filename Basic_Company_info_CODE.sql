
-- Data Analyst Bike Stores
-- Description: The aim of this analysis is obtain an overview about the company

-- 1. Information about stores:
-- How many stores does the company have and where are they located?
SELECT 
	store_id, 
	store_name, 
	city, 
	state 
FROM 
	stores;

-- What is the contact information (phone and email) for each store?
SELECT 
	store_id, 
	phone, 
	email 
FROM 
	stores;


-- 2. Information about employees:
-- How many employees does the company have and in which stores do they work?
SELECT 
	store_id, 
	COUNT(*) AS num_employees 
FROM 
	staffs 
GROUP BY 
	store_id;

-- Who is the manager of each store?  (considering that the manager is also an employee)
SELECT 
	first_name, 
	last_name 
FROM 
	staffs;


-- 3. Information about categories:
-- How many product categories are there?
SELECT 
	COUNT(*) AS num_categories 
FROM 
	categories;

-- What are the names of the product categories?
SELECT 
	category_name 
FROM 
	categories;


-- 4. Information about brands:
-- How many product brands are there?
SELECT 
	COUNT(*) AS num_brands 
FROM 
	brands;

-- What are the names of the product brands?
SELECT 
	brand_name 
FROM 
	brands;


-- 5. Information about products:
-- How many products does the company offer?
SELECT 
	COUNT(*) AS num_products 
FROM 
	products;

-- What are the names and prices of the five most expensive products?
SELECT 
	product_name, 
	list_price 
FROM 
	products 
ORDER BY 
	list_price 
LIMIT 5;

-- What are the names and prices of the five cheapest products;
SELECT 
	product_name, 
	list_price 
FROM 
	products 
ORDER BY 
	list_price DESC 
LIMIT 5;


-- 6. Information about customers:
-- How many customers does the company have?
SELECT 
	COUNT(*) AS num_customers 
FROM 
	customers;

-- How many customers does the company per state?
SELECT 
	COUNT(*) AS num_customers, 
	state 
FROM 
	customers 
GROUP BY 
	state;

-- In which cities and states do the customers reside?
SELECT 
	DISTINCT(city), 
	state 
FROM 
	customers 
ORDER BY 
	state; 


-- 7. Information about orders:
-- How many orders have been placed and what is their status?
SELECT 
	order_status, 
	COUNT(order_date) AS num_orders 
FROM 
	orders 
GROUP BY 
	order_status;

-- What are the dates of the orders and how long do they take to ship?
SELECT 
	order_id, 
	order_status, 
	order_date, 
	shipped_date, 
	DATEDIFF(shipped_date, order_date) AS days_to_ship 
FROM 
	orders 
WHERE 
	order_status IN (3, 4) 
	AND shipped_date IS NOT NULL;

-- On average, how long do they take for orders to ship?
SELECT 
	AVG(DATEDIFF(shipped_date, order_date)) AS days_to_ship 
FROM 
	orders 
WHERE 
	order_status IN (3, 4);


-- 8. Information about order_items:
-- What is the quantity of each product in each order?
SELECT 
	order_id, 
	product_id, 
	quantity 
FROM 
	order_items 
ORDER BY 
	order_id;

-- What is the discount applied to each item in the orders?
SELECT 
	order_id, 
	item_id, 
	discount 
FROM 
	order_items;

-- What is the quantity of products in each order and what is the average quantity of products ordered?
-- PART 1
SELECT 
	order_id, 
	COUNT(quantity) AS quantity_per_order 
FROM 
	order_items 
GROUP BY 
	order_id;

-- PART 2
SELECT 
	AVG(quantity) AS AVG_quantity 
FROM order_items;


-- What is the top ten products ordered?
SELECT 
	product_id, 
	COUNT(quantity) AS quantity_per_order 
FROM 
	order_items 
GROUP BY 
	product_id 
ORDER BY 
	quantity_per_order DESC 
LIMIT 10;

-- 9. Information about stocks:
-- What is the current inventory in each store?
SELECT * 
FROM 
	stocks;

-- Which products have the lowest inventory in each store?
SELECT 
	store_id, 
	product_id, 
	MIN(quantity) AS min_inventory 
FROM 
	stocks 
GROUP BY 
	store_id, product_id 
ORDER BY 
	min_inventory;
