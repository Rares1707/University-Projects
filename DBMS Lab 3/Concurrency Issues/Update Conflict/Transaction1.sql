use DBMS_Lab_3

-- prerequisites
ALTER DATABASE DBMS_Lab_3 SET ALLOW_SNAPSHOT_ISOLATION ON 
delete from Rings
insert into Rings values ('Ring')

waitfor delay '00:00:05'
begin tran
update Rings set [name]='R1'
waitfor delay '00:00:05'
commit tran