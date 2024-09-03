create database BOOTCAMP_EXERCISE1;

use BOOTCAMP_EXERCISE1;

create table regions(
	region_id int primary key,
    region_name varchar(25)
);

create table countries (
	country_id varchar(2) Primary Key,
    country_name varchar(40),
    region_id int,
    foreign key (region_id) references regions(region_id)
);

create table locations (
	location_id int Primary Key,
    street_address varchar(25),
    postal_code varchar(12),
    city varchar(30),
    state_province varchar(12),
    country_id varchar(2),
    foreign key (country_id) references countries(country_id)
);

create table jobs(
	job_id varchar(10) Primary Key,
    job_title varchar(35),
    min_salary int,
    max_salary int
);

create table departments(
	department_id int primary key,
    department_name varchar(30),
    manager_id int,
    location_id int,
    foreign key (location_id) references locations(location_id)
);

create table employees (
	employee_id int primary key,
    first_name varchar(20),
    last_name varchar(25),
    email varchar(25),
    phone_number varchar(20),
    hire_date date,
    job_id varchar(10),
    salary int,
    commission_pct int,
    manager_id int,
    department_id int,
    foreign key(job_id) references jobs (job_id),
    foreign key (department_id) references departments(department_id)
);

create table job_history(
	employee_id int ,
    start_date date,
    end_date date,
    job_id varchar(10),
    department_id int,
    primary key(employee_id,start_date),
    foreign key (job_id) references jobs(job_id),
    foreign key (department_id) references departments(department_id),
    foreign key(employee_id) references employees(employee_id)
);



-- 2

insert into regions (region_id , region_name) values(1,'Asia');
insert into regions (region_id , region_name) values(2,'Europe');

insert into countries values(1, 'Hong Kong',1);
insert into countries values(2, 'United Kingdom',2);

insert into locations values (1, 'No.1, NT Road', '000000', 'Prince Edward', 'Kowloon','1');
insert into locations values (2, 'No.1, London Road', '312456', 'London', 'London','2');

insert into departments values (1, 'Marting', 1, 1);
insert into departments values (2, 'IT', 14, 1);
insert into departments values (3, 'HR', 33, 2);
insert into departments values (4, 'Admin', 66, 2);

insert into jobs values ('IT_PRO', 'IT Programming', 10000,20000);
insert into jobs values ('MK_PRO', 'Marketing Promote', 8000,12000);
insert into jobs values ('ST_CLERK', 'Standard Clerk', 6000,10000);
insert into jobs values ('SAL_ADJ', 'Salary Adjustment', 13000,16000);
insert into jobs values ('Bou_cal', 'Bouns Calculation', 3000,4000);



insert into employees values (101,'Peter','Chan','peter.chan@gmail.com','9871234',date_format('1991-01-04','%Y-%m-%d'),'IT_PRO',20000,0,null,2);
insert into employees values (102,'Carman','Wong','carman.wongn@gmail.com','95612367',date_format('1993-02-04','%Y-%m-%d'),'MK_PRO',15000,15,null,1);
insert into employees values (103,'John','Lam','john.lam@gmail.com','90845938',date_format('1985-04-21','%Y-%m-%d'),'MK_PRO',40000,0,1,1);
insert into employees values (104,'Ming','Sze','mong.sze@gmail.com','65478321',date_format('1987-12-23','%Y-%m-%d'),'ST_CLERK',16000,0,null,4);
insert into employees values (105,'Vivian','Chan','vivian.chan@gmail.com','68970345',date_format('1993-04-04','%Y-%m-%d'),'Bou_cal',23000,0,null,3);

insert into job_history values (101,date_format('2000-01-13','%Y-%m-%d'),date_format('2001-07-24','%Y-%m-%d'),'IT_PRO',2);
insert into job_history values (102,date_format('2001-09-21','%Y-%m-%d'),date_format('2002-10-27','%Y-%m-%d'),'MK_PRO',1);
insert into job_history values (103,date_format('2002-10-28','%Y-%m-%d'),date_format('2003-03-15','%Y-%m-%d'),'MK_PRO',1);
insert into job_history values (104,date_format('2006-02-17','%Y-%m-%d'),date_format('2007-12-19','%Y-%m-%d'),'ST_CLERK',4);
insert into job_history values (102,date_format('2002-03-24','%Y-%m-%d'),date_format('2003-12-31','%Y-%m-%d'),'MK_PRO',1);
insert into job_history values (105,date_format('2002-05-23','%Y-%m-%d'),date_format('2003-12-31','%Y-%m-%d'),'Bou_cal',3);
-- 3

select l.location_id, l.street_address, l.state_province, c.country_name
from locations l left join countries c on l.country_id = c.country_id;

-- 4

select e.first_name , e.last_name, e.department_id
from employees e;

-- 5 in London
select e.first_name , e.last_name, e.job_id, e.department_id
from employees e left join (
select d.department_id
from departments d left join locations l on d.location_id = l.country_id
where l.country_id = 2
) x on x.department_id = e.department_id
where x.department_id is not null;

-- 6
select e.first_name , e.last_name, e.manager_id
from employees e
where e.manager_id is not null;

-- 7 after Peter Chan
select e.first_name , e.last_name, e.hire_date
from employees e where exists ( select 1 from (select min(e.hire_date) as min
from employees e 
where e.hire_date > '1991-01-04'
order by e.hire_date) x where e.hire_date = x.min);

-- 8

select d.department_name, count(d.department_name) as employees_count
from departments d left join employees e on d.department_id = e.department_id
group by d.department_name;

-- 9 (department_id = 1, Marketing)

select jh.employee_id,j.job_title, datediff(jh.end_date,jh.start_date)
from job_history jh left join jobs j on jh.job_id = j.job_id
where jh.department_id = 1;

-- 10 

select d.department_name, d.manager_id, x.city, x.country_name
from departments d left join
( select l.location_id, l.city, c.country_name
from locations l left join countries c on c.country_id = l.country_id
) x on x.location_id = d.location_id;

-- 11
select d.department_name, avg(e.salary) as average_salary
from employees e left join departments d on d.department_id = e.department_id
group by d.department_name;