{{ config(materialized='table') }}

with covid_confirmed_by_date as (
    SELECT 
        date as date,
        SUM(new_confirmed) as sum_of_confirmed
    FROM covid_epidemilolgy
    GROUP BY date
)

SELECT * FROM covid_confirmed_by_date