if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwCONTACTS_EmailList')
	Drop View dbo.vwCONTACTS_EmailList;
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
-- 12/19/2006 Paul.  We need the TEAM_ID and ASSIGNED_USER_ID for standard security filtering. 
-- 11/23/2009 Paul.  Needed to add the TEAM_SET fields. 
-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
Create View dbo.vwCONTACTS_EmailList
as
select ID
     , NAME
     , FIRST_NAME
     , LAST_NAME
     , TITLE
     , ACCOUNT_NAME
     , ACCOUNT_ID
     , PHONE_HOME
     , PHONE_MOBILE
     , PHONE_WORK
     , PHONE_OTHER
     , PHONE_FAX
     , EMAIL1
     , EMAIL2
     , ASSISTANT
     , ASSISTANT_PHONE
     , ASSIGNED_TO
     , ASSIGNED_USER_ID
     , TEAM_ID
     , TEAM_NAME
     , TEAM_SET_ID
     , TEAM_SET_NAME
     , ASSIGNED_SET_ID
     , ASSIGNED_SET_NAME
     , ASSIGNED_SET_LIST
  from vwCONTACTS_List
 where EMAIL1 is not null

GO

Grant Select on dbo.vwCONTACTS_EmailList to public;
GO


