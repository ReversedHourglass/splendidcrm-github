if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwZIPCODES')
	Drop View dbo.vwZIPCODES;
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
Create View dbo.vwZIPCODES
as
select ZIPCODES.ID
     , ZIPCODES.NAME
     , ZIPCODES.CITY
     , ZIPCODES.STATE
     , ZIPCODES.COUNTRY
     , ZIPCODES.LONGITUDE
     , ZIPCODES.LATITUDE
     , ZIPCODES.TIMEZONE_ID
     , TIMEZONES.NAME              as TIMEZONE_NAME
     , ZIPCODES.DATE_ENTERED
     , ZIPCODES.DATE_MODIFIED
     , USERS_CREATED_BY.USER_NAME  as CREATED_BY
     , USERS_MODIFIED_BY.USER_NAME as MODIFIED_BY
     , dbo.fnFullName(USERS_CREATED_BY.FIRST_NAME , USERS_CREATED_BY.LAST_NAME ) as CREATED_BY_NAME
     , dbo.fnFullName(USERS_MODIFIED_BY.FIRST_NAME, USERS_MODIFIED_BY.LAST_NAME) as MODIFIED_BY_NAME
  from            ZIPCODES
  left outer join TIMEZONES
               on TIMEZONES.ID         = ZIPCODES.TIMEZONE_ID
  left outer join USERS USERS_CREATED_BY
               on USERS_CREATED_BY.ID  = ZIPCODES.CREATED_BY
  left outer join USERS USERS_MODIFIED_BY
               on USERS_MODIFIED_BY.ID = ZIPCODES.MODIFIED_USER_ID
 where ZIPCODES.DELETED = 0

GO

Grant Select on dbo.vwZIPCODES to public;
GO


