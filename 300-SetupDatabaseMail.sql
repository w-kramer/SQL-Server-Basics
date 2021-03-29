/*
############################################################
## 300-SetupDatabaseMail.sql
##
## Purpose: set up database mail
##
############################################################
*/

DECLARE @servername				sysname
	  , @servicename			sysname
	  , @account_name			sysname
	  , @profile_name			sysname
	  , @SMTP_servername			sysname
	  , @operator_name			sysname
	  , @email_address			NVARCHAR(128)
	  , @display_name			NVARCHAR(128)
	  , @profile_email_address		NVARCHAR(128)
	  , @operator_email_address 		NVARCHAR(128);

SELECT	@servername = @@SERVERNAME;
SELECT	@servicename = @@SERVICENAME;

-- ============================================================================
-- Activate Mail  Procedures
-- ============================================================================
SET @account_name = N'Administrative Mail Account';
SET @profile_name = N'Administrative Mail Profile';
SET @profile_email_address = N'<DBAdmin@domain.local>';             -- [ChangeMe] (send and reply address)
SET @SMTP_servername = N'<SMTP Server Name or IP Address>';         -- [ChangeMe] 	
SET @operator_name = N'Database Administrators';                    -- [ChangeMe]
SET @operator_email_address = N'<DBAdmin@domain.local>';            -- [ChangeMe] (recipitent address)
SET @display_name = N'Database Mail: ' + @servername;


-- ============================================================================
-- Activate Mail  Procedures
-- ============================================================================
USE master;

EXECUTE sp_configure 'show advanced', 1;
RECONFIGURE;
EXECUTE sp_configure 'Database Mail XPs', 1;
RECONFIGURE;
EXECUTE sp_configure 'show advanced', 0;
RECONFIGURE;


-- ============================================================================
-- Create Operator
-- ============================================================================
USE msdb;

EXEC msdb.dbo.sp_add_operator @name = @operator_name
							, @enabled = 1
							, @email_address = @operator_email_address;


-- ============================================================================
-- Create mail account and profile
-- ============================================================================

EXECUTE msdb.dbo.sysmail_add_account_sp @description = N'Mail account for administrative mails like warning, errors, etc.'
									  , @account_name = @account_name
									  , @email_address = @profile_email_address
									  , @replyto_address = @profile_email_address
									  , @display_name = @display_name
									  , @mailserver_name = @SMTP_servername;

EXECUTE msdb.dbo.sysmail_add_profile_sp @description = N'Mail profile for administrative mails like warning, errors, etc.'
									  , @profile_name = @profile_name;

EXECUTE msdb.dbo.sysmail_add_profileaccount_sp @profile_name = @profile_name
											 , @account_name = @account_name
											 , @sequence_number = 1;

EXECUTE msdb.dbo.sysmail_add_principalprofile_sp @profile_name = @profile_name
											   , @principal_name = 'public'
											   , @is_default = 1;

-- ============================================================================
-- activate warningsystem SQL Agent
-- ============================================================================

-- [ChangeMe]
-- activate warningsystem SQL Agent on 2012
EXEC msdb.dbo.sp_set_sqlagent_properties @email_save_in_sent_folder = 1
									   , @databasemail_profile = @profile_name
									   , @use_databasemail = 1;

---- ============================================================================
---- Set failsafe operator
---- ============================================================================
EXEC master.dbo.sp_MSsetalertinfo @failsafeoperator = @operator_name
								, @notificationmethod = 1;
