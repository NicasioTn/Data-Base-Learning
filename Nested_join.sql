

select sid, name, gpa 
from STUDENT
where major = 'PY'
and gpa =
	(select max(gpa)
	from STUDENT
	where major = 'PY')


-- Nested join
-- 1.แสดงชื่อของอาจารย์ที่เคยาอนวิชา Programming
select lecturer.name
from	lecturer
where	lid in
	(select lecid
	from	SECTION
	where  subid in
		(select sid
		from	subject
		where	name = 'Programming'))

-- 2. แสดงจำนวนอาจารย์ CS ที่เคยสอน Programming 
Select count(lid) as many_lecturer 
from lecturer 
where major = 'CS'
and	  lid in
	(select	lecid
	from section
	where subid in
	(select sid
	from subject 
	where name = 'Programming'))
		
--3. แสดงชื่อของอาจารย์ CS ที่ไม่เคยสอนวิชา Database
select LECTURER.name
from LECTURER
where major = 'CS'
and lid not in 
	(select lecid
	from section
	where subid in
		(select sid
		from subject
		where subject.name = 'Database'))


--4. แสดงจำนวนครั้งที่มีการลงทะเบียนเรียนในเทอม 2-2020
select count(enroll.secid)
from enroll
where secid in
	(select secid
	from section
	where term = '2-2020')

--5. แสดงจำนวนนิสิตที่ลงทะเบียนเรียนในเทอม 2-2020
select stdid
from enroll
where secid in
	(select secid
	from section
	where term = '2-2020')

--6. แสดง รหัสอาจารย์และชื่อ ของอาจารย์ที่ไม่ได้สอนใน 1-2020
select lid, lecturer.name
from lecturer
where lid not in 
	(select lecid
	from section
	where term = '1-2020')
--7. แสดง name, ปีเกิด, อายุ ของนิสิตที่อายุน้อยที่สุด (เปรียบเทียบถึงระดับวัน)

--8. แสดง name, ปีเกิด, อายุ ของนิสิตที่อายุมากที่สุด ใน major CS (เปรียบเทียบถึงระดับวัน)
--9. แสดง ข้อมูล ของนิสิตที่ได้ GPA สูงที่สุดในมหาวิทยาลัย
--10. แสดง ข้อมูล ของนิสิตที่ได้ GPA สูงที่สุดใน major CS
--11. แสดง ข้อมูล ของนิสิตที่เคยลงทะเบียนเรียน และไม่เคยติด F เลย
--12. แสดงจำนวนวิชาที่มีวิชา Programming เป็น วิชา pre-requisite
--13. แสดงรหัสวิชาและ ชื่อวิชา ที่ไม่เคยเปิดสอนเลย
--14. แสดงข้อมูลของนิสิตที่ได้ gpa น้อยที่สุด และ  gpa สูงที่สุด
select *
from student 
where gpa = 
	(select Max(gpa)
	from student )
	UNION
select *
from student 
where gpa = 
	(select Min(gpa)
	from student )
	
--15. แสดง ชื่อ, ปีเกิด, อายุ ของนิสิตที่อายุน้อยที่สุด และอายุมากที่สุดใน major CS
--16. แสดงข้อมูลของอาจารย์ cs ที่ได้เงินเดือนมากกว่าเงินเดือนฉลี่ยของอาจารย์ทุกคนในมหาวิทยาลัย

--1. แสดง ชื่อmajor , gpa สูงสุดของ major นั้น ๆ และ gpa ต่ำสุดของ major นั้น ๆ
select major , max(gpa) as 'Max', min(gpa) as 'Min'
from student
group by major

--2. แสดง ชื่อmajor , gpa สูงสุดของ major นั้น ๆ และ gpa ต่ำสุดของ major นั้น ๆ โดยแสดงเฉพาะ major ที่มีค่า gpa ต่ำสุด มากกว่า 2.00
select major , max(gpa) as 'Max', min(gpa) as 'Min'
from student
group by major
having min(GpA) > 2.00
--3. แสดง รหัสนิสิต, และจำนวนครั้งที่ลงเรียน 
select stdid, count(*)
from enroll
group by stdid

--4. แสดง รหัสนิสิต, และจำนวนครั้งที่ลงเรียน เฉพาะนิสิตที่อยู่ major CS
select stdid, count(*)
from enroll
group by stdid
having stdid in
	(select sid
	from student
	where major = 'CS')

--5. แสดง เกรด, จำนวนครั้งที่ได้เกรดนั้นๆ ของนิสิตรหัส 60001
select grade, count(*)
from enroll
where stdid = '60001'
group by grade

--6. แสดง รหัสนิสิต และ จำนวนครั้งที่ได้เกรด F ของนิสิตรหัสนั้น ๆ  
select stdid, count(*)
from enroll
where grade = 'F'
group by stdid

--7. แสดง รหัสนิสิต และ จำนวนครั้งที่ได้เกรด F โดยแสดงเฉพาะนิสิตที่ได้เกรด F มากกว่า 1 ครั้ง
--8. แสดงข้อมูลทุกอย่างของอาจารย์ที่เคยสอนมากกว่า 3 ครั้ง
--9. แสดงข้อมูลทุกอย่างของอาจารย์ที่เคยสอนวิชา CS001 มากกว่า 1 ครั้ง
--10. แสดงชื่อสาขา และ เงินเดือนเฉลี่ย ของอาจารย์ในสาขานั้น ๆ


select *
from lecturer
where max(avg_max) in
	(select major
	from lecturer
	where avg(salary) as avg_max)
	


--2. แสดงข้อมูลนิสิต ที่อยู่ในสาขาที่มีนิสิตมากกว่า 3 คน
	select		*
	from		STUDENT
	where		major in (select		major
						from		student
						group by	major
						having	    count(major) > 3)
