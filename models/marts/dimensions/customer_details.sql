{{ 
    config(
        materialized='table'
    ) 
}}

WITH ranked_customers AS (
    SELECT 
        rc.CustomerID,
        rc.Country, 
        MAX(CAST(rc.InvoiceDate AS TIMESTAMP_NTZ)) AS last_purchase_date,  
        cs.customer_segment,
        ROW_NUMBER() OVER (
            PARTITION BY rc.CustomerID 
            ORDER BY MAX(rc.InvoiceDate) DESC
        ) AS row_num  
    FROM {{ ref('retail_cleansed') }} rc
    JOIN {{ ref('customer_segmentation') }} cs 
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
