CREATE TABLE retail_sales (
    invoice_id text,
    customer_id text,
    product VARCHAR(50),
    quantity int,      
    price NUMERIC(10,2),
    discount NUMERIC(10,2),
    payment_method VARCHAR(50),
    order_date date,      
    return_flag int
);

select * from retail_sales;


CREATE TABLE invoices (
    invoice_id text PRIMARY KEY,
    customer_id text,
    payment_method VARCHAR(50),
    order_date DATE
);

INSERT INTO invoices (invoice_id, customer_id, payment_method, order_date)
SELECT DISTINCT invoice_id, customer_id, payment_method, order_date
FROM retail_sales
ON CONFLICT (invoice_id) DO NOTHING;

delete from invoices;


CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(50) UNIQUE
);

INSERT INTO products (product_name)
SELECT DISTINCT product
FROM retail_sales;


DROP TABLE invoice_items;

CREATE TABLE invoice_items (
    item_id SERIAL PRIMARY KEY,
    invoice_id VARCHAR(20) REFERENCES invoices(invoice_id),
    product_id INT REFERENCES products(product_id),
    quantity INT,
    price NUMERIC(10,2),
    discount NUMERIC(10,2),
    return_flag INT
);

INSERT INTO invoice_items (invoice_id, product_id, quantity, price, discount, return_flag)
SELECT s.invoice_id, p.product_id, s.quantity, s.price, s.discount, s.return_flag
FROM retail_sales s
JOIN products p ON s.product = p.product_name;



SELECT * FROM products;
SELECT * FROM invoices;
SELECT * FROM invoice_items;















