-- PROJECT NAME : WORLD LAYOFFS - DATA CLEANING AND ANALYSIS
-- DATABASE : SQL
-- ============================================

-- SECTION 1: DATA CLEANING
-- 1. Create staging table
-- 2. Remove duplicates
-- 3. Standardise data
-- 4. Remove unnecessary nulls, columns or rows

-- SECTION 2: EXPLORATORY DATA ANALYSIS
-- 1. Looking at most people laid off in a day and company
-- 2. Looking at Size of Funding in companies that laid off 100% of employees
-- 3. Top 5 companies that laid off the most people in a single day
-- 4. Top 5 companies that had the most total layoffs 
-- 5. Total layoffs by year
-- 6. Total Layoffs by industry
-- 7. Most Common Stages at which People where Laid off
-- 8. Top 4 Months where people are laid off the most
-- 9. Look at The company that had highest total layoff in every year from 2020-2023

-- CREATING STAGING TABLES

SELECT * 
from layoffs;

CREATE TABLE layoffs_staging
LIKE layoffs;

INSERT layoffs_staging
SELECT *
FROM layoffs
;

SELECT *
FROM layoffs_staging 
;

-- REMOVING DUPLICATES

WITH duplicate_cte AS
(SELECT *,
ROW_NUMBER() OVER(
PARTITION BY
 company,location,
 industry,total_laid_off,`date`,
 percentage_laid_off,
 stage,country,
 funds_raised_millions) AS row_num
FROM layoffs_staging
)
SELECT *
FROM duplicate_cte

;

CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
`row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO layoffs_staging2
(SELECT *,
ROW_NUMBER() OVER(
PARTITION BY
 company,location,
 industry,total_laid_off,`date`,
 percentage_laid_off,
 stage,country,
 funds_raised_millions) AS row_num
FROM layoffs_staging
)
;

DELETE 
FROM layoffs_staging2 
WHERE row_num >1
;

SELECT *
FROM layoffs_staging2 
;


-- STANDARDIZING DATA

SELECT ltrim(COMPANY)
FROM layoffs_Staging2
;

UPDATE layoffs_staging2
SET COMPANY = LTRIM(COMPANY)
;

SELECT *
FROM layoffs_staging2 
WHERE Industry LIKE '%crypto%' 
;

UPDATE layoffs_staging2
SET INDUSTRY = 'Crypto'
WHERE Industry LIKE 'Crypto%'
;

SELECT DISTINCT country, TRIM(trailing '.' FROM country)
FROM layoffs_staging2 
order by 1
;

UPDATE layoffs_staging2
SET country = TRIM(trailing '.' FROM country)
WHERE country LIKE 'United States%'
;

SELECT `date`,
STR_TO_DATE(`date`, '%m/%d/%Y')
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET date = STR_TO_DATE(`date`, '%m/%d/%Y')
;

UPDATE layoffs_staging2
SET location = 'Düsseldorf'
WHERE location LIKE 'D%sseldorf'
;

SELECT t1.industry, t2.industry
FROM layoffs_staging2  t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
WHERE ( t1.industry IS NULL OR t1.industry = '' )
AND t2.industry IS NOT NULL 
;

UPDATE layoffs_staging2
SET Industry = NULL
WHERE Industry = ''
;

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL 
AND t2.industry IS NOT NULL 
;

SELECT DISTINCT (location)
FROM layoffs_staging2
;

UPDATE layoffs_staging2
SET location = 'Florianópolis'
WHERE location LIKE 'Florian%polis'
;

UPDATE layoffs_staging2
SET location = 'Malmö'
WHERE Location LIKE 'Malm%'
;

-- REMOVE NULL VALUES NOT RELEVANT TO DATA
SELECT * 
FROM layoffs_staging2
WHERE total_laid_off is NULL
AND percentage_laid_off is NULL
;

DELETE
FROM layoffs_staging2
WHERE total_laid_off is NULL
AND percentage_laid_off is NULL
;

-- DELETING UNECESSARY ROWS
ALTER TABLE layoffs_staging2
DROP COLUMN row_num
;

SELECT * 
FROM layoffs_staging2
;

-- EXPLORATORY DATA ANALYSIS

--  LOOKING AT MOST PEOPLE LAID OFF IN A DAY AND WHICH COMPANY

SELECT company, total_laid_off
FROM layoffs_staging2
WHERE total_laid_off = (SELECT MAX(total_laid_off) FROM layoffs_staging2);

-- HOW BIG SOME OF THESE COMPANIES ARE WHO LAID OFF 100% OF THEIR STAFF

SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC ;

-- TOP 5 COMPANIES WHO HAD THE HIGHEST LAYOFFS IN A SINGLE DAY

SELECT company, max(total_laid_off) as largest_event
FROM layoffs_staging2	
GROUP BY company
ORDER BY largest_event DESC
LIMIT 5
;

-- TOP 5 COMPANIES WITH THE MOST TOTAL LAYOFFS

SELECT company, sum(total_laid_off) as total_layoffs
FROM layoffs_staging2
GROUP BY company
ORDER BY sum(total_laid_off) DESC
LIMIT 5
;

-- TOTAL PEOPLE LAID OFF IN EACH YEAR
SELECT YEAR(date) AS YEARS, SUM(total_laid_off)
FROM layoffs_staging2
WHERE YEAR(date) IS NOT NULL
GROUP BY YEARS
ORDER BY 1 ASC ;
 
 -- LOOKING AT TOTAL NUMBER OF PEOPLE LAID OFF IN EACH INUDSTRY
SELECT industry, Sum(total_laid_off) as Total_Laid_Off
FROM layoffs_staging2
GROUP BY Industry
ORDER BY 2 DESC
;


-- MOST COMMON STAGES AT WHICH LAYOFFS HAPPENED
SELECT SUM(TOTAL_LAID_OFF) AS Total_Laid_Off, Stage
FROM layoffs_staging2
GROUP BY Stage
ORDER BY Total_Laid_off DESC
Limit 5 
;

-- LOOKING AT THE 4 MONTHS WHERE PEOPLE WERE LAID OFF THE MOST
SELECT MONTH(`DATE`) as Months, SUM(Total_Laid_Off) as Total_Laid_Off
FROM Layoffs_staging2
WHERE `date` IS NOT NULL
GROUP BY MONTHS
ORDER BY Total_Laid_Off DESC
LIMIT 4
;

-- COMPANIES THAT LAID OFF THE MOST PEOPLE IN THE YEARS 2020-2023

WITH Company_Year AS (SELECT Company, YEAR(`date`) as Years, SUM(total_laid_off) as Total_Laid_Off
FROM layoffs_staging2
Group BY Company, Years
),
Company_Year_Rank AS(
SELECT Company, Years, Total_Laid_Off, DENSE_RANK() OVER(PARTITION BY Years ORDER BY Total_Laid_off Desc) AS Ranking
FROM Company_Year)
Select Company, Years, Ranking,Total_Laid_Off
FROM Company_Year_Rank
WHERE Ranking <2
AND Years IS NOT NULL
ORDER BY YEARS ASC,Total_Laid_Off DESC 
;
