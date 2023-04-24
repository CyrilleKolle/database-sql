--SELECT

-- SELECT FirstName, LastName FROM Users
-- SELECT * FROM Users

SELECT LastName, FirstName, LastName, 'Hejsan' as 'Greeting'
from Users
--Create a new column called Greeting and Hjesan as a constant

SELECT FirstName as 'Förnamn', LastName, 'Hejsan' as 'Greeting'
from Users
-- Select then name FirstNAme column as Förnam

SELECT FirstName as 'Förnamn', LastName, 'Hello ' + FirstName as 'Greeting'
FROM Users
-- Concatenation

-- radius * 2 as diameter
--[select] this command incase there is a column called select which is already a keyword


SELECT FirstName as 'Förnamn', upper(LastName) as 'LastName', 'Hejsan' as 'Greeting'
from Users
-- Uppercase

--POJECTION 
SELECT TOP 1
    FirstName as 'Förnamn', LastName, 'Hejsan' as 'Greeting'
from Users
WHERE FirstName = 'MY'

SELECT TOP 1
    *
from Users
WHERE FirstName = 'MY'

SELECT *
FROM Users
WHERE len(FirstName) = 4

SELECT *
FROM Users
WHERE len(FirstName) <> 4

SELECT *
FROM Users
WHERE len(FirstName) <> 4 and len(LastName) <= 6
-- Operations
/*

SQL         Python
=             ==
<>            !=
and            &
or            |
<
>
<=
>=

*/
SELECT 9 / 2
--4
SELECT 9.0 / 2
--4.5 checks if its a float first
SELECT 9 % 2

--In
-- SELECT * FROM Users where FirstName in ()

SELECT *
from Users
where FirstName <= 'c'

select '5' + 3


select *
from Airports
where IATA between 'AAF' and 'ADK'

select *
from Airports
where IATA = 'GOT'
select *
from Airports
where IATA like 'G%O%T%'
select *
from Airports
where IATA like 'A_'
select *
from Airports
where IATA like 'A__'
select *
from Airports
where IATA like 'A[f-p]_'
select *
from Airports
where IATA like 'A[f-p][t-z]'

select *
from Airports
where IATA like replicate('[a-b]', 3)
-- [a-b][a-b][a-b]

select *
from Airports
where IATA like '[aglp]%'
--select rows that begin with a,g,l or p
select *
from Airports
WHERE IATA like '[^aglp]%'

SELECT top 2
    *
from Users
where FirstName like 'a%'
ORDER by FirstName DESC, LastName desc
--asc is default when doing an order

select distinct Season
from GameOfThrones

SELECT *
from GameOfThrones

    select 'Förnamn' = FirstName, LastName as 'Efternamn'
    from Users
union all
    select Title, [Directed by]
    from GameOfThrones
order by 'Förnamn'


select
    * ,
    case
    when len(FirstName) <= 4 then 'short First Name'
    when len(FirstName) >=9 then 'Long First Name'
    else 'Average First Name'
    end as 'Length of FirstName'
from Users