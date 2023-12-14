
create view view1 as select * from Higher_Beings
go

create view view2 as 
SELECT L.living_entity_name, C.city_name
FROM Living_Entities L 
LEFT JOIN Cities C on L.city_id = C.city_id
go

create view view3 as
SELECT R.region_name, AVG(t.number_of_citizens) AS 'Average number of citizens'
FROM 
	(SELECT C.number_of_citizens, C.region_id
	FROM Cities C WHERE C.number_of_citizens < 10000) t
		INNER JOIN Region R ON R.region_id = t.region_id
	GROUP BY R.region_name
go

----------------------------------------------------------------------------

DELETE FROM Bears
DELETE FROM Living_Entities
DELETE FROM Rings

exec populateRings 30000
exec populateLiving_Entities 30000
exec populateBears 30000

go
create or alter procedure populateRings (@numberOfRows INT) as
BEGIN
	declare @index INT = 1
	while @index <= @numberOfRows
	BEGIN
		insert into Rings values (@index, CONCAT('elves', @index), CONCAT('ring name', @index))
		set @index = @index + 1
	END
END
go

create or alter procedure populateLiving_Entities (@numberOfRows INT) as
BEGIN
	declare @index INT = 1
	while @index <= @numberOfRows
	BEGIN
		insert into Living_Entities values (@index, CONCAT('entity name', @index), CONCAT('race', @index), SYSDATETIME(), DEFAULT, 1)
		set @index = @index + 1
	END
END
go

create procedure populateBears (@numberOfRows INT) as
BEGIN
	declare @index INT = 1
	while @index <= @numberOfRows
	BEGIN
		insert into Bears values (@index, @index, DEFAULT, DEFAULT)
		set @index = @index + 1
	END
END
go

----------------------------------------------------------------------------

create procedure addView (@viewName varchar(100)) as
BEGIN
	if @viewName not in (select V.TABLE_NAME from INFORMATION_SCHEMA.VIEWS V) 
	BEGIN
        print 'view does not exist'
        return
    END

    if @viewName in (select Name from Views) 
	BEGIN
        print 'view is already part of the testing strucuture'
        return
    END

    insert into Views(Name) values(@viewName)
END
GO

----------------------------------------------------------------------------

exec addView 'view1'
exec addView 'view2'
exec addView 'view3'
select * from Views

----------------------------------------------------------------------------

GO
create procedure addTable (@tableName varchar(100)) as
BEGIN
	if @tableName not in (select T.TABLE_NAME from INFORMATION_SCHEMA.TABLES t) 
	BEGIN
        print 'table does not exist'
        return
    END

    if @tableName in (select T.Name from Tables T) 
	BEGIN
        print 'table is already part of the testing strucuture'
        return
    END

    insert into Tables(Name) values(@tableName)
END
GO

----------------------------------------------------------------------------

exec addTable 'Rings'
exec addTable 'Living_Entities'
exec addTable 'Bears'
select * from Tables

----------------------------------------------------------------------------

GO
create procedure addTest (@testName varchar(100)) as
BEGIN
    if @testName in (select Name from Tests) 
	BEGIN
        print 'test already exists'
        return
    END

    insert into Tests(Name) values(@testName)
END
GO

----------------------------------------------------------------------------

exec addTest firstTest
exec addTest secondTest
select * from Tests

----------------------------------------------------------------------------

create or alter procedure connectTableToTest (@tableName varchar(100), @testName varchar(100), @numberOfRows int, @position int) as
BEGIN
	if @tableName not in (select T.Name from Tables T) 
	BEGIN
        print 'table is not part of the testing structure'
        return
    END

    if @testName not in (select T.Name from Tests T) 
	BEGIN
        print 'test does not exist'
        return
    END

    insert into TestTables(TestID, TableID, NoOfRows, Position) values(
        (select T.TestID from Tests T where T.Name = @testName),
        (select T.TableID from Tables T where T.Name = @tableName), @numberOfRows, @position)
END
GO

----------------------------------------------------------------------------

exec connectTableToTest 'Rings', firstTest, 10000, 2
exec connectTableToTest 'Living_Entities', firstTest, 5000, 3
exec connectTableToTest 'Bears', firstTest, 1000, 1

exec connectTableToTest 'Rings', secondTest, 3000, 2
exec connectTableToTest 'Bears', secondTest, 3000, 1
select * from TestTables

----------------------------------------------------------------------------

create procedure connectViewToTest (@viewName varchar(100), @testName varchar(100)) as
BEGIN
	if @viewName not in (select V.Name from Views V) 
	BEGIN
        print 'view not part of the testing structure'
        return
    END

    if @testName not in (select T.Name from Tests T) 
	BEGIN
        print 'test does not exist'
        return
    END

    insert into TestViews(TestID, ViewID) values(
        (select T.TestID from Tests T where Name = @testName),
        (select V.ViewID from Views V where Name = @viewName))
END
GO

----------------------------------------------------------------------------

exec connectViewToTest view1, firstTest
exec connectViewToTest view2, firstTest
exec connectViewToTest view3, firstTest

exec connectViewToTest view1, secondTest
exec connectViewToTest view3, secondTest

select * from testViews

----------------------------------------------------------------------------


SELECT * FROM Tests
SELECT * FROM Views
SELECT * FROM TestViews
SELECT * FROM Tables
SELECT * FROM TestTables


exec uspRunTest 1

exec uspRunTest 2

SELECT * FROM TestRunTables
SELECT * FROM TestRunViews
SELECT * FROM TestRuns

DELETE FROM TestRunTables
DELETE FROM TestRunViews
DELETE FROM TestRuns


