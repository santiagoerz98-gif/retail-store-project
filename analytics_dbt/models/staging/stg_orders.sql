{{ 
  config(
    materialized='incremental',
    unique_key='order_id'
  ) 
}}

select 
    *,
    current_timestamp() as processed_at
from 
    {{ source('retail_store', 'orders') }}
{% if is_incremental() %}
where
    updated_timestamp > coalesce((select max(updated_timestamp) from {{ this }}),'1970-01-01')
{% endif %}