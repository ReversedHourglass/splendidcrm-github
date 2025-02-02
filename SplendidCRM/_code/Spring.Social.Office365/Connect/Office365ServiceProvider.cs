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
 * IN NO EVENT SHALL SPLENDIDCRM BE RESPONSIBLE FOR ANY DAMAGES OF ANY KIND, INCLUDING ANY DIRECT, 
 * SPECIAL, PUNITIVE, INDIRECT, INCIDENTAL OR CONSEQUENTIAL DAMAGES.  Other limitations of liability 
 * and disclaimers set forth in the License. 
 * 
 *********************************************************************************************************************/
using System;

using Spring.Social.OAuth2;
using Spring.Social.Office365.Api;
using Spring.Social.Office365.Api.Impl;

namespace Spring.Social.Office365.Connect
{
	public class Office365ServiceProvider : AbstractOAuth2ServiceProvider<IOffice365>
	{
		// 02/04/2023 Paul.  Directory Tenant is now required for single tenant app registrations. 
		public Office365ServiceProvider(string tenantId, string clientId, string clientSecret)
			: base(new Office365OAuth2Template(tenantId, clientId, clientSecret))
		{
		}

		public override IOffice365 GetApi(String accessToken)
		{
			return new Office365Template(accessToken);
		}
	}
}
