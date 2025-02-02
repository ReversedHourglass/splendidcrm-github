if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwCONTACTS_ConstantContact')
	Drop View dbo.vwCONTACTS_ConstantContact;
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
-- 04/28/2015 Paul.  ConstantContact will reject any contact without an email. 
-- 04/28/2015 Paul.  ConstantContact will reject duplicate contacts based on the email uniqueness. 
-- 08/04/2016 Paul.  Email length must be at least 6 characters, otherwise it will be rejected. 
-- 08/17/2016 Paul.  Return the Prospect List Sync IDs as a comma-separated string. 
Create View dbo.vwCONTACTS_ConstantContact
as
select vwCONTACTS.*
     , dbo.fnPROSPECT_LISTS_ConstantContact(vwCONTACTS.ID, N'Contacts') as SYNC_LIST_IDS
  from vwCONTACTS
 where NAME is not null
   and EMAIL1 is not null
   and len(EMAIL1) >= 6
   and EMAIL1 in (select EMAIL1
                    from vwCONTACTS
                   group by EMAIL1
                  having count(*) = 1
                 )

GO

Grant Select on dbo.vwCONTACTS_ConstantContact to public;
GO

