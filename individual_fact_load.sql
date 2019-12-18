INSERT INTO nyc_real_estate_dw.`date` (`date_string`, `year`, `month`, `day`, `day of week`)
SELECT DISTINCT sale_date, 
SUBSTRING_INDEX(sale_date,'-',1) AS 'Year',
CASE 
WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(sale_date,'-',-2),'-',1) = '01' THEN 'January'
WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(sale_date,'-',-2),'-',1) = '02' THEN 'February'
WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(sale_date,'-',-2),'-',1) = '03' THEN 'March'
WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(sale_date,'-',-2),'-',1) = '04' THEN 'April'
WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(sale_date,'-',-2),'-',1) = '05' THEN 'May'
WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(sale_date,'-',-2),'-',1) = '06' THEN 'June'
WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(sale_date,'-',-2),'-',1) = '07' THEN 'July'
WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(sale_date,'-',-2),'-',1) = '08' THEN 'August'
WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(sale_date,'-',-2),'-',1) = '09' THEN 'September'
WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(sale_date,'-',-2),'-',1) = '10' THEN 'October'
WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(sale_date,'-',-2),'-',1) = '11' THEN 'November'
WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(sale_date,'-',-2),'-',1) = '12' THEN 'December'
END AS 'Month',
SUBSTRING_INDEX(SUBSTRING_INDEX(sale_date,'-',-2),'-',-1) AS 'Day',
date_format(sale_date, "%W") as `Day of Week`
FROM nyc_real_estate_original.nyc_rolling
WHERE sale_date NOT IN (SELECT DISTINCT date_string FROM nyc_real_estate_dw.`date`);

SELECT * FROM nyc_real_estate_dw.date LIMIT 5;

INSERT INTO nyc_real_estate_dw.`date` (`date_string`, `year`, `month`, `day`, `day of week`)
SELECT DISTINCT str_to_date(sales_date, '%m/%d/%Y') as `Sale_Date`,
 date_format(str_to_date(sales_date, '%m/%d/%Y'), "%Y") as `Year`,
  CASE 
WHEN date_format(str_to_date(sales_date, '%m/%d/%Y'), "%m") = '01' THEN 'January'
WHEN date_format(str_to_date(sales_date, '%m/%d/%Y'), "%m") = '02' THEN 'February'
WHEN date_format(str_to_date(sales_date, '%m/%d/%Y'), "%m") = '03' THEN 'March'
WHEN date_format(str_to_date(sales_date, '%m/%d/%Y'), "%m") = '04' THEN 'April'
WHEN date_format(str_to_date(sales_date, '%m/%d/%Y'), "%m") = '05' THEN 'May'
WHEN date_format(str_to_date(sales_date, '%m/%d/%Y'), "%m") = '06' THEN 'June'
WHEN date_format(str_to_date(sales_date, '%m/%d/%Y'), "%m") = '07' THEN 'July'
WHEN date_format(str_to_date(sales_date, '%m/%d/%Y'), "%m") = '08' THEN 'August'
WHEN date_format(str_to_date(sales_date, '%m/%d/%Y'), "%m") = '09' THEN 'September'
WHEN date_format(str_to_date(sales_date, '%m/%d/%Y'), "%m") = '10' THEN 'October'
WHEN date_format(str_to_date(sales_date, '%m/%d/%Y'), "%m") = '11' THEN 'November'
  WHEN date_format(str_to_date(sales_date, '%m/%d/%Y'), "%m") = '12' THEN 'December'
  END as `Month`,
    date_format(str_to_date(sales_date, '%m/%d/%Y'), "%d") as `Day`,
 date_format(str_to_date(sales_date, '%m/%d/%Y'), "%W") as `Day of Week`
 FROM nyc_real_estate_original.city_realty;
 

INSERT INTO nyc_real_estate_dw.`location`(`source_key`,`zip code`, `neighborhood`, `borough`, `address`, `apartment number`, `block`, `lot`)
SELECT DISTINCT CONCAT('NYC-', a.nyc_rolling_key) as Source_Code,
 CAST(a.zip_code AS UNSIGNED) as 'Zip Code', 
a.neighborhood as 'Neighbohood',
CASE 
WHEN a.borough = '1' THEN 'Manhattan'
WHEN a.borough = '2' THEN 'Bronx'
WHEN a.borough = '3' THEN 'Brooklyn'
WHEN a.borough ='4' THEN 'Queens'
WHEN a.borough = '5' THEN 'Staten Island'
END as 'Borough', 
a.`address` as 'Address',
CASE WHEN a.`apartment number` IS NOT NULL
THEN a.`apartment number`
ELSE 'Whole Building'
END as 'Apartment Number' ,
a.block as 'Block',
a.lot as 'Lot'
FROM(
SELECT DISTINCT nyc_rolling_key,zip_code, neighborhood,borough, SUBSTRING_INDEX(address,'|',1) as `address`,
CASE WHEN SUBSTRING_INDEX(address,'|',-1) = SUBSTRING_INDEX(address,'|',1) THEN NULL 
ELSE SUBSTRING_INDEX(address,'|',-1)
END as `apartment number`,
`block`, `lot`
FROM nyc_real_estate_original.nyc_rolling
WHERE zip_code IS NOT NULL 
AND zip_code NOT IN ('', ' ')) as a;

INSERT INTO nyc_real_estate_dw.`location`(`source_key`,`zip code`, `neighborhood`, `address`, `apartment number`)
SELECT  DISTINCT CONCAT('CR-', city_realty_key), 
zip_code, 
neighborhood, 
address, 
apt_num   
FROM nyc_real_estate_original.city_realty;

INSERT INTO nyc_real_estate_dw.building_type (`building_type`, `tax_key`)
SELECT a.`Building Type`, a.`Tax Class`
FROM (SELECT DISTINCT  CASE 
WHEN  building_type = 'condo' OR building_type = 'co-op' OR building_type = 'Condop'
THEN 'Condo/Co-Op' 
WHEN building_type = 'Townhouse' 
THEN 'Residential'
END As `Building Type`,
CASE WHEN  building_type = 'condo' OR building_type = 'co-op' OR building_type = 'Condop'
THEN 2
WHEN building_type = 'Townhouse' 
THEN 1
END As `Tax Class`
FROM  nyc_real_estate_original.city_realty) as a 
WHERE `Building Type` NOT IN (SELECT building_type FROM nyc_real_estate_dw.building_type);

INSERT INTO nyc_real_estate_dw.building_type (`building_type`, `tax_key`)
SELECT Building_Type, tax_class_at_present
FROM (SELECT DISTINCT 
CASE 
WHEN tax_class_at_present = '1' 
THEN 'Residential'
WHEN tax_class_at_present = '2'
THEN 'Condo/Co-Op'
ELSE
'Other'
END as Building_Type,
tax_class_at_present
FROM nyc_real_estate_original.nyc_rolling) AS a
WHERE Building_Type NOT IN (SELECT DISTINCT building_type FROM nyc_real_estate_dw.building_type);

SELECT * FROM nyc_real_estate_dw.building_type;
 
INSERT INTO nyc_real_estate_dw.data_source (`source_key`,`source`)
VALUES (1, 'City Realty'),
(2, 'NYC Rolling Sales Data'); 

SELECT * from nyc_real_estate_dw.data_source;


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
ON a.tax_key = nyc_real_estate_dw.building_type.tax_key;

# Fact Table Query in progress

SELECT * FROM nyc_real_estate_dw.building_sale;

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

SELECT COUNT(*) FROM nyc_real_estate_original.nyc_rolling WHERE sale_price>0;