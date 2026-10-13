
{{
  config(
    materialized='incremental',
    unique_key='employee_id',
  )
}}
with source as (
        select * from {{ source('retail_store', 'employees') }}
  ),
  renamed as (
      select
          {{ adapter.quote("employee_id") }},
        {{ adapter.quote("store_id") }},
        {{ adapter.quote("first_name") }},
        {{ adapter.quote("last_name") }},
        {{ adapter.quote("email") }},
        {{ adapter.quote("job_title") }},
        {{ adapter.quote("salary") }},
        {{ adapter.quote("created_timestamp") }},
        {{ adapter.quote("updated_timestamp") }},
        {{ adapter.quote("is_active") }}

      from source
  )
  select * from renamed
  {% if is_incremental() %}
    where updated_timestamp > (select max(updated_timestamp) from {{ this }})
  {% endif %}