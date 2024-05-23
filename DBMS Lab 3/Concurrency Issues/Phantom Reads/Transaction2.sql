use DBMS_Lab_3

set transaction isolation level repeatable read
begin tran
select * from Rings
waitfor delay '00:00:05'
select * from Rings
commit tran

-- Solution: set the isolation level to serializable