select *
from iOrder


-- ข้อ 1 

select	oid, datediff( minute,start_time, finish_time) as period
from	iOrder
where	start_time is not null
and		finish_time is not null	

-- ข้อ 2
select	Employee.name, Rider.name,
			datediff( minute,start_time, finish_time) as period
from	iOrder, Employee, Rider
where	Employee.eid	= iOrder.eid
and		iOrder.rid		= Rider.rid
and     datediff(minute,start_time,finish_time) =
            (select		max(datediff(minute,start_time,finish_time))
             from		iOrder)

-- ข้อ 3
select       iorder.Order_day as Date, count(iDetail.amount) as Amount
from         iORDER, iDetail
where        iORDER.oid = iDetail.oid
group by     iorder.Order_day

-- ข้อ 4
select * from iDetail
select * from iOrder

select      datename(Month, Order_day) as Month , count(iDetail.amount) as Amount
from		iOrder, iDetail
where		iOrder.oid = iDetail.oid
group by    iOrder.Order_day
having      year(Order_day) = 2021



-- ข้อ 5
select		rid, Avg(review) as คะแนนเฉลี่ย
from		iOrder
where		rid is not null
group by	rid

select	oid, datediff( minute,start_time, finish_time) as period
from	iOrder
where	start_time is not null
and		finish_time is not null	


