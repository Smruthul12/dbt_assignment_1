




    with grouped_expression as (
    select
        
        
    
  


    
regexp_instr(country, '^[A-Z ]+$', 1, 1, 0, '')


 > 0
 as expression


    from Retail_Analytics_dbt.DEV.retail_cleansed
    

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




