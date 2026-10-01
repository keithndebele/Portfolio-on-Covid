USE [Covid Database]


SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'

---To check if the imported tables are imported correctly 


SELECT 
    TABLE_NAME,
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME IN (
    'Location',
    'Deaths',
    'Hosptializations',
    'CovidTesting',
    'Vaccination'
)
ORDER BY TABLE_NAME, ORDINAL_POSITION;

---- I have columns  that imported incorretly need to check if the contain anything before i delete them

SELECT 
    COUNT(F9) AS F9_NonNull,
    COUNT(F10) AS F10_NonNull,
    COUNT(F11) AS F11_NonNull
FROM CovidTesting;

SELECT 
    COUNT(F8) AS F8_NonNull,
    COUNT(F9) AS F9_NonNull,
    COUNT(F10) AS F10_NonNull,
    COUNT(F11) AS F11_NonNull
FROM Hosptializations;

SELECT COUNT(F11) AS F11_NonNull
FROM Vaccination;

---- Deleting the empty columns

ALTER TABLE CovidTesting
DROP COLUMN F9, F10, F11

SELECT * 
FROM Hosptializations

ALTER TABLE Hosptializations
DROP COLUMN F8, F9, F10 , F11

SELECT *
FROM Vaccination

ALTER TABLE Vaccination
DROP COLUMN F11


----To check for missing values in our tables 

SELECT
    COUNT(*) AS Total_Rows,
    SUM(CASE WHEN code IS NULL THEN 1 ELSE 0 END) AS Missing_Code,
    SUM(CASE WHEN country IS NULL THEN 1 ELSE 0 END) AS Missing_Country,
    SUM(CASE WHEN date IS NULL THEN 1 ELSE 0 END) AS Missing_Date,
    SUM(CASE WHEN total_tests IS NULL THEN 1 ELSE 0 END) AS Missing_Total_tests,
    SUM(CASE WHEN new_tests IS NULL THEN 1 ELSE 0 END) AS Missing_New_tests,
    SUM(CASE WHEN new_tests_smoothed IS NULL THEN 1 ELSE 0 END) AS Missing_tests_smoothed,
    SUM(CASE WHEN positive_rate IS NULL THEN 1 ELSE 0 END) AS Missing_positive_rate,
    SUM(CASE WHEN tests_per_case IS NULL THEN 1 ELSE 0 END) AS Missing_test_per_case
FROM CovidTesting;

SELECT
    COUNT(*) AS Total_Rows,
    SUM(CASE WHEN code IS NULL THEN 1 ELSE 0 END) AS Missing_Code,
    SUM(CASE WHEN country IS NULL THEN 1 ELSE 0 END) AS Missing_Country,
    SUM(CASE WHEN date IS NULL THEN 1 ELSE 0 END) AS Missing_Date,
    SUM(CASE WHEN total_cases IS NULL THEN 1 ELSE 0 END) AS Missing_Total_Cases,
    SUM(CASE WHEN new_cases IS NULL THEN 1 ELSE 0 END) AS Missing_New_Cases,
    SUM(CASE WHEN total_deaths IS NULL THEN 1 ELSE 0 END) AS Missing_Total_Deaths,
    SUM(CASE WHEN new_deaths IS NULL THEN 1 ELSE 0 END) AS Missing_New_Deaths
FROM Deaths;


SELECT
    COUNT(*) AS Total_Rows,
    SUM(CASE WHEN code IS NULL THEN 1 ELSE 0 END) AS Missing_Code,
    SUM(CASE WHEN country IS NULL THEN 1 ELSE 0 END) AS Missing_Country,
    SUM(CASE WHEN date IS NULL THEN 1 ELSE 0 END) AS Missing_Date,
    SUM(CASE WHEN hosp_patients IS NULL THEN 1 ELSE 0 END) AS Missing_hosp_patients,
    SUM(CASE WHEN weekly_hosp_admissions IS NULL THEN 1 ELSE 0 END) AS Missing_weekly_hosp_admissions,
    SUM(CASE WHEN icu_patients IS NULL THEN 1 ELSE 0 END) AS Missing_icu_patients,
    SUM(CASE WHEN weekly_icu_admissions IS NULL THEN 1 ELSE 0 END) AS Missing_weekly_icu_admissions
FROM Hosptializations;

SELECT
    COUNT(*) AS Total_Rows,
    SUM(CASE WHEN code IS NULL THEN 1 ELSE 0 END) AS Missing_Code,
    SUM(CASE WHEN country IS NULL THEN 1 ELSE 0 END) AS Missing_Country,
    SUM(CASE WHEN date IS NULL THEN 1 ELSE 0 END) AS Missing_Date,
    SUM(CASE WHEN population IS NULL THEN 1 ELSE 0 END) AS Missing_ppn,
    SUM(CASE WHEN population_density IS NULL THEN 1 ELSE 0 END) AS Missing_ppn_density,
    SUM(CASE WHEN median_age IS NULL THEN 1 ELSE 0 END) AS Missing_median_age,
    SUM(CASE WHEN gdp_per_capita IS NULL THEN 1 ELSE 0 END) AS Missing_gdp_per_capita,
    SUM(CASE WHEN extreme_poverty IS NULL THEN 1 ELSE 0 END) AS Missing_extreme_poverty,
    SUM(CASE WHEN diabetes_prevalence IS NULL THEN 1 ELSE 0 END) AS Missing_diabetes,
    SUM(CASE WHEN handwashing_facilities IS NULL THEN 1 ELSE 0 END) AS Missing_handwash
FROM Location;

SELECT
    COUNT(*) AS Total_Rows,
    SUM(CASE WHEN code IS NULL THEN 1 ELSE 0 END) AS Missing_Code,
    SUM(CASE WHEN country IS NULL THEN 1 ELSE 0 END) AS Missing_Country,
    SUM(CASE WHEN date IS NULL THEN 1 ELSE 0 END) AS Missing_Date,
    SUM(CASE WHEN total_vaccinations IS NULL THEN 1 ELSE 0 END) AS Missing_total_Vac,
    SUM(CASE WHEN people_vaccinated IS NULL THEN 1 ELSE 0 END) AS Missing_pple_vac,
    SUM(CASE WHEN people_fully_vaccinated IS NULL THEN 1 ELSE 0 END) AS Missing_people_fully_vaccinated,
    SUM(CASE WHEN total_boosters IS NULL THEN 1 ELSE 0 END) AS Missing_total_boosters,
    SUM(CASE WHEN new_vaccinations IS NULL THEN 1 ELSE 0 END) AS Missing_new_vaccinations,
    SUM(CASE WHEN new_vaccinations_smoothed IS NULL THEN 1 ELSE 0 END) AS Missing_new_vaccinations_smoothed,
    SUM(CASE WHEN new_people_vaccinated_smoothed IS NULL THEN 1 ELSE 0 END) AS Missing_new_people_vaccinated_smoothed
FROM Vaccination;

----To check if the columns contain values that can converted to appropriate data type from text for example to big integer then i can convert to appropriate data type

SELECT total_tests
FROM CovidTesting
WHERE total_tests IS NOT NULL
  AND TRY_CONVERT(BIGINT, total_tests) IS NULL;

ALTER TABLE CovidTesting
ALTER COLUMN total_tests BIGINT NULL;

SELECT new_tests
FROM CovidTesting
WHERE new_tests IS NOT NULL
  AND TRY_CONVERT(BIGINT, new_tests) IS NULL;

ALTER TABLE CovidTesting
ALTER COLUMN new_tests BIGINT NULL

SELECT new_tests_smoothed
FROM CovidTesting
WHERE new_tests_smoothed IS NOT NULL
  AND TRY_CONVERT(INT, new_tests_smoothed) IS NULL;

ALTER TABLE CovidTesting
ALTER COLUMN new_tests_smoothed BIGINT NULL

SELECT positive_rate
FROM CovidTesting
WHERE positive_rate IS NOT NULL
  AND TRY_CONVERT(FLOAT , positive_rate) IS NULL


ALTER TABLE CovidTesting
ALTER COLUMN positive_rate FLOAT NULL

SELECT tests_per_case
FROM CovidTesting
WHERE tests_per_case IS NOT NULL
  AND TRY_CONVERT(FLOAT , tests_per_case) IS NULL

ALTER TABLE CovidTesting
ALTER COLUMN tests_per_case FLOAT NULL

SELECT new_cases_smoothed
FROM Deaths
WHERE new_cases_smoothed IS NOT NULL
  AND TRY_CONVERT(FLOAT , new_cases_smoothed) IS NULL

ALTER TABLE Deaths
ALTER COLUMN new_cases_smoothed FLOAT NULL

SELECT new_deaths_smoothed
FROM Deaths
WHERE new_deaths_smoothed IS NOT NULL
  AND TRY_CONVERT(FLOAT , new_deaths_smoothed) IS NULL

ALTER TABLE Deaths
ALTER COLUMN new_deaths_smoothed FLOAT NULL


SELECT stringency_index
FROM Deaths
WHERE stringency_index IS NOT NULL
  AND TRY_CONVERT(FLOAT , stringency_index) IS NULL

ALTER TABLE Deaths
ALTER COLUMN stringency_index FLOAT NULL

SELECT reproduction_rate
FROM Deaths
WHERE reproduction_rate IS NOT NULL
  AND TRY_CONVERT(FLOAT , reproduction_rate) IS NULL


ALTER TABLE Deaths
ALTER COLUMN reproduction_rate FLOAT NULL

SELECT 
    hosp_patients,
    weekly_hosp_admissions,
    icu_patients,
    weekly_icu_admissions
FROM Hosptializations
WHERE 
    (hosp_patients IS NOT NULL 
        AND TRY_CONVERT(FLOAT, hosp_patients) IS NULL)
 OR (weekly_hosp_admissions IS NOT NULL 
        AND TRY_CONVERT(FLOAT, weekly_hosp_admissions) IS NULL)
 OR (icu_patients IS NOT NULL 
        AND TRY_CONVERT(FLOAT, icu_patients) IS NULL)
 OR (weekly_icu_admissions IS NOT NULL 
        AND TRY_CONVERT(FLOAT, weekly_icu_admissions) IS NULL)

ALTER TABLE Hosptializations
ALTER COLUMN hosp_patients FLOAT NULL

ALTER TABLE Hosptializations
ALTER COLUMN weekly_hosp_admissions FLOAT NULL

ALTER TABLE Hosptializations
ALTER COLUMN icu_patients FLOAT NULL

ALTER TABLE Hosptializations
ALTER COLUMN weekly_icu_admissions FLOAT NULL

SELECT 
    population_density,
    median_age,
    gdp_per_capita,
    extreme_poverty,
    diabetes_prevalence,
    handwashing_facilities
FROM Location
WHERE 
    ( population_density IS NOT NULL 
        AND TRY_CONVERT(FLOAT, population_density) IS NULL)
 OR (median_age IS NOT NULL 
        AND TRY_CONVERT(FLOAT, median_age) IS NULL)
 OR (gdp_per_capita IS NOT NULL 
        AND TRY_CONVERT(FLOAT, gdp_per_capita) IS NULL)
 OR (extreme_poverty IS NOT NULL 
        AND TRY_CONVERT(FLOAT, extreme_poverty) IS NULL)
 OR (diabetes_prevalence IS NOT NULL 
        AND TRY_CONVERT(FLOAT, diabetes_prevalence) IS NULL)
 OR (handwashing_facilities IS NOT NULL 
        AND TRY_CONVERT(FLOAT, handwashing_facilities) IS NULL)

ALTER TABLE Location
ALTER COLUMN population_density FLOAT NULL

ALTER TABLE Location
ALTER COLUMN median_age FLOAT NULL

ALTER TABLE Location
ALTER COLUMN gdp_per_capita FLOAT NULL

ALTER TABLE Location
ALTER COLUMN extreme_poverty FLOAT NULL

ALTER TABLE Location
ALTER COLUMN diabetes_prevalence FLOAT NULL

ALTER TABLE Location
ALTER COLUMN handwashing_facilities FLOAT NULL

SELECT 
    total_vaccinations,
    people_vaccinated,
    people_fully_vaccinated,
    total_boosters,
    new_vaccinations,
    new_vaccinations_smoothed,
    new_people_vaccinated_smoothed
FROM Vaccination
WHERE 
    ( total_vaccinations IS NOT NULL 
        AND TRY_CONVERT(FLOAT, total_vaccinations) IS NULL)
 OR (people_vaccinated IS NOT NULL 
        AND TRY_CONVERT(FLOAT, people_vaccinated) IS NULL)
 OR (people_fully_vaccinated IS NOT NULL 
        AND TRY_CONVERT(FLOAT, people_fully_vaccinated) IS NULL)
 OR (total_boosters IS NOT NULL 
        AND TRY_CONVERT(FLOAT, total_boosters) IS NULL)
 OR (new_vaccinations IS NOT NULL 
        AND TRY_CONVERT(FLOAT, new_vaccinations) IS NULL)
 OR (new_vaccinations_smoothed IS NOT NULL 
        AND TRY_CONVERT(FLOAT, new_vaccinations_smoothed) IS NULL)
OR (new_people_vaccinated_smoothed IS NOT NULL 
        AND TRY_CONVERT(FLOAT, new_people_vaccinated_smoothed) IS NULL)


ALTER TABLE Vaccination
ALTER COLUMN total_vaccinations FLOAT NULL

ALTER TABLE Vaccination
ALTER COLUMN people_vaccinated FLOAT NULL

ALTER TABLE Vaccination
ALTER COLUMN people_fully_vaccinated FLOAT NULL

ALTER TABLE Vaccination
ALTER COLUMN total_boosters FLOAT NULL

ALTER TABLE Vaccination
ALTER COLUMN new_vaccinations FLOAT NULL

ALTER TABLE Vaccination
ALTER COLUMN new_vaccinations_smoothed FLOAT NULL

ALTER TABLE Vaccination
ALTER COLUMN new_people_vaccinated_smoothed FLOAT NULL

-----Checking Duplicates
SELECT 
    country,
    date,
    COUNT(*) AS Number_of_Rows
FROM Location
GROUP BY country, date
HAVING COUNT(*) > 1
ORDER BY Number_of_Rows DESC

--------  Checking for negative values from columns where i expect no negative numbers

SELECT *
FROM CovidTesting
WHERE 
    TRY_CONVERT(FLOAT, total_tests) < 0
 OR TRY_CONVERT(FLOAT, new_tests) < 0
 OR TRY_CONVERT(FLOAT, new_tests_smoothed) < 0
 OR TRY_CONVERT(FLOAT, positive_rate) < 0
 OR TRY_CONVERT(FLOAT,tests_per_case) < 0


SELECT *
FROM Deaths
WHERE 
    TRY_CONVERT(FLOAT, total_cases) < 0
 OR TRY_CONVERT(FLOAT, new_cases) < 0
 OR TRY_CONVERT(FLOAT, new_cases_smoothed) < 0
 OR TRY_CONVERT(FLOAT, total_deaths) < 0
 OR TRY_CONVERT(FLOAT,new_deaths) < 0
 OR TRY_CONVERT(FLOAT,new_deaths_smoothed) < 0
 OR TRY_CONVERT(FLOAT,stringency_index) > 100
 OR TRY_CONVERT(FLOAT,reproduction_rate) < 0
ORDER BY stringency_index DESC

SELECT *
FROM Hosptializations
WHERE 
    TRY_CONVERT(FLOAT, hosp_patients) < 0
 OR TRY_CONVERT(FLOAT, weekly_hosp_admissions) < 0
 OR TRY_CONVERT(FLOAT, icu_patients) < 0
 OR TRY_CONVERT(FLOAT, weekly_icu_admissions) < 0

SELECT *
FROM Location
WHERE 
    TRY_CONVERT(FLOAT, population) < 0
 OR TRY_CONVERT(FLOAT, population_density) < 0
 OR TRY_CONVERT(FLOAT, median_age) < 0
 OR TRY_CONVERT(FLOAT, gdp_per_capita) < 0
 OR TRY_CONVERT(FLOAT,extreme_poverty) < 0
 OR TRY_CONVERT(FLOAT,diabetes_prevalence) < 0
 OR TRY_CONVERT(FLOAT,handwashing_facilities) < 0

SELECT *
FROM Vaccination
WHERE 
    TRY_CONVERT(FLOAT, total_vaccinations) < 0
 OR TRY_CONVERT(FLOAT, people_vaccinated) < 0
 OR TRY_CONVERT(FLOAT, people_fully_vaccinated) < 0
 OR TRY_CONVERT(FLOAT, total_boosters) < 0
 OR TRY_CONVERT(FLOAT,new_vaccinations) < 0
 OR TRY_CONVERT(FLOAT,new_vaccinations_smoothed) < 0
 OR TRY_CONVERT(FLOAT,new_people_vaccinated_smoothed) < 0


 ----To check my tables relationships 
SELECT  *
FROM Deaths AS d
INNER JOIN CovidTesting AS ct
    ON d.country = ct.country
   AND d.date = ct.date

SELECT * 
FROM deaths AS d
INNER JOIN Location AS l
ON d.country = l.country
AND d.code = l.code

SELECT *
FROM Location AS l
INNER JOIN Vaccination AS V
ON l.country = V.country
AND l.date = V.date





