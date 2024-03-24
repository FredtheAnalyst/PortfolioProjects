use test;

-- A brief view of our dataset
select * from car_prices_2;

-- General queries

-- All the years in the dataset
select distinct(car_prices_2.year) from car_prices_2;

-- A list of all the makes
select distinct(make) from car_prices_2
order by make asc;
-- Some makes have different names for the same make.  
-- For example, Mercedes-Benz has three different titles: mercedes, mercedes-b and Mercedes-Benz.

-- A look at how many states are in the dataset
select count(distinct(state)) as Number_of_States from car_prices_2;
-- 36 states are recorded in the dataset

-- How many sellers are in the dataset
select count(distinct(seller)) as No_Sellers from car_prices_2;
-- 6421 sellers in the dataset

-- Look at the minimum and maximum of values of 'condition' column
select min(car_prices_2.condition), max(car_prices_2.condition) from car_prices_2;

-- Look at the minimum and maximum of values of 'odometer' column
select min(odometer), max(odometer) from car_prices_2;

-- Querying about make and models

-- Look at which make made the most sales and most turnover

-- order by number of sales
select make, count(make) as number_of_sales, avg(sellingprice) as average_selling_price, sum(sellingprice) as turnover from car_prices_2
group by make
order by count(make) desc;

-- order by turnover
select make, count(make) as number_of_sales, avg(sellingprice) as average_selling_price, sum(sellingprice) as turnover from car_prices_2
group by make
order by sum(sellingprice) desc;

-- Which make had on average the highest odometer-- 
select make, avg(odometer) as average_odometer from car_prices_2
group by make
order by avg(odometer) desc;

-- Querying by year

-- Which year made the most turnover
select car_prices_2.year, count(car_prices_2.year) as number_of_sales, avg(sellingprice) as average_selling_price, sum(sellingprice) as turnover from car_prices_2
group by car_prices_2.year
order by sum(sellingprice) desc;

-- Look at how the selling price compared to the mmr for all sales by make
select distinct(make), avg((mmr - sellingprice)) over (partition by make) as difference
from car_prices_2
order by difference desc;

-- Look at which make and model made the most sales and most turnover

-- order by number of sales
select make, model, count(make) as number_of_sales, avg(sellingprice) as average_selling_price, sum(sellingprice) as turnover from car_prices_2
group by make, model
order by count(make) desc;

-- order by turnover
select make, model, count(make) as number_of_sales, avg(sellingprice) as average_selling_price, sum(sellingprice) as turnover from car_prices_2
group by make, model
order by sum(sellingprice) desc;

-- Look at how the selling price compared to the mmr for all sales by make and model
select distinct(make), model, avg((mmr - sellingprice)) over (partition by make, model) as difference
from car_prices_2
order by difference desc;

-- Querying by colour and interior

-- Look at which color made the most sales and most turnover

-- order by number of sales
select color, count(color) as number_of_sales, avg(sellingprice) as average_selling_price, sum(sellingprice) as turnover from car_prices_2
group by color
order by count(color) desc;

-- order by turnover
select color, count(color) as number_of_sales, avg(sellingprice) as average_selling_price, sum(sellingprice) as turnover from car_prices_2
group by color
order by sum(sellingprice) desc;

-- Look at how the selling price compared to the mmr for all sales by color
select distinct(color), avg((mmr - sellingprice)) over (partition by color) as difference
from car_prices_2
order by difference desc;

-- Look at which color and interior made the most sales and most turnover

-- order by number of sales
select color, interior, count(color) as number_of_sales, avg(sellingprice) as average_selling_price, sum(sellingprice) as turnover from car_prices_2
group by color, interior
order by count(color) desc;

-- order by turnover
select color, interior, count(color) as number_of_sales, avg(sellingprice) as average_selling_price, sum(sellingprice) as turnover from car_prices_2
group by color, interior
order by sum(sellingprice) desc;

-- Look at how the selling price compared to the mmr for all sales by colour and interior
select distinct(color), interior, avg((mmr - sellingprice)) over (partition by color, interior) as difference
from car_prices_2
order by difference desc;

-- Querying by seller

-- order by number of sales
select seller, count(seller) as number_of_sales, avg(sellingprice) as average_selling_price, sum(sellingprice) as turnover from car_prices_2
group by seller
order by count(seller) desc;

-- order by turnover
select seller, count(seller) as number_of_sales, avg(sellingprice) as average_selling_price, sum(sellingprice) as turnover from car_prices_2
group by seller
order by sum(sellingprice) desc;

-- Look at how the selling price compared to the mmr for all sales by colour and interior
select distinct(seller),  avg((mmr - sellingprice)) over (partition by seller) as difference
from car_prices_2
order by difference desc;

-- Querying by condition

-- Turnover by condition
select car_prices_2.condition, count(car_prices_2.condition), avg(sellingprice) as average_selling_price, sum(sellingprice) as turnover 
from car_prices_2
group by car_prices_2.condition
order by sum(sellingprice) desc;

-- Look at how the selling price compared to the mmr for all sales by condition
select distinct(car_prices_2.condition),  avg((mmr - sellingprice)) over (partition by car_prices_2.condition) as difference
from car_prices_2
order by difference desc;

-- Querying by state
select state, count(state), avg(sellingprice) as average_selling_price, sum(sellingprice) as turnover 
from car_prices_2
group by state
order by sum(sellingprice) desc;

-- Create Views 

-- Which year made the most turnover
Create view year_sells as
select car_prices_2.year, count(car_prices_2.year) as number_of_sales, avg(sellingprice) as average_selling_price, sum(sellingprice) as turnover from car_prices_2
group by car_prices_2.year
order by sum(sellingprice) desc;

select * from year_sells;

-- Which make made the most turnover
Create view make_sells as
select make, count(make) as number_of_sales, avg(sellingprice) as average_selling_price, sum(sellingprice) as turnover from car_prices_2
group by make
order by count(make) desc;

-- Which make and model made the most turnover
Create view make_model_sells as
select make, model, count(make) as number_of_sales, avg(sellingprice) as average_selling_price, sum(sellingprice) as turnover from car_prices_2
group by make, model
order by sum(sellingprice) desc;

-- Looking at which makes made more turnover than average
with temporarytable (averageturnover) as
(select avg(turnover) from make_sells)
select * from make_sells, temporarytable
where make_sells.turnover > temporarytable.averageturnover
order by turnover desc;

-- Looking at which makes and their respective models made more turnover than average
with temporarytable (averageturnover) as
(select avg(turnover) from make_model_sells)
select * from make_model_sells, temporarytable
where make_model_sells.turnover > temporarytable.averageturnover
order by turnover desc;

-- top 10 sellers with the most turnover in the usa
Create view top_sellers as
select seller as top_sellers, sum(sellingprice) as turnover
from car_prices_2
group by seller
order by sum(sellingprice) desc
limit 10;

select * from top_sellers;

Create view sellers_most_sales as
select seller as best_sellers, count(seller) as number_of_sales
from car_prices_2
group by seller
order by sum(sellingprice) desc
limit 10;

select * from sellers_most_sales;



-- Create tables for tableau

create table make_model_sells_table
(
make nvarchar(100),
model nvarchar(100),
number_of_sales int,
average_selling_price float,
turnover float
);

insert into make_model_sells_table
select make, model, count(make) as number_of_sales, avg(sellingprice) as average_selling_price, sum(sellingprice) as turnover
from car_prices_2
group by make, model
order by sum(sellingprice) desc;

create table make_sells_table
(
make nvarchar(100),
number_of_sales int,
average_selling_price float,
turnover float
);

insert into make_sells_table
select make, count(make) as number_of_sales, avg(sellingprice) as average_selling_price, sum(sellingprice) as turnover from car_prices_2
group by make, model
order by sum(sellingprice) desc;

create table sellers_most_sales_table
(
top_sellers nvarchar(100),
turnover float
);

insert into sellers_most_sales_table
select seller as top_sellers, sum(sellingprice) as turnover
from car_prices_2
group by seller
order by sum(sellingprice) desc;

create table best_sellers_table
(
best_sellers nvarchar(100),
number_of_sales int
);

insert into best_sellers_table
select seller as best_sellers, count(seller) as number_of_sales
from car_prices_2
group by seller
order by sum(sellingprice) desc;


