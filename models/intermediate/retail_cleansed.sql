{{
  config(
    materialized = 'incremental',  
    unique_key = 'InvoiceNo',  
    cluster_by=['InvoiceDate'], 
    on_schema_change='sync_all_columns'
  )
}}

WITH filtered_data AS (
    SELECT
        InvoiceNo,
        StockCode,
        TRIM(UPPER(Description)) AS Description,
        Quantity,
        CAST(InvoiceDate AS DATE) AS InvoiceDate,  
        CASE 
            WHEN UnitPrice_str REGEXP '^[0-9]+(\.[0-9]+)?$' 
                 AND CAST(UnitPrice_str AS FLOAT) > 0 
            THEN CAST(UnitPrice_str AS FLOAT)
            ELSE NULL  
        END AS UnitPrice,
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

        {% if is_incremental() %}
        AND InvoiceDate > (SELECT MAX(InvoiceDate) FROM {{ this }})  
        {% endif %}
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
AND UnitPrice IS NOT NULL
