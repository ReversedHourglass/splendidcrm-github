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
using System.Globalization;
using System.Collections.Generic;
using System.Diagnostics;
using Spring.Json;

namespace Spring.Social.ConstantContact.Api.Impl.Json
{
	class EmailAddressSerializer : IJsonSerializer
	{
		public JsonValue Serialize(object obj, JsonMapper mapper)
		{
			EmailAddress o = obj as EmailAddress;
			
			// 11/11/2019 Paul.  Updated to v3. 
			// https://v3.developer.constantcontact.com/api_reference/index.html#!/Contacts/getContacts
			JsonObject json = new JsonObject();
			if ( o.permission_to_send != null   ) json.AddValue("permission_to_send", new JsonValue(o.permission_to_send));
			if ( o.confirm_status     != null   ) json.AddValue("confirm_status"    , new JsonValue(o.confirm_status    ));
			if ( o.address            != null   ) json.AddValue("address"           , new JsonValue(o.address           ));
			if ( o.opt_in_date        .HasValue ) json.AddValue("opt_in_date"       , new JsonValue(o.opt_in_date       .Value.ToString("yyyy-MM-ddTHH:mm:ss")));
			if ( o.opt_in_source      != null   ) json.AddValue("opt_in_source"     , new JsonValue(o.opt_in_source     ));
			if ( o.opt_out_date       != null   ) json.AddValue("opt_out_date"      , new JsonValue(o.opt_out_date      ));
			if ( o.opt_out_source     != null   ) json.AddValue("opt_out_source"    , new JsonValue(o.opt_out_source    ));
			return json;
		}
	}

	class EmailAddressListSerializer : IJsonSerializer
	{
		public JsonValue Serialize(object obj, JsonMapper mapper)
		{
			IList<EmailAddress> lst = obj as IList<EmailAddress>;
			JsonArray json = new JsonArray();
			if ( lst != null )
			{
				foreach ( EmailAddress o in lst )
				{
					json.AddValue(mapper.Serialize(o));
				}
			}
			return json;
		}
	}
}
