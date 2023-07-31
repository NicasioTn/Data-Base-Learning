
--trigger ใน tutorial
create table FoodDemo(
	fid varchar(5),
	xprice float,
	newprice float, 
	date date,
	dbuser varchar(30) )


drop table FoodDemo

create trigger Demo_Price_Update on food 
for update as
declare 
	@new_price	float,
	@old_price	float,
	@fid	varchar(5)
declare	
    food_cur cursor for select fid from inserted
open food_cur
if update(price)
begin
	fetch next from food_cur into @fid --@fid = d01
	while (@@fetch_status = 0)
	begin
		select @new_price = price from inserted where fid = @fid
		select @old_price = price from deleted where fid = @fid
		
		insert into FoodDemo values(@fid,@old_price,@new_price,getdate(),SUSER_NAME())
		
		--print 'fid ='+@fid+' '+convert(varchar,@old_price)+' '+convert(varchar,@new_price)
		
		fetch next from food_cur into @fid
	end
end
close food_cur
deallocate food_cur

drop trigger Demo_Price_Update

select * from food

update food
set price = 2000
where type='drink'

deleted
-----------------------------
d01	Beer	200	drink
d02	Red wine	500	drink
d03	White wine	800	drink
d04	Juice	300	drink
d05	Coffee	100	drink
d06	Orange juice	100	drink

inseted
------
d01	Beer	2000	drink
d02	Red wine	2000	drink
d03	White wine	2000	drink
d04	Juice	2000	drink
d05	Coffee	2000	drink
d06	Orange juice	2000	drink


food_cur -> fid
             ----
		->	  d01
		->	  d02
		->	  d03
			  d04
			  d05
			  d06

select * from FoodDemo



select cid,sum(amount)
from iDetail,iORDER
where iDetail.oid = iORDER.oid
group by cid

--เรื่อง procedure ใน tutorial

CREATE VIEW cByYear (year,cid,stotal) as
(	SELECT	 year(date),cid,sum(amount*price) 
	FROM	 iORDER,iDetail,FOOD
	WHERE	 iORDER.oid			=	iDetail.oid
	AND		 iDetail.fid		=	FOOD.fid
	GROUP BY year(date),cid	) 

select * from cByYear order by year

select cid
from cByYear
where year='2020'
and stotal =
 (select max(stotal) from cByYear where year='2020')


 create table CustomerGift (
 year varchar(4),
 cid varchar(5),
 total_order float, 
 gift varchar(50)
 ) 


create procedure sp_check_customer_gift
	@year varchar(4),
	@gift varchar(50)
as 
declare
	@cid  varchar(5),
	@total float

	select @cid = cid
	from cByYear
	where year=@year
	and stotal =
	 (select max(stotal) from cByYear where year=@year)
	 
	 select @total = stotal from cByYear where cid=@cid and year =@year
	insert into CustomerGift values(@year,@cid,@total,@gift)


 exec sp_check_customer_gift '2022','ccccc'
 
 drop procedure sp_check_customer_gift

 select * from CustomerGift


 -- join ข้อ 5 ใน tutorial
 select iDetail.oid,cid, sum(amount*price) as ototal
 from iORDER,iDetail,FOOD
 where food.fid = iDetail.fid
 and iDetail.oid = iORDER.oid
 group by cid,iDetail.oid
 
 
