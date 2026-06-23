# Database Design & SQL

**Course:** LIS 3781 — Database Concepts | Florida State University  
**Author:** Brennan O'Halloran  
**Language:** SQL (MySQL)  
**Tools:** MySQL Workbench, AMPPS, Bitbucket, Git

---

## Overview

This repository contains coursework from LIS 3781: Database Concepts at Florida State University. The projects cover the full database development lifecycle — from requirements gathering and entity-relationship modeling through physical schema design, forward engineering, and SQL querying.

---

## Topics Covered

- Entity-Relationship Diagram (ERD) design and normalization
- Forward engineering ERDs to physical SQL schemas
- MySQL database creation, population, and querying
- Multi-table joins, subqueries, and aggregate functions
- Business rules translation into relational constraints
- Version control with Git and Bitbucket

---

## Project Highlights

### HR Database (Assignment 1)
Designed a relational database for an HR department to track employee records, job histories, benefits, and dependents. Key design decisions included:
- Many-to-many relationship between employees and benefits via a Plan junction table
- Full employee history tracking (job changes, salary changes, benefit elections)
- Zero-filled SSN and zip code formatting constraints
- All tables include audit/notes attributes per business requirements

### Additional Assignments (a2–a5, p1)
Subsequent assignments build on the HR schema with increasingly complex SQL:
- Multi-table SELECT queries with JOINs and WHERE clauses
- Aggregate queries using GROUP BY, HAVING, and window functions
- Stored procedures and data manipulation scripts
- Final project (p1) integrating all course concepts

---

## Repository Structure

```
/
├── a1/     # ERD design, forward-engineered SQL schema, business rules
├── a2/     # SQL querying — JOINs, filtering, aggregation
├── a3/     # Advanced queries — subqueries, GROUP BY, HAVING
├── a4/     # Data manipulation — INSERT, UPDATE, DELETE
├── a5/     # Stored procedures and advanced SQL
└── p1/     # Final project
```

---

## Tech Stack

| Tool | Purpose |
|------|---------|
| MySQL | Relational database engine |
| MySQL Workbench | ERD design and schema forward engineering |
| AMPPS | Local server stack (Apache, MySQL, PHP) |
| Git / Bitbucket | Version control |