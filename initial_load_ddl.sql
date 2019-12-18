CREATE DATABASE IF NOT EXISTS nyc_real_estate_original;
USE nyc_real_estate_original;

DROP TABLE IF EXISTS `zillow`;

CREATE TABLE `zillow` (
  `zillow_key` int(11) NOT NULL AUTO_INCREMENT,
  `region_id` int(11) DEFAULT NULL,
  `zip_code` int(11) DEFAULT NULL,
  `state` varchar(50) DEFAULT NULL,
  `month_year` varchar(50) DEFAULT NULL,
  `median_sales` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`zillow_key`)
) ENGINE=InnoDB AUTO_INCREMENT=4095 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `nyc_rolling` (
  `nyc_rolling_key` int(11) NOT NULL AUTO_INCREMENT,
  `borough` varchar(50) DEFAULT NULL,
  `neighborhood` varchar(250) DEFAULT NULL,
  `building_class_category` varchar(250) DEFAULT NULL,
  `tax_class_at_present` int(11) DEFAULT NULL,
  `block` int(11) DEFAULT NULL,
  `lot` int(11) DEFAULT NULL,
  `easement` varchar(10) DEFAULT NULL,
  `building_class_at_present` varchar(250) DEFAULT NULL,
  `address` varchar(250) DEFAULT NULL,
  `apartment_num` varchar(50) DEFAULT NULL,
  `zip_code` varchar(10) DEFAULT NULL,
  `residential_units` int(11) DEFAULT NULL,
  `commercial_units` int(11) DEFAULT NULL,
  `total_units` int(11) DEFAULT NULL,
  `land_sq_ft` decimal(10,0) DEFAULT NULL,
  `gross_sq_ft` decimal(10,0) DEFAULT NULL,
  `year_built` int(11) DEFAULT NULL,
  `tax_class_at_sale` varchar(50) DEFAULT NULL,
  `building_class_at_sale` varchar(50) DEFAULT NULL,
  `sale_price` varchar(50) DEFAULT NULL,
  `sale_date` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`nyc_rolling_key`)
) ENGINE=InnoDB AUTO_INCREMENT=25487 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


DROP TABLE IF EXISTS `street_easy`;

CREATE TABLE `street_easy` (
  `street_easy_key` int(11) NOT NULL AUTO_INCREMENT,
  `area`varchar(200) DEFAULT NULL,
  `borough` varchar(200) DEFAULT NULL,
  `area_type` varchar(100) DEFAULT NULL,
  `month_year` varchar(50) DEFAULT NULL,
  `median_sales` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`street_easy_key`)
) ENGINE=InnoDB AUTO_INCREMENT=4095 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


DROP TABLE IF EXISTS `city_realty`;

CREATE TABLE `city_realty` (
 `city_realty_key` int(11) NOT NULL AUTO_INCREMENT,
  `address`varchar(200) DEFAULT NULL,
  `apt_num` varchar(200) DEFAULT NULL,
  `neighborhood` varchar(100) DEFAULT NULL,
  `building_type` varchar(100) DEFAULT NULL,
  `beds` varchar(10) DEFAULT NULL,
  `baths` varchar(10) DEFAULT NULL,
  `price` decimal DEFAULT NULL,
  `sales_date` varchar(50) DEFAULT NULL,
  `zip_code` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`city_realty_key`)
);

DROP TABLE IF EXISTS `nyc_rolling_median`;

CREATE TABLE `nyc_rolling_median` (
 `nyc_rolling_median_key` int(11) NOT NULL AUTO_INCREMENT,
  `year_month`varchar(200) DEFAULT NULL,
  `zip_code` varchar(10) DEFAULT NULL,
  `median_sales_price` decimal DEFAULT NULL,
  PRIMARY KEY (`nyc_rolling_median_key`)
);

DROP TABLE IF EXISTS `city_realty_median`;

CREATE TABLE `city_realty_median` (
 `city_realty_median_key` int(11) NOT NULL AUTO_INCREMENT,
  `year_month`varchar(200) DEFAULT NULL,
  `zip_code` varchar(10) DEFAULT NULL,
  `median_sales_price` decimal DEFAULT NULL,
  PRIMARY KEY (`city_realty_median_key`)
);