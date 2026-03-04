-- stg_raw__sales.sql

with source as (

    select * 
    from {{ source('raw', 'sales') }}

),

renamed as (

    select
        date_date as order_date,
        orders_id as order_id,
        pdt_id as product_id,
        revenue,
        quantity

    from source

)

select *
from renamed