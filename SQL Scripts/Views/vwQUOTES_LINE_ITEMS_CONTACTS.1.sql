if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwQUOTES_LINE_ITEMS_CONTACTS')
	Drop View dbo.vwQUOTES_LINE_ITEMS_CONTACTS;
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
Create View dbo.vwQUOTES_LINE_ITEMS_CONTACTS
as
select QUOTES_LINE_ITEMS.ID
     , QUOTES_LINE_ITEMS.QUOTE_ID
     , QUOTES_CONTACTS.CONTACT_ROLE
     , QUOTES_CONTACTS.CONTACT_ID
  from            QUOTES_LINE_ITEMS
  left outer join QUOTES_CONTACTS                   QUOTES_CONTACTS
               on QUOTES_CONTACTS.QUOTE_ID        = QUOTES_LINE_ITEMS.QUOTE_ID
              and QUOTES_CONTACTS.DELETED         = 0
  left outer join CONTACTS
               on CONTACTS.ID                     = QUOTES_CONTACTS.CONTACT_ID
              and CONTACTS.DELETED                = 0
 where QUOTES_LINE_ITEMS.DELETED = 0

GO

Grant Select on dbo.vwQUOTES_LINE_ITEMS_CONTACTS to public;
GO

