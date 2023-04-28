--1. Företagets totala produktkatalog består av 77 unika produkter. 
--Om vi kollar bland våra ordrar, hur stor andel av dessa produkter 
--har vi någon gång leverarat till London?

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

select * from company.products
select * from company.customers
select * from company.orders where company.orders.ShipCity = 'London'
select * from company.order_details
select * from company.categories
select * from company.orders 


select * from company.products where company.products.Discontinued = 1

select 
    p.CategoryId as 'Order Id',
    c.categoryName,
    sum(p.UnitsInStock) as 'Total unit in stock'
from 
    company.products p
    join company.categories c on p.CategoryId = c.id
    join company.order_details od on p.Id = od.ProductId
group BY
p.CategoryId, c.CategoryName
order by 'Total unit in stock' desc