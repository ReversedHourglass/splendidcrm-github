if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwSHORTCUTS_Menu')
	Drop View dbo.vwSHORTCUTS_Menu;
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
Create View dbo.vwSHORTCUTS_Menu
as
select vwSHORTCUTS.MODULE_NAME
     , vwSHORTCUTS.DISPLAY_NAME
     , vwSHORTCUTS.RELATIVE_PATH
     , vwSHORTCUTS.IMAGE_NAME
     , vwSHORTCUTS.SHORTCUT_ORDER
  from      vwSHORTCUTS
 inner join vwMODULES
         on vwMODULES.MODULE_NAME = vwSHORTCUTS.MODULE_NAME
 where vwSHORTCUTS.SHORTCUT_ENABLED = 1

GO

Grant Select on dbo.vwSHORTCUTS_Menu to public;
GO


