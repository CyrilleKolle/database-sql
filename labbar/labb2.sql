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



CREATE TABLE Publisher (
    publisherId int,
    publisherName nvarchar(50),
    isbnBookId nvarchar(50),
    CONSTRAINT PK_NewPublisher PRIMARY KEY (publisherId, publisherName),
    CONSTRAINT FK_publisher_book FOREIGN KEY (isbnBookId) REFERENCES books(isbn13)
);

CREATE TABLE Genre (
    genreId int,
    genreName nvarchar(50),
    isbnBookId nvarchar(50),
    CONSTRAINT PK_genre PRIMARY KEY (genreId, genreName),
    CONSTRAINT FK_book_genre FOREIGN KEY (isbnBookId) REFERENCES books(isbn13)
);


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

create table customerOrders (
    orderId int primary key,
    orderDetailId int,
    customerId int,
    orderDate date,
    shippedDate date,
    shippedAddress nvarchar(100),
    shippedCity nvarchar(100),
    shippedPostalCode nvarchar(100)
)

create table orderDetails(
    orderDetailId int primary key,
    orderId int,
    isbnBookId nvarchar(50),
    unitPrice float,
    quantity float,
    constraint FK_order_books foreign key (isbnBookId) references books(isbn13)
)

create table customerDetails(
    customerId int primary key,
    orderId int,
    shippedAddress nvarchar(100),
    shippedCity nvarchar(100),
    shippedPostalCode nvarchar(100),
    phoneNumber nvarchar(50),
    email nvarchar(100),
    constraint FK_customer_order foreign key (orderId) references customerOrders(orderId)
)

GO
create view titlePerAuthor
as
    select
        concat(a.firstname,' ', a.lastname) as 'Name',
        case 
        when a.deathdate is null then DATEDIFF(year, birthdate, GETDATE())
        else DATEDIFF(year, birthdate, a.deathdate)
    end as 'Age',
        sum(i.totalAvailable) as 'Inventory Total',
        concat(count(distinct b.isbn13), ' st') as 'Books Titles',
        concat(sum(i.totalAvailable * b.price_$), ' Kr') as 'Price value'
    from
        ai22.dbo.authors a
        join dbo.author_books ab on ab.authorId = a.id
        join dbo.books b on b.isbn13 = ab.isbn13
        join dbo.inventory i on i.isbnBookId = b.isbn13
    group by 
    a.firstname, a.lastname, a.birthdate, a.deathdate
GO


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
        where storeId = @fromStoreId and isbnBookId = @isbn and totalAvailable >= @quantity
    )
    begin
        begin tran
        update inventory
        set totalAvailable = totalAvailable - @quantity
        where storeId = @fromStoreId and isbnBookId = @isbn
        
        if @@ROWCOUNT = 0
        begin
            rollback
            raiserror ('Failed to move books. The providing store does not have enough stock of the specified book.', 16, 1)
            return
        end
        if exists (
            select *
            from inventory
            where storeId = @toStoreId and isbnBookId = @isbn
        )
        begin
            update inventory
            set totalAvailable = totalAvailable + @quantity
            where storeId = @toStoreId AND isbnBookId = @isbn
        end
        else
        begin
            insert into inventory (storeId, isbnBookId, totalAvailable)
            values (@toStoreId, @isbn, @quantity)
        end
        
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

create view publisherInfo
as
select top 11
    p.publisherName,
    sales.Sold,
    (sales.Revenue * sales.sold) as 'Revenue'
from Publisher p
join (
    select 
        p.isbnBookId,
        bs.name as StoreName,
        COUNT(distinct co.customerId) as Sold,
        od.unitPrice as Revenue
    from orderDetails od
    join customerOrders co on co.orderId = od.orderId
    join bookStores bs on bs.id = co.storeId
    join books b on b.isbn13 = od.isbnBookId
    join Publisher p on p.isbnBookId = b.isbn13
    group by p.isbnBookId, bs.name, od.unitPrice
) sales on sales.isbnBookId = p.isbnBookId
order by sales.Revenue desc;

GO

select * from orderDetails
select * from customerDetails
select * from customerOrders
select * from publisher

drop view publisherInfo
select * from publisherInfo

--Example:
-- EXEC MoveBooks 1, 3, '978-0141439518', 1

select * from Publisher

-- select top 11
--     p.publisherName,
--     sales.Sold,
--     (sales.Revenue * sales.sold) as 'Revenue'
-- from Publisher p
-- join (
--     select 
--         p.isbnBookId,
--         bs.name as StoreName,
--         COUNT(distinct co.customerId) as Sold,
--         od.unitPrice as Revenue
--     from orderDetails od
--     join customerOrders co on co.orderId = od.orderId
--     join bookStores bs on bs.id = co.storeId
--     join books b on b.isbn13 = od.isbnBookId
--     join Publisher p on p.isbnBookId = b.isbn13
--     group by p.isbnBookId, bs.name, od.unitPrice
-- ) sales on sales.isbnBookId = p.isbnBookId
-- order by sales.Revenue desc;