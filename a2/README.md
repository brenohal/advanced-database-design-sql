# LIS4368 Advanced Database Management

## Brennan O'Halloran

# Assignment #2 Requirements:


Six Parts:

1. Create the company and customer tables using SQL statements.
2. Run describe commands.
3. Run select commands
4. Create and give privileges to user1 and user2. 
5. Run required SQL commands.
6. Bittbucket repo link.

# A2 Database Requirements:
  Use 1:M relationship: company is parent table
  1. company attributes:
      - cmp_id (pk)
      - cmp_type enum('C-Corp','S-Corp','Non-Profit-Corp','LLC','Partnership')
      - cmp_street
      - cmp_city
      - cmp_state
      - cmp_zip
      - cmp_phone
      - cmp_ytd_sales
      - cmp_url
      - cmp_notes
  2. customer attributes:
      - cus_id (pk)
      - cmp_id (fk)
      - cus_ssn (binary 64)
      - cus_salt (binary 64)
      - cus_type enum('Loyal','Discount','Impulse','Need-Based','Wandering')
      - cus_first
      - cus_last
      - cus_street  
      - cus_city
      - cus_state
      - cus_zip
      - cus_phone
      - cus_email
      - cus_balance
      - cus_tot_sales
      - cus_notes
  3. Create suitable indexes and foreign keys:
      - Enforce pk/fk relationship: on update cascade, on delete restrict


# User1 and User2 required SQL commands:

* Local Admin: (***NOTE***: you do *not* have permissions to create users on the CCI Server)
* Create two different users (user1 and user2), with two different passwords: both users can access from localhost only.
* See Granting_Privileges.pdf

1. Limit user1 to select, update, and delete privileges on company and customer tables
2. Limit user2 to select, and insert privileges on customer table

    Log into local server as required:
    * Verify database/table permissions, show grants:
      * yours/admin
      * user1 (logged in as user1)
      * user2 (logged in as admin)
    * Display current user2 (logged in as user2) and MySQL version
    * List tables (as admin)
    * Display structures for both tables (as admin)
      * company
      * customer
    * Display data for both tables:
      * company (as user2)
      * customer (as user1)
    * Log in as user1:
      * show the SQL INSERT statement, and corresponding query result set that prevented user1 from inserting data in the company table
      * show the SQL INSERT statement, and corresponding query result set that prevented user1 from inserting data in the customer table
    * Log in as user2:
      * show the SQL statement, and corresponding query result set that prevented user2 from "seeing" company table
      * same as above, though, prevented from being able to delete from the customer table
    * Log in as admin: remove both tables (structure and data), and show commands

#### README.md file should include the following items:

1. Screenshot of *your* SQL code;
2. Screenshot of *your* populated tables;
3. Link to your lis3781_a2_solutions.sql file—including tables AND data



#### Assignment Screenshots:

*Screenshots of SQL code*:

![A2 SQL Code Part 1](img/sql1.png)
![A2 SQL Code Part 2](img/sql2.png)
![A2 SQL Code Part 3](img/sql3.png)

*Screenshot of populated customer table*:

![A2 Customer Table](img/customer.png)

*Screenshot of populated company table*:

![A2 Company Table](img/company.png)

*Link to lis3781_a2_solutions.sql file:*
[lis3781_a2_solutions.sql](lis3781_a2_solutions.sql)





