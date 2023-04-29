--MoonMisssions

select *
from MoonMissions

select
    Spacecraft,
    [Launch date],
    [Carrier rocket],
    Operator,
    [Mission type]
into 
    SuccessfullMissions
from
    MoonMissions

GO

update SuccessfullMissions set Operator = trim(char(32) from Operator)

GO

UPDATE 
    SuccessfullMissions
SET 
    Spacecraft = trim(char(32) from REPLACE(SUBSTRING(Spacecraft, 1, CHARINDEX('(', Spacecraft)-1), ' ', ''))
WHERE
    Spacecraft 
LIKE 
    '%(%';

GO

select 
    [Mission type], 
    Operator, 
    COUNT(*) as 'Total Missions'
from 
    SuccessfullMissions
group by 
    [Mission type], 
    Operator
having 
    COUNT(*) > 1;

GO

--Users

select 
    Id,
    Username,
    password,
    concat(FirstName , ' ', LastName) as 'Name', 
    iif(substring(reverse(ID), 1,2) % 2 = 0, 'Female', 'Male') as 'Gender' ,
    Email,
    Phone
into
    NewUsers
from 
    Users 
order by 
    FirstName, LastName

GO


select 
    Username, 
    count(*) as 'Duplicate Count'
from 
    NewUsers
group by 
    username
having count(*) > 1;

GO

update 
    NewUsers
set 
    UserName = concat(left(name, 2), right(name, 2), left(id, 2))
where username in (
    select 
        username
    from 
        NewUsers
    group by
        username
    having 
        count(*) > 1
)

GO

select * from NewUsers where left(id, 2) > 70 and gender = 'Female'

GO

insert into NewUsers values('850821-3124', 'timali', newId(), 'Timbuktu Ali', 'Male', 'timali1@mail.com', '0787-0787654')

GO

select 
    gender, 
    avg(datediff(year, substring(ID, 1, 6), getdate() )) as 'Average age',
    count(*) as 'Count per Gender'
from 
    NewUsers 
group by 
    gender

GO
--Company

select 
    t.Id as 'ID',
    ProductName as 'Product',
    CompanyName as 'Suplier',
    CategoryName as 'Category'
from 
    company.products t
    join company.suppliers s on s.id = t.SupplierId
    join company.categories c on c.id = t.CategoryId

GO

select 
    t.RegionId,
    r.RegionDescription,
    count(distinct et.EmployeeId) as 'Employee Count',
    string_agg(et.EmployeeId, ', ')
    
from 
    company.regions r
    right join company.territories t on t.RegionId = r.Id   
    right join company.employee_territory et on et.TerritoryId = t.Id
group by 
    t.RegionId, r.RegionDescription
order by 
    t.RegionId

GO

select 
    e1.id,
    concat(e1.TitleOfCourtesy,char(32),e1.FirstName,char(32),e1.LastName) as 'Employee',
    isnull(cast(e2.ReportsTo as nvarchar(10)), 'Nobody') as 'Reports to'
from 
    company.employees e1
    inner join company.employees e2 on e2.id = e1.id

GO
