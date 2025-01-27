DROP DATABASE IF EXISTS bmo22a;
CREATE DATABASE IF NOT EXISTS bmo22a;
USE bmo22a;

-- Create the Job Table first
CREATE TABLE job (
    job_id TINYINT AUTO_INCREMENT PRIMARY KEY,
    job_title VARCHAR(45) NOT NULL,
    job_notes VARCHAR(255)
);

-- Create the Employee Table next
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

-- Create the Dependent Table
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

-- Create the Benefit Table
CREATE TABLE benefit (
    ben_id TINYINT AUTO_INCREMENT PRIMARY KEY,
    ben_name VARCHAR(45) NOT NULL,
    ben_notes VARCHAR(255)
);

-- Create the Plan Table
CREATE TABLE plan (
    plan_id SMALLINT AUTO_INCREMENT PRIMARY KEY,
    emp_id SMALLINT NOT NULL,
    ben_id TINYINT NOT NULL,
    plan_type ENUM('Single', 'Spouse', 'Family') NOT NULL,
    plan_cost DECIMAL(10, 2) NOT NULL,
    plan_election_date DATE NOT NULL,
    plan_notes VARCHAR(255),
    FOREIGN KEY (emp_id) REFERENCES employee(emp_id) ON DELETE CASCADE,
    FOREIGN KEY (ben_id) REFERENCES benefit(ben_id) ON DELETE CASCADE
);

-- Create the Employee History Table
CREATE TABLE emp_hist (
    hist_id MEDIUMINT AUTO_INCREMENT PRIMARY KEY,
    emp_id SMALLINT NOT NULL,
    hist_change_date DATETIME NOT NULL,
    hist_type ENUM('Job', 'Salary', 'Benefit') NOT NULL,
    hist_job_id TINYINT,
    hist_prev_salary DECIMAL(10, 2),
    hist_user_changed VARCHAR(50) NOT NULL,
    hist_reason VARCHAR(255),
    hist_notes VARCHAR(255),
    FOREIGN KEY (emp_id) REFERENCES employee(emp_id) ON DELETE CASCADE,
    FOREIGN KEY (hist_job_id) REFERENCES job(job_id) ON DELETE SET NULL
);

INSERT INTO job (job_id, job_title, job_notes) VALUES
(1, 'Software Engineer', 'Develops and maintains software.'),
(2, 'HR Specialist', 'Handles employee relations.'),
(3, 'Accountant', 'Manages financial records.'),
(4, 'Marketing Manager', 'Oversees marketing campaigns.'),
(5, 'Sales Representative', 'Drives product sales.');

INSERT INTO employee (emp_id, job_id, emp_ssn, emp_fname, emp_lname, emp_dob, emp_start_date, emp_end_date, emp_salary, emp_street, emp_city, emp_state, emp_zip, emp_phone, emp_email, emp_notes) VALUES
(1, 1, '123456789', 'John', 'Doe', '1990-01-01', '2020-01-01', NULL, 85000.00, '123 Main St', 'Orlando', 'FL', '32801', 1234567890, 'johndoe@example.com', 'Great performance.'),
(2, 2, '987654321', 'Jane', 'Smith', '1985-05-20', '2019-06-15', NULL, 65000.00, '456 Oak St', 'Miami', 'FL', '33101', 9876543210, 'janesmith@example.com', 'Excellent HR skills.'),
(3, 3, '135792468', 'Bob', 'Johnson', '1978-09-12', '2015-11-01', NULL, 72000.00, '789 Pine St', 'Tampa', 'FL', '33602', 1357924680, 'bobjohnson@example.com', 'Detail-oriented.'),
(4, 4, '246813579', 'Alice', 'Brown', '1992-03-10', '2021-07-20', NULL, 68000.00, '321 Elm St', 'St. Petersburg', 'FL', '33701', 2468135790, 'alicebrown@example.com', 'Innovative thinker.'),
(5, 5, '369258147', 'Charlie', 'Davis', '1983-07-30', '2017-03-05', NULL, 55000.00, '654 Maple St', 'Jacksonville', 'FL', '32201', 3692581470, 'charliedavis@example.com', 'Great communicator.');

INSERT INTO dependent (dep_id, emp_id, dep_added, dep_ssn, dep_fname, dep_lname, dep_dob, dep_relation, dep_street, dep_city, dep_state, dep_zip, dep_phone, dep_email, dep_notes) VALUES
(1, 1, '2022-01-01', '111222333', 'Emma', 'Doe', '2010-06-15', 'Daughter', '123 Main St', 'Orlando', 'FL', '32801', 1234567890, 'emma@example.com', 'Dependent for health insurance.'),
(2, 2, '2021-05-15', '444555666', 'Mike', 'Smith', '2008-12-25', 'Son', '456 Oak St', 'Miami', 'FL', '33101', 9876543210, 'mike@example.com', 'Covers dental.'),
(3, 3, '2020-03-10', '777888999', 'Sophia', 'Johnson', '2012-08-09', 'Daughter', '789 Pine St', 'Tampa', 'FL', '33602', 1357924680, 'sophia@example.com', 'Special dietary needs.'),
(4, 4, '2023-02-20', '222333444', 'Liam', 'Brown', '2011-11-11', 'Son', '321 Elm St', 'St. Petersburg', 'FL', '33701', 2468135790, 'liam@example.com', 'Covers medical.'),
(5, 5, '2019-12-01', '555666777', 'Olivia', 'Davis', '2009-05-05', 'Daughter', '654 Maple St', 'Jacksonville', 'FL', '32201', 3692581470, 'olivia@example.com', 'Enrolled in school program.');

INSERT INTO benefit (ben_id, ben_name, ben_notes) VALUES
(1, 'Health Insurance', 'Comprehensive coverage.'),
(2, 'Dental Insurance', 'Includes orthodontics.'),
(3, 'Vision Insurance', 'Covers glasses and contacts.'),
(4, 'Life Insurance', 'Term life coverage.'),
(5, '401(k) Plan', 'Retirement savings plan.');

INSERT INTO plan (plan_id, emp_id, ben_id, plan_type, plan_cost, plan_election_date, plan_notes) VALUES
(1, 1, 1, 'Family', 300.00, '2022-01-15', 'Full coverage for family.'),
(2, 2, 2, 'Single', 50.00, '2021-06-01', 'Single coverage.'),
(3, 3, 3, 'Single', 20.00, '2020-07-10', 'Basic vision.'),
(4, 4, 4, 'Single', 15.00, '2023-02-15', 'Life insurance.'),
(5, 5, 5, 'Single', 0.00, '2019-11-30', 'Employer-contributed.');

INSERT INTO emp_hist (hist_id, emp_id, hist_change_date, hist_type, hist_job_id, hist_prev_salary, hist_user_changed, hist_reason, hist_notes) VALUES
(1, 1, '2022-01-01 10:00:00', 'Salary', NULL, 80000.00, 'Admin', 'Annual increment', 'No issues.'),
(2, 2, '2021-06-15 09:30:00', 'Job', 2, NULL, 'HR', 'Promotion', 'Well-deserved.'),
(3, 3, '2020-08-10 14:00:00', 'Benefit', NULL, NULL, 'Admin', 'New benefit added', 'Vision included.'),
(4, 4, '2023-02-20 08:45:00', 'Salary', NULL, 65000.00, 'Admin', 'Cost-of-living adjustment', 'Updated in system.'),
(5, 5, '2019-12-01 12:00:00', 'Job', 5, NULL, 'Manager', 'Role transfer', 'Smooth transition.');


SELECT * FROM job;

SELECT * FROM employee;

SELECT * FROM dependent;

SELECT * FROM benefit;

SELECT * FROM plan;

SELECT * FROM emp_hist;




