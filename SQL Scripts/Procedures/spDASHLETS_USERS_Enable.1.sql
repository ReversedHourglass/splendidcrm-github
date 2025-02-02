if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spDASHLETS_USERS_Enable' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spDASHLETS_USERS_Enable;
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
-- 01/28/2010 Paul.  The ASSIGNED_USER_ID must be used when managing dashlets. 
Create Procedure dbo.spDASHLETS_USERS_Enable
	( @ID               uniqueidentifier
	, @MODIFIED_USER_ID uniqueidentifier
	)
as
  begin
	set nocount on
	
	declare @ASSIGNED_USER_ID uniqueidentifier;
	declare @SWAP_ID       uniqueidentifier;
	declare @DETAIL_NAME   nvarchar(50);
	declare @DASHLET_ORDER int;

	set @ASSIGNED_USER_ID = @MODIFIED_USER_ID;
	if exists(select * from DASHLETS_USERS where ID = @ID and DELETED = 0) begin -- then
		-- BEGIN Oracle Exception
			select @DETAIL_NAME   = DETAIL_NAME
			     , @DASHLET_ORDER = DASHLET_ORDER
			  from DASHLETS_USERS
			 where ID          = @ID
			   and DELETED     = 0;
		-- END Oracle Exception

		-- 01/28/2010 Paul.  The ASSIGNED_USER_ID must be used when managing dashlets. 
		-- BEGIN Oracle Exception
			select @SWAP_ID = ID
			  from DASHLETS_USERS
			 where ASSIGNED_USER_ID = @ASSIGNED_USER_ID 
			   and DETAIL_NAME      = @DETAIL_NAME
			   and DASHLET_ORDER    = 0
			   and DELETED          = 0;
		-- END Oracle Exception
		-- 01/04/2005 Paul.  If there is a module at 0, shift all DASHLETS_USERS so that this one can be 1. 
		if dbo.fnIsEmptyGuid(@SWAP_ID) = 0 begin -- then
			-- 04/02/2006 Paul.  Catch the Oracle NO_DATA_FOUND exception. 
			-- 01/28/2010 Paul.  The ASSIGNED_USER_ID must be used when managing dashlets. 
			-- BEGIN Oracle Exception
				update DASHLETS_USERS
				   set DASHLET_ORDER    = DASHLET_ORDER + 1
				 where ASSIGNED_USER_ID = @ASSIGNED_USER_ID 
				   and DETAIL_NAME      = @DETAIL_NAME
				   and DASHLET_ORDER   >= 0
				   and DELETED          = 0;
			-- END Oracle Exception
		end -- if;
		
		-- 01/04/2006 Paul.  DASHLETS_USERS made visible start at tab 0. 
		-- BEGIN Oracle Exception
			update DASHLETS_USERS
			   set MODIFIED_USER_ID = @MODIFIED_USER_ID 
			     , DATE_MODIFIED    =  getdate()        
			     , DATE_MODIFIED_UTC=  getutcdate()     
			     , DASHLET_ORDER    = 0
			     , DASHLET_ENABLED  = 1
			 where ID               = @ID
			   and DELETED          = 0;
		-- END Oracle Exception
	end -- if;
  end
GO

Grant Execute on dbo.spDASHLETS_USERS_Enable to public;
GO

