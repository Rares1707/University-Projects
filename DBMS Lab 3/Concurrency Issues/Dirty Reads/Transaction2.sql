use DBMS_Lab_3

set transaction isolation level read uncommitted
begin tran
select * from Rings
waitfor delay '00:00:5'
select * from Rings
commit tran

--solution: set the isolation level to read committed