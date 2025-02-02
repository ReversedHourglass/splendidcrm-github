if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spPRODUCT_PRODUCT_MassUpdate' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spPRODUCT_PRODUCT_MassUpdate;
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
Create Procedure dbo.spPRODUCT_PRODUCT_MassUpdate
	( @PARENT_ID         uniqueidentifier
	, @MODIFIED_USER_ID  uniqueidentifier
	, @ID_LIST           varchar(8000)
	)
as
  begin
	set nocount on
	
	declare @CHILD_ID     uniqueidentifier;
	declare @CurrentPosR  int;
	declare @NextPosR     int;
	set @CurrentPosR = 1;
	while @CurrentPosR <= len(@ID_LIST) begin -- do
		set @NextPosR = charindex(',', @ID_LIST,  @CurrentPosR);
		if @NextPosR = 0 or @NextPosR is null begin -- then
			set @NextPosR = len(@ID_LIST) + 1;
		end -- if;
		set @CHILD_ID = cast(rtrim(ltrim(substring(@ID_LIST, @CurrentPosR, @NextPosR - @CurrentPosR))) as uniqueidentifier);
		set @CurrentPosR = @NextPosR+1;

		exec dbo.spPRODUCT_PRODUCT_Update @MODIFIED_USER_ID, @PARENT_ID, @CHILD_ID;
	end -- while;
  end
GO
 
Grant Execute on dbo.spPRODUCT_PRODUCT_MassUpdate to public;
GO
 
 
