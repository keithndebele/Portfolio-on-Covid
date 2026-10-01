USE [Covid Database]

---1---Global impact of covid

Select 
	MAX(d.total_cases) as total_cases, 
	MAX(d.total_deaths) as total_deaths, 
	ROUND(MAX(d.total_deaths)/MAX(d.total_cases)*100,2) as DeathPercentage,
    MAX(v.people_fully_vaccinated) As Vaccinations
From Deaths As d
JOIN Vaccination AS v
ON d.country = v.country 
order by 1,2

--2-Global infection rate over the years 

 SELECT
    YEAR(date) AS Year,
    SUM(new_cases) AS Global_Infection
FROM Deaths
WHERE date >= '2020'
  AND date < '2027'
GROUP BY
    YEAR(date)
ORDER BY
    Year

---3--What is the global monthly infections for 2020,2021 & 2022?

SELECT
    YEAR(date) AS Year,
    MONTH(date) AS Month,
    MAX(new_cases) AS Global_New_Cases
FROM Deaths
WHERE date >= '2020-01-01'
  AND date < '2023-01-01'
GROUP BY
    YEAR(date),
    MONTH(date)
ORDER BY
    Year,
    Month

---4--Is population density associated with infection rate

SELECT TOP 10
    l.country,
    l.continent,
    l.population_density,
    l.population,
    MAX(d.total_cases) AS Total_Cases,
    (MAX(d.total_cases) / NULLIF(l.population, 0)) * 100
        AS Infection_Rate
FROM Location AS l
INNER JOIN Deaths AS d
    ON l.country = d.country
WHERE l.population_density IS NOT NULL
  AND l.population_density >0
  AND l.population > 0
  AND d.total_cases IS NOT NULL
GROUP BY
    l.country,
    l.continent,
    l.population_density,
    l.population
ORDER BY population_density DESC;

---5-Monthly infections in from january 2021 to january 2022 in South Africa

SELECT
    Country,
    YEAR(date) AS Year,
    MONTH(date) AS Month,
    SUM(new_cases) AS SA_Monthly_Infections
FROM Deaths 
WHERE country ='South Africa'
AND date >= '2021-01-01'
AND date < '2022-01-01'
GROUP BY
    Country,
    YEAR(date),
    MONTH(date)
ORDER BY
    Country,
    Year,
    Month

---6--What percentage of a country's population was recorded as having COVID-19?----

SELECT TOP 10
    d.country,
    l.continent,
    l.population,
    MAX(d.total_cases) AS Total_Cases,
    (MAX(d.total_cases) / NULLIF(l.population, 0)) * 100 AS Infection_Rate_Percentage
FROM Deaths AS d
INNER JOIN Location AS l
    ON d.country = l.country
WHERE d.total_cases IS NOT NULL
  AND l.population IS NOT NULL
GROUP BY
    d.country,
    l.continent,
    l.population
ORDER BY Infection_Rate_Percentage DESC;


--7--Countries with high covid cases 

SELECT TOP 10
    l.continent,
    d.country,
    MAX(d.total_cases) AS Total_Covid_Cases
FROM Deaths AS d
INNER JOIN Location AS l
    ON d.country = l.country
WHERE d.total_cases IS NOT NULL
GROUP BY
    d.country,
    l.continent
ORDER BY Total_Covid_Cases DESC;

--8--African countries with high covid cases 

SELECT TOP 10
    l.continent,
    d.country,
    MAX(d.total_cases) AS Total_Covid_Cases
FROM Deaths AS d
INNER JOIN Location AS l
    ON d.country = l.country
WHERE d.total_cases IS NOT NULL
AND continent = 'Africa'
GROUP BY
    d.country,
    l.continent
ORDER BY Total_Covid_Cases DESC;


--9-----Which countries lost most people to covid

SELECT
    TOP 10
    country,
    MAX(total_deaths) AS Total_Deaths
FROM Deaths
WHERE country IS NOT NULL
GROUP BY country
ORDER BY Total_Deaths DESC

--10-----Which african countries lost most people to covid

SELECT
    TOP 10
    l.continent,
    d.country,
    MAX(d.total_deaths) AS Total_Deaths
FROM Deaths As d
JOIN Location As l
ON d.country = l.country
WHERE d.country IS NOT NULL
AND  l.continent = 'Africa'
GROUP BY d.country,
         l.continent
ORDER BY Total_Deaths DESC

--11----Which african countries lost less people to covid

SELECT
    TOP 10
    l.continent,
    d.country,
    MAX(d.total_deaths) AS Total_Deaths
FROM Deaths As d
JOIN Location As l
ON d.country = l.country
WHERE d.country IS NOT NULL
AND  l.continent = 'Africa'
GROUP BY d.country,
         l.continent
ORDER BY Total_Deaths ASC


---12--Which countries experienced the highest number of COVID deaths compared to their population

SELECT TOP 10
    d.country,
    l.continent,
    l.population,
    MAX(d.total_deaths) AS Total_Deaths,
    (MAX(Total_deaths) / NULLIF(l.population, 0)) * 100 AS Death_Rate_Percentage
FROM Deaths AS d
INNER JOIN Location AS l
    ON d.country = l.country
WHERE d.total_deaths IS NOT NULL
  AND l.population IS NOT NULL
GROUP BY
    d.country,
    l.continent,
    l.population
ORDER BY Death_Rate_Percentage DESC;


---13-- Covid death rate by month in South Africa 2020

SELECT*
FROM Deaths


SELECT
    country,
    YEAR(date) AS Year,
    MONTH(date) AS Month,
    SUM(total_deaths) AS Total_Monthly_Death_Rate
FROM Deaths
WHERE country ='South Africa'
  AND date >= '2020-01-01'
  AND date < '2021-01-01'
GROUP BY
    Country,
    YEAR(date),
    MONTH(date)
ORDER BY
    Year,
    Month

--14-- Yearly COVID-19 Fatality Rate in USA, Canada, UK, France, Brazil, Germany,India, China, Japan, South Africa, Egypt, Nigeria, Zimbabwe

SELECT
    country,
    YEAR(date) AS Year,
    MAX(total_cases) AS Total_Cases,
    MAX(total_deaths) AS Total_Deaths,
    ROUND(
        (MAX(total_deaths) * 100.0) / NULLIF(MAX(total_cases), 0),
        2
    ) AS Fatality_Rate_Percentage
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
    'Nigeria',
    'Zimbabwe'
)
AND date >= '2020-01-01'
AND date < '2026-09-20'
GROUP BY
    country,
    YEAR(date)
ORDER BY
    country,
    Year;
    
--15 -Which continent had the highest death rate relative to cases

SELECT
    l.continent,
    SUM(d.total_cases) AS total_cases,
    SUM(d.total_deaths) AS total_deaths,
    ROUND(
        (SUM(d.total_deaths) / NULLIF(SUM(d.total_cases), 0)) * 100,
        2
    ) AS Death_Rate_To_Cases
FROM Deaths AS d
INNER JOIN Location AS l
    ON l.country = d.country
WHERE l.continent IS NOT NULL
GROUP BY
    l.continent
ORDER BY
    Death_Rate_To_Cases DESC;

--16-Which countries had the highest death rate relative to cases

SELECT
    TOP 10
    l.country,
    SUM(d.total_cases) AS total_cases,
    SUM(d.total_deaths) AS total_deaths,
    ROUND(
        (SUM(d.total_deaths) / NULLIF(SUM(d.total_cases), 0)) * 100,
        2
    ) AS Death_Rate_To_Cases
FROM Deaths AS d
INNER JOIN Location AS l
    ON l.country = d.country
WHERE l.continent IS NOT NULL
GROUP BY
    l.country
ORDER BY
    Death_Rate_To_Cases DESC;

---17-- Impact of covid in 2021 to older people

WITH Impact_in_2021 AS
(
    SELECT
        d.country,
        d.date,
        d.total_cases,
        d.total_deaths,
        ROW_NUMBER() OVER (
            PARTITION BY d.country
            ORDER BY d.date DESC
        ) AS rn
    FROM Deaths AS d
    WHERE d.total_cases IS NOT NULL
      AND d.total_deaths IS NOT NULL
      AND d.date >= '2021-01-01'
      AND d.date < '2022-01-01'
)

SELECT TOP 10
    l.country,
    l.continent,
    l.median_age,
    d.total_cases AS Total_Cases,
    d.total_deaths AS Total_Deaths,

    ROUND(
        (d.total_deaths * 100.0) / NULLIF(d.total_cases, 0),
        2
    ) AS Death_Rate

FROM Location AS l
INNER JOIN Impact_in_2021 AS d
    ON l.country = d.country
    AND l.date = d.date

WHERE d.rn = 1
  AND l.median_age IS NOT NULL

ORDER BY
    l.median_age DESC;

---18--Which countries conducted the most COVID-19 tests?

WITH TestingData AS
(SELECT
        country,
        date,
        total_tests,
        ROW_NUMBER() OVER
        (
            PARTITION BY country
            ORDER BY date DESC
        ) AS Tests_by_Country
    FROM CovidTesting
    WHERE total_tests IS NOT NULL
        AND total_tests > 0
        AND country IS NOT NULL
)

SELECT TOP 10
    country,
    total_tests AS Total_Tests,
    date AS Latest_Testing_Date
FROM TestingData
WHERE Tests_by_Country = 1
ORDER BY
    Total_Tests DESC;

---19--Which african countries conducted the most COVID-19 tests?

WITH TestingData AS
(
    SELECT
        l.continent,
        ct.country,
        ct.date,
        ct.total_tests,
        ROW_NUMBER() OVER
        (
            PARTITION BY ct.country
            ORDER BY ct.date DESC
        ) AS Tests_by_Country
    FROM CovidTesting AS ct
    JOIN Location AS l
        ON ct.country = l.country
    WHERE ct.total_tests IS NOT NULL
        AND ct.total_tests > 0
        AND ct.country IS NOT NULL
 )
SELECT TOP 10
    continent,
    country,
    total_tests AS Total_Tests,
    date AS Latest_Testing_Date
FROM TestingData
WHERE Tests_by_Country = 1
    AND continent = 'Africa'
ORDER BY
    Total_Tests DESC;



--20 --Which countries had the highest COVID positivity rates?

SELECT*
FROM CovidTesting

SELECT
    country,
    AVG(positive_rate) AS Average_Positive_Rate
FROM CovidTesting
WHERE positive_rate IS NOT NULL
GROUP BY country
ORDER BY Average_Positive_Rate DESC;

---21--Which countries experienced the greatest hospital pressure

SELECT
    TOP 10
    country,
    MAX(hosp_patients) AS Peak_Hospital_Patients
FROM Hosptializations
WHERE hosp_patients IS NOT NULL
GROUP BY country
ORDER BY Peak_Hospital_Patients DESC;

---22-Hospital Pressure In South Africa in 2020

SELECT
        MONTH (date) AS Months,
        YEAR (date)AS Years,
        Country,
        MAX(hosp_patients) AS People_Hospitalized
FROM Hosptializations 
WHERE country = 'South Africa'
AND YEAR(date) = 2020
GROUP BY MONTH(date),
       YEAR(date),
       country
ORDER BY MONTH(date) ASC

--23----Which European countries experienced the greatest hospital pressure

SELECT
    TOP 10
    l.continent,
    h.country,
    MAX(h.hosp_patients) AS Peak_Hospital_Patients
FROM Hosptializations AS h
JOIN Location AS l
ON h.country = l.country
WHERE hosp_patients IS NOT NULL
AND  hosp_patients  > 0
AND l.continent = 'Europe'
GROUP BY h.country,
        l.continent
ORDER BY Peak_Hospital_Patients DESC;

SELECT
    TOP 10
    l.continent,
    h.country,
    MAX(h.hosp_patients) AS Peak_Hospital_Patients
FROM Hosptializations AS h
JOIN Location AS l
ON h.country = l.country
WHERE hosp_patients IS NOT NULL
AND  hosp_patients  > 0
AND l.continent = 'Africa'
GROUP BY h.country,
        l.continent
ORDER BY Peak_Hospital_Patients DESC;

---24--- Countries with most patients in ICU

SELECT
    TOP 10
    country,
    MAX(icu_patients) AS Most_ICU_Patients
FROM Hosptializations 
WHERE icu_patients IS NOT NULL
AND  icu_patients  > 0
GROUP BY country
ORDER BY Most_ICU_Patients DESC;


---25--Vaccination in south africa in 2022

SELECT
        MONTH (date) AS Months,
        YEAR (date)AS Years,
        Country,
        Max(people_vaccinated) AS People_Vaccinated 
FROM Vaccination
WHERE country = 'South Africa'
AND YEAR(date) = 2022
GROUP BY MONTH(date),
       YEAR(date),
       country
ORDER BY MONTH(date) ASC

---26--Which 10 countries received at least COVID vaccine dose compared to country's population  ?

SELECT TOP 10
    v.country,
    l.continent,
    l.population,
    MAX(v.people_vaccinated) AS People_Vaccinated,
    (MAX(v.people_vaccinated) / NULLIF(l.population, 0)) * 100
        AS Vaccination_Percentage
FROM Vaccination AS v
JOIN Location AS l
    ON v.country = l.country
WHERE v.people_vaccinated IS NOT NULL
  AND l.population IS NOT NULL
  AND l.population > 0
  AND v.people_vaccinated > 0
GROUP BY
    v.country,
    l.continent,
    l.population
ORDER BY Vaccination_Percentage ASC;


---27--Which selected countries received the COVID vaccine dose compared to country's population  


SELECT
    v.country,
    l.continent,
    l.population,
    MAX(v.people_vaccinated) AS People_Vaccinated,
    ROUND(
        (MAX(v.people_vaccinated) * 100.0) / NULLIF(l.population, 0),
        0
    ) AS Vaccination_Percentage
FROM Vaccination AS v
INNER JOIN Location AS l
    ON v.country = l.country
WHERE v.people_vaccinated IS NOT NULL
    AND v.country IN (
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
        'Zimbabwe'
    )
    AND l.population IS NOT NULL
    AND l.population > 0
    AND v.people_vaccinated > 0
GROUP BY
    v.country,
    l.continent,
    l.population
ORDER BY
    Vaccination_Percentage DESC;

--28--Which countries had the strictest COVID restrictions

SELECT TOP 10
    country,
    MAX(stringency_index) AS Max_covid_restrictions
FROM Deaths
WHERE stringency_index IS NOT NULL
AND stringency_index > 0
GROUP BY country
ORDER BY Max_covid_restrictions DESC;

SELECT
    country,
    Year(date),
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




--29--Reproduction rate in USA during covid

SELECT
    country,
    YEAR(date) AS Year,
    MONTH(date) AS Month,
    ROUND(AVG(reproduction_rate), 2) AS Average_Reproduction_Rate
FROM Deaths
WHERE country = 'United States'
  AND reproduction_rate IS NOT NULL
        AND YEAR(date) >= 2020
      AND YEAR(date)< '2023'
GROUP BY
    country,
    YEAR(date),
    MONTH(date)
ORDER BY
    Year,
    Month;

---30--Did vaccination reduce the death rate
SELECT
    d.country,
    YEAR(d.date) AS Year,
    MONTH(d.date) AS Month,

    MAX(d.total_cases) AS Total_Cases,
    MAX(d.total_deaths) AS Total_Deaths,
    MAX(v.people_fully_vaccinated) AS People_Fully_Vaccinated,
    MAX(l.population) AS Population,

    ROUND(
        (MAX(d.total_deaths) / NULLIF(MAX(d.total_cases), 0)) * 100,
        2
    ) AS Case_Fatality_Rate,

    ROUND(
        (MAX(v.people_fully_vaccinated) / NULLIF(MAX(l.population), 0)) * 100,
        2
    ) AS Vaccination_Rate

FROM Deaths d

INNER JOIN Vaccination v
    ON d.country = v.country
    AND d.date = v.date

INNER JOIN Location l
    ON d.country = l.country
    AND d.date = l.date

WHERE v.people_fully_vaccinated > 0
AND d.country = 'United States'

GROUP BY
    d.country,
    YEAR(d.date),
    MONTH(d.date)

ORDER BY
    d.country,
    Year,
    Month;




























