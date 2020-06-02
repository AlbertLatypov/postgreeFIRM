CREATE OR REPLACE FUNCTION trend( k_param integer )
RETURNS table(client INTEGER, goods integer, mass decimal(18,4), errors DECIMAL(18,4), ddate date) AS $$
DECLARE
current_city integer;
current_goods integer;
/*
Идея у всего написанного ниже есть следующая:

Заводим курсор different_groups - это маленькая таблица, в которой перечислены все уникальные комбинации id городов и
id товаров по которым совершались продажи в нужный период.

GENERAL_TABLE - это большая таблица там сгрупированны города, товары и даты, упорядоченные по датам.

А в таблицу subquery на каджой итерации помещаются определенные строки из GENERAL_TABLE, на основании переменных
current_city integer
current_goods integer которым присваеваются значения из  different groups.

Затем при помощи оконных функций в result_t подсчитываются прогноз и ошибка.

k_param - параметр, определяющий за какой промежуток дней вплоть до настоящего считаем скользящее среднее.
*/
different_groups CURSOR FOR select c.city, rg.goods
          from clients c join recept r on c.id=r.client
          join recgoods rg on rg.id = r.id
          join goods g on rg.goods = g.id
          where r.ddate between '2019-01-02' and '2019-12-31'
          group by c.city, rg.goods;

BEGIN

  OPEN different_groups;
  CREATE TEMP TABLE result_t(
    city INTEGER, goods integer, mass_predicted decimal(18,4), errors DECIMAL(18,4), ddate date
  );
  
  create temp table GENERAL_TABLE (
    city INTEGER, goods integer, mass decimal(18,4), ddate date
  );
  
  create temp table subquery (
    city INTEGER, goods integer, mass decimal(18,4), ddate date
  );
  
  insert into GENERAL_TABLE 
  select c.city, rg.goods, sum(g.weight * rg.volume), r.ddate
          from clients c join recept r on c.id=r.client
          join recgoods rg on rg.id = r.id
          join goods g on rg.goods = g.id
          where r.ddate between '2019-01-02' and '2019-12-31'
          group by c.city, rg.goods, r.ddate
		  order by r.ddate;
LOOP
	FETCH different_groups INTO current_city, current_goods;
    EXIT WHEN NOT FOUND;
	
	insert into subquery (city, goods, mass, ddate)
	select
		GENERAL_TABLE.city,
		GENERAL_TABLE.goods,
		GENERAL_TABLE.mass,
		GENERAL_TABLE.ddate 
	from GENERAL_TABLE
	where GENERAL_TABLE.city = current_city and GENERAL_TABLE.goods = current_goods
	order by ddate;
    
	insert INTO result_t(city,goods,mass_predicted,errors,ddate)
	select
		subquery.city, 
		subquery.goods, 
		(  sum (subquery.mass) over (rows between k_param PRECEDING and 1 preceding)  )/k_param , 
		subquery.mass - (  sum (subquery.mass) over (rows between k_param PRECEDING and 1 preceding)  )/k_param,
		subquery.ddate
	from subquery;

	delete from subquery;
	
END LOOP;
  close different_groups;
  RETURN QUERY select * from result_t;
  drop table GENERAL_TABLE;
  drop table result_t;
  drop table subquery;
END;
$$
LANGUAGE plpgsql;

select * from trend(10);
