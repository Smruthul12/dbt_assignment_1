{{
  config(
    materialized = 'table'
  )
}}

WITH filtered_data AS (
    SELECT
        InvoiceNo,
        StockCode,
        TRIM(UPPER(Description)) AS Description,
        Quantity,
        CAST(InvoiceDate AS DATE) AS InvoiceDate,  
        CAST(UnitPrice_str AS FLOAT) AS UnitPrice,
        CustomerID,
        TRIM(UPPER(Country)) AS Country,
        ROW_NUMBER() OVER (PARTITION BY InvoiceNo ORDER BY InvoiceDate DESC) AS row_num
    FROM {{ ref('raw_retail') }}
    WHERE 
         InvoiceNo IS NOT NULL 
          AND CustomerID IS NOT NULL 
          AND Description IS NOT NULL 
          AND Description REGEXP '^[A-Za-z0-9 ]+$'
          AND Quantity > 0
          AND UnitPrice > 0 
)

SELECT 
    InvoiceNo,
    StockCode,
    Description,
    Quantity,
    InvoiceDate,
    UnitPrice,
    CustomerID,
    Country
FROM filtered_data
WHERE row_num = 1  
ORDER BY InvoiceDate DESC