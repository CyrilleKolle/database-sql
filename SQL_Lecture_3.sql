select *
from users

select *
into users2
from Users

select *
from users2

select ID, UserName, Password, FirstName + ' ' + LastName as 'Fullname', Email, Phone
into users3
from users2

select *
from users3

insert into users3
    (ID, Fullname)
values
    ('490703-8438', 'Frida Karlsson')

select *
from users3
order by ID

--delete from users3 where id = '490703-8438'

insert into users3
    (ID, Fullname, Email)
values
    ('460703-8438', 'Sven Karlsson', 'sven@karlsson.com')
insert into users3
    ( Fullname, Email)
values
    ('490703-8338', 'Er Karlsson', 'err@karlsson.com')
-- wont run because of no id

insert into users3
values
    ('490703-8338', 'erikar', 'bhdsbjhsdhdhbfwefjdfhfdn', 'Er Karlsson', 'err@karlsson.com', '0739283774')

select *
from users2
order by (ID)

insert into users2
    (ID)
select left(Title, 12)
from GameOfThrones
where Season = 1


--UPDATE

update users2 set Email = 'johanna@hhdhd.com' where ID = '500603-4268'

--miniupgift: Uppdatera email till '-' för alla personner med ett förnamn på 4 bokstaver

update users2 set Email = '-'  where len(FirstName) = 4

--miniuppgift: uppdatera email för alla förnamn på 4 bokstaver till [namnet]@gmail.com 

update users2 set Email = FirstName + '@gmail.com'  where len(FirstName) = 4

delete from users2 where len(FirstName) = 4


--UPSERT

select *
into users4
from Users

truncate table users4

select * from users4