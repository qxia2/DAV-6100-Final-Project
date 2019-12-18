USE nyc_real_estate_original;

LOAD DATA LOCAL INFILE "/Users/natanbienstock/Documents/Grad School/Fall 2019/DAV-6100/Final Project/zillow_cleaned.csv"
INTO TABLE zillow
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(region_id, zip_code, state, month_year, median_sales);

SELECT * FROM zillow ORDER BY zillow_key ASC LIMIT 10 ;

LOAD DATA LOCAL INFILE "/Users/natanbienstock/Documents/Grad School/Fall 2019/DAV-6100/Final Project/street_easy_cleaned.csv"
INTO TABLE street_easy
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(area, borough, area_type, month_year, median_sales);


SELECT * FROM street_easy ORDER BY street_easy_key ASC LIMIT 10 ;

#work from here

LOAD DATA LOCAL INFILE "/Users/natanbienstock/Documents/Grad School/Fall 2019/DAV-6100/Final Project/nyc_rolling.csv"
INTO TABLE nyc_rolling
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
( `borough`,
  `neighborhood`,
  `building_class_category`,
  `tax_class_at_present`,
  `block` ,
  `lot` ,
  `easement` ,
  `building_class_at_present` ,
  `address` ,
  `apartment_num` ,
  `zip_code`, 
  `residential_units` ,
  `commercial_units`,
  `total_units` ,
  `land_sq_ft`,
  `gross_sq_ft`,
  `year_built`,
  `tax_class_at_sale`,
  `building_class_at_sale` ,
  `sale_price` ,
  `sale_date`);
  
  SELECT * FROM nyc_rolling;

SELECT DISTINCT neighborhood, GROUP_CONCAT(DISTINCT zip_code) FROM nyc_rolling 
WHERE zip_code IS NOT NULL 
AND zip_code NOT IN ('', ' ') GROUP BY neighborhood;

SELECT a.zip_code as 'Zip Code', 
a.neighborhood as 'Neighbohood',
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

SELECT DISTINCT zip_code
FROM nyc_real_estate_original.nyc_rolling
WHERE zip_code IS NOT NULL 
AND zip_code NOT IN ('', ' ');

LOAD DATA LOCAL INFILE "/Users/natanbienstock/Documents/Grad School/Fall 2019/DAV-6100/Final Project/city_realty_full_cleaned.csv"
INTO TABLE city_realty
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(address, apt_num, neighborhood, building_type, beds, baths, price, sales_date, zip_code);

SELECT * FROM city_realty;
SELECT * from nyc_rolling LIMIT 5;

LOAD DATA LOCAL INFILE "/Users/natanbienstock/Documents/Grad School/Fall 2019/DAV-6100/Final Project/nyc_rolling_medians.csv"
INTO TABLE nyc_rolling_median
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(`year_month`, `zip_code`, `median_sales_price`);

LOAD DATA LOCAL INFILE "/Users/natanbienstock/Documents/Grad School/Fall 2019/DAV-6100/Final Project/city_realty_cleaned_medians.csv"
INTO TABLE city_realty_median
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(`year_month`, `zip_code`, `median_sales_price`);

SELECT * from city_realty_median LIMIT 10;