if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spPROJECT_MassAssign' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spPROJECT_MassAssign;
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
-- 04/17/2013 Paul.  If the TEAM_ID is updated, then we also need to update TEAM_SET_ID. 
-- 01/30/2019 Paul.  We should be creating the matching custom audit record. 
Create Procedure dbo.spPROJECT_MassAssign
	( @ID_LIST           varchar(8000)
	, @MODIFIED_USER_ID  uniqueidentifier
	, @ASSIGNED_USER_ID  uniqueidentifier
	, @TEAM_ID           uniqueidentifier
	)
as
  begin
	set nocount on
	
	declare @ID            uniqueidentifier;
	declare @TEAM_SET_ID   uniqueidentifier;
	declare @TEAM_SET_LIST varchar(8000);
	declare @CurrentPosR   int;
	declare @NextPosR      int;
	set @CurrentPosR = 1;
	while @CurrentPosR <= len(@ID_LIST) begin -- do
		-- 10/04/2006 Paul.  charindex should not use unicode parameters as it will limit all inputs to 4000 characters. 
		set @NextPosR = charindex(',', @ID_LIST,  @CurrentPosR);
		if @NextPosR = 0 or @NextPosR is null begin -- then
			set @NextPosR = len(@ID_LIST) + 1;
		end -- if;
		set @ID = cast(rtrim(ltrim(substring(@ID_LIST, @CurrentPosR, @NextPosR - @CurrentPosR))) as uniqueidentifier);
		set @CurrentPosR = @NextPosR+1;

		-- 04/17/2013 Paul.  If the TEAM_ID is updated, then we also need to update TEAM_SET_ID. 
		if @TEAM_ID is not null begin -- then
			select @TEAM_SET_LIST = TEAM_SET_LIST
			  from            PROJECT
			  left outer join TEAM_SETS
			               on TEAM_SETS.ID      = PROJECT.TEAM_SET_ID
			              and TEAM_SETS.DELETED = 0
			 where PROJECT.ID = @ID;
			exec dbo.spTEAM_SETS_NormalizeSet @TEAM_SET_ID out, @MODIFIED_USER_ID, @TEAM_ID, @TEAM_SET_LIST;
		end -- if;
		-- BEGIN Oracle Exception
			update PROJECT
			   set MODIFIED_USER_ID  = @MODIFIED_USER_ID 
			     , DATE_MODIFIED     =  getdate()        
			     , DATE_MODIFIED_UTC =  getutcdate()     
			     , ASSIGNED_USER_ID  = @ASSIGNED_USER_ID
			     , TEAM_ID           = isnull(@TEAM_ID, TEAM_ID)
			     , TEAM_SET_ID       = isnull(@TEAM_SET_ID, TEAM_SET_ID)
			 where ID                = @ID
			   and DELETED           = 0;

			-- 01/30/2019 Paul.  We should be creating the matching custom audit record. 
			update PROJECT_CSTM
			   set ID_C              = ID_C
			 where ID_C              = @ID;
		-- END Oracle Exception
	end -- while;
  end
GO
 
Grant Execute on dbo.spPROJECT_MassAssign to public;
GO
 
 
