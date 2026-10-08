-- ============================================================
--  E-Commerce Sales & Customer Analysis System
--  Final Analysis & Business Insights  
-- ============================================================

USE ecommerce_project;


-- ============================================================
-- 1. CUSTOMER ANALYSIS
-- ============================================================

-- 1.1 How many customers do we have in total?
-- Gives a quick sense of the size of the customer base.
SELECT COUNT(*) AS total_customers
FROM Customers;

-- 1.2 Which cities are our customers coming from?
-- Helps understand where the customer base is concentrated,
-- useful for targeted marketing or faster regional delivery.
SELECT city, COUNT(*) AS num_customers
FROM Customers
GROUP BY city
ORDER BY num_customers DESC;

-- 1.3 Who are our top 5 customers by amount spent?
-- Identifies the most valuable customers — good candidates
-- for loyalty offers or early access to new products.
SELECT c.customer_name, SUM(p.amount) AS total_spent
FROM Customers c
JOIN Orders o   ON c.customer_id = o.customer_id
JOIN Payments p ON o.order_id = p.order_id
WHERE o.order_status = 'Delivered'
GROUP BY c.customer_id, c.customer_name
ORDER BY total_spent DESC
LIMIT 5;

-- 1.4 Which customers spend more than a typical order is worth?
-- A simple way to flag above-average spenders without a
-- complicated nested query — compares each customer's total
-- spend to the average single payment amount.
SELECT c.customer_name, SUM(p.amount) AS total_spent
FROM Customers c
JOIN Orders o   ON c.customer_id = o.customer_id
JOIN Payments p ON o.order_id = p.order_id
GROUP BY c.customer_id, c.customer_name
HAVING SUM(p.amount) > (SELECT AVG(amount) FROM Payments)
ORDER BY total_spent DESC;

-- 1.5 Which customers have signed up but never placed an order?
-- These are "dormant" sign-ups — worth targeting with a
-- welcome offer to convert them into buyers.
SELECT c.customer_name, c.email
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;


-- ============================================================
-- 2. PRODUCT ANALYSIS
-- ============================================================

-- 2.1 What does our full product catalogue look like by category?
-- A simple catalogue view — the starting point for most other
-- product-level questions below.
SELECT p.product_name, c.category_name, p.price
FROM Products p
JOIN Categories c ON p.category_id = c.category_id
ORDER BY c.category_name, p.product_name;

-- 2.2 Which products fall in the premium price range (above ₹1500)?
-- Useful for deciding which products to feature in premium
-- marketing campaigns.
SELECT product_name, price
FROM Products
WHERE price > 1500;

-- 2.3 Which products are priced above our own average price?
-- A quick way to spot the products pulling the average up —
-- these are the premium end of the catalogue.
SELECT product_name, price
FROM Products
WHERE price > (SELECT AVG(price) FROM Products);

-- 2.4 Which products have never been ordered at all?
-- Flags dead stock — candidates for a discount push or
-- removal from the catalogue.
SELECT product_name
FROM Products
WHERE product_id NOT IN (SELECT DISTINCT product_id FROM Order_Details);

-- 2.5 What are our 5 best-selling products by units sold?
-- Tells us what to keep well-stocked and what to promote more.
SELECT p.product_name, SUM(od.quantity) AS total_units_sold
FROM Order_Details od
JOIN Products p ON od.product_id = p.product_id
GROUP BY p.product_id, p.product_name
ORDER BY total_units_sold DESC
LIMIT 5;


-- ============================================================
-- 3. SALES ANALYSIS
-- ============================================================

-- 3.1 What is our total revenue so far?
-- The single most important number for the business overall.
SELECT SUM(amount) AS total_revenue
FROM Payments
WHERE payment_status = 'Completed';

-- 3.2 What is the average order value?
-- Useful as a benchmark — future promotions can be judged
-- against whether they raise or lower this number.
SELECT AVG(amount) AS average_order_value
FROM Payments
WHERE payment_status = 'Completed';

-- 3.3 Which product category brings in the most revenue?
-- Helps decide where to invest in more inventory or ads.
SELECT cat.category_name, SUM(od.quantity * od.unit_price) AS category_revenue
FROM Order_Details od
JOIN Products p     ON od.product_id = p.product_id
JOIN Categories cat ON p.category_id = cat.category_id
GROUP BY cat.category_id, cat.category_name
ORDER BY category_revenue DESC;

-- 3.4 How has revenue moved month by month?
-- Shows whether the business is growing, flat, or declining
-- over time.
SELECT DATE_FORMAT(o.order_date, '%Y-%m') AS month, SUM(p.amount) AS monthly_revenue
FROM Orders o
JOIN Payments p ON o.order_id = p.order_id
WHERE p.payment_status = 'Completed'
GROUP BY month
ORDER BY month;

-- 3.5 Which orders had more than 2 different items in them?
-- Large, multi-item orders are often the most profitable —
-- worth understanding what drives them (bundles, offers, etc).
SELECT order_id, COUNT(*) AS num_items
FROM Order_Details
GROUP BY order_id
HAVING COUNT(*) > 2
ORDER BY num_items DESC;


-- ============================================================
-- 4. PAYMENT ANALYSIS
-- ============================================================

-- 4.1 How many orders fall into each payment status?
-- A health check — a high "Failed" or "Pending" count would
-- point to a checkout problem worth investigating.
SELECT payment_status, COUNT(*) AS num_orders
FROM Payments
GROUP BY payment_status;

-- 4.2 What is our most popular payment method?
-- Tells us which payment option to keep frictionless and
-- prioritize during checkout design.
SELECT payment_method, COUNT(*) AS times_used
FROM Payments
GROUP BY payment_method
ORDER BY times_used DESC
LIMIT 1;

-- 4.3 How much money has come in through each payment method?
-- Complements 4.2 — a method can be used often but still
-- bring in less total value than a less-used one.
SELECT payment_method, SUM(amount) AS total_collected
FROM Payments
WHERE payment_status = 'Completed'
GROUP BY payment_method
ORDER BY total_collected DESC;

-- 4.4 Which customers currently have a pending payment?
-- A follow-up list — these are orders at risk of being
-- cancelled if payment isn't completed soon.
SELECT c.customer_name, o.order_id, p.amount
FROM Payments p
JOIN Orders o    ON p.order_id = o.order_id
JOIN Customers c ON o.customer_id = c.customer_id
WHERE p.payment_status = 'Pending';

-- 4.5 Does payment amount differ by status?
-- Checks whether failed/pending payments tend to be for
-- higher-value orders, which would need extra attention.
SELECT payment_status, AVG(amount) AS avg_amount
FROM Payments
GROUP BY payment_status;


-- ============================================================
-- 5. REVIEW ANALYSIS
-- ============================================================

-- 5.1 What is the average rating for each product?
-- The core measure of customer satisfaction per product.
SELECT p.product_name, ROUND(AVG(r.rating), 2) AS avg_rating, COUNT(r.review_id) AS num_reviews
FROM Reviews r
JOIN Products p ON r.product_id = p.product_id
GROUP BY p.product_id, p.product_name
ORDER BY avg_rating DESC;

-- 5.2 Which products have built up a solid number of reviews (more than 2)?
-- These ratings are more trustworthy since they're based on
-- more than just one or two opinions.
SELECT p.product_name, COUNT(*) AS num_reviews
FROM Reviews r
JOIN Products p ON r.product_id = p.product_id
GROUP BY p.product_id, p.product_name
HAVING COUNT(*) > 2
ORDER BY num_reviews DESC;

-- 5.3 Which single product has the highest average rating?
-- Our current "best loved" product — a strong candidate to
-- feature on the homepage.
SELECT p.product_name, ROUND(AVG(r.rating), 2) AS avg_rating
FROM Reviews r
JOIN Products p ON r.product_id = p.product_id
GROUP BY p.product_id, p.product_name
ORDER BY avg_rating DESC
LIMIT 1;

-- 5.4 Which customers are our most active reviewers (more than 1 review)?
-- These engaged customers could be invited into a beta
-- testers or reviewers programme.
SELECT c.customer_name, COUNT(*) AS num_reviews
FROM Reviews r
JOIN Customers c ON r.customer_id = c.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING COUNT(*) > 1
ORDER BY num_reviews DESC;

-- 5.5 Which products have no reviews yet?
-- Worth a gentle "leave a review" nudge to buyers of these
-- products, since ratings build trust for future customers.
SELECT product_name
FROM Products
WHERE product_id NOT IN (SELECT DISTINCT product_id FROM Reviews);


-- ============================================================
-- 6. BONUS — the full picture in one query
--    Customer -> Order -> Order_Details -> Product -> Category
--    Ties every table in the schema together in a single view
--    of "who bought what, from which category, and when".
-- ============================================================
SELECT
    c.customer_name,
    o.order_id,
    o.order_date,
    pr.product_name,
    cat.category_name,
    od.quantity,
    od.unit_price
FROM Customers c
JOIN Orders o          ON c.customer_id = o.customer_id
JOIN Order_Details od  ON o.order_id = od.order_id
JOIN Products pr        ON od.product_id = pr.product_id
JOIN Categories cat      ON pr.category_id = cat.category_id
ORDER BY o.order_id
LIMIT 20;


-- ============================================================
--  ADVANTAGES of the business (based on what the data shows)
-- ============================================================
-- 1. Revenue isn't riding on one category alone — Electronics
--    leads, but Clothing and others aren't far behind, so the
--    business isn't overly dependent on a single product line.
-- 2. Customers already use a healthy mix of payment methods —
--    UPI leads, but cards, cash on delivery and net banking are
--    all in regular use, so buyers aren't forced into one option.
-- 3. There's a clear top tier of high-spending customers — a
--    strong base to build loyalty and repeat-purchase programmes
--    around, since they're already bought in.
-- 4. Reviewed products mostly carry solid ratings, which is a
--    good trust signal for new customers browsing the catalogue.


-- ============================================================
--  LIMITATIONS of the business (based on what the data shows)
-- ============================================================
-- 1. A big share of revenue comes from just a handful of top
--    customers — losing even one or two of them would visibly
--    hurt total sales.
-- 2. Several products have never been ordered even once — that's
--    money tied up in stock that isn't moving.
-- 3. A noticeable share of payments are Pending or Failed rather
--    than Completed, which likely means lost or delayed revenue
--    somewhere in the checkout process.
-- 4. The customer base is concentrated in a few cities — large
--    parts of the potential market aren't being reached at all.
-- 5. Many products have no reviews yet, which makes it harder
--    for new customers to trust them enough to buy.


-- ============================================================
--  FUTURE OPPORTUNITIES for the business
-- ============================================================
-- 1. Run city-specific marketing in the regions that are
--    currently underrepresented, to widen the customer base.
-- 2. Launch a loyalty or rewards programme aimed at the top
--    spenders identified above, to reduce the risk of losing them.
-- 3. Bundle or discount the never-ordered products to clear
--    them out, or drop them from the catalogue entirely.
-- 4. Dig into why payments are going Pending/Failed and fix that
--    part of the checkout flow — it's likely leaking revenue.
-- 5. Send a review request after delivery for products that
--    have no ratings yet, to build trust for future buyers.
-- 6. Put more marketing budget and stock behind the
--    best-selling category and products, since demand is proven.
-- 7. Introduce subscription or repeat-purchase incentives for
--    the product categories customers already buy often.