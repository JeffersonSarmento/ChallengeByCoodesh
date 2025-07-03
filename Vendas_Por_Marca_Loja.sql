SELECT loj.store_name
     , mar.brand_name,
     , COUNT(DISTINCT ord.order_id) AS total_orders,
     , SUM(ite.quantity) AS total_items_sold,
     , SUM(ite.quantity * ite.list_price * (1 - ite.discount)) AS total_sales_value,
     , SUM(ite.quantity * ite.list_price * (1 - ite.discount)) / NULLIF(COUNT(DISTINCT ord.order_id), 0) AS avg_order_value
FROM order_items ite WITH (NOLOCK)
INNER JOIN orders ord WITH (NOLOCK) ON ite.order_id = ord.order_id
INNER JOIN products pro WITH (NOLOCK) ON ite.product_id = pro.product_id
INNER JOIN brands mar WITH (NOLOCK) ON pro.brand_id = mar.brand_id
INNER JOIN stores loj WITH (NOLOCK) ON ord.store_id = loj.store_id
WHERE ord.order_status = 'completed'  -- apenas pedidos finalizados
GROUP BY loj.store_name
       , mar.brand_name
ORDER BY loj.store_name
       , total_sales_value DESC
