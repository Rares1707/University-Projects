use DBMS_Lab_3

create table Beings(
	id int identity primary key,
	[name] varchar(50),
	race varchar(20)
)

create table Rings(
	id int identity primary key,
	[name] varchar(50)
)

create table Bears(
	being_id int foreign key references Beings(id),
	ring_id int foreign key references Rings(id),
	unique (being_id, ring_id)
)