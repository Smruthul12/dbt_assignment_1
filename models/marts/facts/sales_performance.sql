-- sales performance by month
{{
  config(
    materialized = 'table'
  )
}}

WITH sales AS (
    SELECT
        DATE_TRUNC('month', InvoiceDate) AS month,
        SUM(Quantity * UnitPrice) AS total_sales,
        COUNT(DISTINCT InvoiceNo) AS total_orders
    FROM {{ ref('retail_cleansed') }}
    GROUP BY 1
)

SELECT 
    month,
    total_sales,
    total_orders
FROM sales
ORDER BY month DESC
