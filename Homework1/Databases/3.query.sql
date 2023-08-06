SELECT MAX(numberOfDuplicates) 
FROM (
  SELECT COUNT(*) as numberOfDuplicates
  FROM movie_genre MG
  GROUP BY MG.movieid, MG.genre
  HAVING COUNT(*) > 1
) as subquery
