
------------------ Advance data manipulation ------------

--1. ให้นิสิตทุกคนที่เรียนวิชา CS001 ในเทอม 1-2020 ได้เกรด A
select * from enroll
select * from section

update	enroll
set		grade = 'A'
where   secid in
	(select		secid
	from		section
	where		term = '1-2020'
	and			subid = 'CS001')

--2. เพิ่มเงินเดือน 10 % ให้อาจารย์ทุกคนที่สอนในปี 2020
update	lecturer
set		salary = salary + (salary*0.1)
where	lid in
	(select		lecid
	from		section
	where		substring(term,3,4) = '2020')

--3. เพิ่มเงินเดือน 20% ให้อาจารย์ทุกคนที่มีเงินเดือนต่ำกว่าค่าเฉลี่ยเงินเดือนของอาจารย์ทั้งหมด
update		lecturer
set			salary = salary + (salary*0.2)
where		salary <
		(select		Avg(salary)
		from		lecturer)
		
--4. เพิ่มเงินเดือน 10% ให้อาจารย์ที่สอนมากกว่า 1วิชาในเทอม 1-2020
update		lecturer
set			salary = salary + (salary*0.1)
where		lid in
		(select		lecid
		from		section
		where		term = '1-2020'
		group by	lecid
		having		count(*) > 1)

-- Alter Table ไม่ออกสอบ และไม่ทำแลป

-- คล้ายๆ Function
-- sp_rename '<Table>', '<new Table>'
	-- ตัวอย่าง sp_rename	'Section', 'cours'
-- sp_rename '<Table.column>', '<new column>'

-- คำสั่ง  Alter Table เป็นการแก้ไข Column เช่น add, Drop
/*	ตัวอย่าง
	ALTER TABLE <table_name>
	ALTER COLUMN <column_name> <datatype> <constraint>
	+
	ADD <what ?>
	DROP <what ?>
*/

------------------ View ------------------
-- Ex
create view CS_data(a,b,c) as
	(select		sid,name,gpa
	from		student)

select * from CS_data

-- Part 1
--1. GOOD_STD(sid, gpa)โดยมีเฉพาะข้อมูลของนิสิตที่ gpa 3.00 ขึ้นไป
create view GOOD_STD(sid, gpa) as
	(select		sid, gpa
	from		student
	where		gpa >= 3.00)

--2. LEC_TCH(lid, amount) โดยมีข้อมูลรหัสอาจารย์ และจำนวนวิชาที่เคยสอนทั้งหมด
create	view LEC_TCH(lid, amount) as
		(select		lecid, count(*)
		from		section
		group by	lecid)

select * from LEC_TCH
Drop	view LEC_TCH


--3. Lecturer_Load (lecid, term, amount) 
--โดยเป็นข้อมูลรหัสอาจารย์ ภาคเรียน และจำนวนวิชาที่สอนในภาคเรียนนั้น ๆ ของอาจารย์ 
create view	Lecturer_Load (lecid, term, amount) as
		(select		lecid, term, count(*)
		from		section
		group by	lecid, term)

select * from  Lecturer_Load
Drop	view Lecturer_Load
	
--4. Student_Credit (stdid, sum_credit) 
--เป็นข้อมูลรหัสนิสิต และจำนวนหน่วยกิตที่เรียนทั้งหมด เฉพาะที่เกรดไม่เป็น F
create view Student_Credit (stdid, sum_credit) as
		(select		stdid,sum(credit)
		from		enroll, section, subject
		where		subject.sid = section.subid
		and			enroll.secid = section.secid
		and			enroll.grade != 'F'
		group by	enroll.stdid)

select * from Student_Credit
select * from section
select * from enroll
select * from subject

--5. Major_Detail(major, amount, max_gpa, min_gpa, avg_gpa ) 
--โดยเป็นข้อมูล ชื่อภาควิชา, จำนวนนิสิต, g

create view Major_Detail(major, 
						amount, 
						max_gpa, 
						min_gpa, 
						avg_gpa ) as
						(select		major, 
									count(sid),
									max(gpa),
									min(gpa),
									avg(gpa)
						from		student
						where		major is not null
						group by	major)
select * from Major_Detail

-- Part 2
--1. แสดงรายชื่อของนิสิตทั้งหมดที่อยู่ใน mjor ที่มี gpa เฉลี่ยสูงที่สุด

select		name
from		Major_Detail, STUDENT
where		Major_Detail.major = student.major
and			avg_gpa =
			(select		max(avg_gpa)
			from		Major_Detail)
--2 แสดง ชื่อนิสิต , ภาควิชา และ gpa ของนิสิต ที่ได้ gpa ต่ำสุดในแต่ละภาควิชา
select		student.name, Major_Detail.major, gpa
from		Major_Detail, STUDENT
where		Major_Detail.major	= student.major
and			student.gpa			=	Major_Detail.min_gpa
and			name is not null
	
select * from Major_Detail
select * from student

--3. แสดงรหัส ชื่ออาจารย์และภาควิชา ของอาจารย์ที่สอนหลายวิชาที่สุด
select		distinct lecturer.lid,name, major, amount
from		lecturer, LEC_TCH
where		lecturer.lid = LEC_TCH.lid
and			LEC_TCH.amount = 
			(select	max(amount)
			from	LEC_TCH)

select * from LEC_TCH


------------------ Stored Procedure ------------------

Create procedure Display_2
    -- Paramiter
	@major	varchar(10),
	@gpa	float	
as
	-- Statement for select data 
	select	sid, name, major, gpa
	from	student
	where	gpa > @gpa
	and		major = @major

-- Call procedure
exec Display_2 "cs", 2.50
-- Drop procedure
drop procedure Display_2

----
create procedure sd_oop
	@grade	char(1),
	@major  varchar(10)
as
	select  sid, name, grade, major
	from	student, enroll
	where	student.sid = enroll.stdid
	and		major = @major
	and		grade = @grade

exec sd_oop  A,"cs"
drop procedure sd_oop
---
-- แสดงรหัสนิสิต ชื่อนิสิต ชื่ออาจารย์ผู้สอน เทอมที่เรียน ของนิสิตเอก CS ที่ติด F วิชา xxx
create procedure Display_4
	@subject	varchar(20)
as
select	STUDENT.sid, STUDENT.name, LECTURER.name, SECTION.term
from	STUDENT, LECTURER, SECTION, ENROLL, SUBJECT
where	STUDENT.sid = ENROLL.stdid
and		ENROLL.secid = SECTION.secid
and		SECTION.lecid = LECTURER.lid
and		SECTION.subid = SUBJECT.sid
and		STUDENT.major = 'CS'
and		ENROLL.grade = 'F'
and		SUBJECT.name = @subject

exec	Display_4 'OOP'
drop	procedure Display_4 

-- Local variable
create procedure display_6 
	@major	varchar(10)
as 
declare
	@mgpa	float

	select	@mgpa = max(gpa) 
	from	student
	where	major = @major

	select	sid, name, gpa
	from	student
	where	gpa = @mgpa
	and		major = @major
	
exec	display_6 "py"
drop	procedure	display_6


--- แสดง รหัส ชื่อ เงินเดือน วิชาเอก ของอาจารย์ที่อยู่เอก xxx
--- และได้เงินเดือนน้อยกว่าค่าเฉลี่ยของอาจารย์ในเอกนั้นๆ
create procedure money_of 
	@major		varchar(10)
as declare

	@Avg  float

	select	@Avg = avg(salary)
	from	lecturer
	where	major = @major

	select	lid, name, salary, major
	from	lecturer
	where	salary < @Avg
	and		major = @major

exec money_of 'cs'
drop procedure money_of 

create procedure up_salary
	@major			varchar(10)
as
	declare
	@Asalary		float

	select	@Asalary = avg(salary)
	from	lecturer
	where	major = @major

	if(@Asalary < 40000)
	begin
		print 'Update 10 %' 
		update	lecturer
		set salary += salary * 0.1
	end
	else
	begin
		print 'Update 5 %'
		update  lecturer
		set		salary += salary * 0.05
	end

select  *
from	lecturer

exec up_salary 'cs'
drop	procedure up_salary 

------- Cursor -------
--- lab 1
create procedure msp_young_students
	@S_year	int,
	@E_year	int
as
	select	sid, name, major, 
			datediff(year, birthday, getdate()) as ages
	from	STUDENT
	where	datediff(year, birthday, getdate()) 
			between @S_year	and	@E_year

exec msp_young_students 19,20
-- lab 2
create procedure msp_major_grade_student
		@major		varchar(10)
as
	declare
	@mgpa		float

	select	@mgpa =  max(gpa)
	from	student
	where	major = @major

	select		count(*) as จำนวนนิสิต, major
	from		student
	where		major = @major
	group by	major

exec msp_major_grade_student 'cs'

-- lab 3
create procedure msp_any_sub_student
	@subject	varchar(30)
as
	select	student.sid, student.name, term, grade
	from	Student, enroll,section, subject
	where	student.sid = enroll.stdid
	and		enroll.secid = section.secid
	and		section.subid = subject.sid
	and		subject.name = @subject

exec msp_any_sub_student 'programming' 
drop procedure msp_any_sub_student

-- lab 4
create procedure msp_any_sub_term_student
		@subid		varchar(10),
		@term		varchar(5)
as
	
	select	sid, name, major, birthday
	from	student, enroll, section
	where	student.sid = enroll.stdid
	and		enroll.secid = section.secid
	and		section.subid = @subid
	and		substring(term, 1,1) = @term

exec msp_any_sub_term_student 'CS001','1'
drop procedure msp_any_sub_term_student

-- lab 5
create procedure msp_update_salary
	@major  varchar(10),
	@per	float
as
	update	lecturer
	set		salary += salary * @per/100 
	from	lecturer
	where	major = @major

select * from lecturer
exec msp_update_salary 'cs', 10
drop procedure msp_update_salary

-- lab 6
create procedure msp_delete_subject
as
	delete 
	from	subject
	where	sid not in
		(select subid
		from	section)

exec msp_delete_subject
	
-- lab 7 
create procedure msp_enroll_reprot
	@term	varchar(1)
as
	select		section.secid, section.subid, count(stdid) as จำนวนนิสิตที่ลงเรียน
	from		section ,enroll
	where		enroll.secid = section.secid
	and			substring(term,1,1) = @term
	group by	section.secid, section.subid

exec msp_enroll_reprot 2
drop procedure msp_enroll_reprot

--- lab 8 
create procedure msp_increase_salary
	@mid_sal	float,
	@i1			float,
	@i2			float
as
	update	LECTURER
	SET salary = case
	WHEN salary < @mid_sal		THEN salary + (salary * @i1 / 100)
	WHEN salary >= @mid_sal		THEN salary + (salary * @i2 / 100)
	END

exec  msp_increase_salary 7000, 10, 5
drop procedure msp_increase_sarary
	
select *
from lecturer

-- lab 9
-- lab 10
create procedure msp_increase_salary
	@term		varchar(10),
	@money		int
as
	declare
		st_cur CURSOR for select stdid, term, count(Grade),


--------------------------- Trigger --------------------------------------
create table StudentBackup(
	sid			varchar(10),
	name		varchar(30),
	major		varchar(30),
	gpa			float,
	resign_date date)

create trigger tg_std_deleteStudent on student
for delete as
declare
	@sid		varchar(10),
	@name		varchar(30),
	@major		varchar(30),
	@gpa		float

	select @sid		= sid from deleted
	select @name	= name from deleted
	select @major	= major from deleted
	select @gpa		= gpa from deleted

	insert into studentBackup values(@sid, @name, @major, @gpa, getdate())
------------------------------------------------------------------------
drop table studentbackup
drop trigger tg_std_deleteStudent 

delete from studentbackup where sid is null
	insert into student values('60001', 'papa','CS',3.50,'2-12-2010')

select * from studentbackup
select * from student

create table salaryHistory(
	mdate		date,
	lid			varchar(5),
	xrate		float,
	nrate		float,
	db_user		varchar(30))


create trigger tg_lec_update on lecturer
for update as
declare
	@lid		varchar(30),
	@newSalary	float,
	@oldSalary	float

declare	lec_cur cursor for select lid from inserted
open lec_cur

if update(salary)
begin
	fetch next from lec_cur into @lid
	
	while(@@fetch_status = 0)
	begin
		select @newSalary = salary from inserted where lid = @lid
		select @oldSalary = salary from deleted where lid = @lid
		insert into SalaryHistory values
					(getdate(), @lid, @oldSalary, @newSalary, suser_name())
		
		fetch next from lec_cur into @lid
	end
end

close lec_cur
deallocate lec_cur
----------------------------------------------------

update lecturer set salary = 50000 where lid = 't01'

select * from lecturer
select * from salaryhistory

--2. [ tg_ LimitTeaching Credit ]
--เพื่อจำกัดจำนวนการสอนของอาจารย์ให้สอนได้ไม่เกินเทอมละ 10 หน่วยกิต

-- step 1
select		lecid, subid, credit
from		section, subject
where		subject.sid = section.subid
and			lecid = 't01'
and			term = '1-2020'

--step 2
select		lecid, sum(credit)
from		section, subject
where		subject.sid = section.subid
and			lecid = 't01'
and			term = '1-2020'
group by	lecid

create trigger tg_LimitTeaching_Credit on section
for insert, update as 
declare
	@lecid			varchar(10),
	@term			varchar(6),
	@total_credit	int

select @lecid = lecid from inserted
select @term = term from inserted
select @total_credit = sum(credit)
		from section, subject
		where	section.subid = subject.sid
		and			lecid = 't01'
		and			term = '1-2020'
		group by	lecid

if(@total_credit > 3)
begin	
	print 'This lecturer cen not teach more than 3 credit'
	rollback
end

select		lecid, sum(credit)
from		section, subject
where		subject.sid = section.subid
and			lecid = 't01'
and			term = '1-2020'
group by	lecid

set dmy
insert into section(subid, lecid, term) values('cs002','t01', '1-2020')
insert into section(subid, lecid, term) values('cs005','t01', '1-2020')
insert into section(subid, lecid, term) values('cs005','t01', '1-2020')
--- demo code 

select * from enroll
select stdid, count(secid)
from	enroll
group by stdid

--3. [ tg Limit Enroll Subject ]
--เพื่อจำกัดให้นิสิตลงทะเบียนได้ไม่เกินเทอมละ 5 วิชา

drop trigger tg_Limit_Enroll_Subject
create trigger tg_Limit_Enroll_Subject on enroll
for insert, update as 
declare
	@stdid		varchar(10),
	@secid		int

select		@stdid  =  stdid from inserted
select		@secid  =  count(secid)
from		enroll	
group by	stdid

if(@secid > 5)
begin
	print 'Enroll more than 5 subject'
	rollback
end

insert into enroll values ('')



--. [ tg_Limit Enroll Credit ]
--เพื่อจำก็ดให้นิสิตลงทะเบียนได้ไม่เกินเทอมละ 21 หน่วยกิต
--5.[tg_No_StdID_Change ]
--เพื่อไม้ให้มีการเปลี่ยนรหัสนิสิตใน table ENROLL