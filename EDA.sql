-- Exploratory Data Analysis

SELECT *
FROM layoffs_staging2;

SELECT MAX(total_laid_off), max(percentage_laid_off)
FROM layoffs_staging2;

SELECT *
FROM layoffs_staging2
where percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

SELECT company, sum(total_laid_off)
FROM layoffs_staging2
group by company
ORDER BY 2 DESC;

SELECT max(date), min(date)
FROM layoffs_staging2;

SELECT industry, sum(total_laid_off)
FROM layoffs_staging2
group by industry
ORDER BY 2 DESC;

SELECT country, sum(total_laid_off)
FROM layoffs_staging2
group by country
ORDER BY 2 DESC;

SELECT year(`DATE`), sum(total_laid_off)
FROM layoffs_staging2
group by year(`DATE`)
ORDER BY 1 DESC;

SELECT stage, sum(total_laid_off)
FROM layoffs_staging2
group by stage
ORDER BY 2 DESC;

SELECT substring(`date`, 1,7) as `Month`, sum(total_laid_off)
FROM layoffs_staging2
where substring(`date`, 1,7) is not null
group by `Month`
ORDER BY 1;

WITH Rolling_Total AS
(
SELECT substring(`date`, 1,7) as `Month`, sum(total_laid_off) AS Total_off
FROM layoffs_staging2
where substring(`date`, 1,7) is not null
group by `Month`
ORDER BY 1
)
SELECT `Month`, Total_off, SUM(Total_off) OVER(ORDER BY `Month`) AS Rolling_Total
FROM Rolling_Total;

SELECT company, sum(total_laid_off)
FROM layoffs_staging2
group by company
ORDER BY 2 DESC;

SELECT company, year(`date`), sum(total_laid_off)
FROM layoffs_staging2
group by company, year(`date`)
order by 3 desc;

WITH Company_year (Company, Years, Total_laid_off) AS
(
SELECT company, year(`date`), sum(total_laid_off)
FROM layoffs_staging2
group by company, year(`date`)
)
SELECT *, dense_rank() over (partition by years order by Total_laid_off desc) as Ranking
FROM Company_year
where years is not null
order by ranking;

WITH Company_year (Company, Years, Total_laid_off) AS
(
SELECT company, year(`date`), sum(total_laid_off)
FROM layoffs_staging2
group by company, year(`date`)
), Company_year_rank as
(
SELECT *, dense_rank() over (partition by years order by Total_laid_off desc) as Ranking
FROM Company_year
where years is not null
)
SELECT *
FROM Company_year_rank
WHERE ranking <= 5;
