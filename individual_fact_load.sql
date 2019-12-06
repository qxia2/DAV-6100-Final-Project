INSERT INTO nyc_real_estate_dw.`date` (`date_string`, `year`, `month`, `day`, `day of week`)
SELECT DISTINCT sale_date, 
SUBSTRING_INDEX(sale_date,'-',1) AS 'Year',
SUBSTRING_INDEX(SUBSTRING_INDEX(sale_date,'-',-2),'-',1) AS 'Month',
SUBSTRING_INDEX(SUBSTRING_INDEX(sale_date,'-',-2),'-',-1) AS 'Day',
date_format(sale_date, "%W") as `Day of Week`
FROM nyc_real_estate_original.nyc_rolling;

SELECT `day of week`, count(*)
FROM nyc_real_estate_dw.`date`
GROUP BY `day of week`;

INSERT INTO nyc_real_estate_dw.`location`(`zip code`, `neighborhood`, `borough`, `address`, `apartment number`, `block`, `lot`)
SELECT a.zip_code as 'Zip Code', 
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
SELECT DISTINCT zip_code, neighborhood,borough, SUBSTRING_INDEX(address,'|',1) as `address`,
CASE WHEN SUBSTRING_INDEX(address,'|',-1) = SUBSTRING_INDEX(address,'|',1) THEN NULL 
ELSE SUBSTRING_INDEX(address,'|',-1)
END as `apartment number`,
`block`, `lot`
FROM nyc_real_estate_original.nyc_rolling
WHERE zip_code IS NOT NULL 
AND zip_code NOT IN ('', ' ')) as a;

SELECT * FROM nyc_real_estate_original.nyc_rolling LIMIT 2;

INSERT INTO nyc_real_estate_dw.building_type (`building_type`, `tax_key`)
SELECT DISTINCT 
CASE 
WHEN tax_class_at_present = '1' 
THEN 'Residential'
WHEN tax_class_at_present = '2'
THEN 'Condo/Co-Op'
ELSE
'Other'
END as 'Building Type',
tax_class_at_present
 FROM nyc_real_estate_original.nyc_rolling;
 
INSERT INTO nyc_real_estate_dw.data_source (`source`)
VALUES ('NYC Rolling Sales Data'); 

SELECT * from nyc_real_estate_dw.data_source;

# Fact Table Query in progress

SELECT date_key, location_key,building_type_key,1 FROM nyc_real_estate_original.nyc_rolling 
LEFT JOIN nyc_real_estate_dw.date
ON nyc_real_estate_original.nyc_rolling.sale_date = nyc_real_estate_dw.date.date_string
LEFT JOIN nyc_real_estate_dw.building_type 
ON nyc_real_estate_original.nyc_rolling.tax_class_at_present = nyc_real_estate_dw.building_type.tax_key
LEFT JOIN nyc_real_estate_dw.location
ON nyc_real_estate_original.nyc_rolling.block = nyc_real_estate_dw.location.block
AND nyc_real_estate_original.nyc_rolling.lot = nyc_real_estate_dw.location.lot
AND nyc_real_estate_original.nyc_rolling.zip_code = nyc_real_estate_dw.location.`zip code`
AND SUBSTRING_INDEX(nyc_real_estate_original.nyc_rolling.address,'|',1) = nyc_real_estate_dw.location.address
;

 

