CREATE TABLE GOODS (
  id serial PRIMARY KEY, 
  price int NOT NULL, 
  date date NOT NULL, 
  name varchar(1000) NOT NULL
);

INSERT INTO GOODS(price, date, name) 
VALUES 
  (35, '2020-02-17', 'ball'), 
  (35, '2020-03-17', 'mouse'), 
  (350, '2020-03-20', 'chair'), 
  (90, '2020-05-01', 'dress'), 
  (150, '2020-06-05', 'table'), 
  (170, '2020-05-05', 'table'), 
  (34, '2020-07-10', 'fork'), 
  (78, '2020-09-15', 'dishes');

select price 
from goods
where name = 'table' and
    date <= '2020-06-05'
order by date desc limit 1;
