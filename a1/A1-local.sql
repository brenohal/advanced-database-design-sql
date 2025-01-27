DROP DATABASE IF EXISTS bmo22a;
CREATE DATABASE IF NOT EXISTS bmo22a;
USE bmo22a;

CREATE TABLE job (
    job_id TINYINT AUTO_INCREMENT PRIMARY KEY,
    job_title VARCHAR(45) NOT NULL,
    job_notes VARCHAR(255)
);

CREATE TABLE employee (
    emp_id SMALLINT AUTO_INCREMENT PRIMARY KEY,
    job_id TINYINT NOT NULL,
    emp_ssn CHAR(9) NOT NULL,
    emp_fname VARCHAR(15) NOT NULL,
    emp_lname VARCHAR(30) NOT NULL,
    emp_dob DATE NOT NULL,
    emp_start_date DATE NOT NULL,
    emp_end_date DATE NULL,
    emp_salary DECIMAL(8, 2) NOT NULL,
    emp_street VARCHAR(30) NOT NULL,
    emp_city VARCHAR(20) NOT NULL,
    emp_state CHAR(2) NOT NULL,
    emp_zip CHAR(9) NOT NULL,
    emp_phone BIGINT NOT NULL,
    emp_email VARCHAR(100) NOT NULL,
    emp_notes VARCHAR(255) NULL,
    FOREIGN KEY (job_id) REFERENCES job(job_id)
);

CREATE TABLE dependent (
    dep_id SMALLINT AUTO_INCREMENT PRIMARY KEY,
    emp_id SMALLINT NOT NULL,
    dep_added DATE NOT NULL,
    dep_ssn CHAR(9) NOT NULL,
    dep_fname VARCHAR(15) NOT NULL,
    dep_lname VARCHAR(30) NOT NULL,
    dep_dob DATE NOT NULL,
    dep_relation VARCHAR(20) NOT NULL,
    dep_street VARCHAR(30) NOT NULL,
    dep_city VARCHAR(20) NOT NULL,
    dep_state CHAR(2) NOT NULL,	
    dep_zip CHAR(9) NOT NULL,
    dep_phone BIGINT NOT NULL,
    dep_email VARCHAR(100),
    dep_notes VARCHAR(255),
    FOREIGN KEY (emp_id) REFERENCES employee(emp_id) ON DELETE CASCADE
);

CREATE TABLE benefit (
    ben_id TINYINT AUTO_INCREMENT PRIMARY KEY,
    ben_name VARCHAR(45) NOT NULL,
    ben_notes VARCHAR(255)
);

CREATE TABLE plan (
    plan_id SMALLINT AUTO_INCREMENT PRIMARY KEY,
    emp_id SMALLINT NOT NULL,
    ben_id TINYINT NOT NULL,
    plan_type ENUM('Single', 'Spouse', 'Family') NOT NULL,
    plan_cost DECIMAL(6, 2) NOT NULL,
    plan_election_date DATE NOT NULL,
    plan_notes VARCHAR(255),
    FOREIGN KEY (emp_id) REFERENCES employee(emp_id) ON DELETE CASCADE,
    FOREIGN KEY (ben_id) REFERENCES benefit(ben_id) ON DELETE CASCADE
);

CREATE TABLE emp_hist (
    eht_id MEDIUMINT AUTO_INCREMENT PRIMARY KEY,
    emp_id SMALLINT,
    eht_date DATETIME NOT NULL,
    eht_type ENUM('i', 'u', 'd') NOT NULL,
    eht_job_id TINYINT,
    eht_emp_salary DECIMAL(8, 2),
    eht_usr_changed VARCHAR(30) NOT NULL,
    eht_reason VARCHAR(45) NOT NULL,
    eht_notes VARCHAR(255),
    FOREIGN KEY (emp_id) REFERENCES employee(emp_id) ON DELETE CASCADE,
    FOREIGN KEY (eht_job_id) REFERENCES job(job_id) ON DELETE SET NULL
);

INSERT INTO job (job_title, job_notes)
VALUES
('Software Engineer', 'Develops and maintains software solutions.'),
('Accountant', 'Manages financial records and tax filings.'),
('HR Manager', 'Oversees recruitment and employee relations.'),
('IT Technician', 'Maintains IT infrastructure and support.'),
('Sales Representative', 'Handles client relationships and sales.');

INSERT INTO employee (job_id, emp_ssn, emp_fname, emp_lname, emp_dob, emp_start_date, emp_end_date, emp_salary, emp_street, emp_city, emp_state, emp_zip, emp_phone, emp_email, emp_notes)
VALUES
(1, '123456789', 'John', 'Doe', '1990-01-15', '2015-06-01', NULL, 85000.00, '123 Elm St', 'Orlando', 'FL', '32801', 4075551234, 'john.doe@example.com', 'Key software developer.'),
(2, '987654321', 'Jane', 'Smith', '1985-04-22', '2018-09-10', NULL, 65000.00, '456 Oak Ave', 'Miami', 'FL', '33101', 3055559876, 'jane.smith@example.com', 'Expert in accounting software.'),
(3, '567890123', 'Alice', 'Brown', '1978-03-10', '2012-11-15', NULL, 72000.00, '789 Pine Dr', 'Tampa', 'FL', '33601', 8135554567, 'alice.brown@example.com', 'Experienced HR manager.'),
(4, '345678901', 'Bob', 'Johnson', '1992-07-04', '2019-01-20', NULL, 55000.00, '321 Maple Ln', 'Jacksonville', 'FL', '32201', 9045557890, 'bob.johnson@example.com', 'Handles network support.'),
(5, '654321987', 'Carol', 'Wilson', '1980-12-25', '2010-05-30', NULL, 62000.00, '567 Cedar Ct', 'Tallahassee', 'FL', '32301', 8505556543, 'carol.wilson@example.com', 'Top-performing sales representative.');

INSERT INTO dependent (emp_id, dep_added, dep_ssn, dep_fname, dep_lname, dep_dob, dep_relation, dep_street, dep_city, dep_state, dep_zip, dep_phone, dep_email, dep_notes)
VALUES
(1, '2017-06-01', '223456789', 'Emily', 'Doe', '2015-03-10', 'Daughter', '123 Elm St', 'Orlando', 'FL', '32801', 4075551234, NULL, 'Added after birth.'),
(2, '2019-09-15', '323456789', 'Michael', 'Smith', '2016-11-20', 'Son', '456 Oak Ave', 'Miami', 'FL', '33101', 3055559876, NULL, 'Dependent for health insurance.'),
(3, '2020-01-25', '423456789', 'Sarah', 'Brown', '2003-08-15', 'Daughter', '789 Pine Dr', 'Tampa', 'FL', '33601', 8135554567, 'sarah.brown@example.com', 'College student.'),
(4, '2021-07-30', '523456789', 'Jake', 'Johnson', '2020-04-10', 'Son', '321 Maple Ln', 'Jacksonville', 'FL', '32201', 4482334495, NULL, 'Recently added.'),
(5, '2022-03-05', '623456789', 'Sophia', 'Wilson', '2018-05-25', 'Daughter', '567 Cedar Ct', 'Tallahassee', 'FL', '32301', 8505556543, NULL, 'On family plan.');

INSERT INTO benefit (ben_name, ben_notes)
VALUES
('Medical Insurance', 'Covers primary health care.'),
('Dental Insurance', 'Includes regular cleanings and procedures.'),
('Vision Insurance', 'Covers eye exams and glasses.'),
('401k', 'Retirement savings plan with employer matching.'),
('Life Insurance', 'Basic coverage for employees.');

INSERT INTO plan (emp_id, ben_id, plan_type, plan_cost, plan_election_date, plan_notes)
VALUES
(1, 1, 'Family', 250.00, '2023-01-01', 'Includes dependents.'),
(2, 2, 'Single', 50.00, '2022-06-15', 'Covers employee only.'),
(3, 3, 'Single', 30.00, '2021-12-01', 'Covers basic vision.'),
(4, 4, 'Spouse', 100.00, '2020-08-20', 'Includes matching contributions.'),
(5, 5, 'Family', 75.00, '2019-03-10', 'Covers entire family.');

INSERT INTO emp_hist (emp_id, eht_date, eht_type, eht_job_id, eht_emp_salary, eht_usr_changed, eht_reason, eht_notes)
VALUES
(1, '2022-07-01 14:30:00', 'u', 1, 90000.00, 'HR Admin', 'Annual raise.', 'Performance-based adjustment.'),
(2, '2021-12-15 09:00:00', 'i', 2, 65000.00, 'HR Admin', 'New hire.', 'Initial hire date.'),
(3, '2023-02-10 16:45:00', 'u', 3, 75000.00, 'HR Admin', 'Salary adjustment.', 'Market rate adjustment.'),
(4, '2020-05-05 11:20:00', 'i', 4, 55000.00, 'HR Admin', 'New hire.', 'Hired for IT support.'),
(5, '2022-03-20 10:15:00', 'd', 5, NULL, 'HR Admin', 'Termination.', 'Left for another opportunity.');


SELECT * FROM job;

SELECT * FROM employee;

SELECT * FROM dependent;

SELECT * FROM benefit;

SELECT * FROM plan;

SELECT * FROM emp_hist;




