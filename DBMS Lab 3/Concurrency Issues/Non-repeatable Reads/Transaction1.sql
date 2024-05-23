use DBMS_Lab_3

-- prerequisites
delete from Rings

insert into Rings values ('Ring')
begin tran
waitfor delay '00:00:05'
update Rings set [name]='New' where [name]='Ring'
commit tran