# LIS4368 Advanced Database Management

## Brennan O'Halloran

# Assignement #2 Requirements:


Five Parts:

1. Create the company and customer tables using SQL statements.
2. Run describe commands.
3. Run select commands
4. Create and give privileges to user1 and user2. 
5. Run required SQL commands.
6. Bittbucket repo link.

# A2 Database Requirements:
Use 1:M relationship: company is parent table
b. company attributes:
    i. cmp_id (pk)
    ii. cmp_type enum('C-Corp','S-Corp','Non-Profit-Corp','LLC','Partnership')
    iii. cmp_street
    iv. cmp_city
    v. cmp_state
    vi. cmp_zip
    vii. cmp_phone
    viii. cmp_ytd_sales
    ix. cmp_url
    x. cmp_notes
c. customer attributes:
    i. cus_id (pk)
    ii. cmp_id (fk)
    iii. cus_ssn (binary 64)
    iv. cus_salt (binary 64)
    v. cus_type enum('Loyal','Discount','Impulse','Need-Based','Wandering')
    vi. cus_first
    vii. cus_last
    viii. cus_street
    ix. cus_city
    x. cus_state
    xi. cus_zip
    xii. cus_phone
    xiii. cus_email
    xiv. cus_balance
    xv. cus_tot_sales
    xvi. cus_notes
d. Create suitable indexes and foreign keys:
Enforce pk/fk relationship: on update cascade, on delete restrict


# User1 and User2 required SQL commands:


Local Admin: (***NOTE***: you do *not* have permissions to create users on the CCI Server)
Create two different users (user1 and user2), with two different passwords: both users can access
from localhost only.
See Granting_Privileges.pdf
1. Limit user1 to select, update, and delete privileges on company and customer tables
2. Limit user2 to select, and insert privileges on customer table

Log into local server as required:
3. Verify database/table permissions, show grants:
    a. yours/admin
    b. user1 (logged in as user1)
    c. user2 (logged in as admin)
4. Display current user2 (logged in as user2) and MySQL version
5. List tables (as admin)
6. Display structures for both tables (as admin)
    a. company
    b. customer
7. Display data for both tables:
    a. company (as user2)
    b. customer (as user1)
8. Log in as user1:
    a. show the SQL INSERT statement, and corresponding query result set that prevented user1 from inserting data in the company table
    b. show the SQL INSERT statement, and corresponding query result set that prevented user1 from inserting data in the customer table
9. Log in as user2:
    a. show the SQL statement, and corresponding query result set that prevented user2 from “seeing” company table:
    b. same as above, though, prevented from being able to delete from the customer table:
10. Log in as admin: remove both tables (structure and data), and show commands:


#### README.md file should include the following items:

* Screenshot of A1 ERD
* At least 1 SQL Solution
* Forward Engineered SQL file [lis3781_a1_solutions.sql](lis3781_a1_solutions.sql)

* Git commands and short descriptions


> #### Git commands w/short descriptions:

1. git init - Create an empty Git repository or reinitialize an existing one
2. git status - Show the working tree status
3. git add - Add file contents to the index
4. git commit - Record changes to the repository
5. git push - Update remote refs along with associated objects
6. git pull - Fetch from and integrate with another repository or a local branch
7. git clone - Clone a repository into a new directory

#### Assignment Screenshots:

*Screenshot of AMPPS running http://localhost*:

![AMPPS Installation Screenshot](img/ampps.png)

*Screenshot of a1 ERD*:

![a1 ERD Screenshot](img/ERD.png)

*Screenshot of Question 2 Solution*:

![Question 2 Screenshot](img/q2.png)






#### Tutorial Links:

*Bitbucket Tutorial - Station Locations:*
[A1 Bitbucket Station Locations Tutorial Link](https://bitbucket.org/username/bitbucketstationlocations/ "Bitbucket Station Locations")
