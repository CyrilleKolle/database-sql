create table authors
(
    id int primary key identity,
    firstname nvarchar(50),
    lastname nvarchar(50),
    birthdate date default(getdate()),
)

create table books
(
    isbn13 nvarchar(50) primary key,
    title nvarchar(50),
    [language ]nvarchar(50),
    price_$ float,
    releaseDate date
)

CREATE TABLE author_books
(
    authorId INT,
    isbn13 NVARCHAR(50),
    PRIMARY KEY (authorId, isbn13),
    FOREIGN KEY (authorId) REFERENCES authors(id),
    FOREIGN KEY (isbn13) REFERENCES books(isbn13)
);

create table bookStores
(
    id int primary key identity,
    name nvarchar(50),
    address nvarchar(50)
)

create table inventory
(
    storeId int,
    isbnBookId nvarchar(50),
    totalAvailable int,
    constraint PK_inventory primary key (storeId, isbnBookId),
    constraint FK_storeid foreign key (storeId) references bookStores(id),
    constraint FK_isbn foreign key (isbnBookId) references books(isbn13)
)


create table BookDescription
(
    descriptionId int primary key identity,
    isbnBookId nvarchar(50),
    description nvarchar(max),
    constraint FK_book foreign key (isbnBookId) references books(isbn13)
)

create table Publisher
(
    publisherId int primary key identity,
    isbnBookId nvarchar(50),
    publisherName nvarchar(50),
    constraint FK_book_publisher foreign key (isbnBookId )references books(isbn13)
)

create table Genre
(
    genereId int primary key identity,
    genereName nvarchar(50),
    isbnBookId nvarchar(50),
)
select * from Publisher
-- EXEC sp_rename 'dbo.genre.genereName', 'isbnBookId', 'COLUMN';
-- EXEC sp_rename 'dbo.genre.isbnBookId', 'genreName', 'COLUMN';


create table Orders
(
    customerId int primary key identity,
    storeId int,
    customerAddress nvarchar(max),
    isbnBookId nvarchar(50),
    orderDate date,
    shippedDate date,
    constraint FK_orders_store foreign key (storeId) references BookStores(id),
    constraint CK_orders_dates check (shippedDate > orderDate)
)


GO
create view titlePerAuthor
as
    select
        concat(a.firstname,' ', a.lastname) as 'Name',
        CASE 
        WHEN a.deathdate IS NULL THEN DATEDIFF(YEAR, birthdate, GETDATE())
        ELSE DATEDIFF(YEAR, birthdate, a.deathdate)
    END AS 'Age',
        sum(i.totalAvailable) as 'Inventory Total',
        concat(count(distinct b.isbn13), ' st') as 'Books Titles',
        concat(sum(i.totalAvailable * b.price_$), ' Kr') as 'Price value'
    from
        ai22.dbo.authors a
        join dbo.books b on b.authorId = a.id
        join dbo.inventory i on i.isbnBookId = b.isbn13

    group by 
    a.firstname, a.lastname, a.birthdate, a.deathdate
GO


create procedure MoveBooks
    @fromStoreId int,
    @toStoreId int,
    @isbn nvarchar(20),
    @quantity int
as
begin
    if exists (
        select *
    from inventory
    where storeId = @fromStoreId and isbnBookId = @isbn and totalAvailable >= @quantity)
                    begin
        begin tran
        update inventory set totalAvailable = totalAvailable - @quantity where storeId = @fromStoreId and isbnBookId = @isbn
        if @@ROWCOUNT = 0
                                    begin
            rollback
            raiserror ('Failed to move books. The providing store does not have enough stock of the specified book.', 16, 1)
            return
        end
        update inventory set totalAvailable = totalAvailable + @quantity where storeId = @toStoreId and isbnBookId = @isbn
        if @@ROWCOUNT = 0
                                    begin
            rollback
            raiserror ('Failed to move books. The destination store does not have the specified book in stock.', 16, 1)
            return
        end
        commit
    end
                    else
                    begin
        raiserror ('Failed to move books. The providing store does not have enough stock of the specified book.', 16, 1)
    end
end

GO


GO
create view publisherInfo
as
    select top 11
        p.publisherName,
        count(o.isbnBookId) as 'Unique Books by publisher',
        string_agg(o.customerId, ', ') as 'Destination',
        string_agg(bs.name, ', ') as 'Store name'
    from
        Publisher p
        join Orders o on o.isbnBookId = p.isbnBookId
        join bookStores bs on bs.id = o.storeId
        join books b on b.isbn13 = o.isbnBookId
    group by 
        p.publisherName, bs.name

GO


--Example:
-- EXEC MoveBooks 2, 1, '978-0062315007', 5




