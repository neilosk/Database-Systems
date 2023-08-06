SELECT COUNT(*) 
FROM movie M
LEFT JOIN involved I ON M.id = I.movieid
WHERE I.movieid IS NULL AND M.year = 2011;
