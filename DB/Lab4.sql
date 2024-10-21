
select *
from sys.objects o inner join sys.columns c ON c.object_id = o.object_id
where type = 'U'




go
create or alter procedure uspSelectView(@viewName VARCHAR(200), @testRunId INT)
AS
begin
	print('yes')
	declare @statement NVARCHAR(100) = CONCAT('select * from ', @viewName)
	declare @startAt DATETIME = SYSDATETIME()
	execute sp_executesql @statement
	declare @endAt DATETIME = SYSDATETIME()

	declare @viewId INT = (SELECT V.ViewID FROM Views V WHERE V.Name = @viewName)
	insert into TestRunViews (TestRunID, ViewID, StartAt, EndAt) VALUES (@testRunId, @viewId, @startAt, @endAt)
end
go


create or alter procedure uspRunTest(@testId INT)
AS
begin
	-- get test configuration from tables: TestViews and TestTables

	-- this will follow:
	-- iterarate over test configuration
	-- for tables delete the data, then call uspTestRunTables 
	-- for views call uspSelectView

	--prepare the tables cursor
	declare @tableId int
	declare @numberOfRows int
	declare @position int

	declare tablesCursor CURSOR SCROLL FOR SELECT T.TableID, T.NoOfRows, T.Position 
		FROM TestTables T WHERE @testId = TestID ORDER BY T.Position
	open tablesCursor

	-- position 1 means that this is the first table we will delete data from 
	-- and the last one we will insert data into

	--prepare the views cursor
	declare @viewId INT

	declare viewsCursor SCROLL CURSOR FOR SELECT ViewID FROM TestViews WHERE @testId = TestID
	OPEN viewsCursor

	-- insert row in TestRuns with startAt = SYSDATETIME() and endAt = NULL
	declare @startAt DATETIME = SYSDATETIME()
	insert into TestRuns(Description, StartAt, EndAt) values (@testId, @startAt, null)
	-- get testRunId 
	declare @testRunId int = (select T.TestRunID from TestRuns T where T.StartAt = @startAt)

	--evaluate the tables
	FETCH FIRST FROM tablesCursor INTO @tableId, @numberOfRows, @position
	while @@FETCH_STATUS = 0 --delete data from all tables
	BEGIN
		declare @tableName VARCHAR(50) = (SELECT T.Name FROM Tables T WHERE T.TableID = @tableId)
		declare @deleteStatement VARCHAR(200) = CONCAT('DELETE FROM ', @tableName)
		EXECUTE(@deleteStatement)
		FETCH NEXT FROM tablesCursor INTO @tableId, @numberOfRows, @position
	END

	FETCH LAST FROM tablesCursor INTO @tableId, @numberOfRows, @position
	while @@FETCH_STATUS = 0 --insert data into all tables
	BEGIN
		exec uspTestRunTables @testRunId, @tableId, @numberOfRows
		FETCH PRIOR FROM tablesCursor INTO @tableId, @numberOfRows, @position
	END

	--evaluate the views
	FETCH FIRST FROM viewsCursor INTO @viewId
	while @@FETCH_STATUS = 0
	BEGIN
		declare @viewName VARCHAR(200) = (SELECT V.NAME FROM Views V WHERE V.ViewID = @viewId)
		exec uspSelectView @viewName, @testRunId
		FETCH NEXT FROM viewsCursor INTO @viewId
	END

	-- update row in TestRuns with testRunId with endAt = SYSDATETIME()
	declare @endAt DATETIME = SYSDATETIME()
	update TestRuns set EndAt = @endAt where TestRunID = @testRunId

	close tablesCursor
	deallocate tablesCursor

	close viewsCursor
	deallocate viewsCursor
end

go 
create or alter procedure uspTestRunTables(@testRunId INT, @tableId INT, @numberOfRows INT)
AS
begin
 -- get Tablename based on tableId
	declare @tableName VARCHAR(100) = (SELECT T.Name FROM Tables T WHERE T.TableID = @tableId)
	declare @procedureForPopulatingTable VARCHAR(200) = concat('populate', @tableName)

	declare @startAt DATETIME = SYSDATETIME()

	exec @procedureForPopulatingTable @numberOfRows
	
	declare @endAt DATETIME = SYSDATETIME()
 -- insert row into TestRunTables
	INSERT INTO TestRunTables(TestRunID, TableID, StartAt, EndAt) VALUES (@testRunId, @tableId, @startAt, @endAt)
end
go


