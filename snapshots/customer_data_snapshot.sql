{% snapshot customer_data_snapshot %}

{{
    config(
        target_schema='DEV',
        unique_key='CustomerID',
        strategy='timestamp',
        updated_at='last_purchase_date'
    )
}}

SELECT 
    CustomerID,
    Country,
    last_purchase_date,
    customer_segment
FROM {{ ref('customer_details') }}

{% endsnapshot %}
