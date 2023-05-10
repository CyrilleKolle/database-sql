create table authors
(
    id int primary key identity,
    firstname nvarchar(50),
    lastname nvarchar(max),
    birthdate datetime default(getdate()),
)
truncate table authors
insert into 
    authors
    (firstname, lastname)
select

    Left(authors, CHARINDEX(' ', authors)),
    case 
           when charindex('/', substring(authors, charindex(' ', authors)+1, 1000)) > 0 
               then substring(authors, charindex(' ', authors)+1, charindex('/', substring(authors, charindex(' ', authors)+1, 1000))-1) 
           else substring(authors, charindex(' ', authors)+1, 1000) 
       end as lastname
from
    kaggleBooks

select *
from authors

-- INSERT INTO myTable (col1, col2, col3)
-- SELECT col1, col2, col3
-- FROM otherTable
-- WHERE condition;
-- ALTER TABLE books
-- DROP CONSTRAINT FK_books_author;
-- delete table books

create table books
(
    isbn13 nvarchar(17) primary key,
    title nvarchar(50),
    [language ]nvarchar(50),
    price nvarchar(50),
    releaseDate datetime,
    authorId int,
    constraint FK_books_author foreign key (authorId) references authors(id)

)

create table bookStores
(
    id int primary key,
    name nvarchar(50),
    address nvarchar(50)
)

create table inventory
(
    storeId int primary key,
    isbnBookId int primary key,
    totalValue int,
    constraint FK_storeid foreign key (storeId) references bookStores(id),
    constraint FK_isbn foreign key (isbnBookId) references books(isbn13)
)
-- I denna tabell vill vi ha 3 kolumner: ButikID som kopplas mot Butiker, 
-- ISBN som kopplas mot böcker, samt Antal som säger hur många exemplar det
--  finns av en given bok i en viss butik. Som PK vill vi ha en kompositnyckel 
--  på kolumnerna ButikID och ISBN.


drop table inventory
select *
from inventory
select *
from authors
select *
from books

select *
from kaggleBooks

