{{
  config(
    materialized = 'view'
  )
}}

WITH raw_retail AS (
    SELECT * FROM {{ ref('raw_retail') }}
)

SELECT
    InvoiceNo,
    StockCode,
    TRIM(UPPER(Description)) AS Description,
    Quantity,
    CAST(InvoiceDate AS DATE) AS InvoiceDate,  
    CAST(UnitPrice_str AS FLOAT) AS UnitPrice,
    CustomerID,
    TRIM(UPPER(Country)) AS Country
FROM
    raw_retail
WHERE 
    CustomerID IS NOT NULL 
    AND Quantity > 0
