/*
############################################################
## 320-SetupMaintenanceJobsAlerts.sql
##
## Purpose: set up severity error mail alerts
##
############################################################
*/



DECLARE @var_DBA sysname = 'Database Administrators'


USE [msdb]
-- Severity  0 - 10: information
-- Severity 11 - 16: result of user problems and can be fixed by the user
/*
EXEC msdb.dbo.sp_add_alert @name=N'Severity Level 11', @severity=11, @delay_between_responses=30, @include_event_description_in=1, @notification_message=N'Specified Database Object Not Found'
EXEC msdb.dbo.sp_add_alert @name=N'Severity Level 13', @severity=13, @delay_between_responses=30, @include_event_description_in=1, @notification_message=N'User Transaction Syntax Error'
EXEC msdb.dbo.sp_add_alert @name=N'Severity Level 14', @severity=14, @delay_between_responses=30, @include_event_description_in=1, @notification_message=N'Insufficent Permission'
EXEC msdb.dbo.sp_add_alert @name=N'Severity Level 15', @severity=15, @delay_between_responses=30, @include_event_description_in=1, @notification_message=N'Syntax Error in SQL Statements'
EXEC msdb.dbo.sp_add_alert @name=N'Severity Level 16', @severity=16, @delay_between_responses=30, @include_event_description_in=1, @notification_message=N'Miscellaneous User Error'
*/
-- Set Email-Notification on Alert for Database Administrators
/*
EXEC msdb.dbo.sp_add_notification @alert_name=N'Severity Level 11', @operator_name=@var_DBA, @notification_method = 1
EXEC msdb.dbo.sp_add_notification @alert_name=N'Severity Level 13', @operator_name=@var_DBA, @notification_method = 1
EXEC msdb.dbo.sp_add_notification @alert_name=N'Severity Level 14', @operator_name=@var_DBA, @notification_method = 1
EXEC msdb.dbo.sp_add_notification @alert_name=N'Severity Level 15', @operator_name=@var_DBA, @notification_method = 1
EXEC msdb.dbo.sp_add_notification @alert_name=N'Severity Level 16', @operator_name=@var_DBA, @notification_method = 1
*/

-- Severity 17 - 25: Errors that DBA has to check
EXEC msdb.dbo.sp_add_alert @name=N'Severity Level 17', @severity=17, @delay_between_responses=30, @include_event_description_in=1, @notification_message=N'Insufficent Resources'
EXEC msdb.dbo.sp_add_alert @name=N'Severity Level 18', @severity=18, @delay_between_responses=30, @include_event_description_in=1, @notification_message=N'Nonfatal Internal Error'
EXEC msdb.dbo.sp_add_alert @name=N'Severity Level 19', @severity=19, @delay_between_responses=30, @include_event_description_in=1, @notification_message=N'Fatal Error in Resource'
EXEC msdb.dbo.sp_add_alert @name=N'Severity Level 20', @severity=20, @delay_between_responses=30, @include_event_description_in=1, @notification_message=N'Fatal Error in Current Process'
EXEC msdb.dbo.sp_add_alert @name=N'Severity Level 21', @severity=21, @delay_between_responses=30, @include_event_description_in=1, @notification_message=N'Fatal Error in Database Processes'
EXEC msdb.dbo.sp_add_alert @name=N'Severity Level 22', @severity=22, @delay_between_responses=30, @include_event_description_in=1, @notification_message=N'Fatal Error: Table Integrity Suspect'
EXEC msdb.dbo.sp_add_alert @name=N'Severity Level 23', @severity=23, @delay_between_responses=30, @include_event_description_in=1, @notification_message=N'Fatal Error: Database Integrity Suspect'
EXEC msdb.dbo.sp_add_alert @name=N'Severity Level 24', @severity=24, @delay_between_responses=30, @include_event_description_in=1, @notification_message=N'Fatal Error: Hardware Error'
EXEC msdb.dbo.sp_add_alert @name=N'Severity Level 25', @severity=25, @delay_between_responses=30, @include_event_description_in=1, @notification_message=N'Fatal Error'


-- Error 823-825: DBCC Errors that DBA has to check
EXEC msdb.dbo.sp_add_alert @name=N'Error 823', @message_id=823, @severity=0, @delay_between_responses=30, @include_event_description_in=1, @notification_message=N'DBCC Error 823'
EXEC msdb.dbo.sp_add_alert @name=N'Error 824', @message_id=824, @severity=0, @delay_between_responses=30, @include_event_description_in=1, @notification_message=N'DBCC Error 824'
EXEC msdb.dbo.sp_add_alert @name=N'Error 825', @message_id=825, @severity=0, @delay_between_responses=30, @include_event_description_in=1, @notification_message=N'DBCC Error 825'



-- Set Email-Notification on Alert for Database Administrators
EXEC msdb.dbo.sp_add_notification @alert_name=N'Severity Level 17', @operator_name=@var_DBA , @notification_method = 1
EXEC msdb.dbo.sp_add_notification @alert_name=N'Severity Level 18', @operator_name=@var_DBA , @notification_method = 1
EXEC msdb.dbo.sp_add_notification @alert_name=N'Severity Level 19', @operator_name=@var_DBA , @notification_method = 1
EXEC msdb.dbo.sp_add_notification @alert_name=N'Severity Level 20', @operator_name=@var_DBA , @notification_method = 1
EXEC msdb.dbo.sp_add_notification @alert_name=N'Severity Level 21', @operator_name=@var_DBA , @notification_method = 1
EXEC msdb.dbo.sp_add_notification @alert_name=N'Severity Level 22', @operator_name=@var_DBA , @notification_method = 1
EXEC msdb.dbo.sp_add_notification @alert_name=N'Severity Level 23', @operator_name=@var_DBA , @notification_method = 1
EXEC msdb.dbo.sp_add_notification @alert_name=N'Severity Level 24', @operator_name=@var_DBA , @notification_method = 1
EXEC msdb.dbo.sp_add_notification @alert_name=N'Severity Level 25', @operator_name=@var_DBA , @notification_method = 1
EXEC msdb.dbo.sp_add_notification @alert_name=N'Error 823', @operator_name=@var_DBA, @notification_method = 1
EXEC msdb.dbo.sp_add_notification @alert_name=N'Error 824', @operator_name=@var_DBA, @notification_method = 1
EXEC msdb.dbo.sp_add_notification @alert_name=N'Error 825', @operator_name=@var_DBA, @notification_method = 1

