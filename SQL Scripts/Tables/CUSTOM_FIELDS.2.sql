
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
-- 04/21/2008 Paul.  SugarCRM 5.0 does not have some of the core auditing fields. 
-- 05/01/2009 Paul.  SugarCRM 4.5.1 migration requires addition of auditing fields.
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'CUSTOM_FIELDS' and COLUMN_NAME = 'ID') begin -- then
	print 'alter table CUSTOM_FIELDS add ID uniqueidentifier not null default(newid())';
	alter table CUSTOM_FIELDS add ID uniqueidentifier not null default(newid());
	alter table CUSTOM_FIELDS add constraint PK_CUSTOM_FIELDS primary key (ID);
end -- if;
GO

if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'CUSTOM_FIELDS' and COLUMN_NAME = 'CREATED_BY') begin -- then
	print 'alter table CUSTOM_FIELDS alter column CREATED_BY uniqueidentifier null';
	alter table CUSTOM_FIELDS add CREATED_BY uniqueidentifier null;
end -- if;
GO

if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'CUSTOM_FIELDS' and COLUMN_NAME = 'MODIFIED_USER_ID') begin -- then
	print 'alter table CUSTOM_FIELDS alter column MODIFIED_USER_ID uniqueidentifier null';
	alter table CUSTOM_FIELDS add MODIFIED_USER_ID uniqueidentifier null;
end -- if;
GO

if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'CUSTOM_FIELDS' and COLUMN_NAME = 'DATE_ENTERED') begin -- then
	print 'alter table CUSTOM_FIELDS alter column DATE_ENTERED datetime not null default(getdate())';
	alter table CUSTOM_FIELDS add DATE_ENTERED datetime not null default(getdate());
end -- if;
GO


if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'CUSTOM_FIELDS' and COLUMN_NAME = 'DATE_MODIFIED') begin -- then
	print 'alter table CUSTOM_FIELDS alter column DATE_MODIFIED datetime not null default(getdate())';
	alter table CUSTOM_FIELDS add DATE_MODIFIED datetime not null default(getdate());
end -- if;
GO


