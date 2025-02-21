
    
    



with __dbt__cte__customer_segmentation as (


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
) select customer_segment
from __dbt__cte__customer_segmentation
where customer_segment is null


