{{
  config(
    materialized='incremental',
    unique_key='InvoiceNo' 
  )
}}

WITH new_sales AS (
    SELECT 
        InvoiceNo,
        InvoiceDate,
        CustomerID,
        StockCode,
        Quantity,
        UnitPrice,
        Quantity * UnitPrice AS total_amount
    FROM {{ ref('retail_cleansed') }}
    
    {% if is_incremental() %}
    WHERE InvoiceDate > (SELECT MAX(InvoiceDate) FROM {{ this }})
    {% endif %}
)

SELECT * FROM new_sales
