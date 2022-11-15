WITH source_data as (
  SELECT sms_date,
    SUM(sms_count),
    IF (
      tag_id = 48,
      SUM(sms_count * 95),
      SUM(sms_count * 35)
    ) as sms_cost
  from (
      select (
          CASE
            WHEN body REGEXP "[а-яА-Я№]+"
            and CHAR_LENGTH(body) <= 70 THEN 1
            WHEN body REGEXP "[а-яА-Я№]+"
            and CHAR_LENGTH(body) > 70
            and CHAR_LENGTH(body) <= 140 THEN 2
            WHEN body REGEXP "[а-яА-Я№]+"
            and CHAR_LENGTH(body) > 140
            and CHAR_LENGTH(body) <= 210 THEN 3
            WHEN body REGEXP "[а-яА-Я№]+"
            and CHAR_LENGTH(body) > 210
            and CHAR_LENGTH(body) <= 280 THEN 4
            WHEN body REGEXP "[а-яА-Я№]+"
            and CHAR_LENGTH(body) > 280
            and CHAR_LENGTH(body) <= 350 THEN 5
            WHEN body REGEXP "[а-яА-Я№]+"
            and CHAR_LENGTH(body) > 350
            and CHAR_LENGTH(body) <= 420 THEN 6
            WHEN CHAR_LENGTH(body) <= 135 THEN 1
            WHEN CHAR_LENGTH(body) > 135
            and CHAR_LENGTH(body) <= 270 then 2
            WHEN CHAR_LENGTH(body) > 270
            and CHAR_LENGTH(body) <= 405 then 3
            WHEN CHAR_LENGTH(body) > 405
            and CHAR_LENGTH(body) <= 540 then 4
            WHEN CHAR_LENGTH(body) > 540
            and CHAR_LENGTH(body) <= 675 then 5
            WHEN CHAR_LENGTH(body) > 675
            and CHAR_LENGTH(body) <= 810 then 6
          END
        ) AS sms_count,
        DATE_FORMAT(created_at, '%Y-%m') AS sms_date,
        sms_logs.tag_id
      from sms_logs
      where year(created_at) >= 2022
        and gateway_id IN (2, 7)
        AND (
          IF(
            phone LIKE '99893%'
            or phone LIKE '99894%',
            TRUE,
            gateway_status in ("Delivered", "Transmitted", null)
          )
        )
    ) t
  GROUP BY sms_date
)

SELECT * FROM source_data;