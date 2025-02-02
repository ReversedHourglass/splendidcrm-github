if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spTERMINOLOGY_LIST_MoveUp' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spTERMINOLOGY_LIST_MoveUp;
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
Create Procedure dbo.spTERMINOLOGY_LIST_MoveUp
	( @ID               uniqueidentifier
	, @MODIFIED_USER_ID uniqueidentifier
	)
as
  begin
	set nocount on
	
	declare @SWAP_ID    uniqueidentifier;
	declare @LIST_NAME  nvarchar(50);
	declare @LIST_ORDER int;
	if exists(select * from TERMINOLOGY where ID = @ID and DELETED = 0) begin -- then
		-- BEGIN Oracle Exception
			select @LIST_NAME  = LIST_NAME
			     , @LIST_ORDER = LIST_ORDER
			  from TERMINOLOGY
			 where ID          = @ID
			   and DELETED     = 0;
		-- END Oracle Exception
		
		-- Moving up actually means decrementing the order value. 
		-- BEGIN Oracle Exception
			select @SWAP_ID   = ID
			  from TERMINOLOGY
			 where LIST_NAME  = @LIST_NAME
			   and LIST_ORDER = @LIST_ORDER - 1
			   and DELETED    = 0;
		-- END Oracle Exception
		if dbo.fnIsEmptyGuid(@SWAP_ID) = 0 begin -- then
			-- BEGIN Oracle Exception
				update TERMINOLOGY
				   set LIST_ORDER       = LIST_ORDER - 1
				     , DATE_MODIFIED    = getdate()
				     , DATE_MODIFIED_UTC= getutcdate()
				     , MODIFIED_USER_ID = @MODIFIED_USER_ID
				 where ID               = @ID
				   and DELETED          = 0;
			-- END Oracle Exception
			-- BEGIN Oracle Exception
				update TERMINOLOGY
				   set LIST_ORDER       = LIST_ORDER + 1
				     , DATE_MODIFIED    = getdate()
				     , DATE_MODIFIED_UTC= getutcdate()
				     , MODIFIED_USER_ID = @MODIFIED_USER_ID
				 where ID               = @SWAP_ID
				   and DELETED          = 0;
			-- END Oracle Exception
		end -- if;
	end -- if;
  end
GO

Grant Execute on dbo.spTERMINOLOGY_LIST_MoveUp to public;
GO

