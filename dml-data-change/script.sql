use restaurant;

-- Вставка данных
insert into account_dictionary (name, code)
  values ('status new', 'new');
insert into account_dictionary (name, code)
  values ('status cancel', 'cancel');
insert into account_dictionary (name, code)
  values ('status paid', 'paid');

-- Вставка с использованием select
insert into order_dictionary (name, code)
  select name, code from account_dictionary where code='new';
insert into order_dictionary (name, code)
  select name, code from account_dictionary where code='cancel';
insert into order_dictionary (name, code)
  values ('status completed', 'completed');

insert into payment_type (name, code)
  values ('cashless_payment', 'cashless_payment');
insert into payment_type (name, code) values ('cash', 'cash');

insert into waiter (name, surname) VALUES ('Igor', 'Ivanov');
insert into client (name, surname, phone) VALUES ('Test', 'Sidorov', '79281001010');

insert into restaurant_table (name, number_seats) values ('table 1', 2);
insert into restaurant_table (name, number_seats) values ('table 2', 2);
insert into restaurant_table (name, number_seats) values ('table 3', 1);
insert into restaurant_table (name, number_seats) values ('table 4', 4);


start transaction;
insert into account (prepayment, payment_type_id, status_id)
  values (
    0,
    (select id from payment_type where code='cash'),
    (select id from account_dictionary where code='new')
  );
insert into `order` (number_persons, begin_date, finish_date, client_id, waiter_id, account_id, status_id)
  values (
    2,
    current_timestamp(),
    current_timestamp(),
    (select id from client where phone='79281001010'),
    (select id from waiter where surname='Ivanov' and name='Igor'),
    LAST_INSERT_ID(),
    (select id from order_dictionary where code='new')
  );
commit;

-- Обновление данных
update restaurant_table set number_seats=3 where name='table 2';
update `order` as o
  join account a on o.account_id = a.id and a.status_id=(select id from account_dictionary where code='new')
  set o.number_persons=3
  where o.client_id=(select id from client where phone='79281001010');

-- Удаление
delete from payment_type where code='cashless_payment'

-- Вставка и обновление
insert into restaurant_table (id, name, number_seats)
  values (1, 'table test', 2) on duplicate key update number_seats=number_seats+1;


-- Очистка данных

delete from `order`;
delete from account;
delete from account_dictionary;
delete from account_dictionary;
delete from order_dictionary;
delete from payment_type;
delete from waiter;
delete from client;
delete from restaurant_table;