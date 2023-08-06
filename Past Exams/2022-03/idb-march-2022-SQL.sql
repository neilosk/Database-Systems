-- (a)

select count(*)
from Tests T 
	join Variants V on T.variantID = V.ID
where V.name = 'delta';
-- 2586

select count(*)
from Tests T 
	join Variants V on T.variantID = V.ID
where V.name = 'omicron';
-- 25919

-- (b)

select count(*)
from Variants V 
where V.riskID is null;
-- 6

select count(*)
from Variants V 
	left join Tests T on T.variantID = V.ID
where T.variantID is null;
-- 1

-- (c)

select count(distinct V.ID)
from Sites S 
	join Tests T on S.ID = T.siteID
	join Kits K on K.ID = T.kitID
	join Testers P on P.ID = T.testerID
	join Variants V on V.ID = T.variantID
	join Risks R on R.ID = V.riskID
where K.producer = 'JJ'
	and R.level = 'extreme'
	and extract(year from T.time) = 2021
	and P.name = 'Kent Lauridsen';
-- 1

-- (d)

select count(distinct D.variantID)
from Detects D
where D.accuracy >= 80;
-- 7

select count(*)
from Variants V
where V.ID not in (
	select distinct D.variantID
	from Detects D
	where D.accuracy >= 50
);
-- 2

-- (e)

select max(score) 
from (
	select avg(D.accuracy) as score
	from Detects D
	group by D.kitID
) X;
-- 59.8888888888888889

select min(score) 
from (
	select avg(D.accuracy) as score
	from Detects D
	group by D.variantID
	having count(*) > 1
) X;
-- 17.5000000000000000

-- (f)

drop view if exists testercount;
create view testercount
as 
select T.testerID, T.kitID, count(*) as cnt
from Tests T
group by T.testerID, T.kitID;

select sum(C.cnt)
from testercount C
where C.testerID = 68;
-- 287

select C.testerID
from testercount C
	join Kits K on C.kitID = K.ID
where K.producer = 'JJ'
	and C.cnt = (
		select max(C.cnt) 
		from testercount C
			join Kits K on C.kitID = K.ID
		where K.producer = 'JJ'
	);
-- 111

drop view if exists testercount;

-- (g)

select count(*)
from (
	select T.testerID, count(distinct T.variantID)
	from Tests T
		join Variants V on T.variantID = V.ID
	where V.riskID is not null
	group by T.testerID
	having count(distinct T.variantID) = (
		select count(*)
		from Variants V
		where V.riskID is not null
	)
) X;
-- 3

select count(*)
from (
	select T.testerID, count(distinct T.variantID)
	from Tests T
		join Variants V on T.variantID = V.ID
		join Risks R on V.riskID = R.ID
	where R.level = 'mild'
	group by T.testerID
	having count(distinct T.variantID) = (
		select count(*)
		from Variants V
			join Risks R on V.riskID = R.ID
		where R.level = 'mild'
	)
) X;
-- 155

-- (h)

select max(T.time)
from Tests T 
	join Variants V on T.variantID = V.ID
	join Kits K on T.kitID = K.ID
	join Detects D on D.kitID = K.ID and D.variantID = V.ID
	join Risks R on V.riskID = R.ID
where D.accuracy < 10
	and R.level = 'extreme';
-- "2022-12-26 12:05:00"
