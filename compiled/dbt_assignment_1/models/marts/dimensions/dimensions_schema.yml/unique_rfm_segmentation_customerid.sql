
    
    

select
    customerid as unique_field,
    count(*) as n_records

from Retail_Analytics_dbt.DEV.rfm_segmentation
where customerid is not null
group by customerid
having count(*) > 1


