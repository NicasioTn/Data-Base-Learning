select * from level
select * from customer
select * from employee
select * from RIDER
select * from food
select * from iORDER
select * from iDetail

create view FoodType(type,amount) as
(select type,count(*)
from food
group by type)


drop view FoodType

select * from FoodType

create view FoodSold(fid,tamount) as
(select fid, sum(amount)
from iDetail
group by fid)

select * from FoodSold
select * from food

select name,tamount,tamount*price
from food, FoodSold
where food.fid = FoodSold.fid
and type='drink'

select food.*
from food, FoodSold
where food.fid = FoodSold.fid
and tamount = 
 (select max(tamount) from FoodSold)


 select * from rider

create view EmpRider(eid, r_amount) as
 (select suggest,count(*)
 from rider
 where suggest is not null
 group by suggest)

select * from EmpRider
select * from employee

select employee.eid,name,r_amount
from employee,empRider
where employee.eid = empRider.eid


select * from rider
select * from empRider

select rider.*
from rider,empRider
where rider.suggest = empRider.eid
and r_amount = 
 (select max(r_amount) from EmpRider)



 select * from iORDER

create view cOrder(cid,year,amount) as
 (select cid,year(date),count(*)
 from iORDER
 group by cid,year(date) )

 select * from cOrder
 select * from CUSTOMER


 select customer.cid, name, amount
 from customer, cOrder
 where customer.cid = cOrder.cid
 and year='2021'

 select * from employee

 --ผู้จัดการแต่ละคนมีลูกน้องกี่คน
create view xxx(manager,number) as
 (select manager, count(*)
 from employee
 where manager is not null
 group by manager)

 drop view xxx

select * from xxx

select * from employee
--ชื่อผู้จัดการที่มีลูกน้องมากที่สุด
select name
from employee, xxx
where employee.eid = xxx.manager
and number = 
 (select max(number) from xxx)













