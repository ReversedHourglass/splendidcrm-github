if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'fnKBTAGS_ChildrenXml' and ROUTINE_TYPE = 'FUNCTION')
	Drop Function dbo.fnKBTAGS_ChildrenXml;
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
-- 
Create Function dbo.fnKBTAGS_ChildrenXml(@PARENT_TAG_ID uniqueidentifier)
returns xml
with returns null on null input --, encryption
begin return 
	(select ID                         as '@ID'
	      , TAG_NAME                   as '@TAG_NAME'
	      , PARENT_TAG_ID              as '@PARENT_TAG_ID'
	      , (case when PARENT_TAG_ID = @PARENT_TAG_ID then dbo.fnKBTAGS_ChildrenXml(id) end)
	   from KBTAGS
	  where PARENT_TAG_ID = @PARENT_TAG_ID
	    and DELETED   = 0
	  order by '@TAG_NAME'
	    for xml path('KBTAG'), type
	)
end
GO

Grant Execute on dbo.fnKBTAGS_ChildrenXml to public
GO

