{% set payment_methods = dbt_utils.get_column_values(table=ref('stg_stripe__payments'), 
column='payment_method', 
max_records=50, 
default=[]) %}

with payments as (
    select * from {{ref('stg_stripe__payments')}}
),

pivoted as(
    select  
        order_id, 
        
        {% for payment_method in payment_methods %}
        sum(case when payment_method = '{{payment_method}}' then order_amount else 0 end) as {{payment_method}}
        {%- if not loop.last -%},{%- endif -%}
        {% endfor %}
    from payments
    group by 1

)

select * from pivoted