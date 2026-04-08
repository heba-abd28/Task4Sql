CREATE DATABASE food_deliveryDB;
USE food_deliveryDB;

-- Customers
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(50)
);

-- Restaurants
CREATE TABLE restaurants (
    restaurant_id INT PRIMARY KEY,
    name VARCHAR(50)
);

-- Menu Items
CREATE TABLE menuItems (
    item_id INT PRIMARY KEY,
    itemname VARCHAR(50),
    price DECIMAL(5,2),
    restaurant_id INT,
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(restaurant_id)
);

-- Orders
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    restaurant_id INT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(restaurant_id)
);

-- Junction Table
CREATE TABLE Order_Items (
    order_id INT,
    item_id INT,
    quantity INT,
    PRIMARY KEY (order_id, item_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (item_id) REFERENCES menuItems(item_id)
); 
  -- Customers
INSERT INTO customers VALUES
(1, 'Omar'),
(2, 'Haya'),
(3, 'Yazan');

-- Restaurants
INSERT INTO restaurants VALUES
(1, 'Italian House'),
(2, 'Fast Food Hub');

-- Menu Items
INSERT INTO menuItems VALUES
(1, 'Pizza', 8.00, 1),
(2, 'Pasta', 7.00, 1),
(3, 'Burger', 5.00, 2),
(4, 'Fries', 3.00, 2),
(5, 'Salad', 4.00, 1); -- هذا ما رح ينطلب

-- Orders
INSERT INTO orders VALUES
(1, 1, 1), -- Omar من مطعم 1
(2, 2, 2); -- Haya من مطعم 
INSERT INTO orders (order_id, customer_id, restaurant_id) VALUES
(4, 1, 2); -- الآن العميل 1 طلب من مطعم 1 و2

-- Order Items
INSERT INTO Order_Items VALUES
(1, 1, 2), -- 2 Pizza
(1, 2, 1), -- 1 Pasta
(2, 3, 1), -- 1 Burger
(2, 4, 2); -- 2 Fries
---Q1
SELECT c.name, o.order_id
FROM customers c
LEFT JOIN orders o
ON c.customer_id = o.customer_id;
---Q2---
SELECT c.name, o.order_id
FROM customers c
INNER JOIN orders o
ON c.customer_id = o.customer_id;
--Q3----
SELECT m.itemname
FROM menuItems m
LEFT JOIN Order_Items oi
ON m.item_id = oi.item_id
WHERE oi.item_id IS NULL;
----Q4-----------
SELECT c.Name, o.order_id
FROM Customers c
LEFT JOIN Orders o
ON c.customer_id = o.customer_id;
-----Q5-------------
SELECT 
    c.name AS CustomerName,
    o.order_id AS OrderID,
    m.itemname AS ItemName,
    oi.quantity AS Quantity,
    (m.price * oi.quantity) AS TotalPrice
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN Order_Items oi ON o.order_id = oi.order_id
JOIN menuItems m ON oi.item_id = m.item_id;
-----Q6---------------------------
SELECT TOP 1 
    m.itemname, 
    SUM(oi.quantity) AS total_ordered
FROM Order_Items oi
JOIN menuItems m ON oi.item_id = m.item_id
GROUP BY m.itemname
ORDER BY total_ordered DESC;
----Q7---------
SELECT c.name
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.name
HAVING COUNT(DISTINCT o.restaurant_id) > 1;