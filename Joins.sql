-- ============================================================
--  E-Commerce Sales & Customer Analysis System
-- ============================================================

USE ecommerce_project;


-- ============================================================
-- 1. INNER JOIN
--    Returns only rows where a match exists in both tables.
--    Example: products that DO have a category assigned.
-- ============================================================
SELECT p.product_name, c.category_name
FROM Products p
INNER JOIN Categories c ON p.category_id = c.category_id;


-- ============================================================
-- 2. LEFT JOIN
--    Returns all rows from the left table, even with no match
--    on the right. Example: every customer, including anyone
--    who hasn't placed an order yet (their order columns show NULL).
-- ============================================================
SELECT c.customer_name, o.order_id, o.order_date
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id;


-- ============================================================
-- 3. RIGHT JOIN
--    Returns all rows from the right table, even with no match
--    on the left. Example: every product, including ones that
--    have never been reviewed (their review columns show NULL).
-- ============================================================
SELECT r.rating, p.product_name
FROM Reviews r
RIGHT JOIN Products p ON r.product_id = p.product_id;


-- ============================================================
-- 4. NORMAL JOIN (plain "JOIN" — behaves the same as INNER JOIN)
--    Example: every order along with the customer who placed it.
-- ============================================================
SELECT o.order_id, c.customer_name
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id;