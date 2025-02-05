# LIS4368 Advanced Database Management

## Brennan O'Halloran

### Assignment #2 Requirements

---

#### User1 and User2 Required SQL Commands

**Local Admin Requirements:**
> **Note:** You do not have permissions to create users on the CCI Server

- Create two different users (user1 and user2) with different passwords
- Both users can access from localhost only
- See Granting_Privileges.pdf

**Permission Requirements:**
1. User1 permissions:
   - Select, update, and delete privileges on company and customer tables
2. User2 permissions:
   - Select and insert privileges on customer table only

**Verification Steps:**
- Log into local server and verify:
  - Database/table permissions, show grants for:
    * Admin account
    * User1 (logged in as user1)
    * User2 (logged in as admin)
  - Display current user2 and MySQL version
  - List tables (as admin)
  - Display structures for both tables (as admin):
    * Company table
    * Customer table
  - Display data for both tables:
    * Company (as user2)
    * Customer (as user1)

**Testing Requirements:**
- As User1:
  - Document failed INSERT attempts on company and customer tables
- As User2:
  - Document failed attempts to view company table
  - Document failed DELETE attempts on customer table
- As Admin:
  - Show commands for removing both tables

---

### README.md Requirements

1. ✅ Screenshot of *your* SQL code
2. ✅ Screenshot of *your* populated tables
3. ✅ Link to your lis3781_a2_solutions.sql file

---

### Assignment Screenshots!

#### SQL Code Examples
![A2 SQL Code Part 1](img/sql1.png)
![A2 SQL Code Part 2](img/sql2.png)
![A2 SQL Code Part 3](img/sql3.png)

#### Populated Tables
**Customer Table:**
![A2 Customer Table](img/customer.png)

**Company Table:**
![A2 Company Table](img/company.png)

#### Solution File
[📄 View lis3781_a2_solutions.sql](lis3781_a2_solutions.sql)