DROP DATABASE IF EXISTS nyc_real_estate_dw;

CREATE DATABASE nyc_real_estate_dw;

USE nyc_real_estate_dw;

DROP TABLE IF EXISTS `date`;

CREATE TABLE `date`(
	`date_key` int not null primary key auto_increment,
    `date_string` varchar(50),
    `year` int,
    `month` varchar(50),
    `day` int,
    `day of week` varchar(50)
);

DROP TABLE IF EXISTS `location`;

CREATE TABLE `location`(
	`location_key` int not null primary key auto_increment,
    `borough` varchar(50),
    `neighborhood` varchar(100),
    `address` varchar(100),
    `apartment number` varchar(25),
    `zip code` varchar(5),
    `block` varchar(6),
    `lot` varchar(6)
);

DROP TABLE IF EXISTS `building_type`;

CREATE TABLE `building_type`(
	`building_type_key` int not null primary key auto_increment,
    `building_type` varchar(200),
    `tax_key` varchar(5)
);

DROP TABLE IF EXISTS data_source;

CREATE TABLE data_source(
	`source_key` int not null auto_increment primary key,
    `source` varchar(200)
);

DROP TABLE IF EXISTS `building_sale`;

CREATE TABLE `building_sale`(
	`date_key` int not null,
    `location_key` int not null,
    `building_type_key` int not null,
    `source_key` int not null,
    `sale_price` double,
    FOREIGN KEY (`date_key`) References `date`(`date_key`),
  FOREIGN KEY (`location_key`) References `location`(`location_key`),
  FOREIGN KEY (`building_type_key`) References `building_type`(`building_type_key`),
  FOREIGN KEY (`source_key`) References `data_source`(`source_key`),
  PRIMARY KEY (`date_key`,`location_key`, `building_type_key`, `source_key`)
);

