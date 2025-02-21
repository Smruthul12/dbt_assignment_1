
    
    

select
    month as unique_field,
    count(*) as n_records

from Retail_Analytics_dbt.DEV.sales_performance
where month is not null
group by month
having count(*) > 1


