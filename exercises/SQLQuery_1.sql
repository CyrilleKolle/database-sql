/*
1. Företagets totala produktkatalog består av 77 unika produkter.
*/

/*
Om vi kollar bland våra ordrar, hur stor andel av dessa produkter
*/

/*
har vi någon gång leverarat till London?
*/

select 
    o.id as 'Order Id',
    string_agg(p.productname, ', ') as 'Product names',
    string_agg(od.ProductId, ', ') as 'Product Ids',
    string_agg(od.Quantity , ', ')
     as 'Quantity of orders',
    sum(od.Quantity) as 'Sum of orders',
    o.ShipAddress as 'Addresses'
from 
    company.order_details od
    left join company.orders o on od.OrderId = o.id
    left join company.products p on p.Id = od.ProductId
where o.ShipCity = 'London'
group BY
o.id, o.ShipAddress

--2. Till vilken stad har vi levererat flest unika produkter?
select 
    o.ShipCity as 'ship city',
    string_agg(p.productname, ', ') as 'Product names',
    count(DISTINCT od.ProductId) as 'Sum of orders',
    string_agg(o.ShipAddress, ', ') as 'Addresses'
from 
    company.order_details od
    left join company.orders o on od.OrderId = o.id
    left join company.products p on p.Id = od.ProductId
group BY
o.ShipCity
order by 'Sum of orders' desc

--3. Av de produkter som inte längre finns I vårat sortiment, 
--hur mycket har vi sålt för totalt till Tyskland?

select 
    string_agg(o.id, ', ' )as 'Order Id',
    p.productname,
    -- string_agg(od.ProductId, ', ') as 'Product Ids',
    -- string_agg(p.Discontinued , ', ')
    --  as 'Discontinued',
    sum(od.Quantity) as 'Total per product',
    string_agg(o.ShipAddress, ', ') as 'Addresses'
from 
    company.order_details od
    left join company.orders o on od.OrderId = o.id
    left join company.products p on p.Id = od.ProductId
where o.ShipCountry = 'Germany' and p.Discontinued = 1
group BY
p.ProductName


--4. För vilken produktkategori har vi högst lagervärde?
select 
    p.CategoryId as 'Order Id',
    c.categoryName,
    sum(p.UnitsInStock) as 'Total unit in stock'
from 
    company.products p
    join company.categories c on p.CategoryId = c.id
group BY
p.CategoryId, c.CategoryName
order by 'Total unit in stock' desc

--5. Från vilken leverantör har vi sålt flest produkter totalt under sommaren 2013?

select * from company.products
select * from company.customers
select * from company.suppliers
select * from company.orders where company.orders.ShipCity = 'London'
select * from company.order_details
select * from company.categories
select * from company.orders 
select * from company.products where company.products.Discontinued = 1


select 
    s.id as 'supplier Id',
    s.CompanyName,
    string_agg(p.productname, ', ') as 'Product names',
    count(distinct od.ProductId) as 'Unique Products sold',
    count(distinct od.Quantity)
     as 'Distinct orders placed',
    sum(od.Quantity) as 'Sum of products'
from 
    company.suppliers s
    join company.products p on s.Id = p.SupplierId
    join company.order_details od on od.productid = p.id
    join company.orders o on o.id = od.OrderId
where o.OrderDate BETWEEN '2013-06-23' and '2013-09-22'
group BY
s.id, s.CompanyName
order by s.id


--Använd dig av tabellerna från schema “music”, och utgå från:
select * from music.albums
select * from music.genres
select * from music.artists
select * from music.media_types
select * from music.playlist_track
select * from music.playlists
select * from music.tracks where music.tracks.name = 'Killers'

select g.name,
       ar.Name,
       a.Title,
       t.name,
       t.Milliseconds,
       t.Bytes,
       t.Composer
from 
    music.genres g 
    join music.tracks t on t.GenreId = g.GenreId
    join music.albums a on t.AlbumId = a.AlbumId
    inner join music.artists ar on ar.ArtistId = a.ArtistId
where g.Name = 'Heavy Metal' or g.name = 'Metal'   
order by 
    g.name asc, t.Milliseconds desc