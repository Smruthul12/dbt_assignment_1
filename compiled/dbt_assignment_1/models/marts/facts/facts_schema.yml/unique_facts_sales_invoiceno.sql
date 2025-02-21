
    
    

select
    invoiceno as unique_field,
    count(*) as n_records

from Retail_Analytics_dbt.DEV.facts_sales
where invoiceno is not null
group by invoiceno
having count(*) > 1


