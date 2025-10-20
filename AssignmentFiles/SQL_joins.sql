USE coffeeshop_db;

-- =========================================================
-- JOINS & RELATIONSHIPS PRACTICE
-- =========================================================

-- Q1) Join products to categories: list product_name, category_name, price.

SELECT
	products.product_id,
    categories.name
FROM products
INNER JOIN categories
	ON products.category_id = categories.category_id;

-- Q2) For each order item, show: order_id, order_datetime, store_name,
--     product_name, quantity, line_total (= quantity * products.price).
--     Sort by order_datetime, then order_id.
 
SELECT
	orders.order_id, 
    orders.order_datetime, 
    stores.name AS store_name, 
    products.name AS store_name, 
    order_items.quantity,
    (order_items.quantity * products.price) AS line_total
FROM orders
INNER JOIN stores
	ON orders.store_id = stores.store_id
INNER JOIN order_items
	ON orders.order_id = order_items.order_id
INNER JOIN products
	ON order_items.product_id = products.product_id
ORDER BY orders.order_datetime DESC;

-- Q3) Customer order history (PAID only):
--     For each order, show customer_name, store_name, order_datetime,
--     order_total (= SUM(quantity * products.price) per order).

SELECT
	orders.customer_id,
    orders.store_id,
    orders.order_datetime,
    SUM(order_items.quantity * products.price) AS order_total
FROM orders
INNER JOIN order_items
	ON orders.order_id = order_items.order_id
INNER JOIN products
	ON order_items.product_id = products.product_id
WHERE status='paid'
GROUP BY orders.customer_id, orders.store_id, orders.order_datetime;

-- Q4) Left join to find customers who have never placed an order.
--     Return first_name, last_name, city, state.

SELECT
	customers.first_name,
    customers.last_name,
    customers.city,
    customers.state
FROM customers
LEFT JOIN orders
	ON customers.customer_id = orders.customer_id
WHERE order_id IS NULL;

-- Q5) For each store, list the top-selling product by units (PAID only).
--     Return store_name, product_name, total_units.
--     Hint: Use a window function (ROW_NUMBER PARTITION BY store) or a correlated subquery.

SELECT
    store_name,
    product_name,
    total_orders
FROM (
	SELECT
    SUM(order_items.quantity) AS total_orders,
    stores.name AS store_name,
    products.name AS product_name,
    ROW_NUMBER() 
		OVER( 
		PARTITION BY stores.name
		ORDER BY SUM(order_items.quantity) DESC
		) AS rank_of_orders
	FROM order_items
INNER JOIN products
	ON order_items.product_id = products.product_id
INNER JOIN orders
	ON order_items.order_id = orders.order_id
INNER JOIN stores
	ON orders.store_id = stores.store_id
WHERE orders.status='paid'
GROUP BY store_name, product_name) AS insane_sub_query
WHERE rank_of_orders = 1;
-- Golllllyyyyy this one was hard :'(

-- Q6) Inventory check: show rows where on_hand < 12 in any store.
--     Return store_name, product_name, on_hand.

SELECT
	stores.name AS store_name,
    products.name AS product_name,
    inventory.on_hand AS inventory_on_hand
FROM inventory
INNER JOIN products
	ON inventory.product_id = products.product_id
INNER JOIN stores
	ON inventory.store_id = stores.store_id
WHERE inventory.on_hand < 12;

-- Q7) Manager roster: list each store's manager_name and hire_date.
--     (Assume title = 'Manager').

SELECT
	employees.first_name,
    employees.last_name,
    employees.hire_date,
    stores.name AS store_name
FROM employees
LEFT JOIN stores
	ON employees.store_id = stores.store_id
WHERE title='Manager'
ORDER BY hire_date DESC;

-- Q8) Using a subquery/CTE: list products whose total PAID revenue is above
--     the average PAID product revenue. Return product_name, total_revenue.

WITH computation AS (
SELECT
	products.name AS product_name,
	SUM(order_items.quantity * products.price) AS total_revenue
FROM products
INNER JOIN order_items
	ON products.product_id = order_items.product_id
INNER JOIN orders
	ON order_items.order_id = orders.order_id
WHERE status='paid'
GROUP BY products.product_id
)
SELECT *
FROM computation	
HAVING total_revenue > (SELECT AVG(total_revenue)FROM computation);

-- Q9) Churn-ish check: list customers with their last PAID order date.
--     If they have no PAID orders, show NULL.
--     Hint: Put the status filter in the LEFT JOIN's ON clause to preserve non-buyer rows.

SELECT 
	customers.first_name AS first_name,
    customers.last_name AS last_name,
    DATE(orders.order_datetime) AS order_date
FROM customers
LEFT JOIN orders
	ON customers.customer_id = orders.customer_id 
WHERE orders.status='paid';

-- Q10) Product mix report (PAID only):
--     For each store and category, show total units and total revenue (= SUM(quantity * products.price)).

SELECT 
	stores.name AS store_name,
    categories.name AS category_name,
	SUM(order_items.quantity) AS quantity,
    SUM(order_items.quantity * products.price) AS total_revenue
FROM order_items
INNER JOIN orders
	ON order_items.order_id = orders.order_id
LEFT JOIN products
	ON order_items.product_id = products.product_id
INNER JOIN stores
	ON stores.store_id = orders.store_id
INNER JOIN categories
	ON products.category_id = categories.category_id
WHERE orders.status='paid'
GROUP BY store_name, category_name;
	
    
    
    
    
    
    
    
