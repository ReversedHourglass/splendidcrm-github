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
-- 12/23/2013 Paul.  Add SMS_REMINDER_TIME. 
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'CALLS_LEADS' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.CALLS_LEADS';
	Create Table dbo.CALLS_LEADS
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_CALLS_LEADS primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())
		, MODIFIED_USER_ID                   uniqueidentifier null
		, DATE_MODIFIED                      datetime not null default(getdate())
		, DATE_MODIFIED_UTC                  datetime null default(getutcdate())

		, CALL_ID                            uniqueidentifier not null
		, LEAD_ID                            uniqueidentifier not null
		, REQUIRED                           bit null default(1)
		, ACCEPT_STATUS                      nvarchar(25) null default('none')
		, EMAIL_REMINDER_SENT                bit null default(0)
		, SMS_REMINDER_SENT                  bit null default(0)
		)

	create index IDX_CALLS_LEADS_CALL_ID on dbo.CALLS_LEADS (CALL_ID, DELETED, LEAD_ID, ACCEPT_STATUS, EMAIL_REMINDER_SENT, SMS_REMINDER_SENT)
	create index IDX_CALLS_LEADS_LEAD_ID on dbo.CALLS_LEADS (LEAD_ID, DELETED, CALL_ID, ACCEPT_STATUS, EMAIL_REMINDER_SENT, SMS_REMINDER_SENT)

	alter table dbo.CALLS_LEADS add constraint FK_CALLS_LEADS_CALL_ID foreign key ( CALL_ID ) references dbo.CALLS ( ID )
	alter table dbo.CALLS_LEADS add constraint FK_CALLS_LEADS_LEAD_ID foreign key ( LEAD_ID ) references dbo.LEADS ( ID )
  end
GO


