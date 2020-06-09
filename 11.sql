WITH RECURSIVE r AS (
   SELECT id, par_id 
   FROM drevo

   union
   
   select drevo.id, r.par_id
	from drevo join r on drevo.par_id = r.id
	where r.par_id is not null
)
SELECT * FROM r












----- задание 2:
with recursive r as (
	select 1 as col1, 1 as col2
	
	union
	
	select col1+1, generate_series(1,col1+1)
	from r 
	where col1 < 4
)
select * from r;
