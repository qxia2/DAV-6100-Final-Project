INSERT INTO nyc_real_estate_dw_agg.`date` (`year`, `month`)
SELECT DISTINCT a.YEAR as 'Year', 
CASE
WHEN a.Month = '01' THEN 'January'
WHEN a.Month = '02' THEN 'February'
WHEN a.Month = '03' THEN 'March'
WHEN a.Month = '04' THEN 'April'
WHEN a.Month = '05' THEN 'May'
WHEN a.Month = '06' THEN 'June'
WHEN a.Month = '07' THEN 'July'
WHEN a.Month = '08' THEN 'August'
WHEN a.Month = '09' THEN 'September'
WHEN a.Month = '10' THEN 'October'
WHEN a.Month = '11' THEN 'November'
WHEN a.Month = '12' THEN 'December'
END AS 'Month'
FROM(
SELECT DISTINCT month_year, 
SUBSTRING_INDEX(month_year,'-',1) AS 'YEAR',
SUBSTRING_INDEX(month_year,'-',-1) AS 'Month'
FROM nyc_real_estate_original.zillow) as a
WHERE 'Year' NOT IN (SELECT 'year' FROM nyc_real_estate_dw_agg.`date`)
AND 'Month' NOT IN (SELECT 'month' FROM nyc_real_estate_dw_agg.`date`) 
;

INSERT INTO nyc_real_estate_dw_agg.`date` (`year`, `month`)
SELECT a.YEAR as 'Year', 
CASE
WHEN a.Month = '01' THEN 'January'
WHEN a.Month = '02' THEN 'February'
WHEN a.Month = '03' THEN 'March'
WHEN a.Month = '04' THEN 'April'
WHEN a.Month = '05' THEN 'May'
WHEN a.Month = '06' THEN 'June'
WHEN a.Month = '07' THEN 'July'
WHEN a.Month = '08' THEN 'August'
WHEN a.Month = '09' THEN 'September'
WHEN a.Month = '10' THEN 'October'
WHEN a.Month = '11' THEN 'November'
WHEN a.Month = '12' THEN 'December'
END AS 'Month'
FROM(
SELECT DISTINCT month_year, 
SUBSTRING_INDEX(month_year,'-',1) AS 'YEAR',
SUBSTRING_INDEX(month_year,'-',-1) AS 'Month'
FROM nyc_real_estate_original.street_easy) as a
WHERE 'Year' NOT IN (SELECT 'year' FROM nyc_real_estate_dw_agg.`date`)
AND 'Month' NOT IN (SELECT 'month' FROM nyc_real_estate_dw_agg.`date`);

INSERT INTO nyc_real_estate_dw_agg.`date` (`year`, `month`)
SELECT DISTINCT a.YEAR as 'Year', 
CASE
WHEN a.Month = '01' THEN 'January'
WHEN a.Month = '02' THEN 'February'
WHEN a.Month = '03' THEN 'March'
WHEN a.Month = '04' THEN 'April'
WHEN a.Month = '05' THEN 'May'
WHEN a.Month = '06' THEN 'June'
WHEN a.Month = '07' THEN 'July'
WHEN a.Month = '08' THEN 'August'
WHEN a.Month = '09' THEN 'September'
WHEN a.Month = '10' THEN 'October'
WHEN a.Month = '11' THEN 'November'
WHEN a.Month = '12' THEN 'December'
END AS 'Month'
FROM(
SELECT DISTINCT sale_date, 
SUBSTRING_INDEX(sale_date,'-',1) AS 'YEAR',
SUBSTRING_INDEX(SUBSTRING_INDEX(sale_date,'-',-2),'-',1) AS 'Month'
FROM nyc_real_estate_original.nyc_rolling) as a
WHERE 'Year' NOT IN (SELECT 'year' FROM nyc_real_estate_dw_agg.`date`)
AND 'Month' NOT IN (SELECT 'month' FROM nyc_real_estate_dw_agg.`date`);

SELECT * FROM nyc_real_estate_dw_agg.date WHERE month = 'January';

INSERT INTO nyc_real_estate_dw_agg.neighborhood(`zip code`, `neighborhood`, `borough`)
SELECT a.zip_code as 'Zip Code', 
a.neighborhood as 'Neighborhood',
CASE 
WHEN a.borough = '1' THEN 'Manhattan'
WHEN a.borough = '2' THEN 'Bronx'
WHEN a.borough = '3' THEN 'Brooklyn'
WHEN a.borough ='4' THEN 'Queens'
WHEN a.borough = '5' THEN 'Staten Island'
END as 'Borough'
FROM(
SELECT DISTINCT zip_code, neighborhood,borough
FROM nyc_real_estate_original.nyc_rolling
WHERE zip_code IS NOT NULL 
AND zip_code NOT IN ('', ' ')
GROUP BY zip_code) as a;

SELECT * FROM nyc_real_estate_dw_agg.neighborhood;

SELECT DISTINCT zip_code FROM nyc_real_estate_original.zillow
WHERE zip_code NOT IN (SELECT `zip code` FROM nyc_real_estate_dw_agg.neighborhood);

SELECT DISTINCT UPPER(area), borough FROM  nyc_real_estate_original.street_easy
WHERE UPPER(area) NOT IN (SELECT `neighborhood` FROM nyc_real_estate_dw_agg.neighborhood);

SELECT DISTINCT `neighborhood` FROM nyc_real_estate_dw_agg.neighborhood;
