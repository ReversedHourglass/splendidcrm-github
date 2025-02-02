if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spNOTES_ATTACHMENT_Update' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spNOTES_ATTACHMENT_Update;
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
-- 09/15/2009 Paul.  Convert data type to varbinary(max) to support Azure. 
-- 05/12/2017 Paul.  Need to optimize for Azure. ATTACHMENT is null filter is not indexable, so index length field. 
Create Procedure dbo.spNOTES_ATTACHMENT_Update
	( @ID                   uniqueidentifier
	, @ATTACHMENT           varbinary(max)
	)
as
  begin
	set nocount on

	update NOTE_ATTACHMENTS
	   set ATTACHMENT = @ATTACHMENT
	     , ATTACHMENT_LENGTH = datalength(@ATTACHMENT)
	 where ID         = @ID;	
  end
GO
 
Grant Execute on dbo.spNOTES_ATTACHMENT_Update to public;
GO



