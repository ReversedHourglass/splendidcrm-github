
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
-- 08/02/2019 Paul.  The React Client will need access to views that require a filter, like CAMPAIGN_ID. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'SYSTEM_REST_TABLES' and COLUMN_NAME = 'REQUIRED_FIELDS') begin -- then
	print 'alter table SYSTEM_REST_TABLES add REQUIRED_FIELDS nvarchar(150) null';
	alter table SYSTEM_REST_TABLES add REQUIRED_FIELDS nvarchar(150) null;
end -- if;
GO

