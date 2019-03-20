# Создание индексов для бд restaurant

use `restaurant`;

create index idx_begin_and_finish_dates
	on `order` (begin_date, finish_date);

create index idx_name
	on `dish` (name);

create index idx_price
	on `dish` (price);

create index idx_fk_order_dishes_dish
	on order_dishes (dish_id);

create index idx_fk_order_id
	on order_dishes (order_id);

create index idx_surname_name
	on waiter (surname, name);

create index idx_phone
	on  client (phone);

create index idx_surname_name
	on client (surname, name);

create index idx_fk_discount_id
	on client (discount_id);

create index idx_fk_account_dictionary1
	on account (status_id);

create index idx_fk_account_dictionary2
	on account (payment_type_id);

create index idx_fk_account_discount
	on account (discount_id);

create index idx_name
  on payment_type (name);

create index idx_code
  on payment_type (code);

create index idx_number_seats
	on restaurant_table (number_seats);

create index idx_fk_order_tables_order
	on order_tables (order_id);

create index idx_fk_order_tables_table
	on order_tables (table_id);

create index idx_name
	on order_dictionary (name);

create index idx_code
	on order_dictionary (code);

create index idx_name
  on account_dictionary (name);

create index idx_code
  on account_dictionary (code);


# Создание индексов для бд voip

use voip;

create index idx_db_date on CDR (BILL_DATE, BILL_TIME);
create index idx_price on CDR (price);
create index idx_rate_t on CDR (rate_t);
create index idx_rate_o on CDR (rate_o);
create index idx_elapsed_time on CDR (ELAPSED_TIME);
create index idx_src_ip on CDR (SRC_IP);
create index idx_dst_ip on CDR (DST_IP);