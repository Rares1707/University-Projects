use DBMS_Lab_3

go
create or alter function raceIsValid (@race varchar(20)) returns int as
begin
	declare @raceIsValid bit
	set @raceIsValid = 0
	if(@race IN ('Elf', 'Human', 'Orc', 'Hobbit', 'Dwarf'))
		set @raceIsValid = 1
	return @raceIsValid
END

go
create or alter function nameIsValid (@name varchar(50)) returns int as
begin
	declare @nameIsValid bit
	set @nameIsValid = 0
	if(@name collate Latin1_General_BIN like '[A-Z]%')
		set @nameIsValid = 1
	return @nameIsValid
END
go