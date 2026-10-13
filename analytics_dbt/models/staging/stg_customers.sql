{{
  config(
    materialized='incremental',
    unique_key='customer_id',
  )
}}
with source as (
        select * from {{ source('retail_store', 'customers') }}
  ),
  renamed as (
      select
          {{ adapter.quote("customer_id") }},
        {{ adapter.quote("first_name") }},
        {{ adapter.quote("last_name") }},
        {{ adapter.quote("email") }},
        {{ adapter.quote("phone") }},
        {{ adapter.quote("city") }},
        {{ adapter.quote("province") }},
        {{ adapter.quote("country") }},
        {{ adapter.quote("created_timestamp") }},
        {{ adapter.quote("updated_timestamp") }},
        {{ adapter.quote("is_active") }}

      from source
  )
  select * from renamed
  {% if is_incremental() %}
    where updated_timestamp > (select max(updated_timestamp) from {{ this }})
  {% endif %}