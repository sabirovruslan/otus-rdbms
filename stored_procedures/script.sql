use restaurant;

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
insert into `order` (number_persons, begin_date, finish_date, client_id, waiter_id, account_id, status_id)
  values (
    2,
    current_timestamp(),
    current_timestamp(),
    client,
    waiter,
    LAST_INSERT_ID(),
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