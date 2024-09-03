-- comment
-- database -> table (row x column)
create database db_bc2405p; 

use db_bc2405p;

create table customers (
	id int,
    name varchar(50),
    email varchar(50)
);

-- insert into table_name (column_name1, ....) values (column_value,...)
insert into customers (id, name, email) values (1, 'John Lau', 'john@gmail.com');
insert into customers (id, name, email) values (2, 'Peter Wong', 'peter@gmail.com');

-- * means all columns
-- 'where' mean condition
select * from customers;

select * from customers where id = 2;
select * from customers where id = 1 or id =2;
select * from customers where id = 1 and id =2;
select name, email from customers where id = 1;

-- order by 
select * from customers order by id; -- acc
select * from customers order by id desc;

-- where, order by (sort)
select * from customers where id = 1 order by id desc;

create table students(
	id integer,
    name varchar(50),
    weight numeric (5,2), -- 5 digit, 2 decimal place
    height numeric (5,2)
);

insert into students (id, name, weight, height) values (1, 'John Lau', 85.32, 170.21);
insert into students (id, name, weight, height) values (2, 'Peter Chan', 100.21, 183.1);
insert into students (id, name, weight, height) values (3.5, 'Peter Wong', 90, 140);

insert into students (id, name, weight, height) values (5, 'Peter Man', 90.999, 170);
-- You can ship some column(s) when you preform insert statement
insert into students (id, name, weight) values (6, 'Simon Wong', 93.124);

-- If you don't specifiy the column name, then you have to put all column values
insert into students  values (7, 'Simon Chan', 93.124,null);
select * from students;

-- DDL (Data Definition Language): create/drop table, add/drop column, modify (modify column defintion varchar(50)-> varchar(100)) 
-- DML (Data Manipulation Language): insert row, update column, delete row, trumcate table (remove all data)

-- +,-,*,/,%
select weight + height as ABC , weight, height , name from students;

select s.weight + s.height as DEF, s.* from students s where s.weight >90 order by name;

-- >,<,>=, <=, <>/!=, = 
select * from students where id<>6 and id<>8;

-- not in
select * from students where id not in (6,7);
select * from students where name = 'John Lau';

-- Any name with prefix (0 or more character) and suffix (0 or more character)
select * from students where name like '%Wong%';

select * from students where name not like '%Wong%';

-- null check
select * from students where weight is null or height is null;
select * from students where weight is not null and height is not null;

-- Functions
insert into students (id,name,weight, height) values(9, '甲乙',60.35,180.5);

-- substring() - start from 1
select upper(s.name) ,lower(s.name), substring(s.name ,1,3),trim(s.name),replace(s.name, 'Wong', 'Chan'), s.* from students s;

-- Java: indexOf(), DB instr() position start from 1, 0 = not found
select instr(s.name, 'Wong'), s.* from students s;

create table orders (
	id integer,
    total_amount numeric (10,2),
    customer_id integer
    
);

select * from orders; -- List<Object>
insert into orders values (1,205.10,2);
insert into orders values (2,10000.9,2);
insert into orders values (3,99.9,1);
insert into orders values (4,1999.9,3);
insert into orders values (5,999.99,4);
insert into orders values (6,999.99,5);

-- sum()
-- 3ms (without network consideration)
select sum(o.total_amount) from orders o;
select avg(o.total_amount) from orders o where customer_id = 2 ;
select min(o.total_amount), max(o.total_amount) from orders o where customer_id = 2;
select min(o.total_amount), max(o.total_amount) from orders o;

select o.*,1 as number,'hello' as string from orders o;

-- why can we put all fucntions is select statement?
-- Ans: Aggregation Functions
select sum(o.total_amount), avg(o.total_amount),min(o.total_amount), max(o.total_amount), count(o.total_amount) from orders o;

-- select o.total_amount, sum(o.total_amount) from orders o; -- error

-- group by -> select "group key"
select * from orders;
select customer_id , sum(total_amount) from orders o group by o.customer_id;
select customer_id , sum(total_amount), group_concat(id SEPARATOR ';') from orders o group by o.customer_id;

-- filter befroe groupby
select customer_id ,sum(total_amount) 
from orders o 
where o.customer_id in (1,2,3,5) 
group by o.customer_id;
-- 2	10206.00
-- 1	99.90
-- 3	1999.90
-- 5	999.99

-- filter after group by
select customer_id , sum(total_amount) from orders o group by o.customer_id having sum(total_amount) >100;
-- 2	10206.00
-- 3	1999.90
-- 4	999.99
-- 5	999.99

select customer_id ,sum(total_amount) 
from orders o 
where o.customer_id in (1,2,3,5) 
-- 2	10206.00
-- 1	99.90
-- 3	1999.90
-- 5	999.99
group by o.customer_id
having sum(total_amount) >1000;
-- 2	10206.00
-- 3	1999.90

select * from customers where name = 'JOHN LAU';
-- select * from customers where name collate utf8_bin = 'JOHN LAU';

select * from customers where name like  '_____LAU';
select * from customers where name like  '%LAU';
select * from customers where name like  '____LAU';

select Round(total_amount, 0), o.* from orders o;

select date_format('2023-08-31','%Y-%m-%d') from dual;
select date_format('2023-08-31','%Y-%m-%d')+1 from dual; -- 24
select date_format('2023-08-31','%Y-%m-%d') + interval 1 day from dual;
select str_to_date('2023-08-31','%Y-%m-%d') + interval 1 day from dual;

select extract(Year From Date_format('2023-08-31','%Y-%m-%d')) from dual;
select extract(month From Date_format('2023-08-31','%Y-%m-%d')) from dual;
select extract(day From Date_format('2023-08-31','%Y-%m-%d')) from dual;

select * from orders;
alter table orders add column trans_date date;

select extract(Year from trans_date) as YEAR , count(id) as NUMBER_OF_ORDERS
from orders
group by extract(Year from trans_date)
having NUMBER_OF_ORDERS>=2;


update orders
set trans_date = date_format('2023-08-31','%Y-%m-%d')
where id = 1;

update orders
set trans_date = date_format('2022-08-30','%Y-%m-%d')
where id = 2;

update orders
set trans_date = date_format('2023-07-29','%Y-%m-%d')
where id = 3;

update orders
set trans_date = date_format('2023-08-28','%Y-%m-%d')
where id = 4;
update orders
set trans_date = date_format('2024-06-27','%Y-%m-%d')
where id = 5;
update orders
set trans_date = date_format('2023-08-26','%Y-%m-%d')
where id = 6;

select * from orders;

-- coalesce did not update the original data
select ifnull(s.weight,'N/A'),ifnull(s.height,'N/A'), s.* from students s;
select ifnull(s.weight,'N/A'),coalesce(s.height,'N/A'), s.* from students s;

-- <1000 'S'
-- >= 1000 and <= 10000 'M'
-- >=10000 'L'
select case
		when total_amount <1000 Then 'S'
        when total_amount >= 1000 and total_amount <10000 then 'M'
        else 'L'
	END as category
    ,o.*
from orders o;

select * from orders;

select *
from orders
where trans_date between date_format('2023-01-31', '%Y-%m-%d')
and date_format('2023-08-30', '%Y-%m-%d');

select * from customers;

insert into customers values (3,'Jenny Wong', 'jenny@gmail.com');
insert into customers values (4,'Ling Wong', 'ling@gmail.com');
insert into customers values (5,'Kalvin Chan', 'Kalvin@gmail.com');
insert into customers values (6,'Sue lee', 'sue@gmail.com');

--  where o.customer_id=c.id -> check if the customer exist in orders
-- Approach 1
select *
from customers c
where exists (select 1 from orders o where o.customer_id=c.id);

-- Approach 2
-- JOIN tables
-- 6 customers * 6 orders = 36 rows
select *
from customers c inner join orders o;

select c.*, o.*
from customers c inner join orders o on (o.customer_id = c.id);

select *
from customers c
where not exists (select 1 from orders o where o.customer_id=c.id);

-- '2024-08'
-- Distinst 1 columns
select distinct Concat_ws('-',extract(Year from trans_date) , extract(Month from trans_date)) from orders;

-- Distinst 2 columns
select distinct Concat_ws('-',extract(Year from trans_date) , extract(Month from trans_date)), total_amount from orders;

select o.* ,(select max(total_amount) from orders)
from orders o;

-- Subquery
-- First SQL to excute select id from customers where name like '%LAU'
-- Second, DBMS excute select * from orders where customer_id in
select *
from orders
where customer_id in (select id from customers where name like '%LAU'); 

select * from orders;

insert into orders values (7, 400.0, null,date_format('2023-09-01','%Y-%m-%d'));

-- LEFT JOIN
select c.*,o.*
from customers c left join orders o on c.id=o.customer_id;

select o.*, c.*
from orders o left join customers c on c.id=o.customer_id;

-- right join
select  o.* ,c.*
from customers c right join orders o on c.id=o.customer_id;

select c.*, o.*
from orders o right join customers c on c.id=o.customer_id;

-- left join + group by
-- count(o.id) is different to count(c.id)
-- Step 1: Left Join (key)
-- Step 2: Where
-- Step 3: group by
-- Step 4: order by
-- Step 5: select
select c.id,c.name,count(o.id) as number_of_orders, ifnull(max(o.total_amount),0) as max_amount_of_orders
from customers c left join orders o on c.id = o.customer_id
where o.total_amount >100.0
group by c.id,c.name
order by c.name asc; 

select * from customers;
insert into customers value (4,'Mary Chan', 'mary@gmail.com');
delete from customers where name ='Mary Chan';

-- DDL
-- Add PK
alter table customers add constraint pk_customer_id primary key(id);
-- insert into customers value (4,'Mary Chan', 'mary@gmail.com'); -- error
insert into customers value (7,'Mary Chan', 'mary@gmail.com'); -- ok

-- Add FK
alter table orders add constraint fk_customer_id Foreign key(customer_id) references customers(id);

select * from orders;
-- insert into orders values (8, 400.0, 10,date_format('2023-09-01','%Y-%m-%d')); -- error as orders. customer_id (10) is not in customers.id
insert into orders values (8, 400.0, 5,date_format('2023-09-01','%Y-%m-%d'));

-- Table design: PK and FK to ensure Data is insert or update with integrity, consistancy
-- Primary Key and Forign Ket are also a type of constriants

-- Other Constraint: Unique Constraint 
select * from customers;

alter table customers add constraint unique_email unique (email);
-- insert into customers value (8,'Mary Chan', 'mary@gmail.com'); -- error

-- not null
alter table customers modify name varchar(50) not null;
-- insert into customers value (9,null, 'mary@gmail.com'); -- error as name is null


select name, email from customers;

select name, email
from customers
union all
select id, total_amount
from orders;

select 1
from customers
union all
select 1
from orders;

-- Distinst, combine two result set no matter any duplicated -  just one '1'
select 1
from customers
union
select 1
from orders;

select * from orders;

-- Select * -> slower performance
-- View -> selecting the real time data (not the moment when create view, no snapshot)
create view orders_2023
as 
select 1
from orders
where trans_date between Date_format('2023-01-01', '%Y-%m-%d') and Date_format('2023-12-31', '%Y-%m-%d') ;

drop view orders_2023;

create view orders_2023
as 
select id,total_amount, trans_date
from orders
where trans_date between Date_format('2023-01-01', '%Y-%m-%d') and Date_format('2023-12-31', '%Y-%m-%d') ;

-- PLSQL, PROCEDUES (IF ELSE, FOR LOOP, CURSOR, SQL)
-- view: Real-Time data (i.e. Actual real-time "orders" table data)
select *
from orders_2023;

