if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwCONTACTS_OPPORTUNITIES')
	Drop View dbo.vwCONTACTS_OPPORTUNITIES;
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
-- 09/18/2018 Paul.  Include the opportunities in B2C mode. 
Create View dbo.vwCONTACTS_OPPORTUNITIES
as
select CONTACTS.ID               as CONTACT_ID
     , CONTACTS.ASSIGNED_USER_ID as CONTACT_ASSIGNED_USER_ID
     , CONTACTS.ASSIGNED_SET_ID  as CONTACT_ASSIGNED_SET_ID
     , dbo.fnFullName(CONTACTS.FIRST_NAME, CONTACTS.LAST_NAME) as CONTACT_NAME
     , vwOPPORTUNITIES.ID        as OPPORTUNITY_ID
     , vwOPPORTUNITIES.NAME      as OPPORTUNITY_NAME
     , vwOPPORTUNITIES.*
  from           CONTACTS
      inner join OPPORTUNITIES_CONTACTS
              on OPPORTUNITIES_CONTACTS.CONTACT_ID = CONTACTS.ID
             and OPPORTUNITIES_CONTACTS.DELETED    = 0
      inner join vwOPPORTUNITIES
              on vwOPPORTUNITIES.ID                = OPPORTUNITIES_CONTACTS.OPPORTUNITY_ID
 where CONTACTS.DELETED = 0
union
select CONTACTS.ID               as CONTACT_ID
     , CONTACTS.ASSIGNED_USER_ID as CONTACT_ASSIGNED_USER_ID
     , CONTACTS.ASSIGNED_SET_ID  as CONTACT_ASSIGNED_SET_ID
     , dbo.fnFullName(CONTACTS.FIRST_NAME, CONTACTS.LAST_NAME) as CONTACT_NAME
     , vwOPPORTUNITIES.ID        as OPPORTUNITY_ID
     , vwOPPORTUNITIES.NAME      as OPPORTUNITY_NAME
     , vwOPPORTUNITIES.*
  from           CONTACTS
      inner join vwOPPORTUNITIES
              on vwOPPORTUNITIES.B2C_CONTACT_ID = CONTACTS.ID
 where CONTACTS.DELETED = 0


GO

Grant Select on dbo.vwCONTACTS_OPPORTUNITIES to public;
GO


