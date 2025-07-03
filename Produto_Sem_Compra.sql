SELECT pro.product_id
     , pro.product_name
     , mar.brand_name
     , cat.category_name
     , pro.list_price AS current_price  -- Preço para análise
     , pro.model_year                   -- Aano do modelo se disponível
     , CASE 
          WHEN pro.discontinued = 1 THEN 'Discontinued'
          ELSE 'Active'
       END AS product_status            -- Status do produto
FROM products pro WITH (NOLOCK)
LEFT JOIN order_items ite WITH (NOLOCK) ON pro.product_id = ite.product_id
                                       AND ite.order_id IS NOT NULL
LEFT JOIN brands mar WITH (NOLOCK) ON pro.brand_id = mar.brand_id
LEFT JOIN categories cat WITH (NOLOCK) ON pro.category_id = cat.category_id
WHERE ite.product_id IS NULL
AND pro.discontinued = 0  --produtos ativos
ORDER BY pro.product_name
