
    
    

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
), all_values as (

    select
        customer_segment as value_field,
        count(*) as n_records

    from __dbt__cte__customer_segmentation
    group by customer_segment

)

select *
from all_values
where value_field not in (
    'Low-Value','High-Value','Medium-Value'
)


