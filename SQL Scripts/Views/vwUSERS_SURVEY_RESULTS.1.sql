if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwUSERS_SURVEY_RESULTS')
	Drop View dbo.vwUSERS_SURVEY_RESULTS;
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
-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
-- 09/12/2019 Paul.  React Client requires a name field. 
Create View dbo.vwUSERS_SURVEY_RESULTS
as
select SURVEY_RESULTS.ID
     , SURVEY_RESULTS.DATE_MODIFIED
     , SURVEY_RESULTS.START_DATE
     , SURVEY_RESULTS.SUBMIT_DATE
     , SURVEY_RESULTS.IS_COMPLETE
     , SURVEY_RESULTS.IP_ADDRESS
     , SURVEY_RESULTS.USER_AGENT
     , SURVEY_RESULTS.ID           as SURVEY_RESULT_ID
     , SURVEYS.ID                  as SURVEY_ID
     , SURVEYS.NAME                as SURVEY_NAME
     , SURVEYS.ASSIGNED_USER_ID    as SURVEY_ASSIGNED_USER_ID
     , SURVEYS.ASSIGNED_SET_ID     as SURVEY_ASSIGNED_SET_ID
     , USERS.ID                    as USER_ID
     , dbo.fnFullName(USERS.FIRST_NAME, USERS.LAST_NAME) as USER_NAME
     , SURVEYS.NAME                as NAME
  from            SURVEY_RESULTS
       inner join SURVEYS
               on SURVEYS.ID       = SURVEY_RESULTS.SURVEY_ID
              and SURVEYS.DELETED  = 0
       inner join USERS
               on USERS.ID         = SURVEY_RESULTS.PARENT_ID
              and USERS.DELETED    = 0
 where SURVEY_RESULTS.DELETED = 0

GO

Grant Select on dbo.vwUSERS_SURVEY_RESULTS to public;
GO


