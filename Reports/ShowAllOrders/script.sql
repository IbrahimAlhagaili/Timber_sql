SET LINESIZE 500
SET PAGESIZE 66

-- Report: Show all customer orders using basic select statements.
SET ECHO ON
SPOOL C:\Orders.txt

COLUMN order_date FORMAT A10
COLUMN quantity_ordered FORMAT 999 

SELECT * FROM orders;

clear columns; 
SPOOL OFF
SET ECHO OFF

