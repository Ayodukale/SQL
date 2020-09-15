
/*

Examining the effectiveness of various experiments, such as an ad or product change
and their test groups, 0 being bassline and 1 being the variation. 
Focusing on their individual effectiveness in creating orders.
Looking at the total orders created, the average orders created, and the standard deviation of orders created.

*/






SELECT 
    test_id,
    test_assignment,
    COUNT(user_id) AS users,
    SUM(number_of_orders) AS total_orders,
    AVG(number_of_orders) AS avg_orders,
    STDDEV(number_of_orders) AS stddev_orders
FROM
         
         
        ( 
         SELECT  
            --    t1.event_time as test_date, 
                  t1.user_id,
                  t1.test_id,
                  t1.test_assignment,
            --    t2.created_at as order_date,
            --    t2.invoice_id,
                 -- COUNT(DISTINCT CASE WHEN t1.event_time < t2.created_at 
                 --  THEN '1' ELSE '0' END) AS order_binary,
                   COUNT(DISTINCT CASE WHEN t1.event_time < t2.created_at THEN t2.invoice_id ELSE NULL END) as number_of_orders,
                   COUNT(DISTINCT CASE WHEN t1.event_time < t2.created_at THEN t2.line_item_id ELSE NULL END) as number_of_items,
                   COALESCE(SUM( CASE WHEN t1.event_time < t2.created_at THEN t2.price ELSE 0 END), 0) as total_revenue
                   
          
          FROM dsv1069.orders as t2
          RIGHT OUTER JOIN 
          
                          (
                          SELECT 
                                event_id, 
                                event_time, 
                                event_name, 
                                user_id, 
                                MAX(CASE WHEN parameter_name = 'test_id' 
                                 THEN CAST (parameter_value AS INT)
                                 ELSE NULL 
                                 END) AS test_id,
                                 
                                 MAX(CASE WHEN parameter_name = 'test_assignment' 
                                 THEN parameter_value
                                 ELSE NULL 
                                 END) AS test_assignment
                                 
                          FROM dsv1069.events
                          WHERE  parameter_name IN ('test_id', 'test_assignment')
                          
                          Group By 
                                user_id,
                                event_id, 
                                event_time, 
                                event_name
                          
                          ORDER BY event_id
                          
                          ) as t1
          
          ON t1.user_id = t2.user_id
          
          
          GROUP BY t1.user_id, 
                   t1.event_id,
                   t1.test_id,
                   t1.test_assignment
                   ) as t3
                   
GROUP BY 
t3.test_id,
t3.test_assignment

ORDER BY 
t3.test_id
