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
using Spring.Json;

namespace Spring.Social.ConstantContact.Api.Impl.Json
{
	class NoteDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			Note obj = new Note();
			
			obj.id              = json.GetValueOrDefault<string   >("id"             );
			obj.created_date    = json.GetValueOrDefault<DateTime?>("created_date"   );
			obj.modified_date   = json.GetValueOrDefault<DateTime?>("modified_date"  );
			obj.note            = json.GetValueOrDefault<string   >("note"           );
			return obj;
		}
	}

	class NoteListDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			IList<Note> items = new List<Note>();
			if ( json != null && json.IsArray )
			{
				foreach ( JsonValue itemValue in json.GetValues() )
				{
					items.Add( mapper.Deserialize<Note>(itemValue) );
				}
			}
			return items;
		}
	}
}
