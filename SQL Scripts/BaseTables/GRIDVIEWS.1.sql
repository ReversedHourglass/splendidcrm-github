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
-- 11/22/2010 Paul.  Add support for Business Rules Framework. 
-- 09/20/2012 Paul.  We need a SCRIPT field that is form specific. 
-- 02/11/2017 Paul.  New index based on missing indexes query. 
-- 02/22/2021 Paul.  The React client needs a way to determine the default sort, besides NAME asc. 
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'GRIDVIEWS' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.GRIDVIEWS';
	Create Table dbo.GRIDVIEWS
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_GRIDVIEWS primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())
		, MODIFIED_USER_ID                   uniqueidentifier null
		, DATE_MODIFIED                      datetime not null default(getdate())
		, DATE_MODIFIED_UTC                  datetime null default(getutcdate())

		, NAME                               nvarchar( 50) not null
		, MODULE_NAME                        nvarchar( 25) not null
		, VIEW_NAME                          nvarchar( 50) not null

		, PRE_LOAD_EVENT_ID                  uniqueidentifier null
		, POST_LOAD_EVENT_ID                 uniqueidentifier null
		, SCRIPT                             nvarchar(max) null

		, SORT_FIELD                         nvarchar(50) null
		, SORT_DIRECTION                     nvarchar(10) null
		)

	create index IDX_GRIDVIEWS_NAME on dbo.GRIDVIEWS (NAME, DELETED)
	-- 02/11/2017 Paul.  New index based on missing indexes query. 
	create index IDX_GRIDVIEWS_DELETED_VIEW on dbo.GRIDVIEWS (DELETED, VIEW_NAME)
  end
GO


