{{
  config(
    materialized='incremental',
    unique_key='store_id',
  )
}}
with source as (
        select * from {{ source('retail_store', 'stores') }}
  ),
  renamed as (
      select
          {{ adapter.quote("store_id") }},
        {{ adapter.quote("store_name") }},
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