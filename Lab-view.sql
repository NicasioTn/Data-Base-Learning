--Lab view
-- 63011212098


select * from level
select * from customer
select * from employee
select * from RIDER
select * from food
select * from iORDER
select * from iDetail
--6 point
create view cByYear(year, cid, stotal) as
	(select	year(date), iOrder.cid, sum(amount*price) as stotal
	from	iOrder, iDetail, Food
	where	iOrder.oid = iDetail.oid
	and		iDetail.fid = Food.fid
	group	by year(date), iOrder.cid)

select * from cByYear
--ข้อ 1
select	year, name , stotal
from	cByYear, customer
where	customer.cid = cByYear.cid
--ข้อ 2
select		name, stotal
from		cByYear, customer
where		customer.cid = cByYear.cid
and			stotal =
		(select		max(stotal)
		from		cByYear
		where		year = '2020')

-- 4 point
create view TypePrice(type, mprice) as
	(select	type, max(price)
	from	food
	group by type)

select		* from TypePrice
select		food.name, food.type, price
from		food, TypePrice
where		food.type = TypePrice.type
and			price = mprice
order by	price desc

-- 5 point

create view RiderWork(rid, trip, atime, areview) as
	(select		rid, count(*), avg(datediff(MINUTE, start_time, finish_time)), avg(review)
	from		iOrder
	where		rid is not null
	group by	rid)

select * from RiderWork

select  name, trip, atime, areview
from	Rider, RiderWork
where	Rider.rid = RiderWork.rid
and		areview =
		(select max(areview)
		from	RiderWork)


create view RiderReview(rid, year, a_review)
as
	(select		rid, year(date), Avg(review)
	from		iOrder
	where		rid is not null
	group by	rid, year(date))

select * from RiderReview
-- procedure
create procedure pro_RiderReview
		@year		varchar(4)
as
	select		RiderReview.rid, name, a_review
	from		RiderReview, Rider
	where		Rider.rid = RiderReview.rid
	and			year = @year		
	order by	       a_review desc

exec pro_RiderReview '2020'
exec pro_RiderReview '2021'
drop procedure pro_RiderReview