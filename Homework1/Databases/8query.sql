

SELECT COUNT(DISTINCT personid) 
FROM (
  SELECT I.personid
  FROM involved AS I
  JOIN movie_genre AS MG ON I.movieid = MG.movieid
  JOIN genre AS GE ON MG.genre = GE.genre
  WHERE GE.category = 'Popular'
  GROUP BY I.personid
  HAVING COUNT(DISTINCT MG.genre) = (
    SELECT COUNT(*)
    FROM genre
    WHERE category = 'Popular'
  )
) AS subquery;










