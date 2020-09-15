SELECT 
t1.user_id,
t1.view_number,
t2.first_name,
t2.last_name,
t1.event_time,
t2.email_address,
t3.id as item_id,
t3.adjective,
t3.category,
t3.modifier,
t3.name,
t3.price




FROM 


  (
  SELECT
    user_id,
    item_id,
    event_time,
    ROW_NUMBER()
      OVER (PARTITION BY user_id ORDER BY event_time DESC) AS view_number
    
    
    FROM dsv1069.view_item_events
  
  ) as t1

LEFT JOIN dsv1069.users as t2
ON t1.user_id = t2.id

LEFT JOIN dsv1069.items as t3 
ON t1.item_id = t3.id

LEFT OUTER JOIN dsv1069.orders as t4
ON t1.item_id = t4.item_id
AND t1.user_id = t4.user_id

WHERE t4.invoice_id IS NULL 
--AND t4.item_id <> t1.item_id
LIMIT 100