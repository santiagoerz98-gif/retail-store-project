select 
    product_id
from {{ ref('stg_products') }}
where price <= 0