-- 3. Cleaning Nulls and Blank Values

#VIEW the NULL values
SELECT *
FROM layoffs_Staging2
WHERE TOTAL_LAID_OFF IS NULL	#Syntax is IS NULL, youc ant use = NULL
AND percentage_laid_off IS NULL;

#View the null values across the industry
SELECT * 
FROM Layoffs_staging2
WHERE industry IS NULL
OR industry = '';	#if the industry is null or blank

#Check for any duplicates in any other row to see what we can steal
SELECT *
FROM layoffs_staging2
WHERE company = 'Airbnb';

# JOIN NULL/BLANK TABLES
SELECT t1.industry, t2.industry	#show the industry
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2	#Self JOIN to populate the values
	ON t1.company = t2.company	#match the companies
    AND t1.location = t2.location	#match the location
WHERE (t1.industry IS NULL OR t1.industry = '') #where one value is null, and the other isnt
AND t2.industry IS NOT NULL; 

#Update any blank values to null
UPDATE layoffs_Staging2
SET industry = NULL
WHERE industry ='';

#Change the null values to be updated
UPDATE layoffs_Staging2 t1
JOIN layoffs_staging2 t2	
	ON t1.company = t2.company	
SET t1.industry = t2.industry	#Set the T1 industry to be the t2 industry
WHERE (t1.industry IS NULL) #where the t1 is blank
AND t2.industry IS NOT NULL; 

