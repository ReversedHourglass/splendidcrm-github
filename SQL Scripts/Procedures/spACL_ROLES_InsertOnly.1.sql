if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spACL_ROLES_InsertOnly' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spACL_ROLES_InsertOnly;
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
Create Procedure dbo.spACL_ROLES_InsertOnly
	( @ID                uniqueidentifier
	, @NAME              nvarchar(150)
	, @DESCRIPTION       nvarchar(max)
	)
as
  begin
	set nocount on
	
	if not exists(select * from ACL_ROLES where ID = @ID) begin -- then
		if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
			set @ID = newid();
		end -- if;
		insert into ACL_ROLES
			( ID               
			, CREATED_BY       
			, DATE_ENTERED     
			, MODIFIED_USER_ID 
			, DATE_MODIFIED    
			, NAME             
			, DESCRIPTION      
			)
		values 	( @ID               
			, null               
			,  getdate()        
			, null               
			,  getdate()        
			, @NAME             
			, @DESCRIPTION      
			);
	end -- if;

	if not exists(select * from ACL_ROLES_CSTM where ID_C = @ID) begin -- then
		insert into ACL_ROLES_CSTM ( ID_C ) values ( @ID );
	end -- if;

  end
GO
 
Grant Execute on dbo.spACL_ROLES_InsertOnly to public;
GO
 
