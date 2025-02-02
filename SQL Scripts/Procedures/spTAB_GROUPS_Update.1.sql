if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spTAB_GROUPS_Update' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spTAB_GROUPS_Update;
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
-- 02/25/2010 Paul.  We need a flag to determine if the group is displayed on the menu. 
Create Procedure dbo.spTAB_GROUPS_Update
	( @ID                 uniqueidentifier output
	, @MODIFIED_USER_ID   uniqueidentifier
	, @NAME               nvarchar(25)
	, @TITLE              nvarchar(100)
	, @ENABLED            bit
	, @GROUP_ORDER        int
	, @GROUP_MENU         bit
	)
as
  begin
	set nocount on
	
	-- BEGIN Oracle Exception
		select @ID = ID
		  from TAB_GROUPS
		 where NAME         = @NAME
		   and DELETED      = 0    ;
	-- END Oracle Exception
	if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
		set @ID = newid();
		insert into TAB_GROUPS
			( ID                
			, CREATED_BY        
			, DATE_ENTERED      
			, MODIFIED_USER_ID  
			, DATE_MODIFIED     
			, DATE_MODIFIED_UTC 
			, NAME              
			, TITLE             
			, ENABLED           
			, GROUP_ORDER       
			, GROUP_MENU        
			)
		values 	( @ID                
			, @MODIFIED_USER_ID  
			,  getdate()         
			, @MODIFIED_USER_ID  
			,  getdate()         
			,  getutcdate()      
			, @NAME              
			, @TITLE             
			, @ENABLED           
			, @GROUP_ORDER       
			, @GROUP_MENU        
			);
	end else begin
		update TAB_GROUPS
		   set MODIFIED_USER_ID   = @MODIFIED_USER_ID  
		     , DATE_MODIFIED      =  getdate()         
		     , DATE_MODIFIED_UTC  =  getutcdate()      
		     , TITLE              = @TITLE             
		     , ENABLED            = @ENABLED           
		     , GROUP_ORDER        = @GROUP_ORDER       
		     , GROUP_MENU         = GROUP_MENU        
		 where ID                 = @ID                ;
	end -- if;
  end
GO

Grant Execute on dbo.spTAB_GROUPS_Update to public;
GO

