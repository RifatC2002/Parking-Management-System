CREATE DATABASE parking_system;

USE parking_system;

CREATE TABLE `User` (
  `UserID` int NOT NULL,
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
);

-- ALTER TABLE user AUTO_INCREMENT = 1357;