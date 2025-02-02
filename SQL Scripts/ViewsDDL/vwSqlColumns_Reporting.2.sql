if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwSqlColumns_Reporting')
	Drop View dbo.vwSqlColumns_Reporting;
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
-- 02/09/2007 Paul.  Use the EDITVIEWS_FIELDS to determine if a column is an enum. 
-- 01/16/2008 Paul.  Simplify conversion to Oracle. 
-- 05/20/2009 Paul.  We need to allow the multiple selection of users. 
-- 05/13/2021 Paul.  Include PARENT_ID. 
Create View dbo.vwSqlColumns_Reporting
as
select ObjectName
     , ColumnName
     , ColumnType
     , ColumnName as NAME
     , ColumnName as DISPLAY_NAME
     , SqlDbType
     , (case 
        when dbo.fnSqlColumns_IsEnum(ObjectName, ColumnName, CsType) = 1 then N'enum'
        else CsType
        end) as CsType
     , colid
  from vwSqlColumns
 where ColumnName not in (N'ID', N'ID_C')
   and (ColumnName not like N'%_ID' or ColumnName in ('PARENT_ID', 'CREATED_BY_ID', 'MODIFIED_USER_ID', 'ASSIGNED_USER_ID', 'TEAM_ID'))

GO

Grant Select on dbo.vwSqlColumns_Reporting to public;
GO


