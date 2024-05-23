use DBMS_Lab_3

go
create or alter procedure InsertIntoTables 
	@beingName varchar(50), @beingRace varchar(20), @ringName varchar(50) AS
begin
	declare @readyForInsertingIntoTheRelation bit = 1

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

		insert into Beings([name], race) values (@beingName, @beingRace);
		declare @beingId int = scope_identity()

		commit tran
		select 'Transaction committed (inserted into Beings)'
	end try
	begin catch
		rollback tran
		set @readyForInsertingIntoTheRelation = 0
		select 'Transaction rolled back (did not insert into Beings'
	end catch


	begin tran
	begin try
		if (dbo.nameIsValid(@ringName) <> 1)
		begin
			raiserror('Ring name does not start with an uppercase letter', 14, 1)
		end
		
		insert into Rings([name]) values (@ringName)
		declare @ringId int = scope_identity()

		commit tran
		select 'Transaction committed (inserted into Rings)'
	end try
	begin catch
		rollback tran
		set @readyForInsertingIntoTheRelation = 0
		select 'Transaction rolled back (did not insert into Rings'
	end catch

	-- seems wrong
	begin tran
	begin try
		if (@readyForInsertingIntoTheRelation <> 1)
		begin
			raiserror('One of the previous inserts did not work', 14, 1)
		end
		insert into Bears(being_id, ring_id) values (@beingId, @ringId);
		commit tran
		select 'Transaction committed (inserted into relation)'
		end try
	begin catch
		rollback tran
		select 'Transaction rolledback (did not insert into relation)'
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

-- tests for unfortunate scenario:
-- first test (first and third transactions fail)
delete from Bears
delete from Beings
delete from Rings

select * from Beings
select * from Rings
select * from Bears
exec InsertIntoTables 'being', 'Human', 'Ring'
select * from Beings
select * from Rings
select * from Bears

-- second test (second and third transactions fail)
delete from Bears
delete from Beings
delete from Rings

select * from Beings
select * from Rings
select * from Bears
exec InsertIntoTables 'Being', 'Human', 'ring'
select * from Beings
select * from Rings
select * from Bears
