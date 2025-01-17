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


