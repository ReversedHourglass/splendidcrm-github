if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwEMAILS_Inbound')
	Drop View dbo.vwEMAILS_Inbound;
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
-- 05/20/2009 Paul.  When checking for inbound emails, make sure not to filter by deleted, otherwise the email could get imported again. 
-- 07/19/2018 Paul.  We will need to change vwEMAILS_Inbound to allow MESSAGE_ID to be null so we can find Sent Items. 
Create View dbo.vwEMAILS_Inbound
as
select ID
     , MESSAGE_ID
  from EMAILS

GO

Grant Select on dbo.vwEMAILS_Inbound to public;
GO

 
