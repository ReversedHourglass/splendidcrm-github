if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spEMAIL_MKTG_PRSPT_LST_Update' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spEMAIL_MKTG_PRSPT_LST_Update;
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
Create Procedure dbo.spEMAIL_MKTG_PRSPT_LST_Update
	( @MODIFIED_USER_ID   uniqueidentifier
	, @EMAIL_MARKETING_ID uniqueidentifier
	, @PROSPECT_LIST_ID   uniqueidentifier
	)
as
  begin
	set nocount on
	
	declare @ID uniqueidentifier;
	-- BEGIN Oracle Exception
		select @ID = ID
		  from EMAIL_MARKETING_PROSPECT_LISTS
		 where EMAIL_MARKETING_ID = @EMAIL_MARKETING_ID
		   and PROSPECT_LIST_ID   = @PROSPECT_LIST_ID
		   and DELETED            = 0;
	-- END Oracle Exception
	
	if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
		-- 01/20/2008 Paul.  When add the first item, we may need to add all the others. 
		-- 01/20/2008 Paul.  Only add the existing lists if currently marked as ALL_PROSPECT_LISTS. 
		if exists(select * from EMAIL_MARKETING where ID = @EMAIL_MARKETING_ID and ALL_PROSPECT_LISTS = 1 and DELETED = 0) begin -- then
			insert into EMAIL_MARKETING_PROSPECT_LISTS(CREATED_BY, MODIFIED_USER_ID, EMAIL_MARKETING_ID, PROSPECT_LIST_ID)
			select @MODIFIED_USER_ID
			     , @MODIFIED_USER_ID
			     , EMAIL_MARKETING.ID
			     , PROSPECT_LIST_CAMPAIGNS.PROSPECT_LIST_ID
			  from            EMAIL_MARKETING
			       inner join CAMPAIGNS
			               on CAMPAIGNS.ID                        = EMAIL_MARKETING.CAMPAIGN_ID
			              and CAMPAIGNS.DELETED                   = 0
			       inner join PROSPECT_LIST_CAMPAIGNS
			               on PROSPECT_LIST_CAMPAIGNS.CAMPAIGN_ID = CAMPAIGNS.ID
			              and PROSPECT_LIST_CAMPAIGNS.DELETED     = 0
			 where EMAIL_MARKETING.ID      = @EMAIL_MARKETING_ID
			   and EMAIL_MARKETING.DELETED = 0;
	
			-- 12/15/2007 Paul.  Disable the ALL flag when the first item is added. 
			update EMAIL_MARKETING
			   set ALL_PROSPECT_LISTS = 0
			     , DATE_MODIFIED      = getdate()
			     , DATE_MODIFIED_UTC= getutcdate()
			     , MODIFIED_USER_ID   = @MODIFIED_USER_ID
			 where ID                 = @EMAIL_MARKETING_ID
			   and ALL_PROSPECT_LISTS = 1;
		end -- if;
		
		set @ID = newid();
		insert into EMAIL_MARKETING_PROSPECT_LISTS
			( ID                
			, CREATED_BY        
			, DATE_ENTERED      
			, MODIFIED_USER_ID  
			, DATE_MODIFIED     
			, EMAIL_MARKETING_ID
			, PROSPECT_LIST_ID  
			)
		values
			( @ID                
			, @MODIFIED_USER_ID  
			,  getdate()         
			, @MODIFIED_USER_ID  
			,  getdate()         
			, @EMAIL_MARKETING_ID
			, @PROSPECT_LIST_ID  
			);
	end -- if;
  end
GO
 
Grant Execute on dbo.spEMAIL_MKTG_PRSPT_LST_Update to public;
GO
 
