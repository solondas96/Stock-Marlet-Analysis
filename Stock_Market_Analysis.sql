

-- creating the Database.
create database stock_market;

-- Using the Database.
use stock_market;


/* Tables for bajaj_auto, eicher motors, hero motocorp, infosys, tcs, tvs motors were imported 
from the dataset provided by using the Table Data import wizard */


-- Changing the name of Close Price coulumn of each table to close_price.

alter table `bajaj auto` rename column `Close Price` to close_price;
alter table `eicher motors` rename column `Close Price` to close_price;
alter table `hero motocorp` rename column `Close Price` to close_price;
alter table infosys rename column `Close Price` to close_price;
alter table tcs rename column `Close Price` to close_price;
alter table `tvs motors` rename column `Close Price` to close_price;

-- Renaming some table names.

rename table `bajaj auto` to bajaj_auto, `eicher motors` to eicher_motors, `hero motocorp` to hero_motocorp, `tvs motors` to tvs_motors;


-- Run the Select query to see the data.

select date, close_price from bajaj_auto;
select date, close_price from eicher_motors;
select date, close_price from hero_motocorp;
select date, close_price from infosys;
select date, close_price from tcs;
select date, close_price from tvs_motors;

-- Changing the date column data type from text to date type.

UPDATE bajaj_auto SET date = STR_TO_DATE(date, '%d-%M-%Y');
UPDATE eicher_motors SET date = STR_TO_DATE(date, '%d-%M-%Y');
UPDATE hero_motocorp SET date = STR_TO_DATE(date, '%d-%M-%Y');
UPDATE infosys SET date = STR_TO_DATE(date, '%d-%M-%Y');
UPDATE tcs SET date = STR_TO_DATE(date, '%d-%M-%Y');
UPDATE tvs_motors SET date = STR_TO_DATE(date, '%d-%M-%Y');

/* --------------------------------------------------------------------------------------------------- */

/*  1 -- Creating a new table named 'bajaj1' containing the date, close price, 20 Day MA and 50 Day MA. 
		(This is done for all 6 stocks).  */
        
create table bajaj1 (
	date date,
	close_price decimal(10,2),
    20_day_ma decimal(10,2),
    50_day_ma decimal(10,2)  
);

create table eicher1 like bajaj1;
create table hero1 like bajaj1;	
create table infosys1 like bajaj1;
create table tcs1 like bajaj1;
create table tvs1 like bajaj1;	

-- inserting values into the table bajaj1, eicher1, hero1, infosys1, tcs1, tvs1

insert into bajaj1 (date, close_price, 20_day_ma, 50_day_ma)
	select date, close_price,
       avg(close_price) over (order by date asc rows 19 preceding) as ma20,
       avg(close_price) over (order by date asc rows 49 preceding) as ma50
	from bajaj_auto
	order by date;

insert into eicher1 (date, close_price, 20_day_ma, 50_day_ma)
	select date, close_price,
		avg(close_price) over (order by date asc rows 19 preceding) as ma20,
		avg(close_price) over (order by date asc rows 49 preceding) as ma50
	from eicher_motors
	order by date;
    
    
insert into hero1 (date, close_price, 20_day_ma, 50_day_ma)
	select date, close_price,
		avg(close_price) over (order by date asc rows 19 preceding) as ma20,
		avg(close_price) over (order by date asc rows 49 preceding) as ma50
	from hero_motocorp
	order by date;
    
    
insert into infosys1 (date, close_price, 20_day_ma, 50_day_ma)
	select date, close_price,
		avg(close_price) over (order by date asc rows 19 preceding) as ma20,
		avg(close_price) over (order by date asc rows 49 preceding) as ma50
	from infosys
	order by date;
    
    
insert into tcs1 (date, close_price, 20_day_ma, 50_day_ma)
	select date, close_price,
		avg(close_price) over (order by date asc rows 19 preceding) as ma20,
		avg(close_price) over (order by date asc rows 49 preceding) as ma50
	from tcs
	order by date;
    
    
insert into tvs1 (date, close_price, 20_day_ma, 50_day_ma)
	select date, close_price,
		avg(close_price) over (order by date asc rows 19 preceding) as ma20,
		avg(close_price) over (order by date asc rows 49 preceding) as ma50
	from tvs_motors
	order by date;

-- view values inserted in each table 


select * from bajaj1;
select * from eicher1;
select * from hero1;
select * from infosys1;
select * from tcs1;
select * from tvs1;

/* --------------------------------------------------------------------------------------------------- */
-- 2. Creating a master table containing the date and close price of all the six stocks. 
 
 create table master_stocks (
	`date` date,
	`bajaj` decimal(10,2),
    `tcs` decimal(10,2),
    `tvs` decimal(10,2),
    `infosys` decimal(10,2),
    `eicher` decimal(10,2),
    `hero` decimal(10,2)  
);

-- insert values into master stocks table


insert into master_stocks (date, bajaj, tcs, tvs, infosys, eicher, hero) 
	select bajaj_auto.date, bajaj_auto.close_price, tcs.close_price, tvs_motors.close_price, infosys.close_price, 
		   eicher_motors.close_price, hero_motocorp.close_price	   	   
	from  bajaj_auto
   	inner join tcs on bajaj_auto.date = tcs.date
	inner join tvs_motors on bajaj_auto.date = tvs_motors.date
	inner join infosys on bajaj_auto.date = infosys.date
	inner join eicher_motors on bajaj_auto.date = eicher_motors.date
	inner join hero_motocorp on bajaj_auto.date = hero_motocorp.date
	order by date;
    
-- view the updated master_stocks table

select * from master_stocks;
 
 /* --------------------------------------------------------------------------------------------------- */
 
 /*  
 	  3.   Use the table created in Part(1) to generate buy and sell signal. Store this in another table named 
		   'bajaj2'. Perform this operation for all stocks. 
		   Create  new tables bajaj2, eicher2, hero2, infosys2, tcs2, tvs2.
 */

create table bajaj2 (
	`date` date,
	`close_price` decimal(10,2),
    `signal` varchar(15)
);

create table eicher2 like bajaj2;
create table hero2 like bajaj2;
create table infosys2 like bajaj2;
create table tcs2 like bajaj2;
create table tvs2 like bajaj2;

-- inserting data into tables bajaj2, eicher2, hero2, infosys2, tcs2, tvs2

 /* 
   Note : Setting the first 49 rows signal as 'Not Applicable' in all tables , as they need to be ignored, 
		  becuase the 50 MA is only valid from the 50th row onwards and hence signals starting from the 
          50th row alone will be valid 
*/
 
 insert into bajaj2 (date,close_price,`signal`) 
	select date, close_price,		
		case
			when row_number() over(order by date) < 50 
				then 'Not Applicable'
			when 20_day_ma > 50_day_ma and (lag(20_day_ma,1) over (order by date)) < (lag(50_day_ma,1) over (order by date)) 
				then 'Buy'
			when 20_day_ma < 50_day_ma and (lag(20_day_ma,1) over (order by date)) > (lag(50_day_ma,1) over (order by date))
				then 'Sell'
			else 'Hold'	
		end	
	from  bajaj1
   	order by date; 
    

insert into eicher2 (date,close_price,`signal`) 
	select date, close_price,
		case
			when row_number() over(order by date) < 50 
				then 'Not Applicable'
			when 20_day_ma > 50_day_ma and (lag(20_day_ma,1) over (order by date)) < (lag(50_day_ma,1) over (order by date)) 
				then 'Buy'
			when 20_day_ma < 50_day_ma and (lag(20_day_ma,1) over (order by date)) > (lag(50_day_ma,1) over (order by date))
				then 'Sell'
			else 'Hold'	
		end	
	from  eicher1
   	order by date;


insert into hero2 (date,close_price,`signal`) 
	select date, close_price,
		case
			when row_number() over(order by date) < 50 
				then 'Not Applicable'
			when 20_day_ma > 50_day_ma and (lag(20_day_ma,1) over (order by date)) < (lag(50_day_ma,1) over (order by date)) 
				then 'Buy'
			when 20_day_ma < 50_day_ma and (lag(20_day_ma,1) over (order by date)) > (lag(50_day_ma,1) over (order by date))
				then 'Sell'
			else 'Hold'	
		end	
	from  hero1
   	order by date;
    
    
insert into infosys2 (date,close_price,`signal`) 
	select date, close_price,
		case
			when row_number() over(order by date) < 50 
				then 'Not Applicable'
			when 20_day_ma > 50_day_ma and (lag(20_day_ma,1) over (order by date)) < (lag(50_day_ma,1) over (order by date)) 
				then 'Buy'
			when 20_day_ma < 50_day_ma and (lag(20_day_ma,1) over (order by date)) > (lag(50_day_ma,1) over (order by date))
				then 'Sell'
			else 'Hold'	
		end	
	from  infosys1
   	order by date;
    
    
insert into tcs2 (date,close_price,`signal`) 
	select date, close_price,
		case
			when row_number() over(order by date) < 50 
				then 'Not Applicable'
			when 20_day_ma > 50_day_ma and (lag(20_day_ma,1) over (order by date)) < (lag(50_day_ma,1) over (order by date)) 
				then 'Buy'
			when 20_day_ma < 50_day_ma and (lag(20_day_ma,1) over (order by date)) > (lag(50_day_ma,1) over (order by date))
				then 'Sell'
			else 'Hold'	
		end	
	from  tcs1
   	order by date;
    
    
insert into tvs2 (date,close_price,`signal`) 
	select date, close_price,
		case
			when row_number() over(order by date) < 50 
				then 'Not Applicable'
			when 20_day_ma > 50_day_ma and (lag(20_day_ma,1) over (order by date)) < (lag(50_day_ma,1) over (order by date)) 
				then 'Buy'
			when 20_day_ma < 50_day_ma and (lag(20_day_ma,1) over (order by date)) > (lag(50_day_ma,1) over (order by date))
				then 'Sell'
			else 'Hold'	
		end	
	from  tvs1
   	order by date;
    

-- view all the tables bajaj2, eicher2, hero2, infosys2, tcs2, tvs2


select * from bajaj2;
select * from eicher2;
select * from hero2;
select * from infosys2;
select * from tcs2;
select * from tvs2;

 /* --------------------------------------------------------------------------------------------------- */

/* 4 --  Creating a User defined function, that takes the date as input and returns the signal for that particular 
		 day (Buy/Sell/Hold) for the Bajaj stock.  */
 
 delimiter $$

  create function getSignalForBajaj(input_date date) 
  returns varchar(15) deterministic
  begin   
  declare output_trade_signal varchar(15);
  
  select bajaj2.signal into output_trade_signal from bajaj2 
  where date = input_date;
  
  return output_trade_signal ;
  end
  
$$ 
delimiter ;

-- Checking what is our given trade signal on a input date.
select getSignalForBajaj('2015-08-24') as trade_signal;

 /* --------------------------------------------------------------------------------------------------- */


-- 5 - Queries used to help in drawing the Inferences from the stock analysis

-- For Bajaj

select date, close_price
from bajaj2
where `signal` = 'Buy'
order by close_price
limit 1;

select date, close_price
from bajaj2
where `signal` = 'Sell'
order by close_price desc
limit 1;


-- For Eicher

select date, close_price
from eicher2
where `signal` = 'Buy'
order by close_price
limit 1;

select date, close_price
from eicher2
where `signal` = 'Sell'
order by close_price desc
limit 1;


-- For Hero

select date, close_price
from hero2
where `signal` = 'Buy'
order by close_price
limit 1;

select date, close_price
from hero2
where `signal` = 'Sell'
order by close_price desc
limit 1;


-- For Infosys 

select date, close_price
from infosys2
where `signal` = 'Buy'
order by close_price
limit 1;

select date, close_price
from infosys2
where `signal` = 'Sell'
order by close_price desc
limit 1;


-- For TCS 

select date, close_price
from tcs2
where `signal` = 'Buy'
order by close_price
limit 1;

select date, close_price
from tcs2
where `signal` = 'Sell'
order by close_price desc
limit 1;


-- For TVS 

select date, close_price
from tvs2
where `signal` = 'Buy'
order by close_price
limit 1;

select date, close_price
from tvs2
where `signal` = 'Sell'
order by close_price desc
limit 1;

 /* --------------------------------------------------------------------------------------------------- */


