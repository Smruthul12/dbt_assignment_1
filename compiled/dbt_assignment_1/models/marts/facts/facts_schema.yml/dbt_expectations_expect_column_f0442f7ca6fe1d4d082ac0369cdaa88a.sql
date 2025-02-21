






    with grouped_expression as (
    select
        
        
    
  
( 1=1 and monetary_score >= 1 and monetary_score <= 5
)
 as expression


    from Retail_Analytics_dbt.DEV.customer_rfm
    

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







