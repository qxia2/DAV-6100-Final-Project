CREATE DEFINER=`admin`@`%` PROCEDURE `updateFactProc`()
BEGIN

INSERT INTO nyc_real_estate_dw.building_sale (date_key, location_key, building_type_key, source_key, sale_price)
SELECT 
date_key, 
location_key,
building_type_key,
1,
a.price
FROM (SELECT *,
CASE WHEN  building_type = 'condo' OR building_type = 'co-op' OR building_type = 'Condop'
THEN 2
WHEN building_type = 'Townhouse' 
THEN 1 
END as tax_key
FROM nyc_real_estate_original.city_realty) as a
INNER JOIN nyc_real_estate_dw.`date` 
ON str_to_date(a.sales_date, '%m/%d/%Y') = nyc_real_estate_dw.`date`.date_string
INNER JOIN nyc_real_estate_dw.location 
ON CONCAT('CR-', a.city_realty_key) = nyc_real_estate_dw.location.source_key 
INNER JOIN nyc_real_estate_dw.building_type
ON a.tax_key = nyc_real_estate_dw.building_type.tax_key
;


INSERT INTO nyc_real_estate_dw.building_sale (date_key, location_key, building_type_key, source_key, sale_price)
SELECT date_key, 
location_key,
building_type_key,
2, 
sale_price
FROM nyc_real_estate_original.nyc_rolling 
INNER JOIN nyc_real_estate_dw.date
ON nyc_real_estate_original.nyc_rolling.sale_date = nyc_real_estate_dw.date.date_string
INNER JOIN nyc_real_estate_dw.building_type 
ON nyc_real_estate_original.nyc_rolling.tax_class_at_present = nyc_real_estate_dw.building_type.tax_key
INNER JOIN nyc_real_estate_dw.location
ON CONCAT('NYC-', nyc_real_estate_original.nyc_rolling.nyc_rolling_key) = nyc_real_estate_dw.location.source_key 
WHERE sale_price > 0
;

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


END