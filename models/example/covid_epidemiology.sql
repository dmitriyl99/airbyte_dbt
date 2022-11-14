

  {{ config (
    materialized="table"
)}}
    
with __dbt__cte__covid_epidemiology_ab1 as (

-- SQL model to parse JSON blob stored in a single column and extract into separated field columns as described by the JSON Schema
-- depends_on: "dwh".services_calls._airbyte_raw_covid_epidemiology
select
    jsonb_extract_path_text(_airbyte_data, 'key') as "key",
    jsonb_extract_path_text(_airbyte_data, 'date') as "date",
    jsonb_extract_path_text(_airbyte_data, 'new_tested') as new_tested,
    jsonb_extract_path_text(_airbyte_data, 'new_deceased') as new_deceased,
    jsonb_extract_path_text(_airbyte_data, 'total_tested') as total_tested,
    jsonb_extract_path_text(_airbyte_data, 'new_confirmed') as new_confirmed,
    jsonb_extract_path_text(_airbyte_data, 'new_recovered') as new_recovered,
    jsonb_extract_path_text(_airbyte_data, 'total_deceased') as total_deceased,
    jsonb_extract_path_text(_airbyte_data, 'total_confirmed') as total_confirmed,
    jsonb_extract_path_text(_airbyte_data, 'total_recovered') as total_recovered,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    now() as _airbyte_normalized_at
from "dwh".services_calls._airbyte_raw_covid_epidemiology as table_alias
-- covid_epidemiology
where 1 = 1
),  __dbt__cte__covid_epidemiology_ab2 as (

-- SQL model to cast each column to its adequate SQL type converted from the JSON schema type
-- depends_on: __dbt__cte__covid_epidemiology_ab1
select
    cast("key" as text) as "key",
    cast("date" as text) as "date",
    cast(new_tested as text) as new_tested,
    cast(new_deceased as text) as new_deceased,
    cast(total_tested as text) as total_tested,
    cast(new_confirmed as text) as new_confirmed,
    cast(new_recovered as text) as new_recovered,
    cast(total_deceased as text) as total_deceased,
    cast(total_confirmed as text) as total_confirmed,
    cast(total_recovered as text) as total_recovered,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    now() as _airbyte_normalized_at
from __dbt__cte__covid_epidemiology_ab1
-- covid_epidemiology
where 1 = 1
),  __dbt__cte__covid_epidemiology_ab3 as (

-- SQL model to build a hash column based on the values of this record
-- depends_on: __dbt__cte__covid_epidemiology_ab2
select
    md5(cast(coalesce(cast("key" as text), '') || '-' || coalesce(cast("date" as text), '') || '-' || coalesce(cast(new_tested as text), '') || '-' || coalesce(cast(new_deceased as text), '') || '-' || coalesce(cast(total_tested as text), '') || '-' || coalesce(cast(new_confirmed as text), '') || '-' || coalesce(cast(new_recovered as text), '') || '-' || coalesce(cast(total_deceased as text), '') || '-' || coalesce(cast(total_confirmed as text), '') || '-' || coalesce(cast(total_recovered as text), '') as text)) as _airbyte_covid_epidemiology_hashid,
    tmp.*
from __dbt__cte__covid_epidemiology_ab2 tmp
-- covid_epidemiology
where 1 = 1
)-- Final base SQL model
-- depends_on: __dbt__cte__covid_epidemiology_ab3
select
    "key",
    "date",
    new_tested,
    new_deceased,
    total_tested,
    new_confirmed,
    new_recovered,
    total_deceased,
    total_confirmed,
    total_recovered,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    now() as _airbyte_normalized_at,
    _airbyte_covid_epidemiology_hashid
from __dbt__cte__covid_epidemiology_ab3
-- covid_epidemiology from "dwh".services_calls._airbyte_raw_covid_epidemiology
where 1 = 1;