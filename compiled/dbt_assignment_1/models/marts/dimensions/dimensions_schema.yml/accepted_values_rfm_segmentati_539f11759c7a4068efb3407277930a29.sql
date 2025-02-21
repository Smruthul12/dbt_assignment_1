
    
    

with all_values as (

    select
        customer_segment as value_field,
        count(*) as n_records

    from Retail_Analytics_dbt.DEV.rfm_segmentation
    group by customer_segment

)

select *
from all_values
where value_field not in (
    'Lost Customers','Others','New Customers','At Risk Customers','Loyal Customers','Best Customers'
)


