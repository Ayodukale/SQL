/*

Checking to see the variation in effectiveness of an experiment, such as a new email campaign.
Focusing on test_id 7.
Comparing if the baseline group, 0, viewed the site/product more than the experiment group, 1.
And comparing how many viewed within 30 days of the experiment.

*/



SELECT 
t3.test_assignment,
COUNT(user_id)         AS users,
SUM(views_binary)      AS views_binary,
SUM(views_within_30)   AS views_within_30
FROM

          (
          SELECT  
            --    t1.event_time as test_date, 
                  t1.user_id,
                  t1.test_id,
                  t1.test_assignment,
            --    t2.created_at as order_date,
            --    t2.invoice_id,
                  MAX(CASE WHEN t1.event_time < t2.event_time
                   THEN 1 ELSE 0 END) AS views_binary,
                  MAX(CASE WHEN (t1.event_time < t2.event_time AND 
                   DATE_PART('day', t2.event_time - t1.event_time ) <=30) THEN 1 ELSE 0 END)  AS views_within_30
          
          FROM dsv1069.view_item_events as t2
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
                   t1.test_assignment,
                   t1.test_id
                   
                   
          ) as t3


WHERE test_id = '7'
--AND t2.event_time  


GROUP BY test_assignment







--WHERE t1.event_time < t2.created_at
--SELECT *
--FROM dsv1069.events
--WHERE event_name = 'test_assignment' 
--GROUP BY parameter_name
