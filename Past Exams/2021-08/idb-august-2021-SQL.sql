
-- types(ID, name)
-- families(ID, typeID, name)
-- plants(ID, familyID, name)
-- people(ID, name, position)
-- parks(ID, name)
-- flowerbeds(ID, parkID, size, description)
-- plantedin(plantID, flowerbedID, percentage, planterID)

-- (a) There are 8 di↵erent plants that are missing the family information. How many
-- plants belong to the family “Thespesia”?
-- (b) Of the people in the database, 11 have not planted anything. How many of those,
-- who have not planted anything, have the position “Planter”?
-- (c) The total area of the family “Thespesia” is 66.62 (the unit is square meters; on my
-- machine, the exact number is 66.62000000000003). What is the total area of the
-- family “Vicia”?
-- Note: The result needs only be accurate to two digits after the decimal point.
-- (d) The most overfilled flowerbed is planted to 105% capacity. What are the ID(s) of the
-- flowerbed(s) with the most overfilled capacity?
-- Note: The output of this query could contain more than one identifier.
-- (e) There are 9 flowerbeds that are planted to more than 100% capacity. How many
-- flowerbeds are planted to less than 100% capacity.
-- (f) How many flowerbeds are planted to less than 100% capacity, and have a plant of
-- the type “shrub” planted in them?
-- (g) There are 354 families that are planted in at least one flowerbed in all the parks from
-- the database. How many flowerbeds have at least one plant of all types from the
-- database.
-- Note: This is a division query; points will only be awarded if division is attempted.
-- (h) Write a query that returns the ID and name of people, and the total area that they
-- have planted. The list should be restricted to people who have the position “Planter”
-- and who have planted some plant of type “flower” in the park “Kongens Have”. The
-- total area returned, however, should not have those restrictions and should represent
-- all the area planted by these people. The list should have the largest area first.
-- Note: The readability of the solution is important for this query.
-- drop view if exists alldata;
-- drop view if exists bedperc;
-- drop view if exists familycount;

-- (a)

select count(*)
from plants P
where P.familyID is null;
-- 8

select count(*)
from plants P
	join families F on F.ID = P.familyID
where M.name = 'Thespesia';
-- 18

-- (b)

select count(*)
from people E
	left join plantedin I on E.ID = I.planterID
where I.planterID is null;
-- 11

select count(*)
from people E
	left join plantedin I on E.ID = I.planterID
where I.planterID is null
	and E.position = 'Planter';
-- 9

-- (c)

select sum(1.0 * B.size * I.percentage / 100) as sqm
from families F
	join plants P on F.ID = P.familyID
	join plantedin I on P.ID = I.plantID
	join flowerbeds B on B.ID = I.flowerbedID
where F.name = 'Thespesia';
-- 66.62000000000003
-- 66.62

select sum(1.0 * B.size * I.percentage / 100) as sqm
from families F
	join plants P on F.ID = P.familyID
	join plantedin I on P.ID = I.plantID
	join flowerbeds B on B.ID = I.flowerbedID
where F.name = 'Vicia';
-- 27.3

-- (d)

drop view if exists bedperc;
create view bedperc 
as
select I.flowerbedID as ID, sum(I.percentage) as perc
from plantedin I
group by I.flowerbedID;

select max(BP.perc)
from bedperc BP;
-- 105

select BP.ID
from bedperc BP
where BP.perc = (
	select max(BP.perc)
	from bedperc BP
);
-- 243

-- (e)

select count(*)
from bedperc BP
where BP.perc > 100;
-- 9

select count(*)
from flowerbeds B
where B.ID not in (
	select BP.ID
	from bedperc BP
	where BP.perc >= 100
);
-- 273

-- (f)

select count(*)
from bedperc BP
where BP.perc < 100
 	and BP.ID in (
		select I.flowerbedID
	  	from plantedin I
	  		join plants P on I.plantID = P.ID
			join families F on P.familyID = F.ID
			join types T on F.typeID = T.ID
		where T.name = 'herb'
);
-- 150

-- (g)

select count(*)
from (
	select F.ID  --,  count(*), count(distinct B.ID), count(distinct B.parkID) -- use these for debugging
	from families F
		join plants P on F.ID = P.familyID
		join plantedin I on P.ID = I.plantID
		join flowerbeds B on B.ID = I.flowerbedID
	group by F.ID
	having count(distinct B.parkID) = (
		select count(*)
		from parks K
	) 
) X;
-- 354

select count(*)
from (
	select P.familyID  --,  count(*), count(distinct B.ID), count(distinct B.parkID) -- use these for debugging
	from plants P 
		join plantedin I on P.ID = I.plantID
		join flowerbeds B on B.ID = I.flowerbedID
	group by P.familyID
	having count(distinct B.parkID) = (
		select count(*)
		from parks K
	) 
) X;
-- 354

select count(*)
from (
	select I.flowerbedID --,  count(*), count(distinct M.ID), count(distinct M.typeID) -- use these for debugging
	from families F 
		join plants P on F.ID = P.familyID
		join plantedin I on P.ID = I.plantID
	group by I.flowerbedID
	having count(distinct F.typeID) = (
		select count(*)
		from types T
	) 
) X;
-- 2

-- (h)

create view alldata
as
select E.ID, E.name, T.name as type, K.name as park, E.position, 1.0 * B.size * I.percentage / 100 as sqm
from people E
	join plantedin I on E.ID = I.planterID
	join flowerbeds B on B.ID = I.flowerbedID
	join parks K on K.ID = B.parkID
	join plants P on P.ID = I.plantID
	join families F on F.ID = P.familyID
	join types T on T.ID = F.typeID;

select A.ID, A.name, sum(A.sqm)
from alldata A
group by A.ID, A.name
having A.ID in (
	select A2.ID
	from alldata A2
	where A2.type = 'flower'
		and A2.park = 'Kongens Have'
		and A2.position = 'Planter'
)
order by sum(A.sqm) desc;
-- First 5 rows:
-- 154	"Frank Jansen"	72.82
-- 110	"Jan Lauridsen"	72.04999999999998
-- 48	"Johan Mikaelsen"	70.41999999999999
-- 142	"Mikael Lauritz"	67.52999999999999
-- 156	"Mikael Mikaelsen"	67.47
