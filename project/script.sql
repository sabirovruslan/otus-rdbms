use restaurant;

set @client_phone = '79281001010';

# Выборка клиентов
select id, concat(name, ' ', surname) as fullname, phone from client;

# Выборка официантов с фамилией 'Ivanov'
select id, concat(name, ' ', surname) as fullname from waiter where surname='Ivanov';

# Получить клиентов и посчитать количество их заказов
select *,
       (select count(*) from `order` where `order`.client_id=client.id) as count_order
  from client
  order by count_order desc;

# Получить заказы клиента
select * from `order`
  where client_id=(select id from client where phone=@client_phone);

# Получение информации о заказе
select o.id, o.number_persons, o.begin_date, o.finish_date,
       c.id as client_id, concat(c.name, ' ', c.surname) as client_name,
       od.id as status_id, od.code as status_code,
       w.id as waiter_id, concat(w.name, ' ', w.surname) as waiter_name
  from `order` as o
  inner join order_dictionary od on o.status_id = od.id
  inner join client c on o.client_id = c.id
  inner join waiter w on o.waiter_id = w.id

  where client_id=(select id from client where phone=@client_phone);

# Получение информации об оплате заказа
select *
  from `order`
  inner join account a on `order`.account_id = a.id
  inner join payment_type pt on a.payment_type_id = pt.id
  where `order`.client_id=(select id from client where phone=@client_phone);

# Получение информации о заказанных блюдах
select o.id, o.begin_date, o.finish_date, o.client_id, d.id, d.name, d.price
from `order` as o
inner join order_dishes od on o.id = od.order_id
inner join dish d on od.dish_id = d.id
order by d.id;

# Получение информации о столиках в заказе
select o.id, o.begin_date, o.finish_date, o.client_id, rt.id, rt.name, rt.number_seats
from `order` as o
inner join order_tables ot on o.id = ot.order_id
inner join restaurant_table rt on ot.table_id = rt.id
order by rt.id;

# Хранимая процедура для создания заказа и счета
drop procedure if exists create_order;
create procedure create_order(in p_type smallint, s_account smallint, client int, waiter smallint)
begin
  insert into account (prepayment, payment_type_id, status_id)
  values (
    0,
    p_type,
    s_account
  );
  set @account_id = LAST_INSERT_ID();
  insert into `order` (number_persons, begin_date, finish_date, client_id, waiter_id, account_id, status_id)
  values (
    2,
    current_timestamp(),
    current_timestamp(),
    client,
    waiter,
    @account_id,
    (select id from order_dictionary where code='new')
  );
end;

# Создание заказа и счета
start transaction;
call create_order(
  (select id from payment_type where code='cash'),
  (select id from account_dictionary where code='new'),
  (select id from client where phone='79281001010'),
  (select id from waiter where surname='Ivanov' and name='Igor')
);
commit;