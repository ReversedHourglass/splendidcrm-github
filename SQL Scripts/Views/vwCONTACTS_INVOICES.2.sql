if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwCONTACTS_INVOICES')
	Drop View dbo.vwCONTACTS_INVOICES;
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
-- 05/30/2012 Paul.  Include both bill to and ship to contacts. 
-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
Create View dbo.vwCONTACTS_INVOICES
as
select BILLING_CONTACT_ID                as CONTACT_ID
     , BILLING_CONTACT_NAME              as CONTACT_NAME
     , BILLING_CONTACT_ASSIGNED_USER_ID  as CONTACT_ASSIGNED_USER_ID
     , BILLING_CONTACT_ASSIGNED_SET_ID   as CONTACT_ASSIGNED_SET_ID
     , vwINVOICES.ID                     as INVOICE_ID
     , vwINVOICES.NAME                   as INVOICE_NAME
     , vwINVOICES.*
  from vwINVOICES
union
select SHIPPING_CONTACT_ID               as CONTACT_ID
     , SHIPPING_CONTACT_NAME             as CONTACT_NAME
     , SHIPPING_CONTACT_ASSIGNED_USER_ID as CONTACT_ASSIGNED_USER_ID
     , SHIPPING_CONTACT_ASSIGNED_SET_ID  as CONTACT_ASSIGNED_SET_ID
     , vwINVOICES.ID                     as INVOICE_ID
     , vwINVOICES.NAME                   as INVOICE_NAME
     , vwINVOICES.*
  from vwINVOICES

GO

Grant Select on dbo.vwCONTACTS_INVOICES to public;
GO

