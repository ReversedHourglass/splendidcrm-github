if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spSYSTEM_SYNC_LOG_InsertOnly' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spSYSTEM_SYNC_LOG_InsertOnly;
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
Create Procedure dbo.spSYSTEM_SYNC_LOG_InsertOnly
	( @MODIFIED_USER_ID  uniqueidentifier
	, @USER_ID           uniqueidentifier
	, @MACHINE           nvarchar(60)
	, @REMOTE_URL        nvarchar(255)
	, @ERROR_TYPE        nvarchar(25)
	, @FILE_NAME         nvarchar(255)
	, @METHOD            nvarchar(450)
	, @LINE_NUMBER       int
	, @MESSAGE           nvarchar(max)
	)
as
  begin
	set nocount on
	
	declare @ID uniqueidentifier;
	set @ID = newid();
	insert into SYSTEM_SYNC_LOG
		( ID               
		, CREATED_BY       
		, DATE_ENTERED     
		, MODIFIED_USER_ID 
		, DATE_MODIFIED    
		, DATE_MODIFIED_UTC
		, USER_ID          
		, MACHINE          
		, REMOTE_URL       
		, ERROR_TYPE       
		, FILE_NAME        
		, METHOD           
		, LINE_NUMBER      
		, MESSAGE          
		)
	values 	( @ID               
		, @MODIFIED_USER_ID 
		,  getdate()        
		, @MODIFIED_USER_ID 
		,  getdate()        
		,  getutcdate()     
		, @USER_ID          
		, @MACHINE          
		, @REMOTE_URL       
		, @ERROR_TYPE       
		, @FILE_NAME        
		, @METHOD           
		, @LINE_NUMBER      
		, @MESSAGE          
		);
  end
GO

Grant Execute on dbo.spSYSTEM_SYNC_LOG_InsertOnly to public;
GO

