SELECT fun.staff_id
     , fun.first_name + ' ' + fun.last_name AS staff_name
     , fun.email
     , fun.phone
     , fun.position 
     , loj.store_name
     , DATEDIFF(month, fun.hire_date, GETDATE()) AS months_employed
     , CASE 
          WHEN fun.last_performance_review IS NULL THEN 'No review'
          WHEN fun.last_performance_review > 80 THEN 'High performer'
          ELSE 'Regular performer'
       END AS performance_rating
FROM staffs fun WITH (NOLOCK)
LEFT JOIN orders ord WITH (NOLOCK) ON fun.staff_id = ord.staff_id
                                  AND ord.order_date >= DATEADD(month, -3, GETDATE()) --apenas pedidos recentes
INNER JOIN stores loj WITH (NOLOCK) ON fun.store_id = loj.store_id
WHERE ord.order_id IS NULL
  AND fun.active = 1
  AND fun.hire_date <= DATEADD(month, -1, GETDATE()) --funcionários com mais de 1 mês
ORDER BY loj.store_name
       , months_employed DESC -- mais tempo de empresa (mais antigos primeiro)
       , fun.last_name
