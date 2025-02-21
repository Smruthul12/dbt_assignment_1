

WITH  __dbt__cte__customer_segmentation as (


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
), ranked_customers AS (
    SELECT 
        rc.CustomerID,
        rc.Country, 
        MAX(CAST(rc.InvoiceDate AS TIMESTAMP_NTZ)) AS last_purchase_date,  
        cs.customer_segment,
        ROW_NUMBER() OVER (
            PARTITION BY rc.CustomerID 
            ORDER BY MAX(rc.InvoiceDate) DESC
        ) AS row_num  
    FROM Retail_Analytics_dbt.DEV.retail_cleansed rc
    JOIN __dbt__cte__customer_segmentation cs 
        ON rc.CustomerID = cs.CustomerID
    WHERE rc.CustomerID IS NOT NULL  
    GROUP BY rc.CustomerID, rc.Country, cs.customer_segment
)

SELECT 
    CustomerID,
    Country,
    last_purchase_date,
    customer_segment
FROM ranked_customers
WHERE row_num = 1