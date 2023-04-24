--drop table Teachers

create table Teachers (
    Id INT PRIMARY KEY,
    Name NVARCHAR(MAX) NOT NULL,
    Age INT
)

select * from Teachers

insert into Teachers VALUES(1, 'Peters', 28)
insert into Teachers VALUES(2, 'Pers', 28)
insert into Teachers VALUES(3, 'theters', 28)
insert into Teachers VALUES(4, 'lars', 28)
