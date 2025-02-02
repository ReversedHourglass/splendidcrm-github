if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwTWITTER_MESSAGES_RELATED_LEADS')
	Drop View dbo.vwTWITTER_MESSAGES_RELATED_LEADS;
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
Create View dbo.vwTWITTER_MESSAGES_RELATED_LEADS
as
select ID
     , PARENT_ID as LEAD_ID
  from TWITTER_MESSAGES
 where PARENT_ID   is not null
   and PARENT_TYPE = N'Leads'
   and DELETED     = 0
union
select TWITTER_MESSAGES.ID
     , PROSPECTS.LEAD_ID
  from      PROSPECTS
 inner join TWITTER_MESSAGES
         on TWITTER_MESSAGES.PARENT_ID   = PROSPECTS.ID
        and TWITTER_MESSAGES.PARENT_TYPE = N'Prospects'
        and TWITTER_MESSAGES.DELETED     = 0
 where PROSPECTS.DELETED = 0
   and PROSPECTS.LEAD_ID is not null

GO

Grant Select on dbo.vwTWITTER_MESSAGES_RELATED_LEADS to public;
GO

