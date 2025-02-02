if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spMODULES_Disable' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spMODULES_Disable;
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
Create Procedure dbo.spMODULES_Disable
	( @ID               uniqueidentifier
	, @MODIFIED_USER_ID uniqueidentifier
	)
as
  begin
	set nocount on
	
	if exists(select * from MODULES where ID = @ID and DELETED = 0) begin -- then
		-- BEGIN Oracle Exception
			update MODULES
			   set MODIFIED_USER_ID  = @MODIFIED_USER_ID 
			     , DATE_MODIFIED     =  getdate()        
			     , DATE_MODIFIED_UTC =  getutcdate()     
			     , MODULE_ENABLED    = 0
			 where ID                = @ID
			   and DELETED           = 0;
		-- END Oracle Exception
		-- 08/27/2007 Paul.  When disabling, hide it as a tab. 
		exec dbo.spMODULES_TAB_Hide @ID, @MODIFIED_USER_ID;
	end -- if;
  end
GO

Grant Execute on dbo.spMODULES_Disable to public;
GO

