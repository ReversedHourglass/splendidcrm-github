if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwGRIDVIEWS_RULES')
	Drop View dbo.vwGRIDVIEWS_RULES;
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
Create View dbo.vwGRIDVIEWS_RULES
as
select GRIDVIEWS.ID
     , GRIDVIEWS.NAME
     , GRIDVIEWS.MODULE_NAME
     , GRIDVIEWS.VIEW_NAME
     , PRE_LOAD_EVENT_RULES.ID      as PRE_LOAD_EVENT_ID
     , PRE_LOAD_EVENT_RULES.NAME    as PRE_LOAD_EVENT_NAME
     , PRE_LOAD_EVENT_RULES.XOML    as PRE_LOAD_EVENT_XOML
     , POST_LOAD_EVENT_RULES.ID     as POST_LOAD_EVENT_ID
     , POST_LOAD_EVENT_RULES.NAME   as POST_LOAD_EVENT_NAME
     , POST_LOAD_EVENT_RULES.XOML   as POST_LOAD_EVENT_XOML
  from            GRIDVIEWS
  left outer join RULES                            PRE_LOAD_EVENT_RULES
               on PRE_LOAD_EVENT_RULES.ID        = GRIDVIEWS.PRE_LOAD_EVENT_ID
              and PRE_LOAD_EVENT_RULES.DELETED   = 0
  left outer join RULES                            POST_LOAD_EVENT_RULES
               on POST_LOAD_EVENT_RULES.ID       = GRIDVIEWS.POST_LOAD_EVENT_ID
              and POST_LOAD_EVENT_RULES.DELETED  = 0
 where GRIDVIEWS.DELETED = 0

GO

Grant Select on dbo.vwGRIDVIEWS_RULES to public;
GO

