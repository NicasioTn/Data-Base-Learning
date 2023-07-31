---Final

select * from Rider
select * from iOrder
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
	order by	a_review desc

exec pro_RiderReview '2020'
exec pro_RiderReview '2021'
drop procedure pro_RiderReview


-- Q2
-- no view use only table and procedure
create table RiderBonus(
	year		varchar(4),
	rid			varchar(10),
	trip		int,
	bonus		int
)

select * from RiderBonus
-- procedure
create procedure Give_Bonus_To_Riderja
		@year_Curent		varchar(4)
as
	declare
		@rid		varchar(10),
		@trip		int

	--- cursor
	declare	
		BoBonus_Cur cursor for select		rid, count(*)
							   from			iOrder
							   where		year(date) = @year_Curent
							   and			rid is not null
							   group	by	rid, year(date)

	open BoBonus_Cur
	fetch next from BoBonus_Cur into @rid, @trip

	while (@@fetch_status = 0)
	begin
		if(@trip between 1 and 3)
		begin
			insert into RiderBonus values(@year_Curent, @rid, @trip,1000)
		end
		else if(@trip between 4 and 10)
		begin
			insert into RiderBonus values(@year_Curent, @rid, @trip, 3000)
		end
		else if(@trip > 10)
		begin
			insert into RiderBonus values(@year_Curent, @rid, @trip, @trip*300)
		end
		else
			print 'No action'
		
		fetch next from BoBonus_Cur into @rid, @trip -- i++
	end

	close BoBonus_Cur
	deallocate BoBonus_Cur

	-- display
	select * from RiderBonus

exec Give_Bonus_To_Riderja '2020'
exec Give_Bonus_To_Riderja '2021'
drop procedure Give_Bonus_To_Riderja
	
	
select * from iOrder
-- Q3
 
create trigger Dont_do_it_Rider on iOrder
for	insert as 
	declare 
		@rid		varchar(5),
		@trip		int,
		@time		date
	select		@rid = rid from inserted
	select		@time = date from inserted
	select		@trip = count(*)
	from		iOrder
	where		rid = @rid
	and			date = @time

if(@trip >= 3)
begin
	print @rid + 'Drive more then 3 time per day!!'
	rollback
end

drop trigger  Dont_do_it_Rider 
insert into iORDER values('c01', 'e01',	'r01', '18-sep-2021',	'15:00', '15:30', '3', 5)

-- test
select *	from iOrder
select		rid,date,count(*)
from		iOrder
where		rid is not null
group by	rid ,date


-- Q4
Create table FoodHistory(
		fid			varchar(10),
		xdata		varchar(50),
		newdata		varchar(50),
		detail		varchar(20),
		date		date
)
select * from FoodHistory
drop table FoodHistory

create trigger Change_date_about_Food on food
for update as
	declare
		@fid			varchar(10),
		@olddata		varchar(50),
		@newdata		varchar(50),
		@typeChange		varchar(20),
		@datetime		date

		select @fid = fid from deleted

		if update(name) -- name
		begin
			select @olddata = name from deleted where fid = @fid
			select @newdata = name from inserted where fid = @fid
			select @typeChange = 'name'
		end
		else if update(price) -- price
		begin
			select @olddata = price from deleted where fid = @fid
			select @newdata = price from inserted where fid = @fid
			select @typeChange = 'price'
		end

		select @datetime = getdate() from inserted where fid = @fid

		insert into FoodHistory values(@fid, @olddata, @newdata, @typeChange, @datetime)
		--end trigger
		
		

drop trigger Change_date_about_Food
update  food
set		name = '20+'
where	name = 'beer'

update  food
set		price = '60'
where	price = '100'

select * from FoodHistory

-- check all data in food
select * from food
select * from iDetail
select * from iORDER
select * from FOOD
select * from RIDER
select * from EMPLOYEE
select * from CUSTOMER
select * from LEVEL

-- Q6
create trigger  Beyond_exam on iDetail
for insert as
	declare
		@lid    varchar(10),
		@name	varchar(50),
		@rate	int
	declare
		level_cur cursor for select lid, name, rate from deleted
		open level_cur
			fetch next from level_cur into @lid, @name, @rate
			while (@@fetch_status = 0)
				fetch next from level_cur into @lid, @name, @rate
				
		close food_cur
	deallocate food_cur
-- Q6
create trigger Beyond_exam on iDetail
for insert as
	declare
		@lid		varchar(10),
		@cid		varchar(10),
		@price		int,
		@rate		int,
		@total		int

	select			@cid = cid 
			from	inserted, iOrder 
			where	inserted.oid = iOrder.oid
	select				@price = sum(amount*price)  
			from		inserted, food
			where		inserted.fid = food.fid		
			group by	oid

	update		customer
	set			total = total + @price
	where		cid = @cid
	select		@total = total 
		from	customer
		where	cid = @cid
	
	declare 
		Up_cur cursor for select  lid ,rate from level 
		open Up_cur
			fetch next from Up_cur into @lid, @rate
			while(@@FETCH_STATUS=0)
			begin
				if(@total >= @rate)
				begin
					update		customer
					set			level = @lid
					where		cid = @cid
				end
				fetch next from Up_cur into @lid, @rate
			end
		close	Up_cur
	deallocate	Up_cur

drop trigger Beyond_exam
insert into iORDER values('c02', 'e02', 'r03', '18-sep-2021',  '15:00', '15:30', '4', 5)
-- select test output filnal
select * from level
select * from customer
select * from iDetail
