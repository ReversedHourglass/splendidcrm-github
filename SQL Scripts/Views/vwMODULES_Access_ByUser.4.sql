if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwMODULES_Access_ByUser')
	Drop View dbo.vwMODULES_Access_ByUser;
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
-- 02/08/2018 Paul.  TABLE_NAME is needed by RestUtils so that we can determine the module in the calendar. 
Create View dbo.vwMODULES_Access_ByUser
as
select vwMODULES_USERS_Cross.USER_ID
     , vwMODULES_USERS_Cross.MODULE_NAME
     , vwMODULES_USERS_Cross.DISPLAY_NAME
     , vwMODULES_USERS_Cross.RELATIVE_PATH
     , vwMODULES_USERS_Cross.TAB_ORDER
     , vwMODULES_USERS_Cross.PORTAL_ENABLED
     , vwMODULES_USERS_Cross.TABLE_NAME
  from            vwMODULES_USERS_Cross
  left outer join vwACL_ACTIONS
               on vwACL_ACTIONS.CATEGORY            = vwMODULES_USERS_Cross.MODULE_NAME
              and vwACL_ACTIONS.NAME                = N'access'
  left outer join vwACL_ACCESS_ByAccess
               on vwACL_ACCESS_ByAccess.USER_ID     = vwMODULES_USERS_Cross.USER_ID
              and vwACL_ACCESS_ByAccess.MODULE_NAME = vwMODULES_USERS_Cross.MODULE_NAME
 where vwMODULES_USERS_Cross.MODULE_ENABLED = 1
   and (   (vwACL_ACCESS_ByAccess.ACLACCESS_ACCESS is not null and vwACL_ACCESS_ByAccess.ACLACCESS_ACCESS >= 0)
        or (vwACL_ACCESS_ByAccess.ACLACCESS_ACCESS is null and vwACL_ACTIONS.ACLACCESS is not null and vwACL_ACTIONS.ACLACCESS >= 0)
        or (vwACL_ACCESS_ByAccess.ACLACCESS_ACCESS is null and vwACL_ACTIONS.ACLACCESS is null)
       )
GO

Grant Select on dbo.vwMODULES_Access_ByUser to public;
GO

