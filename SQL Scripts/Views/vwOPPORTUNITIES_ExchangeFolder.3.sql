if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwOPPORTUNITIES_ExchangeFolder')
	Drop View dbo.vwOPPORTUNITIES_ExchangeFolder;
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
-- 05/14/2010 Paul.  We need the NEW_FOLDER flag to determine if we should perform a first SyncAll. 
Create View dbo.vwOPPORTUNITIES_ExchangeFolder
as
select vwOPPORTUNITIES.ID
     , vwOPPORTUNITIES.NAME
     , vwOPPORTUNITIES_USERS.USER_ID
     , (case when vwEXCHANGE_FOLDERS.ID is null then 1 else 0 end) as NEW_FOLDER
  from      vwOPPORTUNITIES
 inner join vwOPPORTUNITIES_USERS
         on vwOPPORTUNITIES_USERS.OPPORTUNITY_ID = vwOPPORTUNITIES.ID
  left outer join vwEXCHANGE_FOLDERS
               on vwEXCHANGE_FOLDERS.PARENT_ID         = vwOPPORTUNITIES_USERS.OPPORTUNITY_ID
              and vwEXCHANGE_FOLDERS.ASSIGNED_USER_ID  = vwOPPORTUNITIES_USERS.USER_ID
              and vwEXCHANGE_FOLDERS.MODULE_NAME       = N'Opportunities'
 where vwOPPORTUNITIES.NAME is not null

GO

Grant Select on dbo.vwOPPORTUNITIES_ExchangeFolder to public;
GO

