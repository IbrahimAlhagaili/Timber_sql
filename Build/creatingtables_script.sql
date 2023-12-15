SET ECHO on 

SPOOL C:\creating_tables_spool.txt

CREATE TABLE Customers (
    customer_id NUMBER(20) PRIMARY KEY,
    first_name VARCHAR2(50) NOT NULL,
    last_name VARCHAR2(50) NOT NULL,
    email VARCHAR2(50) NOT NULL UNIQUE CHECK (REGEXP_LIKE(email, '^[A-Za-z]+[A-Za-z0-9.]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$')),
    phone_number VARCHAR2(15) NOT NULL
);

CREATE TABLE Suppliers (
    supplier_id NUMBER(20) PRIMARY KEY,
    supplier_name VARCHAR2(50) NOT NULL,
    supplier_address VARCHAR2(150) NOT NULL,
    supplier_email VARCHAR2(50) NOT NULL UNIQUE CHECK (REGEXP_LIKE(supplier_email,'^[A-Za-z]+[A-Za-z0-9.]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$')),
    supplier_phone_number VARCHAR2(15) NOT NULL,
    products_available NUMBER(10) NOT NULL CHECK (products_available >= 0)
);

CREATE TABLE Category (
    category_id NUMBER(20) PRIMARY KEY,
    category_name VARCHAR2(50) NOT NULL UNIQUE
);

CREATE TABLE SubCategory (
    sub_category_id NUMBER(20) PRIMARY KEY,
    sub_category_name VARCHAR2(50),
    category_id NUMBER(20),
    CONSTRAINT fk_category_subcategory FOREIGN KEY (category_id) REFERENCES Category(category_id)
);

CREATE TABLE Products (
    product_id NUMBER(20) PRIMARY KEY,
    product_name VARCHAR2(50) NOT NULL,
    product_description VARCHAR2(500) NOT NULL,
    product_weight NUMBER(10,2) NOT NULL CHECK (product_weight > 0),
    category_id NUMBER(20) NOT NULL,
    price NUMBER(10,2) NOT NULL CHECK (price > 0),
    product_stock NUMBER(10) NOT NULL CHECK (product_stock >= 1),
    CONSTRAINT fk_category_products FOREIGN KEY (category_id) REFERENCES Category(category_id)
);

CREATE TABLE ProductSupplierBridge (
    product_id NUMBER(20),
    supplier_id NUMBER(20),
    CONSTRAINT pk_product_supplier PRIMARY KEY (product_id, supplier_id),
    CONSTRAINT fk_product FOREIGN KEY (product_id) REFERENCES Products(product_id),
    CONSTRAINT fk_supplier FOREIGN KEY (supplier_id) REFERENCES Suppliers(supplier_id)
);
--Modified review message to make it longer
CREATE TABLE Reviews (
    review_id NUMBER(20) PRIMARY KEY,
    customer_id NUMBER(20),
    product_id NUMBER(20),
    review_date DATE,
    review_message VARCHAR2(100),
    rating NUMBER(4,1),
    CONSTRAINT fk_customer_reviews FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    CONSTRAINT fk_product_reviews FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

CREATE TABLE Location (
    location_id NUMBER(20),
    street_address VARCHAR2(150) NOT NULL,
    province VARCHAR2(20) NOT NULL,
    city VARCHAR2(20) NOT NULL,
    postal_code VARCHAR2(7) NOT NULL CHECK (REGEXP_LIKE(postal_code, '^[A-Z]\d[A-Z]\d[A-Z]\d$'))
);

-- Creating the location table using the Alter Table command to add constraints
ALTER TABLE Location
ADD CONSTRAINT location_pk PRIMARY KEY (location_id);

CREATE TABLE Orders (
    order_id NUMBER(20) PRIMARY KEY,
    customer_id NUMBER(20),
    order_date DATE NOT NULL,
    location_id NUMBER(20),
    quantity_ordered NUMBER(10) NOT NULL CHECK (quantity_ordered > 0),
    CONSTRAINT fk_customer_orders FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    CONSTRAINT fk_location_orders FOREIGN KEY (location_id) REFERENCES Location(location_id)
);

CREATE TABLE OrderProductBridge (
    product_id NUMBER(20), 
    order_id NUMBER(20),
    CONSTRAINT pk_order_product PRIMARY KEY (product_id, order_id),
    CONSTRAINT fk_product_1 FOREIGN KEY (product_id) REFERENCES Products(product_id),
    CONSTRAINT fk_order FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

CREATE TABLE Shipping (
    shipping_id NUMBER(20),
    location_id NUMBER(20) NOT NULL,
    date_shipped DATE NOT NULL,
    free_shipping NUMBER(1),
    shipping_rate NUMBER(5,2) NOT NULL,
    high_priority NUMBER(1)
);

ALTER TABLE Shipping
ADD CONSTRAINT chk_free_shipping CHECK (free_shipping IN (0,1))
ADD CONSTRAINT chk_high_priority CHECK (high_priority IN (0,1))
ADD CONSTRAINT pk_shipping PRIMARY KEY (shipping_id)
ADD CONSTRAINT fk_location_shipping FOREIGN KEY (location_id) REFERENCES Location(location_id);

CREATE TABLE Taxes (
    tax_id NUMBER(20),
    location_id NUMBER(20) NOT NULL,
    provincial_tax_rate NUMBER(5,2) NOT NULL,
    federal_tax_rate NUMBER(5,2) NOT NULL,
    hst NUMBER(5,2),
    gst NUMBER(5,2)
);

ALTER TABLE Taxes
ADD CONSTRAINT chk_provincial_tax CHECK (provincial_tax_rate > 0)
ADD CONSTRAINT chk_federal_tax CHECK (federal_tax_rate > 0)
ADD CONSTRAINT chk_hst CHECK (hst > 0)
ADD CONSTRAINT chk_gst CHECK (gst > 0)
ADD CONSTRAINT pk_taxes PRIMARY KEY (tax_id)
ADD CONSTRAINT fk_location_tax FOREIGN KEY (location_id) REFERENCES Location(location_id);

CREATE TABLE Payments (
    payment_id NUMBER(20),
    shipping_id NUMBER(20) NOT NULL,
    payment_amount NUMBER(10,2) NOT NULL,
    date_paid DATE NOT NULL,
    payment_type VARCHAR2(50) NOT NULL,
    tax_id NUMBER(20) NOT NULL,
    order_id NUMBER(20) NOT NULL
);

ALTER TABLE Payments
ADD CONSTRAINT pk_payment PRIMARY KEY (payment_id)
ADD CONSTRAINT fk_shipping_id FOREIGN KEY (shipping_id) REFERENCES Shipping(shipping_id)
ADD CONSTRAINT fk_order_id FOREIGN KEY (order_id) REFERENCES Orders (order_id)
ADD CONSTRAINT fk_tax_id FOREIGN KEY (tax_id) REFERENCES Taxes (tax_id)
ADD CONSTRAINT chk_payment_amount CHECK (payment_amount > 0)
ADD CONSTRAINT chk_payment_type CHECK (payment_type IN ('Visa', 'Mastercard', 'Amex', 'Debit'));

SPOOL OFF
SET ECHO OFF
