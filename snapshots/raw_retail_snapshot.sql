{% snapshot raw_retail_snapshot %}

{{
    config(
        target_schema='DEV', 
        unique_key='InvoiceNo || StockCode',  
        strategy='timestamp',  
        updated_at="InvoiceDate"  
    )
}}

select * FROM {{ source('ecommerce', 'raw_retail_data') }}
{% endsnapshot %}
