SELECT *
FROM layoffs_staging;

CREATE TABLE layoffs_staging
LIKE layoffs;

INSERT layoffs_staging
SELECT *
FROM layoffs;

/*Identifying Duplicate*/

SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised) AS row_num
FROM layoffs_staging
;

WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised) AS row_num
FROM layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num>1;


CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` text,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised` text,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised) AS row_num
FROM layoffs_staging;

SELECT *
FROM layoffs_staging2;

SELECT *
FROM layoffs_staging2
WHERE row_num>1;

DELETE
FROM layoffs_staging2
WHERE row_num>1;



/*Standardizing Data*/
SELECT *
FROM layoffs_staging2
;

SELECT company
FROM layoffs_staging2;

SELECT TRIM(company), company
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company = TRIM(company);

/*Fault was only found in the company column*/

/*Updating - Changing the data type for date column*/
SELECT *
FROM layoffs_staging2;

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

/*Null & Blank Values*/
SELECT *
FROM layoffs_staging2;

SELECT * 
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

/*No Null values in the total_laid_off and percentage_laid_off columns*/

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
OR total_laid_off = '';

UPDATE layoffs_staging2
SET total_laid_off = null
WHERE total_laid_off = '';

ALTER TABLE layoffs_staging2
MODIFY COLUMN total_laid_off INT;


UPDATE layoffs_staging2
SET percentage_laid_off = NULL
WHERE percentage_laid_off = '';

ALTER TABLE layoffs_staging2
MODIFY COLUMN percentage_laid_off INT;


SELECT *
FROM layoffs_staging2;

SELECT *
FROM layoffs_staging2
WHERE industry IS NULL 
OR industry = '';


SELECT *
FROM layoffs_staging2
WHERE company = 'Appsmith';

UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';
