-----------------------------------------------------------
-------- Join query (slide p. 27)--------------------------
-----------------------------------------------------------

--1. แสดงรหัสนิสิต และชื่อนิสิตที่เคยเรียนวิชา CS001
-- * commond mistake -- take table SUBJECT for nothing!
	select	sid, name
	from	student, enroll, section
	where	student.sid		= enroll.stdid
	and		enroll.secid	= section.secid
	and		section.subid	= 'CS001'

--2. แสดงรหัสนิสิต และชื่อนิสิตที่เคยเรียนวิชา Programming 
-- commond mistake: Ambiguous column name sid, name
	select  student.sid, student.name 
	from	student, enroll, section, subject
	where	student.sid		= enroll.stdid
	and		enroll.secid	= section.secid
	and		section.subid	= subject.sid
	and		subject.name	= 'programming'
	



--3. แสดงรหัสนิสิต และชื่อนิสิตที่เคยเรียนกับอาจารย์ชื่อ Peter Parker
-- remark: use distinct
	select distinct student.sid, student.name
	from	student, lecturer, section, enroll
	where	student.sid		= enroll.stdid
	and		enroll.secid	= section.secid
	and		section.lecid	= lecturer.lid
	and		lecturer.name	= 'Peter parker'


-- 4. แสดงชื่อวิชา ชื่ออาจารย์ และเทอมที่เปิดสอน
	select  subject.name, lecturer.name, term
	from	subject, lecturer, section
	where	subject.sid		= section.subid
	and		lecturer.lid	= section.lecid



--5. แสดงชื่อวิชา, เทอมที่สอน, ชื่อผู้สอน ของทุกวิชาที่สอนโดยอาจารย์ใน major CS
	select  subject.name, term, lecturer.name
	from	subject, section, lecturer
	where	subject.sid		= section.subid
	and		section.lecid	= lecturer.lid
	and		lecturer.major	= 'CS'

--6. แสดงรหัสนิสิตที่ได้เกรด A วิชา Programming 
	select  enroll.stdid
	from	enroll, subject, section
	where	enroll.secid  = section.secid
	and		section.subid = subject.sid
	and		grade		  = 'A'
	and		subject.name  = 'programming'

--7. แสดงรหัสนิสิต ชื่อนิสิต และเกรดที่ได้ ของนิสิตที่เรียน section id 6
	select  distinct student.sid, student.name , grade
	from	student, enroll
	where	student.sid		= enroll.stdid
	and		enroll.secid	= 6
	
--8. แสดงรหัสวิชา ชื่อวิชา และเกรดที่ได้ ของทุกวิชาที่นิสิตชื่อ Alex เคยเรียน
	select subject.sid, subject.name, grade
	from   subject, section, enroll, student
	where  enroll.secid	 = section.secid
	and	   section.subid = subject.sid
	and	   enroll.stdid	 = student.sid
	and	   student.name	 = 'Alex'
--9. แสดงชื่อวิชาและเทอมที่เปิดสอน เรียงลำดับตามเทอม
	select subject.name, term
	from	subject, section
	where	section.subid = subject.sid
	order by substring(term,3,4), substring(term,1,1)

--10. แสดงชื่อวิชา และเทอมที่สอน ของทุก section ที่อาจารย์ชื่อ Steve Roger เคยสอน
	select subject.name, term
	from	section, lecturer, subject
	where	subject.sid	  = section.subid
	and		section.lecid = lecturer.lid
	and		lecturer.name = 'Steve Roger'

--------------------------------------------------------------------
---------- Algebra, Outer join, table alias  (slide p. 55)  --------
--------------------------------------------------------------------

--1. แสดงรหัสวิชา และชื่อวิชาที่เป็น pre-requisite ของวิชารหัส cs002
	select S2.sid, S2.name
	from	subject S1, subject S2
	where   S1.prerequisite = S2.sid
	and		S1.sid			= 'cs002'
--2. แสดงรหัสวิชา และชื่อวิชาที่เป็น pre-requisite ของวิชา AI
	select S2.sid, S2.name
	from	subject S1, subject S2
	where   S1.prerequisite = S2.sid
	and		S1.name			= 'AI'
--3. แสดงรหัสนิสิต และชื่อนิสิตของนิสิตที่เคยเรียนทั้งวิชา cs001  และ cs002
	select	student.sid, student.name 
	from	student, enroll, section
	where	student.sid  = enroll.stdid
	and		enroll.secid = section.secid
	and		subid		 = 'cs001'
			UNION
	select	student.sid, student.name 
	from	student, enroll, section
	where	student.sid  = enroll.stdid
	and		enroll.secid = section.secid
	and		subid		 = 'cs002'

--4. แสดงรหัสนิสิต และชื่อนิสิตของนิสิตที่เคยเรียนวิชา cs001 แต่ไม่เคยเรียน cs002
	select	student.sid, student.name 
	from	student, enroll, section
	where	student.sid  = enroll.stdid
	and		enroll.secid = section.secid
	and		subid		 = 'cs001'
			EXCEPT
	select	student.sid, student.name 
	from	student, enroll, section
	where	student.sid  = enroll.stdid
	and		enroll.secid = section.secid
	and		subid			= 'cs002'
	

--5. แสดง ชื่อ, สาขา ของอาจารย์ที่เคยสอนวิชา Database แต่ไม่เคยสอน OOP
	select  lecturer.name, lecturer.major
	from	lecturer, section, subject
	where   section.subid	= subject.sid
	and		lecturer.lid	= section.lecid
	and		subject.name	= 'Database'
			EXCEPT
	select  lecturer.name, lecturer.major
	from	lecturer, section, subject
	where   section.subid	= subject.sid
	and		lecturer.lid	= section.lecid
	and		subject.name	= 'OOP'
	

--6. แสดงรหัสและชื่ออาจารย์ที่เคยสอนวิชา Graphics หรือ เคยสอนในเทอม 3-2020  เรียงลำดับตามชื่ออาจารย์
	select  lecturer.lid, lecturer.name
	from    lecturer, section, subject
	where	section.lecid	= lecturer.lid
	and		section.subid	= subject.sid
	and		subject.name	= 'Graphics'
			UNION
	select   lecturer.lid, lecturer.name
	from     lecturer, section
	where	 section.lecid	= lecturer.lid
	and		 term			= '3-2020'
	Order by lecturer.name

--7. แสดงรหัสนิสิตที่เคยลงทะเบียนเรียน และไม่เคยติด F เลย 
	select  enroll.stdid
	from	enroll
		EXCEPT
	select  enroll.stdid
	from	enroll
	where	enroll.grade = 'F'

--8. แสดงข้อมูลของนิสิตที่เคยลงทะเบียนเรียน และไม่เคยติด F เลย 
	select  student.*
	from	Student, enroll
	where	student.sid = enroll.stdid
		EXCEPT
	select  student.*
	from	Student, enroll
	where	student.sid = enroll.stdid
	and		enroll.grade = 'F'
--9. แสดงข้อมูลของนิสิตสาขา CS ที่ไม่เคยเรียนวิชา Database เลย
	select  student.*
	from	Student
	where	student.major = 'CS'
		EXCEPT
	select  student.*
	from	Student, enroll, section, subject
	where	student.sid		= enroll.stdid
	and		enroll.secid	= section.secid
	and		section.subid	= subject.sid
	and		subject.name	='DATABASE'
--10. แสดงรหัสนิสิต และรหัสวิชาที่ลงทะเบียนเรียน ของนิสิตทุกคน รวมทั้งคนที่ไม่เคยลงทะเบียนเรียนเลย
		
--11. แสดงชื่ออาจารย์และเทอมที่สอน ของอาจารย์ทุกคน รวมทั้งอาจารย์ที่ไม่เคยสอนเลย

--12. แสดงชื่ออาจารย์ ชื่อวิชาที่สอน และเทอมที่สอน ของอาจารย์ทุกคน รวมทั้งอาจารย์ที่ไม่เคยสอนเลย

--13. แสดงชื่ออาจารย์ ชื่อวิชาที่สอน และเทอมที่สอน ของอาจารย์สาขา English ทุกคน รวมทั้งอาจารย์ที่ไม่เคยสอนเลย

--14. แสดงรหัสชื่อวิชา และชื่อวิชาที่เป็น  prerequisite ของวิชานั้น ๆ ถ้าวิชาใดไม่มี prerequisite ให้แสดง  prerequisite เป็น null


-----------------------------------------------------------
-------------------- Nested Join (slide p. 84) ------------
-----------------------------------------------------------

1. แสดงชื่อของอาจารย์ที่เคยสอนวิชา Programming
2. แสดงจำนวนอาจารย์ CS ที่เคยสอน Programming 
3. แสดงชื่อของอาจารย์ CS ที่ไม่เคยสอนวิชา Database
4. แสดงจำนวนครั้งที่มีการลงทะเบียนเรียนในเทอม 2-2020
5. แสดงจำนวนนิสิตที่ลงทะเบียนเรียนในเทอม 2-2020
6. แสดง รหัสอาจารย์และชื่อ ของอาจารย์ที่ไม่ได้สอนใน 1-2020
7. แสดง name, ปีเกิด, อายุ ของนิสิตที่อายุน้อยที่สุด (เปรียบเทียบถึงระดับวัน)
8. แสดง name, ปีเกิด, อายุ ของนิสิตที่อายุมากที่สุด ใน major CS (เปรียบเทียบถึงระดับวัน)
9. แสดง ข้อมูล ของนิสิตที่ได้ GPA สูงที่สุดในมหาวิทยาลัย
10. แสดง ข้อมูล ของนิสิตที่ได้ GPA สูงที่สุดใน major CS
11. แสดง ข้อมูล ของนิสิตที่เคยลงทะเบียนเรียน และไม่เคยติด F เลย
12. แสดงจำนวนวิชาที่มีวิชา Programming เป็น วิชา pre-requisite
13. แสดงรหัสวิชาและ ชื่อวิชา ที่ไม่เคยเปิดสอนเลย
14. แสดงข้อมูลของนิสิตที่ได้ gpa น้อยที่สุด และ  gpa สูงที่สุด
15. แสดง ชื่อ, ปีเกิด, อายุ ของนิสิตที่อายุน้อยที่สุด และอายุมากที่สุดใน major CS
16. แสดงข้อมูลของอาจารย์ cs ที่ได้เงินเดือนมากกว่าเงินเดือนฉลี่ยของอาจารย์ทุกคนในมหาวิทยาลัย


-----------------------------------------------------------
--------------Group by , having (slide p. 112) ------------
-----------------------------------------------------------
1. แสดง ชื่อmajor , gpa สูงสุดของ major นั้น ๆ และ gpa ต่ำสุดของ major นั้น ๆ
2. แสดง ชื่อmajor , gpa สูงสุดของ major นั้น ๆ และ gpa ต่ำสุดของ major นั้น ๆ โดยแสดงเฉพาะ major ที่มีค่า gpa ต่ำสุด มากกว่า 2.00
3. แสดง รหัสนิสิต, และจำนวนครั้งที่ลงเรียน 
4. แสดง รหัสนิสิต, และจำนวนครั้งที่ลงเรียน เฉพาะนิสิตที่อยู่ major CS
5. แสดง เกรด, จำนวนครั้งที่ได้เกรดนั้นๆ ของนิสิตรหัส 60001
6. แสดง รหัสนิสิต และ จำนวนครั้งที่ได้เกรด F ของนิสิตรหัสนั้น ๆ  
7. แสดง รหัสนิสิต และ จำนวนครั้งที่ได้เกรด F โดยแสดงเฉพาะนิสิตที่ได้เกรด F มากกว่า 1 ครั้ง
8. แสดงข้อมูลทุกอย่างของอาจารย์ที่เคยสอนมากกว่า 3 ครั้ง
9. แสดงข้อมูลทุกอย่างของอาจารย์ที่เคยสอนวิชา CS001 มากกว่า 1 ครั้ง
10. แสดงชื่อสาขา และ เงินเดือนเฉลี่ย ของอาจารย์ในสาขานั้น ๆ


------------------------------------
---- โจทย์เพิ่มเติม ฝึกทำ บางข้อก็ซ้ำๆบ้าง ----------
------------------------------------

1.	Join Statement
1.	แสดงรหัสนิสิต ที่เคยเรียนวิชา CS001
2.	แสดงรหัสนิสิต และชื่อนิสิตที่เคยเรียนวิชา CS001
3.	แสดงรหัสนิสิต และชื่อนิสิตที่เคยเรียนวิชา Programming
4.	แสดงรหัสนิสิต และชื่อนิสิตที่เคยเรียนกับอาจารย์ชื่อ Peter Parker
5.	แสดงรหัสนิสิตที่ได้เกรด A วิชา Programming
6.	แสดงรหัสนิสิต และชื่อนิสิต ที่ได้เกรด A วิชา Programming
7.	แสดงรหัสนิสิต ชื่อนิสิต และเกรดที่ได้ ของนิสิตที่เรียน section id 6 
8.	แสดงรหัสนิสิต ชื่อนิสิต และเกรดที่ได้ ของนิสิตที่เรียนวิชา CS005 ในเทอม 1-2020
9.	แสดงรหัสนิสิต ชื่อนิสิต และเกรดที่ได้ ของนิสิตที่เรียนวิชา Graphics ในเทอม 1-2020
10.	แสดงรหัสนิสิต และชื่อนิสิตของนิสิตที่เคยเรียนวิชา cs001  หรือ cs002
11.	แสดงรหัสวิชา และชื่อวิชาที่เป็น pre-requisite ของวิชารหัส cs009
12.	แสดงรหัสวิชา และชื่อวิชาที่เป็น pre-requisite ของวิชา Project
13.	แสดงชื่อวิชาและเทอมที่เปิดสอน เรียงลำดับตามเทอม
14.	แสดงชื่อวิชา ชื่ออาจารย์ และเทอมที่เปิดสอน
15.	แสดงวิชา , เทอมที่เรียน ,อาจารย์ผู้สอน และเกรดที่ได้ ของนิสิตชื่อ Avril
16.	แสดงชื่อวิชา, เทอมที่สอน, ชื่อผู้สอน ของทุกวิชาที่สอนโดยอาจารย์ใน major CS
17.	แสดง รหัสนิสิต, ชื่อนิสิต, ชื่อวิชา, ชื่อผู้สอน, เทอมที่เรียน ของการเรียนที่ได้เกรด F
18.	แสดง รหัสนิสิต, ชื่อนิสิต, ชื่อวิชา, เทอมที่เรียน ของนิสิตที่ได้ F วิชาที่สอนโดยอาจารย์ Steve Roger 
โดยเรียงลำดับตามรหัสนิสิต

 
2.	Nested Join Statement
1.	แสดงชื่อของอาจารย์ที่เคยสอนวิชา Programming
2.	แสดงจำนวนอาจารย์ภาควิชา CS ที่เคยสอน Programming
3.	แสดงชื่อของอาจารย์ภาควิชา CS ที่ไม่เคยสอนวิชา Programming
4.	แสดงจำนวนครั้งที่ลงทะเบียนเรียนในเทอม 2-2010
5.	แสดงจำนวนนิสิตที่ลงทะเบียนเรียนในเทอม 2-2010 (จากข้อ c. ให้นับเฉพาะจำนวนนิสิต )
6.	แสดง รหัสอาจารย์และชื่อ ของอาจารย์ที่สอนในภาคเรียน 1-2020
7.	แสดง รหัสอาจารย์และชื่อ ของอาจารย์ที่ไม่ได้สอนในภาคเรียน 1-2020
8.	แสดง name, ปีเกิด, อายุ ของนิสิตที่อายุน้อยที่สุด
9.	แสดง name, ปีเกิด, อายุ ของนิสิตที่อายุมากที่สุด ใน major CS
10.	แสดง ข้อมูล ของนิสิตที่ได้ GPA สูงที่สุดในมหาวิทยาลัย
11.	แสดง ข้อมูล ของนิสิตที่ได้ GPA สูงที่สุดใน major CS
12.	แสดง ข้อมูล ของนิสิตที่ได้ GPA สูงที่สุดใน major Thai
13.	แสดง ข้อมูล ของนิสิตที่เคยลงทะเบียนเรียน และไม่เคยติด F เลย
14.	แสดงจำนวนวิชาที่มีวิชา Programming เป็น วิชา pre-requisite
15.	แสดงรหัสวิชาและ ชื่อวิชา ที่ไม่เคยเปิดสอนเลย
3.	Outer Join
1.	แสดงชื่ออาจารย์และเทอมที่สอน ของอาจารย์ทุกคน รวมทั้งอาจารย์ที่ไม่เคยสอนเลย
2.	แสดงชื่ออาจารย์ ชื่อวิชาที่สอน และเทอมที่สอน ของอาจารย์ทุกคน รวมทั้งอาจารย์ที่ไม่เคยสอนเลย
3.	แสดงรหัสนิสิต และรหัสวิชาที่ลงทะเบียนเรียน ของนิสิตทุกคน รวมทั้งคนที่ไม่เคยลงทะเบียนเรียนเลย
4.	แสดงรหัสนิสิต รหัสวิชาและเทอมที่ลงทะเบียนเรียน ของนิสิตทุกคน รวมทั้งคนที่ไม่เคยลงทะเบียนเรียนเลย

4.	INTERSECT, EXCEPT,  UNION, EXISTS
1.	แสดงรหัสนิสิต และชื่อนิสิตของนิสิตที่เคยเรียนทั้งวิชา cs001  และ cs002 
2.	แสดงรหัสนิสิต และชื่อนิสิตของนิสิตที่เคยเรียนวิชา cs001 แต่ไม่เคยเรียน cs002
3.	แสดง ชื่อ, สาขา ของอาจารย์ที่สอนในเทอม 1-2020 แต่ไมได้สอนเทอม 2-2020
4.	แสดงรหัสและชื่ออาจารย์ที่สอนวิชา Programming แต่ไม่เคยสอน Programming2
5.	แสดงรหัสและชื่อนิสิตที่เคยเรียน Programming แต่ไม่เคยเรียน Graphics
6.	แสดง ชื่อ, ปีเกิด, อายุ ของนิสิตที่อายุน้อยที่สุด และอายุมากที่สุด
7.	แสดง ชื่อ, ปีเกิด, อายุ ของนิสิตที่อายุน้อยที่สุด และอายุมากที่สุดใน major CS
8.	แสดงข้อมูลของนิสิตที่เคยลงทะเบียนเรียน และไม่เคยติด F เลย 
9.	แสดงข้อมูลของนิสิตสาขา CS ที่ไม่เคยเรียนวิชา Programming เลย

10.	ANY, ALL
1.	แสดงข้อมูล ของนิสิตทุกคนที่มี gpa มากกว่า นิสิต บางคน ใน major CS
2.	ข้อมูลข้อมูล ของนิสิตทุกคนที่ไม่ได้อยู่ major CS และมี gpa มากกว่า นิสิตใน major CS
3.	แสดง ข้อมูล ของนิสิตทุกคนที่มี gpa มากกว่า นิสิต ทุกคน ใน major CS
4.	แสดง ข้อมูล ของนิสิตทุกคนที่มี gpa มากกว่า average gpa ของนิสิตทุกคน
5.	แสดง ข้อมูล ของนิสิต CS ทุกคนที่มี gpa น้อยกว่า gpa ของ นิสิต PY บางคน


11.	Group by , Having
1.	แสดง ชื่อmajor , gpa สูงสุดของ major นั้นๆ และ gpa ต่ำสุดของ major นั้นๆ 
โดยไม่ต้องแสดงข้อมูลที่ major เป็น null

ตัวอย่างการแสดงผล
major		Max_GPA			Min_GPA
Architecture	3.55		1.99
Art				3.98		3.05
CS				3.98		1.25
English			3.00		3.00
MA				1.25		1.25




2.	แสดง ชื่อmajor , gpa สูงสุดของ major นั้นๆ และ gpa ต่ำสุดของ major นั้นๆ 
โดยแสดงเฉพาะ major ที่มีค่า gpa ต่ำสุด มากกว่า 2.00
ตัวอย่างการแสดงผล
major		Max_GPA	Min_GPA
Art			3.98		3.05
English		3.00		3.00
PY			3.50		2.78
Thai		2.78		2.78

3.	แสดง รหัสนิสิต, และจำนวนครั้งที่ลงเรียน 

4.	แสดง รหัสนิสิต, และจำนวนครั้งที่ลงเรียน เฉพาะนิสิตที่อยู่ major CS
ตัวอย่างการแสดงผล
stdid		Amount
50001		5
50002		4
50003		4
50004		2

5.	แสดง เกรด, จำนวนครั้งที่ได้เกรดนั้นๆ ของนิสิตรหัส 60001	
ตัวอย่างการแสดงผล
grade		Amount
A			3
B			1

6.	แสดง รหัสนิสิต และ จำนวนครั้งที่ได้เกรด F ของนิสิตรหัสนั้นๆ  
7.	แสดง รหัสนิสิต และ จำนวนครั้งที่ได้เกรด F โดยแสดงเฉพาะนิสิตที่ได้เกรด F มากกว่า 1 ครั้ง
ตัวอย่างการแสดงผล
stdid		Amount
50006		2

8.	แสดงรหัสวิชา และจำนวนเทอมที่สอน เฉพาะวิชาที่สอนโดยอาจารย์รหัส t05
ตัวอย่างการแสดงผล
	subid		Amount
	CS001		1
CS007		2
9.	แสดงข้อมูลทุกอย่างของอาจารย์ที่เคยสอนมากกว่า 3 ครั้ง
ตัวอย่างการแสดงผล
	lid	name	salary	major
	t01	Depp	40000	ComputerScience
	t02	Angy	40000	ComputerScience

10.	แสดงข้อมูลทุกอย่างของอาจารย์ที่เคยสอนวิชา CS005 มากกว่า 1 ครั้ง
ตัวอย่างการแสดงผล
	lid	name	salary	major
	t01	Depp	40000	ComputerScience

11.	แสดงรหัสอาจารย์ เทอมที่สอน และจำนวนวิชาที่สอนในเทอมนั้น
เฉพาะที่ข้อมูลที่สอนมากกว่า 1 วิชาในเทอมนั้น โดยเรียงลำดับตามรหัสอาจารย์
ตัวอย่างการแสดงผล
lecid	term		Amount
t01	1-2020		3
t01	1-2021		2
t01	2-2020		3
t02	1-2020		2
t02	1-2021		2
t03	2-2021		2
t05	2-2021		2
t06	1-2021		2
t08	2-2022		2

12.	แสดงชื่อสาขา และ เงินเดือนรวมของอาจารย์ในสาขานั้นๆ

ตัวอย่างการแสดงผล
major		Sum
Architecture	37000
CS				165000
English			150000
Math			65000