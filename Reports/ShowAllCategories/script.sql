SET LINESIZE 500
SET PAGESIZE 66

-- Report: Shows the categories and subcategories for those categories using joins and select statements.
SET ECHO ON
SPOOL C:\categories.txt

COLUMN category_name FORMAT A20
COLUMN subcategory_name FORMAT A20

SELECT
    Category.category_name,
    SubCategory.sub_category_name AS subcategory_name
FROM
    Category 
LEFT JOIN
    SubCategory ON Category.category_id = SubCategory.category_id
ORDER BY
    Category.category_id, SubCategory.sub_category_id;

clear columns;
SPOOL OFF
SET ECHO OFF
