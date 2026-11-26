-- =====================================================================
-- CMPE341 - Stock Management System
-- 03_queries.sql : Query design
-- =====================================================================

-- Q1 (JOIN - 5 tables): Current stock list with category, supplier and warehouse
SELECT p.sku,
       p.product_name,
       c.category_name,
       s.supplier_name,
       w.warehouse_name,
       i.shelf_location,
       i.quantity
FROM   inventory i
JOIN   product   p ON p.product_id   = i.product_id
JOIN   category  c ON c.category_id  = p.category_id
JOIN   supplier  s ON s.supplier_id  = p.supplier_id
JOIN   warehouse w ON w.warehouse_id = i.warehouse_id
ORDER  BY w.warehouse_name, p.sku;

-- Q2 (GROUP BY + HAVING + ORDER BY): Sales revenue per category
--     (only shipped/delivered orders, categories with revenue > 5000 TL)
SELECT c.category_name,
       COUNT(DISTINCT so.so_id)                 AS number_of_orders,
       SUM(soi.quantity)                        AS units_sold,
       SUM(soi.quantity * soi.unit_price)       AS total_revenue
FROM   sales_order_item soi
JOIN   sales_order so ON so.so_id      = soi.so_id
JOIN   product     p  ON p.product_id  = soi.product_id
JOIN   category    c  ON c.category_id = p.category_id
WHERE  so.status IN ('Shipped','Delivered')
GROUP  BY c.category_name
HAVING SUM(soi.quantity * soi.unit_price) > 5000
ORDER  BY total_revenue DESC;

-- Q3 (SUBQUERY): Low-stock alert - products whose total quantity in all
--     warehouses is below their reorder level (they must be re-ordered)
SELECT p.sku,
       p.product_name,
       p.reorder_level,
       (SELECT COALESCE(SUM(i.quantity), 0)
          FROM inventory i
         WHERE i.product_id = p.product_id) AS total_stock
FROM   product p
WHERE  p.reorder_level >
       (SELECT COALESCE(SUM(i.quantity), 0)
          FROM inventory i
         WHERE i.product_id = p.product_id)
ORDER  BY p.sku;

-- Q4 (SUBQUERY in HAVING): Customers who spent more than the average
--     customer spending
SELECT cu.customer_name,
       cu.city,
       SUM(soi.quantity * soi.unit_price) AS total_spent
FROM   customer cu
JOIN   sales_order      so  ON so.customer_id = cu.customer_id
JOIN   sales_order_item soi ON soi.so_id      = so.so_id
WHERE  so.status <> 'Cancelled'
GROUP  BY cu.customer_id, cu.customer_name, cu.city
HAVING SUM(soi.quantity * soi.unit_price) >
       (SELECT AVG(t.spent)
          FROM (SELECT so2.customer_id,
                       SUM(soi2.quantity * soi2.unit_price) AS spent
                  FROM sales_order so2
                  JOIN sales_order_item soi2 ON soi2.so_id = so2.so_id
                 WHERE so2.status <> 'Cancelled'
                 GROUP BY so2.customer_id) t)
ORDER  BY total_spent DESC;

-- Q5 (GROUP BY + ORDER BY): Stock value and capacity usage per warehouse
SELECT w.warehouse_name,
       w.city,
       COUNT(i.product_id)                        AS distinct_products,
       SUM(i.quantity)                            AS total_units,
       ROUND(100.0 * SUM(i.quantity) / w.capacity, 2) AS capacity_used_pct,
       SUM(i.quantity * p.unit_price)             AS stock_value
FROM   warehouse w
JOIN   inventory i ON i.warehouse_id = w.warehouse_id
JOIN   product   p ON p.product_id   = i.product_id
GROUP  BY w.warehouse_id, w.warehouse_name, w.city, w.capacity
ORDER  BY stock_value DESC;
