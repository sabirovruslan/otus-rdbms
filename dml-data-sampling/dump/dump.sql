# mysqldump: [Warning] Using a password on the command line interface can be insecure.
-- MySQL dump 10.13  Distrib 5.7.25, for Linux (x86_64)
--
-- Host: localhost    Database: restaurant
-- ------------------------------------------------------
-- Server version	5.7.25

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `account`
--

DROP TABLE IF EXISTS `account`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `account` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `prepayment` decimal(10,2) NOT NULL DEFAULT '0.00',
  `discount_id` smallint(5) unsigned DEFAULT NULL,
  `payment_type_id` smallint(5) unsigned NOT NULL,
  `status_id` smallint(5) unsigned NOT NULL,
  `create_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_fk_account_dictionary1` (`status_id`),
  KEY `idx_fk_account_dictionary2` (`payment_type_id`),
  KEY `idx_fk_account_discount` (`discount_id`),
  CONSTRAINT `fk_account_discount_id` FOREIGN KEY (`discount_id`) REFERENCES `discount` (`id`),
  CONSTRAINT `fk_account_status_id` FOREIGN KEY (`status_id`) REFERENCES `account_dictionary` (`id`),
  CONSTRAINT `fk_payment_type_id` FOREIGN KEY (`payment_type_id`) REFERENCES `payment_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `account`
--

LOCK TABLES `account` WRITE;
/*!40000 ALTER TABLE `account` DISABLE KEYS */;
INSERT INTO `account` VALUES (1,0.00,NULL,2,1,'2019-02-23 11:55:00','2019-02-23 11:55:00');
/*!40000 ALTER TABLE `account` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `account_dictionary`
--

DROP TABLE IF EXISTS `account_dictionary`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `account_dictionary` (
  `id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `code` varchar(45) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_name` (`name`),
  KEY `idx_code` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `account_dictionary`
--

LOCK TABLES `account_dictionary` WRITE;
/*!40000 ALTER TABLE `account_dictionary` DISABLE KEYS */;
INSERT INTO `account_dictionary` VALUES (1,'status new','new',NULL),(2,'status cancel','cancel',NULL),(3,'status paid','paid',NULL);
/*!40000 ALTER TABLE `account_dictionary` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `client`
--

DROP TABLE IF EXISTS `client`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `client` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `surname` varchar(50) NOT NULL,
  `phone` varchar(11) NOT NULL,
  `discount_id` smallint(5) unsigned DEFAULT NULL,
  `create_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_phone` (`phone`),
  KEY `idx_surname_name` (`surname`,`name`),
  KEY `idx_fk_discount_id` (`discount_id`),
  CONSTRAINT `fk_discount_id` FOREIGN KEY (`discount_id`) REFERENCES `discount` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `client`
--

LOCK TABLES `client` WRITE;
/*!40000 ALTER TABLE `client` DISABLE KEYS */;
INSERT INTO `client` VALUES (1,'Test','Sidorov','79281001010',NULL,'2019-02-23 11:54:59','2019-02-23 11:54:59');
/*!40000 ALTER TABLE `client` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `discount`
--

DROP TABLE IF EXISTS `discount`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `discount` (
  `id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `value` tinyint(3) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `discount`
--

LOCK TABLES `discount` WRITE;
/*!40000 ALTER TABLE `discount` DISABLE KEYS */;
INSERT INTO `discount` VALUES (1,5),(2,10),(3,3),(4,15),(5,20);
/*!40000 ALTER TABLE `discount` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dish`
--

DROP TABLE IF EXISTS `dish`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dish` (
  `id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `price` decimal(6,2) NOT NULL,
  `create_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_name` (`name`),
  KEY `idx_price` (`price`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dish`
--

LOCK TABLES `dish` WRITE;
/*!40000 ALTER TABLE `dish` DISABLE KEYS */;
INSERT INTO `dish` VALUES (1,'Salat',500.00,'2019-02-23 11:57:12','2019-02-23 11:57:12'),(2,'Sup',450.00,'2019-02-23 11:57:27','2019-02-23 11:57:27');
/*!40000 ALTER TABLE `dish` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order`
--

DROP TABLE IF EXISTS `order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `order` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `number_persons` tinyint(3) unsigned NOT NULL DEFAULT '2',
  `begin_date` datetime NOT NULL,
  `finish_date` datetime DEFAULT NULL,
  `client_id` int(10) unsigned NOT NULL,
  `waiter_id` smallint(5) unsigned NOT NULL,
  `account_id` bigint(20) unsigned NOT NULL,
  `status_id` smallint(5) unsigned NOT NULL,
  `create_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_begin_and_finish_dates` (`begin_date`,`finish_date`),
  KEY `fk_client_id` (`client_id`),
  KEY `fk_waiter_id` (`waiter_id`),
  KEY `fk_account_id` (`account_id`),
  KEY `fk_status_id` (`status_id`),
  CONSTRAINT `fk_account_id` FOREIGN KEY (`account_id`) REFERENCES `account` (`id`),
  CONSTRAINT `fk_client_id` FOREIGN KEY (`client_id`) REFERENCES `client` (`id`),
  CONSTRAINT `fk_status_id` FOREIGN KEY (`status_id`) REFERENCES `order_dictionary` (`id`),
  CONSTRAINT `fk_waiter_id` FOREIGN KEY (`waiter_id`) REFERENCES `waiter` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order`
--

LOCK TABLES `order` WRITE;
/*!40000 ALTER TABLE `order` DISABLE KEYS */;
INSERT INTO `order` VALUES (1,3,'2019-02-23 11:55:00','2019-02-23 11:55:00',1,1,1,1,'2019-02-23 11:55:00','2019-02-23 11:55:00');
/*!40000 ALTER TABLE `order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_dictionary`
--

DROP TABLE IF EXISTS `order_dictionary`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `order_dictionary` (
  `id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `code` varchar(45) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_name` (`name`),
  KEY `idx_code` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_dictionary`
--

LOCK TABLES `order_dictionary` WRITE;
/*!40000 ALTER TABLE `order_dictionary` DISABLE KEYS */;
INSERT INTO `order_dictionary` VALUES (1,'status new','new',NULL),(2,'status cancel','cancel',NULL),(3,'status completed','completed',NULL);
/*!40000 ALTER TABLE `order_dictionary` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_dishes`
--

DROP TABLE IF EXISTS `order_dishes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `order_dishes` (
  `order_id` bigint(20) unsigned NOT NULL,
  `dish_id` smallint(5) unsigned NOT NULL,
  `amount` smallint(5) unsigned NOT NULL DEFAULT '1',
  `create_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`order_id`,`dish_id`),
  KEY `idx_fk_order_dishes_dish` (`dish_id`),
  KEY `idx_fk_order_id` (`order_id`),
  CONSTRAINT `fk_dish_id` FOREIGN KEY (`dish_id`) REFERENCES `dish` (`id`),
  CONSTRAINT `fk_order_id` FOREIGN KEY (`order_id`) REFERENCES `order` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_dishes`
--

LOCK TABLES `order_dishes` WRITE;
/*!40000 ALTER TABLE `order_dishes` DISABLE KEYS */;
INSERT INTO `order_dishes` VALUES (1,1,2,'2019-02-23 11:57:49','2019-02-23 11:57:49'),(1,2,1,'2019-02-23 11:58:12','2019-02-23 11:58:12');
/*!40000 ALTER TABLE `order_dishes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_tables`
--

DROP TABLE IF EXISTS `order_tables`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `order_tables` (
  `order_id` bigint(20) unsigned NOT NULL,
  `table_id` smallint(5) unsigned NOT NULL,
  `create_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`order_id`,`table_id`),
  KEY `idx_fk_order_tables_order` (`order_id`),
  KEY `idx_fk_order_tables_table` (`table_id`),
  CONSTRAINT `fk_order_tables_order_id` FOREIGN KEY (`order_id`) REFERENCES `order` (`id`),
  CONSTRAINT `fk_order_tables_table_id` FOREIGN KEY (`table_id`) REFERENCES `restaurant_table` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_tables`
--

LOCK TABLES `order_tables` WRITE;
/*!40000 ALTER TABLE `order_tables` DISABLE KEYS */;
INSERT INTO `order_tables` VALUES (1,1,'2019-02-23 11:56:19','2019-02-23 11:56:19');
/*!40000 ALTER TABLE `order_tables` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payment_type`
--

DROP TABLE IF EXISTS `payment_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `payment_type` (
  `id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `code` varchar(50) NOT NULL,
  `create_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_name` (`name`),
  KEY `idx_code` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payment_type`
--

LOCK TABLES `payment_type` WRITE;
/*!40000 ALTER TABLE `payment_type` DISABLE KEYS */;
INSERT INTO `payment_type` VALUES (1,'cashless_payment','cashless_payment','2019-02-23 11:54:59','2019-02-23 11:54:59'),(2,'cash','cash','2019-02-23 11:54:59','2019-02-23 11:54:59');
/*!40000 ALTER TABLE `payment_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `restaurant_table`
--

DROP TABLE IF EXISTS `restaurant_table`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `restaurant_table` (
  `id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `number_seats` tinyint(3) unsigned NOT NULL DEFAULT '2',
  PRIMARY KEY (`id`),
  KEY `idx_number_seats` (`number_seats`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `restaurant_table`
--

LOCK TABLES `restaurant_table` WRITE;
/*!40000 ALTER TABLE `restaurant_table` DISABLE KEYS */;
INSERT INTO `restaurant_table` VALUES (1,'table 1',2),(2,'table 2',3),(3,'table 3',1),(4,'table 4',4);
/*!40000 ALTER TABLE `restaurant_table` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `waiter`
--

DROP TABLE IF EXISTS `waiter`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `waiter` (
  `id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `surname` varchar(50) NOT NULL,
  `create_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_surname_name` (`surname`,`name`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `waiter`
--

LOCK TABLES `waiter` WRITE;
/*!40000 ALTER TABLE `waiter` DISABLE KEYS */;
INSERT INTO `waiter` VALUES (1,'Igor','Ivanov','2019-02-23 11:54:59','2019-02-23 11:54:59');
/*!40000 ALTER TABLE `waiter` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-02-23 17:55:15
