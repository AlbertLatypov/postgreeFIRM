----- задание 1:
WITH RECURSIVE r AS (
	SELECT a.id, a.name, a.parent, b.name par_name
	FROM clients_groups a join clients_groups b on a.parent = b.id

	union
   
	select c.id, c.name, r.parent, d.name par_name
	from clients_groups c join r on c.parent = r.id
	join clients_groups d on  r.parent = d.id
	where r.parent is not null
)


select 
clients.id,
clients.name,
clients_groups.id,
clients_groups.name
from clients join clients_groups on clients.clients_groups = clients_groups.id

union

select
clients.id,
clients.name,
r.parent,
r.par_name
from clients join r on clients.clients_groups = r.id









----- задание 2:
with recursive r as (
	select 1 as col1, 1 as col2
	
	union
	
	select col1+1, generate_series(1,col1+1)
	from r 
	where col1 < 4
)
select * from r;
