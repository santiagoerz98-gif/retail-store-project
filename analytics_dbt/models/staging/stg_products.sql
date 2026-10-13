
{{ 
  config(
    materialized='incremental',
    unique_key='product_id'
  ) 
}}

with source as (
        select * from {{ source('retail_store', 'products') }}
  ),
  renamed as (
      select
          {{ adapter.quote("product_id") }},
        {{ adapter.quote("product_name") }},
        {{ adapter.quote("category") }},
        {{ adapter.quote("brand") }},
        {{ adapter.quote("price") }},
        {{ adapter.quote("created_timestamp") }},
        {{ adapter.quote("updated_timestamp") }},
        {{ adapter.quote("is_active") }}

      from source
  )
  select 
    *,
    current_timestamp() as processed_at
  from 
    renamed
{% if is_incremental() %}
  where updated_timestamp > coalesce((select max(updated_timestamp) from {{ this }}),'1970-01-01')
{% endif %}