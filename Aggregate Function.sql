-- ============================================================
--  E-Commerce Sales & Customer Analysis System
--  4 queries per function: COUNT, SUM, AVG, MAX, MIN
-- ============================================================

USE ecommerce_project;


-- ============================================================
-- COUNT()
-- ============================================================

-- C1. Total number of customers
SELECT COUNT(*) AS total_customers
FROM Customers;

-- C2. Number of products in the Electronics category (category_id = 1)
SELECT COUNT(*) AS electronics_product_count
FROM Products
WHERE category_id = 1;

-- C3. Number of reviews received by each product
SELECT product_id, COUNT(*) AS num_reviews
FROM Reviews
GROUP BY product_id;

-- C4. Number of items in each order
SELECT order_id, COUNT(*) AS num_items
FROM Order_Details
GROUP BY order_id;


-- ============================================================
-- SUM()
-- ============================================================

-- S1. Total revenue collected (completed payments only)
SELECT SUM(amount) AS total_revenue
FROM Payments
WHERE payment_status = 'Completed';

-- S2. Total quantity of items sold across all orders
SELECT SUM(quantity) AS total_units_sold
FROM Order_Details;

-- S3. Total quantity sold for each product
SELECT product_id, SUM(quantity) AS total_quantity_sold
FROM Order_Details
GROUP BY product_id;

-- S4. Total value of each order (quantity x unit_price)
SELECT order_id, SUM(quantity * unit_price) AS order_total
FROM Order_Details
GROUP BY order_id;


-- ============================================================
-- AVG()
-- ============================================================

-- A1. Average price of all products
SELECT AVG(price) AS average_product_price
FROM Products;

-- A2. Average rating given to each product
SELECT product_id, ROUND(AVG(rating), 2) AS average_rating
FROM Reviews
GROUP BY product_id;

-- A3. Average order value (completed payments only)
SELECT AVG(amount) AS average_order_value
FROM Payments
WHERE payment_status = 'Completed';

-- A4. Average quantity ordered per order line item
SELECT AVG(quantity) AS average_quantity_per_line
FROM Order_Details;


-- ============================================================
-- MAX()
-- ============================================================

-- M1. Highest-priced product
SELECT product_name, price
FROM Products
WHERE price = (SELECT MAX(price) FROM Products);

-- M2. Highest single payment amount received
SELECT MAX(amount) AS highest_payment
FROM Payments;

-- M3. Most recent order date
SELECT MAX(order_date) AS most_recent_order_date
FROM Orders;

-- M4. Highest rating received by each product
SELECT product_id, MAX(rating) AS highest_rating
FROM Reviews
GROUP BY product_id;


-- ============================================================
-- MIN()
-- ============================================================

-- N1. Lowest-priced product
SELECT product_name, price
FROM Products
WHERE price = (SELECT MIN(price) FROM Products);

-- N2. Smallest payment amount received
SELECT MIN(amount) AS lowest_payment
FROM Payments;

-- N3. Earliest order date
SELECT MIN(order_date) AS earliest_order_date
FROM Orders;

-- N4. Lowest rating received by each product
SELECT product_id, MIN(rating) AS lowest_rating
FROM Reviews
GROUP BY product_id;