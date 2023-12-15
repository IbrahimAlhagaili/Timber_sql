SET ECHO ON
SET LINESIZE 500
SET PAGESIZE 66
--Report: Show all the customer reviews for a given product (Input a product ID): Using User Inputs, restricting rows and Joins
SPOOL C:\showcustomerreviewsforproduct.txt

--Help with input prompt syntax from chat gpt 3.5
ACCEPT product_id CHAR PROMPT 'Enter Product ID: ';

COLUMN review_id FORMAT 999999
COLUMN "CUSTOMER_NAME" FORMAT A20
COLUMN product_name FORMAT A20
COLUMN review_date FORMAT A20
COLUMN review_message FORMAT A51
COLUMN rating FORMAT A10

SELECT Reviews.review_id,
       Customers.first_name || ' ' || Customers.last_name AS "CUSTOMER_NAME",
       Products.product_name,
       TO_CHAR(Reviews.review_date, 'YYYY-MM-DD') AS review_date,
       Reviews.review_message,
       TO_CHAR(Reviews.rating) AS rating
FROM Reviews
JOIN Customers ON Reviews.customer_id = Customers.customer_id
JOIN Products ON Reviews.product_id = Products.product_id
WHERE Reviews.product_id = '&product_id';
CLEAR COLUMNS;

SPOOL OFF
SET ECHO OFF
