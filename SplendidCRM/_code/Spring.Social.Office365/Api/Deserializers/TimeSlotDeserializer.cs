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

namespace Spring.Social.Office365.Api.Impl.Json
{
	class TimeSlotDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			TimeSlot obj = new TimeSlot();
			JsonValue End             = json.GetValue                    ("end"           );
			JsonValue Start           = json.GetValue                    ("start"         );
			JsonValue AdditionalData  = json.GetValue                    ("additionalData");
			if ( End            != null && !End           .IsNull && End           .IsObject ) obj.End            = mapper.Deserialize<DateTimeTimeZone>(End           );
			if ( Start          != null && !Start         .IsNull && Start         .IsObject ) obj.Start          = mapper.Deserialize<DateTimeTimeZone>(Start         );
			if ( AdditionalData != null && !AdditionalData.IsNull && AdditionalData.IsObject ) obj.AdditionalData = mapper.Deserialize<AdditionalData  >(AdditionalData);
			return obj;
		}
	}
}
