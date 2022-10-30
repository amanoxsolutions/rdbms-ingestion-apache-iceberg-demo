create table products (
  id integer constraint products_pk primary key,
  name varchar(100),
  type varchar(100),
  quantity integer,
  price decimal(10,2) check(price > 0)
);
insert into products (id, name, type, quantity, price) values (
generate_series(1, 1000),
'product' || trunc(random()*1000),
'type' || trunc(random()*10),
trunc(random()*10),
trunc(cast(random()*1000 as numeric), 2)
);