/* 
   Project: COVID-19 Portfolio (SQL Data Analysis)
   Author: Mohammed Sharif Hossain
   File: 3_analysis_queries.sql
   Purpose:This file contains all calculated column creation and analytical 
   SQL queries for the COVID-19 portfolio project.
  */

--Add the new column case_fatality_rate for to know about how much death rate in covid case rate 
ALTER TABLE covid_cases 
ADD case_fatality_rate FLOAT;

--Update the new column
UPDATE covid_cases
SET case_fatality_rate = 
    CASE 
        WHEN total_cases > 0 THEN (total_deaths * 100.0 / total_cases)
        ELSE 0 
    END;

select * 
from covid_cases

--Create new column for calulating daily growth rate 
ALTER TABLE covid_cases
ADD daily_growth_rate FLOAT;


WITH DailyGrowth AS (
    SELECT 
        c.primary_key,
        ci.country,
        c.date,
        c.new_cases,
        LAG(c.total_cases) OVER (PARTITION BY ci.country ORDER BY c.date) AS prev_total_cases
    FROM covid_cases c
    JOIN country_info ci ON c.primary_key = ci.primary_key
)
UPDATE c
SET c.daily_growth_rate = 
    CASE 
        WHEN dg.prev_total_cases > 0 THEN (dg.new_cases * 100.0 / dg.prev_total_cases)
        ELSE 0 
    END
FROM covid_cases c
JOIN DailyGrowth dg 
    ON c.primary_key = dg.primary_key;

--for validating 
SELECT 
    ci.country,
    c.date,
    c.total_cases,
    c.new_cases,
    c.daily_growth_rate
FROM covid_cases c
JOIN country_info ci ON c.primary_key = ci.primary_key
ORDER BY ci.country asc, c.date;  

--Create new column in covid_case table for calculation weekly average case 
ALTER TABLE covid_cases
ADD weekly_avg_cases FLOAT;


--Calculation 
WITH WeeklyAvg AS (
    SELECT 
        c.primary_key,
        ci.country,
        c.date,
        AVG(c.total_cases) OVER (
            PARTITION BY ci.country 
            ORDER BY c.date 
            ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
        ) AS rolling_avg_cases
    FROM covid_cases c
    JOIN country_info ci ON c.primary_key = ci.primary_key
)
UPDATE c
SET c.weekly_avg_cases = w.rolling_avg_cases
FROM covid_cases c
JOIN WeeklyAvg w ON c.primary_key = w.primary_key;

--For validation 

SELECT TOP 500
    ci.country,
    c.date,
    c.total_cases,
    c.weekly_avg_cases
FROM covid_cases c
JOIN country_info ci ON c.primary_key = ci.primary_key
WHERE ci.country = 'Bangladesh'
ORDER BY c.date;

--Create new column in covid_case table for calculating  weekly average deaths  

ALTER TABLE covid_cases
ADD weekly_avg_deaths FLOAT;


WITH WeeklyAvgDeaths AS (
    SELECT 
        c.primary_key,
        ci.country,
        c.date,
        AVG(c.new_deaths) OVER (
            PARTITION BY ci.country 
            ORDER BY c.date 
            ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
        ) AS rolling_avg_deaths
    FROM covid_cases c
    JOIN country_info ci 
        ON c.primary_key = ci.primary_key
)
UPDATE c
SET c.weekly_avg_deaths = w.rolling_avg_deaths
FROM covid_cases c
JOIN WeeklyAvgDeaths w 
    ON c.primary_key = w.primary_key;


--Create new column in covid vaccination table for calulating vaccnation rate 
ALTER TABLE covid_vaccination
ADD vaccination_rate FLOAT;


UPDATE v
SET v.vaccination_rate =
    CASE
        WHEN ci.population > 0 THEN (v.people_vaccinated * 100.0 / ci.population)
        ELSE NULL
    END
FROM covid_vaccination v
JOIN country_info ci
    ON v.primary_key = ci.primary_key; 


--Create new column in covid vaccination table for calulating full vaccnation rate 

ALTER TABLE covid_vaccination
ADD full_vaccination_rate FLOAT;

UPDATE v
SET v.full_vaccination_rate =
    CASE
        WHEN ci.population > 0 THEN (v.people_fully_vaccinated * 100.0 / ci.population)
        ELSE NULL  -- Keep NULL for data integrity
    END
FROM covid_vaccination v
JOIN country_info ci
    ON v.primary_key = ci.primary_key;


--Create new column in covid vaccination table for calulating booster coverage rate 
ALTER TABLE covid_vaccination
ADD booster_coverage FLOAT;

UPDATE v
SET v.booster_coverage =
    CASE
        WHEN ci.population > 0 THEN (v.total_boosters * 100.0 / ci.population)
        ELSE NULL  -- keep NULL if population missing
    END
FROM covid_vaccination v
JOIN country_info ci
    ON v.primary_key = ci.primary_key;

--Create new column in covid vaccination table for calulating daily vaccination rate 

ALTER TABLE covid_vaccination
ADD daily_vaccination_rate FLOAT;

UPDATE v
SET v.daily_vaccination_rate =
    CASE
        WHEN ci.population > 0 THEN (v.new_vaccinations * 100.0 / ci.population)
        ELSE NULL  -- Keep NULL to preserve data integrity
    END
FROM covid_vaccination v
JOIN country_info ci
    ON v.primary_key = ci.primary_key;


--Create new column in covid_testing  table for calulating test per million 
ALTER TABLE covid_testing
ADD tests_per_million FLOAT;

UPDATE t
SET t.tests_per_million =
    CASE
        WHEN ci.population > 0 THEN (t.total_tests * 1000000.0 / ci.population)
        ELSE NULL  -- keep NULL for missing or invalid population
    END
FROM covid_testing t
JOIN country_info ci
    ON t.primary_key = ci.primary_key;


--Create new column in covid_testing  table for calulating test positive rate 
ALTER TABLE covid_testing
ADD test_positivity_rate FLOAT;

UPDATE t
SET t.test_positivity_rate =
    CASE
        WHEN t.new_tests > 0 THEN (c.new_cases * 100.0 / t.new_tests)
        ELSE NULL  -- Avoid division by zero
    END
FROM covid_testing t
JOIN covid_cases c
    ON t.primary_key = c.primary_key;

select * 
from covid_cases;

select * from covid_testing;

--Create new column in covid_case  table for calulating case per million 
ALTER TABLE covid_cases
ADD cases_per_million FLOAT;


UPDATE c
SET c.cases_per_million =
    CASE
        WHEN ci.population > 0 THEN (c.total_cases * 1000000.0 / ci.population)
        ELSE NULL  -- Avoid division by zero
    END
FROM covid_cases c
JOIN country_info ci
    ON c.primary_key = ci.primary_key;

--Create new column in covid_case  table for calulating death  per million 
ALTER TABLE covid_cases
ADD deaths_per_million FLOAT;


UPDATE c
SET c.deaths_per_million =
    CASE
        WHEN ci.population > 0 THEN (c.total_deaths * 1000000.0 / ci.population)
        ELSE NULL  -- Avoid division by zero
    END
FROM covid_cases c
JOIN country_info ci
    ON c.primary_key = ci.primary_key;




--Country-wise Summary of COVID-19 Impact
SELECT 
ci.country,
MAX(c.total_cases) AS total_cases,
MAX(c.total_deaths) AS total_deaths,
MAX(c.case_fatality_rate) AS fatality_rate,
MAX(v.full_vaccination_rate) AS full_vaccination_rate
FROM country_info ci
JOIN covid_cases c ON ci.primary_key = c.primary_key
JOIN covid_vaccination v ON ci.primary_key = v.primary_key
GROUP BY ci.country
ORDER BY total_cases DESC;


--highlights the countries most affected and compares their vaccination and testing coverage.
SELECT 
    ci.country,
    MAX(c.total_cases) AS total_cases,
    MAX(c.total_deaths) AS total_deaths,
    MAX(v.people_vaccinated) AS total_vaccinated,
    MAX(v.full_vaccination_rate) AS full_vaccination_rate,
    MAX(t.total_tests) AS total_tests,
    MAX(t.tests_per_million) AS tests_per_million
FROM country_info ci
JOIN covid_cases c ON ci.primary_key = c.primary_key
JOIN covid_vaccination v ON ci.primary_key = v.primary_key
JOIN covid_testing t ON ci.primary_key = t.primary_key
GROUP BY ci.country
ORDER BY total_cases DESC;


/*For quick snapshot of the pandemic’s overall impact showing worldwide totals for 
cases and deaths, along with average fatality, vaccination, and test positivity rates. */

SELECT
    SUM(total_cases) AS world_total_cases,
    SUM(total_deaths) AS world_total_deaths,
    AVG(case_fatality_rate) AS avg_case_fatality_rate,
    AVG(vaccination_rate) AS avg_vaccination_rate,
    AVG(test_positivity_rate) AS avg_test_positive_rate
FROM covid_cases c
JOIN covid_vaccination v ON c.primary_key = v.primary_key
JOIN covid_testing t ON c.primary_key = t.primary_key;

--For top 10 Countries by Death Rate 
SELECT 
    ci.country,
    MAX(c.case_fatality_rate) AS death_rate
FROM covid_cases c
JOIN country_info ci ON c.primary_key = ci.primary_key
GROUP BY ci.country
ORDER BY death_rate DESC
OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY;

select * 
from covid_cases

--Trend of Daily Cases for bangaldesh 
SELECT 
    ci.country,
    c.date,
    SUM(c.new_cases) AS total_new_cases
FROM covid_cases c
JOIN country_info ci ON c.primary_key = ci.primary_key
WHERE ci.country = 'Bangladesh'
GROUP BY ci.country, c.date
ORDER BY c.date;

--Relationship between Testing & Cases 
SELECT 
    ci.country,
    AVG(t.tests_per_million) AS avg_tests,
    AVG(c.cases_per_million) AS avg_cases,
    (AVG(c.cases_per_million) / NULLIF(AVG(t.tests_per_million),0)) * 100 AS case_test_ratio
FROM covid_cases c
JOIN covid_testing t ON c.primary_key = t.primary_key
JOIN country_info ci ON c.primary_key = ci.primary_key
GROUP BY ci.country
ORDER BY case_test_ratio DESC;


--Compare Vaccination vs Deaths
SELECT 
    ci.country,
    MAX(v.full_vaccination_rate) AS full_vaccination,
    MAX(c.case_fatality_rate) AS death_rate
FROM covid_vaccination v
JOIN covid_cases c ON v.primary_key = c.primary_key
JOIN country_info ci ON v.primary_key = ci.primary_key
GROUP BY ci.country
ORDER BY full_vaccination DESC;

--For Identifying countries with continuous increase in infection rate.

SELECT 
    ci.country,
    AVG(c.daily_growth_rate) AS avg_growth_rate
FROM covid_cases c
JOIN country_info ci ON c.primary_key = ci.primary_key
GROUP BY ci.country
HAVING AVG(c.daily_growth_rate) > 0
ORDER BY avg_growth_rate DESC;


--Continent-wise Comparison

SELECT 
    ci.continent,
    AVG(c.case_fatality_rate) AS avg_death_rate,
    AVG(v.full_vaccination_rate) AS avg_vaccination_rate,
    AVG(t.test_positivity_rate) AS avg_positivity_rate
FROM covid_cases c
JOIN covid_vaccination v ON c.primary_key = v.primary_key
JOIN covid_testing t ON c.primary_key = t.primary_key
JOIN country_info ci ON c.primary_key = ci.primary_key
WHERE ci.continent IS NOT NULL 
  AND ci.continent <> '' 
  AND ci.continent NOT LIKE '%South Korea%'
GROUP BY ci.continent
ORDER BY avg_death_rate DESC;


--For Detect Sudden Spikes in Cases (Unusual Growth)
SELECT 
    ci.country,
    c.date,
    c.new_cases,
    c.weekly_avg_cases,
    CASE 
        WHEN c.new_cases > 2 * c.weekly_avg_cases THEN 'Spike Detected' 
        ELSE 'Normal' 
    END AS status
FROM covid_cases c
JOIN country_info ci ON c.primary_key = ci.primary_key
ORDER BY ci.country, c.date;


--Deaths Without Cases (Data Anomaly) for detects potential data integrity issues.
SELECT 
    ci.country,
    c.date,
    c.total_deaths,
    c.total_cases
FROM covid_cases c
JOIN country_info ci ON c.primary_key = ci.primary_key
WHERE c.total_deaths > c.total_cases;




--For top 10 Countries by Death Rate 
SELECT 
    ci.country,
    MAX(c.case_fatality_rate) AS death_rate
FROM covid_cases c
JOIN country_info ci ON c.primary_key = ci.primary_key
GROUP BY ci.country
ORDER BY death_rate DESC
OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY;
--by run this code I sea some unusal value 



SELECT 
    ci.country,
    (MAX(c.total_deaths) * 100.0 / NULLIF(MAX(c.total_cases), 0)) AS death_rate
FROM covid_cases c
JOIN country_info ci ON c.primary_key = ci.primary_key
WHERE c.total_cases IS NOT NULL AND c.total_deaths IS NOT NULL
GROUP BY ci.country
ORDER BY death_rate DESC
OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY;
