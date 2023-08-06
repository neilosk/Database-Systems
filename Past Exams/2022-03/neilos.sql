-- (a) There are 2,586 tests that have detected the ‘delta’ variant. How many tests have
-- detected the ‘omicron’ variant?
	select count(*)
	from Tests T
	join Variants V on V.ID = T.variantID
	where V.name = 'omicron';
	
-- (b) There are 6 variants with an unknown risk level. How many variants have never been
-- detected with a test?
	select count(*)
	from Variants V
	left join Tests T on T.variantID = V.ID
	where T.variantID is null;
	
-- (c) How many di↵erent variants of the ‘extreme’ risk level have been detected in 2021
-- by a tester called ‘Kent Lauridsen’ using a kit produced by ‘JJ’?
	select count(distinct V.ID)
	from Tests T
	join Variants V on V.ID = T.variantID
	join Risks R on R.id = V.riskID
	join Kits K on K.id = T.kitID
	join Testers TS on TS.id = T.testerID
	where R.level = 'extreme'
	and extract(year from T.time) = 2021
	and TS.name = 'Kent Lauridsen'
	and K.producer = 'JJ';
-- (d) There are 7 variants that can be detected by some kit with at least 80% accuracy.
-- How many variants cannot be detected by any kit with more than 50% accuracy?
	select count(distinct D.variantID)
	from Detects D
	where D.variantID not in (
	select distinct D2.variantID
	from Detects D2
	where D2.accuracy >= 50
	)
	

	
-- (e) The best average accuracy for any kit is about 59.89%. What is the lowest average
-- accuracy for any variant which is detected by more than one kit?
	select max(average)
	from (
	select D.kitID ID, avg(D.accuracy) as average
	from Detects D
	group by D.kitID
	)X;
	
	select min(average)
	from (
	select D.variantID ID, avg(D.accuracy) as average
	from Detects D
	group by D.variantID
	having count(D.variantID) > 1
	)X;



-- (f) The tester with ID = 68 has performed 287 tests. What is the ID of the tester that
-- has performed the most tests with the kit produced by ‘JJ’?
-- Note: The output of this query is a single identifier. The query must be written to
-- return the correct results, however, even if there were two testers tied with the most
-- tests.
	drop view if exists Testcount;
	create view testcount 
	as
	select T.testerID, count(*) as tests, K.producer as producer
	from Tests T
	join Kits K on K.id = T.kitID
	group by T.testerID, K.producer;
	
	select TC.testerID
	from testcount TC
	where TC.producer = 'JJ'
	and TC.tests = (
	select max(T2.tests)
		from Testcount T2
		where T2.producer = 'JJ'
	);
-- (g) There are 3 testers that have detected all variants with a known risk level. How
-- many testers have detected all variants with risk level ‘mild’?
	select count(*)
	from(
	select T.testerID, count(distinct T.variantID)
	from Tests T
	join Variants V on V.ID = T.variantID
	join Risks R on R.ID = V.riskID
	where R.level = 'mild'
	group by T.testerID
	having count(distinct T.variantID) = (
		select count(*)
		from Variants V
			join Risks R on R.id = V.riskID
		where R.level = 'mild')
	 )X;
-- Note: This is a division query; points will only be awarded if division is attempted.

-- (h) Write a query that returns the timestamp for the last time a detection was made
-- of a variant with risk level ‘extreme’ using a kit that has < 10% accuracy for that
-- variant.
-- Note: The output of this query is a single timestamp. It may be copied directly with
-- or without quotes.
	select max(T.time)
	from Tests T
	join Variants V on V.ID = T.variantID
	join Risks R on R.id = V.riskID
	join Kits K on K.ID = T.kitID
	join Detects D on K.ID = D.kitID and D.variantID = V.ID
	where  R.level = 'extreme'
	and D.accuracy < 10
	;