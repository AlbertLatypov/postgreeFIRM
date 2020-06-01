create table region(
  id serial,
  name varchar(10),
  primary key(id)
  );

create table city (
  id serial,
  name varchar(10),
  region int references region(id),
  primary key (id)
  );

create table clients (
  id serial,
  name varchar(10),
  address varchar(50),
  city int references city(id),
  primary key(id)
  );
 
create table storages (
  id serial,
  name varchar(10),
  primary key(id)
  ); 

create table income (
  id serial,
  ddate date,
  ndoc integer,
  storage int references storages(id),
  client int references clients(id),
  primary key(id)
  );
 
create table recept (
  id serial,
  ddate date,
  ndoc integer,
  storage int references storages(id),
  client int references clients(id),
  primary key(id)
  );

create table goods_groups (
  id serial,
  name varchar(10),
  parent int,
  primary key(id),
  FOREIGN KEY (parent) REFERENCES goods_groups(id)
  );

create table goods (
  id serial,
  g_group int references goods_groups(id),
  name varchar(10),
  weight real,
  length real,
  height real,
  width real,
  primary key(id)
  );

create table incgoods (
  id serial references income(id),
  subid int,
  goods int references goods(id),
  volume int,
  price real,
  primary key(id,subid)
  );
 
create table recgoods (
  id serial references recept(id),
  subid int,
  goods int references goods(id),
  volume int,
  price real,
  primary key(id,subid)
  );
 
create table supplies (
  id serial,
  ddate date,
  storage varchar(10),
  price real,
  v3 real,
  diff_goods int,
  primary key(id)
  );
  
create table cassa_income
(
    id serial PRIMARY KEY,
    ddate date,
    summ int,
    client int REFERENCES client (id)
);

create table bank_income
(
    id serial PRIMARY KEY,
    ddate date,
    summ int,
    client int REFERENCES client (id)
);

create table cassa_recept
(
    id serial PRIMARY KEY,
    ddate date,
    summ int,
    client int REFERENCES client (id)
);

create table bank_recept
(
    id serial PRIMARY KEY,
    ddate date,
    summ int,
    client int REFERENCES client (id)
);
