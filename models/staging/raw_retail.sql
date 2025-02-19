WITH raw_retail AS (
    SELECT
        *
    FROM
        {{ source('ecommerce', 'raw_retail_data') }}
)
SELECT
    InvoiceNo,
    StockCode,
    Description,
    Quantity,
    InvoiceDate,
    UnitPrice AS UnitPrice_str,
    CustomerID,
    Country
FROM
    raw_retail
