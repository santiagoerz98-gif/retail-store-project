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
where 
    is_active = 'Y'

{% if is_incremental() %}
    and updated_timestamp > coalesce((select max(updated_timestamp) from {{ this }}),'1970-01-01')
{% endif %}