{{
    config(
        materialized='view'
    )
}}

with stg_customers as (
    select *
    from {{ ref('stg_customers') }}
),
stg_orders as (
    select *
    from {{ ref('stg_orders') }}
)
select
    c.customer_id,
    count(o.order_id) as total_orders_placed,
    count(case when o.order_status = 'Completed' then o.order_id else null end) as total_orders_completed,
    sum(case when o.order_status = 'Completed' then o.total_amount else 0 end) as lifetime_value,
    round(avg(case when o.order_status = 'Completed' then o.total_amount else 0 end), 2) as average_order_value,
    max(case when o.order_status = 'Completed' then o.total_amount else 0 end) as max_order_value,
    min(case when o.order_status = 'Completed' then o.total_amount else 0 end) as min_order_value,
    max(o.order_timestamp) as last_order_date,
    min(o.order_timestamp) as first_order_date
from stg_customers c
join stg_orders o
    on c.customer_id = o.customer_id
group by c.customer_id