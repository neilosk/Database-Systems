-- (a) A total of 410 chefs have created at least one recipe. How many have not created
-- any recipes?
	select count(distinct C.ID)
	from chefs C 
	join recipes R on R.created_by = C.ID
	
	select count(*)
	from Chefs C
	where C.ID not in (
		select distinct C.ID
		from chefs C 
		join recipes R on R.created_by = C.ID
	)
	
-- (b) The chef ‘Foodalicious’ has mastered 56 recipes that have some ingredient(s) of type
-- ‘spice’. How many recipes that have some ingredient(s) of type ‘spice’ has the chef
-- ‘Spicemaster’ mastered?
	select count(distinct M.recipe_id)
	from master M
	join Chefs C on C.ID = chef_id
	join use U on U.recipe_id = M.recipe_id
	join ingredients I on I.id = U.ingredient_id
	where C.name = 'Foodalicious'
	and I.type = 'spice';
	
	select count(distinct M.recipe_id)
	from master M
	join Chefs C on C.ID = chef_id
	join use U on U.recipe_id = M.recipe_id
	join ingredients I on I.id = U.ingredient_id
	where C.name = 'Spicemaster'
	and I.type = 'spice';
-- (c) There are 1,257 recipes in the database with 10 or more steps registered. How many
-- recipes have 3 or fewer steps registered?

	select count(distinct S.recipe_id)
	from Steps S
	where S.step >=10;
	
	select count(distinct S.recipe_id)
	from Steps S
	where S.recipe_id not in (
	select S.recipe_id
	from Steps S
		group by S.recipe_id
	having count (distinct S.step) > 3
	)
	
	select count(*)
from recipes
where id not in (
	select S.recipe_id
	from steps S
	group by S.recipe_id
	having count(distinct S.step) > 3
);

-- (d) How many recipes belong to the same cuisine as at least one of their ingredients?
	
	select count(distinct R.id)
from recipes R
	join use U on R.id = U.recipe_id
	join belong_to B on B.ingredient_id = U.ingredient_id
where R.belong_to = B.cuisine_id;
		
	
-- (e) The recipe with name ‘Fresh Tomato Salsa Restaurant-Style’ has the most steps of
-- all recipes, or 38. What is/are the name of the recipe/s with the most different
-- ingredients of all recipes?
-- Note: The output of this query is a set of one or more recipe names.
	drop view if exists stepcount;
	create view stepcount 
	as
	select S.recipe_id, R.name as name,  count(S.step) as steps
	from steps S
	join recipes R on S.recipe_id = R.id
	group by S.recipe_id, R.name;
	
	select SC.name
	from stepcount SC
	join recipes R on SC.recipe_id = R.id
	where SC.steps = (
		select max(SC.steps)
		from stepcount SC
	)
	
	drop view if exists ingredientcount;
	create view ingredientcount 
	as
	select U.recipe_id, R.name as name,  count(U.ingredient_id) as ingredients
	from Use U
	join recipes R on U.recipe_id = R.id
	group by U.recipe_id, R.name;
	
	select IC.name
	from ingredientcount IC
	join recipes R on IC.recipe_id = R.id
	where IC.ingredients = (
		select max(IC.ingredients)
		from ingredientcount IC
	)
-- (f) We define the spice ratio of a cuisine as the number of ingredients that belong to it
-- that are of type ‘spice’ divided by the total number of ingredients that belong to the
-- cuisine. Here we consider only cuisines that actually have spices. The highest spice
-- ratio is 1.0, and this spice ratio is shared by 8 cuisines. How many cuisines share the
-- lowest spice ratio?

	drop view if exists spicyingredients;
	create view spicyingredients 
	as
	select BT.cuisine_id, count(BT.ingredient_id) as spicyingredients
	from belong_to BT
	join ingredients I on I.ID = BT.ingredient_id
	where I.type = 'spice'
	group by BT.cuisine_id;
	
	drop view if exists totalingredients;
	create view totalingredients
	as
	select BT.cuisine_id, count(BT.ingredient_id) as totalingredients
	from belong_to BT
	join ingredients I on I.ID = BT.ingredient_id
	group by BT.cuisine_id;
	
	drop view if exists spicyratio;
	create view spicyratio
	as
	select SI.cuisine_ID, (SI.spicyingredients / TI.totalingredients) as ratio
	from spicyingredients SI
	join totalingredients TI on SI.cuisine_ID = TI.cuisine_ID
	group by SI.cuisine_ID, ratio;
	
-- 	select count(*)
-- 	from spicyratio SR
-- 	where SR.ratio = (
-- 	select max(ratio)
-- 	from spicyratio SR)
	
	select count(distinct SR.cuisine_ID)
	from spicyratio SR
	where SR.ratio = (
	select min(ratio)
	from spicyratio SR
	where SR.ratio > 0)
	

	
-- (g) There are 4,169 recipes that contain some ingredient of all ingredient types. How
-- many recipes contain some ingredient of all ingredient types in the same step?
-- Note: This is a division query; points will only be awarded if division is attempted.
	select count(distinct X.recipe_id)
from (
	select U.recipe_id, U.step, count(*), count(distinct I.type)
	from use U 
		join ingredients I on U.ingredient_id = I.id
	group by U.recipe_id, U.step
	having count(distinct I.type) = (
		select count(distinct type)
		from ingredients I
	) 
) X;
-- (h) Write a query that outputs the id and name of chefs, and total ingredient quantity
-- (regardless of units), in order of decreasing quantity, for chefs that have created
-- recipes in a cuisine with ‘Indian’ in the name, but only considering ingredients that
-- belong to a cuisine with ‘Thai’ in the name.

drop view if exists indian_chefs;
create view indian_chefs as
select distinct C.id, C.name
from chefs C
     join recipes R on R.created_by = C.id
     join cuisines CU on CU.id = R.belong_to
where CU.name like '%Indian%';

select C.id, C.name, sum(quantity)
from indian_chefs C
     join recipes R on R.created_by = C.id
     join use U on U.recipe_id = R.id --18m
     join belong_to B on B.ingredient_id = U.ingredient_id
     join cuisines CU on CU.id = B.cuisine_id
where CU.name like '%Thai%'
group by C.id, C.name
order by sum(quantity) desc