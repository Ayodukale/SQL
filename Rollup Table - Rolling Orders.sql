/*

Creating a subtable of daily and weekly rollup orders by using various joins and aggregations.


First I created a subtable of orders per day.
Joined this subtable to the dates rollup table to get a row for every date.
Cleaned up columns, applied aggregations.
I treated the join as a where clause so that it would join on dates I needed within the column. 
As opposed to the entire column.

*/ 

SELECT 
t1.date,
COALESCE (SUM(orders),0)      AS orders,
COALESCE (SUM(line_items), 0) AS line_items

FROM
dsv1069.dates_rollup as t1

LEFT Outer JOIN

    (
    SELECT 
    
    date(created_at)              as created_at_,
    COUNT(DISTINCT invoice_id)    as orders,
    COUNT(DISTINCT line_item_id)  as line_items
    
    FROM dsv1069.orders
    
    GROUP BY 
    created_at_
    
    
    ORDER BY 
    created_at_
    
    ) as t2

ON t2.created_at_ <= t1.date
AND t1.d7_ago < t2.created_at_


GROUP BY t1.date
ORDER BY t1.date DESC
