use DBMS_Lab_3

-- prerequisites
delete from Rings

begin tran
waitfor delay '00:00:05'
insert into Rings values ('Ring')
commit tran