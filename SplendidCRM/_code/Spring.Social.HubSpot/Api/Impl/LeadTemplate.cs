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
using System.Net;
using System.Collections.Generic;
using System.Collections.Specialized;

using Spring.Json;
using Spring.Http;
using Spring.Rest.Client;

namespace Spring.Social.HubSpot.Api.Impl
{
	class LeadTemplate : ILeadOperations
	{
		protected RestTemplate restTemplate;
		protected int          maxResults  ;

		// 09/26/2020 Paul.  Latest version use bearer tokens. 
		public LeadTemplate(RestTemplate restTemplate)
		{
			this.restTemplate = restTemplate;
			this.maxResults   = 1000        ;
		}

		public virtual IList<HBase> GetModified(DateTime startModifiedDate)
		{
			long lTicks = JsonUtils.ToUnixTicks(startModifiedDate);
			// http://developers.hubspot.com/docs/methods/contacts/get_recently_updated_contacts
			string sURL = "/contacts/v1/lists/recently_updated/contacts/recent";
			// 04/27/2015 Paul.  A Sync-All request will have min date. 
			if ( startModifiedDate == DateTime.MinValue )
				sURL = "/contacts/v1/lists/all/contacts/all";
			// 04/25/2015 Paul.  The documentation says that 100 is the maximum. 
			sURL += "?count=100&propertyMode=value_only&property=vid&property=isDeleted&property=createdate&property=lastmodifieddate";
			LeadPagination pag = this.restTemplate.GetForObject<LeadPagination>(sURL);
			List<HBase> all = new List<HBase>();
			foreach ( Lead lead in pag.items )
			{
				if ( startModifiedDate == DateTime.MinValue || lead.lastmodifieddate > startModifiedDate )
					all.Insert(0, lead);
			}
			while ( pag.hasmore && lTicks > 0 && pag.timeoffset > lTicks )
			{
				string sPagedURL = sURL + "&vidOffset=" + pag.offset + "&timeOffset=" + pag.timeoffset;
				pag = this.restTemplate.GetForObject<LeadPagination>(sPagedURL);
				foreach ( Lead lead in pag.items )
				{
					if ( startModifiedDate == DateTime.MinValue || lead.lastmodifieddate > startModifiedDate )
						all.Insert(0, lead);
				}
			}
			return all;
		}

		public virtual IList<Lead> GetAll(string search)
		{
			string sURL = "/contacts/v1/lists/all/contacts/all?count=100";
			if ( !String.IsNullOrEmpty(search) )
			{
				sURL = "/contacts/v1/search/query?count=100";
				sURL += "&q=" + HttpUtils.UrlEncode(search);
			}
			// 04/25/2015 Paul.  The documentation says that 100 is the maximum. 
			sURL += "&propertyMode=value_only";
			LeadPagination pag = this.restTemplate.GetForObject<LeadPagination>(sURL);
			List<Lead> all = new List<Lead>(pag.items);
			while ( pag.hasmore )
			{
				string sPagedURL = sURL + "&vidOffset=" + pag.offset;
				pag = this.restTemplate.GetForObject<LeadPagination>(sPagedURL);
				foreach ( Lead lead in pag.items )
				{
					all.Add(lead);
				}
			}
			return all;
		}

		public Lead GetByEmail(string email)
		{
			string sURL = "/contacts/v1/contact/email/" + email + "/profile";
			return this.restTemplate.GetForObject<Lead>(sURL);
		}

		// 09/27/2020 Paul.  HubSpot is now using long instead of integers. 
		public Lead GetById(long id)
		{
			string sURL = "/contacts/v1/contact/vid/" + id.ToString() + "/profile";
			return this.restTemplate.GetForObject<Lead>(sURL);
		}

		public Lead Insert(Lead obj)
		{
			string sURL = "/contacts/v1/contact";
			return this.restTemplate.PostForObject<Lead>(sURL, obj);
		}

		public void Update(Lead obj)
		{
			if ( !obj.id.HasValue )
				throw(new Exception("id must not be null during update operation."));
			string sURL = "/contacts/v1/contact/vid/" + obj.id.Value.ToString() + "/profile";
			this.restTemplate.PostForObject<Lead>(sURL, obj);
		}

		public void Delete(long id)
		{
			string sURL = "/contacts/v1/contact/vid/" + id.ToString();
			this.restTemplate.Delete(sURL);
		}
	}
}