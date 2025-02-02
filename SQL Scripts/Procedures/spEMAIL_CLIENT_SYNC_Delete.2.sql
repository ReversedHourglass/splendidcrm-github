if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spEMAIL_CLIENT_SYNC_Delete' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spEMAIL_CLIENT_SYNC_Delete;
GO

/**********************************************************************************************************************
 * SplendidCRM is a Customer Relationship Management program created by SplendidCRM Software, Inc. 
 * Copyright (C) 2005-2023 SplendidCRM Software, Inc. All rights reserved.
 *
 * Any use of the contents of this file are subject to the SplendidCRM Professional Source Code License 
 * Agreement, or other written agreement between you and SplendidCRM ("License"). By installing or 
 * using this file, you have unconditionally agreed to the terms and conditions of the License, 
 * including but not limited to restrictions on the number of users therein, and you may not use this 
 * file except in compliance with the License. 
 * 
 * SplendidCRM owns all proprietary rights, including all copyrights, patents, trade secrets, and 
 * trademarks, in and to the contents of this file.  You will not link to or in any way combine the 
 * contents of this file or any derivatives with any Open Source Code in any manner that would require 
 * the contents of this file to be made available to any third party. 
 * 
 *********************************************************************************************************************/
-- 03/28/2010 Paul.  Exchange Web Services returns dates in local time, so lets store both local time and UTC time. 
-- 04/01/2010 Paul.  Add the MODULE_NAME so that the LastModifiedTime can be filtered by module. 
-- 08/31/2010 Paul.  The EMAILS_SYNC table was renamed to EMAIL_CLIENT_SYNC to prevent conflict with Offline Client sync tables. 
Create Procedure dbo.spEMAIL_CLIENT_SYNC_Delete
	( @MODIFIED_USER_ID         uniqueidentifier
	, @ASSIGNED_USER_ID         uniqueidentifier
	, @LOCAL_ID                 uniqueidentifier
	, @REMOTE_KEY               varchar(800)
	, @MODULE_NAME              nvarchar(25)
	)
as
  begin
	set nocount on

	update EMAIL_CLIENT_SYNC
	   set DELETED           = 1
	     , DATE_MODIFIED     =  getdate()               
	     , DATE_MODIFIED_UTC =  getutcdate()            
	     , MODIFIED_USER_ID  = @MODIFIED_USER_ID        
	 where ASSIGNED_USER_ID  = @ASSIGNED_USER_ID 
	   and REMOTE_KEY        = @REMOTE_KEY 
	   and LOCAL_ID          = @LOCAL_ID 
	   and DELETED           = 0;
  end
GO

Grant Execute on dbo.spEMAIL_CLIENT_SYNC_Delete to public;
GO


