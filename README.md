# Database Design & SQL

**Course portfolio · LIS 3781 — Advanced Database Management · Florida State University**

A collection of database design and SQL projects built around realistic business requirements—from employee benefits and customer permissions to retail operations and legal case management.

[Portfolio](https://brenohal.github.io/brennan-resume/) · [GitHub profile](https://github.com/brenohal) · [LinkedIn](https://www.linkedin.com/in/brennan-o-halloran)

## Featured project: Legal case-management database

The final project models a legal-services organization with **11 related tables** for people, clients, attorneys, judges, courts, cases, assignments, specialties, and bar admissions. It includes an entity-relationship diagram, populated example tables, and a sample report.

| Database design | Project output |
|:--:|:--:|
| [![Legal case-management database ERD](https://raw.githubusercontent.com/brenohal/advanced-database-design-sql/master/p1/img/ERD.png)](https://github.com/brenohal/advanced-database-design-sql/blob/master/p1/img/ERD.png) | [![Example report output](https://raw.githubusercontent.com/brenohal/advanced-database-design-sql/master/p1/img/report.png)](https://github.com/brenohal/advanced-database-design-sql/blob/master/p1/img/report.png) |

**Explore:** [Final project folder](https://github.com/brenohal/advanced-database-design-sql/tree/master/p1) · [Entity-relationship model](https://github.com/brenohal/advanced-database-design-sql/blob/master/p1/P1_ERD.mwb) · [SQL solution](https://github.com/brenohal/advanced-database-design-sql/blob/master/p1/lis3781_p1_solutions.sql)

## More database work

| Assignment | What it explores | Database system |
|---|---|---|
| [A1 · Human resources](https://github.com/brenohal/advanced-database-design-sql/tree/master/a1) | Employees, jobs, dependents, benefits, plans, and employee history | MySQL |
| [A2 · Companies and customers](https://github.com/brenohal/advanced-database-design-sql/tree/master/a2) | One-to-many relationships, table constraints, and user permissions | MySQL |
| [A3 · Customers and orders](https://github.com/brenohal/advanced-database-design-sql/tree/master/a3) | Customers, commodities, orders, sequences, and reporting queries | Oracle |
| [A4–A5 · Retail operations](https://github.com/brenohal/advanced-database-design-sql/tree/master/a4) | People, sales representatives, stores, vendors, products, orders, invoices, and payments | Microsoft SQL Server |
| [P1 · Legal case management](https://github.com/brenohal/advanced-database-design-sql/tree/master/p1) | A multi-table legal-services schema, populated records, and reporting | MySQL |
| P2 | Starter README only; not presented as a completed project | — |

[View the HR entity-relationship diagram](https://github.com/brenohal/advanced-database-design-sql/blob/master/a1/img/ERD.png)

## Skills practiced

- Translating business rules into relational schemas and ER diagrams
- Designing primary keys, foreign keys, constraints, and indexes
- Modeling one-to-many and many-to-many relationships
- Working with history tables and data integrity rules
- Writing queries with joins, subqueries, grouping, and aggregation
- Managing database users and permissions
- Creating and populating schemas in MySQL, Oracle, and SQL Server

## Running the SQL

These are course exercises, not production-ready database migrations. **Some scripts drop and recreate a database named `bmo22a`; others drop tables or sequences before rebuilding them.** Review a script before running it, and use only a disposable course or test database. Don’t run these scripts against a database containing data you need.

The assignments use different SQL dialects. Use the database system listed for that assignment; the scripts are not interchangeable across MySQL, Oracle, and SQL Server.

The repository includes example records. Treat them as demonstration data, not production data.

## Repository map

```text
a1/   HR schema, ERD, and introductory SQL
a2/   Company/customer schema and permissions
a3/   Oracle customer, commodity, and order exercises
a4/   SQL Server retail schema and queries
a5/   SQL Server schema continuation and queries
p1/   MySQL legal case-management project
p2/   Starter README
```
