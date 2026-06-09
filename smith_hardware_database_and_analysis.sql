
CREATE DATABASE smith_hardware;
USE smith_hardware

CREATE TABLE regions (
    region_id INT PRIMARY KEY AUTO_INCREMENT,
    region_name VARCHAR(50) NOT NULL,
    city VARCHAR(50),
    manager VARCHAR(100)
);

SHOW DATABASES;
SHOW TABLES;

INSERT INTO regions (region_name, city, manager)
VALUES
('North', 'Delhi', 'Amit Sharma'),
('South', 'Bangalore', 'Priya Nair'),
('East', 'Kolkata', 'Raju Das'),
('West', 'Mumbai', 'Sneha Patil'),
('Central', 'Bhopal', 'Vikram Singh');

SELECT * FROM regions;

CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    unit_price DECIMAL(10,2),
    cost_price DECIMAL(10,2)
);

INSERT INTO products (product_name, category, unit_price, cost_price)
VALUES
('Hammer 16oz', 'Hand Tools', 450.00, 220.00),
('Electric Drill 750W', 'Power Tools', 2800.00, 1500.00),
('PVC Pipe 1 inch', 'Plumbing', 85.00, 40.00),
('Cement 50kg', 'Building', 420.00, 280.00),
('Paint Brush Set', 'Painting', 350.00, 160.00),
('Safety Gloves', 'Safety', 220.00, 90.00),
('Measuring Tape 10m', 'Hand Tools', 180.00, 75.00),
('Angle Grinder 4 inch', 'Power Tools', 3200.00, 1800.00);

SELECT * FROM products;

CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_type VARCHAR(50),
    customer_name VARCHAR(100)
);

INSERT INTO customers (customer_type, customer_name)
VALUES
('Retail', 'Walk-in Customer'),
('Contractor', 'Local Contractor'),
('Wholesale', 'Hardware Reseller'),
('Government', 'Govt Department'),
('Corporate', 'Construction Firm');

CREATE TABLE sales (
    sale_id INT PRIMARY KEY AUTO_INCREMENT,
    sale_date DATE NOT NULL,
    product_id INT,
    region_id INT,
    customer_id INT,
    quantity_sold INT,
    revenue DECIMAL(12,2),

    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (region_id) REFERENCES regions(region_id),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

SHOW TABLES;
SELECT * FROM products;
SELECT *
FROM regions;
SELECT region_name
FROM regions;
SELECT city
FROM regions;

INSERT INTO sales
(sale_date, product_id, region_id, customer_id, quantity_sold, revenue)
VALUES
('2024-01-05', 2, 1, 2, 3, 8400),
('2024-01-10', 1, 4, 1, 5, 2250),
('2024-01-15', 8, 2, 5, 2, 6400),
('2024-01-20', 4, 3, 4, 10, 4200),
('2024-01-25', 5, 5, 3, 7, 2450);

SELECT
    s.sale_date,
    p.product_name,
    r.region_name,
    c.customer_type,
    s.quantity_sold,
    s.revenue
FROM sales s
JOIN products p
    ON s.product_id = p.product_id
JOIN regions r
    ON s.region_id = r.region_id
JOIN customers c
    ON s.customer_id = c.customer_id;
    
SELECT COUNT(*) AS total_rows
FROM sales;
TRUNCATE TABLE sales;
SELECT COUNT(*) FROM sales;
SELECT COUNT(*) FROM sales;
SELECT COUNT(*) FROM sales;
SELECT COUNT(*) AS total_rows
FROM sales;
SELECT
    MIN(sale_date) AS first_sale,
    MAX(sale_date) AS last_sale
FROM sales;

SELECT
    r.region_name,
    COUNT(s.sale_id) AS total_orders,
    SUM(s.quantity_sold) AS total_quantity,
    ROUND(SUM(s.revenue), 2) AS total_revenue
FROM sales s
JOIN regions r
    ON s.region_id = r.region_id
GROUP BY r.region_name
ORDER BY total_revenue DESC;

SELECT
    r.region_name,
    ROUND(SUM(s.revenue)/COUNT(s.sale_id),2) AS avg_order_value
FROM sales s
JOIN regions r
ON s.region_id = r.region_id
GROUP BY r.region_name
ORDER BY avg_order_value DESC;

SELECT
    DATE_FORMAT(sale_date, '%Y-%m') AS month,
    ROUND(SUM(revenue), 2) AS monthly_revenue,
    COUNT(sale_id) AS monthly_orders
FROM sales
GROUP BY DATE_FORMAT(sale_date, '%Y-%m')
ORDER BY month ASC;

SELECT
    DATE_FORMAT(sale_date, '%Y-%m') AS month,
    COUNT(*) AS orders,
    ROUND(SUM(revenue),2) AS revenue,
    ROUND(SUM(revenue)/COUNT(*),2) AS avg_order_value
FROM sales
GROUP BY DATE_FORMAT(sale_date, '%Y-%m')
ORDER BY month DESC;

SELECT
    p.product_name,
    SUM(s.quantity_sold) AS units_sold,
    ROUND(SUM(s.revenue),2) AS total_revenue
FROM sales s
JOIN products p
ON s.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_revenue DESC;

SELECT
    p.product_name,
    ROUND(SUM(s.revenue)/SUM(s.quantity_sold),2) AS revenue_per_unit
FROM sales s
JOIN products p
ON s.product_id = p.product_id
GROUP BY p.product_name
ORDER BY revenue_per_unit DESC;

SELECT
    c.customer_type,
    COUNT(s.sale_id) AS total_orders,
    ROUND(SUM(s.revenue),2) AS total_revenue,
    ROUND(AVG(s.revenue),2) AS avg_order_value
FROM sales s
JOIN customers c
ON s.customer_id = c.customer_id
GROUP BY c.customer_type
ORDER BY total_revenue DESC;

SELECT
    p.category,
    COUNT(s.sale_id) AS total_orders,
    SUM(s.quantity_sold) AS total_units,
    ROUND(SUM(s.revenue), 2) AS total_revenue,
    ROUND(
        SUM(s.revenue) * 100.0 / SUM(SUM(s.revenue)) OVER(),
        1
    ) AS revenue_pct
FROM sales s
JOIN products p ON s.product_id = p.product_id
GROUP BY p.category
ORDER BY total_revenue DESC;

SELECT
    r.region_name,
    ROUND(SUM(s.revenue), 2) AS total_revenue,
    RANK() OVER (ORDER BY SUM(s.revenue) DESC) AS revenue_rank,
    ROUND(MAX(SUM(s.revenue)) OVER() - SUM(s.revenue), 2) AS gap_from_top
FROM sales s
JOIN regions r ON s.region_id = r.region_id
GROUP BY r.region_name;

SELECT VERSION();