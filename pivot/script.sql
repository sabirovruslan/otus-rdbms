use voip;

# 1 выборка операторов
select
       op.ID                                                    as oper_id,
       op.OPERNAME                                              as oper_name,
       dense_rank() over(order by SUBSTRING(op.OPERNAME, 1, 1)) as number,
       row_number() over(f_part order by op.OPERNAME)           as num_in_part,
       count(*) over f_part                                     as total_in_part,
       count(*) over f_all                                   as count_opers,
       lag(op.ID, 1) over f_all                              as prev_oper_id,
       lead(op.ID, 1) over f_all                             as next_oper_id,
       lag(op.OPERNAME, 2) over f_all                        as oper_name_two_back_rows
from operators as op window
    f_all as (),
    f_part as (partition by SUBSTRING(op.OPERNAME, 1, 1));



# 2 Гос дума выпустила новый закон

with oper_all as (
    select op.ID       as oper_id,
           op.OPERNAME as oper_name,
           op.ORGNAME  as oper_orgname
    from operators as op)
select o.oper_id,
       o.oper_name,
       o.oper_orgname,
       ntile(3) over() as group_number
from oper_all as o
         left join operators as oper on o.oper_id = oper.ID
group by o.oper_id,
         o.oper_name,
         o.oper_orgname;


# 3 2 самых больших платежа оператора

with payments_operators as (
    with operators_prepared as (
        select op.ID       as oper_id,
               op.OPERNAME as oper_name
        from operators as op
    ),
         cal_payments as (
             select p.ID                                                             as payment_id,
                    p.OPER_ID                                                        as oper_id,
                    if(trim(p.CUR_NAME) = 'USD', p.PAY_SUM, p.PAY_SUM * p.EXCH_RATE) as payment_sum_usd,
                    p.PAY_DATE                                                       as payment_date
             from PAY as p
             where p.oper_id is not null
         )
    select distinct payments.oper_id                                                      as oper_id,
                    opers.oper_name                                                       as oper_name,
                    payments.payment_sum_usd                                              as payment_sum,
                    payments.payment_date                                                 as payment_date,
                    row_number() over(partition by oper_id order by payment_sum_usd desc) as payment_rate

    from cal_payments as payments
             inner join operators_prepared as opers using (oper_id)
)
select oper_id,
       oper_name,
       payment_sum,
       payment_date,
       if(payment_rate = 1, 1, 0) as is_max
from payments_operators
where payment_rate in (1, 2);


# 4 платежи в системе в разрезе год (строка) - месяц (колонка)

with payments_all as (
					select
						p.ID,
						p.OPER_ID,
						if(trim(p.CUR_NAME)='USD', p.PAY_SUM, p.PAY_SUM*p.EXCH_RATE) as payment_sum,
						extract(year from p.PAY_DATE) 	as year,
						extract(month from p.PAY_DATE)	as month
					from PAY 	as p
					where p.OPER_ID is not null
)
select
	year,
	sum( if( month = 1, payment_sum, 0)) as `jan`,
	sum( if( month = 2, payment_sum, 0)) as `feb`,
	sum( if( month = 3, payment_sum, 0)) as `mar`,
	sum( if( month = 4, payment_sum, 0)) as `apr`,
	sum( if( month = 5, payment_sum, 0)) as `may`,
	sum( if( month = 6, payment_sum, 0)) as `jun`,
	sum( if( month = 7, payment_sum, 0)) as `jul`,
	sum( if( month = 8, payment_sum, 0)) as `aug`,
	sum( if( month = 9, payment_sum, 0)) as `sep`,
	sum( if( month = 9, payment_sum, 0)) as `oct`,
	sum( if( month = 8, payment_sum, 0)) as `nov`,
	sum( if( month = 9, payment_sum, 0)) as `dec`
from payments_all
group by year;