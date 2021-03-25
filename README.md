# SQL-Server-BasicConfiguration

SQL-Server-Basics are supplied as-is. I am not responsible for any harm. It's intention is to help you, to easily setup your SQL Server.

## Instance Configuration

[**100-DefaultConfiguration.sql**](100-DefaultConfiguration.sql)

Purpose: set baseline configration with common best practices


## Database Maintenance
Maintenance Solution is based on [Ola Hallengren's SQL Server Backup, Integrity Check, and Index and Statistics Maintenance](https://ola.hallengren.com/).
By default all the maintenance objects (Log-Table, Stored procedures, etc.) are stored in master-database. But I prefer to have it on a dedicated database. Let's call it "**MaintenanceDB**". Therefore you need to adjust line 22 in **MaintenanceSolution.sql** `USE [master] -- Specify the database in which the objects will be created.` to `USE [MaintenanceDB] -- Specify the database in which the objects will be created.`
Execute scripts in the following order:

1. [200-CreateMaintenanceDB.sql](200-CreateMaintenanceDB.sql)
2. MaintenanceSolution.sql
3. [220-CreateMaintenaceJobs.sql](220-CreateMaintenaceJobs.sql)

## Database Mailing

1. [300-SetupDatabaseMail.sql](300-SetupDatabaseMail.sql)
2. [310-SetupSeverityAlerts.sql](310-SetupSeverityAlerts.sql)
3. [320-SetupMaintenanceJobsAlerts.sql](320-SetupMaintenanceJobsAlerts.sql)
