-- ============================================================
--  E-Commerce Sales & Customer Analysis System
--  Views & Window Functions  (MySQL 8.0+)
--  Kept single-table and simple, same as the other files
-- ============================================================

USE ecommerce_project;


-- ============================================================
-- VIEWS
--  A view is just a saved SELECT query you can reuse like a table.
-- ============================================================

-- V1. Expensive_Products — products priced above ₹1500
DROP VIEW IF EXISTS Expensive_Products;
CREATE VIEW Expensive_Products AS
SELECT product_name, price
FROM Products
WHERE price > 1500;

-- usage:
SELECT * FROM Expensive_Products;


-- V2. Pending_Orders — orders that are still awaiting delivery
DROP VIEW IF EXISTS Pending_Orders;
CREATE VIEW Pending_Orders AS
SELECT order_id, order_date, order_status
FROM Orders
WHERE order_status = 'Pending';

-- usage:
SELECT * FROM Pending_Orders;


-- V3. Product_Ratings — average rating for each product
DROP VIEW IF EXISTS Product_Ratings;
CREATE VIEW Product_Ratings AS
SELECT product_id, ROUND(AVG(rating), 2) AS average_rating
FROM Reviews
GROUP BY product_id;

-- usage:
SELECT * FROM Product_Ratings;


-- V4. Customer_Order_Count — number of orders placed by each customer
DROP VIEW IF EXISTS Customer_Order_Count;
CREATE VIEW Customer_Order_Count AS
SELECT customer_id, COUNT(*) AS num_orders
FROM Orders
GROUP BY customer_id;

-- usage:
SELECT * FROM Customer_Order_Count;


-- ============================================================
-- WINDOW FUNCTIONS
--  Like aggregates, but they don't collapse rows — each row
--  keeps its own detail alongside the calculated value.
-- ============================================================

-- WF1. ROW_NUMBER() — number every product, most expensive first
SELECT
    product_name,
    price,
    ROW_NUMBER() OVER (ORDER BY price DESC) AS price_rank_no
FROM Products;


-- WF2. RANK() — rank products by price (equal prices share a rank)
SELECT
    product_name,
    price,
    RANK() OVER (ORDER BY price DESC) AS price_rank
FROM Products;


-- WF3. Running total — cumulative revenue as payments come in
SELECT
    payment_id,
    payment_date,
    amount,
    SUM(amount) OVER (ORDER BY payment_date) AS running_total
FROM Payments
WHERE payment_status = 'Completed';


-- WF4. PARTITION BY — show each review next to that product's average rating
SELECT
    product_id,
    rating,
    AVG(rating) OVER (PARTITION BY product_id) AS product_average_rating
FROM Reviews;