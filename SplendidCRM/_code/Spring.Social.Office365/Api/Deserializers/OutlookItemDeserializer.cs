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

namespace Spring.Social.Office365.Api.Impl.Json
{
	class OutlookItemDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			OutlookItem obj = new OutlookItem();
			obj.RawContent = json.ToString();
			//Debug.WriteLine("Spring.Social.Office365.Api.Impl.Json.OutlookItemDeserializer.Deserialize " + obj.RawContent);
			
			try
			{
				// Entity
				obj.Id                           = json.GetValueOrDefault<String>   ("id"                        );
				JsonValue AdditionalData         = json.GetValue                    ("additionalData"            );
				if ( AdditionalData != null && !AdditionalData.IsNull && AdditionalData.IsObject )
					obj.AdditionalData = mapper.Deserialize<AdditionalData>(AdditionalData);
				
				// OutlookItem
				obj.CreatedDateTime              = json.GetValueOrDefault<DateTime?>("createdDateTime"           );
				obj.LastModifiedDateTime         = json.GetValueOrDefault<DateTime?>("lastModifiedDateTime"      );
				obj.ChangeKey                    = json.GetValueOrDefault<String>   ("changeKey"                 );
				JsonValue Categories             = json.GetValue                    ("categories"                );
				if ( Categories != null && !Categories.IsNull && Categories.IsArray )
					obj.Categories  = mapper.Deserialize<IList<String>>(Categories );
			}
			catch(Exception ex)
			{
				System.Diagnostics.Debug.WriteLine(ex.Message);
				System.Diagnostics.Debug.WriteLine(ex.StackTrace);
				throw;
			}
			return obj;
		}
	}

	class OutlookItemListDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			IList<OutlookItem> items = new List<OutlookItem>();
			if ( json != null && json.IsArray )
			{
				foreach ( JsonValue itemValue in json.GetValues() )
				{
					items.Add( mapper.Deserialize<OutlookItem>(itemValue) );
				}
			}
			return items;
		}
	}

	class OutlookItemPaginationDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			OutlookItemPagination pag = new OutlookItemPagination();
			//JsonUtils.FaultCheck(json);
			if ( json != null && !json.IsNull )
			{
				pag.count = json.GetValueOrDefault<int>("@odata.count");
				//Debug.WriteLine("Spring.Social.Office365.Api.Impl.Json.OutlookItemPaginationDeserializer.Deserialize " + json.ToString());
				JsonValue items  = json.GetValue("value");
				if ( items != null && !items.IsNull )
				{
					pag.items = mapper.Deserialize<IList<OutlookItem>>(items);
				}
			}
			return pag;
		}
	}
}
