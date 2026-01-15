--1
SELECT 
      SUM(quantity*price) AS total_revenue
FROM invoice_items;

--2
SELECT p.product_name,
       SUM(i.quantity*i.price) AS revenue
FROM invoice_items i
JOIN products p ON i.product_id = p.product_id
GROUP BY p.product_name
ORDER BY revenue DESC
LIMIT 10;

--3
WITH product_revenue AS (
    SELECT
        p.product_name,
        SUM(i.quantity*i.price) AS revenue
    FROM invoice_items i
    JOIN products p ON i.product_id = p.product_id
    GROUP BY p.product_name
),
avg_revenue AS (
    SELECT AVG(revenue) AS avg_rev
    FROM product_revenue
)
SELECT pr.product_name,
       pr.revenue,
       round ((SELECT avg_rev FROM avg_revenue), 2) AS average_revenue
FROM product_revenue pr
WHERE pr.revenue > (SELECT avg_rev FROM avg_revenue)
ORDER BY pr.revenue DESC;

--4
SELECT p.product_name,
       COUNT(*) AS return_count
FROM invoice_items i
JOIN products p ON i.product_id = p.product_id
WHERE return_flag = 1
GROUP BY p.product_name
ORDER BY return_count DESC;

--5
SELECT
    customer_id,
    COUNT(*) AS returned_items
FROM invoices i
JOIN invoice_items it ON i.invoice_id = it.invoice_id
WHERE it.return_flag = 1
GROUP BY customer_id
ORDER BY returned_items DESC
LIMIT 10;

--6
SELECT SUM (quantity*price) AS return_loss
FROM invoice_items
WHERE return_flag = 1;

--7
SELECT DATE_TRUNC('month', order_date) AS month,
       SUM (quantity*price) AS monthly_sales
FROM invoices inv
JOIN invoice_items it ON inv.invoice_id = it.invoice_id
GROUP BY month
ORDER BY month;

--8
SELECT payment_method,
       SUM (quantity*price) AS revenue
FROM invoices i
JOIN invoice_items it ON i.invoice_id = it.invoice_id
GROUP BY payment_method
ORDER BY revenue DESC;
