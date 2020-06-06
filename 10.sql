WITH RECURSIVE r AS (
   SELECT id, parent
   FROM goods_groups

   union
   
   select goods_groups.id, r.parent 
	from goods_groups join r on goods_groups.parent = r.id
	where r.parent is not null

)
SELECT * FROM r;
