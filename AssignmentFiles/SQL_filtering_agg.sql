-- ==================================
-- FILTERS & AGGREGATION
-- ==================================

USE coffeeshop_db;

-- Q1) Compute total items per order.
--     Return (order_id, total_items) from order_items.

SELECT order_id,
SUM(quantity) AS total_items
FROM order_items
GROUP BY order_id;

-- Q2) Compute total items per order for PAID orders only.
--     Return (order_id, total_items). Hint: order_id IN (SELECT ... FROM orders WHERE status='paid').

SELECT 
	order_items.order_id, 
	SUM(order_items.quantity) AS total_items,
	orders.status
FROM order_items
INNER JOIN orders
	ON order_items.order_id = orders.order_id
WHERE status='paid'
GROUP BY order_items.order_id;

-- Q3) How many orders were placed per day (all statuses)?
--     Return (order_date, orders_count) from orders.

-- Q4) What is the average number of items per PAID order?
--     Use a subquery or CTE over order_items filtered by order_id IN (...).

-- Q5) Which products (by product_id) have sold the most units overall across all stores?
--     Return (product_id, total_units), sorted desc.

-- Q6) Among PAID orders only, which product_ids have the most units sold?
--     Return (product_id, total_units_paid), sorted desc.
--     Hint: order_id IN (SELECT order_id FROM orders WHERE status='paid').

-- Q7) For each store, how many UNIQUE customers have placed a PAID order?
--     Return (store_id, unique_customers) using only the orders table.

-- Q8) Which day of week has the highest number of PAID orders?
--     Return (day_name, orders_count). Hint: DAYNAME(order_datetime). Return ties if any.

-- Q9) Show the calendar days whose total orders (any status) exceed 3.
--     Use HAVING. Return (order_date, orders_count).

-- Q10) Per store, list payment_method and the number of PAID orders.
--      Return (store_id, payment_method, paid_orders_count).

-- Q11) Among PAID orders, what percent used 'app' as the payment_method?
--      Return a single row with pct_app_paid_orders (0–100).

-- Q12) Busiest hour: for PAID orders, show (hour_of_day, orders_count) sorted desc.


-- ================
