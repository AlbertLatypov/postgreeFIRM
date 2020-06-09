select 
	b.id, 
	b.ddate, 
	c.goods,
	b.client, 
	
	sum(c.price * c.volume) over (partition by b.id),
	
	sum(c.volume) over (partition by EXTRACT(month FROM b.ddate), c.goods ) /
	count(b.client) over (partition by EXTRACT(month FROM b.ddate), c.goods )  as avg_sells_by_month,
	
	sum(c.price * c.volume) over (partition by b.ddate order by b.id, c.subid) as sells_by_day
	
from clients a join recept b on a.id = b.client
	join recgoods c on b.id=c.id
