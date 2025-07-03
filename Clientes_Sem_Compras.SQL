SELECT cli.customer_id
     , cli.first_name + ' ' + cli.last_name AS customer_name
     , cli.email
     , cli.phone
     , cli.city + '/' + cli.state AS location  -- Contexto geográfico
FROM customers cli WITH (NOLOCK)
LEFT JOIN orders ord WITH (NOLOCK) ON cli.customer_id = ord.customer_id
WHERE ord.order_id IS NULL
AND cli.active = 1  -- Clientes ativos
ORDER BY cli.last_name
       , cli.first_name
