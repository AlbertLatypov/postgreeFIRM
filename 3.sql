
select city.name, 
income.ddate, 
income.ndoc, 
goods_groups.name, 
goods.name, 
(goods.length*goods.width*goods.height)*incgoods.volume

from clients join income on clients.id = income.client
join city on clients.city=city.id
join incgoods on income.id=incgoods.id
join goods on incgoods.goods=goods.id
join goods_groups on goods.id=goods_groups.parent

where (goods.length*goods.width*goods.height)*incgoods.volume > 10 
and date_part('month',income.ddate) between 4 and 6 
and date_part('year', income.ddate) = 2020;





select 
clients.address, 
recept.ddate, 
recept.ndoc, 
storages.name, 
goods.name, 
(goods.weight*recgoods.volume), 
(recgoods.volume * recgoods.price)

from recept
join clients on recept.client=clients.id
join storages on recept.storage=storages.id
join recgoods on recept.id=recgoods.id
join goods on recgoods.goods=goods.id
join city on clients.city=city.id
join region on city.region=region.id

where region.name='Moscow' 
and date_part('year', recept.ddate)=2020 
and date_part('month', recept.ddate)=2 
and recgoods.id in
               (select recgoods.id
               from recept 
                join recgoods on recept.id=recgoods.id
               where date_part('year', recept.ddate) = 2019)
order by random() limit 10;
