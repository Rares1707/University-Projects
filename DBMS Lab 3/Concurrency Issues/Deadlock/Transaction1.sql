use DBMS_Lab_3

-- prerequisites
delete from Rings
delete from Beings
insert into Rings values ('Ring')
insert into Beings values ('Being', 'Human')

begin tran
update Rings set [name]='R1'
waitfor delay '00:00:7'
update Beings set [name]='B1'
commit tran

-- check results after running both transactions:
select * from Rings
select * from Beings