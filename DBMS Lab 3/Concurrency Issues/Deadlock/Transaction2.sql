use DBMS_Lab_3

begin tran
update Beings set [name]='B2'
waitfor delay '00:00:07'
update Rings set [name]='R2'
commit tran

-- Solution: lock the resources in the same order, i.e. first update the tables in the same order in both transactions

-- this would solve the problem

begin tran
update Rings set [name]='R2'
waitfor delay '00:00:05'
update Beings set [name]='B2'
commit tran