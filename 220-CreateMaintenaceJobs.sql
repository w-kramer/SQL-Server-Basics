/*
############################################################
## 220-CreateMaintenaceJobs.sql
##
## Purpose: create maintenace jobs with schedules
##
############################################################
*/


USE msdb;
GO
DECLARE @jobname sysname;
DECLARE @overwrite INT;

SET @overwrite = 1; -- overwrite existing jobs - 0 .. no, 1 .. yes


IF NOT EXISTS (SELECT	name
				 FROM	msdb.dbo.syscategories
				WHERE	name		   = N'Database Maintenance'
				  AND	category_class = 1)
	BEGIN
		EXEC msdb.dbo.sp_add_category @class = N'JOB'
									, @type = N'LOCAL'
									, @name = N'Database Maintenance';
	END;

SET @jobname = N'SYS-Backup-FULL';
IF			EXISTS (SELECT		* FROM	msdb.dbo.sysjobs WHERE	name = @jobname)
			   AND	 @overwrite = 1
	BEGIN
		-- delete Job if exists
		EXEC msdb.dbo.sp_delete_job @job_name = @jobname
								  , @delete_unused_schedule = 1;
		PRINT 'existing job deleted - ' + @jobname;
	END;

IF NOT EXISTS (SELECT	* FROM	msdb.dbo.sysjobs WHERE	name = @jobname)
	BEGIN
		-- create Job
		EXEC msdb.dbo.sp_add_job @job_name = @jobname
							   , @enabled = 1
							   , @description = N'Source: http://ola.hallengren.com'
							   , @category_name = N'Database Maintenance'
							   , @owner_login_name = N'sa';
		EXEC msdb.dbo.sp_add_jobstep @job_name = @jobname
								   , @step_name = N'DatabaseBackup - FULL'
								   , @subsystem = N'CmdExec'
								   , @command = N'sqlcmd -E -S $(ESCAPE_SQUOTE(SRVR)) -d MaintenanceDB -Q "EXECUTE [dbo].[DatabaseBackup] @Databases = ''ALL_DATABASES'', @Directory = NULL, @BackupType = ''FULL'', @Verify = ''Y'', @CleanupTime = 71, @CheckSum = ''Y'', @LogToTable = ''Y''" -b';
		EXEC msdb.dbo.sp_add_jobschedule @job_name = @jobname
									   , @name = @jobname
									   , @enabled = 1
									   , @freq_type = 4
									   , @freq_interval = 1
									   , @freq_subday_type = 1
									   , @freq_subday_interval = 0
									   , @freq_relative_interval = 0
									   , @freq_recurrence_factor = 0
									   , @active_start_time = 10000
									   , @active_end_time = 5959;
		EXEC msdb.dbo.sp_add_jobserver @job_name = @jobname;
		PRINT 'job created - ' + @jobname;
	END;

SET @jobname = N'SYS-Backup-DIFF';
IF			EXISTS (SELECT		* FROM	msdb.dbo.sysjobs WHERE	name = @jobname)
			   AND	 @overwrite = 1
	BEGIN
		-- delete Job if exists
		EXEC msdb.dbo.sp_delete_job @job_name = @jobname
								  , @delete_unused_schedule = 1;
		PRINT 'existing job deleted - ' + @jobname;
	END;

IF NOT EXISTS (SELECT	* FROM	msdb.dbo.sysjobs WHERE	name = @jobname)
	BEGIN
		-- create Job
		EXEC msdb.dbo.sp_add_job @job_name = @jobname
							   , @enabled = 0
							   , @description = N'Source: http://ola.hallengren.com'
							   , @category_name = N'Database Maintenance'
							   , @owner_login_name = N'sa';
		EXEC msdb.dbo.sp_add_jobstep @job_name = @jobname
								   , @step_name = N'DatabaseBackup - DIFF'
								   , @subsystem = N'CmdExec'
								   , @command = N'sqlcmd -E -S $(ESCAPE_SQUOTE(SRVR)) -d MaintenanceDB -Q "EXECUTE [dbo].[DatabaseBackup] @Databases = ''ALL_DATABASES'', @Directory = NULL, @BackupType = ''DIFF'', @Verify = ''Y'', @CleanupTime = 71, @CheckSum = ''Y'', @LogToTable = ''Y''" -b';
		EXEC msdb.dbo.sp_add_jobschedule @job_name = @jobname
									   , @name = @jobname
									   , @enabled = 1
									   , @freq_type = 4
									   , @freq_interval = 1
									   , @freq_subday_type = 1
									   , @freq_subday_interval = 0
									   , @freq_relative_interval = 0
									   , @freq_recurrence_factor = 0
									   , @active_start_time = 10000
									   , @active_end_time = 5959;
		EXEC msdb.dbo.sp_add_jobserver @job_name = @jobname;
		PRINT 'job created - ' + @jobname;
	END;

SET @jobname = N'SYS-Backup-LOG';
IF			EXISTS (SELECT		* FROM	msdb.dbo.sysjobs WHERE	name = @jobname)
			   AND	 @overwrite = 1
	BEGIN
		-- delete Job if exists
		EXEC msdb.dbo.sp_delete_job @job_name = @jobname
								  , @delete_unused_schedule = 1;
		PRINT 'existing job deleted - ' + @jobname;
	END;

IF NOT EXISTS (SELECT	* FROM	msdb.dbo.sysjobs WHERE	name = @jobname)
	BEGIN
		-- create Job
		EXEC msdb.dbo.sp_add_job @job_name = @jobname
							   , @enabled = 1
							   , @description = N'Source: http://ola.hallengren.com'
							   , @category_name = N'Database Maintenance'
							   , @owner_login_name = N'sa';
		EXEC msdb.dbo.sp_add_jobstep @job_name = @jobname
								   , @step_name = N'DatabaseBackup - LOG'
								   , @subsystem = N'CmdExec'
								   , @command = N'sqlcmd -E -S $(ESCAPE_SQUOTE(SRVR)) -d MaintenanceDB -Q "EXECUTE [dbo].[DatabaseBackup] @Databases = ''ALL_DATABASES'', @Directory = NULL, @BackupType = ''LOG'', @Verify = ''Y'', @CleanupTime = 71, @CheckSum = ''Y'', @LogToTable = ''Y''" -b';
		EXEC msdb.dbo.sp_add_jobschedule @job_name = @jobname
									   , @name = @jobname
									   , @enabled = 1
									   , @freq_type = 4
									   , @freq_interval = 1
									   , @freq_subday_type = 8
									   , @freq_subday_interval = 1
									   , @freq_relative_interval = 0
									   , @freq_recurrence_factor = 0
									   , @active_start_time = 1500
									   , @active_end_time = 1459;
		EXEC msdb.dbo.sp_add_jobserver @job_name = @jobname;
		PRINT 'job created - ' + @jobname;
	END;


SET @jobname = N'SYS-IndexOptimize';
IF			EXISTS (SELECT		* FROM	msdb.dbo.sysjobs WHERE	name = @jobname)
			   AND	 @overwrite = 1
	BEGIN
		-- delete Job if exists
		EXEC msdb.dbo.sp_delete_job @job_name = @jobname
								  , @delete_unused_schedule = 1;
		PRINT 'existing job deleted - ' + @jobname;
	END;

IF NOT EXISTS (SELECT	* FROM	msdb.dbo.sysjobs WHERE	name = @jobname)
	BEGIN
		-- create Job
		EXEC msdb.dbo.sp_add_job @job_name = @jobname
							   , @enabled = 1
							   , @description = N'Source: http://ola.hallengren.com'
							   , @category_name = N'Database Maintenance'
							   , @owner_login_name = N'sa';
		EXEC msdb.dbo.sp_add_jobstep @job_name = @jobname
								   , @step_name = N'IndexOptimize - USER_DATABASES'
								   , @subsystem = N'CmdExec'
								   , @command = N'sqlcmd -E -S $(ESCAPE_SQUOTE(SRVR)) -d MaintenanceDB -Q "EXECUTE [dbo].[IndexOptimize] @Databases = ''USER_DATABASES'', @FragmentationMedium = ''INDEX_REORGANIZE,INDEX_REBUILD_ONLINE'', @FragmentationHigh = ''INDEX_REBUILD_ONLINE,INDEX_REBUILD_OFFLINE'', @FragmentationLevel1 = 10, @FragmentationLevel2 = 40, @PageCountLevel = 2000, @UpdateStatistics = ''ALL'', @OnlyModifiedStatistics = ''Y'' , @LogToTable = ''Y''" -b';
		EXEC msdb.dbo.sp_add_jobschedule @job_name = @jobname
									   , @name = @jobname
									   , @enabled = 1
									   , @freq_type = 4
									   , @freq_interval = 1
									   , @freq_subday_type = 1
									   , @freq_subday_interval = 0
									   , @freq_relative_interval = 0
									   , @freq_recurrence_factor = 0
									   , @active_start_time = 20000
									   , @active_end_time = 15959;
		EXEC msdb.dbo.sp_add_jobserver @job_name = @jobname;
		PRINT 'job created - ' + @jobname;
	END;


SET @jobname = N'SYS-IntegrityCheck';
IF			EXISTS (SELECT		* FROM	msdb.dbo.sysjobs WHERE	name = @jobname)
			   AND	 @overwrite = 1
	BEGIN
		-- delete Job if exists
		EXEC msdb.dbo.sp_delete_job @job_name = @jobname
								  , @delete_unused_schedule = 1;
		PRINT 'existing job deleted - ' + @jobname;
	END;

IF NOT EXISTS (SELECT	* FROM	msdb.dbo.sysjobs WHERE	name = @jobname)
	BEGIN
		-- create Job
		EXEC msdb.dbo.sp_add_job @job_name = @jobname
							   , @enabled = 1
							   , @description = N'Source: http://ola.hallengren.com'
							   , @category_name = N'Database Maintenance'
							   , @owner_login_name = N'sa';
		EXEC msdb.dbo.sp_add_jobstep @job_name = @jobname
								   , @step_name = N'IntegrityCheck - ALL_DATABASES'
								   , @subsystem = N'CmdExec'
								   , @command = N'sqlcmd -E -S $(ESCAPE_SQUOTE(SRVR)) -d MaintenanceDB -Q "EXECUTE [dbo].[DatabaseIntegrityCheck] @Databases = ''ALL_DATABASES'', @LogToTable = ''Y''" -b';
		EXEC msdb.dbo.sp_add_jobschedule @job_name = @jobname
									   , @name = @jobname
									   , @enabled = 1
									   , @freq_type = 8
									   , @freq_interval = 64
									   , @freq_subday_type = 1
									   , @freq_subday_interval = 0
									   , @freq_relative_interval = 0
									   , @freq_recurrence_factor = 1
									   , @active_start_time = 230000
									   , @active_end_time = 225959;
		EXEC msdb.dbo.sp_add_jobserver @job_name = @jobname;
		PRINT 'job created - ' + @jobname;
	END;


SET @jobname = N'SYS-HistoryCleanUp';
IF			EXISTS (SELECT		* FROM	msdb.dbo.sysjobs WHERE	name = @jobname)
			   AND	 @overwrite = 1
	BEGIN
		-- delete Job if exists
		EXEC msdb.dbo.sp_delete_job @job_name = @jobname
								  , @delete_unused_schedule = 1;
		PRINT 'existing job deleted - ' + @jobname;
	END;

IF NOT EXISTS (SELECT	* FROM	msdb.dbo.sysjobs WHERE	name = @jobname)
	BEGIN
		-- create Job
		EXEC msdb.dbo.sp_add_job @job_name = @jobname
							   , @enabled = 1
							   , @description = N'Source: http://ola.hallengren.com'
							   , @category_name = N'Database Maintenance'
							   , @owner_login_name = N'sa';
		EXEC msdb.dbo.sp_add_jobstep @job_name = @jobname
								   , @step_name = N'sp_delete_backuphistory'
								   , @subsystem = N'CmdExec'
								   , @command = N'sqlcmd -E -S $(ESCAPE_SQUOTE(SRVR)) -d msdb -Q "DECLARE @CleanupDate datetime SET @CleanupDate = DATEADD(dd,-30,GETDATE()) EXECUTE dbo.sp_delete_backuphistory @oldest_date = @CleanupDate" -b'
								   , @on_success_action = 3;
		EXEC msdb.dbo.sp_add_jobstep @job_name = @jobname
								   , @step_name = N'sp_purge_jobhistory'
								   , @subsystem = N'CmdExec'
								   , @command = N'sqlcmd -E -S $(ESCAPE_SQUOTE(SRVR)) -d msdb -Q "DECLARE @CleanupDate datetime SET @CleanupDate = DATEADD(dd,-30,GETDATE()) EXECUTE dbo.sp_purge_jobhistory @oldest_date = @CleanupDate" -b'
								   , @on_success_action = 3;
		EXEC msdb.dbo.sp_add_jobstep @job_name = @jobname
								   , @step_name = N'CommandLog_Cleanup'
								   , @subsystem = N'CmdExec'
								   , @command = N'sqlcmd -E -S $(ESCAPE_SQUOTE(SRVR)) -d MaintenanceDB -Q "DELETE FROM [dbo].[CommandLog] WHERE StartTime < DATEADD(dd,-30,GETDATE())" -b';
		EXEC msdb.dbo.sp_add_jobschedule @job_name = @jobname
									   , @name = @jobname
									   , @enabled = 1
									   , @freq_type = 16
									   , @freq_interval = 1
									   , @freq_subday_type = 1
									   , @freq_subday_interval = 0
									   , @freq_relative_interval = 0
									   , @freq_recurrence_factor = 1
									   , @active_start_time = 0
									   , @active_end_time = 235959;
		EXEC msdb.dbo.sp_add_jobserver @job_name = @jobname;
		PRINT 'job created - ' + @jobname;
	END;


