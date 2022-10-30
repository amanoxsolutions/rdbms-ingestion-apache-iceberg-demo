insert into products (id, name, type, quantity, price) values (
  generate_series(1001, 1020),
  'product' || trunc(random()*100),
  'type' || trunc(random()*10),
  trunc(random()*10),
  trunc(cast(random()*1000 as numeric), 2)
);
update products as p set
  price = p.price * 1.1,
  quantity = p.quantity + 10
where p.id < 11 and id=p.id;