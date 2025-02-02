if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwMODULES_RenameTabs')
	Drop View dbo.vwMODULES_RenameTabs;
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
-- 12/05/2006 Paul.  Literals should be in unicode to reduce conversions at runtime. 
Create View dbo.vwMODULES_RenameTabs
as
select TERMINOLOGY.ID
     , TERMINOLOGY.NAME
     , TERMINOLOGY.LANG
     , TERMINOLOGY.LIST_NAME
     , TERMINOLOGY.LIST_ORDER
     , TERMINOLOGY.DISPLAY_NAME
     , vwMODULES.TAB_ORDER
  from      TERMINOLOGY
 inner join vwMODULES
         on vwMODULES.MODULE_NAME = TERMINOLOGY.NAME
 where TERMINOLOGY.DELETED = 0
   and TERMINOLOGY.LIST_NAME = N'moduleList'
   and vwMODULES.TAB_ENABLED = 1
GO

Grant Select on dbo.vwMODULES_RenameTabs to public;
GO


