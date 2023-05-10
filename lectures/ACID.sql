select * from users2
select * into usersDemo from users2

--without a begin transaction this transaction cant be rolled back if we regret the decision
-- delete from usersDemo where FirstName like '%b'
-- ROLLBACK

begin TRANSACTION

delete from usersDemo where FirstName like 'c%'

ROLLBACK

commit  

select * from usersDemo