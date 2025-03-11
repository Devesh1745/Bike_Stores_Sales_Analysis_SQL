use bike_store_data_analysis;
select * from stores;

--

-- Q1	Which stores have the highest total sales?

SELECT orders.store_id,stores.store_name,
    ROUND(SUM(quantity * list_price * (1 - discount)), 2) AS total_sales,
    ROW_NUMBER() OVER(ORDER BY ROUND(SUM(quantity * list_price * (1 - discount)), 2) DESC) AS sales_rank
FROM order_items
LEFT JOIN orders ON order_items.order_id = orders.order_id
LEFT JOIN stores ON orders.store_id = stores.store_id
WHERE orders.order_status = 4
GROUP BY orders.store_id, stores.store_name
ORDER BY total_sales DESC;

-- Q2 TOTAL SALES PER STORE AND YEAR

SELECT EXTRACT(YEAR FROM order_date) AS year, orders.store_id, stores.store_name,
    ROUND(SUM(quantity * list_price * (1 - discount)), 2) AS total_sales,
ROW_NUMBER() OVER(PARTITION BY EXTRACT(YEAR FROM order_date)
ORDER BY ROUND(SUM(quantity * list_price * (1 - discount)), 2) DESC) AS sales_rank
FROM order_items
LEFT JOIN orders ON order_items.order_id = orders.order_id
LEFT JOIN stores ON orders.store_id = stores.store_id
WHERE orders.order_status = 4
GROUP BY orders.store_id, stores.store_name, year
ORDER BY year, total_sales DESC;


-- Q3 monthly sales trend--

SELECT DATE_FORMAT(orders.order_date, '%Y-%m') AS month, SUM(order_items.quantity * order_items.list_price) AS revenue
FROM orders 
JOIN order_items ON orders .order_id = order_items.order_id
GROUP BY month
ORDER BY month;

-- Q4 What are the top cities where most of the orders are placed?

SELECT c.city, COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o ON o.customer_id = c.customer_id
GROUP BY c.city
ORDER BY total_orders DESC
LIMIT 10;


-- Q5 Did Discounts Reduce After June 2018?

SELECT DATE_FORMAT(o.order_date, '%Y-%m') AS month, 
       SUM(oi.discount) AS total_discount_given
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_date >= '2018-01-01'
GROUP BY month
ORDER BY month;

-- Q6 Total revenue per category--

SELECT categories.category_name, SUM(order_items.quantity * order_items.list_price) AS total_revenue
FROM order_items 
JOIN products  ON order_items.product_id = products.product_id
JOIN categories  ON products.category_id = categories.category_id
GROUP BY categories.category_name
ORDER BY total_revenue DESC;

-- Q7 Store-Wise Best Performing Staff

SELECT s.store_name,
       sf.staff_id, 
       CONCAT(sf.first_name, ' ', sf.last_name) AS staff_name,
       SUM(oi.quantity * oi.list_price) AS total_sales
FROM staffs sf
JOIN stores s ON sf.store_id = s.store_id
JOIN orders o ON sf.staff_id = o.staff_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY s.store_name, sf.staff_id, staff_name
ORDER BY s.store_name, total_sales DESC;


-- Q8 Best sales seasons (Which quarter performs best?)

SELECT QUARTER(orders.order_date) AS quarter, SUM(order_items.quantity * order_items.list_price) AS total_sales
FROM orders 
JOIN order_items  ON orders.order_id = order_items.order_id
GROUP BY quarter
ORDER BY total_sales DESC;

-- Q9 What are the most popular product categories by sales volume?
SELECT c.category_id, c.category_name, SUM(oi.quantity) as Sales_volume
FROM categories c
JOIN products p ON c.category_id = p.category_id
JOIN order_items oi ON oi.product_id = p.product_id
GROUP BY c.category_id, c.category_name
ORDER BY Sales_volume DESC
LIMIT 1;


-- Q10 Effect of discounts on sales (Do discounts increase sales?)

SELECT p.product_name, 
       SUM(CASE WHEN oi.discount > 0 THEN oi.quantity ELSE 0 END) AS discounted_sales,
       SUM(CASE WHEN oi.discount = 0 THEN oi.quantity ELSE 0 END) AS regular_sales,
       ROUND((SUM(CASE WHEN oi.discount > 0 THEN oi.quantity ELSE 0 END) / NULLIF(SUM(oi.quantity), 0)) * 100, 2) AS discount_effect
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY discount_effect DESC;



-- Q11 Forecast next month’s sales (Simple moving average)

SELECT month, total_revenue,
       ROUND(AVG(total_revenue) OVER (ORDER BY month ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 2) AS moving_avg
FROM (
    SELECT DATE_FORMAT(o.order_date, '%Y-%m') AS month, 
           SUM(oi.quantity * oi.list_price) AS total_revenue
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY month
) AS monthly_sales;


-- Q12 Store Sales Before & After June 2018
SELECT s.store_name,
       SUM(CASE WHEN o.order_date < '2018-07-01' THEN oi.quantity ELSE 0 END) AS sales_before,
       SUM(CASE WHEN o.order_date >= '2018-07-01' THEN oi.quantity ELSE 0 END) AS sales_after,
       ROUND(((SUM(CASE WHEN o.order_date >= '2018-07-01' THEN oi.quantity ELSE 0 END) - 
              SUM(CASE WHEN o.order_date < '2018-07-01' THEN oi.quantity ELSE 0 END)) /
              SUM(CASE WHEN o.order_date < '2018-07-01' THEN oi.quantity ELSE 0 END)) * 100, 2) AS sales_change
FROM stores s
JOIN staffs sf ON s.store_id = sf.store_id
JOIN orders o ON sf.staff_id = o.staff_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY s.store_name
ORDER BY sales_change ASC;


















