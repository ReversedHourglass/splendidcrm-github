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
-- 10/28/2009 Paul.  Add UTC date to allow this table to sync. 
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'CASES_BUGS' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.CASES_BUGS';
	Create Table dbo.CASES_BUGS
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_CASES_BUGS primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())
		, MODIFIED_USER_ID                   uniqueidentifier null
		, DATE_MODIFIED                      datetime not null default(getdate())
		, DATE_MODIFIED_UTC                  datetime null default(getutcdate())

		, CASE_ID                            uniqueidentifier not null
		, BUG_ID                             uniqueidentifier not null
		)

	-- 09/10/2009 Paul.  The indexes should be fully covered. 
	create index IDX_CASES_BUGS_CASE_ID on dbo.CASES_BUGS (CASE_ID, DELETED, BUG_ID )
	create index IDX_CASES_BUGS_BUG_ID  on dbo.CASES_BUGS (BUG_ID , DELETED, CASE_ID)

	alter table dbo.CASES_BUGS add constraint FK_CASES_BUGS_CASE_ID foreign key ( CASE_ID ) references dbo.CASES ( ID )
	alter table dbo.CASES_BUGS add constraint FK_CASES_BUGS_BUG_ID  foreign key ( BUG_ID  ) references dbo.BUGS  ( ID )
  end
GO


