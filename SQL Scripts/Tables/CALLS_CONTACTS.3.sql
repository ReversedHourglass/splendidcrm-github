
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
-- 12/25/2012 Paul.  EMAIL_REMINDER_SENT was moved to relationship table so that it can be applied per recipient. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'CALLS_CONTACTS' and COLUMN_NAME = 'EMAIL_REMINDER_SENT') begin -- then
	print 'alter table CALLS_CONTACTS add EMAIL_REMINDER_SENT bit null default(0)';
	alter table CALLS_CONTACTS add EMAIL_REMINDER_SENT bit null default(0);
	-- 04/27/2014 Paul.  Disable triggers as this is a system change that does not need to be tracked. 
	exec dbo.spSqlTableDisableTriggers 'CALLS_CONTACTS';
	exec('update CALLS_CONTACTS set EMAIL_REMINDER_SENT = 0');
	exec dbo.spSqlTableEnableTriggers 'CALLS_CONTACTS';

	if exists (select * from sys.indexes where name = 'IDX_CALLS_CONTACTS_CALL_ID') begin -- then
		drop index IDX_CALLS_CONTACTS_CALL_ID    on CALLS_CONTACTS;
	end -- if;
	if exists (select * from sys.indexes where name = 'IDX_CALLS_CONTACTS_CONTACT_ID') begin -- then
		drop index IDX_CALLS_CONTACTS_CONTACT_ID on CALLS_CONTACTS;
	end -- if;

	create index IDX_CALLS_CONTACTS_CALL_ID    on dbo.CALLS_CONTACTS (CALL_ID   , DELETED, CONTACT_ID, ACCEPT_STATUS, EMAIL_REMINDER_SENT)
	create index IDX_CALLS_CONTACTS_CONTACT_ID on dbo.CALLS_CONTACTS (CONTACT_ID, DELETED, CALL_ID   , ACCEPT_STATUS, EMAIL_REMINDER_SENT)
end -- if;
GO

if exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'CALLS_CONTACTS_AUDIT') begin -- then
	if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'CALLS_CONTACTS_AUDIT' and COLUMN_NAME = 'EMAIL_REMINDER_SENT') begin -- then
		print 'alter table CALLS_CONTACTS_AUDIT add EMAIL_REMINDER_SENT bit null';
		alter table CALLS_CONTACTS_AUDIT add EMAIL_REMINDER_SENT bit null;
	end -- if;
end -- if;
GO

-- 12/23/2013 Paul.  Add SMS_REMINDER_TIME. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'CALLS_CONTACTS' and COLUMN_NAME = 'SMS_REMINDER_SENT') begin -- then
	print 'alter table CALLS_CONTACTS add SMS_REMINDER_SENT bit null default(0)';
	alter table CALLS_CONTACTS add SMS_REMINDER_SENT bit null default(0);
	-- 04/27/2014 Paul.  Disable triggers as this is a system change that does not need to be tracked. 
	exec dbo.spSqlTableDisableTriggers 'CALLS_CONTACTS';
	exec('update CALLS_CONTACTS set SMS_REMINDER_SENT = 0');
	exec dbo.spSqlTableEnableTriggers 'CALLS_CONTACTS';

	if exists (select * from sys.indexes where name = 'IDX_CALLS_CONTACTS_CALL_ID') begin -- then
		drop index IDX_CALLS_CONTACTS_CALL_ID    on CALLS_CONTACTS;
	end -- if;
	if exists (select * from sys.indexes where name = 'IDX_CALLS_CONTACTS_CONTACT_ID') begin -- then
		drop index IDX_CALLS_CONTACTS_CONTACT_ID on CALLS_CONTACTS;
	end -- if;

	create index IDX_CALLS_CONTACTS_CALL_ID    on dbo.CALLS_CONTACTS (CALL_ID   , DELETED, CONTACT_ID, ACCEPT_STATUS, EMAIL_REMINDER_SENT, SMS_REMINDER_SENT)
	create index IDX_CALLS_CONTACTS_CONTACT_ID on dbo.CALLS_CONTACTS (CONTACT_ID, DELETED, CALL_ID   , ACCEPT_STATUS, EMAIL_REMINDER_SENT, SMS_REMINDER_SENT)
end -- if;
GO

if exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'CALLS_CONTACTS_AUDIT') begin -- then
	if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'CALLS_CONTACTS_AUDIT' and COLUMN_NAME = 'SMS_REMINDER_SENT') begin -- then
		print 'alter table CALLS_CONTACTS_AUDIT add SMS_REMINDER_SENT bit null';
		alter table CALLS_CONTACTS_AUDIT add SMS_REMINDER_SENT bit null;
	end -- if;
end -- if;
GO

-- 04/30/2017 Paul.  Azure recommended index. 
if not exists (select * from sys.indexes where name = 'IDX_CALLS_CONTACTS_EMAIL_SENT') begin -- then
	create nonclustered index IDX_CALLS_CONTACTS_EMAIL_SENT on dbo.CALLS_CONTACTS (DELETED, EMAIL_REMINDER_SENT, CALL_ID) include (ACCEPT_STATUS, CONTACT_ID);
end -- if;
GO

