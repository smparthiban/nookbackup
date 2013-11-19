SELECT tot.*
FROM
  (
  SELECT a.*
       , bq.backlog
  FROM
    (SELECT V.*
     FROM
       (SELECT alloc_id
             , customer_name
             , product_description
             , product_category
             , allocated
             , available_inventory
             , due_date
             , allocation_orders
             , backlog_orders
             , order_quantity
             , demand_quantity
             , allocation_set_id
             , afc.display_value AS display_value
             , afc.id AS id
             , 2 AS sort_value
        FROM
          (

          SELECT alloc_id
               , customer_name
               , product_description
               , product_category
               , allocated
               , available_inventory
               , due_date
               , allocation_orders
               , backlog_orders
               , order_quantity
               , demand_quantity
               , allocation_set_id
          FROM
            (

            SELECT aa.id AS alloc_id
                 , aa.customer_name AS customer_name
                 , aa.product_description AS product_description
                 , aa.product_category AS product_category
                 , avg(aa.allocated) AS allocated
                 , aa.allocation_set_id AS allocation_set_id
                 , aa.available_inventory AS available_inventory
                 , (avg(aa.allocated) - sum(aoo.quantity)) AS allocation_orders
                 , (sum(aoo.quantity) - avg(aa.allocated)) AS backlog_orders
                 , aa.due_date AS due_date
                 , sum(aoo.quantity) AS order_quantity
                 , 0 AS demand_quantity

            FROM
              app_order_allocations aoa

            LEFT JOIN app_allocations aa
            ON aoa.allocation_id = aa.id

            LEFT JOIN app_open_orders aoo
            ON aoa.order_id = aoo.id

            GROUP BY
              alloc_id) AS it) AS ot

        LEFT JOIN app_fiscal_calendars afc
        ON ot.due_date >= afc.start_date AND ot.due_date <= afc.end_date

        LEFT JOIN app_allocation_sets aas
        ON ot.allocation_set_id = aas.id


        WHERE
          afc.calendar = "Fiscal_Month"
          AND aas.is_master = 1
          AND afc.start_date >= /*'29/12/2013'*/ (SELECT start_date
                                                  FROM
                                                    fiscal_calendars_report
                                                  WHERE
                                                    calendar = 'Fiscal_Month'
                                                    AND date_add(now(), INTERVAL 60 DAY) BETWEEN start_date AND end_date)

       UNION ALL

       SELECT alloc_id
            , customer_name
            , product_description
            , product_category
            , allocated
            , available_inventory
            , due_date
            , allocation_orders
            , backlog_orders
            , order_quantity
            , demand_quantity
            , allocation_set_id
            , afc.display_value AS display_value
            , afc.id AS id
            , 2 AS sort_value
        FROM
          (

          SELECT alloc_id
               , customer_name
               , product_description
               , product_category
               , allocated
               , available_inventory
               , due_date
               , order_quantity
               , demand_quantity
               , allocation_set_id
               , allocation_orders
               , backlog_orders
          FROM
            (

            SELECT aa.id AS alloc_id
                 , aa.customer_name AS customer_name
                 , aa.product_description AS product_description
                 , aa.product_category AS product_category
                 , avg(aa.allocated) AS allocated
                 , aa.allocation_set_id AS allocation_set_id
                 , aa.available_inventory AS available_inventory
                 , (avg(aa.allocated) - sum(adp.quantity)) AS allocation_orders
                 , (sum(adp.quantity) - avg(aa.allocated)) AS backlog_orders
                 , aa.due_date AS due_date
                 , 0 AS order_quantity
                 , sum(adp.quantity) AS demand_quantity

            FROM
              app_plan_allocations apa

            LEFT JOIN app_allocations aa
            ON apa.allocation_id = aa.id

            LEFT JOIN app_demand_plans adp
            ON apa.plan_id = adp.id

            LEFT JOIN app_allocation_sets aas
            ON apa.id = aas.id

            GROUP BY
              alloc_id) AS it) AS ot

        LEFT JOIN fiscal_calendars_report afc
        ON ot.due_date >= afc.start_date AND ot.due_date <= afc.end_date

        LEFT JOIN app_allocation_sets aas
        ON ot.allocation_set_id = aas.id

        WHERE
          afc.calendar = "Fiscal_Month"
          AND aas.is_master = 1
          AND afc.start_date >= /*"2013-12-29"*/ (SELECT start_date
                                                  FROM
                                                    fiscal_calendars_report
                                                  WHERE
                                                    calendar = 'Fiscal_Month'
                                                    AND date_add(now(), INTERVAL 60 DAY) BETWEEN start_date AND end_date)) V

    UNION ALL

    SELECT V.*
     FROM
       (SELECT alloc_id
             , customer_name
             , product_description
             , product_category
             , allocated
             , available_inventory
             , due_date
             , allocation_orders
             , backlog_orders
             , order_quantity
             , demand_quantity
             , allocation_set_id
             , CASE
               WHEN afc.calendar IN ('Fiscal_Week') THEN
                 DATE_FORMAT(afc.start_date, '%m/%d/%Y')
               ELSE
                 NULL
               END AS display_value
             , afc.id AS id
             , 1 AS sort_value
        FROM
          (

          SELECT alloc_id
               , customer_name
               , product_description
               , product_category
               , allocated
               , available_inventory
               , due_date
               , allocation_orders
               , backlog_orders
               , order_quantity
               , demand_quantity
               , allocation_set_id
          FROM
            (

            SELECT aa.id AS alloc_id
                 , aa.customer_name AS customer_name
                 , aa.product_description AS product_description
                 , aa.product_category AS product_category
                 , avg(aa.allocated) AS allocated
                 , aa.allocation_set_id AS allocation_set_id
                 , aa.available_inventory AS available_inventory
                 , (avg(aa.allocated) - sum(aoo.quantity)) AS allocation_orders
                 , (sum(aoo.quantity) - avg(aa.allocated)) AS backlog_orders
                 , aa.due_date AS due_date
                 , sum(aoo.quantity) AS order_quantity
                 , 0 AS demand_quantity

            FROM
              app_order_allocations aoa

            LEFT JOIN app_allocations aa
            ON aoa.allocation_id = aa.id

            LEFT JOIN app_open_orders aoo
            ON aoa.order_id = aoo.id

            GROUP BY
              alloc_id) AS it) AS ot

        LEFT JOIN fiscal_calendars_report afc
        ON ot.due_date >= afc.start_date AND ot.due_date <= afc.end_date

        LEFT JOIN app_allocation_sets aas
        ON ot.allocation_set_id = aas.id

        WHERE
          afc.calendar = "Fiscal_Week"
          AND aas.is_master = 1
          AND afc.start_date < /*"2013-12-29"*/ (SELECT start_date
                                                 FROM
                                                   fiscal_calendars_report
                                                 WHERE
                                                   calendar = 'Fiscal_Month'
                                                   AND date_add(now(), INTERVAL 60 DAY) BETWEEN start_date AND end_date)
          AND afc.start_date > sysdate()

       UNION ALL

       SELECT alloc_id
            , customer_name
            , product_description
            , product_category
            , allocated
            , available_inventory
            , due_date
            , allocation_orders
            , backlog_orders
            , order_quantity
            , demand_quantity
            , allocation_set_id
            , CASE
              WHEN afc.calendar IN ('Fiscal_Week') THEN
                DATE_FORMAT(afc.start_date, '%m/%d/%Y')
              ELSE
                NULL
              END AS display_value
            , afc.id AS id
            , 1 AS sort_value
        FROM
          (

          SELECT alloc_id
               , customer_name
               , product_description
               , product_category
               , allocated
               , available_inventory
               , due_date
               , order_quantity
               , demand_quantity
               , allocation_set_id
               , allocation_orders
               , backlog_orders
          FROM
            (

            SELECT aa.id AS alloc_id
                 , aa.customer_name AS customer_name
                 , aa.product_description AS product_description
                 , aa.product_category AS product_category
                 , avg(aa.allocated) AS allocated
                 , aa.allocation_set_id AS allocation_set_id
                 , aa.available_inventory AS available_inventory
                 , aa.due_date AS due_date
                 , 0 AS order_quantity
                 , sum(adp.quantity) AS demand_quantity
                 , (avg(aa.allocated) - sum(adp.quantity)) AS allocation_orders
                 , (sum(adp.quantity) - avg(aa.allocated)) AS backlog_orders

            FROM
              app_plan_allocations apa

            LEFT JOIN app_allocations aa
            ON apa.allocation_id = aa.id

            LEFT JOIN app_demand_plans adp
            ON apa.plan_id = adp.id

            LEFT JOIN app_allocation_sets aas
            ON apa.id = aas.id

            GROUP BY
              alloc_id) AS it) AS ot

        LEFT JOIN fiscal_calendars_report afc
        ON ot.due_date >= afc.start_date AND ot.due_date <= afc.end_date

        LEFT JOIN app_allocation_sets aas
        ON ot.allocation_set_id = aas.id

        WHERE
          afc.calendar = "Fiscal_Week"
          AND aas.is_master = 1
          AND afc.start_date < (SELECT start_date
                                FROM
                                  fiscal_calendars_report
                                WHERE
                                  calendar = 'Fiscal_Month'
                                  AND date_add(now(), INTERVAL 60 DAY) BETWEEN start_date AND end_date)
          AND afc.start_date > sysdate()) V) a

  LEFT JOIN (SELECT aso.description AS product_description
                  , aso.category_desc AS product_category
                  , sum(aso.qty) AS backlog
                  , cgc.customer_name
             FROM
               all_sales_orders aso
             LEFT JOIN customer_group_codes cgc
             ON aso.custom_group_code = cgc.group_code
             WHERE
               requested_dlvy_date IS NOT NULL
               AND requested_dlvy_date < now()
               AND order_status NOT IN ("Billed", "Shipped", "Cancelled")
             GROUP BY
               aso.customer
             , aso.description
             , aso.category_desc) bq
  ON bq.customer_name = a.customer_name AND
  bq.product_category = a.product_category AND bq.product_description = a.product_description) tot
	
	/*wq*/

ORDER BY
  tot.sort_value
, tot.id;