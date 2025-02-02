if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwACCOUNTS_CREDIT_CARDS')
	Drop View dbo.vwACCOUNTS_CREDIT_CARDS;
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
-- 04/12/2008 Paul.  Oracle requires the base view when using *. 
Create View dbo.vwACCOUNTS_CREDIT_CARDS
as
select ID      as CREDIT_CARD_ID
     , NAME    as CREDIT_CARD_NAME
     , vwCREDIT_CARDS.*
  from vwCREDIT_CARDS

GO

Grant Select on dbo.vwACCOUNTS_CREDIT_CARDS to public;
GO

