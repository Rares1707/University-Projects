
INSERT INTO Region (region_id, region_name) VALUES (1, 'Gondor')
INSERT INTO Region (region_id, region_name) VALUES (2, 'Mordor'), (3, 'Rohan'), (4, 'Beleriand'), 
(5, 'Eriador'), (6, 'Rhun'), (7, 'Rhovanion')


INSERT INTO Cities (city_id, city_name, number_of_citizens, ruling_race, region_id) VALUES 
(1, 'Minas Tirith', 20000, 'Humans', 1), (2, 'Minas Morgul', 1000, 'Nazgul', 2),
(3, 'Moria', 0, 'Dwarves', 5), (4, 'Hobbiton', 400, 'Hobbits', 5), (5, 'Edoras', 10000, 'Humans', 3)
INSERT INTO Cities (city_id, city_name, number_of_citizens, ruling_race, region_id) VALUES 
(6, 'Rivendell', 3000, 'Elves', 5)
INSERT INTO Cities (city_id, city_name, number_of_citizens, ruling_race, region_id) VALUES 
(7, 'Erebor', 1500, 'Dwarves', 7)



INSERT INTO Living_Entities(living_entity_id, living_entity_name, race, birth_date, city_id, is_alive) VALUES
(1, 'Bilbo Baggins', 'Hobbit', '2890-09-22', 6, 1)
INSERT INTO Living_Entities(living_entity_id, living_entity_name, race, birth_date, city_id, is_alive) VALUES
(2, 'Frodo Baggins', 'Hobbit', '2968-09-22', 6, 1)
INSERT INTO Living_Entities(living_entity_id, living_entity_name, race, birth_date, city_id, is_alive) VALUES
(3, 'Aragorn', 'Human', '2931-03-1', 1, 1)
INSERT INTO Living_Entities(living_entity_id, living_entity_name, race, birth_date, city_id, is_alive) VALUES
(4, 'Gimli', 'Human', '2879-05-19', 7, 1)
INSERT INTO Living_Entities(living_entity_id, living_entity_name, race, birth_date, city_id, is_alive) VALUES
(5, 'Elrond', 'Elf', '1-01-01', 6, 1)
INSERT INTO Living_Entities(living_entity_id, living_entity_name, race, birth_date, city_id, is_alive) VALUES
(6, 'Grima', 'Human', '2981-04-10', 3, 0)
INSERT INTO Living_Entities(living_entity_id, living_entity_name, race, birth_date, city_id, is_alive) VALUES
(7, 'Boromir', 'Human', '2978-03-1', 1, 0)
INSERT INTO Living_Entities(living_entity_id, living_entity_name, race, birth_date, city_id, is_alive) VALUES
(8, 'Smeagol', 'Hobbit', '2430-08-20', null, 0)
INSERT INTO Living_Entities(living_entity_id, living_entity_name, race, birth_date, city_id, is_alive) VALUES
(9, 'Legolas', 'Elf', '2500-07-03', 6, 1)

DELETE FROM Living_Entities WHERE living_entity_name = 'Gimli' OR living_entity_name = 'Boromir';
DELETE FROM Living_Entities WHERE living_entity_name IN( 'Gimli', 'Boromir');
DELETE FROM Living_Entities WHERE city_id IS NULL;
DELETE FROM Living_Entities WHERE living_entity_name LIKE 'A%';
DELETE FROM Cities WHERE number_of_citizens < 500;
DELETE FROM Cities WHERE number_of_citizens BETWEEN 500 AND 2000;

INSERT INTO Rings(ring_id, ring_name, belongs_to) VALUES
(1, 'The One Ring', 'Sauron'), (2, 'Vilya', 'Elves'), (3, '', 'Humans')

INSERT INTO Bears(bearer_id, ring_id, starting_date, ending_date) VALUES
(5, 2, '1981-02-23', null), (8, 1, '2463-11-09', '2941-05-21'), 
(1, 1, '2941-05-21', '3001-09-22'), (2, 1, '3001-09-22', '3019-03-25')
INSERT INTO Bears(bearer_id, ring_id, starting_date, ending_date) VALUES
(2, 1, '3001-09-22', '3019-03-10')

INSERT INTO Bears(bearer_id, ring_id, starting_date, ending_date) VALUES
 (1, 2, '3001-09-24', '3019-03-25')
 DELETE FROM Bears WHERE bearer_id = 1 AND ring_id = 2

 SELECT * FROM Bears

INSERT INTO Child_Parent(parent_id, child_id) VALUES
(1, 2)


-- DELETEs and UPDATEs
DELETE FROM CHILD_PARENT WHERE parent_id = 2;
DELETE FROM Living_Entities WHERE living_entity_id = 2;
INSERT INTO Living_Entities(living_entity_id, living_entity_name, race, birth_date, city_id, is_alive) VALUES
(2, 'Frodo Baggins', 'Hobbit', '2968-09-22', 4, 1)
DELETE FROM Living_Entities WHERE living_entity_id = 4;
INSERT INTO Living_Entities(living_entity_id, living_entity_name, race, birth_date, city_id, is_alive) VALUES
(4, 'Gimli', 'Dwarf', '2879-05-19', 7, 1)
DELETE FROM Living_Entities WHERE living_entity_name = 'Grima'
INSERT INTO Living_Entities(living_entity_id, living_entity_name, race, birth_date, city_id, is_alive) VALUES
(6, 'Grima', 'Human', '2981-04-10', 5, 0)

UPDATE Living_Entities SET race = 'Hobbit' WHERE living_entity_name = 'Gimli'
UPDATE Living_Entities SET race = 'Dwarf' WHERE living_entity_name = 'Gimli'
UPDATE Cities SET number_of_citizens = '18000' WHERE city_name = 'Minas Tirith'
UPDATE Cities SET number_of_citizens = '20000' WHERE city_name = 'Minas Tirith'
UPDATE Cities SET number_of_citizens = '18000' WHERE city_name = 'Minas Tirith'
UPDATE Bears SET ending_date = '3019-03-05' WHERE bearer_id = 2;
UPDATE Bears SET ending_date = '3019-03-25' WHERE bearer_id = 2;

SELECT * FROM Region
SELECT * FROM Cities
SELECT * FROM Living_Entities
SELECT * FROM Rings
SELECT * FROM Bears


--a. 2 queries with the union operation; use UNION [ALL] and OR;
SELECT living_entity_name AS 'Name'
FROM Living_Entities
UNION
SELECT region_name
FROM Region
UNION
SELECT city_name
FROM Cities
UNION
SELECT ring_name
FROM Rings;

SELECT living_entity_name AS 'Little people'
FROM Living_Entities
WHERE race = 'Hobbit' OR race = 'Dwarf'
ORDER BY birth_date;


--b. 2 queries with the intersection operation; use INTERSECT and IN;
SELECT living_entity_name AS 'Humans alive'
FROM Living_Entities
WHERE is_alive = 1
INTERSECT
SELECT living_entity_name 
FROM Living_Entities
WHERE race = 'Human';

SELECT living_entity_name AS 'Little people'
FROM Living_Entities
WHERE race IN ('Hobbit', 'Dwarf');


--c. 2 queries with the difference operation; use EXCEPT and NOT IN;
SELECT living_entity_name AS 'Humans dead'
FROM Living_Entities
WHERE race = 'Human'
EXCEPT
SELECT living_entity_name 
FROM Living_Entities
WHERE is_alive = 1;

SELECT TOP 3 living_entity_name AS 'Big people'
FROM Living_Entities
WHERE race NOT IN ('Hobbit', 'Dwarf')
ORDER BY birth_date DESC;


--d. 4 queries with INNER JOIN, LEFT JOIN, RIGHT JOIN, and FULL JOIN (one query per operator); 
-- one query will join at least 3 tables, while another one will join at least two many-to-many relationships;
SELECT L.living_entity_name, C.city_name
FROM Living_Entities L 
LEFT JOIN Cities C on L.city_id = C.city_id;

-- (3 tables)
SELECT L.living_entity_name, C.city_name, R.region_name
FROM Living_Entities L 
RIGHT JOIN Cities C on L.city_id = C.city_id
RIGHT JOIN Region R on C.region_id = R.region_id;

SELECT R.ring_name, L.living_entity_name
FROM Rings R
FULL JOIN Bears B on R.ring_id = B.ring_id
FULL JOIN Living_Entities L on B.bearer_id = L.living_entity_id;

-- (parents and children who bore the same ring) (2 many to many relationships)
SELECT R.ring_name, L.living_entity_name AS 'Parent name', L2.living_entity_name AS 'Child name'
FROM Rings R
INNER JOIN Bears B on R.ring_id = B.ring_id
INNER JOIN Living_Entities L on B.bearer_id = L.living_entity_id
INNER JOIN Child_Parent CP on CP.child_id = L.living_entity_id
INNER JOIN Living_Entities L2 on CP.child_id = L2.living_entity_id;


-- e. 2 queries with the IN operator and a subquery in the WHERE clause; 
-- in at least one case, the subquery must include a subquery in its own WHERE clause;

-- people who live in human cities
SELECT living_entity_name
FROM Living_Entities 
WHERE city_id IN (
	SELECT city_id
	FROM Cities 
	WHERE ruling_race = 'Humans');

-- people who live in a city where the number of citizens is above 500 but still below average  
SELECT living_entity_name
FROM Living_Entities 
WHERE city_id IN (
	SELECT city_id
	FROM Cities 
	WHERE number_of_citizens > 500 AND number_of_citizens < (
		SELECT AVG(number_of_citizens)
		FROM Cities
		) 
	);


-- f. 2 queries with the EXISTS operator and a subquery in the WHERE clause;

-- (regions where there are cities)
SELECT region_name
FROM Region R
WHERE EXISTS (
	SELECT C.city_id
	FROM Cities C
	WHERE C.region_id = R.region_id
	); 

-- (people who bore a ring)
SELECT L.living_entity_name
FROM Living_Entities L
WHERE EXISTS (
	SELECT B.bearer_id
	FROM Bears B 
	WHERE b.bearer_id = L.living_entity_id
	);


-- g. 2 queries with a subquery in the FROM clause;       

-- the average number of citizens of each region, but we exclude the big cities
SELECT R.region_name, AVG(t.number_of_citizens) AS 'Average number of citizens'
FROM 
	(SELECT C.number_of_citizens, C.region_id
	FROM Cities C WHERE C.number_of_citizens < 10000) t
		INNER JOIN Region R ON R.region_id = t.region_id
	GROUP BY R.region_name
	ORDER BY AVG(t.number_of_citizens);
	
-- people who stopped bearing The One Ring after a certain year
SELECT L.living_entity_name
FROM 
	(SELECT bearer_id, ring_id
	FROM Bears WHERE ending_date >= '3000-01-01' AND ring_id = '1') t
	INNER JOIN Living_Entities L on t.bearer_id = L.living_entity_id
	INNER JOIN Rings R on t.ring_id = R.ring_id;


-- h. 4 queries with the GROUP BY clause, 3 of which also contain the HAVING clause; 
-- 2 of the latter will also have a subquery in the HAVING clause; 
-- use the aggregation operators: COUNT, SUM, AVG, MIN, MAX;

SELECT TOP 50 PERCENT AVG(C.number_of_citizens) as 'Average number of citizens', C.ruling_race
FROM Cities C
GROUP BY C.ruling_race
ORDER BY AVG(C.number_of_citizens) DESC;

SELECT AVG(C.number_of_citizens) as 'Average number of citizens' , C.ruling_race
FROM Cities C
GROUP BY C.ruling_race
HAVING COUNT(C.number_of_citizens) > 1

-- average num of citizens by race, but we exclude the races with dead city-dwellers
-- (in a real data-base we could exclude the ones with casualty count above a certain number)
SELECT AVG(C.number_of_citizens) as 'Average number of citizens' , C.ruling_race
FROM Cities C
GROUP BY C.ruling_race
HAVING C.ruling_race IN 
	(SELECT C2.ruling_race
	FROM Living_Entities L
	INNER JOIN Cities C2 on C2.city_id = L.city_id
	WHERE L.is_alive = 1);

-- total number of citizens of regions with more than one city
SELECT SUM(C.number_of_citizens), C.region_id
FROM Cities C
GROUP BY C.region_id
HAVING C.region_id IN (
	SELECT region_id
	FROM 
		(SELECT COUNT (C.region_id) AS filter, region_id
		FROM CITIES C
		GROUP BY C.region_id) t
	WHERE t.filter > 1);

-- 4 queries using ANY and ALL to introduce a subquery in the WHERE clause (2 queries per operator);
-- rewrite 2 of them with aggregation operators, and the other 2 with IN / [NOT] IN.

-- names of ring bearers
SELECT L.living_entity_name
FROM Living_Entities L
WHERE L.living_entity_id = 
	ANY (SELECT B.bearer_id
	FROM Bears B);

SELECT L.living_entity_name
FROM Living_Entities L
WHERE L.living_entity_id IN (SELECT B.bearer_id
	FROM Bears B);

--name and birthdate of entities older than the youngest elf
SELECT L.living_entity_name, L.birth_date
FROM Living_Entities L
WHERE L.birth_date < 
	ANY (SELECT L2.birth_date
	FROM Living_Entities L2 
	WHERE L2.race = 'Elf');

SELECT L.living_entity_name, L.birth_date
FROM Living_Entities L
WHERE L.birth_date < 
	(SELECT MAX(L2.birth_date)
	FROM Living_Entities L2
	WHERE L2.race = 'Elf');



-- names of people with no children
SELECT L.living_entity_name
FROM Living_Entities L
WHERE L.living_entity_id != 
	ALL (SELECT CP.parent_id
	FROM Child_Parent CP)

SELECT L.living_entity_name
FROM Living_Entities L
WHERE L.living_entity_id NOT IN (SELECT CP.parent_id
	FROM Child_Parent CP)

-- smallest city (excluding hobbits and nazgul cities) which is not abandoned
SELECT city_name
FROM Cities C
WHERE C.ruling_race NOT IN ('Nazgul', 'Hobbits') AND C.number_of_citizens > 0 AND C.number_of_citizens <= 
	  ALL (SELECT C2.number_of_citizens
		FROM Cities C2
		WHERE C2.ruling_race NOT IN ('Nazgul', 'Hobbits') AND C2.number_of_citizens > 0);


SELECT city_name
FROM Cities C
WHERE C.ruling_race NOT IN ('Nazgul', 'Hobbits') AND C.number_of_citizens = 
	  (SELECT MIN(C2.number_of_citizens)
		FROM Cities C2
		WHERE C2.ruling_race NOT IN ('Nazgul', 'Hobbits') AND C2.number_of_citizens > 0);

-- 3 queries with DISTINCT
SELECT DISTINCT C.city_name
FROM Living_Entities L
INNER JOIN Cities C ON L.city_id = C.city_id;

SELECT DISTINCT race
FROM Living_Entities;

SELECT DISTINCT R.ring_name
FROM Rings R
JOIN Bears B ON R.ring_id = B.ring_id;

-- 3 queries with arithmetic expressions
SELECT 
	(SELECT C1.number_of_citizens
	FROM Cities C1
	WHERE C1.city_name = 'Minas Tirith') - 
	(SELECT C2.number_of_citizens
	FROM Cities C2
	WHERE C2.city_name = 'Minas Morgul');

SELECT C1.city_name
FROM Cities C1
WHERE C1.number_of_citizens > 2 * 
	(SELECT AVG(C2.number_of_citizens)
	FROM Cities C2);

SELECT
	(SELECT SUM(C1.number_of_citizens)
	FROM Cities C1
	WHERE C1.ruling_race != 'Nazgul') - 
	(SELECT SUM(C2.number_of_citizens)
	FROM Cities C2
	WHERE C2.ruling_race = 'Nazgul') AS 'Difference between evil things and everyone else';

SELECT * FROM Living_Entities;
SELECT * FROM Region;
SELECT * FROM Cities;
SELECT * FROM Child_Parent;
SELECT * FROM Rings;
SELECT * FROM Bears;

