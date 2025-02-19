{{
  config(
    materialized = 'table'
  )
}}

WITH rfm_base AS (
    SELECT 
        CustomerID,
        MAX(InvoiceDate) AS last_purchase_date,
        COUNT(DISTINCT InvoiceNo) AS frequency,
        SUM(Quantity * UnitPrice) AS monetary_value
    FROM {{ ref('retail_cleansed') }}
    GROUP BY CustomerID
),

rfm_scores AS (
    SELECT 
        CustomerID,
        DATEDIFF(day, last_purchase_date, CURRENT_DATE) AS recency,
        frequency,
        monetary_value,
        NTILE(5) OVER (ORDER BY recency DESC) AS recency_score,
        NTILE(5) OVER (ORDER BY frequency ASC) AS frequency_score,
        NTILE(5) OVER (ORDER BY monetary_value ASC) AS monetary_score
    FROM rfm_base
)

SELECT 
    CustomerID,
    recency,
    frequency,
    monetary_value,
    recency_score,
    frequency_score,
    monetary_score,
    recency_score + frequency_score + monetary_score AS rfm_total_score
FROM rfm_scores
