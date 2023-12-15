SET ECHO ON
SET LINESIZE 500
SET PAGESIZE 66

-- Show the quantity and value (including subtotals and grand total) of sales for products categories based on category, customer, supplier, and total.
-- Report ProductSales: Using Group Functions, Single Row functions, Joins, Sorting Data, OLAP, and Subqueries (CHATGPT 3.5 Generated and manually modified) 

SPOOL C:\ProductSales.txt

COLUMN category_name FORMAT a15
COLUMN customer_name FORMAT a15
COLUMN supplier_name FORMAT a30
COLUMN quantity_ordered FORMAT 999,999
COLUMN value_orderd FORMAT $999,999,999.99
COLUMN product_names FORMAT a150
--Help with our subquery structure from (Chat GPT 3.5) 
SELECT
    category_name,
    customer_name,
    supplier_name,
     --COALESCE SYNTAX from chat gpt 3.5 to display 0 for nulls values for products that have no orders 
    COALESCE(SUM(quantity_ordered), 0) AS "QUANTITY_ORDERED",
    TO_CHAR(COALESCE(SUM(quantity_ordered * price), 0), '$999,999,999.99') AS "VALUE_ORDERD",
    -- Help from CHATGPT 3.5 with LISTAGG SYNTAX to display product names for each corresponding row
    LISTAGG(product_name, ', ') WITHIN GROUP (ORDER BY product_name) AS "PRODUCT_NAMES"
FROM (
    SELECT
        Products.product_id,
        Category.category_name,
        ProductSupplierBridge.supplier_id,
        Suppliers.supplier_name,
        Orders.quantity_ordered,
        Customers.first_name || ' ' || Customers.last_name AS "CUSTOMER_NAME",
        Products.price, 
        Products.product_name
    FROM
        Products
    JOIN
        Category ON Products.category_id = Category.category_id
    JOIN
        ProductSupplierBridge ON Products.product_id = ProductSupplierBridge.product_id
    JOIN
        Suppliers ON ProductSupplierBridge.supplier_id = Suppliers.supplier_id
    --Help with left join syntax from chatgpt to include products that dont have any orders
    LEFT JOIN
        OrderProductBridge ON Products.product_id = OrderProductBridge.product_id
    LEFT JOIN
        Orders ON OrderProductBridge.order_id = Orders.order_id
    LEFT JOIN
        Customers ON Orders.customer_id = Customers.customer_id
) subquery
GROUP BY
    ROLLUP(category_name, customer_name, supplier_name)
ORDER BY
    category_name, customer_name, supplier_name;

SPOOL OFF
SET ECHO OFF
