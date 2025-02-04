DROP DATABASE IF EXISTS bmo22a;  
CREATE DATABASE IF NOT EXISTS bmo22a;  
USE bmo22a;  

DROP TABLE IF EXISTS company;  
CREATE TABLE IF NOT EXISTS company (  
    cmp_id INT UNSIGNED NOT NULL AUTO_INCREMENT,  
    cmp_type ENUM('C-Corp', 'S-Corp', 'Non-Profit-Corp', 'LLC', 'Partnership'),  
    cmp_street VARCHAR(30) NOT NULL,  
    cmp_city VARCHAR(30) NOT NULL,  
    cmp_state CHAR(2) NOT NULL,  
    cmp_zip CHAR(9) NOT NULL COMMENT 'no dashes',  
    cmp_phone CHAR(10) NOT NULL COMMENT 'Use CHAR to preserve leading zeros',  
    cmp_ytd_sales DECIMAL(10,2) NOT NULL COMMENT '12,345,678.90',  
    cmp_email VARCHAR(100) NULL,  
    cmp_url VARCHAR(100) NULL,  
    cmp_notes VARCHAR(255) NULL,  
    PRIMARY KEY (cmp_id)  
) ENGINE = InnoDB CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;  

INSERT INTO company (cmp_type, cmp_street, cmp_city, cmp_state, cmp_zip, cmp_phone, cmp_ytd_sales, cmp_url, cmp_notes)  
VALUES  
    ('C-Corp', '1234 Maple St.', 'Bellevue', 'WA', '980052341', '4251234567', 5678901.00, 'http://www.maplecorp.com', 'company notes6'),  
    ('S-Corp', '5678 Pine Ave.', 'Everett', 'WA', '982014567', '4259876543', 7890123.00, 'http://www.pineindustries.com', 'company notes7'),  
    ('Non-Profit-Corp', '910 Cedar Blvd.', 'Olympia', 'WA', '985010987', '3601237890', 345678.00, 'http://www.cedarfoundation.org', 'company notes8'),  
    ('LLC', '246 Oak Lane', 'Spokane', 'WA', '992010246', '5094561234', 1234567.00, 'http://www.oaksolutions.com', 'company notes9'),  
    ('Partnership', '135 Birch Rd.', 'Bellingham', 'WA', '982250135', '3607894561', 2345678.00, 'http://www.birchpartners.com', 'company notes10');  

DROP TABLE IF EXISTS customer;  
CREATE TABLE IF NOT EXISTS customer (  
    cus_id INT UNSIGNED NOT NULL AUTO_INCREMENT,  
    cmp_id INT UNSIGNED NOT NULL,  
    cus_ssn BINARY(64) NOT NULL,  
    cus_pepper BINARY(64) NOT NULL COMMENT "Do NOT use 'salt' in the name",  
    cus_type ENUM('Loyal', 'Discount', 'Impulse', 'Need-Based', 'Wandering'),  
    cus_first VARCHAR(15) NOT NULL,  
    cus_last VARCHAR(30) NOT NULL,  
    cus_street VARCHAR(30) NULL,  
    cus_city VARCHAR(30) NULL,  
    cus_state CHAR(2) NULL,  
    cus_zip CHAR(9) NULL,  
    cus_phone CHAR(10) NOT NULL,  
    cus_email VARCHAR(100) NULL,  
    cus_balance DECIMAL(7,2) NULL COMMENT "12,345.67",  
    cus_tot_sales DECIMAL(7,2) NULL,  
    cus_notes VARCHAR(255) NULL,  
    PRIMARY KEY (cus_id),  
    UNIQUE INDEX ux_cus_ssn (cus_ssn ASC),  
    INDEX idx_cmp_id (cmp_id ASC),  
    CONSTRAINT fk_customer_company  
        FOREIGN KEY (cmp_id)  
        REFERENCES company (cmp_id)  
        ON DELETE NO ACTION  
        ON UPDATE CASCADE  
) ENGINE = InnoDB CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;  

set @salt = random_bytes(64);

INSERT INTO customer (cus_id, cmp_id, cus_ssn, cus_pepper, cus_type, cus_first, cus_last, cus_street, cus_city, cus_state, cus_zip, cus_phone, cus_email, cus_balance, cus_tot_sales, cus_notes)  
VALUES  
    (null, 2, UNHEX(SHA2(CONCAT(@salt, '004456781'), 512)), @salt, 'Discount', 'Alex', 'Johnson', '123 Oak St.', 'Dallas', 'TX', '750012345', '2145556789', 'alex.j@email.com', 10234.56, 50432.75, 'Regular customer'),  
    (null, 4,UNHEX(SHA2(CONCAT(@salt, '004456782'), 512)), @salt, 'Loyal', 'Samantha', 'Miller', '456 Pine Ave.', 'Austin', 'TX', '733013456', '5129876543', 'sam.m@email.com', 8750.32, 40210.98, 'Prefers online orders'),  
    (null, 3,UNHEX(SHA2(CONCAT(@salt, '004456783'), 512)), @salt, 'Impulse', 'Michael', 'Davis', '789 Birch Blvd.', 'Houston', 'TX', '770019876', '7132345678', 'michael.d@email.com', 1345.78, 7823.45, 'Frequent but small purchases'), 
    (null, 5,UNHEX(SHA2(CONCAT(@salt, '004456784'), 512)), @salt, 'Need-Based', 'Jessica', 'Lopez', '159 Maple Ct.', 'San Antonio', 'TX', '782101234', '2108765432', 'jessica.l@email.com', 321.09, 12098.34, 'Buys only when necessary'),  
    (null, 1,UNHEX(SHA2(CONCAT(@salt, '004456785'), 512)), @salt, 'Wandering', 'Daniel', 'Smith', '753 Cedar Rd.', 'Fort Worth', 'TX', '761019876', '8175554321', 'daniel.s@email.com', 580.45, 2398.67, 'Rarely purchases');  


SHOW WARNINGS;  
SELECT * FROM company;  
SELECT * FROM customer;  


-- Create user1 and user2 with passwords
-- CREATE USER IF NOT EXISTS 'user1'@'localhost' IDENTIFIED BY 'test1';
-- CREATE USER IF NOT EXISTS 'user2'@'localhost' IDENTIFIED BY 'test2';
-- flush privileges;


-- use mysql;
-- select * from user;

-- Grant user1 SELECT, UPDATE, DELETE privileges on company and customer tables
-- GRANT SELECT, UPDATE, DELETE 
-- ON bmo22a.company 
-- TO 'user1'@'localhost';
-- GRANT SELECT, UPDATE, DELETE 
-- ON bmo22a.customer 
-- TO 'user1'@'localhost';

-- Grant user2 SELECT, INSERT privileges on customer table
-- GRANT SELECT, INSERT 
-- ON bmo22a.customer 
-- TO 'user2'@'localhost';

-- FLUSH privileges;


-- show grants
-- SHOW GRANTS FOR 'root'@'localhost';

-- SHOW GRANTS FOR 'user1'@'localhost';

-- SHOW GRANTS FOR 'user2'@'localhost';

-- Display current user2 (logged in as user2) and MySQL version
-- SELECT USER(), CURRENT_USER();
-- SELECT VERSION();

-- List tables (as admin)
-- SHOW TABLES;

--  Display Structures for Both Tables (As Admin)
-- use bmo22a;
-- DESC company;
-- DESC customer;

-- Display Data for Both Tables
-- SELECT * FROM company;
-- SELECT * FROM customer;

-- Log in as user1 and Attempt Inserts
-- INSERT INTO company (id, name) VALUES (1, 'TestCompany');
-- INSERT INTO customer (id, name) VALUES (1, 'TestCustomer');

-- Log in as user2 and Check Access Issues
-- SHOW TABLES LIKE 'company';
-- DELETE FROM customer WHERE id = 1;

-- Log in as Admin and Remove Both Tables
-- DROP TABLE IF EXISTS company;
-- DROP TABLE IF EXISTS customer;








