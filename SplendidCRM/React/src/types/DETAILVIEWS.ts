/*
 * Copyright (C) 2005-2023 SplendidCRM Software, Inc. All rights reserved.
 *
 * Any use of the contents of this file are subject to the SplendidCRM Professional Source Code License 
 * Agreement, or other written agreement between you and SplendidCRM ("License"). By installing or 
 * using this file, you have unconditionally agreed to the terms and conditions of the License, 
 * including but not limited to restrictions on the number of users therein, and you may not use this 
 * file except in compliance with the License. 
 * 
 */

// 1. React and fabric. 
// 2. Store and Types. 
// 3. Scripts. 

export default interface DETAILVIEWS
{
	ID                            : string ;  // uniqueidentifier
	NAME                          : string ;  // nvarchar
	MODULE_NAME                   : string ;  // nvarchar
	VIEW_NAME                     : string ;  // nvarchar
	LABEL_WIDTH                   : string ;  // nvarchar
	FIELD_WIDTH                   : string ;  // nvarchar
	SCRIPT                        : string ;  // nvarchar
	DATA_COLUMNS                  : number ;  // int
	PRE_LOAD_EVENT_ID             : string ;  // uniqueidentifier
	PRE_LOAD_EVENT_NAME           : string ;  // nvarchar
	POST_LOAD_EVENT_ID            : string ;  // uniqueidentifier
	POST_LOAD_EVENT_NAME          : string ;  // nvarchar
}

