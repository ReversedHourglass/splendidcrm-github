if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spCONTACTS_USERS_Delete' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spCONTACTS_USERS_Delete;
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
-- 09/18/2015 Paul.  Add SERVICE_NAME to separate Exchange Folders from Contacts Sync. 
Create Procedure dbo.spCONTACTS_USERS_Delete
	( @MODIFIED_USER_ID uniqueidentifier
	, @CONTACT_ID       uniqueidentifier
	, @USER_ID          uniqueidentifier
	, @SERVICE_NAME     nvarchar(25) = null
	)
as
  begin
	set nocount on
	
	-- 02/09/2006 Paul.  SugarCRM uses the CONTACTS_USERS table to allow each user to 
	-- choose the contacts they want sync'd with Outlook. 
	update CONTACTS_USERS
	   set DELETED          = 1
	     , DATE_MODIFIED    = getdate()
	     , DATE_MODIFIED_UTC= getutcdate()
	     , MODIFIED_USER_ID = @MODIFIED_USER_ID
	 where CONTACT_ID       = @CONTACT_ID
	   and USER_ID          = @USER_ID
	   and (SERVICE_NAME is null and @SERVICE_NAME is null or SERVICE_NAME = @SERVICE_NAME)
	   and DELETED          = 0;
  end
GO

Grant Execute on dbo.spCONTACTS_USERS_Delete to public;
GO

