/*
############################################################
## 310-SetupSeverityAlerts.sql
##
## Purpose: set mail alerting for agent jobs
##
############################################################
*/


	DECLARE @operator_name sysname = N'Database Administrators'		-- [ChangeMe]

	-- DECLARE VARIABLES
	DECLARE @Job_Filter varchar(20)
	DECLARE @Job_ID uniqueidentifier

	-- DECLARE A CURSOR AND GET ALL JOBS
	DECLARE Job_ID_Cursor CURSOR FOR
		SELECT [job_id] FROM [msdb].[dbo].[sysjobs] Where name not like '%syspolicy_purge_history%'

	-- OPEN THE CURSOR AND FETCH THE RESULTS
	OPEN Job_ID_Cursor

	-- GET FIRST RESULT FROM CURSOR
	FETCH NEXT FROM Job_ID_Cursor INTO @Job_ID

	-- UPDATE JOBOWNER FOR EVERY BUENTING JOB
	WHILE @@FETCH_STATUS = 0
	BEGIN
		EXEC msdb.dbo.sp_update_job @job_id=@Job_ID, @notify_level_email=2, @notify_email_operator_name=@operator_name
		FETCH NEXT FROM Job_ID_Cursor INTO @Job_ID
	END

	-- CLEANUP
	CLOSE Job_ID_Cursor
	DEALLOCATE Job_ID_Cursor
GO
