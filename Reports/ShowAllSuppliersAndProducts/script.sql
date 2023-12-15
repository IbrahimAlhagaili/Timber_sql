SET LINESIZE 500
SET PAGESIZE 66
-- Report: To show all suppliers and the products they provide Using basic select and joins 
SET ECHO ON
SPOOL C:\SupplierAndProducts.txt

COLUMN supplier_name FORMAT A30
COLUMN product_name FORMAT A30

SELECT
    Suppliers.supplier_id,
    Suppliers.supplier_name,
    Products.product_id,
    Products.product_name
FROM
    Suppliers
JOIN
    ProductSupplierBridge ON Suppliers.supplier_id = ProductSupplierBridge.supplier_id
JOIN
    Products ON ProductSupplierBridge.product_id = Products.product_id
ORDER BY
    Suppliers.supplier_id, Products.product_id;

CLEAR COLUMNS; 
SPOOL OFF
SET ECHO OFF
