






    with grouped_expression as (
    select
        
        
    
  
( 1=1 and rfm_total_score >= 3 and rfm_total_score <= 15
)
 as expression


    from Retail_Analytics_dbt.DEV.rfm_segmentation
    

),
validation_errors as (

    select
        *
    from
        grouped_expression
    where
        not(expression = true)

)

select *
from validation_errors







