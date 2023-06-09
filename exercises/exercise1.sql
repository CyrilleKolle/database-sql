
--Exercise 1

select *
from GameOfThrones

--1
SELECT Title, 'S' + FORMAT(Season, '00') + 'E' + format(EpisodeInSeason, '00') as 'Episodes'
FROM GameOfThrones;


--2
select *
from Users

select *
into UsersNew
from Users

update UsersNew set UserName = lower(left(FirstName, 2) + left(LastName, 2))
select *
from UsersNew

--3
select *
from Airports

select *
into air1
from Airports

update air1 set dst = isnull(dst, '-'), time = isnull(time, '-')
select *
from air1


--4 
select *
from Elements

select *
into el
from Elements
select *
from el
-- drop table el
select lower(name)
from el
delete from el where substring(reverse(Name), 1, 2) = 'mu'
delete from el where Name like '[HKMOU]%'
-- delete from el where Name like 'H%' or Name like 'K%' or Name like 'M%' or name like 'O%' or Name like 'U%'


--5

select *
into el2
from Elements
select *
from el2


select *, iif(name like symbol+'%', 'Yes', 'No')
     as 'Naming'
into el3
from Elements

select Symbol, Name, case when Symbol = left(Name, len(Symbol)) then 'Yes'
else 'No' end as 'Yes/No' from Elements

select * from el3

--6
select * from Colors

select Name, Red, Green, Blue into colors2 from Colors
select * from colors2

select [Name], Code, concat('#', format(Red, 'X2'), format(Green, 'X2'), format(Blue, 'X2')) as 'Code2' from Colors


--7f) Kopiera tabellen Colors till Colors2, men skippa kolumnen ”Code”. 
--Gör sedan en select från Colors2 som ger samma resultat som du skulle fått från select
-- * from Colors; (Dvs, återskapa den saknade kolumnen från RGB- värdena i resultatet).


--1g                                                                                  
select 
    Integer / 100.0 as 'newInteger',
    CAST(Integer AS FLOAT) / 100 AS 'Float',
    String,
    -- NOTE: have to add DAY Integer - 1 because 2019-01-00 is not a valid date
    CAST(DATEADD(DAY, [Integer] - 1, DATEADD(MINUTE, [Integer], '2019-01-01 09:00:00')) AS DATETIME2) AS 'newDateTime',
    Integer % 2 AS 'Bool'
from Types