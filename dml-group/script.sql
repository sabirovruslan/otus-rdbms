use voip;

# Создаем временную таблицу
create table tmp_oper_ip like oper_ip;
insert into tmp_oper_ip
select oper_ip.*
from oper_ip
       inner join (
  select IP_OP, MAX(ID) vid
  from oper_ip
  group by IP_OP
) v on v.vid = oper_ip.ID;

# Стоимость звонков
select DST_NUMBER_IN,
       DST_NUMBER_BILL,
       BILL_DATE,
       BILL_TIME,
       ELAPSED_TIME,
       SRC_IP,
       ip_o.OP_ID   as                                       site_o,
       s_o.SITENAME as                                       sname_o,
       s_o.rate_o,
       r_o.PRICE,
       r_o.CODE_ID,
       (select max(CODE)
        from DEST_CODE dc
        where dc.DEST_ID = r_o.CODE_ID
          and dc.CODE in (
                          SUBSTRING(c.DST_NUMBER_BILL, 1, 1),
                          SUBSTRING(c.DST_NUMBER_BILL, 1, 2),
                          SUBSTRING(c.DST_NUMBER_BILL, 1, 3),
                          SUBSTRING(c.DST_NUMBER_BILL, 1, 4),
                          SUBSTRING(c.DST_NUMBER_BILL, 1, 5)
          )
       )            as                                       max_code_o,
       CAST(r_o.PRICE * ELAPSED_TIME / 60 AS DECIMAL(12, 6)) cost_per_minute_o,
       DST_IP,
       ip_t.OP_ID   as                                       site_t,
       s_t.SITENAME as                                       sname_t,
       r_t.PRICE,
       r_t.CODE_ID,
       (select max(CODE)
        from DEST_CODE dc
        where dc.DEST_ID = r_t.CODE_ID
          and dc.CODE in (
                          SUBSTRING(c.DST_NUMBER_BILL, 1, 1),
                          SUBSTRING(c.DST_NUMBER_BILL, 1, 2),
                          SUBSTRING(c.DST_NUMBER_BILL, 1, 3),
                          SUBSTRING(c.DST_NUMBER_BILL, 1, 4),
                          SUBSTRING(c.DST_NUMBER_BILL, 1, 5)
          )
       )            as                                       max_code_t,
       CAST(r_t.PRICE * ELAPSED_TIME / 60 as DECIMAL(12, 6)) cost_per_minute_t

from CDR as c
       inner join tmp_oper_ip ip_o on ip_o.IP_OP = c.SRC_IP
       inner join SITE as s_o on s_o.ID = ip_o.OP_ID
       inner join RATES as r_o on r_o.RATE_ID = s_o.rate_o
       inner join tmp_oper_ip ip_t on ip_t.IP_OP = c.DST_IP
       inner join SITE as s_t on s_t.ID = ip_t.OP_ID
       inner join RATES as r_t on r_t.RATE_ID = s_t.rate_t
where (select max(CODE)
       from DEST_CODE as dc
       where dc.DEST_ID = r_o.CODE_ID
         and dc.CODE in (
                         SUBSTRING(c.DST_NUMBER_BILL, 1, 1),
                         SUBSTRING(c.DST_NUMBER_BILL, 1, 2),
                         SUBSTRING(c.DST_NUMBER_BILL, 1, 3),
                         SUBSTRING(c.DST_NUMBER_BILL, 1, 4),
                         SUBSTRING(c.DST_NUMBER_BILL, 1, 5)
         )
) is not null
  and (select max(CODE)
       from DEST_CODE dc
       where dc.DEST_ID = r_t.CODE_ID
         and dc.CODE in (
                         SUBSTRING(c.DST_NUMBER_BILL, 1, 1),
                         SUBSTRING(c.DST_NUMBER_BILL, 1, 2),
                         SUBSTRING(c.DST_NUMBER_BILL, 1, 3),
                         SUBSTRING(c.DST_NUMBER_BILL, 1, 4),
                         SUBSTRING(c.DST_NUMBER_BILL, 1, 5)
         )
) is not null;


# Подсчет стоимости звонков DAYSTAT
insert into DAYSTAT (BILL_DATE,
                     TERM_OPER_ID,
                     TERM_DEST_ID,
                     TERM_COST,
                     ORIG_OPER_ID,
                     ORIG_DEST_ID,
                     ORIG_COST,
                     ALL_MIN,
                     ALL_CALLS)
select BILL_DATE,
       ip_t.OP_ID             as                                  TERM_OPER_ID,
       r_t.CODE_ID            as                                  TERM_DEST_ID,
       SUM(CAST(r_t.PRICE * ELAPSED_TIME / 60 as DECIMAL(12, 4))) TERM_COST,
       ip_o.OP_ID             as                                  ORIG_OPER_ID,
       r_o.CODE_ID            as                                  ORIG_DEST_ID,
       SUM(CAST(r_o.PRICE * ELAPSED_TIME / 60 AS DECIMAL(12, 4))) ORIG_COST,
       SUM(ELAPSED_TIME) / 60 as                                  ALL_MIN,
       COUNT(*)               as                                  ALL_CALLS
from CDR as c
       inner join tmp_oper_ip ip_o on ip_o.IP_OP = c.SRC_IP
       inner join SITE as s_o on s_o.ID = ip_o.OP_ID
       inner join RATES as r_o on r_o.RATE_ID = s_o.rate_o
       inner join tmp_oper_ip ip_t on ip_t.IP_OP = c.DST_IP
       inner join SITE as s_t on s_t.ID = ip_t.OP_ID
       inner join RATES as r_t on r_t.RATE_ID = s_t.rate_t
where (select max(CODE)
       from DEST_CODE as dc
       where dc.DEST_ID = r_o.CODE_ID
         and dc.CODE in (
                         SUBSTRING(c.DST_NUMBER_BILL, 1, 1),
                         SUBSTRING(c.DST_NUMBER_BILL, 1, 2),
                         SUBSTRING(c.DST_NUMBER_BILL, 1, 3),
                         SUBSTRING(c.DST_NUMBER_BILL, 1, 4),
                         SUBSTRING(c.DST_NUMBER_BILL, 1, 5)
         )
) is not null
  and (select max(CODE)
       from DEST_CODE dc
       where dc.DEST_ID = r_t.CODE_ID
         and dc.CODE in (
                         SUBSTRING(c.DST_NUMBER_BILL, 1, 1),
                         SUBSTRING(c.DST_NUMBER_BILL, 1, 2),
                         SUBSTRING(c.DST_NUMBER_BILL, 1, 3),
                         SUBSTRING(c.DST_NUMBER_BILL, 1, 4),
                         SUBSTRING(c.DST_NUMBER_BILL, 1, 5)
         )
) is not null
group by c.BILL_DATE, ip_t.OP_ID, r_t.CODE_ID, ip_o.OP_ID, r_o.CODE_ID
on duplicate key update DAYSTAT.ALL_CALLS=ALL_CALLS,
                        DAYSTAT.ALL_MIN=ALL_MIN,
                        DAYSTAT.TERM_COST=TERM_COST,
                        DAYSTAT.ORIG_COST=ORIG_COST;


# Подсчет стоимости HOURSTAT
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
select BILL_DATE,
       HOUR(BILL_TIME)        as                                  VHOUR,
       CAST(CONCAT(BILL_DATE, ' ', BILL_TIME) as datetime)        DB_DATE,
       ip_t.OP_ID             as                                  TERM_OPER_ID,
       r_t.CODE_ID            as                                  TERM_DEST_ID,
       SUM(CAST(r_t.PRICE * ELAPSED_TIME / 60 as DECIMAL(12, 4))) TERM_COST,
       ip_o.OP_ID             as                                  ORIG_OPER_ID,
       r_o.CODE_ID            as                                  ORIG_DEST_ID,
       SUM(CAST(r_o.PRICE * ELAPSED_TIME / 60 AS DECIMAL(12, 4))) ORIG_COST,
       SUM(ELAPSED_TIME) / 60 as                                  ALL_MIN,
       COUNT(*)               as                                  ALL_CALLS
from CDR as c
       inner join tmp_oper_ip ip_o on ip_o.IP_OP = c.SRC_IP
       inner join SITE as s_o on s_o.ID = ip_o.OP_ID
       inner join RATES as r_o on r_o.RATE_ID = s_o.rate_o
       inner join tmp_oper_ip ip_t on ip_t.IP_OP = c.DST_IP
       inner join SITE as s_t on s_t.ID = ip_t.OP_ID
       inner join RATES as r_t on r_t.RATE_ID = s_t.rate_t
where (select max(CODE)
       from DEST_CODE as dc
       where dc.DEST_ID = r_o.CODE_ID
         and dc.CODE in (
                         SUBSTRING(c.DST_NUMBER_BILL, 1, 1),
                         SUBSTRING(c.DST_NUMBER_BILL, 1, 2),
                         SUBSTRING(c.DST_NUMBER_BILL, 1, 3),
                         SUBSTRING(c.DST_NUMBER_BILL, 1, 4),
                         SUBSTRING(c.DST_NUMBER_BILL, 1, 5)
         )
) is not null
  and (select max(CODE)
       from DEST_CODE dc
       where dc.DEST_ID = r_t.CODE_ID
         and dc.CODE in (
                         SUBSTRING(c.DST_NUMBER_BILL, 1, 1),
                         SUBSTRING(c.DST_NUMBER_BILL, 1, 2),
                         SUBSTRING(c.DST_NUMBER_BILL, 1, 3),
                         SUBSTRING(c.DST_NUMBER_BILL, 1, 4),
                         SUBSTRING(c.DST_NUMBER_BILL, 1, 5)
         )
) is not null
group by c.BILL_DATE, c.BILL_TIME, ip_t.OP_ID, r_t.CODE_ID, ip_o.OP_ID, r_o.CODE_ID
on duplicate key update HOURSTAT.ALL_CALLS=ALL_CALLS,
                        HOURSTAT.ALL_MIN=ALL_MIN,
                        HOURSTAT.TERM_COST=TERM_COST,
                        HOURSTAT.ORIG_COST=ORIG_COST;