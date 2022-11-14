{{ config(materialized='table') }}

with covid_confirmed_by_date as (
    SELECT 
        date as date,
        SUM(new_confirmed::REAL) as sum_of_confirmed
    FROM covid_epidemiology
    GROUP BY date
)

SELECT * FROM covid_confirmed_by_date