if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spTERMINOLOGY_DeleteTerm' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spTERMINOLOGY_DeleteTerm;
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
Create Procedure dbo.spTERMINOLOGY_DeleteTerm
	( @TERM              nvarchar(100)
	)
as
  begin
	set nocount on

	if exists(select * from TERMINOLOGY where isnull(MODULE_NAME, N'') + N'.' + isnull(NAME, N'') = @TERM) begin -- then	
		delete from TERMINOLOGY
		 where isnull(MODULE_NAME, N'') + N'.' + isnull(NAME, N'') = @TERM
		  and LIST_NAME is null;
	end -- if;
  end
GO

Grant Execute on dbo.spTERMINOLOGY_DeleteTerm to public;
GO

