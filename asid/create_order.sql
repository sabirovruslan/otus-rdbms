-- Создаем справочники Тип оплаты, статус счета и статус заказа
insert into payment_type (name, code) values ('cash', 'cash');

insert into account_dictionary (name, code, description)
  values ('Status NEW', 'new', 'description');

insert into order_dictionary (name, code, description)
  values ('Status NEW', 'new', 'description');


-- создаеем официанта и клиента
insert into waiter (name, surname) VALUES ('Igor', 'Ivanov');
insert into client (name, surname, phone) VALUES ('Test', 'Sidorov', '79281001010');

-- Открываем транзакцию по созданию счета и заказа
start transaction;

-- Делаем необходимые выборки
select @C:=id from client where phone='79281001010';
select @W:=id from waiter LIMIT 1;
select @P_T:=id from payment_type where code='cash';
select @S:=id from account_dictionary where code='new';
select @O_S:=id from order_dictionary where code='new';

-- Создаем счет
insert into account (prepayment, payment_type_id, status_id) values (0.00, @P_T, @S);
select @A:=id from account LIMIT 1;

-- Создаем заказ
insert into `order` (number_persons, begin_date, finish_date, client_id, waiter_id, account_id, status_id)
values (2, CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP(), @C, @W, @A, @O_S);

-- Фиксируем изменения
commit;