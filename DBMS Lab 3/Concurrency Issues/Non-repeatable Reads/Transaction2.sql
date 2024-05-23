use DBMS_Lab_3

set transaction isolation level read committed
begin tran
select * from Rings
waitfor delay '00:00:05'
select * from Rings
commit tran

-- Solution: set isolation level to repeatable read. This will not allow any other transaction to modify the row after this transaction reads it
