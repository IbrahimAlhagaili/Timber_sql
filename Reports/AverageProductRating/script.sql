SET LINESIZE 500
SET PAGESIZE 66

-- Report: Displays all products with an average review rating above the input value entered. Using Joins, User inputs, Group functions, and Restricting rows
SET ECHO ON
SPOOL C:\products_above_avg_rating.txt

ACCEPT avg_rating NUMBER PROMPT 'Enter the average rating threshold: '

COLUMN "PRODUCT_ID" FORMAT 999
COLUMN "PRODUCT_NAME" FORMAT A30
COLUMN "PRODUCT_DESCRIPTION" FORMAT A50
COLUMN "PRODUCT_WEIGHT" FORMAT 999.999
COLUMN "PRODUCT_STOCK" FORMAT 999
COLUMN "PRODUCT_RATING" FORMAT 999.99

SELECT 
    products.product_id as "PRODUCT_ID",
    products.product_name as "PRODUCT_NAME",
    products.product_description as "PRODUCT_DESCRIPTION",
    products.product_weight as "PRODUCT_WEIGHT",
    TO_CHAR(products.price, '$999.99') AS "PRICE",
    products.product_stock as "PRODUCT_STOCK",
    AVG(reviews.rating) AS "PRODUCT_RATING"
FROM 
    products
JOIN 
    reviews ON products.product_id = reviews.product_id
GROUP BY 
    products.product_id,
    products.product_name,
    products.product_description,
    products.product_weight,
    products.category_id,
    TO_CHAR(products.price, '$999.99'),
    products.product_stock
HAVING 
    AVG(reviews.rating) > &avg_rating;

clear columns; 
SPOOL OFF
SET ECHO OFF
