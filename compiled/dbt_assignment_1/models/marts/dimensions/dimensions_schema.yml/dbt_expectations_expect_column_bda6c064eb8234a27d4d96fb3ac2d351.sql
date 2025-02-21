






    with  __dbt__cte__customer_segmentation as (


WITH customer_spend AS (
    SELECT
        CustomerID,
        SUM(Quantity * UnitPrice) AS total_spent
    FROM Retail_Analytics_dbt.DEV.retail_cleansed
    GROUP BY CustomerID
)

SELECT 
    CustomerID,
    total_spent,
    CASE
        WHEN total_spent > 30000 THEN 'High-Value'
        WHEN total_spent BETWEEN 10000 AND 30000 THEN 'Medium-Value'
        ELSE 'Low-Value'
    END AS customer_segment
FROM customer_spend
), grouped_expression as (
    select
        
        
    
  
( 1=1 and total_spent >= 0
)
 as expression


    from __dbt__cte__customer_segmentation
    

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







