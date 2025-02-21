

WITH rfm_base AS (
    SELECT 
        CustomerID,
        MAX(InvoiceDate) AS last_purchase_date,
        COUNT(DISTINCT InvoiceNo) AS frequency,
        SUM(Quantity * UnitPrice) AS monetary_value 
    FROM Retail_Analytics_dbt.DEV.retail_cleansed
    WHERE CustomerID IS NOT NULL
    GROUP BY CustomerID
),

rfm_scores AS (
    SELECT 
        CustomerID,
        DATEDIFF(day, last_purchase_date, CURRENT_DATE) AS recency, 
        frequency,
        monetary_value,

        NTILE(5) OVER (ORDER BY recency ASC) AS recency_score,
        NTILE(5) OVER (ORDER BY frequency DESC) AS frequency_score,
        NTILE(5) OVER (ORDER BY monetary_value DESC) AS monetary_score

    FROM rfm_base
),

rfm_segmentation AS (
    SELECT 
        CustomerID,
        recency,
        frequency,
        monetary_value,
        recency_score,
        frequency_score,
        monetary_score,
        
        recency_score + frequency_score + monetary_score AS rfm_total_score,

        CASE 
            WHEN recency_score >= 4 AND frequency_score >= 4 AND monetary_score >= 4 THEN 'Best Customers'
            WHEN recency_score >= 3 AND frequency_score >= 3 AND monetary_score >= 3 THEN 'Loyal Customers'
            WHEN recency_score >= 3 AND frequency_score <= 2 THEN 'New Customers'
            WHEN recency_score <= 2 AND frequency_score >= 4 THEN 'At Risk Customers'
            WHEN recency_score <= 2 AND frequency_score <= 2 THEN 'Lost Customers'
            ELSE 'Others'
        END AS customer_segment
    FROM rfm_scores
)

SELECT * FROM rfm_segmentation