CREATE DATABASE IF NOT EXISTS blinkit_analytics;
USE blinkit_analytics;

CREATE TABLE blinkit_orders (
    order_id VARCHAR(20) PRIMARY KEY,
    order_date DATETIME,
    customer_id VARCHAR(10),
    product_id VARCHAR(10),
    product_name VARCHAR(100),
    category VARCHAR(50),
    quantity INT,
    unit_price_inr DECIMAL(10,2),
    discount_pct DECIMAL(5,2),
    discount_inr DECIMAL(10,2),
    total_amount_inr DECIMAL(10,2),
    payment_method VARCHAR(30),
    order_status VARCHAR(20),
    delivery_time_min INT NULL,
    city VARCHAR(30),
    area VARCHAR(40),
    delivery_partner VARCHAR(30),
    customer_rating INT NULL
);

-- After importing the CSV into blinkit_orders, try:
-- 1. Total orders
SELECT COUNT(*) AS total_orders FROM blinkit_orders;

-- 2. Revenue from delivered orders
SELECT SUM(total_amount_inr) AS delivered_revenue
FROM blinkit_orders WHERE order_status = 'Delivered';

-- 3. Revenue by category
SELECT category, SUM(total_amount_inr) AS revenue
FROM blinkit_orders
WHERE order_status = 'Delivered'
GROUP BY category ORDER BY revenue DESC;

-- 4. Monthly revenue
SELECT DATE_FORMAT(order_date, '%Y-%m') AS order_month,
       SUM(total_amount_inr) AS revenue
FROM blinkit_orders
WHERE order_status = 'Delivered'
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY order_month;

-- 5. Best-selling products
SELECT product_name, SUM(quantity) AS units_sold,
       COUNT(DISTINCT order_id) AS order_count
FROM blinkit_orders
WHERE order_status = 'Delivered'
GROUP BY product_name
ORDER BY units_sold DESC;
