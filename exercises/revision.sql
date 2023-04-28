
--select * from [Database].[Schema].[Table]
--select [Server].[Database].[Schema].[Table]

use AI --sends this command to the server to chose this is as the databese to use
select * from Students

use everyloop
select * from dbo.Users

--alias--
select firstname as 'Förnamn', left(LastName, 3) as '3 first letter LN' from users2 --förnamn is the alias

select * into #myTemplate from users2
select * from #myTemplate

select * into ##myTemplate from users2
select * from ##myTemplate

select @@IDENTITY
select @@SPID