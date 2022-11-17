WITH source_data as (
    SELECT sms_date,
       SUM(sms_count)                                             as sms_count,
       SUM(sms_count * 25)                                        as sms_cost
from (select (CASE
                  WHEN body SIMILAR TO '[а-яА-Я]+' or body LIKE '%№%' and CHAR_LENGTH(body) <= 70 THEN 1
                  WHEN body SIMILAR TO '[а-яА-Я]+' or
                       body LIKE '%№%' and CHAR_LENGTH(body) > 70 and CHAR_LENGTH(body) <= 140 THEN 2
                  WHEN body SIMILAR TO '[а-яА-Я]+' or
                       body LIKE '%№%' and CHAR_LENGTH(body) > 140 and CHAR_LENGTH(body) <= 210 THEN 3
                  WHEN body SIMILAR TO '[а-яА-Я]+' or
                       body LIKE '%№%' and CHAR_LENGTH(body) > 210 and CHAR_LENGTH(body) <= 280 THEN 4
                  WHEN body SIMILAR TO '[а-яА-Я]+' or
                       body LIKE '%№%' and CHAR_LENGTH(body) > 280 and CHAR_LENGTH(body) <= 350 THEN 5
                  WHEN body SIMILAR TO '[а-яА-Я]+' or
                       body LIKE '%№%' and CHAR_LENGTH(body) > 350 and CHAR_LENGTH(body) <= 420 THEN 6
                  WHEN CHAR_LENGTH(body) <= 135 THEN 1
                  WHEN CHAR_LENGTH(body) > 135 and CHAR_LENGTH(body) <= 270 then 2
                  WHEN CHAR_LENGTH(body) > 270 and CHAR_LENGTH(body) <= 405 then 3
                  WHEN CHAR_LENGTH(body) > 405 and CHAR_LENGTH(body) <= 540 then 4
                  WHEN CHAR_LENGTH(body) > 540 and CHAR_LENGTH(body) <= 675 then 5
                  WHEN CHAR_LENGTH(body) > 675 and CHAR_LENGTH(body) <= 810 then 6 END) AS sms_count,
             to_char(created_at, 'YYYY-MM')                                             AS sms_date
      from sms_logs_since_2022
      where gateway_id IN (4, 5)
        AND ((gateway_status in ('Delivered', 'Transmitted') or gateway_status is NULL) OR
             (phone LIKE '99893%' or phone LIKE '99894%'))) t
GROUP BY sms_date;
)

SELECT * FROM source_data;