SELECT pro.product_id
     , pro.product_name
     , mar.brand_name
     , cat.category_name
     , loj.store_name
     , COALESCE(est.quantity, 0) AS stock_quantity
     , DATEDIFF(day, ISNULL(pro.last_restock_date, pro.creation_date), GETDATE()) AS days_out_of_stock
FROM products pro WITH (NOLOCK)
LEFT JOIN stocks est WITH (NOLOCK) ON pro.product_id = est.product_id
LEFT JOIN stores loj WITH (NOLOCK) ON est.store_id = loj.store_id
LEFT JOIN brands mar WITH (NOLOCK) ON pro.brand_id = mar.brand_id
LEFT JOIN categories cat WITH (NOLOCK) ON pro.category_id = cat.category_id
WHERE (est.quantity IS NULL OR est.quantity <= 0)
  AND pro.discontinued = 0
ORDER BY days_out_of_stock DESC -- Prioriza itens faltando há mais tempo
       , loj.store_name
       , cat.category_name
