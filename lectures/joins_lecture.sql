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

select * from cities join countries on cities.countryId = countries.id
select * from cities inner join countries on cities.countryId = countries.id --same as above

select 
    cities.id, 
    cities.name as 'City', 
    cities.name as 'Country',
    countries.* --same as cities.*
    --Id -will return a fault since both tables have an Id column
FROM
    cities
    inner join countries on cities.countryId = countries.id

select 
    cities.id, 
    cities.name as 'City', 
    cities.name as 'Country',
    countries.* --same as cities.*
    --Id -will return a fault since both tables have an Id column
FROM
    cities
    inner join countries on cities.countryId = countries.id
where countries.name = 'Sweden'

select 
    ci.id,
    ci.name as 'City',
    ci.name as 'Country'
from 
    cities ci 
    inner join countries co on ci.countryId = co.id --join woukd be same as inner join

--lefft join
select 
    ci.id,
    ci.name as 'City',
    ci.name as 'Country'
from 
    cities ci 
    left join countries co on ci.countryId = co.id 
    
--right join
select 
    ci.id,
    ci.name as 'City',
    ci.name as 'Country'
from 
    cities ci 
    right join countries co on ci.countryId = co.id 

--full join
select 
    ci.id,
    ci.name as 'City',
    ci.name as 'Country'
from 
    cities ci 
    full join countries co on ci.countryId = co.id

--full outer join
select 
    ci.id,
    ci.name as 'City',
    ci.name as 'Country'
from 
    cities ci 
    full outer join countries co on ci.countryId = co.id

--where
select 
    -- ci.id,
    -- ci.name as 'City',
    co.name as 'Country',
    count(*) as 'Number of cities',
    isnull(string_agg(ci.name, ', '), '-') as 'List of cities'
from 
    cities ci 
    right join countries co on ci.countryId = co.id
group by co.name

--cross join
select * from countries cross join cities

-- old way for a cross join, recommended to use a more modern way
select * from countries, cities where countries.id = cities.countryId

-- select * from company.employees

-------------------------------------------------------
--Join Many to Many
--drop table courses;

create table courses
(
    id int,
    name nvarchar(max)
);

insert into courses values (1, 'Python');
insert into courses values (2, 'Algebra');
insert into courses values (3, 'Databaser');
insert into courses values (4, 'AI');

drop table students;

create table students
(
    id int,
    name nvarchar(max)
);

insert into students values (1, 'Thomas');
insert into students values (2, 'Erik');
insert into students values (3, 'Anna');
insert into students values (4, 'Camilla');
insert into students values (5, 'Maria');

create table coursesStudents
(
    courseId int,
    studentId int
)

insert into coursesStudents values (1, 1);
insert into coursesStudents values (1, 2);
insert into coursesStudents values (1, 3);
insert into coursesStudents values (2, 1);
insert into coursesStudents values (2, 2);
insert into coursesStudents values (2, 3);
insert into coursesStudents values (2, 4);
insert into coursesStudents values (3, 2);
insert into coursesStudents values (3, 4);

select * from courses;
select * from students;
select * from coursesStudents;

-- if OBJECT_ID(N'dbo.students', N'U') drop table [dbo].students

select 
    -- *,
    c.name as 'Kurs',
    s.name as 'Students'
from 
    courses c
    join coursesstudents cs on c.id = cs.courseId
    join students s on s.id = cs.studentId

--miniuppgigt 2: Lista alla kurser (4 rader), med en kolumn med antal studenter
--och en för lista med studenter

--miniuppgigt: Lista alla studententer (5 rader), med en kolumn med antal kurser
--och en för lista med kurser

--1
select * from courses
select 
    c.name as 'Kurs',
    count(s.name) as 'Number of students',
    isnull(string_agg(s.name, ', '), '0') as 'List of students'
from 
    courses c
    left join coursesstudents cs on c.id = cs.courseId
    left join students s on s.id = cs.studentId
group by c.name

--2
select 
    s.name as 'Students',
    count(c.name) as 'Number of Courses',
    isnull(string_agg(c.name, ', '), '0') as 'List of courses'
from 
    courses c
    right join coursesstudents cs on c.id = cs.courseId
    right join students s on s.id = cs.studentId
    
group by s.id, s.name
-------