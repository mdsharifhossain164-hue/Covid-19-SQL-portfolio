/* 
   Project: COVID-19 Portfolio (SQL Data Analysis)
   Author: Mohammed Sharif Hossain
   File: 2_data_cleaning.sql
   Purpose: Data cleaning, transformation, and validation
  */

-- Clean all numeric columns in country_info by replacing non-numeric values with 0
UPDATE country_info
SET 
    population = CASE WHEN TRY_CAST(population AS FLOAT) IS NULL THEN '0' ELSE population END,
    population_density = CASE WHEN TRY_CAST(population_density AS FLOAT) IS NULL THEN '0' ELSE population_density END,
    median_age = CASE WHEN TRY_CAST(median_age AS FLOAT) IS NULL THEN '0' ELSE median_age END,
    life_expectancy = CASE WHEN TRY_CAST(life_expectancy AS FLOAT) IS NULL THEN '0' ELSE life_expectancy END,
    gdp_per_capita = CASE WHEN TRY_CAST(gdp_per_capita AS FLOAT) IS NULL THEN '0' ELSE gdp_per_capita END,
    extreme_poverty = CASE WHEN TRY_CAST(extreme_poverty AS FLOAT) IS NULL THEN '0' ELSE extreme_poverty END,
    diabetes_prevalence = CASE WHEN TRY_CAST(diabetes_prevalence AS FLOAT) IS NULL THEN '0' ELSE diabetes_prevalence END,
    handwashing_facilities = CASE WHEN TRY_CAST(handwashing_facilities AS FLOAT) IS NULL THEN '0' ELSE handwashing_facilities END,
    hospital_beds_per_thousand = CASE WHEN TRY_CAST(hospital_beds_per_thousand AS FLOAT) IS NULL THEN '0' ELSE hospital_beds_per_thousand END,
    human_development_index = CASE WHEN TRY_CAST(human_development_index AS FLOAT) IS NULL THEN '0' ELSE human_development_index END;

select * 
from covid_cases


-- Convert all numeric columns to FLOAT
ALTER TABLE country_info ALTER COLUMN population FLOAT;
ALTER TABLE country_info ALTER COLUMN population_density FLOAT;
ALTER TABLE country_info ALTER COLUMN median_age FLOAT;
ALTER TABLE country_info ALTER COLUMN life_expectancy FLOAT;
ALTER TABLE country_info ALTER COLUMN gdp_per_capita FLOAT;
ALTER TABLE country_info ALTER COLUMN extreme_poverty FLOAT;
ALTER TABLE country_info ALTER COLUMN diabetes_prevalence FLOAT;
ALTER TABLE country_info ALTER COLUMN handwashing_facilities FLOAT;
ALTER TABLE country_info ALTER COLUMN hospital_beds_per_thousand FLOAT;
ALTER TABLE country_info ALTER COLUMN human_development_index FLOAT;


--Convert 'date' column to DATE type
ALTER TABLE covid_cases ALTER COLUMN date DATE;

-- Convert columns to FLOAT
ALTER TABLE covid_cases ALTER COLUMN total_cases FLOAT;
ALTER TABLE covid_cases ALTER COLUMN new_cases FLOAT;
ALTER TABLE covid_cases ALTER COLUMN new_cases_smoothed FLOAT;
ALTER TABLE covid_cases ALTER COLUMN total_deaths FLOAT;
ALTER TABLE covid_cases ALTER COLUMN new_deaths FLOAT;
ALTER TABLE covid_cases ALTER COLUMN new_deaths_smoothed FLOAT;
ALTER TABLE covid_cases ALTER COLUMN total_cases_per_million FLOAT;
ALTER TABLE covid_cases ALTER COLUMN total_deaths_per_million FLOAT;

-- Replace non-numeric values with 0
UPDATE covid_cases SET total_cases='0' WHERE TRY_CAST(total_cases AS FLOAT) IS NULL AND total_cases IS NOT NULL;
UPDATE covid_cases SET new_cases='0' WHERE TRY_CAST(new_cases AS FLOAT) IS NULL AND new_cases IS NOT NULL;
UPDATE covid_cases SET new_cases_smoothed='0' WHERE TRY_CAST(new_cases_smoothed AS FLOAT) IS NULL AND new_cases_smoothed IS NOT NULL;
UPDATE covid_cases SET total_deaths='0' WHERE TRY_CAST(total_deaths AS FLOAT) IS NULL AND total_deaths IS NOT NULL;
UPDATE covid_cases SET new_deaths='0' WHERE TRY_CAST(new_deaths AS FLOAT) IS NULL AND new_deaths IS NOT NULL;
UPDATE covid_cases SET new_deaths_smoothed='0' WHERE TRY_CAST(new_deaths_smoothed AS FLOAT) IS NULL AND new_deaths_smoothed IS NOT NULL;
UPDATE covid_cases SET total_cases_per_million='0' WHERE TRY_CAST(total_cases_per_million AS FLOAT) IS NULL AND total_cases_per_million IS NOT NULL;
UPDATE covid_cases SET total_deaths_per_million='0' WHERE TRY_CAST(total_deaths_per_million AS FLOAT) IS NULL AND total_deaths_per_million IS NOT NULL;



-- Check invalid dates
SELECT * FROM covid_testing WHERE TRY_CAST(date AS DATE) IS NULL AND date IS NOT NULL;

-- Convert 'date' column to DATE
ALTER TABLE covid_testing ALTER COLUMN date DATE;
-- Convert numeric columns to FLOAT
ALTER TABLE covid_testing ALTER COLUMN total_tests FLOAT;
ALTER TABLE covid_testing ALTER COLUMN new_tests FLOAT;
ALTER TABLE covid_testing ALTER COLUMN new_tests_smoothed FLOAT;
ALTER TABLE covid_testing ALTER COLUMN total_tests_per_thousand FLOAT;
ALTER TABLE covid_testing ALTER COLUMN new_tests_per_thousand FLOAT;
ALTER TABLE covid_testing ALTER COLUMN new_tests_smoothed_per_thousand FLOAT;
ALTER TABLE covid_testing ALTER COLUMN positive_rate FLOAT;
ALTER TABLE covid_testing ALTER COLUMN tests_per_case FLOAT;

-- Clean numeric columns
UPDATE covid_testing SET total_tests='0' WHERE TRY_CAST(total_tests AS FLOAT) IS NULL AND total_tests IS NOT NULL;
UPDATE covid_testing SET new_tests='0' WHERE TRY_CAST(new_tests AS FLOAT) IS NULL AND new_tests IS NOT NULL;
UPDATE covid_testing SET new_tests_smoothed='0' WHERE TRY_CAST(new_tests_smoothed AS FLOAT) IS NULL AND new_tests_smoothed IS NOT NULL;
UPDATE covid_testing SET total_tests_per_thousand='0' WHERE TRY_CAST(total_tests_per_thousand AS FLOAT) IS NULL AND total_tests_per_thousand IS NOT NULL;
UPDATE covid_testing SET new_tests_per_thousand='0' WHERE TRY_CAST(new_tests_per_thousand AS FLOAT) IS NULL AND new_tests_per_thousand IS NOT NULL;
UPDATE covid_testing SET new_tests_smoothed_per_thousand='0' WHERE TRY_CAST(new_tests_smoothed_per_thousand AS FLOAT) IS NULL AND new_tests_smoothed_per_thousand IS NOT NULL;
UPDATE covid_testing SET positive_rate='0' WHERE TRY_CAST(positive_rate AS FLOAT) IS NULL AND positive_rate IS NOT NULL;
UPDATE covid_testing SET tests_per_case='0' WHERE TRY_CAST(tests_per_case AS FLOAT) IS NULL AND tests_per_case IS NOT NULL;



--covid_vaccination table

SELECT * FROM covid_vaccination WHERE TRY_CAST(date AS DATE) IS NULL AND date IS NOT NULL;
ALTER TABLE covid_vaccination ALTER COLUMN date DATE;

-- Convert numeric columns to FLOAT

ALTER TABLE covid_vaccination ALTER COLUMN total_vaccinations FLOAT;
ALTER TABLE covid_vaccination ALTER COLUMN people_vaccinated FLOAT;
ALTER TABLE covid_vaccination ALTER COLUMN people_fully_vaccinated FLOAT;
ALTER TABLE covid_vaccination ALTER COLUMN total_boosters FLOAT;
ALTER TABLE covid_vaccination ALTER COLUMN new_vaccinations FLOAT;
ALTER TABLE covid_vaccination ALTER COLUMN new_vaccinations_smoothed FLOAT;
ALTER TABLE covid_vaccination ALTER COLUMN people_vaccinated_per_hundred FLOAT;
ALTER TABLE covid_vaccination ALTER COLUMN people_fully_vaccinated_per_hundred FLOAT;
ALTER TABLE covid_vaccination ALTER COLUMN total_boosters_per_hundred FLOAT;

-- Clean numeric columns
UPDATE covid_vaccination SET total_vaccinations='0' WHERE TRY_CAST(total_vaccinations AS FLOAT) IS NULL AND total_vaccinations IS NOT NULL;
UPDATE covid_vaccination SET people_vaccinated='0' WHERE TRY_CAST(people_vaccinated AS FLOAT) IS NULL AND people_vaccinated IS NOT NULL;
UPDATE covid_vaccination SET people_fully_vaccinated='0' WHERE TRY_CAST(people_fully_vaccinated AS FLOAT) IS NULL AND people_fully_vaccinated IS NOT NULL;
UPDATE covid_vaccination SET total_boosters='0' WHERE TRY_CAST(total_boosters AS FLOAT) IS NULL AND total_boosters IS NOT NULL;
UPDATE covid_vaccination SET new_vaccinations='0' WHERE TRY_CAST(new_vaccinations AS FLOAT) IS NULL AND new_vaccinations IS NOT NULL;
UPDATE covid_vaccination SET new_vaccinations_smoothed='0' WHERE TRY_CAST(new_vaccinations_smoothed AS FLOAT) IS NULL AND new_vaccinations_smoothed IS NOT NULL;
UPDATE covid_vaccination SET people_vaccinated_per_hundred='0' WHERE TRY_CAST(people_vaccinated_per_hundred AS FLOAT) IS NULL AND people_vaccinated_per_hundred IS NOT NULL;
UPDATE covid_vaccination SET people_fully_vaccinated_per_hundred='0' WHERE TRY_CAST(people_fully_vaccinated_per_hundred AS FLOAT) IS NULL AND people_fully_vaccinated_per_hundred IS NOT NULL;
UPDATE covid_vaccination SET total_boosters_per_hundred='0' WHERE TRY_CAST(total_boosters_per_hundred AS FLOAT) IS NULL AND total_boosters_per_hundred IS NOT NULL;



-- covid_hospitalization table

SELECT * FROM covid_hospitalization WHERE TRY_CAST(date AS DATE) IS NULL AND date IS NOT NULL;
ALTER TABLE covid_hospitalization ALTER COLUMN date DATE;

-- Convert numeric columns to FLOAT
ALTER TABLE covid_hospitalization ALTER COLUMN hosp_patients FLOAT;
ALTER TABLE covid_hospitalization ALTER COLUMN hosp_patients_per_million FLOAT;
ALTER TABLE covid_hospitalization ALTER COLUMN weekly_hosp_admissions FLOAT;
ALTER TABLE covid_hospitalization ALTER COLUMN weekly_hosp_admissions_per_million FLOAT;
ALTER TABLE covid_hospitalization ALTER COLUMN icu_patients FLOAT;
ALTER TABLE covid_hospitalization ALTER COLUMN icu_patients_per_million FLOAT;
ALTER TABLE covid_hospitalization ALTER COLUMN weekly_icu_admissions FLOAT;
ALTER TABLE covid_hospitalization ALTER COLUMN weekly_icu_admissions_per_million FLOAT;

-- Clean numeric columns
UPDATE covid_hospitalization SET hosp_patients='0' WHERE TRY_CAST(hosp_patients AS FLOAT) IS NULL AND hosp_patients IS NOT NULL;
UPDATE covid_hospitalization SET hosp_patients_per_million='0' WHERE TRY_CAST(hosp_patients_per_million AS FLOAT) IS NULL AND hosp_patients_per_million IS NOT NULL;
UPDATE covid_hospitalization SET weekly_hosp_admissions='0' WHERE TRY_CAST(weekly_hosp_admissions AS FLOAT) IS NULL AND weekly_hosp_admissions IS NOT NULL;
UPDATE covid_hospitalization SET weekly_hosp_admissions_per_million='0' WHERE TRY_CAST(weekly_hosp_admissions_per_million AS FLOAT) IS NULL AND weekly_hosp_admissions_per_million IS NOT NULL;
UPDATE covid_hospitalization SET icu_patients='0' WHERE TRY_CAST(icu_patients AS FLOAT) IS NULL AND icu_patients IS NOT NULL;
UPDATE covid_hospitalization SET icu_patients_per_million='0' WHERE TRY_CAST(icu_patients_per_million AS FLOAT) IS NULL AND icu_patients_per_million IS NOT NULL;
UPDATE covid_hospitalization SET weekly_icu_admissions='0' WHERE TRY_CAST(weekly_icu_admissions AS FLOAT) IS NULL AND weekly_icu_admissions IS NOT NULL;
UPDATE covid_hospitalization SET weekly_icu_admissions_per_million='0' WHERE TRY_CAST(weekly_icu_admissions_per_million AS FLOAT) IS NULL AND weekly_icu_admissions_per_million IS NOT NULL;


-- covid_mortality table

SELECT * FROM covid_mortality WHERE TRY_CAST(date AS DATE) IS NULL AND date IS NOT NULL;
ALTER TABLE covid_mortality ALTER COLUMN date DATE;

-- Convert numeric columns to FLOAT
ALTER TABLE covid_mortality ALTER COLUMN excess_mortality FLOAT;
ALTER TABLE covid_mortality ALTER COLUMN excess_mortality_cumulative FLOAT;
ALTER TABLE covid_mortality ALTER COLUMN excess_mortality_cumulative_absolute FLOAT;
ALTER TABLE covid_mortality ALTER COLUMN excess_mortality_cumulative_per_million FLOAT;

-- Clean numeric columns

UPDATE covid_mortality SET excess_mortality='0' WHERE TRY_CAST(excess_mortality AS FLOAT) IS NULL AND excess_mortality IS NOT NULL;
UPDATE covid_mortality SET excess_mortality_cumulative='0' WHERE TRY_CAST(excess_mortality_cumulative AS FLOAT) IS NULL AND excess_mortality_cumulative IS NOT NULL;
UPDATE covid_mortality SET excess_mortality_cumulative_absolute='0' WHERE TRY_CAST(excess_mortality_cumulative_absolute AS FLOAT) IS NULL AND excess_mortality_cumulative_absolute IS NOT NULL;
UPDATE covid_mortality SET excess_mortality_cumulative_per_million='0' WHERE TRY_CAST(excess_mortality_cumulative_per_million AS FLOAT) IS NULL AND excess_mortality_cumulative_per_million IS NOT NULL;

--Check the row number
SELECT COUNT(*) AS total_rows FROM country_info;
SELECT COUNT(*) AS total_rows FROM covid_cases;
SELECT COUNT(*) AS total_rows FROM covid_testing;
SELECT COUNT(*) AS total_rows FROM covid_vaccination;
SELECT COUNT(*) AS total_rows FROM covid_hospitalization;
SELECT COUNT(*) AS total_rows FROM covid_mortality;


--Check for NULL or Missing Values from random table 
-- Country info table
SELECT * 
FROM country_info
WHERE country IS NULL OR continent IS NULL OR population IS NULL;

-- Covid cases table
SELECT * 
FROM covid_cases
WHERE total_cases IS NULL AND new_cases IS NULL;

-- Vaccination table
SELECT * 
FROM covid_vaccination
WHERE total_vaccinations IS NULL AND people_vaccinated IS NULL;

--I did not found any missing value 

--Check dupplicate primary key from random table 
SELECT primary_key, COUNT(*) AS count
FROM covid_cases
GROUP BY primary_key
HAVING COUNT(*) > 1;


-- Negative values check
SELECT * FROM covid_cases WHERE new_cases < 0 OR total_cases < 0;
SELECT * FROM covid_vaccination WHERE total_vaccinations < 0;
SELECT * FROM covid_testing WHERE total_tests < 0;

-- Zero population check
SELECT * FROM country_info WHERE population <= 0;
--In this cose I found some irrelevent value, this is not exect country row , country column some row are asi excel. China ,  word excel china, I cant understnad what does it means , so thats why I did not do anything with this value 

Select * 
from covid_vaccination



SELECT COUNT(*) FROM covid_cases WHERE new_cases IS NULL;
SELECT COUNT(*) FROM covid_vaccination WHERE new_vaccinations IS NULL;
SELECT COUNT(*) FROM country_info WHERE population IS NULL;

