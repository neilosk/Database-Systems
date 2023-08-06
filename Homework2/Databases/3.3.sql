SELECT SUM((cl.Percentage / 100) * c.Population) as NumberOfSpanishSpeakers
FROM countries c
JOIN countries_continents cc ON c.Code = cc.CountryCode
JOIN countries_languages cl ON c.Code = cl.CountryCode
WHERE cc.Continent = 'Europe'
  AND c.Population > 1000000
  AND cl.Language = 'Spanish';

