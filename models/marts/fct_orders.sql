with orders as  (
    select * from {{ ref('stg_jaffle_shop__orders')}}
),

payments as (
    select * from {{ ref('stg_stripe__payments') }}
),

order_payments as (
    select
        order_id,
        sum(order_amount) as amount
    from payments
    group by 1
),

final as (

    select
        dim_orders.order_id,
        dim_orders.customer_id,
        dim_orders.order_date,
        dim_orders.status,
        coalesce(order_payments.amount, 0) as amount

    from dim_orders
    left join order_payments using (order_id)
)

select * from final
