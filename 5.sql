
insert into supplies (ddate,storage,price,v3,diff_goods)
select
    income.ddate,
    income.storage,
    sum(incgoods.price*incgoods.volume),
    sum((goods.length*goods.width*goods.height)*incgoods.volume),
    count(distinct goods.id)
from income
join incgoods on income.id=incgoods.id
join goods on incgoods.goods=goods.id
group by
income.ddate, income.storage;





ALTER TABLE storages
ADD COLUMN isActive varchar(10);





update storages
set isActive =
case when storages.id in (
  select
    recept.storage
  from recept
    join recgoods on recept.id=recgoods.id
  where recept.ddate between '2020.02.11' AND '2020.03.11'
  group by
    recept.storage
  having
    sum(recgoods.price*recgoods.volume) > 10000)
then 1
else 0
end;





DELETE FROM goods
WHERE goods.id not in (SELECT incgoods.goods
                   FROM incgoods
                   )
AND goods.id not in (SELECT recgoods.goods
                   FROM recgoods
                   );
