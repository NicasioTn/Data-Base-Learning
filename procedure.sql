--1. [ msp_young_students ]  	
แสดง sid, name, major  และ อายุ ของนิสิตทุกคนที่อายุอยู่ในช่วง xx ถึง yy ปี
create procedure msp_young_students
	@a1 int,
	@a2 int
as
	select sid,name,major,year(getdate())-year(birthday)
	from student
	where year(getdate())-year(birthday)>=@a1
	and year(getdate())-year(birthday)<=@a2

	exec msp_young_students 18,20


--2. [ msp_major_grade_students ]  	
แสดงจำนวนนิสิตในภาควิชา xx ที่ได้ gpa สูงกว่า yy 

create procedure msp_major_grade_students
	@major varchar(20),
	@gpa float
as
	select count(*)
	from student
	where major=@major
	and gpa>@gpa

	exec msp_major_grade_students 'cs',3.50




--3. [ msp_any_sub_students ] 	
แสดง sid, name, term, grade ของนิสิตเฉพาะที่เรียนวิชารหัส  xx

create procedure msp_any_sub_students
	@subid varchar(20)
as
   select sid,name,term,grade
   from student,section,enroll
   where student.sid = enroll.stdid
   and enroll.secid = section.secid
   and section.subid =@subid

   exec msp_any_sub_students 'CS001'

   	 
--4. [ msp_any_sub_term_students ]   
แสดงรายละเอียดของนิสิตทุกคนที่เคยเรียนวิชารหัส  xx ในเทอม yy

create procedure msp_any_sub_term_students
  @subid varchar(20),
  @term varchar(10)
as
  select student.*
  from student, enroll, section
  where student.sid = enroll.stdid
  and enroll.secid = section.secid
  and subid =@subid
  and term = @term

  exec msp_any_sub_term_students 'CS001','1-2019'



--5. [msp_update_salary]		เพื่อเพิ่มเงินเดือนให้อาจารย์ภาควิชา xx โดยเพิ่ม yy %
create procedure msp_update_salary
 @major varchar(20),
 @percent int
as
 update lecturer
 set salary = salary+salary*(@percent/100.0)
 where major = @major

 drop procedure msp_update_salary
 exec msp_update_salary 'CS',10

 select * from lecturer

--6. [msp_delete_subject] 		เพื่อลบข้อมูลวิชาที่ไม่เคยเปิดสอนเลย

create procedure msp_delete_subject
as
 delete from subject
 where sid not in 
   (select subid
   from section)

exec msp_delete_subject

select * from subject

--7. [msp_enroll_report] 		เพื่อแสดงรายละเอียดการลงทะเบียนเรียนในเทอม xx 
--โดยแสดง secid, subid  และจำนวนนิสิตที่ลงเรียนใน secid  นั้น
create procedure msp_enroll_report
  @term varchar(20)
as 
  select enroll.secid,subid, count(*)
  from enroll,section
  where enroll.secid = section.secid
  and term = @term
  group by  enroll.secid, subid

  exec msp_enroll_report '1-2020'



--8. [msp_increase_salary] เพิ่มเงินเดือนอาจารย์ โดยมีการรับ parameter 3  ตัว
--major, percent,  


--9. [msp_count_Credit] เพิ่มหรือแก้ไขข้อมูล รหัสนิสิต และจำนวนหน่วยกิตที่ลงทะเบียนเรียนเฉพาะที่ไม่ได้เกรด F 
--ลงใน table Credit_Complete(stdid, credit, cdate)


create table Credit_Complete(
stdid varchar(10), 
credit int, 
cdate date)


drop table credit_complete

create procedure msp_count_Credit
as
declare
	@sid varchar(10),
	@amount int,
	@check int
declare
  std_cur CURSOR for select stdid,sum(credit) 
  from enroll,section,subject
  where enroll.secid = section.secid
  and section.subid = subject.sid
  and grade !='F'
  group by stdid
open std_cur
fetch next from std_cur into @sid, @amount --@sid =60001, @amount=19
while(@@FETCH_STATUS=0)
begin
	select @check = count(stdid) from Credit_Complete
	where stdid = @sid
	if(@check =0)
	begin
		insert into Credit_Complete values(@sid,@amount,getdate())
	end
	else
	begin
	    update Credit_Complete 
		set credit=@amount
		where stdid = @sid
	end

	fetch next from std_cur into @sid, @amount
end
close std_cur
deallocate std_cur

drop procedure msp_count_Credit

exec msp_count_Credit

select * from Credit_Complete

insert into ENROLL values(14,60002,'B')

select  count(stdid) from Credit_Complete
	where stdid = '60001'



--10. [msp_student_prize] มหาวิทยาลัยต้องการให้รางวัลกับนิสิตที่เรียนได้ A ในแต่ละเทอม 

select  lecid, enroll.secid, subid, count(*)
from	enroll, section
where	enroll.secid = section.secid
and		term = '2-2020'
group by lecid, enroll.secid, subid

select  enroll.secid, count(*)
from	enroll, section
where	enroll.secid = section.secid
and		term = '2-2020'
group by enroll.secid


select * from enroll where secid in (11,12,13)