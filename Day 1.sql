-- comment
-- database -> table (row x column)
-- create database db_bc2405p; 

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
insert into students (id, name, weight, height) values (3.5, 'Peter Wong', 90, 12);

insert into students (id, name, weight, height) values (5, 'Peter Chan', 90.999, 12);

select * from students;










