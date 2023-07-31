/*
	DROP TABLE	DepartMent
	DROP TABLE	Employee
	DROP TABLE	Project
	DROP TABLE	Works_On
*/
CREATE TABLE DepartMent(
	did		char(5)		,
	name	varchar(50)	,
	room	varchar(10)	,
CONSTRAINT	dept_pk PRIMARY KEY (did) )

CREATE TABLE Employee(
	eid			char(5),
	name		varchar(50),
	gender		char,
	salary		float,
	birthday	date,
	phone		varchar(10),
	dept		char(5) default '000',
CONSTRAINT emp_pk PRIMARY KEY(eid),
CONSTRAINT emp_uk_phone UNIQUE(phone),  -- เบอร์ห้ามซ้ำ คือprimarykey นั่นแหละ แต่มี eid ที่สมควรกว่า
CONSTRAINT emp_fk_dept FOREIGN KEY (dept)
					REFERENCES Department(did) ON DELETE SET NULL,
CONSTRAINT emp_name CHECK (name IS NOT NULL),
CONSTRAINT emp_salary CHECK (salary BETWEEN 10000 AND 200000), -- 10000 ถึง 200000
CONSTRAINT emp_gender CHECK (gender IN ('M','F','U')) ) -- Only on(..., ..., ... )

CREATE TABLE Project(
	pid	int		identity(1, 1), -- identity จะใส่ค่าให้เองไม่ต้องใส่ตอน input
	name		varchar(30),
	budget		float,
	start_date	date,
	end_date	date,
CONSTRAINT pj_pk PRIMARY KEY(pid),
CONSTRAINT pj_name CHECK(name IS not null),
CONSTRAINT pj_end_date CHECK(end_date > start_date) )

CREATE TABLE Works_On(
	eid			char(5),
	pid			int,
	position	varchar(30),
CONSTRAINT wk_on_pk PRIMARY KEY(eid, pid),
CONSTRAINT wk_on_fk1_eid	FOREIGN KEY(eid) REFERENCES Employee(eid) 
						ON DELETE NO ACTION,
CONSTRAINT wk_on_fk2_pid	FOREIGN KEY(pid) REFERENCES Project(pid) 
						ON DELETE NO ACTION )
 

INSERT into DepartMent values ('000', 'Undefined department', '0')
INSERT into DepartMent values ('100', 'IT', '300')
INSERT into DepartMent values ('200', 'Human Resources', '301')
INSERT into DepartMent values ('300', 'Accounting', '302')
INSERT into DepartMent values ('400', 'markting', '400')
-- ERROR // INSERT into DepartMent (did, name, room) values ('100', 'Customer services',700)

-- ERROR // INSERT into DepartMent values ('200', 'Computer', 202)
insert into Department(did, name, room) values(500,'Reception', '100')
insert into DepartMent(did) values (600)
insert into DepartMent(room, name, did) values('100', 'Customer services',700)

set dateformat dmy
INSERT into Employee values ('e001', 'jim', 'M', 20000, '5 may 1995', '0897745475', 100)
INSERT into Employee (eid, name, salary, phone, dept)values ('e002', 'Jack', 40000, '0852221213', 300)
INSERT into Employee (eid, name, dept)values ('e003', 'Joe', 300)
INSERT into Employee (eid, name, dept, gender, phone)values ('e075', 'Joy', 200, 'F', '0874454545')

insert into Project (name, budget, start_date, end_date) values('MobileX', 500000, '10-9-2020', '15-12-2020')
insert into Project (name, budget, start_date, end_date) values('msu map', 200000, '10-5-2020', '15-6-2020')
insert into Project (name, budget, start_date, end_date) values('Project X', 1000000, '10-2-2020', '6-5-2020') 

insert into Works_On values('e001', 1, 'Programmer')
insert into Works_on values('e002', 1 ,'Manager')
-- Both line is primary key because e001 and e002 works on project 1 and dfrence Position

-- Select Data in table Employee
select * from Employee

-- Select Data in table DepartMent
select * from DepartMent

-- Select Data in table Project
select * from Project

-- Select Data in table Works_On
select * from Works_On

select *
From Department
Where did = 200

select *
From Department
Where did in (200, 300, 500).

select name, eid, gender, phone
From Employee

-- Delete statement
Delete
From DepartMent
Where did = '100'

Delete
From DepartMent
where did IN (100, 200)

Delete
From DepartMent
where name is null

-- Update statement
Update Employee
set name = 'joe'
where name = 'Peter'

Update Employee
set gender = 'M'
where gender is null and eid = 'e002'