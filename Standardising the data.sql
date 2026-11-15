-- 2. Standardizing the data

# Standardizing data is just finding issues in the data and fixing it.

#View the company and the trimed company names
SELECT company, TRIM(company) 
FROM layoffs_staging2;

#Trim whitespace from the end of the companies
UPDATE layoffs_staging2
SET company = TRIM(company);

# View all the industres
SELECT DISTINCT industry 
FROM layoffs_staging2
ORDER BY 1;

# Find all in the 'crypto' category
SELECT * 
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%';

# Update all to be crypto
UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

# Find all in the 'country' category
SELECT DISTINCT country, TRIM(TRAILING '.' FROM country) 	#Trailing removes everything following what you set it
FROM layoffs_staging2
ORDER BY 1;

#Update this
UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

#Update date column from a 'string' data type to a 'date' data type
SELECT `date`,
STR_TO_DATE(`date`, '%m/%d/%Y') #SYNTAX - STR_TO_DATE(’string_name’, ‘date_format’)
FROM layoffs_staging2;

#Update date colunm
UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

#View new dates
SELECT date `date`
FROM layoffs_staging2;

#Change the table's data type to a date
ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

#View the whole table.
SELECT * 
FROM layoffs_Staging2;