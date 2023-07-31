---- สอบย่อย View ----

--มีนักเรียนกี่คนในแต่ละสาขา
select * from student
-- cs4, py3, art2 ,thai 1
select major , count(*) as amount
from student 
where major is not null
group by major
order by   count(*) desc

create view major_count(major, amount) as
	(select major, count(*)
	from	student
	where	major is not null
	group by major)

drop view major_count
select * from major_count

-- นับจำนวนเมนู
create view FoodType(type, amount) as
	(select type, count(*)
	from	FOOD
	where	type is not null
	group by type)

drop view FoodType
select * from FoodType

select * from iOrder iDetail

create view FoodSold(fid, tamount) as
	(select fid, sum(amount)
	from iDetail
	group by fid)

drop view FoodSold
select * from FoodSold
select * from iDetail
select * from Food where type = 'drink'
-- 2.1
select		Food.name, tamount, sum(price*tamount) as total
from		Food, FoodSold
where		Food.fid = FoodSold.fid
and			type = 'drink'
group by	Food.name, tamount

select		Food.name, tamount, price*tamount as total
from		Food, FoodSold
where		Food.fid = FoodSold.fid
and			type = 'drink'
-- 2.2
select	Food.fid, Food.name , price, type
from	Food, FoodSold
where	Food.fid = FoodSold.fid
and		tamount = 
	(select Max(tamount)
	from	FoodSold)
	
--3
create view EmpRider(eid, r_amount) as
		(select	eid, count(suggest)
		from	Employee, Rider
		where	Employee.eid = Rider.suggest
		group
		by		eid)

-- อาจารย์เฉลย
create view EmpRider(eid, r_amount) as
	(select		suggest, count(*)
	from		rider
	where		suggest is not null
	group by	suggest)

drop view EmpRider
select * from Employee
select * from Rider
select * from EmpRider

--3.1
select	Employee.eid, Employee.name, r_amount
from	Employee, EmpRider
where	EMPLOYEE.eid = EmpRider.eid

--3.2
select	rid, name, birthday, gender, phone, suggest
from	Rider
where	suggest = 
		(select		eid
		from		EmpRider
		where		r_amount = 
			(select		Max(r_amount)
			from		EmpRider))

select	Rider.*
from	Rider, empRider
where	Rider.suggest = empRider.suggest
and		r_amount = 
	(select		Max(r_amount)
	from		EmpRider)

-- 4
select * from iOrder
select * from iDetail

/*create view cOrder(cid, year, amount) as
	(select	cid, year(Order_day),count(amount)
	from	iOrder, iDetail
	where	iOrder.oid = iDetail.oid
	group
	by		cid, Order_day)
*/
drop view cOrder
select * from cOrder

-- เฉลย
create view cOrder(cid, year, amount) as
	(select		cid, year(date),count(*)
	from		iOrder
	group by	cid , year(date))

select * from cOrder

--4.1
select	cOrder.cid, Customer.name, amount
from	cOrder, Customer
where	cOrder.cid = Customer.cid
and		year = '2021'

-- ผู้จักการแต่ละคนมีลูกน้องกี่คน
create view xxx(manager, ลูกน้อง) as
	( select		manager, count(*)
	from		employee
	where		manager is not null
	group by	manager)


select * from xxx

-- ชื่อพนักงานที่มีลูกน้องมากที่สุด
select	employee.name, ลูกน้อง
from	xxx, employee
where	EMPLOYEE.eid = xxx.manager
and		ลูกน้อง =
	(select		Max(ลูกน้อง)
	from		xxx)
