# SQL-Server-BasicConfiguration

SQL-Server-Basics are supplied as-is. I am not responsible for any harm. It's intention is to help you, to easily setup your SQL Server.

## Instance Configuration

[**100-DefaultConfiguration.sql**](100-DefaultConfiguration.sql)

Purpose: set baseline configration with common best practices


## Database Maintenance
Maintenance Solution is based on [Ola Hallengren's SQL Server Backup, Integrity Check, and Index and Statistics Maintenance](https://ola.hallengren.com/).
By default all the maintenance objects (Log-Table, Stored procedures, etc.) are stored in master-database. But I prefer to have it on a dedicated database. Let's call it "**MaintenanceDB**". Therefore you need to adjust line 22 in [**MaintenanceSolution.sql**](https://github.com/olahallengren/sql-server-maintenance-solution/blob/master/MaintenanceSolution.sql#L22) `USE [master] -- Specify the database in which the objects will be created.` to `USE [MaintenanceDB] -- Specify the database in which the objects will be created.`
Also we create our own jobs, so change line 26 in [**MaintenanceSolution.sql**](https://github.com/olahallengren/sql-server-maintenance-solution/blob/master/MaintenanceSolution.sql#L26) from Y to N.
Execute scripts in the following order:

1. [200-CreateMaintenanceDB.sql](200-CreateMaintenanceDB.sql)
2. [MaintenanceSolution.sql](https://github.com/olahallengren/sql-server-maintenance-solution/blob/master/MaintenanceSolution.sql)
3. [220-CreateMaintenaceJobs.sql](220-CreateMaintenaceJobs.sql)

## Database Mailing

1. [300-SetupDatabaseMail.sql](300-SetupDatabaseMail.sql)
2. [310-SetupSeverityAlerts.sql](310-SetupSeverityAlerts.sql)
3. [320-SetupMaintenanceJobsAlerts.sql](320-SetupMaintenanceJobsAlerts.sql)

# Post migration tasks
After restoring a database to your new server, you should perform some tasks. 

Trace flag 1117 is gone in current SQL Server versions. Now you set it up on database and file group level.

`ALTER DATABASE [dbname] MODIFY FILEGROUP [PRIMARY] AUTOGROW_ALL_FILES;`

Databases should have checksum as page verify setting.

`ALTER DATABASE [dbname] SET PAGE_VERIFY CHECKSUM;`

Set the recovery model of the database according to your needs. IMHO production databases should always set to FULL recovery model.

```
ALTER DATABASE [dbname] SET RECOVERY FULL;
ALTER DATABASE [dbname] SET RECOVERY SIMPLE;
```

I like to have the Query Store feature enabled.

```
ALTER DATABASE [dbname] SET QUERY_STORE = ON;
ALTER DATABASE [dbname] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, MAX_STORAGE_SIZE_MB = 2048);
```
