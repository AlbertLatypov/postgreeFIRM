with recursive r as (
	select 1 as col1, 1 as col2
	
	union
	
	select col1+1, generate_series(1,col1+1)
	from r 
	where col1 < 4
)
select * from r;
