-- 4. Removing Unncessary Rows/ Columns

-- Delete any unnecessary rows

#VIEW the rows that don't show any layoffs
SELECT *
FROM layoffs_Staging2
WHERE TOTAL_LAID_OFF IS NULL
AND percentage_laid_off IS NULL;

#Delete the rows that don't show layoffs
DELETE
FROM layoffs_Staging2
WHERE TOTAL_LAID_OFF IS NULL
AND percentage_laid_off IS NULL;

# View the full table
SELECT *
FROM layoffs_staging2;

#we still have an unncessary column called 'row_num'
#so let's remove it

-- Removing Unnecessary Columns
ALTER TABLE layoffs_staging2
DROP COLUMN row_num;
