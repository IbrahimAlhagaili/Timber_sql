SET LINESIZE 500
SET PAGESIZE 66

-- Report: Displays products in a specific price range (0-100$ in this case) and orders them from highest to lowest price. This query uses restricting rows and select statements
SET ECHO ON
SPOOL C:\productbyprices.txt

COLUMN product_id HEADING "PRODUCT_ID" FORMAT 999
COLUMN product_name HEADING "PRODUCT_NAME" FORMAT A30
COLUMN product_description HEADING "PRODUCT_DESCRIPTION" FORMAT A50
COLUMN product_weight HEADING "PRODUCT_WEIGHT" FORMAT 999.999
COLUMN category_id HEADING "CATEGORY_ID" FORMAT 999
COLUMN price HEADING "PRICE" FORMAT $999.99 
COLUMN product_stock HEADING "PRODUCT_STOCK" FORMAT 999

SELECT * FROM products 
WHERE price BETWEEN 0 AND 100
ORDER BY price DESC; 

columns clear;
SPOOL OFF
SET ECHO OFF
