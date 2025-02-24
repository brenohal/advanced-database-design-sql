SET DEFINE OFF

DROP SEQUENCE seq_cus_id;
Create sequence seq_cus_id
start with 1
increment by 1
minvalue 1
maxvalue 10000;



drop table customer CASCADE CONSTRAINTS PURGE;
CREATE TABLE customer
(
cus_id number(3,0) not null,
cus_fname varchar2(15) not null,
cus_lname varchar2(30) not null,
cus_street varchar2(30) not null,
cus_city varchar2(30) not null,
cus_state char(2)not null,
cus_zip number(9) not null,
cus_phone number(10) not null,
cus_email varchar2(100),
cus_balance number(7,2),
cus_notes varchar2(255),
CONSTRAINT pk_customer PRIMARY KEY(cus_id)
);

DROP SEQUENCE seq_com_id;
Create sequence seq_com_id
start with 1
increment by 1
minvalue 1
maxvalue 10000;

drop table commodity CASCADE CONSTRAINTS PURGE;
CREATE TABLE commodity
(
com_id number not null,
com_name varchar2(20),
com_price number(8,2) not null,
cus_notes varchar2(255),
CONSTRAINT pk_commodity PRIMARY KEY(com_id),
CONSTRAINT uq_com_name  UNIQUE(com_name)
);

DROP SEQUENCE seq_ord_id;
Create sequence seq_ord_id
start with 1
increment by 1
minvalue 1
maxvalue 10000;


drop table "order" CASCADE CONSTRAINTS PURGE;
CREATE TABLE "order"
(
ord_id number(4,0) not null,
cus_id number,
com_id number,
ord_num_units number(5,0) not null,
ord_total_cost number(8,2) not null,
ord_notes varchar2(255),	
CONSTRAINT pk_order PRIMARY KEY(ord_id),
CONSTRAINT fk_order_customer
FOREIGN KEY(cus_id)
REFERENCES customer(cus_id),
CONSTRAINT fk_order_commodity
FOREIGN KEY(com_id)
REFERENCES commodity(com_id),
CONSTRAINT check_unit CHECK(ord_num_units > 0),
CONSTRAINT check_total CHECK(ord_total_cost > 0)
);

INSERT INTO customer VALUES(seq_cus_id.nextval,'Beverly','Davis','123 Main St.','Detroit','MI', 48252, 3135551212,'bdavis@aol.com',11500.99, 'recently moved');
INSERT INTO customer VALUES(seq_cus_id.nextval,'Stephan','Taylor','456 Elm st.','St. Louis','MO',57252,4185551212,'staylor@comcast.net',25.01,NULL);
INSERT INTO customer VALUES(seq_cus_id.nextval,'Donna','Carter','789 Peach Ave.','Los Angeles','CA',48252,3135551212,'dcarter@wow.com',300.99,'returning customer');
INSERT INTO customer VALUES(seq_cus_id.nextval,'Robert','Silverman','857 Wilbur Rd.','Pheonix','AZ',25278,4805551212,'rsilverman@aol.com',NULL,NULL);
INSERT INTO customer VALUES(seq_cus_id.nextval,'Sally','Victors','534 Holler Way','Charleston','WV',78345,9045551212,'svictors@wow.com',500.76,'new customer');
COMMIT;

INSERT INTO commodity VALUES (seq_com_id.nextval, 'DVD & Player', 109.00, NULL);
INSERT INTO commodity VALUES (seq_com_id.nextval, 'Cereal', 3.00, 'sugar free');
INSERT INTO commodity VALUES (seq_com_id.nextval, 'Scrabble', 29.00, 'original');
INSERT INTO commodity VALUES (seq_com_id.nextval, 'Licorice', 1.89, NULL);
INSERT INTO commodity VALUES (seq_com_id.nextval, 'Tums', 2.45, 'antacid');
COMMIT;
 
INSERT INTO "order" VALUES (seq_ord_id.nextval, 1, 2, 50, 200, NULL);  
INSERT INTO "order" VALUES (seq_ord_id.nextval, 2, 3, 30, 100, NULL);  
INSERT INTO "order" VALUES (seq_ord_id.nextval, 3, 1, 6, 654, NULL);  
INSERT INTO "order" VALUES (seq_ord_id.nextval, 5, 4, 24, 972, NULL);  
INSERT INTO "order" VALUES (seq_ord_id.nextval, 3, 5, 7, 300, NULL);  
INSERT INTO "order" VALUES (seq_ord_id.nextval, 1, 2, 5, 15, NULL);  
INSERT INTO "order" VALUES (seq_ord_id.nextval, 2, 3, 40, 57, NULL);  
INSERT INTO "order" VALUES (seq_ord_id.nextval, 3, 1, 4, 300, NULL);  
INSERT INTO "order" VALUES (seq_ord_id.nextval, 5, 4, 14, 770, NULL);  
INSERT INTO "order" VALUES (seq_ord_id.nextval, 3, 5, 15, 883, NULL);  
COMMIT;  

-- Verify data  
SELECT * FROM customer;  
SELECT * FROM commodity;  
SELECT * FROM "order";  


/* 

1
select * from product_component_version;

2
Select * from v$version;

Select * from v$version
where banner
like 'Oracle%';

3
select user from dual;

4
select to_char(sysdate, 'MM-DD-YYY HH12:MI:SS AM') "NOW"
from dual;

5
select * from user_sys_privs; -- ANSWER
select * from user_tab_privs;
select * from user_role_privs;

6
select object_name
from user_objects
where object_type='table';

7
describe customer;
describe commodity;
describe "order";

8
select cus_id, cus_lname, cus_fname, cus_email
from customer;

9
select cus_id, cus_lname, cus_fname, cus_street, cus_city, cus_state, cus_email
from customer
order by cus_state desc, cus_lname;

10
select cus_lname,cus_fname
from customer
where cus_id = 3;

11
select cus_id, cus_lname, cus_fname, cus_balance
from custsomer
where cus_balance > 1000;
order by cus_balance desc;

12
select com_name, to_char(com_price, 'L99,999.99') as price_formatted
from commodity
order by com_price;

13
select (cus_lname || ',' || cus_fname) as name,
(cus_street || ',' || cus_city || ',' || cus_state || ' ' || cus_zip) as address
from customer
order by cus_zip desc;

14
select * from "order"
where com_id not in (select com_id from commodity where lower(com_name) ='cereal');

15
select cus_id, cus_lname, cus_fname. to_char(cus_balance, 'L99,999.99') as balance_formatted
from customer
where cus_balance between 500 and 1000;

16
select cus_id, cus_lname, cus_fname, to_char(cus_balance, 'L99,999.99') as balance_formatted
from customer
where cus_balance >
 (select avg(cus_balance) from customer);

17
select cus_id, cus_lname, cus_fname, to_char(sum(ord_total_cost), 'L99,999.99') as "total orders"
from customer
natural join "order"
group by cus_id, cus_lname, cus_fname
order by sum(ord_total_cost) desc;

18
select cus_id, cus_lname, cus_fname, cus_street, cus_city, cus_state, cus_zip
from customer
where cus_street like '%Peach%';

19
select cus_id, cus_lname, cus_fname, to_char(sum(ord_total_cost), 'L99,999.99') as "total orders"
from customer
natural join "order"
group by cus_id, cus_lname, cus_fname
having sum(ord_total_cost) > 1500
order by sum(ord_total_cost) desc;

20
select cus_id cus_lname, cus_fname, ord_num_units
from customer
natural join "order"    
where ord_num_units in (30, 40, 50);

21
select
  cus_id, cus_lname, cus_fname,
  count(*) as "number of orders",
  to_char(min(ord_total_cost), 'L99,999.99') as "minimum order cost",
  to_char(max(ord_total_cost), 'L99,999.99') as "maximum order cost",
  to_char(sum(ord_total_cost), 'L99,999.99') as "total orders"
from customer
natural join "order"
where exists
  (select count(*) from customer having count(*) >= 5)
group by cus_id, cus_lname, cus_fname;

22
select
  count(*),
  count(cus_balance),
  sum(cus_balance),
  avg(cus_balance),
  max(cus_balance),
  min(cus_balance)
from customer;

23
select count(distinct cus_id) from "order";

24
select cu.cus_id, cus_lname, cus_fname, com_name, ord_id, to_char(ord_total_cost, 'L99,999.99') as "order amount"
from customer cu
 join "order" o on o.cus_id = cu.cus_id
 join commodity co on co.com_id = o.com_id
order by ord_total_cost desc;

25
set define off

select * from commodity;

UPDATE commodity
set com_price = 99
where com_name = 'DVD & Player';






*/