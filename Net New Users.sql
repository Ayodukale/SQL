SELECT 
  new.day,
  new.users,
  COALESCE(deleted.deleted_users, 0 ) as deleted_users,
  COALESCE(merged.merged_users, 0 ) as merged_users,
  (new.users - COALESCE(deleted.deleted_users, 0 ) - COALESCE(merged.merged_users, 0 )) AS net_added_users
FROM

  (SELECT COUNT(*) as users, Date(created_at) as day
  FROM dsv1069.users
  --WHERE deleted_at IS NULL AND merged_at IS NULL
  
  Group By Date(created_at)
  ORDER By Date(created_at)) new
  
LEFT JOIN

    (SELECT COUNT(*) as deleted_users, Date(deleted_at) as day
    FROM dsv1069.users
    WHERE deleted_at IS NOT NULL 
    
    Group By Date(deleted_at)
    ) deleted 
  ON deleted.day = new.day

LEFT JOIN 
    (SELECT COUNT(*) as merged_users, Date(merged_at) as day
    FROM dsv1069.users
    WHERE id = parent_user_id 
    --AND 
      --parent_user_id IS NOT NULL
    
    Group By Date(merged_at) 
    ) as merged
    ON merged.day = new.day

ORDER BY new.day DESC