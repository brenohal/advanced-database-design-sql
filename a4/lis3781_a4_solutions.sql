-----------------------------------------------------------------------------
-- 1) Recreate the database
-----------------------------------------------------------------------------
USE master;
GO

IF EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = N'bmo22a')
    DROP DATABASE bmo22a;
GO

CREATE DATABASE bmo22a;
GO

USE bmo22a;
GO

-----------------------------------------------------------------------------
-- 2) CREATE TABLE: PERSON
--    (Changed per_zip to CHAR(9) to allow LIKE pattern matching)
-----------------------------------------------------------------------------
IF OBJECT_ID(N'dbo.person', N'U') IS NOT NULL
    DROP TABLE dbo.person;
GO

CREATE TABLE dbo.person
(
    per_id SMALLINT NOT NULL IDENTITY(1,1),
    per_ssn BINARY(64) NULL,
    per_pep BINARY(64) NULL,
    per_fname VARCHAR(15) NOT NULL,
    per_lname VARCHAR(30) NOT NULL,
    per_gender CHAR(1) NOT NULL CHECK (per_gender IN('m', 'f')),
    per_dob DATE NOT NULL,
    per_street VARCHAR(30) NOT NULL,
    per_city VARCHAR(30) NOT NULL,
    per_state CHAR(2) NOT NULL DEFAULT 'FL',
    per_zip CHAR(9) NOT NULL CHECK (per_zip LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
    per_email VARCHAR(100) NULL,
    per_type CHAR(1) NOT NULL CHECK (per_type IN('c', 's')),
    per_notes VARCHAR(45) NULL,
    PRIMARY KEY (per_id),
    
    -- Ensure SSNs are unique
    CONSTRAINT ux_per_ssn UNIQUE NONCLUSTERED (per_ssn ASC)
);
GO

-----------------------------------------------------------------------------
-- 7) CREATE TABLE: PHONE
--    (Changed phn_num to CHAR(10))
-----------------------------------------------------------------------------
IF OBJECT_ID(N'dbo.phone', N'U') IS NOT NULL
    DROP TABLE dbo.phone;
GO

CREATE TABLE dbo.phone
(
    phn_id SMALLINT NOT NULL IDENTITY(1,1),
    per_id SMALLINT NOT NULL,
    phn_num CHAR(10) NOT NULL CHECK (phn_num LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
    phn_type CHAR(1) NOT NULL CHECK (phn_type IN('h','c','w','f')),
    phn_notes VARCHAR(255) NULL,
    PRIMARY KEY (phn_id),

    CONSTRAINT fk_phone_person
        FOREIGN KEY (per_id)
        REFERENCES dbo.person (per_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
GO


-----------------------------------------------------------------------------
-- 8) CREATE TABLE: CUSTOMER
-----------------------------------------------------------------------------
IF OBJECT_ID(N'dbo.customer', N'U') IS NOT NULL
    DROP TABLE dbo.customer;
GO

CREATE TABLE dbo.customer
(
    per_id SMALLINT NOT NULL,
    cus_balance DECIMAL(7,2) NOT NULL CHECK (cus_balance >= 0),
    cus_total_sales DECIMAL(7,2) NOT NULL CHECK (cus_total_sales >= 0),
    cus_notes VARCHAR(45) NULL,
    PRIMARY KEY (per_id),

    CONSTRAINT fk_customer_person
        FOREIGN KEY (per_id)
        REFERENCES dbo.person (per_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
GO

-----------------------------------------------------------------------------
-- 5) CREATE TABLE: SLSREP
-----------------------------------------------------------------------------
IF OBJECT_ID(N'dbo.slsrep', N'U') IS NOT NULL
    DROP TABLE dbo.slsrep;
GO

CREATE TABLE dbo.slsrep
(
    per_id SMALLINT NOT NULL,
    srp_yr_sales_goal DECIMAL(8,2) NOT NULL CHECK (srp_yr_sales_goal >= 0),
    srp_ytd_sales DECIMAL(8,2) NOT NULL CHECK (srp_ytd_sales >= 0),
    srp_ytd_comm DECIMAL(7,2) NOT NULL CHECK (srp_ytd_comm >= 0),
    srp_notes VARCHAR(45) NULL,
    PRIMARY KEY (per_id),

    CONSTRAINT fk_slsrep_person
        FOREIGN KEY (per_id)
        REFERENCES dbo.person (per_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
GO

-----------------------------------------------------------------------------
-- 6) CREATE TABLE: SRP_HIST
-----------------------------------------------------------------------------
IF OBJECT_ID(N'dbo.srp_hist', N'U') IS NOT NULL
    DROP TABLE dbo.srp_hist;
GO

CREATE TABLE dbo.srp_hist
(
    sht_id SMALLINT NOT NULL IDENTITY(1,1),
    per_id SMALLINT NOT NULL,
    sht_type CHAR(1) NOT NULL CHECK (sht_type IN('i', 'u', 'd')),
    sht_modified DATETIME NOT NULL,
    sht_modifier VARCHAR(45) NOT NULL DEFAULT SYSTEM_USER,
    sht_date DATE NOT NULL DEFAULT GETDATE(),
    sht_yr_sales_goal DECIMAL(8,2) NOT NULL CHECK (sht_yr_sales_goal >= 0),
    sht_yr_total_sales DECIMAL(8,2) NOT NULL CHECK (sht_yr_total_sales >= 0),
    sht_yr_total_comm DECIMAL(7,2) NOT NULL CHECK (sht_yr_total_comm >= 0),
    sht_notes VARCHAR(45) NULL,
    PRIMARY KEY (sht_id),

    CONSTRAINT fk_srp_hist_slsrep
        FOREIGN KEY (per_id)
        REFERENCES dbo.slsrep (per_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
GO

-----------------------------------------------------------------------------
-- 11) CREATE TABLE: CONTACT
--     (This table is created before [order] so that its primary key can be referenced)
-----------------------------------------------------------------------------
IF OBJECT_ID(N'dbo.contact', N'U') IS NOT NULL
    DROP TABLE dbo.contact;
GO

CREATE TABLE dbo.contact
(
    cnt_id INT NOT NULL IDENTITY(1,1),
    per_cid SMALLINT NOT NULL,
    per_sid SMALLINT NOT NULL,
    cnt_date DATETIME NOT NULL,
    cnt_notes VARCHAR(255) NULL,
    PRIMARY KEY (cnt_id),

    CONSTRAINT fk_contact_customer
        FOREIGN KEY (per_cid)
        REFERENCES dbo.customer (per_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fk_contact_slsrep 
        FOREIGN KEY (per_sid)
        REFERENCES dbo.slsrep (per_id)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
);
GO

-----------------------------------------------------------------------------
-- 12) CREATE TABLE: [ORDER]
--     (References dbo.contact which now exists)
-----------------------------------------------------------------------------
IF OBJECT_ID(N'dbo.[order]', N'U') IS NOT NULL
    DROP TABLE dbo.[order];
GO

CREATE TABLE dbo.[order]
(
    ord_id INT NOT NULL IDENTITY(1,1),
    cnt_id INT NOT NULL,
    ord_placed_date DATETIME NOT NULL,
    ord_filled_date DATETIME NULL,
    ord_notes VARCHAR(255) NULL,
    PRIMARY KEY (ord_id),

    CONSTRAINT fk_order_contact
        FOREIGN KEY (cnt_id)
        REFERENCES dbo.contact (cnt_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
GO


-----------------------------------------------------------------------------
-- 3) CREATE TABLE: STORE
--    (Changed str_zip to CHAR(9) and str_phone to CHAR(10))
-----------------------------------------------------------------------------
IF OBJECT_ID(N'dbo.store', N'U') IS NOT NULL
    DROP TABLE dbo.store;
GO

CREATE TABLE dbo.store
(
    str_id SMALLINT NOT NULL IDENTITY(1,1),
    str_name VARCHAR(45) NOT NULL,
    str_street VARCHAR(30) NOT NULL,
    str_city VARCHAR(30) NOT NULL,
    str_state CHAR(2) NOT NULL DEFAULT 'FL',
    str_zip CHAR(9) NOT NULL CHECK (str_zip LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
    str_phone CHAR(10) NOT NULL CHECK (str_phone LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
    str_email VARCHAR(100) NOT NULL,
    str_url VARCHAR(100) NOT NULL,
    str_notes VARCHAR(255) NULL,
    PRIMARY KEY (str_id)
);
GO

-----------------------------------------------------------------------------
-- 14) CREATE TABLE: INVOICE
--     (One-to-one relationship with [order])
-----------------------------------------------------------------------------
IF OBJECT_ID(N'dbo.invoice', N'U') IS NOT NULL
    DROP TABLE dbo.invoice;
GO

CREATE TABLE dbo.invoice
(
    inv_id INT NOT NULL IDENTITY(1,1),
    ord_id INT NOT NULL,
    str_id SMALLINT NOT NULL,
    inv_date DATETIME NOT NULL,
    inv_total DECIMAL(8,2) NOT NULL CHECK (inv_total >= 0),
    inv_paid BIT NOT NULL,
    inv_notes VARCHAR(255) NULL,
    PRIMARY KEY (inv_id),

    CONSTRAINT ux_ord_id UNIQUE NONCLUSTERED (ord_id ASC),

    CONSTRAINT fk_invoice_order
        FOREIGN KEY (ord_id)
        REFERENCES dbo.[order] (ord_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fk_invoice_store
        FOREIGN KEY (str_id)
        REFERENCES dbo.store (str_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
GO

-----------------------------------------------------------------------------
-- 15) CREATE TABLE: PAYMENT
-----------------------------------------------------------------------------
IF OBJECT_ID(N'dbo.payment', N'U') IS NOT NULL
    DROP TABLE dbo.payment;
GO

CREATE TABLE dbo.payment
(
    pay_id INT NOT NULL IDENTITY(1,1),
    inv_id INT NOT NULL,
    pay_date DATETIME NOT NULL,
    pay_amt DECIMAL(7,2) NOT NULL CHECK (pay_amt >= 0),
    pay_notes VARCHAR(255) NULL,
    PRIMARY KEY (pay_id),

    CONSTRAINT fk_payment_invoice
        FOREIGN KEY (inv_id)
        REFERENCES dbo.invoice (inv_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
GO

-----------------------------------------------------------------------------
-- 4) CREATE TABLE: VENDOR
--    (Changed ven_zip to CHAR(9) and ven_phone to CHAR(10))
-----------------------------------------------------------------------------
IF OBJECT_ID(N'dbo.vendor', N'U') IS NOT NULL
    DROP TABLE dbo.vendor;
GO

CREATE TABLE dbo.vendor
(
    ven_id SMALLINT NOT NULL IDENTITY(1,1),
    ven_name VARCHAR(45) NOT NULL,
    ven_street VARCHAR(30) NOT NULL,
    ven_city VARCHAR(30) NOT NULL,
    ven_state CHAR(2) NOT NULL DEFAULT 'FL',
    ven_zip CHAR(9) NOT NULL CHECK (ven_zip LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
    ven_phone CHAR(10) NOT NULL CHECK (ven_phone LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
    ven_email VARCHAR(100) NULL,
    ven_url VARCHAR(100) NULL,
    ven_notes VARCHAR(255) NULL,
    PRIMARY KEY (ven_id)
);
GO







-----------------------------------------------------------------------------
-- 9) CREATE TABLE: PRODUCT
-----------------------------------------------------------------------------
IF OBJECT_ID(N'dbo.product', N'U') IS NOT NULL
    DROP TABLE dbo.product;
GO

CREATE TABLE dbo.product
(
    pro_id SMALLINT NOT NULL IDENTITY(1,1),
    ven_id SMALLINT NOT NULL,
    pro_name VARCHAR(30) NOT NULL,
    pro_descript VARCHAR(45) NULL,
    pro_weight FLOAT NOT NULL CHECK (pro_weight >= 0),
    pro_qoh SMALLINT NOT NULL CHECK (pro_qoh >= 0),
    pro_cost DECIMAL(7,2) NOT NULL CHECK (pro_cost >= 0),
    pro_price DECIMAL(7,2) NOT NULL CHECK (pro_price >= 0),
    pro_discount DECIMAL(3,0) NULL,
    pro_notes VARCHAR(255) NULL,
    PRIMARY KEY (pro_id),

    CONSTRAINT fk_product_vendor
        FOREIGN KEY (ven_id)
        REFERENCES dbo.vendor (ven_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
GO

-----------------------------------------------------------------------------
-- 10) CREATE TABLE: PRODUCT_HIST
-----------------------------------------------------------------------------
IF OBJECT_ID(N'dbo.product_hist', N'U') IS NOT NULL
    DROP TABLE dbo.product_hist;
GO

CREATE TABLE dbo.product_hist
(
    pht_id INT NOT NULL IDENTITY(1,1),
    pro_id SMALLINT NOT NULL,
    pht_date DATETIME NOT NULL,
    pht_cost DECIMAL(7,2) NOT NULL CHECK (pht_cost >= 0),
    pht_price DECIMAL(7,2) NOT NULL CHECK (pht_price >= 0),
    pht_discount DECIMAL(3,0) NULL,
    pht_notes VARCHAR(255) NULL,
    PRIMARY KEY (pht_id),

    CONSTRAINT fk_product_hist_product
        FOREIGN KEY (pro_id)
        REFERENCES dbo.product (pro_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
GO




-----------------------------------------------------------------------------
-- 13) CREATE TABLE: ORDER_LINE
-----------------------------------------------------------------------------
IF OBJECT_ID(N'dbo.order_line', N'U') IS NOT NULL
    DROP TABLE dbo.order_line;
GO

CREATE TABLE dbo.order_line
(
    oln_id INT NOT NULL IDENTITY(1,1),
    ord_id INT NOT NULL,
    pro_id SMALLINT NOT NULL,
    oln_qty SMALLINT NOT NULL CHECK (oln_qty >= 0),
    oln_price DECIMAL(7,2) NOT NULL CHECK (oln_price >= 0),
    oln_notes VARCHAR(255) NULL,
    PRIMARY KEY (oln_id),

    CONSTRAINT fk_order_line_order
        FOREIGN KEY (ord_id)
        REFERENCES dbo.[order] (ord_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fk_order_line_product
        FOREIGN KEY (pro_id)
        REFERENCES dbo.product (pro_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
GO





-----------------------------------------------------------------------------
-- 16) CREATE PROCEDURE: dbo.CreatePersonSSN
--      (Ensure it is the first statement in the batch)
-----------------------------------------------------------------------------
GO
CREATE PROC dbo.CreatePersonSSN
AS
BEGIN
    DECLARE @salt    BINARY(64),
            @ran_num INT,
            @ssn     BINARY(64),
            @x       INT,
            @y       INT;

    SET @x = 1;
    SET @y = (SELECT COUNT(*) FROM dbo.person);

    WHILE (@x <= @y)
    BEGIN
        SET @salt    = CRYPT_GEN_RANDOM(64);
        SET @ran_num = FLOOR(RAND()*(999999999 - 111111111 + 1)) + 111111111;
        SET @ssn     = HASHBYTES('SHA2_512', CONCAT(@salt, @ran_num));

        UPDATE dbo.person
          SET per_pep = @salt,
              per_ssn = @ssn
          WHERE per_id = @x;

        SET @x = @x + 1;
    END;
END;
GO

exec dbo.CreatePersonSSN
-----------------------------------------------------------------------------
-- 17) INSERT SAMPLE DATA
-----------------------------------------------------------------------------
-- A) PERSON (15 rows: 5 's' for sales reps, 10 'c' for customers)
-- Note: ZIP codes are now strings, so enclose them in quotes.
INSERT INTO dbo.person
(per_ssn, per_pep, per_fname, per_lname, per_gender, per_dob, per_street, per_city, per_state, per_zip, per_email, per_type, per_notes)
VALUES
(1, NULL, 'Steve', 'Rogers', 'm', '1923-10-03', '437 Southern Drive', 'Rochester', 'NY', 324402222, 'srogers@comcast.net', 's', NULL),
(2, NULL, 'Bruce', 'Wayne', 'm', '1968-03-20', '1007 Mountain Drive', 'Gotham', 'NY', 983208440, 'bwayne@knology.net', 's', NULL),
(3, NULL, 'Peter', 'Parker', 'm', '1998-02-09', '12 Ingram Street', 'New York', 'NY', 102826341, 'pparker@msn.com', 's', NULL),
(4, NULL, 'Jane', 'Thompson', 'f', '1978-05-08', '13563 Ocean View Drive', 'Seattle', 'WA', 132084409, 'jthompson@gmail.com', 's', NULL),
(5, NULL, 'Debra', 'Steele', 'f', '1994-07-19', '543 Oak Ln', 'Milwaukee', 'WI', 286234178, 'dsteele@verizon.net', 's', NULL),
(6, NULL, 'Tony', 'Smith', 'm', '1972-05-04', '902 Palm Avenue', 'Malibu', 'CA', 902638332, 'tsstark@yahoo.com', 'c', NULL),
(7, NULL, 'Hank', 'Pymi', 'm', '1980-08-28', '2355 Brown Street', 'Cleveland', 'OH', 822348890, 'hpym@aol.com', 'c', NULL),
(8, NULL, 'Bob', 'Best', 'm', '1992-02-10', '4902 Avendale Avenue', 'Scottsdale', 'AZ', 872638332, 'bbest@yahoo.com', 'c', NULL),
(9, NULL, 'Sandra', 'Smith', 'f', '1980-01-26', '1912 Lawrence Ave', 'Atlanta', 'GA', 672348890, 'sdole@gmail.com', 'c', NULL),
(10, NULL, 'Ben', 'Avery', 'm', '1983-12-24', '6432 Thunderbird Ln', 'Sioux Falls', 'SD', 562638332, 'bavery@hotmail.com', 'c', NULL),
(11, NULL, 'Arthur', 'Curry', 'm', '1975-12-15', '3304 Euclid Avenue', 'Miami', 'FL', 342219932, 'acurry@gmail.com', 'c', NULL),
(12, NULL, 'Diana', 'Price', 'f', '1980-08-22', '9401 Green Street', 'Las Vegas', 'NV', 332048823, 'dprice@symaptico.com', 'c', NULL),
(13, NULL, 'Adam', 'Smith', 'm', '1995-01-31', '98435 Valencia Dr.', 'Gulf Shores', 'AL', 870219932, 'ajurris@gmx.com', 'c', NULL),
(14, NULL, 'Judy', 'Sleen', 'f', '1970-03-22', '56343 Rover Ct.', 'Billings', 'MT', 672048823, 'jsleen@symaptico.com', 'c', NULL),
(15, NULL, 'Bill', 'Neiderheim', 'm', '1982-06-13', '43567 Netherland Blvd', 'South Bend', 'IN', 320219932, 'bneiderheim@comcast.net', 'c', NULL);
GO

-- B) SLSREP (for the 's' persons => IDs 1, 2, 3, 6, 10)
INSERT INTO dbo.slsrep (per_id, srp_yr_sales_goal, srp_ytd_sales, srp_ytd_comm, srp_notes)
VALUES
(1,  20000.00,  5000.00, 150.00, NULL),
(2,  15000.00,  3000.00,  90.00, NULL),
(3,  25000.00, 10000.00, 300.00, 'Great salesperson!'),
(4,  18000.00,  7000.00, 210.00, NULL),
(5, 30000.00, 12000.00, 360.00, NULL);

-- C) CUSTOMER (for the 'c' persons)
INSERT INTO dbo.customer
(per_id, cus_balance, cus_total_sales, cus_notes)
VALUES
(6, 120, 14789, NULL),
(7, 98.46, 234.92, NULL),
(8, 0, 4578, 'Customer always pays on time.'),
(9, 981.73, 1672.38, 'High balance.'),
(10, 541.23, 782.57, NULL),
(11, 251.02, 13782.96, 'Good customer.'),
(12, 582.67, 963.12, 'Previously paid in full.'),
(13, 121.67, 1057.45, 'Recent customer.'),
(14, 765.43, 6789.42, 'Buys bulk quantities.'),
(15, 304.39, 456.81, 'Has not purchased recently.');

INSERT INTO dbo.contact
(per_sid, per_cid, cnt_date, cnt_notes)
VALUES
(1, 6, '1999-01-01', NULL),
(2, 6, '2001-09-29', NULL),
(3, 7, '2002-08-15', NULL),
(2, 7, '2002-09-01', NULL),
(4, 7, '2004-01-05', NULL),
(5, 8, '2004-02-28', NULL),
(4, 8, '2004-03-03', NULL),
(1, 9, '2004-04-07', NULL),
(5, 9, '2004-07-29', NULL),
(3, 11, '2005-05-02', NULL),
(4, 13, '2005-06-14', NULL),
(2, 15, '2005-07-02', NULL);

INSERT INTO dbo.[order]
(cnt_id, ord_placed_date, ord_filled_date, ord_notes)
VALUES
(1, '2010-11-23', '2010-12-24', NULL),
(2, '2005-03-19', '2005-07-28', NULL),
(3, '2011-07-01', '2011-07-06', NULL),
(4, '2009-12-24', '2010-01-05', NULL),
(5, '2008-09-21', '2008-11-26', NULL),
(6, '2009-04-17', '2009-04-30', NULL),
(7, '2010-05-31', '2010-06-07', NULL),
(8, '2007-09-02', '2007-09-16', NULL),
(9, '2011-12-08', '2011-12-23', NULL),
(10, '2012-02-29', '2012-05-02', NULL);



INSERT INTO dbo.store
(str_name, str_street, str_city, str_state, str_zip, str_phone, str_email, str_url, str_notes)
VALUES
('Walgreens', '14567 Walnut Ln', 'Aspen', 'IL', '475315690', '3127658127', 'info@walgreens.com', 'http://www.walgreens.com', NULL),
('CVS', '572 Casper Rd', 'Chicago', 'IL', '505231519', '3128926534', 'help@cvs.com', 'http://www.cvs.com', 'Rumor of merger.'),
('Lowes', '81309 Catapult Ave', 'Clover', 'WA', '802345671', '9017653421', 'sales@lowes.com', 'http://www.lowes.com', NULL),
('Walmart', '14567 Walnut Ln', 'St. Louis', 'FL', '387563628', '8722718923', 'info@walmart.com', 'http://www.walmart.com', NULL),
('Dollar General', '47583 Davison Rd', 'Detroit', 'MI', '482983456', '3137583492', 'ask@dollargeneral.com', 'http://www.dollargeneral.com', 'recently sold property');


INSERT INTO dbo.invoice
(ord_id, str_id, inv_date, inv_total, inv_paid, inv_notes)
VALUES
(5, 1, '2001-05-03', 58.32, 0, NULL),
(4, 1, '2006-11-11', 100.59, 0, NULL),
(1, 1, '2010-09-16', 57.34, 0, NULL),
(3, 2, '2011-01-10', 99.32, 1, NULL),
(2, 3, '2008-06-24', 1109.67, 1, NULL),
(6, 4, '2009-04-20', 239.83, 0, NULL),
(7, 5, '2010-06-05', 537.29, 0, NULL),
(8, 2, '2007-09-09', 644.21, 1, NULL),
(9, 3, '2011-12-17', 934.12, 1, NULL),
(10, 4, '2012-03-18', 27.45, 0, NULL);

INSERT INTO dbo.vendor
(ven_name, ven_street, ven_city, ven_state, ven_zip, ven_phone, ven_email, ven_url, ven_notes)
VALUES
('Sysco', '531 Dolphin Run', 'Orlano', 'FL', '344761234', '7641238543', 'sales@sysco.com', 'http://www.sysco.com', NULL),
('General Electric', '100 Happy Trails Dr.', 'Boston', 'MA', '123458743', '2134569641', 'support@ge.com', 'http://www.ge.com', 'Very good turnaround'),
('Cisco', '300 Cisco Dr.', 'Stanford', 'OR', '872315492', '7823456723', 'cisco@cisco.com', 'http://www.cisco.com', NULL),
('Goodyear', '100 Goodyear Dr.', 'Gary', 'IN', '485321956', '5784218427', 'sales@goodyear.com', 'http://www.goodyear.com', 'Competing well with Firestone.'),
('Snap-On', '42185 Magenta Ave', 'Lake Falls', 'ND', '387513649', '9197345632', 'support@snapon.com', 'http://www.snap-on.com', 'Good quality tools!');

INSERT INTO dbo.product
(ven_id, pro_name, pro_descript, pro_weight, pro_qoh, pro_cost, pro_price, pro_discount, pro_notes)
VALUES
(1, 'hammer', '', 2.5, 45, 4.99, 7.99, 30, 'Discounted only when purchased with screwdriver set.'),
(2, 'screwdriver', '', 1.8, 120, 1.99, 3.49, NULL, NULL),
(4, 'pail', '16 Gallon', 2.8, 48, 3.89, 7.99, 40, NULL),
(5, 'cooking oil', 'Peanut oil', 15, 19, 19.99, 28.99, NULL, 'gallons'),
(3, 'frying pan', '', 3.5, 178, 8.45, 13.99, 50, 'Currently 1/2 price sale.');

INSERT INTO dbo.order_line
(ord_id, pro_id, oln_qty, oln_price, oln_notes)
VALUES
(1, 2, 10, 8.0, NULL),
(2, 3, 7, 9.88, NULL),
(3, 4, 3, 6.99, NULL),
(5, 1, 2, 12.76, NULL),
(4, 5, 13, 58.99, NULL);

INSERT INTO dbo.payment
(inv_id, pay_date, pay_amt, pay_notes)
VALUES
(5, '2008-07-01', 5.99, NULL),
(4, '2010-09-28', 4.99, NULL),
(1, '2008-07-23', 8.75, NULL),
(3, '2010-10-31', 19.55, NULL),
(2, '2011-03-29', 32.5, NULL),
(6, '2011-10-03', 20.00, NULL),
(8, '2008-09-10', 1000.00, NULL),
(3, '2009-01-10', 103.68, NULL),
(7, '2007-03-15', 25.00, NULL),
(10, '2007-05-12', 40.00, NULL),
(4, '2007-05-22', 9.33, NULL);

INSERT INTO dbo.product_hist
(pro_id, pht_date, pht_cost, pht_price, pht_discount, pht_notes)
VALUES
(1, '2005-01-02 11:53:34', 4.99, 7.99, 30, 'Discounted only when purchased with screwdriver set.'),
(2, '2005-02-03 09:13:56', 1.99, 3.49, NULL, NULL),
(3, '2005-03-04 23:21:49', 3.89, 7.99, 40, NULL),
(4, '2006-05-06 18:09:04', 19.99, 28.99, NULL, 'gallons'),
(5, '2006-05-07 15:07:29', 8.45, 13.99, 50, 'Currently 1/2 price sale.');

INSERT INTO dbo.srp_hist
(per_id, sht_type, sht_modified, sht_modifier, sht_date, sht_yr_sales_goal, sht_yr_total_sales, sht_yr_total_comm, sht_notes)
VALUES
(1, 'i', GETDATE(), SYSTEM_USER, GETDATE(), 100000, 110000, 11000, NULL),
(4, 'i', GETDATE(), SYSTEM_USER, GETDATE(), 150000, 175000, 17500, NULL),
(3, 'u', GETDATE(), SYSTEM_USER, GETDATE(), 200000, 185000, 18500, NULL),
(2, 'u', GETDATE(), ORIGINAL_LOGIN(), GETDATE(), 210000, 220000, 22000, NULL),
(5, 'i', GETDATE(), ORIGINAL_LOGIN(), GETDATE(), 225000, 230000, 2300, NULL);

INSERT INTO dbo.phone (per_id, phn_num, phn_type, phn_notes)
VALUES
    (1, '7271234567', 'c', 'Captain America''s cell phone'),
    (2, '2121234567', 'w', 'Batman''s office number'),
    (3, '9179987654', 'c', 'Spider-Man''s personal cell'),
    (4, '2069876543', 'h', 'Jane''s home phone'),
    (5, '4147654321', 'h', 'Debra''s home phone');



SELECT * FROM dbo.person;
SELECT * FROM dbo.store;
SELECT * FROM dbo.vendor;
SELECT * FROM dbo.slsrep;
SELECT * FROM dbo.srp_hist;
SELECT * FROM dbo.phone;
SELECT * FROM dbo.customer;
SELECT * FROM dbo.product;
SELECT * FROM dbo.product_hist;
SELECT * FROM dbo.contact;
SELECT * FROM dbo.[order];
SELECT * FROM dbo.order_line;
SELECT * FROM dbo.invoice;
SELECT * FROM dbo.payment;

/*
Create a view that displays the sum of all paid invoice totals for each customer, sort by the largest
invoice total sum appearing first

CREATE VIEW dbo.vwPaidInvoiceTotalsByCustomer
AS
SELECT TOP 100 PERCENT
    p.per_id,
    p.per_fname AS FirstName,
    p.per_lname AS LastName,
    SUM(i.inv_total) AS TotalPaid
FROM dbo.invoice AS i
    INNER JOIN dbo.[order]      AS o   ON i.ord_id  = o.ord_id
    INNER JOIN dbo.contact      AS c   ON o.cnt_id  = c.cnt_id
    INNER JOIN dbo.person       AS p   ON c.per_cid = p.per_id
WHERE i.inv_paid = 1
GROUP BY
    p.per_id,
    p.per_fname,
    p.per_lname
ORDER BY SUM(i.inv_total) DESC;  -- 'Hacky' approach
GO
*/

