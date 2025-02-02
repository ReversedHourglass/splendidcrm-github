if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spSCHEDULERS_UpdateStatus' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spSCHEDULERS_UpdateStatus;
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
-- 08/24/2010 Paul.  Try and be more efficient by only updating the status if it changed. 
Create Procedure dbo.spSCHEDULERS_UpdateStatus
	( @MODIFIED_USER_ID  uniqueidentifier
	, @JOB               nvarchar(255)
	, @STATUS            nvarchar(25)
	)
as
  begin
	set nocount on
	
	update SCHEDULERS
	   set STATUS           = @STATUS
	     , MODIFIED_USER_ID = @MODIFIED_USER_ID 
	     , DATE_MODIFIED    =  getdate()        
	     , DATE_MODIFIED_UTC=  getutcdate()     
	 where JOB              = @JOB  
	   and (STATUS <> @STATUS or STATUS is null)
	   and DELETED          = 0;
  end
GO

Grant Execute on dbo.spSCHEDULERS_UpdateStatus to public;
GO

