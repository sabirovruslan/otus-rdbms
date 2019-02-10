create database restaurant;
use `restaurant`;

create table `order`
(
	id bigint unsigned auto_increment,
	number_persons tinyint unsigned default 2 not null,
	begin_date datetime not null,
	finish_date datetime null,
	client_id int unsigned not null,
	waiter_id smallint unsigned not null,
	account_id bigint unsigned not null,
	status_id smallint unsigned not null,
	create_at datetime default current_timestamp not null,
	update_at datetime default current_timestamp null,
	constraint order_pk
		primary key (id)
);

alter table `order` modify status_id smallint unsigned not null;

create index idx_begin_and_finish_dates
	on `order` (begin_date, finish_date);

alter table `order`
	add constraint fk_client_id
		foreign key (client_id) references client (id);

alter table `order`
  add constraint fk_waiter_id
    foreign key (waiter_id) references waiter (id);

alter table `order`
  add constraint fk_account_id
    foreign key (account_id) references account (id);

alter table `order`
  add constraint fk_status_id
    foreign key (status_id) references order_dictionary (id);

# -------------------------------------------------
create table `dish`
(
  id smallint unsigned auto_increment,
  name varchar(255) not null,
  price decimal(6,2) not null,
  create_at datetime default current_timestamp not null,
  update_at datetime default current_timestamp not null,
  constraint order_ph
    primary key (id)
);

create index idx_name
	on `dish` (name);

create index idx_price
	on `dish` (price);

# -----------------------------------------------------
create table `order_dishes`
(
  order_id bigint unsigned not null,
  dish_id smallint unsigned not null,
  amount smallint unsigned not null default 1,
  create_at datetime default current_timestamp not null,
  update_at datetime default current_timestamp null,
  PRIMARY KEY (order_id, dish_id)
);

create index idx_fk_order_dishes_dish
	on order_dishes (dish_id);

create index idx_fk_order_id
	on order_dishes (order_id);

alter table `order_dishes`
  add constraint fk_order_id
    foreign key (order_id) references `order` (id),
  add constraint fk_dish_id
    foreign key (dish_id) references `dish` (id);

# -----------------------------------------------------
create table waiter
(
  id smallint unsigned auto_increment not null,
  name varchar(50) not null,
  surname varchar(50) not null,
  create_at datetime default current_timestamp not null,
  update_at datetime default current_timestamp null,
	PRIMARY KEY (id)
);

create index idx_surname_name
	on waiter (surname, name);

# -------------------------------------------------------
create table client
(
  id int unsigned auto_increment not null,
  name varchar(50) not null,
  surname varchar(50) not null,
  phone varchar(11) not null,
  discount_id smallint unsigned null,
  create_at datetime not null default current_timestamp,
  update_at datetime null default current_timestamp,
  constraint client_pk
		primary key (id)
);

create index idx_phone
	on  client (phone);

create index idx_surname_name
	on client (surname, name);

create index idx_fk_discount_id
	on client (discount_id);

alter table `client`
  add constraint fk_discount_id
    foreign key (discount_id) references `discount` (id);

create table account
(
  id bigint unsigned auto_increment not null,
  prepayment decimal(10, 2) not null default 0,
  discount_id smallint unsigned null,
  payment_type_id smallint unsigned not null,
  status_id smallint unsigned not null,
  create_at datetime not null default current_timestamp,
  update_at datetime null default current_timestamp,
  constraint account_pk
		primary key (id)
);

create index idx_fk_account_dictionary1
	on account (status_id);

create index idx_fk_account_dictionary2
	on account (payment_type_id);

create index idx_fk_account_discount
	on account (discount_id);

alter table `account`
  add constraint fk_account_discount_id
    foreign key (discount_id) references `discount` (id),
  add constraint fk_payment_type_id
    foreign key (payment_type_id) references `payment_type` (id),
  add constraint fk_account_status_id
    foreign key (status_id) references `account_dictionary` (id);

# -------------------------------------------------------
create table payment_type
(
  id smallint unsigned auto_increment not null,
  name varchar(100) not null,
  code varchar(50) not null,
  create_at datetime not null default current_timestamp,
  update_at datetime null default current_timestamp,
  constraint payment_type_pk
    primary key (id)
);

create index idx_name
  on payment_type (name);

create index idx_code
  on payment_type (code);

# --------------------------------------------------------
create table restaurant_table
(
  id smallint unsigned auto_increment not null,
  name varchar(45) not null,
  number_seats tinyint unsigned not null default 2,
  constraint restaurant_table_pk
		primary key (id)
);

create index idx_number_seats
	on restaurant_table (number_seats);

# --------------------------------------------------
create table order_tables
(
  order_id bigint unsigned not null,
  table_id smallint unsigned not null,
  create_at datetime not null default current_timestamp,
  update_at datetime null default current_timestamp,
  primary key (order_id, table_id)
);

create index idx_fk_order_tables_order
	on order_tables (order_id);

create index idx_fk_order_tables_table
	on order_tables (table_id);

alter table `order_tables`
  add constraint fk_order_tables_order_id
    foreign key (order_id) references `order` (id),
  add constraint fk_order_tables_table_id
    foreign key (table_id) references `restaurant_table` (id);

# ----------------------------------------------
create table order_dictionary
(
  id smallint unsigned auto_increment not null,
  name varchar(45) not null,
  code varchar(45) not null,
  description varchar(255) null,
  constraint order_dictionary_pk
		primary key (id)
);

create index idx_name
	on order_dictionary (name);

create index idx_code
	on order_dictionary (code);

# ----------------------------------------
create table discount
(
  id smallint unsigned auto_increment not null,
  value tinyint unsigned not null,
  constraint discount_pk
    primary key (id)
);

# ---------------------------------------------
create table account_dictionary
(
  id smallint unsigned auto_increment not null,
  name varchar(45) not null,
  code varchar(45) not null,
  description varchar(255) null,
  constraint account_dictionary_pk
    primary key (id)
);

create index idx_name
  on account_dictionary (name);

create index idx_code
  on account_dictionary (code);
