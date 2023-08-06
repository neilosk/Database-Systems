SELECT COUNT(*) as NumberOfCommonLanguages
FROM (
    SELECT CL.Language
    FROM countries_languages CL
    JOIN empires E ON CL.CountryCode = E.CountryCode
    WHERE E.Empire = 'Danish Empire'
    GROUP BY CL.Language
    HAVING COUNT(DISTINCT CL.CountryCode) = (
        SELECT COUNT(*) as NumberOfCountriesInEmpire
        FROM empires
        WHERE Empire = 'Benelux'
    )
) as CommonLanguages;

