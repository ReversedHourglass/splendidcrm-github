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
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'SURVEY_RESULTS' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.SURVEY_RESULTS';
	Create Table dbo.SURVEY_RESULTS
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_SURVEY_RESULTS primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())
		, MODIFIED_USER_ID                   uniqueidentifier null
		, DATE_MODIFIED                      datetime not null default(getdate())
		, DATE_MODIFIED_UTC                  datetime null default(getutcdate())

		, SURVEY_ID                          uniqueidentifier not null
		, PARENT_ID                          uniqueidentifier null
		, START_DATE                         datetime null
		, SUBMIT_DATE                        datetime null
		, IS_COMPLETE                        bit null
		, IP_ADDRESS                         nvarchar(100) null
		, USER_AGENT                         nvarchar(255) null
		)

	create index IDX_SURVEY_RESULTS_SURVEY_ID on dbo.SURVEY_RESULTS (SURVEY_ID, PARENT_ID)
	create index IDX_SURVEY_RESULTS_PARENT_ID on dbo.SURVEY_RESULTS (PARENT_ID, SURVEY_ID)
  end
GO


