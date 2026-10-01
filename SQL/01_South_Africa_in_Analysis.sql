USE [Covid Database]

SELECT
    l.continent,
    d.country,
    MAX(d.total_cases) AS total_cases,
    MAX(d.total_deaths) AS total_deaths,
    ROUND(
        MAX(d.total_deaths) / NULLIF(MAX(d.total_cases), 0) * 100,
        2
    ) AS DeathPercentage,
    MAX(v.people_fully_vaccinated) AS Vaccinations
FROM Deaths AS d
JOIN Vaccination AS v
    ON d.country = v.country
    AND d.date = v.date
JOIN Location AS l
    ON d.country = l.country
    AND v.country = l.country
WHERE l.continent = 'Africa'
AND d.country = 'South Africa'
GROUP BY
    l.continent,
    d.country
ORDER BY
    total_cases DESC;

 


SELECT
    country,
    YEAR(date) AS Year,
    MAX(total_cases) AS Total_Cases,
    MAX(total_deaths) AS Total_Deaths,
    ROUND(
        (MAX(total_deaths) * 100.0) / NULLIF(MAX(total_cases), 0),
        2
    ) AS Covid_Fatality_Rate
FROM Deaths
WHERE country IN (
    'United States',
    'Canada',
    'United Kingdom',
    'France',
    'Brazil',
    'Germany',
    'India',
    'China',
    'Japan',
    'South Africa',
    'Egypt',
    'Nigeria'
)
AND date >= '2020-01-01'
AND date < '2026-09-20'
GROUP BY
    country,
    YEAR(date)
ORDER BY
    country,
    Year;

Select 
    l.continent,
   d.country, 
    MAX(d.total_deaths) as Covid_Deaths
From Deaths AS d
JOIN location as l
ON d.country = l.country
WHERE YEAR(d.date) = 2021
AND d.new_deaths is not NULL
Group by d.country,
         l.continent
order by Covid_Deaths desc



SELECT
    YEAR(date) AS Years,
    MONTH(date) AS Months,
    Country,
    MAX(hosp_patients) AS People_Hospitalized
FROM Hosptializations 
WHERE Country = 'United States'
  AND date >= '2020-04-01'
  AND date < '2024-06-01'
GROUP BY 
    YEAR(date),
    MONTH(date),
    Country
ORDER BY 
    Years ASC,
    Months ASC;


SELECT
    country,
    Year(date) AS Year,
    MAX(stringency_index) AS Max_covid_restrictions
FROM Deaths
WHERE stringency_index IS NOT NULL
AND   Year(date) = 2021
AND stringency_index > 0
AND country IN (
        'United States',
        'Canada',
        'United Kingdom',
        'France',
        'Brazil',
        'Peru',
        'Germany',
        'India',
        'China',
        'Japan',
        'South Africa',
        'Morocco',
        'Egypt',
        'Nigeria',
        'Zimbabwe')
GROUP BY country,
        Year(date)
ORDER BY Max_covid_restrictions DESC;

SELECT
    d.code,
    d.country,
    MAX(d.total_cases) AS Total_Cases,
    MAX(d.total_deaths) AS Total_Deaths,
    ROUND(
        MAX(d.total_deaths) /
        NULLIF(MAX(d.total_cases), 0) * 100,
        2
    ) AS CFR_Percentage,
    MAX(l.diabetes_prevalence) AS Diabetes_Prevalence,
    MAX(l.median_age) AS Median_Age,
    MAX(l.gdp_per_capita) AS GDP_Per_Capita,
    MAX(l.population_density) AS Population_Density,
    MAX(l.extreme_poverty) AS Extreme_Poverty,
    MAX(l.handwashing_facilities) AS Handwashing_Facilities
FROM Deaths d
INNER JOIN Location l
    ON d.country = l.country
    AND d.date = l.date
WHERE l.continent IS NOT NULL
GROUP BY d.country,
         d.code
;
