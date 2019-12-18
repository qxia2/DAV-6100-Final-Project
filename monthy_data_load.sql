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
WHERE Year NOT IN (SELECT year FROM nyc_real_estate_dw_agg.`date`)
AND Month NOT IN (SELECT month FROM nyc_real_estate_dw_agg.`date`) 
;

SELECT * FROM nyc_real_estate_original.city_realty LIMIT 5;

INSERT INTO nyc_real_estate_dw_agg.`date` (`year`, `month`)
SELECT DISTINCT a.YEAR as 'Year', 
CASE
WHEN a.Month = '1' THEN 'January'
WHEN a.Month = '2' THEN 'February'
WHEN a.Month = '3' THEN 'March'
WHEN a.Month = '4' THEN 'April'
WHEN a.Month = '5' THEN 'May'
WHEN a.Month = '6' THEN 'June'
WHEN a.Month = '7' THEN 'July'
WHEN a.Month = '8' THEN 'August'
WHEN a.Month = '9' THEN 'September'
WHEN a.Month = '10' THEN 'October'
WHEN a.Month = '11' THEN 'November'
WHEN a.Month = '12' THEN 'December'
ELSE NULL
END AS 'Month'
FROM
(SELECT DISTINCT
SUBSTRING_INDEX(`year_month`,'-', 1) as Year,
SUBSTRING_INDEX(SUBSTRING_INDEX(`year_month`,'-',2),'-', -1) as Month
FROM nyc_real_estate_original.city_realty_median) as a
WHERE Year NOT IN (SELECT DISTINCT Year FROM nyc_real_estate_dw_agg.date)
AND Month  NOT IN (SELECT DISTINCT Month FROM nyc_real_estate_dw_agg.`date`) 
;


SELECT * FROM nyc_real_estate_dw_agg.date;

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
WHERE Year NOT IN (SELECT year FROM nyc_real_estate_dw_agg.`date`)
AND Month NOT IN (SELECT month FROM nyc_real_estate_dw_agg.`date`);

SELECT * FROM nyc_real_estate_dw_agg.date WHERE month = 'January';

INSERT INTO nyc_real_estate_dw_agg.neighborhood(`zip code`, `neighborhood`, `borough`)
SELECT CAST(CAST(a.zip_code as UNSIGNED) AS char) as 'Zip Code', 
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
GROUP BY zip_code) as a
WHERE   CAST(CAST(a.zip_code as UNSIGNED) AS char) NOT IN (SELECT DISTINCT `zip code` FROM nyc_real_estate_dw_agg.neighborhood)
;

INSERT INTO nyc_real_estate_dw_agg.neighborhood (`zip code`, `neighborhood`, `borough`)
SELECT CAST(CAST(a.zip_code as UNSIGNED) AS char) as `zip_code`, UPPER(a.neighborhood), 'Unknown'
FROM 
(SELECT DISTINCT zip_code, neighborhood  FROM nyc_real_estate_original.city_realty
WHERE zip_code IS NOT NULL 
AND zip_code NOT IN ('', ' ')
GROUP BY zip_code ) as a
WHERE  CAST(CAST(a.zip_code as UNSIGNED) AS char) NOT IN (SELECT DISTINCT `zip code` FROM nyc_real_estate_dw_agg.neighborhood)
;

INSERT INTO nyc_real_estate_dw_agg.neighborhood (`zip code`)
SELECT a.zip_code
FROM 
(SELECT DISTINCT zip_code FROM nyc_real_estate_original.zillow
WHERE zip_code IS NOT NULL 
AND zip_code NOT IN ('', ' ')
GROUP BY zip_code ) as a
WHERE  a.zip_code NOT IN (SELECT DISTINCT `zip code` FROM nyc_real_estate_dw_agg.neighborhood)
;

INSERT INTO nyc_real_estate_dw_agg.data_source
VALUES (1, 'City Realty'), (2, 'NYC Open Data'), (3, 'Zillow')
;

SELECT * FROM nyc_real_estate_dw_agg.data_source;

SELECT * FROM nyc_real_estate_dw_agg.monthly_sales;

INSERT INTO nyc_real_estate_dw_agg.monthly_sales(date_key, neighborhood_key, source_key, `median sales`)
SELECT  a.date_key, 
nyc_real_estate_dw_agg.neighborhood.neighborhood_key,
3,
median_sales
FROM nyc_real_estate_original.zillow
LEFT JOIN (
SELECT CASE 
WHEN Month = 'January' THEN '01'
WHEN Month = 'February' THEN '02'
WHEN Month = 'March' THEN '03'
WHEN Month = 'April' THEN '04'
WHEN Month = 'May' THEN '05'
WHEN Month = 'June' THEN '06'
WHEN Month = 'July' THEN '07'
WHEN Month = 'August' THEN '08'
WHEN Month = 'September' THEN '09'
WHEN Month = 'October' THEN '10'
WHEN Month = 'November' THEN '11'
WHEN Month = 'December' THEN '12' END as 'Month', 
date_key, year
FROM nyc_real_estate_dw_agg.date) as a
ON SUBSTRING_INDEX(nyc_real_estate_original.zillow.month_year,'-',1) = a.year
AND SUBSTRING_INDEX(nyc_real_estate_original.zillow.month_year,'-',-1) = a.Month
LEFT JOIN nyc_real_estate_dw_agg.neighborhood 
ON nyc_real_estate_original.zillow.zip_code = nyc_real_estate_dw_agg.neighborhood.`zip code`
;

/*
SET @row_number:=0; 
SET @median_group:='';


INSERT INTO nyc_real_estate_dw_agg.monthly_sales(date_key, neighborhood_key, source_key, `median sales`)
SELECT DISTINCT c.date_key, nyc_real_estate_dw_agg.neighborhood.neighborhood_key, 2, 
 AVG(price) as 'median'
FROM
(SELECT
 @row_number:=CASE
        WHEN @median_group = CONCAT(a.month_year, '|', a.zip_code) THEN @row_number + 1
        ELSE 1
    END AS count_of_group,
    @median_group:= CONCAT(a.month_year, '|', a.zip_code) AS median_group,
 a.month_year, a.zip_code, a.price,
(SELECT count(*) FROM nyc_real_estate_original.nyc_rolling
 WHERE a.month_year = substring_index(sale_date, '-', 2)
 AND a.zip_code = zip_code
 AND sale_price > 0)
 AS total_of_group
 FROM 
(SELECT  substring_index(sale_date, '-', 2) as 'month_year', CAST(zip_code AS unsigned) as zip_code, CAST(sale_price AS decimal) as 'price'
FROM nyc_real_estate_original.nyc_rolling
WHERE sale_price > 0
AND substring_index(sale_date, '-', 2) IS NOT NULL
AND substring_index(sale_date, '-', 2)  NOT IN ('', ' ')
AND zip_code IS NOT NULL
AND zip_code NOT IN ('' , ' ')
ORDER BY zip_code, substring_index(sale_date, '-', 2), CAST(sale_price AS decimal) ASC )  as a ) as b
INNER JOIN (
SELECT CASE 
WHEN Month = 'January' THEN '01'
WHEN Month = 'February' THEN '02'
WHEN Month = 'March' THEN '03'
WHEN Month = 'April' THEN '04'
WHEN Month = 'May' THEN '05'
WHEN Month = 'June' THEN '06'
WHEN Month = 'July' THEN '07'
WHEN Month = 'August' THEN '08'
WHEN Month = 'September' THEN '09'
WHEN Month = 'October' THEN '10'
WHEN Month = 'November' THEN '11'
WHEN Month = 'December' THEN '12' END as 'Month', 
date_key, year
FROM nyc_real_estate_dw_agg.date) as c
ON SUBSTRING_INDEX(SUBSTRING_INDEX(median_group, '|', 1), '-', 1) = c.year
AND SUBSTRING_INDEX(SUBSTRING_INDEX(median_group, '|', 1),'-',-1) = c.Month
INNER JOIN nyc_real_estate_dw_agg.neighborhood 
ON substring_index(median_group, '|',-1) = nyc_real_estate_dw_agg.neighborhood.`zip code`
WHERE count_of_group BETWEEN total_of_group / 2.0 AND total_of_group / 2.0 + 1
GROUP BY median_group
;
*/

INSERT INTO nyc_real_estate_dw_agg.monthly_sales(date_key, neighborhood_key, source_key, `median sales`)
SELECT c.date_key, nyc_real_estate_dw_agg.neighborhood.neighborhood_key, 2, median_sales_price
FROM nyc_real_estate_original.nyc_rolling_median
INNER JOIN (
SELECT CASE 
WHEN Month = 'January' THEN '01'
WHEN Month = 'February' THEN '02'
WHEN Month = 'March' THEN '03'
WHEN Month = 'April' THEN '04'
WHEN Month = 'May' THEN '05'
WHEN Month = 'June' THEN '06'
WHEN Month = 'July' THEN '07'
WHEN Month = 'August' THEN '08'
WHEN Month = 'September' THEN '09'
WHEN Month = 'October' THEN '10'
WHEN Month = 'November' THEN '11'
WHEN Month = 'December' THEN '12' END as 'Month', 
date_key, year
FROM nyc_real_estate_dw_agg.date) as c
ON SUBSTRING_INDEX(nyc_real_estate_original.nyc_rolling_median.year_month, '-', 1) = c.year
AND SUBSTRING_INDEX(nyc_real_estate_original.nyc_rolling_median.year_month,'-',-1) = c.Month
INNER JOIN nyc_real_estate_dw_agg.neighborhood 
ON SUBSTRING_INDEX(nyc_real_estate_original.nyc_rolling_median.zip_code, '.', 1) = nyc_real_estate_dw_agg.neighborhood.`zip code`
;

SELECT COUNT(*) FROM nyc_real_estate_dw_agg.monthly_sales;


INSERT INTO nyc_real_estate_dw_agg.monthly_sales(date_key, neighborhood_key, source_key, `median sales`)
SELECT c.date_key, nyc_real_estate_dw_agg.neighborhood.neighborhood_key, 1, median_sales_price
FROM nyc_real_estate_original.city_realty_median
INNER JOIN (
SELECT CASE 
WHEN Month = 'January' THEN '1'
WHEN Month = 'February' THEN '2'
WHEN Month = 'March' THEN '3'
WHEN Month = 'April' THEN '4'
WHEN Month = 'May' THEN '5'
WHEN Month = 'June' THEN '6'
WHEN Month = 'July' THEN '7'
WHEN Month = 'August' THEN '8'
WHEN Month = 'September' THEN '9'
WHEN Month = 'October' THEN '10'
WHEN Month = 'November' THEN '11'
WHEN Month = 'December' THEN '12' END as 'Month', 
date_key, year
FROM nyc_real_estate_dw_agg.date) as c
ON SUBSTRING_INDEX(nyc_real_estate_original.city_realty_median.year_month, '-', 1) = c.year
AND SUBSTRING_INDEX(nyc_real_estate_original.city_realty_median.year_month,'-',-1) = c.Month
INNER JOIN nyc_real_estate_dw_agg.neighborhood 
ON CAST(CAST(nyc_real_estate_original.city_realty_median.zip_code as UNSIGNED) AS char) = nyc_real_estate_dw_agg.neighborhood.`zip code`
;

