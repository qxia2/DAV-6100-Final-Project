CREATE DATABASE IF NOT EXISTS nyc_real_estate_dw_agg;
USE nyc_real_estate_dw_agg;

DROP TABLE IF EXISTS `date`;

CREATE TABLE `date`(
	`date_key` int not null auto_increment primary key,
    `year` varchar(5),
    `month` varchar(25)
);

DROP TABLE IF EXISTS neighborhood;

CREATE TABLE neighborhood(
	`neighborhood_key` int not null auto_increment primary key,
    `borough` varchar(50),
    `neighborhood` varchar(100),
    `zip code` varchar(5)
);

DROP TABLE IF EXISTS data_source;

CREATE TABLE data_source(
	`source_key` int not null auto_increment primary key,
    `source` varchar(200)
);

DROP TABLE IF EXISTS monthly_sales;

CREATE TABLE monthly_sales(
	`date_key` int not null,
    `neighborhood_key` int not null,
    `source_key` int not null,
    `median sales` double,
    FOREIGN KEY (`date_key`) References `date`(`date_key`),
  FOREIGN KEY (`neighborhood_key`) References `neighborhood`(`neighborhood_key`),
  FOREIGN KEY (`source_key`) References `data_source`(`source_key`),
  PRIMARY KEY (`date_key`,`neighborhood_key`, `source_key`)
);
