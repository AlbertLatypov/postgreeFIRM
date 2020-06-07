WITH RECURSIVE r AS (
   SELECT id, parent
   FROM goods_groups

   union
   
   select goods_groups.id, r.parent 
	from goods_groups join r on goods_groups.parent = r.id
	where r.parent is not null

)
SELECT * FROM r;







/*
with recursive r as (
	select a.good_id, b.id, b.par_id
	from drevo_goods a join drevo b on a.good_gr=b.id
	
	union
	
	select drevo_goods.good_id, r.id, r.par_id
	from drevo_goods join r on drevo_goods.good_gr = r.par_id
)
select * from r
*/

/*
WITH RECURSIVE r AS (
   SELECT drevo_goods.good_id good, drevo.id grp, drevo.par_id parent
   FROM drevo_goods join drevo on drevo_goods.good_gr = drevo.id

	union all
	
	select r.good, drevo.id, r.parent 
	from drevo join r on drevo.par_id = r.grp
	

)
SELECT * FROM r;
*/

/*
WITH RECURSIVE r AS (
   SELECT drevo.id grp, drevo.par_id parent
   FROM drevo
	
	union
	
	select r.grp, r.parent 
	from drevo join r on drevo.par_id = r.grp
)
SELECT * FROM r;
*/

