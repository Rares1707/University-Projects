

-- a. modify the type of a column;
CREATE PROCEDURE ModifySeaName AS
	ALTER TABLE Sea
	ALTER COLUMN Sea_name CHAR(20)
GO
	ALTER TABLE Sea
	ALTER COLUMN Sea_name VARCHAR(20)
GO