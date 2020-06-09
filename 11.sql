WITH RECURSIVE r AS (
   SELECT id, par_id 
   FROM drevo

   union
   
   select drevo.id, r.par_id
	from drevo join r on drevo.par_id = r.id
	where r.par_id is not null
)
SELECT * FROM r


WITH RECURSIVE r AS (
   SELECT id, par_id 
   FROM drevo

   union
   
   select drevo.id, r.par_id
	from drevo join r on drevo.par_id = r.id
	where r.par_id is not null
)


select 
drevo_goods.good_id,
drevo_goods.good_gr
from drevo_goods join drevo on drevo_goods.good_gr = drevo.id

union

select
drevo_goods.good_id,
r.par_id
from drevo_goods join r on drevo_goods.good_gr = r.id









----- задание 2:
with recursive r as (
	select 1 as col1, 1 as col2
	
	union
	
	select col1+1, generate_series(1,col1+1)
	from r 
	where col1 < 4
)
select * from r;
