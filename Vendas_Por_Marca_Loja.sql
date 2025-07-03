SELECT loj.store_name
     , mar.brand_name
     , COUNT(DISTINCT ord.order_id) AS total_orders
     , SUM(ite.quantity) AS total_items_sold
     , SUM(ite.quantity * ite.list_price * (1 - ite.discount)) AS total_sales_value
     , SUM(ite.quantity * ite.list_price * (1 - ite.discount)) / NULLIF(COUNT(DISTINCT ord.order_id), 0) AS avg_order_value
     , COUNT(DISTINCT ord.customer_id) AS unique_customers
     , SUM(CASE WHEN pro.category_id = 1 THEN ite.quantity ELSE 0 END) AS category_1_items
     , MAX(ord.order_date) AS last_order_date
FROM order_items ite WITH (NOLOCK)
INNER JOIN orders ord WITH (NOLOCK) ON ite.order_id = ord.order_id
                                   AND ord.order_date BETWEEN DATEADD(month, -6, GETDATE()) AND GETDATE() -- Filtro temporal
INNER JOIN products pro WITH (NOLOCK) ON ite.product_id = pro.product_id
                                     AND pro.discontinued = 0 --produtos ativos
INNER JOIN brands mar WITH (NOLOCK) ON pro.brand_id = mar.brand_id
INNER JOIN stores loj WITH (NOLOCK) ON ord.store_id = loj.store_id
WHERE ord.order_status = 'completed'
  AND loj.is_active = 1 -- Apenas lojas ativas
GROUP BY loj.store_name
       , mar.brand_name
ORDER BY loj.store_name
       , total_sales_value DESC
