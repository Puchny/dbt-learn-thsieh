select
    id as payment_id,
    "orderID" as order_id,
    "paymentMethod" as payment_method,
    AMOUNT as order_amount,
    CREATED as creation_date
from  {{source('stripe', 'payment')}}
