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
-- 02/17/2018 Paul.  Add ARCHIVE_RULE_ID. 
-- drop table MODULES_ARCHIVE_LOG;
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'MODULES_ARCHIVE_LOG' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.MODULES_ARCHIVE_LOG';
	Create Table dbo.MODULES_ARCHIVE_LOG
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_MODULES_ARCHIVE_LOG primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())
		, MODIFIED_USER_ID                   uniqueidentifier null
		, DATE_MODIFIED                      datetime not null default(getdate())
		, DATE_MODIFIED_UTC                  datetime null default(getutcdate())

		, MODULE_NAME                        nvarchar(25) null
		, TABLE_NAME                         nvarchar(50) null
		, ARCHIVE_RULE_ID                    uniqueidentifier null
		, ARCHIVE_ACTION                     nvarchar(25) null
		, ARCHIVE_TOKEN                      varchar(255) null
		, ARCHIVE_RECORD_ID                  uniqueidentifier null
		)

	create index IDX_MODULES_ARCHIVE_LOG on dbo.MODULES_ARCHIVE_LOG (MODULE_NAME, ARCHIVE_ACTION)
	create index IDX_MODULES_ARCHIVE_LOG_ACTION on dbo.MODULES_ARCHIVE_LOG (ARCHIVE_ACTION, MODULE_NAME)
  end
GO

