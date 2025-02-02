if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwNOTE_ATTACHMENTS_Related')
	Drop View dbo.vwNOTE_ATTACHMENTS_Related;
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
-- 12/21/2007 Paul.  The NOTE_ATTACHMENT will have only one originating parent, and that will be the NOTE_ID. 
-- However, there can be several NOTES that point to the attachment. 
-- The join must therefore use NOTE_ATTACHMENT_ID. 
Create View dbo.vwNOTE_ATTACHMENTS_Related
as
select NOTE_ATTACHMENTS.ID
     , NOTE_ATTACHMENTS.NOTE_ID
     , NOTES.ID                 as RELATED_ID
     , NOTES.NAME               as RELATED_NAME
  from            NOTE_ATTACHMENTS
       inner join NOTES
               on NOTES.NOTE_ATTACHMENT_ID = NOTE_ATTACHMENTS.ID
              and NOTES.DELETED            = 0

GO

Grant Select on dbo.vwNOTE_ATTACHMENTS_Related to public;
GO

