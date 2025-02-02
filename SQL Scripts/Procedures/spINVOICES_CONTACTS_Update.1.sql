if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spINVOICES_CONTACTS_Update' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spINVOICES_CONTACTS_Update;
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
-- 11/13/2009 Paul.  Remove the unnecessary update as it will reduce offline client conflicts. 
Create Procedure dbo.spINVOICES_CONTACTS_Update
	( @MODIFIED_USER_ID  uniqueidentifier
	, @INVOICE_ID        uniqueidentifier
	, @CONTACT_ID        uniqueidentifier
	, @CONTACT_ROLE      nvarchar(25)
	)
as
  begin
	set nocount on
	
	declare @ID uniqueidentifier;
	-- BEGIN Oracle Exception
		select @ID = ID
		  from INVOICES_CONTACTS
		 where INVOICE_ID        = @INVOICE_ID
		   and CONTACT_ID        = @CONTACT_ID
		   and CONTACT_ROLE      = @CONTACT_ROLE
		   and DELETED           = 0;
	-- END Oracle Exception
	
	if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
		set @ID = newid();
		insert into INVOICES_CONTACTS
			( ID               
			, CREATED_BY       
			, DATE_ENTERED     
			, MODIFIED_USER_ID 
			, DATE_MODIFIED    
			, INVOICE_ID         
			, CONTACT_ID       
			, CONTACT_ROLE     
			)
		values
			( @ID               
			, @MODIFIED_USER_ID 
			,  getdate()        
			, @MODIFIED_USER_ID 
			,  getdate()        
			, @INVOICE_ID         
			, @CONTACT_ID       
			, @CONTACT_ROLE     
			);
	end -- if;
  end
GO
 
Grant Execute on dbo.spINVOICES_CONTACTS_Update to public;
GO
 
