--join we can link data from two tables given they have a commun column like an id
--foreign keys(reationsnyckel - sv) points to a primary key in another table
--primary key data = -GUID -Identity key -

--Cross join:
--least used type but others are build from this

--Inner join vs Full join
--Inner join: we get only those who match i.e the ones that are common for both tables

--Full join: takes all rows from all tables and rows that dont match get a null value for
--for the empty rows

--Left join vs Right join
--Left: takes all from the left table even if without a corresponding right row with empty 
--columns being null
--Right: opposite of left

--Examples
--select * from [countries] i join [cities] on s.landsId = i.landsId
-- just writing join does an 'inner join'

--EXAMPLES
--Join One to Many: Type of join done when a value unique in one table can have many 
--values in another table
--Common type of dataset

-- drop table countries
-- drop table cities

create table countries (
    id INT,
    name NVARCHAR(max)
)
insert into countries values (1, 'Sweden')
insert into countries values (2, 'Denmark')
insert into countries values (3, 'Normway')
insert into countries values (4, 'Finland')

select * from countries

create table cities (
    id int,
    name nvarchar(max),
    countryId int
)
insert into cities values(1, 'Stockholm',1)
insert into cities values(2, 'Gothenburg',1)
insert into cities values(3, 'Malmö',1)
insert into cities values(4, 'Copenhagen',2)
insert into cities values(5, 'Oslo',3)
insert into cities values(6, 'Bergen',3)
insert into cities values(7, 'London',5)

select * from cities