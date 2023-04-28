--1. Företagets totala produktkatalog består av 77 unika produkter.
--Om vi kollar bland våra ordrar, hur stor andel av dessa produkter
--har vi någon gång leverarat till London?

select
    -- od.ProductId as 'Order Id',
    -- string_agg(p.productname, ', ') as 'Product names',
    -- string_agg(od.ProductId, ', ') as 'Product Ids',
    -- string_agg(od.Quantity , ', ')
    --  as 'Quantity of orders',
    -- sum(od.Quantity) as 'Sum of orders',
    count(distinct od.productid)
from
    company.order_details od
    left join company.orders o on od.OrderId = o.id
    left join company.products p on p.Id = od.ProductId
where o.ShipCity = 'London'

--   DECLARE @London_products as FLOAT = (SELECT COUNT(DISTINCT od.ProductId) FROM company.orders o JOIN company.order_details od on o.id = od.OrderId WHERE o.ShipCity = 'LONDON');
-- DECLARE @Num_products as FLOAT = (SELECT COUNT(DISTINCT od.ProductId) FROM company.order_details od)

-- PRINT(@London_products / @Num_products)


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
    -- string_agg(od.ProductId, ', ') as 'Product Ids',
    -- string_agg(p.Discontinued , ', ')
    --  as 'Discontinued',
    format(sum(od.Quantity * od.UnitPrice), '0000.#' ) as 'Total Price per product'
--format(sum(od.Quantity * od.UnitPrice *(1 - od.discoun)t), '0000.#' ) as 'Total Price per product' --add discount

from
    company.order_details od
    join company.orders o on od.OrderId = o.id
    join company.products p on p.Id = od.ProductId
where o.ShipCountry = 'Germany' and p.Discontinued = 1



--4. För vilken produktkategori har vi högst lagervärde?
select
    p.CategoryId as 'Order Id',
    c.categoryName,
    round(sum(p.UnitsInStock * p.UnitPrice), 2) as 'Total Value unit in stock'
from
    company.products p
    join company.categories c on p.CategoryId = c.id
group BY
p.CategoryId, c.CategoryName
order by 'Total Value unit in stock' desc

--5. Från vilken leverantör har vi sålt flest produkter totalt under sommaren 2013?

select *
from company.products
select *
from company.customers
select *
from company.suppliers
select *
from company.orders
where company.orders.ShipCity = 'London'
select *
from company.order_details
select *
from company.categories
select *
from company.orders
select *
from company.products
where company.products.Discontinued = 1


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
where o.OrderDate >= '2013-06-01 00:00:00' and o.OrderDate < '2013-09-01 00:00:00'--better for taking interval
group BY
s.id, s.CompanyName
order by 'Sum of products' desc

-- SELECT TOP 1
--     s.CompanyName AS 'Supplier',
--     SUM(od.Quantity) AS 'Products Sold'
-- FROM
--     Company.Orders o
--     JOIN Company.Order_Details od ON o.ID = od.OrderID
--     JOIN Company.Products p ON od.ProductID = p.ID
--     JOIN Company.Suppliers s ON p.SupplierID = s.ID
-- WHERE
--     o.OrderDate BETWEEN '2013-06-01' AND '2013-08-31' -- arbitrarily defined summer as June, July,  August
-- GROUP BY
--     s.CompanyName,
--     s.ID -- include ID to deal with companies potentially having the same name
-- ORDER BY
--     [Products Sold] DESC;


select datepart(quarter, getdate())
--yearly quarter
select datepart(dayofyear, getdate())

--Använd dig av tabellerna från schema “music”, och utgå från:
select *
from music.albums
select *
from music.genres
where music.genres.Name = '% metal'
select *
from music.artists
select *
from music.media_types
select *
from music.playlist_track
select *
from music.playlists
select *
from music.tracks

--Table continuation
declare @searchWord nvarchar(max)
set @searchWord = 'Heavy Metal Classic'

select
    newId() as 'GUID',
    g.name as 'Genre',
    ar.Name as 'Artist',
    a.Title as 'Album',
    t.name as 'Track',
    format(dateadd(ms, t.Milliseconds, 0), 'mm:ss') as 'Length',
    CONVERT(DECIMAL(10,1), t.Bytes/POWER(1024.0,2)) AS 'Size',
    isnull(t.Composer, '-') as 'Composer'

from
    music.genres g
    join music.tracks t on t.GenreId = g.GenreId
    join music.albums a on t.AlbumId = a.AlbumId
    join music.artists ar on ar.ArtistId = a.ArtistId
    join music.playlist_track pl on pl.TrackId = t.TrackId
    join music.playlists p on p.PlaylistId = pl.PlaylistId
where p.Name = @searchWord
order by 
    newId()
-- g.name,ar.Name, t.Composer, t.Name asc

--1. Av alla audiospår, vilken artist har längst total speltid?
select
    ar.Name as 'Artist',
    format(dateadd(ms, sum(t.Milliseconds),0), 'hh:mm:ss') as 'Total time'
from
    music.genres g
    join music.tracks t on t.GenreId = g.GenreId
    join music.albums a on t.AlbumId = a.AlbumId
    join music.artists ar on ar.ArtistId = a.ArtistId
    join music.playlist_track pl on pl.TrackId = t.TrackId
    join music.playlists p on p.PlaylistId = pl.PlaylistId
where MediaTypeId != 3
group by 
    ar.Name
order by 'Total time' desc

--2. Vad är den genomsnittliga speltiden på den artistens låtar?
select
    ar.Name as 'Artist',
    format(dateadd(ms, avg(t.Milliseconds),0), 'hh:mm:ss') as 'Total time'
from
    music.genres g
    join music.tracks t on t.GenreId = g.GenreId
    join music.albums a on t.AlbumId = a.AlbumId
    join music.artists ar on ar.ArtistId = a.ArtistId
    join music.playlist_track pl on pl.TrackId = t.TrackId
    join music.playlists p on p.PlaylistId = pl.PlaylistId
where ar.Name = 'Led Zeppelin'
group by 
    ar.Name
order by 'Total time' desc

--3. Vad är den sammanlagda filstorleken för all video?

select
    format(SUM(CONVERT(DECIMAL(10, 1), t.Bytes / POWER(1024.0, 2))) / 1024.0, '00.##') AS 'Size GiB'
-- t.Name
from
    music.tracks t
    join music.media_types m on m.MediaTypeId = t.MediaTypeId
where m.Name = 'Protected MPEG-4 video file'

--4. Vilket är det högsta antal artister som finns på en enskild spellista?
select
    p.Name as 'Playlist ',
    count(distinct ar.ArtistId) as 'Count Per Playlist'
from
    music.tracks t
    right join music.albums a on t.AlbumId = a.AlbumId
    right join music.artists ar on ar.ArtistId = a.ArtistId
    right join music.playlist_track pl on pl.TrackId = t.TrackId
    right join music.playlists p on p.PlaylistId = pl.PlaylistId

group by 
    p.PlaylistId, p.Name
order by 'Count Per Playlist' desc

--5. Vilket är det genomsnittliga antalet artister per spellista?

select
    AVG(subquery.[Count Per Playlist]) as 'Average'
from
    --select subquery.* / subquery.[] from ***
    (   
    select
        p.PlaylistId,
        p.Name as 'Playlist ',
        count(distinct ar.ArtistId) as 'Count Per Playlist'
    from
        music.tracks t
        right join music.albums a on t.AlbumId = a.AlbumId
        right join music.artists ar on ar.ArtistId = a.ArtistId
        right join music.playlist_track pl on pl.TrackId = t.TrackId
        right join music.playlists p on p.PlaylistId = pl.PlaylistId

    group by 
        p.PlaylistId, p.Name
    --Caannot have an order by in a subquery
) subquery

-- Subquery is a query in a query
-- eg
select 
    tracks.trackId,
    tracks.Name,
    (select count(*) from music.genres),
    (select count(*) from music.playlist_track where TrackId = tracks.TrackId)
from 
    music.tracks

--Correction



