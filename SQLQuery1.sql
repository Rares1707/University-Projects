create Table Region(
region_id INT primary key,
region_name VARCHAR(20),
)

---------------------------------------------------------------------

create Table Cities(
city_id INT primary key,
number_of_citizens INT,
region VARCHAR(20),
ruling_race VARCHAR(20),
--ruler_id VARCHAR(20)
);

alter Table Cities
drop column region

alter Table Cities
add region_id INT foreign key references Region(region_id)

alter Table Cities
add city_name VARCHAR(20)

------------------------------------------------------------------

create Table Living_Entities(
living_entity_id INT primary key,
living_entity_name VARCHAR(20),
race VARCHAR(20),
birth_date DATE,
city_id INT foreign key references Cities(city_id),
is_alive BIT,
killer_id INT foreign key references Living_Entities(
living_entity_id)
);

alter Table Living_Entities
drop CONSTRAINT FK__Living_En__kille__3A81B327

alter Table Living_Entities
drop column killer_id

------------------------------------------------------------

create Table Child_Parent(
parent_id INT foreign key references Living_Entities(
living_entity_id),
child_id INT foreign key references Living_Entities(
living_entity_id),
unique(parent_id, child_id)
);

---------------------------------------------------------------

create Table Swords(
sword_id INT primary key,
sword_name INT,
maker VARCHAR(20)
);

alter Table Swords
drop column maker

alter Table Swords
add maker_id INT foreign key references Living_Entities(living_Entity_id)

---------------------------------------------------------------

create Table Rings(
ring_id INT primary key,
ring_name INT,
belongs_to VARCHAR(10),
constraint belonging_constraint CHECK (belongs_to in ('Elves', 'Dwarves', 'Men', 'Sauron'))
);

alter Table Rings
drop column ring_name

alter Table Rings
add ring_name VARCHAR(20)

alter Table Rings
drop constraint belonging_constraint

alter Table Rings
add constraint belonging_constraint CHECK (belongs_to in ('Elves', 'Dwarves', 'Humans', 'Sauron'))

--............................................................................................

create Table Rivers(
river_id INT primary key,
river_name VARCHAR(20),
origin VARCHAR(20)
)

alter Table Rivers
add region_id INT foreign key references Region(region_id)

--............................................................................................

alter Table Cities
add region_id INT foreign key references Region(region_id)

create Table Woods
(
wood_id INT primary key,
wood_name VARCHAR(20),
region_id INT foreign key references Region(region_id)
)

create Table Sea
(
sea_id INT primary key,
sea_name VARCHAR(20),
region_id INT foreign key references Region(region_id),
maximum_depth INT
)

create Table Higher_Beings
(
being_id INT primary key,
being_name VARCHAR(20),
type_of_being VARCHAR(10),
main_title VARCHAR(20),
constraint type_constraint CHECK( type_of_being IN ('Valar', 'Maiar'))
)

create Table Bears
(
bearer_id INT foreign key references Living_Entities(living_entity_id),
ring_id INT foreign key references Rings(ring_id),
unique(bearer_id, ring_id),
starting_date DATE,
ending_date DATE,
--constraint date_constraint CHECK( SELECT COUNT (SELECT bearer_id FROM Bears WHERE 
--(starting_date NOT BETWEEN Bears.starting_date AND Bears.ending_date) AND 
--(ending_date NOT BETWEEN Bears.starting_date AND Bears.ending_date) FROM Bears)
--)
)