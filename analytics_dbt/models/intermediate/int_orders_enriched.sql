{{ 
    config(
        materialized = 'view'
    )
}}

with stg_orders as (
    select *
    from {{ ref('stg_orders') }}
),

stg_customers as (
    select *
    from {{ ref('stg_customers') }}
),

stg_stores as (
    select *
    from {{ ref('stg_stores') }}
),

enriched_orders as (
    select
        o.order_id,
        c.customer_id,
        s.store_id,

        -- customers context
        c.first_name as customer_first_name,
        c.last_name as customer_last_name,
        c.city as customer_city,
        c.province as customer_province,
        c.country as customer_country,

        -- stores context
        s.store_name as store_name,
        s.city as store_city,
        s.province as store_province,
        s.country as store_country,

        -- dates and times context
        o.order_timestamp as order_timestamp,
        date(o.order_timestamp) as order_date,
        extract(year from o.order_timestamp) as order_year,
        extract(month from o.order_timestamp) as order_month,
        extract(day from o.order_timestamp) as order_day,
        extract(hour from o.order_timestamp) as order_hour,

        -- status flags
        case when o.order_status = 'Completed' then 1 else 0 end as is_completed,
        case when o.order_status = 'Cancelled' then 1 else 0 end as is_canceled,
        case when o.order_status = 'Pending' then 1 else 0 end as is_pending,
        case when o.order_status = 'Returned' then 1 else 0 end as is_returned,

        -- financial metrics
        o.total_amount as order_gross_amount,
        o.payment_method as order_payment_method
        
    from stg_orders o
    left join stg_customers c on o.customer_id = c.customer_id
    left join stg_stores s on o.store_id = s.store_id
)

select * 
from enriched_orders


    