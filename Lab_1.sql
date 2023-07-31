/*
drop table DEPARTMENT
drop table EMPLOYEE
drop table PROJECT
drop table WORKS_ON
*/
create table DEPARTMENT(
	did		varchar(20),
	name	varchar(50),
	room	varchar(20),
constraint dept_pk PRIMARY KEY(did))

create table EMPLOYEE(
	eid		varchar(5),
	name	varchar(50),
	gender	char,
	salary	float,
	birthday date,
	phone	varchar(10),
	dept	char(5)default'000',
constraint emp_pk PRIMARY KEY(eid),
constraint emp_uk_phone UNIQUE(phone),
constraint emp_fk_dept FOREIGN KEY(dept)
			REFERENCES department(did)ON DELETE SET NULL,
constraint emp_name CHECK (name IS NOT NUll),
constraint emp_salary CHECK (salary BETWEEN 10000 AND 200000),
constraint emp_gender CHECK (gender IN('M','F','U')))

create table PROJECT(
	pid		varchar(10),
	name	varchar(20),
	bugget	float,
	start_date date,
	end_date date,
constraint prj_pk PRIMARY KEY(pid),
constraint prj_check_enddate CHECK(end_date>start_date))

create table WORKS_ON(
	eid		varchar(5),
	pid		varchar(10),
	position varchar(20),
constraint workon_pk PRIMARY KEY(eid,pid),
constraint workon_fk1_eid FOREIGN KEY(cid) REFERENCES employee(eid) ON DELETE NO ACTION,
constraint workon_fk2_pid FOREIGN KEY(pid) REFERENCES project(pid)	ON DELETE NO ACTION)

insert into department values('d01','IT','202')
insert into department values('d02','CS','203')
insert into department values('d03','CA','205')

select * from department

set dateformat dmy

insert into EMPLOYEE values('e001','Arigato','M',14000,'5-may-1995','064456465',100)
insert into EMPLOYEE values('e002','hohk','M',14000,'28-may-2001','041414544',200)

select * from employee

insert into PROJECT values('p001','PoPo',1000,'10-9-2020','15-12-2020')

select * from project

insert into WORKS_ON values('d08','LL','204')
insert into WORKS_ON values('d09','TT','205')
insert into WORKS_ON values('d10','UU','206')

select * from works_on






