select count(*) from Elements --count rows

select count(*), count(Meltingpoint), count(Boilingpoint) from Elements --Count rows with melting point
select * from Elements where Meltingpoint is not null
select count(*) - count(Meltingpoint) as 'Null values in meltinpoint' from Elements -- count null values in meltingpoint
select sum(Mass) as 'Sum of mass' from Elements
select avg(Boilingpoint) as 'avege', min(Boilingpoint) as 'Average boiling point', max(Boilingpoint) as 'Max bp' from Elements
select avg(isnull(Boilingpoint, 0)) from Elements -- if null give it 0
select * from Elements order by Boilingpoint
select STRING_AGG(Symbol, ', ') from Elements

select count(period), count(distinct period) from Elements --dount distinct/unique values

--Group--
select  Period ,count(Period) as 'Number of elements', string_agg(Symbol, ', ') from Elements group by Period

select * from Countries
select country, count(region) from Countries group by country

--Having--

select  period from Elements group by period having count(period) >=18
select  period from Elements where Boilingpoint < 10 group by period having count(period) <=18

--group by more than a column

select * from company.orders

select id, shipRegion, shipcountry, shipcity  from company.orders order by ShipRegion, ShipCountry, ShipCity

select shipRegion, shipcountry, shipcity, count(*) as 'order count'  from company.orders group by ShipRegion, ShipCountry, ShipCity


--Variables
declare @username as nvarchar(max) = 'sigpet';
declare @email as nvarchar(max);
declare @firstname as nvarchar(max);
declare @lastname as nvarchar(max);

--set @email = (select top 1 email from users where UserName = @username);

select top 1 @firstname = firstname, @lastname = lastname, @email = Email from users where UserName = @username

print concat('Email for user ', @firstname, ' ', @lastname, ' is ', @email)

--------

declare @firstname2 as nvarchar(max) = '';

select @firstname2 += firstname from users

select @firstname2



-- Konvertering
select cast('45' as int) -- ISO-SQL
select convert(int, '45') -- T-SQL


select cast('42' as int) -- type casting ISO sql text to int
select convert(int, '45') -- T-SQL text to int
