-- Data Cleaning

#View the raw dataset to clean
SELECT *
FROM layoffs;

-- Steps to Clean Data
# 1. Remove Duplicates
# 2. Standardize the data
# 3. Null Values or Blank Values
# 4. Remove any unnecessary columns

#Create a new table to preserve the raw data
CREATE TABLE layoffs_staging
LIKE layoffs;

#View the new table
SELECT * 
FROM layoffs_staging;

# Populate the new table (copy all rows)
INSERT layoffs_staging
SELECT *
FROM layoffs;		#we will only edit/update this new table

-- 1 - Removing Duplicates

# Using Window Functions - partition table by columns
SELECT *,
ROW_NUMBER() OVER(
	PARTITION BY 
		company, location, industry, total_laid_off, 
        percentage_laid_off, `date`, stage,
        country, funds_raised_millions) AS row_num
FROM layoffs_staging;

#CTE to create temporary table to filter by row_num to find duplicates
WITH duplicate_cte AS 	#create a new CTE
(
SELECT *,
ROW_NUMBER() OVER(
	PARTITION BY 			#Partition over everything
		company, location, industry, total_laid_off, 
        percentage_laid_off, `date`, stage,
        country, funds_raised_millions) AS row_num
FROM layoffs_staging
)
SELECT *			
FROM duplicate_cte
WHERE row_num > 1;	#Locate any dupes

#CHECK FOR DUPLICATES (TEST)
SELECT *
FROM layoffs_staging
WHERE company = 'Casper';

# Create a new table to delete duplicates with a num_row > 1
CREATE TABLE `layoffs_staging2` (	# (copied create statement from clipboard)
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT # ADD THIS IN
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

# VIEW NEW TABLE'S COLUMNS
SELECT * 
FROM layoffs_staging2
WHERE row_num > 1;	#Filter for any duplicates

# POPULATE NEW TABLE
INSERT INTO layoffs_staging2
SELECT *,		#USE THE WINDOW FUNCTION FROM EARLIER TO POPULATE
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, 
total_laid_off, percentage_laid_off, `date`, 
stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging;

# DELETE DUPLICATES
DELETE 
FROM layoffs_staging2
WHERE row_num > 1;		#Retain original row and remove duplicates

#Apparently I had safe update mode on (disable it)
SET SQL_SAFE_UPDATES = 0;
