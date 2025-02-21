
    
    

with all_values as (

    select
        customer_segment as value_field,
        count(*) as n_records

    from Retail_Analytics_dbt.DEV.customer_details
    group by customer_segment

)

select *
from all_values
where value_field not in (
    'Low-Value','High-Value','Medium-Value'
)


