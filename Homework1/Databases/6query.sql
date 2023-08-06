SELECT MAX(cnt)
FROM(
	SELECT COUNT(*) AS cnt
	FROM person P
		JOIN involved AS I1 ON P.id = I1.personid AND I1.role = 'actor'
		JOIN involved AS I2 ON P.id = I2.personid AND I2.role = 'director'
		JOIN movie M ON I1.movieid = M.id AND I2.movieid = M.id
		GROUP BY P.id
			HAVING COUNT(*) > 1
) AS Sub;
