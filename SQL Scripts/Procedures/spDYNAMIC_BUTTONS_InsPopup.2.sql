if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spDYNAMIC_BUTTONS_InsPopup' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spDYNAMIC_BUTTONS_InsPopup;
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
-- 08/27/2008 Paul.  PostgreSQL does not allow modifying input parameters.  Use a local temp variable. 
-- 09/12/2010 Paul.  Add default parameter EXCLUDE_MOBILE to ease migration to EffiProz. 
-- 03/14/2014 Paul.  Allow hidden buttons to be created. 
Create Procedure dbo.spDYNAMIC_BUTTONS_InsPopup
	( @VIEW_NAME           nvarchar(50)
	, @CONTROL_INDEX       int
	, @MODULE_NAME         nvarchar(25)
	, @MODULE_ACCESS_TYPE  nvarchar(100)
	, @TARGET_NAME         nvarchar(25)
	, @TARGET_ACCESS_TYPE  nvarchar(100)
	, @ONCLICK_SCRIPT      nvarchar(255)
	, @TEXT_FIELD          nvarchar(200)
	, @CONTROL_TEXT        nvarchar(150)
	, @CONTROL_TOOLTIP     nvarchar(150)
	, @CONTROL_ACCESSKEY   nvarchar(150)
	, @ARGUMENT_FIELD      nvarchar(200)
	, @MOBILE_ONLY         bit
	)
as
  begin
	set nocount on
	
	declare @ID                  uniqueidentifier;
	declare @TEMP_ONCLICK_SCRIPT nvarchar(255);
	set @TEMP_ONCLICK_SCRIPT = @ONCLICK_SCRIPT;
	
	-- BEGIN Oracle Exception
		select @ID = ID
		  from DYNAMIC_BUTTONS
		 where VIEW_NAME     = @VIEW_NAME    
		   and CONTROL_INDEX = @CONTROL_INDEX
		   and DELETED       = 0             
		   and DEFAULT_VIEW  = 0             ;
	-- END Oracle Exception

	-- 04/28/2008 Paul.  Popups should return false so that the button does not actually submit the form. 
	-- 05/09/2008 Paul.  There should always be a return false in a popup. 
	if charindex('return ', @TEMP_ONCLICK_SCRIPT,  1) = 0 begin -- then
		set @TEMP_ONCLICK_SCRIPT = @TEMP_ONCLICK_SCRIPT + N'return false;';
	end -- if;
	if not exists(select * from DYNAMIC_BUTTONS where ID = @ID) begin -- then
		exec dbo.spDYNAMIC_BUTTONS_Update
			  @ID out
			, null                 -- MODIFIED_USER_ID    
			, @VIEW_NAME           
			, @CONTROL_INDEX       
			, N'Button'            -- CONTROL_TYPE
			, @MODULE_NAME         
			, @MODULE_ACCESS_TYPE  
			, @TARGET_NAME         
			, @TARGET_ACCESS_TYPE  
			, @CONTROL_TEXT        
			, @CONTROL_TOOLTIP     
			, @CONTROL_ACCESSKEY   
			, N'button'            -- CONTROL_CSSCLASS
			, @TEXT_FIELD          
			, @ARGUMENT_FIELD      
			, null                 -- COMMAND_NAME        
			, null                 -- URL_FORMAT
			, null                 -- URL_TARGET
			, @TEMP_ONCLICK_SCRIPT      
			, @MOBILE_ONLY         
			, 0                    -- ADMIN_ONLY          
			, null                 -- EXCLUDE_MOBILE      
			, null                 -- HIDDEN              
			;
	end -- if;
  end
GO

Grant Execute on dbo.spDYNAMIC_BUTTONS_InsPopup to public;
GO

