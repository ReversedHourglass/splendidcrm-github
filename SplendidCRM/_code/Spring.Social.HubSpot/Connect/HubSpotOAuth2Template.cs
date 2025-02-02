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
#if NET_4_0 || SILVERLIGHT_5
using System.Threading.Tasks;
#endif
#if SILVERLIGHT
using Spring.Collections.Specialized;
#else
using System.Collections.Specialized;
#endif

using Spring.Rest.Client;
using Spring.Social.OAuth2;
using Spring.Json;
using Spring.Http.Converters.Json;

namespace Spring.Social.HubSpot.Connect
{
	public class HubSpotOAuth2Template : OAuth2Template
	{
		// 09/28/2020 Paul.  Update refresh token url. 
		// https://developers.hubspot.com/docs/api/oauth/tokens#endpoint?spec=GET-/oauth/v1/refresh-tokens/{token}
		public HubSpotOAuth2Template(string clientId, string clientSecret)
			: base(clientId, clientSecret
				, "https://app.hubspot.com/auth/authenticate"
				, "https://api.hubapi.com/oauth/v1/token"
				, true)  // 04/26/2015 Paul.  UseParametersForClientAuthentication so that client_id gets sent. 
		{
		}

#if NET_4_0 || SILVERLIGHT_5
		protected override Task<AccessGrant> PostForAccessGrantAsync(string accessTokenUrl, NameValueCollection request)
		{
			JsonMapper jsonMapper = new JsonMapper();
			jsonMapper.RegisterDeserializer(typeof(RefreshToken), new Spring.Social.HubSpot.Api.Impl.Json.RefreshTokenDeserializer());
			this.RestTemplate.MessageConverters.Add(new SpringJsonHttpMessageConverter(jsonMapper));
			return this.RestTemplate.PostForObjectAsync<RefreshToken>(accessTokenUrl, request)
				.ContinueWith<AccessGrant>(task =>
				{
					// Exeption should bubble up. 
					//if ( task.Status == TaskStatus.RanToCompletion && task.Result != null )
						return new AccessGrant(task.Result.access_token, String.Empty, task.Result.refresh_token, task.Result.expires_in);
				});
		}
#else
#if !SILVERLIGHT
		protected override AccessGrant PostForAccessGrant(string accessTokenUrl, NameValueCollection request)
		{
			NameValueCollection response = this.RestTemplate.PostForObject<NameValueCollection>(accessTokenUrl, request);
			string expires = response["expires"];
			return new AccessGrant(response["access_token"], null, null, expires != null ? new Nullable<int>(Int32.Parse(expires)) : null);
		}
#endif
		protected override RestOperationCanceler PostForAccessGrantAsync(string accessTokenUrl, NameValueCollection request, Action<RestOperationCompletedEventArgs<AccessGrant>> operationCompleted)
		{
			return this.RestTemplate.PostForObjectAsync<NameValueCollection>(accessTokenUrl, request,
				r =>
				{
					if (r.Error == null)
					{
						string expires = r.Response["expires"];
						AccessGrant token = new AccessGrant(r.Response["access_token"], null, null, expires != null ? new Nullable<int>(Int32.Parse(expires)) : null);
						operationCompleted(new RestOperationCompletedEventArgs<AccessGrant>(token, null, false, r.UserState));
					}
					else
					{
						operationCompleted(new RestOperationCompletedEventArgs<AccessGrant>(null, r.Error, r.Cancelled, r.UserState));
					}
				});
		}
#endif
	}
}
