select
    customer_id
from {{ ref('int_customers_agg') }}
where lifetime_value < 0