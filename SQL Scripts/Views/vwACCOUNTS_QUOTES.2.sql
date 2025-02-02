if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwACCOUNTS_QUOTES')
	Drop View dbo.vwACCOUNTS_QUOTES;
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
-- 05/30/2012 Paul.  Show records when account is billing or shipping. 
-- 05/30/2012 Paul.  Include records when account is parent. 
-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
Create View dbo.vwACCOUNTS_QUOTES
as
select BILLING_ACCOUNT_ID                 as ACCOUNT_ID
     , BILLING_ACCOUNT_NAME               as ACCOUNT_NAME
     , BILLING_ACCOUNT_ASSIGNED_USER_ID   as ACCOUNT_ASSIGNED_USER_ID
     , BILLING_ACCOUNT_ASSIGNED_SET_ID    as ACCOUNT_ASSIGNED_SET_ID
     , vwQUOTES.ID                        as QUOTE_ID
     , vwQUOTES.NAME                      as QUOTE_NAME
     , vwQUOTES.*
  from vwQUOTES
union
select SHIPPING_ACCOUNT_ID                as ACCOUNT_ID
     , SHIPPING_ACCOUNT_NAME              as ACCOUNT_NAME
     , SHIPPING_ACCOUNT_ASSIGNED_USER_ID  as ACCOUNT_ASSIGNED_USER_ID
     , SHIPPING_ACCOUNT_ASSIGNED_SET_ID   as ACCOUNT_ASSIGNED_SET_ID
     , vwQUOTES.ID                        as QUOTE_ID
     , vwQUOTES.NAME                      as QUOTE_NAME
     , vwQUOTES.*
  from vwQUOTES
union
select vwACCOUNTS.PARENT_ID               as ACCOUNT_ID
     , vwACCOUNTS.PARENT_NAME             as ACCOUNT_NAME
     , vwACCOUNTS.PARENT_ASSIGNED_USER_ID as ACCOUNT_ASSIGNED_USER_ID
     , vwACCOUNTS.PARENT_ASSIGNED_SET_ID  as ACCOUNT_ASSIGNED_SET_ID
     , vwQUOTES.ID                        as QUOTE_ID
     , vwQUOTES.NAME                      as QUOTE_NAME
     , vwQUOTES.*
  from      vwQUOTES
 inner join vwACCOUNTS
         on vwACCOUNTS.ID        = vwQUOTES.BILLING_ACCOUNT_ID
union
select vwACCOUNTS.PARENT_ID               as ACCOUNT_ID
     , vwACCOUNTS.PARENT_NAME             as ACCOUNT_NAME
     , vwACCOUNTS.PARENT_ASSIGNED_USER_ID as ACCOUNT_ASSIGNED_USER_ID
     , vwACCOUNTS.PARENT_ASSIGNED_SET_ID  as ACCOUNT_ASSIGNED_SET_ID
     , vwQUOTES.ID                        as QUOTE_ID
     , vwQUOTES.NAME                      as QUOTE_NAME
     , vwQUOTES.*
  from      vwQUOTES
 inner join vwACCOUNTS
         on vwACCOUNTS.ID        = vwQUOTES.SHIPPING_ACCOUNT_ID

GO

Grant Select on dbo.vwACCOUNTS_QUOTES to public;
GO


