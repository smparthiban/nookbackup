select b.* from(select a.* from (select V.* from (SELECT alloc_id, customer_name, product_description, product_category, allocated,

available_inventory, due_date,allocation_orders,backlog_orders,

order_quantity, demand_quantity, allocation_set_id, afc.display_value AS display_value, afc.id AS id, 2 AS sort_value  FROM (

SELECT alloc_id, customer_name, product_description, product_category, allocated,

available_inventory, due_date,
allocation_orders,backlog_orders,
order_quantity, demand_quantity, allocation_set_id FROM (

SELECT aa.id AS alloc_id,

aa.customer_name AS customer_name,

aa.product_description AS product_description,

aa.product_category AS product_category,

AVG(aa.allocated) AS allocated,

aa.allocation_set_id AS allocation_set_id,

aa.available_inventory as available_inventory,
(AVG(aa.allocated) - SUM(aoo.quantity)) as allocation_orders,
( SUM(aoo.quantity)-AVG(aa.allocated)) as backlog_orders,
 aa.due_date AS due_date, SUM(aoo.quantity) AS order_quantity, 0 AS demand_quantity

FROM app_order_allocations aoa

LEFT JOIN app_allocations aa ON aoa.allocation_id = aa.id

LEFT JOIN app_open_orders aoo ON aoa.order_id = aoo.id

GROUP BY alloc_id) AS it) AS ot

LEFT JOIN app_fiscal_calendars afc ON ot.due_date >= afc.start_date AND ot.due_date <= afc.end_date

LEFT JOIN app_allocation_sets aas ON ot.allocation_set_id = aas.id


WHERE afc.calendar = "Fiscal_Month" AND aas.is_master = 1 and afc.start_date >= /*'29/12/2013'*/ (select start_date from fiscal_calendars_report where calendar = 'Fiscal_Month'
and DATE_ADD(NOW(), INTERVAL 60 DAY) between start_date and end_date)

UNION ALL

SELECT alloc_id, customer_name, product_description, product_category, allocated,

available_inventory, due_date,allocation_orders,backlog_orders,

order_quantity, demand_quantity, allocation_set_id, afc.display_value as display_value, afc.id AS id, 2 AS sort_value  FROM (

select alloc_id, customer_name, product_description, product_category, allocated, available_inventory, due_date,

order_quantity, demand_quantity, allocation_set_id,allocation_orders,backlog_orders from (

SELECT aa.id AS alloc_id,

aa.customer_name as customer_name,

aa.product_description as product_description,

aa.product_category as product_category,

AVG(aa.allocated) AS allocated,

aa.allocation_set_id AS allocation_set_id,

aa.available_inventory as available_inventory,
(AVG(aa.allocated) - SUM(adp.quantity)) as allocation_orders,
(SUM(adp.quantity)-AVG(aa.allocated)) as backlog_orders,
aa.due_date AS due_date, 0 as order_quantity, SUM(adp.quantity) AS demand_quantity

FROM app_plan_allocations apa

LEFT JOIN app_allocations aa ON apa.allocation_id = aa.id

LEFT JOIN app_demand_plans adp ON apa.plan_id = adp.id

lEFT JOIN app_allocation_sets aas ON apa.id =aas.id

GROUP BY alloc_id) as it ) AS ot

LEFT JOIN fiscal_calendars_report afc ON ot.due_date >= afc.start_date AND ot.due_date <= afc.end_date

LEFT JOIN app_allocation_sets aas ON ot.allocation_set_id = aas.id

WHERE afc.calendar = "Fiscal_Month" AND aas.is_master = 1 and afc.start_date >= /*"2013-12-29"*/ (select start_date from fiscal_calendars_report where calendar = 'Fiscal_Month'
and DATE_ADD(NOW(), INTERVAL 60 DAY) between start_date and end_date) ) V

UNION ALL

select V.* from (SELECT alloc_id, customer_name, product_description, product_category, allocated,

available_inventory, due_date,allocation_orders,backlog_orders,

order_quantity, demand_quantity, allocation_set_id, case when afc.calendar in ('Fiscal_Week') then DATE_FORMAT(afc.start_date, '%m/%d/%Y')
 else null
end as display_value, afc.id AS id, 1 AS sort_value  FROM (

SELECT alloc_id, customer_name, product_description, product_category, allocated,

available_inventory, due_date,allocation_orders,backlog_orders,

order_quantity, demand_quantity, allocation_set_id FROM (

SELECT aa.id AS alloc_id,

aa.customer_name AS customer_name,

aa.product_description AS product_description,

aa.product_category AS product_category,

AVG(aa.allocated) AS allocated,

aa.allocation_set_id AS allocation_set_id,

aa.available_inventory as available_inventory,
(AVG(aa.allocated) - SUM(aoo.quantity)) as allocation_orders,
(SUM(aoo.quantity)-AVG(aa.allocated)) as backlog_orders,
 aa.due_date AS due_date, SUM(aoo.quantity) AS order_quantity, 0 AS demand_quantity

FROM app_order_allocations aoa

LEFT JOIN app_allocations aa ON aoa.allocation_id = aa.id

LEFT JOIN app_open_orders aoo ON aoa.order_id = aoo.id

GROUP BY alloc_id) AS it) AS ot

LEFT JOIN fiscal_calendars_report afc ON ot.due_date >= afc.start_date AND ot.due_date <= afc.end_date

LEFT JOIN app_allocation_sets aas ON ot.allocation_set_id = aas.id

WHERE afc.calendar = "Fiscal_Week" AND aas.is_master = 1 and afc.start_date < /*"2013-12-29"*/(select start_date from fiscal_calendars_report where calendar = 'Fiscal_Month'
and DATE_ADD(NOW(), INTERVAL 60 DAY) between start_date and end_date) and afc.start_date > sysdate()

UNION ALL

SELECT alloc_id, customer_name, product_description, product_category, allocated,

available_inventory, due_date,allocation_orders,backlog_orders,

order_quantity, demand_quantity, allocation_set_id, case when afc.calendar in ('Fiscal_Week') then DATE_FORMAT(afc.start_date, '%m/%d/%Y') 
 else null
end as display_value, afc.id AS id, 1 AS sort_value  FROM (

select alloc_id, customer_name, product_description, product_category, allocated, available_inventory, due_date,

order_quantity, demand_quantity, allocation_set_id,allocation_orders,backlog_orders
 from (

SELECT aa.id AS alloc_id,

aa.customer_name as customer_name,

aa.product_description as product_description,

aa.product_category as product_category,

AVG(aa.allocated) AS allocated,

aa.allocation_set_id AS allocation_set_id,

aa.available_inventory as available_inventory,

aa.due_date AS due_date, 0 AS order_quantity, SUM(adp.quantity) AS demand_quantity,

(AVG(aa.allocated) - SUM(adp.quantity)) as allocation_orders,
(SUM(adp.quantity)- AVG(aa.allocated) ) as backlog_orders

FROM app_plan_allocations apa

LEFT JOIN app_allocations aa ON apa.allocation_id = aa.id

LEFT JOIN app_demand_plans adp ON apa.plan_id = adp.id

lEFT JOIN app_allocation_sets aas ON apa.id = aas.id

GROUP BY alloc_id) as it ) AS ot

LEFT JOIN fiscal_calendars_report afc ON ot.due_date >= afc.start_date AND ot.due_date <= afc.end_date

LEFT JOIN app_allocation_sets aas ON ot.allocation_set_id = aas.id

WHERE afc.calendar = "Fiscal_Week" AND ot.allocation_set_id = 48 and afc.start_date < (select start_date from fiscal_calendars_report where calendar = 'Fiscal_Month'
 and DATE_ADD(NOW(), INTERVAL 60 DAY) between start_date and end_date) and afc.start_date > sysdate()) V) a ) as b

/*wq*/

order by a.sort_value, a.id;

 

 

 

 

select aso.description AS product_description,aso.category_desc AS product_category, SUM(aso.qty) AS backlog, cgc.customer_name from all_sales_orders aso
left join customer_group_codes cgc on aso.custom_group_code = cgc.group_code
 where requested_dlvy_date is not null 
and requested_dlvy_date < now() 
and order_status not in ("Billed","Shipped","Cancelled") GROUP BY aso.customer,aso.description,aso.category_desc


