-- MySQL dump 10.13  Distrib 8.1.0, for macos13.3 (arm64)
--
-- Host: localhost    Database: parking_system
-- ------------------------------------------------------
-- Server version	8.1.0

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
-- Table structure for table `Booking`
--

DROP TABLE IF EXISTS `Booking`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Booking` (
  `BookingID` int NOT NULL AUTO_INCREMENT,
  `UserID` int DEFAULT NULL,
  `VehicleType` enum('Car','Bike') NOT NULL,
  `SlotID` int DEFAULT NULL,
  `Status` enum('Pending','Confirmed','Cancelled','Completed') NOT NULL,
  `BookingDate` date DEFAULT NULL,
  `TimeFrom` time DEFAULT NULL,
  `TimeTo` time DEFAULT NULL,
  `OwnerName` varchar(255) DEFAULT NULL,
  `LicensePlate` varchar(20) DEFAULT NULL,
  `Color` varchar(50) DEFAULT NULL,
  `Brand` varchar(50) DEFAULT NULL,
  `Model` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`BookingID`),
  KEY `UserID` (`UserID`),
  CONSTRAINT `booking_ibfk_1` FOREIGN KEY (`UserID`) REFERENCES `User` (`UserID`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Booking`
--

LOCK TABLES `Booking` WRITE;
/*!40000 ALTER TABLE `Booking` DISABLE KEYS */;
INSERT INTO `Booking` VALUES (8,18,'Car',1,'Completed','2023-12-09','05:59:00','08:04:00','Ridwanul Islam','1213','Red','Toyota','TR490');
/*!40000 ALTER TABLE `Booking` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `checkout`
--

DROP TABLE IF EXISTS `checkout`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `checkout` (
  `CheckoutID` int NOT NULL AUTO_INCREMENT,
  `BookingID` int DEFAULT NULL,
  `DamageDone` enum('Yes','No') NOT NULL,
  `TypeOfDamage` varchar(255) DEFAULT NULL,
  `CompensationAmount` decimal(10,2) DEFAULT NULL,
  `extraTime` enum('Yes','No') DEFAULT NULL,
  `FinalPayableAmount` decimal(10,2) DEFAULT NULL,
  `CheckoutDate` datetime DEFAULT NULL,
  PRIMARY KEY (`CheckoutID`),
  KEY `BookingID` (`BookingID`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `checkout`
--

LOCK TABLES `checkout` WRITE;
/*!40000 ALTER TABLE `checkout` DISABLE KEYS */;
INSERT INTO `checkout` VALUES (1,7,'No','None',12.00,'No',15.00,'2023-12-09 00:00:00'),(2,7,'No','None',12.00,'No',15.00,'2023-12-09 00:00:00'),(3,7,'No','None',12.00,'No',15.00,'2023-12-09 00:00:00'),(4,7,'No','None',12.00,'No',15.00,'2023-12-09 00:00:00'),(5,7,'No','None',12.00,'No',15.00,'2023-12-09 00:00:00'),(6,7,'No','None',12.00,'No',15.00,'2023-12-09 00:00:00'),(7,8,'Yes','Broken Glass',50.00,'Yes',150.00,'2023-12-08 00:00:00'),(8,8,'Yes','Broken Glass',50.00,'Yes',150.00,'2023-12-08 00:00:00');
/*!40000 ALTER TABLE `checkout` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Earning`
--

DROP TABLE IF EXISTS `Earning`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Earning` (
  `EarningID` int NOT NULL AUTO_INCREMENT,
  `CheckoutID` int DEFAULT NULL,
  `Amount` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`EarningID`),
  KEY `CheckoutID` (`CheckoutID`),
  CONSTRAINT `earning_ibfk_1` FOREIGN KEY (`CheckoutID`) REFERENCES `Checkout` (`CheckoutID`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Earning`
--

LOCK TABLES `Earning` WRITE;
/*!40000 ALTER TABLE `Earning` DISABLE KEYS */;
INSERT INTO `Earning` VALUES (8,8,150.00);
/*!40000 ALTER TABLE `Earning` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Slots`
--

DROP TABLE IF EXISTS `Slots`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Slots` (
  `SlotID` int NOT NULL AUTO_INCREMENT,
  `SlotNumber` int NOT NULL,
  `Status` enum('Available','Occupied') NOT NULL,
  PRIMARY KEY (`SlotID`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Slots`
--

LOCK TABLES `Slots` WRITE;
/*!40000 ALTER TABLE `Slots` DISABLE KEYS */;
INSERT INTO `Slots` VALUES (1,1,'Available'),(2,2,'Available'),(3,3,'Available');
/*!40000 ALTER TABLE `Slots` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `User`
--

DROP TABLE IF EXISTS `User`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `User` (
  `UserID` int NOT NULL AUTO_INCREMENT,
  `FirstName` varchar(255) DEFAULT NULL,
  `LastName` varchar(255) DEFAULT NULL,
  `ContactNo` varchar(15) NOT NULL,
  `Password` varchar(255) NOT NULL,
  `NationalID` varchar(20) NOT NULL,
  `EmergencyContact` varchar(15) NOT NULL,
  `AddressHouse` varchar(255) NOT NULL,
  `AddressStreet` varchar(255) NOT NULL,
  `AddressArea` varchar(255) NOT NULL,
  `AddressCity` varchar(255) NOT NULL,
  `UserType` enum('Customer','Employee') NOT NULL,
  PRIMARY KEY (`UserID`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `User`
--

LOCK TABLES `User` WRITE;
/*!40000 ALTER TABLE `User` DISABLE KEYS */;
INSERT INTO `User` VALUES (17,'Rifat','Chowdhury','0193743943','1234567','1234343432','0193743944','1','12','Mohammadpur','Dhaka','Employee'),(18,'Ridwanul','Islam','0193743342','1234567','4334243342','0193433427','12','20','Mohammadpur','Dhaka','Customer');
/*!40000 ALTER TABLE `User` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-12-08  4:27:49
