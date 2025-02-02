if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwPROSPECT_LISTS_EditSQL')
	Drop View dbo.vwPROSPECT_LISTS_EditSQL;
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
-- 01/14/2010 Paul.  Move DYNAMIC_SQL to a separate table so that it cannot be imported or exported. 
Create View dbo.vwPROSPECT_LISTS_EditSQL
as
select vwPROSPECT_LISTS_Edit.*
     , PROSPECT_LISTS_SQL.DYNAMIC_SQL
     , PROSPECT_LISTS_SQL.DYNAMIC_RDL
  from            vwPROSPECT_LISTS_Edit
  left outer join PROSPECT_LISTS_SQL 
               on PROSPECT_LISTS_SQL.ID = vwPROSPECT_LISTS_Edit.ID

GO

Grant Select on dbo.vwPROSPECT_LISTS_EditSQL to public;
GO


