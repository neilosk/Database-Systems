SELECT COUNT(*) as NumberOfCountries
FROM (
    SELECT CountryCode
    FROM countries_continents
    GROUP BY CountryCode
    HAVING COUNT(*) > 1
) as MultipleContinentCountries
JOIN countries_continents CC ON MultipleContinentCountries.CountryCode = CC.CountryCode
WHERE CC.Continent = 'Europe';
