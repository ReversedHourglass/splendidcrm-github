if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spNUMBER_SEQUENCES_Update' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spNUMBER_SEQUENCES_Update;
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
Create Procedure dbo.spNUMBER_SEQUENCES_Update
	( @ID                uniqueidentifier output
	, @MODIFIED_USER_ID  uniqueidentifier
	, @NAME              nvarchar(60)
	, @ALPHA_PREFIX      nvarchar(10)
	, @ALPHA_SUFFIX      nvarchar(10)
	, @SEQUENCE_STEP     int
	, @NUMERIC_PADDING   int
	, @CURRENT_VALUE     int
	)
as
  begin
	set nocount on
	
	if not exists(select * from NUMBER_SEQUENCES where ID = @ID) begin -- then
		if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
			set @ID = newid();
		end -- if;
		insert into NUMBER_SEQUENCES
			( ID               
			, CREATED_BY       
			, DATE_ENTERED     
			, MODIFIED_USER_ID 
			, DATE_MODIFIED    
			, NAME             
			, ALPHA_PREFIX     
			, ALPHA_SUFFIX     
			, SEQUENCE_STEP    
			, NUMERIC_PADDING  
			, CURRENT_VALUE    
			)
		values 	( @ID               
			, @MODIFIED_USER_ID       
			,  getdate()        
			, @MODIFIED_USER_ID 
			,  getdate()        
			, @NAME             
			, @ALPHA_PREFIX     
			, @ALPHA_SUFFIX     
			, @SEQUENCE_STEP    
			, @NUMERIC_PADDING  
			, @CURRENT_VALUE    
			);
	end else begin
		update NUMBER_SEQUENCES
		   set MODIFIED_USER_ID  = @MODIFIED_USER_ID 
		     , DATE_MODIFIED     =  getdate()        
		     , DATE_MODIFIED_UTC =  getutcdate()     
		     , NAME              = @NAME             
		     , ALPHA_PREFIX      = @ALPHA_PREFIX     
		     , ALPHA_SUFFIX      = @ALPHA_SUFFIX     
		     , SEQUENCE_STEP     = @SEQUENCE_STEP    
		     , NUMERIC_PADDING   = @NUMERIC_PADDING  
		     , CURRENT_VALUE     = @CURRENT_VALUE    
		 where ID                = @ID               ;
	end -- if;
  end
GO

Grant Execute on dbo.spNUMBER_SEQUENCES_Update to public;
GO


