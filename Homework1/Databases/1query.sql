SELECT COUNT(*)
FROM(
	SELECT *
	FROM person P
	WHERE P.gender = 'f'
	 ) tmp;