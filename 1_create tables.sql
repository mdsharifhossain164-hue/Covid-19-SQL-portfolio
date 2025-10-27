/*
   Project: COVID-19 Portfolio (SQL Data Analysis)
   Author: Mohammed Sharif Hossain
   File: 1_create_tables.sql
   Purpose: Database setup and initial data validation checks
   Dataset: https://catalog.ourworldindata.org/garden/covid/latest/compact/compact.csv
   
   */

-- Step 1: Dataset Overview
-- The dataset contains 61 columns and more than 500,000 rows.
-- Using Python, a primary_key was created to maintain relationships between tables.
-- Then I created 6 table with relevent columns using python 

USE portfolio;
GO

-- Basic row count check for each table 
SELECT COUNT(*) AS total_rows FROM country_info;
SELECT COUNT(*) AS total_rows FROM covid_cases;
SELECT COUNT(*) AS total_rows FROM covid_hospitalization;
SELECT COUNT(*) AS total_rows FROM covid_mortality;
SELECT COUNT(*) AS total_rows FROM covid_testing;
SELECT COUNT(*) AS total_rows FROM covid_vaccination;



-- Missing key check primary key or country or date 
SELECT * FROM country_info WHERE primary_key IS NULL OR country IS NULL;
SELECT * FROM covid_cases WHERE primary_key IS NULL OR date IS NULL;
SELECT * FROM covid_hospitalization WHERE primary_key IS NULL OR date IS NULL;
SELECT * FROM covid_mortality WHERE primary_key IS NULL OR date IS NULL;
SELECT * FROM covid_testing WHERE primary_key IS NULL OR date IS NULL;
SELECT * FROM covid_vaccination WHERE primary_key IS NULL OR date IS NULL;


-- I just check random talbe to ensured did not have any diplicate primary key 
SELECT primary_key, COUNT(*) AS cnt
FROM country_info
GROUP BY primary_key
HAVING COUNT(*) > 1;


--Check which rows in population column are non-numeric
SELECT primary_key, country, population
FROM country_info
WHERE TRY_CAST(population AS FLOAT) IS NULL 
      AND population IS NOT NULL;


-- Replace non-numeric population values with 0
UPDATE country_info
SET population = 0
WHERE TRY_CAST(population AS FLOAT) IS NULL 
      AND population IS NOT NULL;

--Verify all population values are now numeric or 0
SELECT primary_key, country, population
FROM country_info
ORDER BY primary_key;

Select * 
From country_info
order by 1;


SELECT *
FROM covid_cases

--Data Quality Log Table
   
CREATE TABLE dbo.data_quality_log (
  table_name NVARCHAR(100),
  check_type NVARCHAR(100),
  issue_count INT,
  check_date DATETIME DEFAULT GETDATE()
);


-- Missing Keys or Date issues
INSERT INTO data_quality_log
SELECT 'covid_cases', 'missing_key_or_date', COUNT(*), 'Missing PK or Date'
FROM dbo.covid_cases
WHERE primary_key IS NULL OR date IS NULL;

--Referential Integrity Check

SELECT DISTINCT primary_key
FROM dbo.covid_cases
WHERE primary_key NOT IN (SELECT primary_key FROM dbo.country_info);

--Check invalid date formats
SELECT * FROM covid_cases
WHERE TRY_CAST(date AS DATE) IS NULL AND date IS NOT NULL;



