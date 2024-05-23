use DBMS_Lab_3

-- this transaction will work on a snapshot of the database as it existed at the start of the transaction
set transaction isolation level snapshot
begin tran 
waitfor delay '00:00:5'
update Rings set [name]='R2'
commit tran
