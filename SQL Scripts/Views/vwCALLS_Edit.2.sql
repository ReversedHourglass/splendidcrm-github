if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwCALLS_Edit')
	Drop View dbo.vwCALLS_Edit;
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
-- 11/08/2008 Paul.  Move description to base view. 
Create View dbo.vwCALLS_Edit
as
select vwCALLS.*
     , (case when vwCALLS.REMINDER_TIME > 0 then 1 else 0 end) as SHOULD_REMIND
  from            vwCALLS
  left outer join CALLS
               on CALLS.ID = vwCALLS.ID

GO

Grant Select on dbo.vwCALLS_Edit to public;
GO

 
