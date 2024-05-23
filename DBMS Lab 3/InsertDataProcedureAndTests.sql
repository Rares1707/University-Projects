use DBMS_Lab_3

go
create or alter procedure InsertIntoTables 
	@beingName varchar(50), @beingRace varchar(20), @ringName varchar(50) AS
begin
	begin tran
	begin try
		if (dbo.raceIsValid(@beingRace) <> 1)
		begin
			raiserror('Race not valid', 14, 1)
		end

		if (dbo.nameIsValid(@beingName) <> 1)
		begin
			raiserror('Being name does not start with an uppercase letter', 14, 1)
		end

		if (dbo.nameIsValid(@ringName) <> 1)
		begin
			raiserror('Ring name does not start with an uppercase letter', 14, 1)
		end

		insert into Beings([name], race) values (@beingName, @beingRace);
		declare @beingId int = scope_identity()
		insert into Rings([name]) values (@ringName)
		declare @ringId int = scope_identity()
		insert into Bears(being_id, ring_id) values (@beingId, @ringId);
		commit tran
		select 'Transaction committed'
	end try
	begin catch
		rollback tran
		select 'Transaction rolled back'
	end catch
end
go

-- test for happy scenario
delete from Bears
delete from Beings
delete from Rings
select * from Beings
select * from Rings
select * from Bears
exec InsertIntoTables 'Being', 'Human', 'Ring'
select * from Beings
select * from Rings
select * from Bears

-- test for unfortunate scenario
delete from Bears
delete from Beings
delete from Rings

select * from Beings
select * from Rings
select * from Bears
exec InsertIntoTables 'being', 'Human', 'Ring'
exec InsertIntoTables 'Being', 'invalid race', 'Ring'
exec InsertIntoTables 'Being', 'Human', 'ring'
select * from Beings
select * from Rings
select * from Bears

