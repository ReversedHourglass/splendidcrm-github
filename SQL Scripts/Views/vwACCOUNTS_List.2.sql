if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwACCOUNTS_List')
	Drop View dbo.vwACCOUNTS_List;
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
-- 01/18/2008 Paul.  Return the primary contact, which is just the first contact when sorted alphabetically. 
-- 09/11/2009 Paul.  Move the Primary Contact filter out of the where clause as it will prevent us from stubbing the primary function. 
-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
Create View dbo.vwACCOUNTS_List
as
select vwACCOUNTS.*
     , CONTACTS.ID               as CONTACT_ID
     , CONTACTS.ASSIGNED_USER_ID as CONTACT_ASSIGNED_USER_ID
     , CONTACTS.ASSIGNED_SET_ID  as CONTACT_ASSIGNED_SET_ID
     , dbo.fnFullName(CONTACTS.FIRST_NAME, CONTACTS.LAST_NAME) as CONTACT_NAME
  from            vwACCOUNTS
  left outer join ACCOUNTS_CONTACTS
               on ACCOUNTS_CONTACTS.ACCOUNT_ID = vwACCOUNTS.ID
              and ACCOUNTS_CONTACTS.DELETED    = 0
              and ACCOUNTS_CONTACTS.CONTACT_ID = dbo.fnACCOUNTS_CONTACTS_Primary(vwACCOUNTS.ID)
  left outer join CONTACTS
               on CONTACTS.ID            = ACCOUNTS_CONTACTS.CONTACT_ID
              and CONTACTS.DELETED       = 0

GO

Grant Select on dbo.vwACCOUNTS_List to public;
GO

