
---  Practice Before mid term Test -----

select * from Level

select * from Employee
select * from Rider
select * from Customer
select * from Food
select * from iOrder
select * from iDetail

--- Select All Teble for Check Data ---

/* 	   Status
	0. ทำการสั่งซื้อ 
	1. กำลังทำอาหาร 
	2. Rider กำลังส่ง 
	3. ส่งเรียบร้อย
*/

-- แสดงรหัสrider, ชื่อrider, รหัสพนักงานที่แนะนำให้เข้าทำงาน โดยแสดงเฉพาะ rider ที่มีพนักงานแนะนำเข้ามา
select	rid, name, suggest
from	Rider
where	suggest is not null

-- แสดงรหัส ชื่อ และปีเกิด ของ rider ทุกคนที่อายุมากกว่า 35 ปี (แสดงเฉพาะปีเกิด ไม่ใช่วัน-เดือน-ปี เกิด)
select    fid,name,price
from    food
where    name like '%cake%'


--แสดงชื่อ ราคา และประเภทสินค้า โดยแสดงเฉพาะ สินค้าประเภท sweet หรือ icecream เท่านั้น
select    name,type,price
from    FOOD
where    type in ('sweet','icecream')

 -- แสดงข้อมูล เมื่อ status เท่ากับ 3 และ คะแนนรีวิว มากกว่า 2
 select *
 from iOrder
 where status = 3
	INTERSECT
 select *
 from iOrder
 where review > 2

select		Customer.name
from		Customer, iOrder
where		Customer.cid = iOrder.cid
and			start_time is not null
	INTERSECT
select		Customer.name
from		Customer, iOrder
where		Customer.cid = iOrder.cid
and			finish_time is not null

-- แสดง ชื่อพนักงาน เมื่อ พนักงานคนนั้นมีหัวหน้ามากกว่า 1 คน ขึ้นไป
select		Employee.name, count(manager) as 'Head'
from		Employee
group by	manager, name
having		count(manager) > 0

-- แสดง ชื่อ เบอร์ และ เลข ออเดอร์ ที่ยังส่งไม่เสร็จ
select		Customer.name, Customer.phone, iOrder.oid
from		Customer, iOrder
where		Customer.cid = iORDER.cid
and			finish_time is null


select   name, type, price
from	 FOOD
where    type in ('sweet','icecream')

--แสดงรหัส ชื่อ และเบอร์โทรของลูกค้าทุกคนที่อยู่ระดับ l3 และไม่มีข้อมูลเบอร์โทร
select    cid,name,phone
from    customer
where    level = 'l3' 
and        phone is null

--เปลี่ยนราคาสินค้าโดยถ้าเป็นสินค้าประเภท
--drink        เพิ่มราคาขึ้น    30%
--sweet        เพิ่มราคาขึ้น    10%
--icecream    ลดราคาลง        20%
--สินค้าประเภทอื่นๆไม่ต้องเปลี่ยนแปลงราคา
UPDATE        FOOD
SET        price    =    case    type
WHEN    'drink'        THEN    price+price*0.3
WHEN    'sweet'        THEN    price+price*0.1
WHEN    'icecream'    THEN    price-price*0.2
ELSE                price
END


SELECT    oid,review,CAST( case
WHEN    review    =    1    THEN    'BAD'
WHEN    review    =    2    THEN    'NOT BAD'
WHEN    review    =    3    THEN    'OK'
END
AS    varchar(15))as COMMENT
FROM    iORDER
WHERE    review <=    3

select    oid, review, cast( case
when     review    =    1    THEN    'bad'
when     review    =    2    THEN    'NOT BAD'
when     review    =    3    THEN    'OK'
end        as    varchar(15)) as COMMENT
from      iOrder
where    review <=    3

--แสดงเงินเดือนต่ำสุด เงินเดือนสูงสุด และเงินเดือนเฉลี่ยของพนักงานตำแหน่ง waitress
select    max(salary) as 'Max', min(salary) as 'Min', avg(salary) as 'Average'
from    EMPLOYEE
where    position = 'waitress'

Update        Food
SET               price    =    case    type
When          'drink'           THEN    price + price * 0.3
When          'sweet'          THEN    price + price * 0.1
When          'icecream'    THEN    price-price*0.2
else             price
end

 select     rid, name, year(birthday) as 'Years'
 from       Rider
 where      datediff( year, birthday, getdate()) > 35

--แสดงชื่อ และเบอร์โทร ของลูกค้า ที่อยู่ระดับ l3 และมียอดซื้อสะสมมากกว่า 3000 บาท
select    name,phone
from    CUSTOMER
where    level    =    'l3'
and        total    >    3000

select    name, type, price
from      FOOD
where    type in ('sweet', 'icecream')

select * from Rider
select * from Customer

select * from iOrder
select * from Employee

-- แสดงชื่อ Rider ที่เคยส่งอาหารให้กับ ลูกค้า ชื่อ Peter
select		Rider.name
from		Rider
where		rid IN
	(Select		rid
	from		iOrder
	where		cid IN
		(select		cid
		from		Customer
		where		name = 'cake'))


--แสดงชื่อลูกค้าที่เคยสั่งซื้อสินค้าที่ราคาแพงที่สุดในร้าน (เช่นถ้าสินค้าราคาแพงที่สุดคือ champagne ให้แสดงชื่อลูกค้าที่เคยสั่งซื้อ champagne)
select    name
from    CUSTOMER
where    cid in
        (select    cid
         from    iorder
         where    oid in
                (select    oid
                 from    iDetail
                 where    fid in
                        (select    fid
                         from    FOOD
                         where    price = 
                                (select max(price)
                                 from    FOOD))))

-- แสดงชื่อ rider ที่ไม่เคยส่งสินค้าชื่อ cake เลย
select		Rider.name
from		Rider
where		rid IN
	(Select		rid
	from		iOrder
	where		fid IN
		(select		fid
		from		Food
		where		name = 'cake'))

-- แสดงชื่อ พนักงานที่แนะนำ Rider มาทำงาน		
select	Employee.name
from	Employee
where	eid IN
	(select		eid
	from		Rider
	where		Rider.suggest is not null)

-- แสดง ชื่อ ลูกค้าที่เคยสั่ง Beer
select		Customer.name
from		Customer
where		cid IN
	(select		cid
	from		iOrder
	where		oid IN
		(select		oid
		from		iDetail
		where		fid	IN
			(select		fid
			from		food
			where		name = 'Beer')))

-- แสดงชื่อ ลูกค้าที่ไม่เคยสั่งอาหาร
select	Customer.name
from	Customer
where	cid not IN
	(select		cid
	from		iOrder)

select sid, name, major
from  STUDENT
where name like 'A%'


select		name , count(cid)
from		Customer

select		name, phone
from		Customer
where		substring(phone, 0, 3) = '08' -- Column + st + end (index)

select		Customer.name, total
from		Customer
where		total between 500 and 7000

select		name, price, type
from		food
where		price > 0
order by	price desc

--  แสดงชื่อ และ ไอดี ของลูกค้าทั้งหมด ที่ไม่เคยสั่งอาหาร
select	Distinct Customer.name, Customer.cid
from	Customer left outer join iOrder
on		Customer.cid =	iOrder.cid
where	oid is null

select	Distinct name, cid
from	Customer	


-- แสดงชื่อ rider ที่ไม่เคยส่งสินค้าชื่อ cake เลย
select    *
from      iOrder
select    *
from      iDetail
select	  *
from	  Rider


select    name
from      Rider
where     rid not in
	(select   rid
	from	  iOrder
	where	  oid  in
		(select   oid
		from	  iDetail
		where	  fid in
			(select fid
			from	Food
			where	name = 'Cake')))

		--แสดงรหัส และชื่อrider ที่พนักงานชื่อ Blue แนะนำให้เข้าทำงาน (1 คะแนน)
select     rid, name
from       Rider
where      suggest in
        (select     eid
        from        Employee
        where       name = 'Blue')

		--แสดงรหัส ชื่อสินค้า และราคาของสินค้าประเภท sweet ที่ราคาแพงที่สุด
select    fid,name
from    FOOD
where    type    = 'sweet'
and        price    in
        (select    max(price)
         from    FOOD
         where    type    = 'sweet')

--แสดงรหัส และชื่อของพนักงานทุกคน ที่เป็นลูกน้องของพนักงานชื่อ Blue (1 คะแนน)
select *
from EMPLOYEE

select	Distinct E2.eid, E2.name
from	Employee E1, Employee E2
where	E1.manager = E2.eid 
and		E2.name = 'Blue'

--แสดงรหัสสินค้า และจำนวนที่ขายได้ทั้งหมด โดยแสดงเฉพาะสินค้าที่ขายได้เกิน 3 ชิ้น
select      fid, sum(amount) as จำนวนที่ขายได้ทั้งหมด
from        iDetail
group by    fid
having      sum(amount) > 3

--แสดงรหัส และชื่อสินค้า ที่ไม่เคยถูกสั่งซื้อเลย
select    fid, name
from      Food
where     fid not in
      (select    fid
       from      iDetail)

--แสดงชื่อสินค้า และจำนวนสินค้า ของออเดอร์รหัส 13 (1 คะแนน)
select		Food.name, iDetail.amount
from		Food,iDetail
where		Food.fid	=    iDetail.fid
and         iDetail.oid    =    '13'


--รุป
select   Employee.name as 'emlpoyee name',Rider.name as 'rider name'
from     Employee
left     outer join Rider
on       Employee.eid = rider.suggest

--แสดงรหัสสินค้า และจำนวนที่ขายได้ทั้งหมด โดยแสดงเฉพาะสินค้าประเภท sweet
--แสดงรหัสสินค้า และจำนวนที่ขายได้ทั้งหมด โดยแสดงเฉพาะสินค้าประเภท sweet
select	   fid, sum(amount) as ยอดขายได้ทั้งหมด
from       iDetail
where      fid  IN
		(select    fid
         from      Food
         where     type    =    'sweet')
group by fid


--แสดงชื่อrider ที่เคยส่งสินค้าให้ลูกค้าที่ชื่อ Sam และ Edward (เคยส่งให้ทั้ง 2 คน)
select    name
from    RIDER
where   rid in
        (select    rid
         from    iORDER
         where    cid in 
                (select    cid
                 from    CUSTOMER
                 where    name = 'Sam'))
INTERSECT
select    name
from    RIDER
where   rid in
        (select    rid
         from    iORDER
         where    cid in 
                (select    cid
                 from    CUSTOMER
                 where    name = 'Edward'))


--แสดงชื่อลูกค้าที่เคยสั่งซื้อสินค้าที่ราคาแพงที่สุดในร้าน (เช่นถ้าสินค้าราคาแพงที่สุดคือ champagne ให้แสดงชื่อลูกค้าที่เคยสั่งซื้อ champagne)
select    name
from    CUSTOMER
where    cid in
        (select    cid
         from    iorder
         where    oid in
                (select    oid
                 from    iDetail
                 where    fid in
                        (select    fid
                         from    FOOD
                         where    price = 
                                (select max(price)
                                 from    FOOD))))

--แสดงชื่อrider ที่เคยส่งสินค้าให้ลูกค้าที่ชื่อ Sam และ Edward (เคยส่งให้ทั้ง 2 คน)
select    name
from	  Rider
where     rid in
        (select    rid
         from      iORDER
         where     cid in 
                (select    cid
                 from      Customer
                 where    name = 'Sam'))
INTERSECT
select    name
from      Rider
where     rid in
        (select    rid
         from      iORDER
         where     cid in 
                (select    cid
                 from      Customer
                 where     name = 'Edward'))

select        rid, name
from          Rider
where         suggest in
        (select        eid
        from           Employee
        where          name = 'Blue')


---แสดงรหัสลูกค้า และจำนวนครั้งที่เคยออเดอร์ โดยแสดงเฉพาะลูกค้าที่มียอดซื้อรวมมากกว่า 3000 บาท และเคยออเดอร์มากกว่า 3 ครั้ง

select        Customer.cid, count(iOrder.oid) as จำนวนครั้งที่เคยออเดอร์
from          Customer, iOrder
where         Customer.cid = iOrder.cid
and           Customer.total > 3000
group by      Customer.cid
INTERSECT
select        Customer.cid,count(iOrder.oid) as จำนวนครั้งที่เคยออเดอร์
from          Customer,iORDER
where         Customer.cid = iOrder.cid
group by      Customer.cid
having        count(iOrder.oid) > 3


select     Employee.name as 'Employee name', Rider.name as 'Rider name'
from       Employee
left          outer join Rider
on           Employee.eid = Rider.suggest

select       name
from	  Rider
where       rid in
        (select    rid
         from       iOrder
         where     cid in 
                (select    cid
                 from      Customer
                 where    name = 'Sam'))
INTERSECT
select     name
from       Rider
where     rid in
        (select    rid
         from       iOrder
         where     cid in 
                (select    cid
                 from       Customer
                 where     name = 'Edward'))



				 select           Customer.cid, count(iOrder.oid) as จำนวนครั้งที่เคยออเดอร์
from             Customer, iOrder
where           Customer.cid = iOrder.cid
and               Customer.total > 3000
group by      Customer.cid
INTERSECT
select          Customer.cid,count(iOrder.oid) as จำนวนครั้งที่เคยออเดอร์
from            Customer,iORDER
where          Customer.cid = iOrder.cid
group by     Customer.cid
having         count(iOrder.oid) > 3

select    name
from      Customer
where    cid in
        (select    cid
         from       iOrder
         where     oid in
                (select    oid
                 from       iDetail
                 where     fid in
                        (select    fid
                         from       FOOD
                         where     price = 
                                (select max(price)
                                 from    Food))))


								 select		Food.name, iDetail.amount
from		Food, iDetail
where		Food.fid	 =   iDetail.fid
and                iDetail.oid    =    '13'