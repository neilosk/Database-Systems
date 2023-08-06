SELECT COUNT(*) 
FROM movie M
WHERE M.year = 2011
  AND (
    SELECT COUNT(*) 
    FROM role R
  ) = (
    SELECT COUNT(DISTINCT role)
    FROM involved I
    WHERE I.movieid = M.id
  );
  

