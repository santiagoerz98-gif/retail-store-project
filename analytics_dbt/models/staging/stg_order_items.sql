
{{
  config(
    materialized='incremental',
    unique_key='order_item_id',
  )
}}
with source as (
        select * from {{ source('retail_store', 'order_items') }}
  ),
  renamed as (
      select
          {{ adapter.quote("order_item_id") }},
        {{ adapter.quote("order_id") }},
        {{ adapter.quote("product_id") }},
        {{ adapter.quote("quantity") }},
        {{ adapter.quote("unit_price") }},
        {{ adapter.quote("line_amount") }},
        {{ adapter.quote("created_timestamp") }},
        {{ adapter.quote("updated_timestamp") }},
        {{ adapter.quote("is_active") }}

      from source
  )
  select * from renamed
  {% if is_incremental() %}
    where updated_timestamp > (select max(updated_timestamp) from {{ this }})
  {% endif %}