
-- clustered index scan 
select L.living_entity_id from Living_Entities L where L.race = 'race20000'

-- clustered index seek because we have an index for the id due to it being the primary key
select * from Living_Entities L where L.living_entity_id = 20000

-- nonclustered index scan
select L.living_entity_name from Living_Entities L 

-- nonclustered index seek because we have an index for the name due to unique constraint
SELECT living_entity_name from Living_Entities L where L.living_entity_name = 'entity name20000'

-- key lookup
select L.is_alive from Living_Entities L where L.living_entity_name = 'entity name20000'


--b. Write a query on table Tb with a WHERE clause of the form WHERE b2 = value and analyze 
-- its execution plan. Create a nonclustered index that can speed up the query. 
-- Examine the execution plan again

-- without an index it is an index scan, otherwise it is an index seek
select R.ring_id from Rings R where R.ring_name = 'ring name2500'

create nonclustered index ring_name_index on Rings(ring_name)


-- c. Create a view that joins at least 2 tables. Check whether existing indexes are helpful; 
-- if not, reassess existing indexes / examine the cardinality of the tables.
go
create or alter view view1 as
    select L.living_entity_name, R.ring_name
    from Bears B join Living_Entities L on B.bearer_id = L.living_entity_id 
	join Rings R on B.ring_id = R.ring_id
    where R.ring_name > 'ring name200' and L.living_entity_id < 9000
go

select * from view1

-- Yes, they help. Thanks to them the query doesn't execute any scan operation.