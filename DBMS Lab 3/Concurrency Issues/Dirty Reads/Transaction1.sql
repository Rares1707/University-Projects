use DBMS_Lab_3

-- prerequisite
delete from Rings
insert into Rings values ('Ring')

begin transaction
update Rings set [name]='New' where [name]='Ring'
waitfor delay '00:00:5'
rollback transaction
