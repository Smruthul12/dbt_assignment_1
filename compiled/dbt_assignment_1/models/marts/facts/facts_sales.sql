

WITH new_sales AS (
    SELECT 
        InvoiceNo,
        InvoiceDate,
        CustomerID,
        StockCode,
        Quantity,
        UnitPrice,
        Quantity * UnitPrice AS total_amount
    FROM Retail_Analytics_dbt.DEV.retail_cleansed
    
    
    WHERE InvoiceDate > (SELECT MAX(InvoiceDate) FROM Retail_Analytics_dbt.DEV.facts_sales)
    
)

SELECT * FROM new_sales