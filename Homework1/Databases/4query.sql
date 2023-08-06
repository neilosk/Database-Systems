SELECT COUNT(DISTINCT P.id)
FROM involved I

JOIN person P On I.personid = P.id
JOIN (
	SELECT M.id
	FROM movie M
	WHERE M.id IN(
		SELECT movieid
		FROM involved I
		JOIN person P ON I.personid = P.id
		WHERE P.name = 'Roger Spottiswoode'
			AND I.role = 'director'
		)
	) AS directorsMovies ON I.movieid = directorsMovies.id
WHERE I.role = 'actor';