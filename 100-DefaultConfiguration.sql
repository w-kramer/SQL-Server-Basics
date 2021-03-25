/*
############################################################
## 100-DefaultConfiguration.sql
##
## Purpose: set baseline configration with common best practices
##
############################################################
*/

-- Value for index page fill factor
-- should be set to 80 for SharePoint
-- should be set to 0 as common best pracice
-- ask your application supplier for applications recommendation
-- see https://docs.microsoft.com/en-us/sql/relational-databases/indexes/specify-fill-factor-for-an-index
DECLARE @fillFactor INT = 0;

-- see recommendation on https://docs.microsoft.com/en-us/sql/database-engine/configure-windows/configure-the-max-degree-of-parallelism-server-configuration-option#Recommendations
-- in most cases 8 or # of cpu cores per NUMA is good
-- SharePoint requires MaxDOP set to 1
DECLARE @maxDOP INT = 0;


-- ****************************************************************************
--  Configure SQL Server Agent
-- ****************************************************************************
USE [msdb];
GO
EXEC .dbo.sp_set_sqlagent_properties @jobhistory_max_rows = 10000
									   , @jobhistory_max_rows_per_job = 1000
									   , @email_save_in_sent_folder = 1
									   , @cpu_poller_enabled = 1
									   , @use_databasemail = 1;
GO

-- ****************************************************************************
--  Show all configuration options
-- ****************************************************************************
USE [master];
GO

EXEC sys.sp_configure 'show advanced options', '1';
RECONFIGURE;

-- ****************************************************************************
--  Configuration page 'Memory', reserved Memory for OS is 2GB + 12.5% from System memory
-- ****************************************************************************
-- run script to calculate suggested max memory
DECLARE @var_physMemory FLOAT
	  , @var_maxMemory	FLOAT;
SELECT	@var_physMemory = physical_memory_kb / 1024
  FROM	sys.dm_os_sys_info;
SET @var_maxMemory = ROUND(@var_physMemory - 2048 - (@var_physMemory * 0.125), 0);


DECLARE @var_MinMemory AS INT = ROUND(@var_maxMemory / 4, 0);

EXEC sys.sp_configure 'min server memory (MB)', @var_MinMemory;
EXEC sys.sp_configure 'max server memory (MB)', @var_maxMemory;
RECONFIGURE;

-- ****************************************************************************
-- Configuration page 'Database Settings'
-- ****************************************************************************
EXEC sys.sp_configure 'fill factor (%)', @fillFactor
EXEC sys.sp_configure 'backup compression default', '1';
EXEC sys.sp_configure 'contained database authentication', '1';
RECONFIGURE;

-- ****************************************************************************
-- Configuration page 'Advanced'
-- ****************************************************************************
EXEC sys.sp_configure 'max degree of parallelism', '0';
-- [ChangeMe] -- 0 (max 8) Best Practice and 1 for SharePoint
EXEC sys.sp_configure 'cost threshold for parallelism', N'50';
EXEC sys.sp_configure 'remote admin connections', 1;
EXEC sys.sp_configure N'optimize for ad hoc workloads', N'1'		-- 0 = off, 1 = on
RECONFIGURE;

-- ****************************************************************************
-- Disable Show all configuration options
-- ****************************************************************************
EXEC sys.sp_configure 'show advanced options', '0';
RECONFIGURE;

-- ****************************************************************************
-- Set file growth for system databases
-- ****************************************************************************
USE [master]
GO
ALTER DATABASE [master] MODIFY FILE ( NAME = N'master',  FILEGROWTH = 128MB )
GO
ALTER DATABASE [master] MODIFY FILE ( NAME = N'mastlog', FILEGROWTH = 128MB )
GO
ALTER DATABASE [model] MODIFY FILE ( NAME = N'modeldev', FILEGROWTH = 256MB )
GO
ALTER DATABASE [model] MODIFY FILE ( NAME = N'modellog', FILEGROWTH = 256MB )
GO
ALTER DATABASE [msdb] MODIFY FILE ( NAME = N'MSDBData',  FILEGROWTH = 256MB )
GO
ALTER DATABASE [msdb] MODIFY FILE ( NAME = N'MSDBLog',   FILEGROWTH = 256MB )
GO


-- ****************************************************************************
-- Set system database initial size
-- ****************************************************************************

ALTER DATABASE [master] MODIFY FILE ( NAME = N'master', SIZE = 128MB  )
GO
ALTER DATABASE [master] MODIFY FILE ( NAME = N'mastlog', SIZE = 128MB )
GO
ALTER DATABASE [model] MODIFY FILE ( NAME = N'modeldev', SIZE = 256MB )
GO
ALTER DATABASE [model] MODIFY FILE ( NAME = N'modellog', SIZE = 256MB )
GO
ALTER DATABASE [msdb] MODIFY FILE ( NAME = N'MSDBData', SIZE = 256MB  )
GO
ALTER DATABASE [msdb] MODIFY FILE ( NAME = N'MSDBLog', SIZE = 256MB )
GO
