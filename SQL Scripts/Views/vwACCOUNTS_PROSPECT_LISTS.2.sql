if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwACCOUNTS_PROSPECT_LISTS')
	Drop View dbo.vwACCOUNTS_PROSPECT_LISTS;
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
-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
Create View dbo.vwACCOUNTS_PROSPECT_LISTS
as
select ACCOUNTS.ID                  as ACCOUNT_ID
     , ACCOUNTS.NAME                as ACCOUNT_NAME
     , ACCOUNTS.ASSIGNED_USER_ID    as ACCOUNT_ASSIGNED_USER_ID
     , ACCOUNTS.ASSIGNED_SET_ID     as ACCOUNT_ASSIGNED_SET_ID
     , vwPROSPECT_LISTS.ID          as PROSPECT_LIST_ID
     , vwPROSPECT_LISTS.NAME        as PROSPECT_LIST_NAME
     , vwPROSPECT_LISTS.*
     , (select count(*)
          from PROSPECT_LISTS_PROSPECTS
         where PROSPECT_LISTS_PROSPECTS.PROSPECT_LIST_ID = vwPROSPECT_LISTS.ID
           and PROSPECT_LISTS_PROSPECTS.DELETED          = 0
       ) as ENTRIES
  from            ACCOUNTS
       inner join PROSPECT_LISTS_PROSPECTS
               on PROSPECT_LISTS_PROSPECTS.RELATED_ID   = ACCOUNTS.ID
              and PROSPECT_LISTS_PROSPECTS.RELATED_TYPE = N'Accounts'
              and PROSPECT_LISTS_PROSPECTS.DELETED      = 0
       inner join vwPROSPECT_LISTS
               on vwPROSPECT_LISTS.ID                   = PROSPECT_LISTS_PROSPECTS.PROSPECT_LIST_ID
 where ACCOUNTS.DELETED = 0

GO

Grant Select on dbo.vwACCOUNTS_PROSPECT_LISTS to public;
GO

