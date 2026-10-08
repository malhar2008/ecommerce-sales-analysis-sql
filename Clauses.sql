-- ============================================================
--  E-Commerce Sales & Customer Analysis System
--  SELECT, WHERE, GROUP BY, HAVING, ORDER BY
-- ============================================================

USE ecommerce_project;


-- ============================================================
-- SELECT
-- ============================================================

-- SEL1. Display all customer names
SELECT customer_name
FROM Customers;

-- SEL2. Display all product names and their prices
SELECT product_name, price
FROM Products;

-- SEL3. Display all order dates and their status
SELECT order_date, order_status
FROM Orders;

-- SEL4. Display all review ratings and comments
SELECT rating, comments
FROM Reviews;


-- ============================================================
-- WHERE
-- ============================================================

-- W1. Find products priced above ₹1500
SELECT product_name, price
FROM Products
WHERE price > 1500;

-- W2. Find customers located in Bangalore
SELECT customer_name, city
FROM Customers
WHERE city = 'Bangalore';

-- W3. Find orders that are still Pending
SELECT order_id, order_date
FROM Orders
WHERE order_status = 'Pending';

-- W4. Find reviews with a rating of 5
SELECT review_id, rating, comments
FROM Reviews
WHERE rating = 5;


-- ============================================================
-- GROUP BY
-- ============================================================

-- GB1. Number of products in each category (by category_id)
SELECT category_id, COUNT(*) AS num_products
FROM Products
GROUP BY category_id;

-- GB2. Number of orders placed by each customer
SELECT customer_id, COUNT(*) AS num_orders
FROM Orders
GROUP BY customer_id;

-- GB3. Total amount collected for each payment method
SELECT payment_method, SUM(amount) AS total_collected
FROM Payments
GROUP BY payment_method;

-- GB4. Number of orders placed in each month
SELECT DATE_FORMAT(order_date, '%Y-%m') AS month, COUNT(*) AS num_orders
FROM Orders
GROUP BY month;


-- ============================================================
-- HAVING
-- ============================================================

-- H1. Categories with more than 3 products
SELECT category_id, COUNT(*) AS num_products
FROM Products
GROUP BY category_id
HAVING COUNT(*) > 3;

-- H2. Customers who have placed more than 2 orders
SELECT customer_id, COUNT(*) AS num_orders
FROM Orders
GROUP BY customer_id
HAVING COUNT(*) > 2;

-- H3. Payment methods used more than 5 times
SELECT payment_method, COUNT(*) AS times_used
FROM Payments
GROUP BY payment_method
HAVING COUNT(*) > 5;

-- H4. Products with an average rating above 4
SELECT product_id, AVG(rating) AS avg_rating
FROM Reviews
GROUP BY product_id
HAVING AVG(rating) > 4;


-- ============================================================
-- ORDER BY
-- ============================================================

-- O1. Products sorted by price, cheapest first (ASCENDING)
SELECT product_name, price
FROM Products
ORDER BY price ASC;

-- O2. Products sorted by price, most expensive first (DESCENDING)
SELECT product_name, price
FROM Products
ORDER BY price DESC;

-- O3. Customers sorted by signup date, earliest first (ASCENDING)
SELECT customer_name, signup_date
FROM Customers
ORDER BY signup_date ASC;

-- O4. Orders sorted by order date, most recent first (DESCENDING)
SELECT order_id, order_date
FROM Orders
ORDER BY order_date DESC;