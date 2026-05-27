-- MySQL dump 10.13  Distrib 8.0.46, for Win64 (x86_64)
--
-- Host: localhost    Database: little_thread
-- ------------------------------------------------------
-- Server version	8.0.46

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `little_thread`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `little_thread` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `little_thread`;

--
-- Table structure for table `_categorytoproduct`
--

DROP TABLE IF EXISTS `_categorytoproduct`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `_categorytoproduct` (
  `A` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `B` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  UNIQUE KEY `_CategoryToProduct_AB_unique` (`A`,`B`),
  KEY `_CategoryToProduct_B_index` (`B`),
  CONSTRAINT `_CategoryToProduct_A_fkey` FOREIGN KEY (`A`) REFERENCES `category` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `_CategoryToProduct_B_fkey` FOREIGN KEY (`B`) REFERENCES `product` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `_categorytoproduct`
--

LOCK TABLES `_categorytoproduct` WRITE;
/*!40000 ALTER TABLE `_categorytoproduct` DISABLE KEYS */;
INSERT INTO `_categorytoproduct` VALUES ('3e5c4296-c041-43f2-b444-0425c0e3acea','8ca801ed-9c94-469e-ab83-bcd2d96beec6'),('c904ea54-7a63-4d30-98db-d24db76024e4','8ca801ed-9c94-469e-ab83-bcd2d96beec6'),('44817bc7-4b47-4123-b057-342469a12f2c','eeea7f68-2f6f-427d-a1e1-3556f0bb9dd5'),('44817bc7-4b47-4123-b057-342469a12f2c','f06bf710-1b81-477d-8336-bdf543142cdc');
/*!40000 ALTER TABLE `_categorytoproduct` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `_collectiontoproduct`
--

DROP TABLE IF EXISTS `_collectiontoproduct`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `_collectiontoproduct` (
  `A` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `B` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  UNIQUE KEY `_CollectionToProduct_AB_unique` (`A`,`B`),
  KEY `_CollectionToProduct_B_index` (`B`),
  CONSTRAINT `_CollectionToProduct_A_fkey` FOREIGN KEY (`A`) REFERENCES `collection` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `_CollectionToProduct_B_fkey` FOREIGN KEY (`B`) REFERENCES `product` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `_collectiontoproduct`
--

LOCK TABLES `_collectiontoproduct` WRITE;
/*!40000 ALTER TABLE `_collectiontoproduct` DISABLE KEYS */;
INSERT INTO `_collectiontoproduct` VALUES ('c29d2790-23e6-40f0-850f-2b5f8cbc73f1','3e146278-bb34-453b-80c4-f9f726cf12e2'),('c29d2790-23e6-40f0-850f-2b5f8cbc73f1','69e6ed03-e19b-43ea-afe1-3aa6f49be73a'),('5fb25081-dd40-4f85-bff1-c0a11ab4b3b7','8ca801ed-9c94-469e-ab83-bcd2d96beec6'),('cf9a4f2a-676d-4375-84df-ee78fb6b4b2d','8ca801ed-9c94-469e-ab83-bcd2d96beec6'),('c29d2790-23e6-40f0-850f-2b5f8cbc73f1','91ed5582-9c57-4dc2-bc5c-0ac3cb5e2589'),('c29d2790-23e6-40f0-850f-2b5f8cbc73f1','dfd5f30f-039b-4cf7-96ea-7f0917605639');
/*!40000 ALTER TABLE `_collectiontoproduct` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `address`
--

DROP TABLE IF EXISTS `address`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `address` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `customerId` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `phone` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `addressLine1` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `addressLine2` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `city` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `state` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `pincode` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` datetime(3) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `Address_pincode_idx` (`pincode`),
  KEY `Address_customerId_fkey` (`customerId`),
  CONSTRAINT `Address_customerId_fkey` FOREIGN KEY (`customerId`) REFERENCES `customer` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `address`
--

LOCK TABLES `address` WRITE;
/*!40000 ALTER TABLE `address` DISABLE KEYS */;
INSERT INTO `address` VALUES ('1722b8c1-616c-426d-a7b4-c2154e8005b3','e51d6f1d-8c72-4a0a-bacf-1ecf4ecae300','Saved Address','','123 Luxury Lane','Apt 123','Mumbai','Maharashtra','400001','2026-05-23 10:38:53.077','2026-05-23 10:38:53.077'),('94bfecca-83e3-480c-bdfa-98dbf5ed02d0','72a54893-527e-4269-933f-f11aaaf374cf','Saved Address','','34,lig square','123','Indore',',adhyapradesh','452010','2026-05-23 09:22:24.737','2026-05-23 09:22:24.737');
/*!40000 ALTER TABLE `address` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `admin`
--

DROP TABLE IF EXISTS `admin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `admin` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is2FAEnabled` tinyint(1) NOT NULL DEFAULT '0',
  `otp` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `otpExpires` datetime(3) DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` datetime(3) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `Admin_email_key` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admin`
--

LOCK TABLES `admin` WRITE;
/*!40000 ALTER TABLE `admin` DISABLE KEYS */;
INSERT INTO `admin` VALUES ('8bb00ffc-f379-4992-9bf9-89aed1dfd764','admin@example.com',NULL,0,NULL,NULL,'2026-05-14 07:05:58.219','2026-05-14 07:05:58.219'),('faf9174c-0633-4c3c-ab67-8053a1aca2b5','swatigunjan1@gmail.com','admin123',0,NULL,NULL,'2026-05-23 11:24:30.476','2026-05-23 11:25:17.516');
/*!40000 ALTER TABLE `admin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `banner`
--

DROP TABLE IF EXISTS `banner`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `banner` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `imageUrl` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `altText` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `linkUrl` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `type` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'DESKTOP',
  `order` int NOT NULL DEFAULT '0',
  `isActive` tinyint(1) NOT NULL DEFAULT '1',
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` datetime(3) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `Banner_isActive_idx` (`isActive`),
  KEY `Banner_createdAt_idx` (`createdAt`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `banner`
--

LOCK TABLES `banner` WRITE;
/*!40000 ALTER TABLE `banner` DISABLE KEYS */;
/*!40000 ALTER TABLE `banner` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `brand`
--

DROP TABLE IF EXISTS `brand`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `brand` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  UNIQUE KEY `Brand_name_key` (`name`),
  UNIQUE KEY `Brand_slug_key` (`slug`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `brand`
--

LOCK TABLES `brand` WRITE;
/*!40000 ALTER TABLE `brand` DISABLE KEYS */;
INSERT INTO `brand` VALUES ('f2ef7474-d792-46a1-93e5-1c0b9d0457d4','Little Threads','little-threads','2026-05-15 08:30:28.803');
/*!40000 ALTER TABLE `brand` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `category`
--

DROP TABLE IF EXISTS `category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `category` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  UNIQUE KEY `Category_name_key` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `category`
--

LOCK TABLES `category` WRITE;
/*!40000 ALTER TABLE `category` DISABLE KEYS */;
INSERT INTO `category` VALUES ('3e5c4296-c041-43f2-b444-0425c0e3acea','Set',NULL,'2026-05-15 08:30:28.803'),('44817bc7-4b47-4123-b057-342469a12f2c','Feeding Essentials',NULL,'2026-05-14 09:05:08.430'),('6e289794-fed3-4d04-b3af-7b1600427977','Girls Clothing',NULL,'2026-05-14 09:04:41.893'),('9e5d7725-c816-494c-b048-562fec52944f','Toys & Games',NULL,'2026-05-14 09:04:53.925'),('9f053b6c-ee70-45fd-9ae9-18c2e4bd144d','Boys clothing',NULL,'2026-05-14 09:04:35.583'),('added5d7-cad1-45cc-9232-8d4656fb301c','Baby Essentials',NULL,'2026-05-14 09:04:59.405'),('c904ea54-7a63-4d30-98db-d24db76024e4','Baby Clothing',NULL,'2026-05-15 08:30:28.803'),('cd1ab3d6-fb6a-4b61-9cfa-ec103a99b242','Kids Footwear',NULL,'2026-05-14 09:04:48.341'),('d944d22c-5df7-45cf-8568-e66c593f0c12','Bath & Baby Care',NULL,'2026-05-14 09:05:15.670');
/*!40000 ALTER TABLE `category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `collection`
--

DROP TABLE IF EXISTS `collection`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `collection` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `imageUrl` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `order` int NOT NULL DEFAULT '0',
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  UNIQUE KEY `Collection_name_key` (`name`),
  KEY `Collection_name_idx` (`name`),
  KEY `Collection_createdAt_idx` (`createdAt`),
  KEY `Collection_order_idx` (`order`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `collection`
--

LOCK TABLES `collection` WRITE;
/*!40000 ALTER TABLE `collection` DISABLE KEYS */;
INSERT INTO `collection` VALUES ('173b4497-c6b2-439d-b056-58ea1f7225af','Sale','','http://localhost:5000/uploads/collections/new-1761920422014--2--1778829034031-706897330.gif',4,'2026-05-15 05:52:08.453'),('4851e015-536b-45cb-b377-f8c5301d8c6f','Footware','','http://localhost:5000/uploads/products/image-1778824338033-773654095_optimized.webp',5,'2026-05-15 05:52:18.145'),('4c9132b2-2f08-42fc-be5f-65bc07534151','Baby Care','','http://localhost:5000/uploads/products/image-1778824252759-123712674_optimized.webp',1,'2026-05-15 05:50:52.843'),('4e017274-e969-40fe-8f4f-06bc40f4e7ae','Boys collection','','http://localhost:5000/uploads/products/image-1778756814360-233181913_optimized.webp',8,'2026-05-14 11:06:54.459'),('5fb25081-dd40-4f85-bff1-c0a11ab4b3b7','New Arrivals',NULL,NULL,10,'2026-05-15 08:30:28.803'),('6e38fe61-6762-47fa-9cb3-1c80ea1b99ad','Baby Gear','','http://localhost:5000/uploads/products/image-1778824282288-588181499_optimized.webp',2,'2026-05-15 05:51:22.360'),('79418e65-d4a7-471a-a3af-baa48398e0f7','New born','','http://localhost:5000/uploads/products/image-1778824377747-512094013_optimized.webp',7,'2026-05-15 05:52:57.822'),('a07a65fb-590d-48ef-b42e-e91fc5492bcc','Girls Collection','','http://localhost:5000/uploads/products/image-1778756848266-498168745_optimized.webp',9,'2026-05-14 11:07:28.363'),('c29d2790-23e6-40f0-850f-2b5f8cbc73f1','Best sellers','','',12,'2026-05-15 10:28:57.009'),('cf9a4f2a-676d-4375-84df-ee78fb6b4b2d','Featured',NULL,NULL,11,'2026-05-15 08:30:28.803'),('d3fa838c-547b-4bdd-8703-cbd608a0b6a2','Accessories','','http://localhost:5000/uploads/products/image-1778824227890-559898109_optimized.webp',0,'2026-05-15 05:50:28.035'),('dbe3dc53-8d72-4654-822d-190d1222d233','New Arrival','','http://localhost:5000/uploads/collections/new-arrivals-1757862927977--2--1778829025130-140595505.gif',6,'2026-05-15 05:52:50.284'),('f8d1488c-501a-4b48-83da-18088bac8023','Bedding','','http://localhost:5000/uploads/products/image-1778824288271-741889382_optimized.webp',3,'2026-05-15 05:51:28.368');
/*!40000 ALTER TABLE `collection` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contactmessage`
--

DROP TABLE IF EXISTS `contactmessage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `contactmessage` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `subject` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `message` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `isRead` tinyint(1) NOT NULL DEFAULT '0',
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contactmessage`
--

LOCK TABLES `contactmessage` WRITE;
/*!40000 ALTER TABLE `contactmessage` DISABLE KEYS */;
/*!40000 ALTER TABLE `contactmessage` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `coupon`
--

DROP TABLE IF EXISTS `coupon`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `coupon` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `code` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `percentage` double NOT NULL,
  `type` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'PERCENTAGE',
  `isActive` tinyint(1) NOT NULL DEFAULT '1',
  `maxUses` int DEFAULT NULL,
  `usedCount` int NOT NULL DEFAULT '0',
  `allowedEmails` json NOT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` datetime(3) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `Coupon_code_key` (`code`),
  KEY `Coupon_code_idx` (`code`),
  KEY `Coupon_isActive_idx` (`isActive`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `coupon`
--

LOCK TABLES `coupon` WRITE;
/*!40000 ALTER TABLE `coupon` DISABLE KEYS */;
/*!40000 ALTER TABLE `coupon` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customer`
--

DROP TABLE IF EXISTS `customer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customer` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `mobile` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `gender` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `password` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `provider` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'local',
  `otp` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `otpExpires` datetime(3) DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` datetime(3) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `Customer_email_key` (`email`),
  UNIQUE KEY `Customer_mobile_key` (`mobile`),
  KEY `Customer_email_idx` (`email`),
  KEY `Customer_mobile_idx` (`mobile`),
  KEY `Customer_createdAt_idx` (`createdAt`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer`
--

LOCK TABLES `customer` WRITE;
/*!40000 ALTER TABLE `customer` DISABLE KEYS */;
INSERT INTO `customer` VALUES ('72a54893-527e-4269-933f-f11aaaf374cf','customer@gmail.com',NULL,'customer','Male','$2b$12$huAbDNflBQbxgsOaLDcaZOeIz4spQ7bysScDW0LWRZxzj.Cy/6WZm','local',NULL,NULL,'2026-05-23 06:33:46.328','2026-05-23 06:33:46.328'),('e51d6f1d-8c72-4a0a-bacf-1ecf4ecae300','test@example.com',NULL,'Test User','Male','$2b$12$DyK5NLUfGdP63.FjdaOJEuGJL8JBQTY4oxJk8CujORRPRhzziJ3T2','local',NULL,NULL,'2026-05-23 10:36:00.394','2026-05-23 10:36:00.394'),('ef4a0efd-b4fb-4baa-8b24-6c4bbb4e2e0b','test@gmail.com',NULL,'testing3','Male','$2b$12$xQVpLCFocuyDEMZhZx4/LOlFrH72/dCxrs/uT6.vJTGMpVOwJsSCG','local',NULL,NULL,'2026-05-14 12:37:07.880','2026-05-14 12:37:07.880');
/*!40000 ALTER TABLE `customer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `failedshipment`
--

DROP TABLE IF EXISTS `failedshipment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `failedshipment` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `provider` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'SHIPROCKET',
  `orderId` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `stage` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` json DEFAULT NULL,
  `errorMessage` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `errorDetails` json DEFAULT NULL,
  `attempts` int NOT NULL DEFAULT '0',
  `lastAttemptAt` datetime(3) DEFAULT NULL,
  `resolved` tinyint(1) NOT NULL DEFAULT '0',
  `resolvedAt` datetime(3) DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` datetime(3) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FailedShipment_orderId_idx` (`orderId`),
  KEY `FailedShipment_stage_idx` (`stage`),
  KEY `FailedShipment_resolved_idx` (`resolved`),
  KEY `FailedShipment_createdAt_idx` (`createdAt`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `failedshipment`
--

LOCK TABLES `failedshipment` WRITE;
/*!40000 ALTER TABLE `failedshipment` DISABLE KEYS */;
/*!40000 ALTER TABLE `failedshipment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `globalsetting`
--

DROP TABLE IF EXISTS `globalsetting`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `globalsetting` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'default',
  `codEnabled` tinyint(1) NOT NULL DEFAULT '0',
  `updatedAt` datetime(3) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `globalsetting`
--

LOCK TABLES `globalsetting` WRITE;
/*!40000 ALTER TABLE `globalsetting` DISABLE KEYS */;
INSERT INTO `globalsetting` VALUES ('default',0,'2026-05-14 10:08:25.540');
/*!40000 ALTER TABLE `globalsetting` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mobileotp`
--

DROP TABLE IF EXISTS `mobileotp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mobileotp` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `mobile` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `otpHash` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiresAt` datetime(3) NOT NULL,
  `attempts` int NOT NULL DEFAULT '0',
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` datetime(3) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `MobileOtp_mobile_key` (`mobile`),
  KEY `MobileOtp_expiresAt_idx` (`expiresAt`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mobileotp`
--

LOCK TABLES `mobileotp` WRITE;
/*!40000 ALTER TABLE `mobileotp` DISABLE KEYS */;
/*!40000 ALTER TABLE `mobileotp` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order`
--

DROP TABLE IF EXISTS `order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `totalAmount` double NOT NULL,
  `status` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'ORDERED',
  `customerId` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` datetime(3) NOT NULL,
  `razorpayOrderId` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `razorpayPaymentId` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `razorpaySignature` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `paymentMethod` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `invoiceNumber` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `shippingAddress` json DEFAULT NULL,
  `deliveryDate` datetime(3) DEFAULT NULL,
  `cancellationReason` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `Order_razorpayOrderId_key` (`razorpayOrderId`),
  UNIQUE KEY `Order_razorpayPaymentId_key` (`razorpayPaymentId`),
  UNIQUE KEY `Order_invoiceNumber_key` (`invoiceNumber`),
  KEY `Order_status_idx` (`status`),
  KEY `Order_customerId_idx` (`customerId`),
  KEY `Order_createdAt_idx` (`createdAt`),
  KEY `Order_razorpayOrderId_idx` (`razorpayOrderId`),
  CONSTRAINT `Order_customerId_fkey` FOREIGN KEY (`customerId`) REFERENCES `customer` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order`
--

LOCK TABLES `order` WRITE;
/*!40000 ALTER TABLE `order` DISABLE KEYS */;
INSERT INTO `order` VALUES ('0afaa3e0-1579-446f-8c34-e6f43bf9c07e',79,'PAID',NULL,'2026-05-23 11:14:54.097','2026-05-23 11:18:41.420','order_SsmxgcHebaZJxK','pay_Ssn1Mi6QmfaYg6','70322720b8292f96ee24aa6c305662c233875799ab40a357abfde316c9b1bf14','razorpay','GOE-2026-03','{\"city\": \"Indore\", \"email\": \"customer@gmail.com\", \"phone\": \"12345679\", \"state\": \",adhyapradesh\", \"address\": \"34,lig square\", \"pinCode\": \"452010\", \"fullName\": \"customer cust\", \"lastName\": \"cust\", \"apartment\": \"\", \"firstName\": \"customer\", \"addressLabel\": \"Saved Address\"}',NULL,NULL),('4de89d22-40b9-4c8c-87e4-67927bf5558d',1000,'PENDING',NULL,'2026-05-23 11:02:53.372','2026-05-23 11:02:53.372','order_Ssmkztm6dOL7xz',NULL,NULL,'razorpay','GOE-2026-01','{\"city\": \"Test City\", \"email\": \"test@example.com\", \"phone\": \"9876543210\", \"state\": \"TS\", \"address\": \"123 Test St\", \"pinCode\": \"123456\", \"fullName\": \"Test User\", \"lastName\": \"User\", \"apartment\": \"Apt 1\", \"firstName\": \"Test\"}',NULL,NULL),('c7615f19-a689-48f0-a89a-51528bacc1c9',88,'PAID',NULL,'2026-05-23 11:05:24.075','2026-05-23 11:12:27.591','order_SsmneOppKxjHoy','pay_Ssmup0QJ4Ad8J4','51b73aee8ea448f0bd83edc07fb29cf31f8bf6d95dc8c1f2b3220c1e2ffc41b5','razorpay','GOE-2026-02','{\"city\": \"Indore\", \"email\": \"customer@gmail.com\", \"phone\": \"12345679\", \"state\": \",adhyapradesh\", \"address\": \"34,lig square\", \"pinCode\": \"452010\", \"fullName\": \"customer yadav\", \"lastName\": \"yadav\", \"apartment\": \"\", \"firstName\": \"customer\", \"addressLabel\": \"Saved Address\"}',NULL,NULL);
/*!40000 ALTER TABLE `order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orderactivity`
--

DROP TABLE IF EXISTS `orderactivity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orderactivity` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `orderId` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `message` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  KEY `OrderActivity_orderId_idx` (`orderId`),
  CONSTRAINT `OrderActivity_orderId_fkey` FOREIGN KEY (`orderId`) REFERENCES `order` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orderactivity`
--

LOCK TABLES `orderactivity` WRITE;
/*!40000 ALTER TABLE `orderactivity` DISABLE KEYS */;
INSERT INTO `orderactivity` VALUES ('41251103-3504-4824-988c-bdd74147cb4b','c7615f19-a689-48f0-a89a-51528bacc1c9','PAYMENT_RECEIVED','Payment of ₹88 verified.','2026-05-23 11:12:27.663'),('47319ed1-36fe-4d33-acc3-fad16ae36099','0afaa3e0-1579-446f-8c34-e6f43bf9c07e','PAYMENT_RECEIVED','Payment of ₹79 verified.','2026-05-23 11:18:41.469');
/*!40000 ALTER TABLE `orderactivity` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orderitem`
--

DROP TABLE IF EXISTS `orderitem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orderitem` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `quantity` int NOT NULL,
  `price` double NOT NULL,
  `productId` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `productName` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `variantTitle` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `orderId` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `OrderItem_orderId_idx` (`orderId`),
  KEY `OrderItem_productId_idx` (`productId`),
  CONSTRAINT `OrderItem_orderId_fkey` FOREIGN KEY (`orderId`) REFERENCES `order` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `OrderItem_productId_fkey` FOREIGN KEY (`productId`) REFERENCES `product` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orderitem`
--

LOCK TABLES `orderitem` WRITE;
/*!40000 ALTER TABLE `orderitem` DISABLE KEYS */;
INSERT INTO `orderitem` VALUES ('0d8bf8a7-81a8-475f-ad79-5d272faa9515',1,1000,'3e146278-bb34-453b-80c4-f9f726cf12e2','Little Star Sleepsuit','M','4de89d22-40b9-4c8c-87e4-67927bf5558d'),('2a46402b-ba1e-420f-8668-9c1ff66ca907',1,79,'3e146278-bb34-453b-80c4-f9f726cf12e2','Little Star Sleepsuit','Color: blue, Size: 3 - 4 Y','0afaa3e0-1579-446f-8c34-e6f43bf9c07e'),('4fc6cd80-543b-41d3-8b5e-e02ff1d58a42',1,88,'69e6ed03-e19b-43ea-afe1-3aa6f49be73a','Tiny Explorer Romper',NULL,'c7615f19-a689-48f0-a89a-51528bacc1c9');
/*!40000 ALTER TABLE `orderitem` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product`
--

DROP TABLE IF EXISTS `product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `subtitle` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `handle` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `price` double NOT NULL,
  `isDiscountable` tinyint(1) NOT NULL DEFAULT '0',
  `discountPrice` double DEFAULT NULL,
  `images` json NOT NULL,
  `thumbnailUrl` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `hoverThumbnailUrl` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `stock` int NOT NULL DEFAULT '0',
  `weight` double DEFAULT NULL,
  `length` double DEFAULT NULL,
  `breadth` double DEFAULT NULL,
  `height` double DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` datetime(3) NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `brandId` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `compareAtPrice` double DEFAULT NULL,
  `costPrice` double DEFAULT NULL,
  `tags` json DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `Product_name_key` (`name`),
  UNIQUE KEY `Product_handle_key` (`handle`),
  KEY `Product_price_idx` (`price`),
  KEY `Product_createdAt_idx` (`createdAt`),
  KEY `Product_stock_idx` (`stock`),
  KEY `Product_handle_idx` (`handle`),
  KEY `Product_brandId_idx` (`brandId`),
  CONSTRAINT `Product_brandId_fkey` FOREIGN KEY (`brandId`) REFERENCES `brand` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product`
--

LOCK TABLES `product` WRITE;
/*!40000 ALTER TABLE `product` DISABLE KEYS */;
INSERT INTO `product` VALUES ('3e146278-bb34-453b-80c4-f9f726cf12e2','Little Star Sleepsuit','','little-star-sleepsuit','',79,1,20,'[\"http://localhost:5000/uploads/products/image-1778840087958-850941957_optimized.webp\", \"http://localhost:5000/uploads/products/image-1778840088066-447669607_optimized.webp\"]','http://localhost:5000/uploads/products/image-1778840087958-850941957_optimized.webp','http://localhost:5000/uploads/products/image-1778840088066-447669607_optimized.webp',0,NULL,NULL,NULL,NULL,'2026-05-15 10:14:48.210','2026-05-15 10:16:41.226',1,NULL,NULL,NULL,NULL),('69e6ed03-e19b-43ea-afe1-3aa6f49be73a','Tiny Explorer Romper','','tiny-explorer-romper','',88,1,12,'[\"http://localhost:5000/uploads/products/image-1778839845382-157441930_optimized.webp\", \"http://localhost:5000/uploads/products/image-1778839845466-450545707_optimized.webp\"]','http://localhost:5000/uploads/products/image-1778839845382-157441930_optimized.webp','http://localhost:5000/uploads/products/image-1778839845466-450545707_optimized.webp',1,NULL,NULL,NULL,NULL,'2026-05-15 10:10:45.588','2026-05-23 11:12:27.626',1,NULL,NULL,NULL,NULL),('8ca801ed-9c94-469e-ab83-bcd2d96beec6','Indigo Edit','Soft cotton outfit','Handcrafted cotton set','indigo-edit',1599,1,1399,'[\"https://example.com/product-main.jpg\", \"https://example.com/product-alt.jpg\", \"https://example.com/variant-indigo-s.jpg\", \"https://example.com/variant-indigo-m.jpg\", \"http://localhost:5000/uploads/products/hero-3-1778836716955-505961578_optimized.webp\", \"http://localhost:5000/uploads/products/2--1--1778836729243-42815697_optimized.webp\"]','http://localhost:5000/uploads/products/2--1--1778836729243-42815697_optimized.webp','http://localhost:5000/uploads/products/hero-3-1778836716955-505961578_optimized.webp',20,0.15,15,10,1,'2026-05-15 08:30:28.803','2026-05-15 09:30:35.171',1,'f2ef7474-d792-46a1-93e5-1c0b9d0457d4',1799,850,'{\"set\": [\"cotton\", \"indigo\", \"organic\"]}'),('91ed5582-9c57-4dc2-bc5c-0ac3cb5e2589','Floral Sundress (Girls)','','floral-sundress-girls','',100,0,NULL,'[\"http://localhost:5000/uploads/products/image-1778840391549-827395780_optimized.webp\", \"http://localhost:5000/uploads/products/image-1778840391775-753581681_optimized.webp\"]','http://localhost:5000/uploads/products/image-1778840391549-827395780_optimized.webp','http://localhost:5000/uploads/products/image-1778840391775-753581681_optimized.webp',8,NULL,NULL,NULL,NULL,'2026-05-15 10:19:51.859','2026-05-15 11:02:58.474',1,NULL,NULL,NULL,NULL),('92a7ec39-57ba-4bab-b955-4d6297affe9e','Product test','Handcrafted cotton set','indigo-edit','Soft cotton outfit',1599,1,200,'[\"https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1776495946953.webp\", \"https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1776495948232.webp\", \"https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1776501131228.webp\", \"https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1776501130346.webp\"]','https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103227874.webp','https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103229171.webp',0,NULL,NULL,NULL,NULL,'2026-05-14 07:07:43.176','2026-05-14 07:07:43.176',1,NULL,NULL,NULL,NULL),('c635c510-82d0-48f6-90bd-9ab239e86460','dummy ','','dummy','',90,1,10,'[\"http://localhost:5000/uploads/products/image-14-1778843067210-737610542_optimized.webp\"]','http://localhost:5000/uploads/products/image-14-1778843067210-737610542_optimized.webp',NULL,19,NULL,NULL,NULL,NULL,'2026-05-15 11:04:27.430','2026-05-15 11:16:23.559',1,NULL,500,60,'[]'),('dfd5f30f-039b-4cf7-96ea-7f0917605639','Mini Polo Tee (Boys)','','mini-polo-tee-boys','',830,1,170,'[\"http://localhost:5000/uploads/products/image-1778840328742-288721667_optimized.webp\", \"http://localhost:5000/uploads/products/image-1778840328815-254189548_optimized.webp\"]','http://localhost:5000/uploads/products/image-1778840328742-288721667_optimized.webp','http://localhost:5000/uploads/products/image-1778840328815-254189548_optimized.webp',1,NULL,NULL,NULL,NULL,'2026-05-15 10:18:48.879','2026-05-15 10:18:48.879',1,NULL,NULL,NULL,NULL),('eeea7f68-2f6f-427d-a1e1-3556f0bb9dd5','testing','','testing-1','',90,1,10,'[\"http://localhost:5000/uploads/products/desktop-home-banner-800-x-1494-px-mobile-4-1778762705669-426388177_optimized.webp\"]','http://localhost:5000/uploads/products/desktop-home-banner-800-x-1494-px-mobile-4-1778762705669-426388177_optimized.webp',NULL,0,NULL,NULL,NULL,NULL,'2026-05-14 12:45:05.903','2026-05-14 12:45:05.903',1,NULL,NULL,NULL,NULL),('f06bf710-1b81-477d-8336-bdf543142cdc','testing test','subtitle','testing-4','',90,1,10,'[\"http://localhost:5000/uploads/products/2--1--1778763057364-661325262_optimized.webp\"]','http://localhost:5000/uploads/products/2--1--1778763057364-661325262_optimized.webp',NULL,0,NULL,NULL,NULL,NULL,'2026-05-14 12:50:57.735','2026-05-14 12:50:57.735',1,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `product` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `productvariant`
--

DROP TABLE IF EXISTS `productvariant`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `productvariant` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `title` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `price` double DEFAULT NULL,
  `stock` int NOT NULL DEFAULT '0',
  `reservedStock` int NOT NULL DEFAULT '0',
  `images` json NOT NULL,
  `thumbnailUrl` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `hoverThumbnailUrl` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `productId` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` datetime(3) NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `barcode` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `breadth` double DEFAULT NULL,
  `color` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `compareAtPrice` double DEFAULT NULL,
  `costPrice` double DEFAULT NULL,
  `height` double DEFAULT NULL,
  `length` double DEFAULT NULL,
  `size` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sku` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `weight` double DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `ProductVariant_productId_idx` (`productId`),
  KEY `ProductVariant_createdAt_idx` (`createdAt`),
  KEY `ProductVariant_sku_idx` (`sku`),
  CONSTRAINT `ProductVariant_productId_fkey` FOREIGN KEY (`productId`) REFERENCES `product` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `productvariant`
--

LOCK TABLES `productvariant` WRITE;
/*!40000 ALTER TABLE `productvariant` DISABLE KEYS */;
INSERT INTO `productvariant` VALUES ('063f1561-4a98-4b87-9d10-5d2cf4c36ad1','Color: blue, Size: 3 - 4 Y',NULL,12,0,'[\"http://localhost:5000/uploads/products/image-1778840087958-850941957_optimized.webp\"]',NULL,NULL,'3e146278-bb34-453b-80c4-f9f726cf12e2','2026-05-15 10:16:41.226','2026-05-23 11:18:41.456',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('1be3ca9a-bb0e-4c90-a345-d85a0b41857d','Color: blue, Size: 2 - 3 Y',NULL,12,0,'[\"http://localhost:5000/uploads/products/image-1778840087958-850941957_optimized.webp\"]',NULL,NULL,'3e146278-bb34-453b-80c4-f9f726cf12e2','2026-05-15 10:16:41.226','2026-05-15 10:16:41.226',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('33636627-ff4d-4393-bec0-3440a98f5a48','Color: blue, Size: 4 - 5 Y',NULL,14,0,'[\"http://localhost:5000/uploads/products/image-1778840087958-850941957_optimized.webp\"]',NULL,NULL,'3e146278-bb34-453b-80c4-f9f726cf12e2','2026-05-15 10:16:41.226','2026-05-15 10:16:41.226',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('399e00d0-0776-4b2e-96ea-efc394e30a51','Color: blue, Size: L',NULL,3,0,'[\"http://localhost:5000/uploads/products/desktop-home-banner-800-x-1494-px-mobile-4-1778762705669-426388177_optimized.webp\"]',NULL,NULL,'eeea7f68-2f6f-427d-a1e1-3556f0bb9dd5','2026-05-14 12:45:05.903','2026-05-14 12:45:05.903',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('488f1526-13c5-42e7-b0f2-8862f0c73013','Color: yellow, Size: L',1599,0,0,'[\"https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1776501131228.webp\", \"https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1776501130346.webp\"]',NULL,NULL,'92a7ec39-57ba-4bab-b955-4d6297affe9e','2026-05-14 09:18:56.391','2026-05-14 09:18:56.391',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('5b35c5fb-39c8-4a28-9147-04c77529bfc6','Color: blue, Size: 5 - 6 Y',NULL,15,0,'[\"http://localhost:5000/uploads/products/image-1778840087958-850941957_optimized.webp\"]',NULL,NULL,'3e146278-bb34-453b-80c4-f9f726cf12e2','2026-05-15 10:16:41.226','2026-05-15 10:16:41.226',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('5e3a9b6a-2eb0-4e7f-abf0-81f3c23031bc','Color: Indigo, Size: Small',1599,12,0,'[\"http://localhost:5000/uploads/products/hero-3-1778836716955-505961578_optimized.webp\"]',NULL,NULL,'8ca801ed-9c94-469e-ab83-bcd2d96beec6','2026-05-15 09:29:09.030','2026-05-15 09:29:09.030',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('70d95054-df12-41b7-b3ff-823891643c56','Color: yellow, Size: XL',1599,4,0,'[\"https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1776501131228.webp\", \"https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1776501130346.webp\"]',NULL,NULL,'92a7ec39-57ba-4bab-b955-4d6297affe9e','2026-05-14 09:18:56.391','2026-05-14 09:18:56.391',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('70f8532c-6718-4cc3-9ba8-d95af6f6aa4a','Color: blue, Size: M',NULL,2,0,'[\"http://localhost:5000/uploads/products/desktop-home-banner-800-x-1494-px-mobile-4-1778762705669-426388177_optimized.webp\"]',NULL,NULL,'eeea7f68-2f6f-427d-a1e1-3556f0bb9dd5','2026-05-14 12:45:05.903','2026-05-14 12:45:05.903',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('727dfc4c-62a9-4bfe-beae-f3fac1e8bdcb','Color: green, Size: xxl',1599,3,0,'[\"https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1776495946953.webp\", \"https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1776495948232.webp\"]',NULL,NULL,'92a7ec39-57ba-4bab-b955-4d6297affe9e','2026-05-14 09:18:56.391','2026-05-14 09:18:56.391',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('78f833fe-a6ad-4759-b486-f7d2db6b8738','Color: yellow, Size: xxl',1599,2,0,'[\"https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1776501131228.webp\", \"https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1776501130346.webp\"]',NULL,NULL,'92a7ec39-57ba-4bab-b955-4d6297affe9e','2026-05-14 09:18:56.391','2026-05-14 09:18:56.391',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('81051656-f5fd-4f98-a4ab-70944008d392','Color: blue, Size: 18 - 24 M',NULL,11,0,'[\"http://localhost:5000/uploads/products/image-1778840087958-850941957_optimized.webp\"]',NULL,NULL,'3e146278-bb34-453b-80c4-f9f726cf12e2','2026-05-15 10:16:41.226','2026-05-15 10:16:41.226',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('823a8c26-e57e-44f6-ae42-9491f29c0dc5','Color: blue, Size: XL',NULL,4,0,'[\"http://localhost:5000/uploads/products/2--1--1778763057364-661325262_optimized.webp\"]',NULL,NULL,'f06bf710-1b81-477d-8336-bdf543142cdc','2026-05-14 12:50:57.735','2026-05-14 12:50:57.735',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('82de524a-7095-40b0-b09e-c0b99a072a4d','Color: green, Size: XL',1599,0,0,'[\"https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1776495946953.webp\", \"https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1776495948232.webp\"]',NULL,NULL,'92a7ec39-57ba-4bab-b955-4d6297affe9e','2026-05-14 09:18:56.391','2026-05-14 09:18:56.391',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('8936e5f4-0682-416b-863f-127bcfddcb31','Color: blue, Size: M',NULL,1,0,'[\"http://localhost:5000/uploads/products/2--1--1778763057364-661325262_optimized.webp\"]',NULL,NULL,'f06bf710-1b81-477d-8336-bdf543142cdc','2026-05-14 12:50:57.735','2026-05-14 12:50:57.735',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('8fb2bfe0-491c-4fbd-88bd-0dcf1c2cd128','Color: green, Size: L',1599,2,0,'[\"https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1776495946953.webp\", \"https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1776495948232.webp\"]',NULL,NULL,'92a7ec39-57ba-4bab-b955-4d6297affe9e','2026-05-14 09:18:56.391','2026-05-14 09:18:56.391',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('95646989-53c8-47c4-b413-ba88ce17b4b2','Color: blue, Size: 12 - 18 M',NULL,10,0,'[\"http://localhost:5000/uploads/products/image-1778840087958-850941957_optimized.webp\"]',NULL,NULL,'3e146278-bb34-453b-80c4-f9f726cf12e2','2026-05-15 10:16:41.226','2026-05-15 10:16:41.226',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('c058effd-9ef9-42a6-aab1-970c191a8c07','Color: blue, Size: L',NULL,3,0,'[\"http://localhost:5000/uploads/products/2--1--1778763057364-661325262_optimized.webp\"]',NULL,NULL,'f06bf710-1b81-477d-8336-bdf543142cdc','2026-05-14 12:50:57.735','2026-05-14 12:50:57.735',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('cd912c31-3aa1-4b08-9c87-5a413ea22937','Color: yellow, Size: M',1599,0,0,'[\"https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1776501131228.webp\", \"https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1776501130346.webp\"]',NULL,NULL,'92a7ec39-57ba-4bab-b955-4d6297affe9e','2026-05-14 09:18:56.391','2026-05-14 09:18:56.391',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('d3d75339-2328-4d49-bab1-c03a35b93e52','Color: blue, Size: 2XL',NULL,0,0,'[\"http://localhost:5000/uploads/products/desktop-home-banner-800-x-1494-px-mobile-4-1778762705669-426388177_optimized.webp\"]',NULL,NULL,'eeea7f68-2f6f-427d-a1e1-3556f0bb9dd5','2026-05-14 12:45:05.903','2026-05-14 12:45:05.903',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('de5d2625-ed0a-46e9-852b-cd9efdff8563','Color: blue, Size: XL',NULL,4,0,'[\"http://localhost:5000/uploads/products/desktop-home-banner-800-x-1494-px-mobile-4-1778762705669-426388177_optimized.webp\"]',NULL,NULL,'eeea7f68-2f6f-427d-a1e1-3556f0bb9dd5','2026-05-14 12:45:05.903','2026-05-14 12:45:05.903',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('e12fe74d-fdd9-4332-9562-1a5fca6c9932','Color: Indigo, Size: Medium',1599,8,0,'[\"http://localhost:5000/uploads/products/hero-3-1778836716955-505961578_optimized.webp\"]',NULL,NULL,'8ca801ed-9c94-469e-ab83-bcd2d96beec6','2026-05-15 09:29:09.030','2026-05-15 09:29:09.030',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('e43db38b-8a25-4658-9572-1b25b2cabfad','Color: blue, Size: 2XL',NULL,0,0,'[\"http://localhost:5000/uploads/products/2--1--1778763057364-661325262_optimized.webp\"]',NULL,NULL,'f06bf710-1b81-477d-8336-bdf543142cdc','2026-05-14 12:50:57.735','2026-05-14 12:50:57.735',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('ff64c33e-caf6-42a2-a97a-0cb1cc2437f7','Color: green, Size: M',1599,1,0,'[\"https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1776495946953.webp\", \"https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1776495948232.webp\"]',NULL,NULL,'92a7ec39-57ba-4bab-b955-4d6297affe9e','2026-05-14 09:18:56.391','2026-05-14 09:18:56.391',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `productvariant` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `profile`
--

DROP TABLE IF EXISTS `profile`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `profile` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `role` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'user',
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` datetime(3) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `Profile_email_key` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `profile`
--

LOCK TABLES `profile` WRITE;
/*!40000 ALTER TABLE `profile` DISABLE KEYS */;
/*!40000 ALTER TABLE `profile` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `returnrequest`
--

DROP TABLE IF EXISTS `returnrequest`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `returnrequest` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `orderId` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `reason` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `type` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'RETURN',
  `preferredVariantTitle` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `returnDate` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `status` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'PENDING',
  `pickupStatus` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'REQUESTED',
  `inspectionStatus` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'PENDING',
  `adminResponse` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `refundAmount` double DEFAULT NULL,
  `refundStatus` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'PENDING',
  `refundCompletedAt` datetime(3) DEFAULT NULL,
  `returnShipmentId` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` datetime(3) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `ReturnRequest_orderId_idx` (`orderId`),
  KEY `ReturnRequest_status_idx` (`status`),
  KEY `ReturnRequest_refundStatus_idx` (`refundStatus`),
  CONSTRAINT `ReturnRequest_orderId_fkey` FOREIGN KEY (`orderId`) REFERENCES `order` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `returnrequest`
--

LOCK TABLES `returnrequest` WRITE;
/*!40000 ALTER TABLE `returnrequest` DISABLE KEYS */;
/*!40000 ALTER TABLE `returnrequest` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `review`
--

DROP TABLE IF EXISTS `review`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `review` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `rating` int NOT NULL,
  `comment` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `userName` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `userEmail` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `userPhone` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `images` json NOT NULL,
  `productId` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  KEY `Review_productId_idx` (`productId`),
  KEY `Review_rating_idx` (`rating`),
  KEY `Review_createdAt_idx` (`createdAt`),
  CONSTRAINT `Review_productId_fkey` FOREIGN KEY (`productId`) REFERENCES `product` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `review`
--

LOCK TABLES `review` WRITE;
/*!40000 ALTER TABLE `review` DISABLE KEYS */;
/*!40000 ALTER TABLE `review` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sale`
--

DROP TABLE IF EXISTS `sale`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sale` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `productId` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `quantity` int NOT NULL,
  `price` double NOT NULL,
  `source` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Website',
  `customerName` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `customerEmail` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `customerPhone` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `paymentMode` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `paymentId` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `notes` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `variantTitle` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `orderId` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `Sale_orderId_fkey` (`orderId`),
  KEY `Sale_productId_fkey` (`productId`),
  CONSTRAINT `Sale_orderId_fkey` FOREIGN KEY (`orderId`) REFERENCES `order` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `Sale_productId_fkey` FOREIGN KEY (`productId`) REFERENCES `product` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sale`
--

LOCK TABLES `sale` WRITE;
/*!40000 ALTER TABLE `sale` DISABLE KEYS */;
INSERT INTO `sale` VALUES ('a9720301-ff02-4a95-ac5b-e7fb4427d1d0','3e146278-bb34-453b-80c4-f9f726cf12e2',1,79,'Website','customer cust','customer@gmail.com','12345679','Razorpay','pay_Ssn1Mi6QmfaYg6',NULL,'Color: blue, Size: 3 - 4 Y','2026-05-23 11:18:41.464','0afaa3e0-1579-446f-8c34-e6f43bf9c07e'),('d8caa7f6-a555-4e70-abf6-7f2d400b66d9','69e6ed03-e19b-43ea-afe1-3aa6f49be73a',1,88,'Website','customer yadav','customer@gmail.com','12345679','Razorpay','pay_Ssmup0QJ4Ad8J4',NULL,NULL,'2026-05-23 11:12:27.640','c7615f19-a689-48f0-a89a-51528bacc1c9');
/*!40000 ALTER TABLE `sale` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `shipment`
--

DROP TABLE IF EXISTS `shipment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shipment` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `orderId` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `awb` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `shipmentId` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `courier` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'SHIPMENT_CREATED',
  `labelUrl` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` datetime(3) NOT NULL,
  `lastTrackedAt` datetime(3) DEFAULT NULL,
  `pickupId` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `Shipment_orderId_key` (`orderId`),
  UNIQUE KEY `Shipment_awb_key` (`awb`),
  UNIQUE KEY `Shipment_shipmentId_key` (`shipmentId`),
  KEY `Shipment_orderId_idx` (`orderId`),
  KEY `Shipment_awb_idx` (`awb`),
  KEY `Shipment_status_idx` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shipment`
--

LOCK TABLES `shipment` WRITE;
/*!40000 ALTER TABLE `shipment` DISABLE KEYS */;
/*!40000 ALTER TABLE `shipment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `shipmenttrackingevent`
--

DROP TABLE IF EXISTS `shipmenttrackingevent`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shipmenttrackingevent` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `provider` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'SHIPROCKET',
  `source` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'WEBHOOK',
  `orderId` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `awb` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `shipmentId` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `eventTime` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `raw` json DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  KEY `ShipmentTrackingEvent_orderId_idx` (`orderId`),
  KEY `ShipmentTrackingEvent_awb_idx` (`awb`),
  KEY `ShipmentTrackingEvent_shipmentId_idx` (`shipmentId`),
  KEY `ShipmentTrackingEvent_eventTime_idx` (`eventTime`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shipmenttrackingevent`
--

LOCK TABLES `shipmenttrackingevent` WRITE;
/*!40000 ALTER TABLE `shipmenttrackingevent` DISABLE KEYS */;
/*!40000 ALTER TABLE `shipmenttrackingevent` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `webhooklog`
--

DROP TABLE IF EXISTS `webhooklog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `webhooklog` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `provider` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'SHIPROCKET',
  `eventType` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'STATUS_UPDATE',
  `orderId` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `awb` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `shipmentId` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `headers` json DEFAULT NULL,
  `payload` json NOT NULL,
  `receivedAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `processed` tinyint(1) NOT NULL DEFAULT '0',
  `processedAt` datetime(3) DEFAULT NULL,
  `processingError` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `attempts` int NOT NULL DEFAULT '0',
  `lastAttemptAt` datetime(3) DEFAULT NULL,
  `nextRetryAt` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `WebhookLog_provider_idx` (`provider`),
  KEY `WebhookLog_orderId_idx` (`orderId`),
  KEY `WebhookLog_awb_idx` (`awb`),
  KEY `WebhookLog_processed_idx` (`processed`),
  KEY `WebhookLog_receivedAt_idx` (`receivedAt`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `webhooklog`
--

LOCK TABLES `webhooklog` WRITE;
/*!40000 ALTER TABLE `webhooklog` DISABLE KEYS */;
/*!40000 ALTER TABLE `webhooklog` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'little_thread'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-05-26 12:52:44
