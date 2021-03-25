/*
############################################################
## 200-CreateMaintenanceDB.sql
##
## Purpose: create new database for database maintenance
##
############################################################
*/

USE [master];
GO

CREATE DATABASE [MaintenanceDB];
GO

ALTER DATABASE [MaintenanceDB] SET AUTO_SHRINK OFF;

ALTER DATABASE [MaintenanceDB]
SET AUTO_CREATE_STATISTICS ON
	(INCREMENTAL = OFF);

ALTER DATABASE [MaintenanceDB] SET AUTO_UPDATE_STATISTICS ON;

ALTER DATABASE [MaintenanceDB]
MODIFY FILE (
	NAME = N'data_0'
  , SIZE = 512MB
  , FILEGROWTH = 256MB
);

ALTER DATABASE [MaintenanceDB]
MODIFY FILE (
	NAME = N'log'
  , SIZE = 512MB
  , FILEGROWTH = 256MB
);
GO

ALTER AUTHORIZATION ON DATABASE::[MaintenanceDB] TO sa;
GO
