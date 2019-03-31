use voip;

# Создаем view заменив временную таблицу
create view v_oper_ip as
select oper_ip.*
from oper_ip
         inner join (
    select IP_OP, MAX(ID) vid
    from oper_ip
    group by IP_OP
) v on v.vid = oper_ip.ID;


# создаем view и расчитываем стоимость звонков
create view v_cdr_prices as
select dCDR.DST_NUMBER_IN,
       dCDR.DST_NUMBER_BILL,
       dCDR.BILL_DATE,
       dCDR.BILL_TIME,
       dCDR.ELAPSED_TIME,
       dCDR.SRC_IP,
       ip_o.OP_ID   as                                       site_o,
       s_o.SITENAME as                                       sname_o,
       s_o.rate_o,
       r_o.PRICE    as                                       price_o,
       r_o.CODE_ID  as                                       code_id_o,
       CAST(r_o.PRICE * ELAPSED_TIME / 60 AS DECIMAL(12, 6)) cost_per_minute_o,
       dCDR.DST_IP,
       ip_t.OP_ID   as                                       site_t,
       s_t.SITENAME as                                       sname_t,
       r_t.PRICE    as                                       price_t,
       r_t.CODE_ID  as                                       code_id_t,
       CAST(r_t.PRICE * ELAPSED_TIME / 60 as DECIMAL(12, 6)) cost_per_minute_t

from CDR as dCDR
         inner join v_oper_ip ip_o on ip_o.IP_OP = dCDR.SRC_IP
         inner join SITE as s_o on s_o.ID = ip_o.OP_ID
         inner join RATES as r_o on r_o.RATE_ID = s_o.rate_o
         inner join v_oper_ip ip_t on ip_t.IP_OP = dCDR.DST_IP
         inner join SITE as s_t on s_t.ID = ip_t.OP_ID
         inner join RATES as r_t on r_t.RATE_ID = s_t.rate_t
where (select max(CODE)
       from DEST_CODE as dc
       where dc.DEST_ID = r_o.CODE_ID
         and dc.CODE in (
                         SUBSTRING(dCDR.DST_NUMBER_BILL, 1, 1),
                         SUBSTRING(dCDR.DST_NUMBER_BILL, 1, 2),
                         SUBSTRING(dCDR.DST_NUMBER_BILL, 1, 3),
                         SUBSTRING(dCDR.DST_NUMBER_BILL, 1, 4),
                         SUBSTRING(dCDR.DST_NUMBER_BILL, 1, 5)
           )
) is not null
  and (select max(CODE)
       from DEST_CODE dc
       where dc.DEST_ID = r_t.CODE_ID
         and dc.CODE in (
                         SUBSTRING(dCDR.DST_NUMBER_BILL, 1, 1),
                         SUBSTRING(dCDR.DST_NUMBER_BILL, 1, 2),
                         SUBSTRING(dCDR.DST_NUMBER_BILL, 1, 3),
                         SUBSTRING(dCDR.DST_NUMBER_BILL, 1, 4),
                         SUBSTRING(dCDR.DST_NUMBER_BILL, 1, 5)
           )
) is not null;


# Подсчет стоимости звонков DAYSTAT с использованием v_cdr_prices
insert into DAYSTAT (BILL_DATE,
                     TERM_OPER_ID,
                     TERM_DEST_ID,
                     TERM_COST,
                     ORIG_OPER_ID,
                     ORIG_DEST_ID,
                     ORIG_COST,
                     ALL_MIN,
                     ALL_CALLS)
select v_cdr.BILL_DATE,
       v_cdr.site_t           as                                      TERM_OPER_ID,
       v_cdr.code_id_t        as                                      TERM_DEST_ID,
       SUM(CAST(v_cdr.price_t * ELAPSED_TIME / 60 as DECIMAL(12, 4))) TERM_COST,
       v_cdr.site_o           as                                      ORIG_OPER_ID,
       v_cdr.code_id_o        as                                      ORIG_DEST_ID,
       SUM(CAST(v_cdr.price_o * ELAPSED_TIME / 60 AS DECIMAL(12, 4))) ORIG_COST,
       SUM(ELAPSED_TIME) / 60 as                                      ALL_MIN,
       COUNT(*)               as                                      ALL_CALLS
from v_cdr_prices as v_cdr
group by v_cdr.BILL_DATE, v_cdr.site_t, v_cdr.code_id_t, v_cdr.site_o, v_cdr.code_id_o
on duplicate key update DAYSTAT.ALL_CALLS=ALL_CALLS,
                        DAYSTAT.ALL_MIN=ALL_MIN,
                        DAYSTAT.TERM_COST=TERM_COST,
                        DAYSTAT.ORIG_COST=ORIG_COST;


# Подсчет стоимости HOURSTAT с использованием v_cdr_prices
insert into HOURSTAT (BILL_DATE,
                      VHOUR,
                      DB_DATE,
                      TERM_OPER_ID,
                      TERM_DEST_ID,
                      TERM_COST,
                      ORIG_OPER_ID,
                      ORIG_DEST_ID,
                      ORIG_COST,
                      ALL_MIN,
                      ALL_CALLS)
select v_cdr.BILL_DATE,
       HOUR(v_cdr.BILL_TIME)  as                                      VHOUR,
       CAST(CONCAT(BILL_DATE, ' ', BILL_TIME) as datetime)            DB_DATE,
       v_cdr.site_t           as                                      TERM_OPER_ID,
       v_cdr.code_id_t        as                                      TERM_DEST_ID,
       SUM(CAST(v_cdr.price_t * ELAPSED_TIME / 60 as DECIMAL(12, 4))) TERM_COST,
       v_cdr.site_o           as                                      ORIG_OPER_ID,
       v_cdr.code_id_o        as                                      ORIG_DEST_ID,
       SUM(CAST(v_cdr.price_o * ELAPSED_TIME / 60 AS DECIMAL(12, 4))) ORIG_COST,
       SUM(ELAPSED_TIME) / 60 as                                      ALL_MIN,
       COUNT(*)               as                                      ALL_CALLS
from v_cdr_prices as v_cdr
group by v_cdr.BILL_DATE, v_cdr.BILL_TIME, v_cdr.site_t, v_cdr.code_id_t, v_cdr.site_o, v_cdr.code_id_o
on duplicate key update HOURSTAT.ALL_CALLS=ALL_CALLS,
                        HOURSTAT.ALL_MIN=ALL_MIN,
                        HOURSTAT.TERM_COST=TERM_COST,
                        HOURSTAT.ORIG_COST=ORIG_COST;