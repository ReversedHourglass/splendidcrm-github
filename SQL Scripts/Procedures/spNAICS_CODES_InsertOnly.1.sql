if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spNAICS_CODES_InsertOnly' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spNAICS_CODES_InsertOnly;
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
Create Procedure dbo.spNAICS_CODES_InsertOnly
	( @NAME               nvarchar(10)
	, @DESCRIPTION        nvarchar(400)
	)
as
  begin
	set nocount on
	
	declare @ID                 uniqueidentifier;
	declare @MODIFIED_USER_ID   uniqueidentifier;
	if not exists(select * from NAICS_CODES where NAME = @NAME) begin -- then
		set @ID = newid();
		insert into NAICS_CODES
			( ID                
			, CREATED_BY        
			, DATE_ENTERED      
			, MODIFIED_USER_ID  
			, DATE_MODIFIED     
			, DATE_MODIFIED_UTC 
			, NAME              
			, DESCRIPTION       
			)
		values 	( @ID                
			, @MODIFIED_USER_ID        
			,  getdate()         
			, @MODIFIED_USER_ID  
			,  getdate()         
			,  getutcdate()      
			, @NAME              
			, @DESCRIPTION       
			);
	end -- if;
  end
GO

Grant Execute on dbo.spNAICS_CODES_InsertOnly to public;
GO

