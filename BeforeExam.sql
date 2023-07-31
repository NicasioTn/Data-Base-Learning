-- เตรียมสอบ Final

select * from Level
select * from Food
select * from iOrder
select * from iDetail
select * from Employee
select * from Rider
select * from customer

Update  customer
set		level = 'l4'
where	cid = 'c03'

select  * from customer
where   cid = 'c03'

Update  customer
set		total = total + 500
where	cid = 'c03'

select  iOrder.oid, sum(amount*price) as 'ยอดรวม'
from    iOrder, Food, iDetail
where	iOrder.oid = iDetail.oid
and		iDetail.fid = Food.fid
group
by		iOrder.oid

select  iOrder.oid, customer.cid, sum(amount*price) as 'ยอดรวม'
from    iOrder, Food, iDetail, customer
where	iOrder.oid = iDetail.oid
and		iDetail.fid = Food.fid
and		iOrder.cid = customer.cid
group
by		iOrder.oid, customer.cid


select	rid, year(date) as 'year', count(*) as 'trip'
from	iOrder
where   rid is not null
group
by		rid, year(date)

select  date, rid, count(*) as 'amount'
from	iOrder
where	date is not null
and		rid is not null
group
by		date, rid

create table CustomerGift(
	year		date,
	cid			varchar(10),
	total_order	int,
	gift		varchar(30),
)
	select	cid, stotal
	from	cByYear
	where	year = '2020'
	and		stotal = 
		(select		max(stotal)
		from		cByYear
		where		year = '2020')

select * from cByYear

create procedure sp_check_customer_gift 
		@year		varchar(5),
		@gift		varchar(30)
as
declare
		@total		int,
		@cid		varchar
	select @total = max(stotal) from cByYear where	year = @year
	select @cid = cid 
				from cByYear 
				where	year = @year 
				and @total =  
					(select max(stotal)
					from cByYear 
					where year = @year)
	--
	select	year, cid, @total, @gift
	from	cByYear
	where	year = @year
	and		stotal = 
		(select		max(stotal)
		from		cByYear
		where		year = @year)
	insert into CustomerGift values (@year,@cid,@total,@gift)


exec	sp_check_customer_gift '2020','Banana'
exec	sp_check_customer_gift '2021','LongGong'

drop procedure sp_check_customer_gift

drop table CustomerGift

delete 
from	CustomerGift
where	total_order is null

create procedure student_name_in_major
		@major		varchar(10)
as
	select	sid, name, gpa, birthday
	from	student
	where	major = @major
	and		name is not null

drop procedure student_name_in_major
exec student_name_in_major 'py'

create procedure demo_inc_salary
	@major		varchar(10)
as
declare
	@Avg_lec	float
select	@Avg_lec = Avg(salary) from lecturer where major = @major
if(@Avg_lec < 40000)
begin
	update  lecturer
	set		salary = salary + (salary * 0.1)
	where	major = @major
end
else
begin
	update  lecturer
	set		salary = salary + (salary * 0.05)
	where	major = @major
end
-- display 
	select  lid, name, salary
	from	lecturer
	where	major = @major

drop procedure demo_inc_salary
exec demo_inc_salary 'English' 

select * from customer


create view GOOD_CTM(cid, total)as
		(select cid, total
		from	customer
		where	total = 
			(select		max(total)
			from		customer))

drop view GOOD_CTM
select * from GOOD_CTM

create view Cus_AmountOrder(cid, name, amount)as
		(select		customer.cid, name, count(*) 
		from		customer, iOrder, iDetail
		where		customer.cid = iOrder.cid
		and			iOrder.oid = iDetail.oid
		group
		by			customer.cid, name)

drop view Cus_AmountOrder
select * from Cus_AmountOrder

create view Emp_Avg(eid, name, Max_Avg_salary )as
		(select		eid, name , Max(salary)
		from		employee
		group
		by			eid, name
		having		Max(salary) = 
			(select		Avg(salary)
			from		employee))

drop view Emp_Avg
select * from Emp_Avg

select * from employee

create procedure pro_search_Emp
		@many		int,
		@money		int
as
	if(@many <= 5)
	begin
		Update	employee
		set		salary = salary + (salary * 0.5)
		where	salary = @money
	end
	else
		print 'เกินจำนวน'

drop procedure pro_search_Emp
exec pro_search_Emp 4, 30000
select * from employee


create procedure msp_young_student
		@xx		int,
		@yy		int
as
	select	sid, name, major, datediff(year,birthday,getdate())
	from	student
	where	name is not null
	and		datediff(year,birthday,getdate()) between @xx and @yy

drop procedure msp_young_student
exec msp_young_student 11, 17


select * from level
create procedure discount_customer 
	@level		varchar(10),
	@total_all	int
as
	if(@level != 'l1' and	@total_all >= 4000)
	begin
			print 'x'
			update	Level
			set		name = 'P1'
			where	lid = @level
	end
	select	*
	from	level

exec discount_customer 'l4', 4000
drop procedure discount_customer 

select birthday from rider
create procedure HBD
	@day		int
as
	declare
		@Bday	int
	select	@Bday = DAY(birthday) 
	from Rider
	where	DAY(birthday) = @day
	
	select  rid, name, birthday, @Bday as 'Happy birthday'
	from	Rider
	where	DAY(birthday) = @day

drop procedure HBD
exec HBD 15

create table Update_Incom(
	name		varchar(20),
	new_salary	int,
	old_salary	int
)
create trigger tg_lecturer_chang_Salary on lecturer
for Update as
	declare
		@new_Salary		int,
		@old_Salary		int,
		@name			varchar(20)

		select @name = name from lecturer where salary >= 50000
if update(Salary)
begin
	select	@new_Salary = salary from inserted where salary <= 50000
	select	@old_Salary = salary from deleted where salary <= 50000
end
	insert into Update_Incom values(@name, @new_Salary, @Old_Salary)

drop trigger tg_lecturer_chang_Salary
drop table Update_Incom

Update  lecturer
set		salary = 100
where	salary < 50000


select * from lecturer
select * from Update_Incom

create trigger tg_Limit_Enroll_Subject
as
	declare
		
create table CustomerGift(
	year		varchar(20),
	cid			varchar(10),
	total_order int,
	gift		varchar(30)
	)
	
create procedure sp_check_customer_gift
		@year		varchar(4),
		@gift		varchar(30)
as
	declare
		@cid		varchar(5),
		@stotal		int
	-- select for set value declare
	select @cid = cid, @stotal = stotal
	from	cByYear
	where	year = @year
	and		stotal = 
			(select max(stotal)
			from	cByYear
			where	year = @year)

	-- do
	insert into CustomerGift values(@year, @cid, @stotal, @gift)


drop procedure sp_check_customer_gift

exec sp_check_customer_gift '2020', 'figureAvenger'
exec sp_check_customer_gift '2021', 'figureUltraman'

select * from CustomerGift

Create table Backup_Cus(
		cid		varchar(10),
		name	varchar(20),
		phone	varchar(10),
		level	varchar(5),
		total	int,
		oldaddr varchar(50)
	)
drop table Backup_Cus

create trigger tg_customer on customer
for update as
declare
	@cid		varchar(10),
	@name		varchar(20),
	@phone		varchar(10),
	@level		varchar(5),
	@total		int,
	@address	varchar(50),
	@old_addr   varchar(50)
declare
	cus_cur cursor for select cid, name, phone, level, total from deleted
open cus_cur
if(update(address))
begin
	fetch next from cus_cur into @cid, @name,@phone,@level,@total
	while (@@fetch_status = 0)
	begin
		select @old_addr = address from deleted 
		insert into Backup_Cus values(@cid,@name,@phone,@level,@total, @old_addr)
		fetch next from cus_cur into @cid, @name,@phone,@level,@total
	end
end
close cus_cur
deallocate cus_cur	

drop trigger tg_customer

update  Customer
set		address = 'Nnot found'
where	address is null

select * from Backup_Cus Order by cid
select * from customer
