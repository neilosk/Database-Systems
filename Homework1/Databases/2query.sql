SELECT COUNT(*)
FROM (
  SELECT COUNT(DISTINCT movieid)
  FROM involved I
  JOIN person P ON I.personid = P.id
  GROUP BY I.movieid
  HAVING AVG(P.height) > 195
) as SubQuery


