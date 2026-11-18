-- Exploratory Data Analysis (EDA)

# View the table
SELECT *
FROM layoffs_staging2;

# Who laid off the most  (Max a company laid off and max & laid off)
SELECT MAX(total_laid_off), MAX(percentage_laid_off)	#If the max % laid off comes back as 1 = that means 100% of the company
FROM layoffs_staging2;

# Find all companies that laid off EVERYONE
SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;	#Order by how many they laid off

#search for who has the raised the most funds  
SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_Raised_millions DESC;	#order by who has the most funding

# Look at the sum of the total laid off per company
SELECT company, SUM(total_laid_off)
FROM layoffs_Staging2
GROUP BY company
ORDER BY 2 DESC; # 2 stands for the total laid off

#Let's check the date ranges for this
SELECT MIN(`date`), MAX(`date`)	#min represents when the layoffs started, max represents the most recent one
FROM layoffs_staging2;

#What industry had the most layoffs
SELECT industry, SUM(total_laid_off)
FROM layoffs_Staging2
GROUP BY industry
ORDER BY 2 DESC;

#What country had the most layoffs
SELECT country, SUM(total_laid_off)
FROM layoffs_Staging2
GROUP BY country
ORDER BY 2 DESC;

#What country had the most layoffs BY DATE (In years)
SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_Staging2
GROUP BY YEAR(`date`)	#YEAR() function lets you see the date by year
ORDER BY 2 DESC;

#What stage of the company is everyone in and which had the most layoffs
SELECT stage, SUM(total_laid_off)
FROM layoffs_Staging2
GROUP BY stage
ORDER BY 2 DESC;

-- Progression of Layoffs PER MONTH

# Progression of Layoffs - per month
SELECT SUBSTRING(`date`, 1, 7) AS `month`, SUM(total_laid_off)	#take the date field - and start at the first month, and show 7 digits of the date (YYYY-MM)
FROM layoffs_Staging2
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC;

#NOW MAKE IT A ROLLING TOTAL - using a substring
WITH Rolling_Total AS  			#USE CTE
(
SELECT SUBSTRING(`date`, 1, 7) AS `month`, SUM(total_laid_off) AS total_off	
FROM layoffs_Staging2
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC
)			#creates a temporary useable results value 
SELECT `MONTH`,  total_off,
SUM(total_off) OVER(ORDER BY `MONTH`) AS rolling_total		# take the previous month and add the new layoffs
FROM Rolling_Total;

-- Layoffs Per Year BY COMPANY

-- WE WANT to see how many were laid off PER year PER company

#TAKE THE company statement from before 
SELECT company, SUM(total_laid_off)
FROM layoffs_Staging2
GROUP BY company
ORDER BY 2 DESC; 

#Lets select the company date, and how many were laid off in that year by company
SELECT company, YEAR(`date`), SUM(total_laid_off)	#Doint the date by year
FROM layoffs_staging2
GROUP BY company, `date`
ORDER BY company ASC;

#Lets select the company date, and how many were laid off in that year by company
SELECT company, YEAR(`date`), SUM(total_laid_off)	#Doint the date by year
FROM layoffs_staging2
GROUP BY company, `date`
ORDER BY 3 DESC;	# AKA the company with the most layoffs should be first in order


#Now lets make this a rolling total
WITH Company_Year(company, years, total_laid_off) AS	#CTE to make a company year
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC
)
SELECT *, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking	#Partition by the year and who had the most layoffs
FROM Company_Year
WHERE years IS NOT NULL	#no null values
ORDER BY Ranking ASC;


#Now lets filter this by the top 5
WITH Company_Year(company, years, total_laid_off) AS
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
), 
 Company_Year_Rank AS	# Add another CTE TO MAKE A RANKING FILTER
(
SELECT *, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking	#Dense rank to remove any duplicates
FROM Company_Year
WHERE years IS NOT NULL
)
SELECT *
FROM Company_Year_Rank #QUERY OFF THE NEW CTE
WHERE Ranking <=5	#Take the top 5 for each year
;