if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'fnLocation' and ROUTINE_TYPE = 'FUNCTION')
	Drop Function dbo.fnLocation;
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
-- 08/17/2010 Paul.  Now that we are using this function in the list views, we need to be more efficient. 
Create Function dbo.fnLocation(@CITY nvarchar(100), @STATE nvarchar(100))
returns nvarchar(200)
as
  begin
	declare @DISPLAY_NAME nvarchar(200);
	if @CITY is null begin -- then
		set @DISPLAY_NAME = @STATE;
	end else if @STATE is null begin -- then
		set @DISPLAY_NAME = @CITY;
	end else begin
		set @DISPLAY_NAME = rtrim(isnull(@CITY, N'') + N', ' + isnull(@STATE, N''));
	end -- if;
	return @DISPLAY_NAME;
  end
GO

Grant Execute on dbo.fnLocation to public
GO

