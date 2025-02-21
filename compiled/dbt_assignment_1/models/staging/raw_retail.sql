

WITH raw_retail AS (
    SELECT
        *
    FROM
        Retail_Analytics_dbt.ecommerce.raw_retail_data
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