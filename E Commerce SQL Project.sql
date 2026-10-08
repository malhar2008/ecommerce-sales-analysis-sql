-- ============================================================
--  E-Commerce Sales & Customer Analysis System
-- ============================================================

DROP DATABASE IF EXISTS ecommerce_project;
CREATE DATABASE ecommerce_project;
USE ecommerce_project;

-- ------------------------------------------------------------
-- 1. Categories  — product categories
-- ------------------------------------------------------------
CREATE TABLE Categories (
    category_id   INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL UNIQUE
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- 2. Customers  — customer details
-- ------------------------------------------------------------
CREATE TABLE Customers (
    customer_id   INT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    email         VARCHAR(100) NOT NULL UNIQUE,
    city          VARCHAR(50),
    phone         VARCHAR(15),
    signup_date   DATE
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- 3. Products  — items being sold
-- ------------------------------------------------------------
CREATE TABLE Products (
    product_id     INT AUTO_INCREMENT PRIMARY KEY,
    product_name   VARCHAR(100) NOT NULL,
    category_id    INT NOT NULL,
    price          DECIMAL(10,2) NOT NULL,
    stock_quantity INT DEFAULT 0,
    FOREIGN KEY (category_id) REFERENCES Categories(category_id)
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- 4. Orders  — one row per order placed by a customer
-- ------------------------------------------------------------
CREATE TABLE Orders (
    order_id     INT AUTO_INCREMENT PRIMARY KEY,
    customer_id  INT NOT NULL,
    order_date   DATE NOT NULL,
    order_status VARCHAR(20) DEFAULT 'Pending',   -- Delivered / Pending / Cancelled
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- 5. Order_Details  — line items inside each order (order <-> product)
-- ------------------------------------------------------------
CREATE TABLE Order_Details (
    order_detail_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id        INT NOT NULL,
    product_id      INT NOT NULL,
    quantity        INT NOT NULL,
    unit_price      DECIMAL(10,2) NOT NULL,        -- price at time of order
    FOREIGN KEY (order_id)   REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- 6. Payments  — one payment per order
-- ------------------------------------------------------------
CREATE TABLE Payments (
    payment_id     INT AUTO_INCREMENT PRIMARY KEY,
    order_id       INT NOT NULL UNIQUE,
    payment_date   DATE,
    amount         DECIMAL(10,2) NOT NULL,
    payment_method VARCHAR(20),                    -- UPI / Credit Card / Debit Card / Net Banking / Cash on Delivery
    payment_status VARCHAR(20) DEFAULT 'Pending',   -- Completed / Pending / Failed
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- 7. Reviews  — customer ratings/reviews on products
-- ------------------------------------------------------------
CREATE TABLE Reviews (
    review_id   INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    product_id  INT NOT NULL,
    rating      INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    review_date DATE,
    comments    VARCHAR(255),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (product_id)  REFERENCES Products(product_id)
) ENGINE=InnoDB;
