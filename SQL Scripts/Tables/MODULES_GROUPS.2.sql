
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
-- 02/18/2010 Paul.  The MODULES_GROUPS table is a system table and should not be audited. 
if exists (select * from sys.objects where name = 'trMODULES_GROUPS_Ins_AUDIT' and type = 'TR') begin -- then
	print 'drop trigger dbo.trMODULES_GROUPS_Ins_AUDIT';
	drop trigger dbo.trMODULES_GROUPS_Ins_AUDIT;
end -- if;

if exists (select * from sys.objects where name = 'trMODULES_GROUPS_Upd_AUDIT' and type = 'TR') begin -- then
	print 'drop trigger dbo.trMODULES_GROUPS_Upd_AUDIT';
	drop trigger dbo.trMODULES_GROUPS_Upd_AUDIT;
end -- if;

if exists(select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'MODULES_GROUPS_AUDIT') begin -- then
	print 'drop table dbo.MODULES_GROUPS_AUDIT';
	drop table dbo.MODULES_GROUPS_AUDIT;
end -- if;

-- 09/24/2009 Paul.  The new Silverlight charts exceeded the control name length of 50. 
if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'MODULES_GROUPS' and COLUMN_NAME = 'CONTROL_NAME' and CHARACTER_MAXIMUM_LENGTH < 100) begin -- then
	print 'alter table MODULES_GROUPS alter column CONTROL_NAME nvarchar(100) not null';
	alter table MODULES_GROUPS alter column CONTROL_NAME nvarchar(100) not null;
end -- if;
GO

-- 02/24/2010 Paul.  We need to specify an order to the modules for the tab menu. 
if not exists(select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'MODULES_GROUPS' and COLUMN_NAME = 'MODULE_ORDER') begin -- then
	print 'alter table MODULES_GROUPS add MODULE_ORDER int null';
	alter table MODULES_GROUPS add MODULE_ORDER int null;
end -- if;
GO

-- 02/24/2010 Paul.  We need to specify an order to the modules for the tab menu. 
if not exists(select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'MODULES_GROUPS' and COLUMN_NAME = 'MODULE_MENU') begin -- then
	print 'alter table MODULES_GROUPS add MODULE_MENU bit null';
	alter table MODULES_GROUPS add MODULE_MENU bit null;
end -- if;
GO

