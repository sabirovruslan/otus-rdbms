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

# Тригер расчитывает скидку клиента на след заказ
drop trigger if exists cal_discount_client;
create trigger cal_discount_client before update on `order` for each row
  begin
    declare s_completed smallint;
    declare count_order_completed int;
    set s_completed = (select id from order_dictionary where code='completed');
    set count_order_completed = (select count(1) from `order` where status_id=s_completed and client_id=NEW.client_id);

    if count_order_completed = 1 then
      update client set discount_id=(select id from discount where value=3) where id=NEW.client_id;
    end if;

    if count_order_completed > 2 then
      update client set discount_id=(select id from discount where value=5) where id=NEW.client_id;
    end if;
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

update `order` set status_id=(select id from order_dictionary where code='completed')
where client_id=(select id from client where phone='79281001010')
limit 1;