select * from generate_series(1,10)

select 
    value,
    rand() as 'Random',
    newId() as 'GUID'
from generate_series(1,10) --rand() here generates just one value for all columns

select rand(5), rand(), rand()

select checksum('Fredrik')


select 
    value,
    rand() as 'Random',
    newId() as 'GUID',
    checksum(newId()) as 'GUID',
    rand(checksum(newId())) as '0 -10',
    rand(checksum(newId())) * 10 as '0-10',
    rand(checksum(newId())) * 10 - 5 as 'Random float',
    abs(checksum(newId())) % 5 as ' Random Int',
    char(65 + abs(checksum(newId())) % 5) as 'As random letter',
    char(65 + abs(checksum(newId())) % 26) as 'As random letter',
    checksum(newid()) % 3 + 1 as 'Rand3'
from generate_series(1,10)


select 
    *,
    choose(Rand3, 'Red', 'Green', 'Blue')
from (
    select 
    value,
    rand() as 'Random',
    newId() as 'GUID',
    checksum(newId()) as 'GUID Checksum',
    rand(checksum(newId())) as '0 -10',
    rand(checksum(newId())) * 10 as '0-10',
    rand(checksum(newId())) * 10 - 5 as 'Random float',
    abs(checksum(newId())) % 5 as ' Random Int',
    char(65 + abs(checksum(newId())) % 5) as 'As random letter',
    char(65 + abs(checksum(newId())) % 26) as 'As random letter 2',
    abs(checksum(newid())) % 3 + 1 as 'Rand3'
from generate_series(1,100)
) subquery

declare @randomName nvarchar(max) = (select top 1 FirstName from users order by newId())
print @randomName

-- ALTER DATABASE everyloop
-- SET COMPATIBILITY_LEVEL = 160

select 
    id,
    concat(firstname, ' ', lastname) as 'name',
    translate(lower(concat(firstname,'.', lastname, '@gmail.com')), 'åöä', 'aao')as 'email'
(select 
    value,
    concat(format(dateadd(day, abs(checksum(newid())) % 36500, '1900-01-01'), 'yymmdd'), '-', format(abs(checksum(newid())) % 1000)) as 'personnumber',
    (select top 1 firstname from Users where g.[value] = g.[value] order by newId()) as 'firstname',
    (select top 1 lastname from Users where g.[value] = g.[value] order by newId()) as 'lastname'

from 
    generate_series(1,1000) g) subquery


select * from company.order_details
select * from company.orders

