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
using Google.Apis.Util;

namespace Google.Apis.Contacts.v3
{
	public class GroupsResource
	{
		private const string Resource = "groups";

		private readonly Google.Apis.Services.IClientService service;

		public GroupsResource(Google.Apis.Services.IClientService service)
		{
			this.service = service;
		}

		#region DeleteRequest
		public DeleteRequest Delete(string group)
		{
			return new DeleteRequest( service, group );
		}

		// 09/12/2015 Paul.  Use new class that specifically allows * as ETag. 
		public class DeleteRequest : ContactsBaseServiceRequest<string>
		{
			public DeleteRequest(Google.Apis.Services.IClientService service, string group) : base( service )
			{
				Group = group;
				InitParameters();
				// 09/11/2015 Paul.  Need to find a way to set If-Match: * header, otherwise we get "Missing resource version ID" error. 
				// We cannot use Body as that too will generate an error. 
				this.ETag = "*";
			}

			[RequestParameterAttribute( "group", RequestParameterType.Path )] public string Group { get; private set; }

			public override string MethodName { get { return "delete"; } }
			public override string HttpMethod { get { return "DELETE"; } }
			public override string RestPath   { get { return "groups/default/base/{group}"; } }

			protected override void InitParameters()
			{
				base.InitParameters();
				RequestParameters.Add("group", new Google.Apis.Discovery.Parameter { Name = "group", IsRequired = true, ParameterType = "path", DefaultValue = null, Pattern = null } );
			}
		}
		#endregion

		#region GetRequest
		public GetRequest Get(string group)
		{
			return new GetRequest( service, group );
		}

		public class GetRequest : ContactsBaseServiceRequest<Google.Apis.Contacts.v3.Data.GroupEntry>
		{
			public GetRequest(Google.Apis.Services.IClientService service, string group) : base( service )
			{
				Group = group;
				InitParameters();
			}

			[RequestParameterAttribute( "group", RequestParameterType.Path )] public string Group { get; private set; }

			public override string MethodName { get { return "get"; } }
			public override string HttpMethod { get { return "GET"; } }
			public override string RestPath   { get { return "groups/default/full/{group}"; } }

			protected override void InitParameters()
			{
				base.InitParameters();
				RequestParameters.Add("group", new Google.Apis.Discovery.Parameter { Name = "group", IsRequired = true, ParameterType = "path", DefaultValue = null, Pattern = null } );
			}
		}
		#endregion

		#region InsertRequest
		public InsertRequest Insert(Google.Apis.Contacts.v3.Data.GroupEntry body)
		{
			return new InsertRequest( service, body );
		}

		public class InsertRequest : ContactsBaseServiceRequest<Google.Apis.Contacts.v3.Data.GroupEntry>
		{
			public InsertRequest(Google.Apis.Services.IClientService service, Google.Apis.Contacts.v3.Data.GroupEntry body) : base( service )
			{
				Body = body;
				InitParameters();
			}

			Data.GroupEntry Body { get; set; }

			protected override object GetBody()
			{
				return Body;
			}

			public override string MethodName { get { return "insert"; } }
			public override string HttpMethod { get { return "POST"  ; } }
			public override string RestPath   { get { return "groups/default/base"; } }

			protected override void InitParameters()
			{
				base.InitParameters();
			}
		}
		#endregion

		#region ListRequest
		public ListRequest List()
		{
			return new ListRequest( service );
		}

		public class ListRequest : ContactsBaseServiceRequest<Google.Apis.Contacts.v3.Data.Groups>
		{
			public ListRequest(Google.Apis.Services.IClientService service) : base( service )
			{
				InitParameters();
			}

			#region Query Parameters
			[RequestParameterAttribute("showdeleted", RequestParameterType.Query)] public System.Nullable<bool> ShowDeleted { get; set; }
			[RequestParameterAttribute("updated-min", RequestParameterType.Query)] public string                UpdatedMin  { get; set; }
			[RequestParameterAttribute("max-results", RequestParameterType.Query)] public System.Nullable<long> MaxResults  { get; set; }
			[RequestParameterAttribute("start-index", RequestParameterType.Query)] public string                StartIndex  { get; set; }
			[RequestParameterAttribute("sortorder"  , RequestParameterType.Query)] public string                SortOrder   { get; set; }
			[RequestParameterAttribute("orderby"    , RequestParameterType.Query)] public string                OrderBy     { get; set; }
			[RequestParameterAttribute("q"          , RequestParameterType.Query)] public string                Query       { get; set; }
			#endregion

			public override string MethodName { get { return "list"               ; } }
			public override string HttpMethod { get { return "GET"                ; } }
			public override string RestPath   { get { return "groups/default/full"; } }

			protected override void InitParameters()
			{
				base.InitParameters();
				// https://developers.google.com/google-apps/contacts/v3/reference#contacts-query-parameters-reference
				// https://code.google.com/p/google-gdata/source/browse/trunk/clients/cs/src/gcontacts/contactquery.cs
				/// The ContactsQuery supports the following GData parameters:
				/// Name              Description
				/// alt               The type of feed to return, such as atom (the default), rss, or json.
				/// max-results       The maximum number of entries to return. If you want to receive all of
				///                   the contacts, rather than only the default maximum, you can specify a very 
				///                   large number for max-results.
				/// start-index       The 1-based index of the first result to be retrieved (for paging).
				/// updated-min       The lower bound on entry update dates.
				/// 
				/// For more information about the standard parameters, see the Google Data APIs protocol reference document.
				/// In addition to the standard query parameters, the Contacts Data API supports the following parameters:
				/// 
				/// Name              Description
				/// orderby           Sorting criterion. The only supported value is lastmodified.
				/// showdeleted       Include deleted contacts in the returned contacts feed. 
				///                   Deleted contacts are shown as entries that contain nothing but an 
				///                   atom:id element and a gd:deleted element. 
				///                   (Google retains placeholders for deleted contacts for 30 days after 
				///                   deletion; during that time, you can request the placeholders 
				///                   using the showdeleted query parameter.) Valid values are true or false.
				/// sortorder         Sorting order direction. Can be either ascending or descending.
				/// group             Constrains the results to only the contacts belonging to the group specified. 
				///                   Value of this parameter specifies group ID (see also: gContact:groupMembershipInfo).
				RequestParameters.Add("q"          , new Google.Apis.Discovery.Parameter { Name = "query"      , IsRequired = false, ParameterType = "query", DefaultValue = null, Pattern = null } );
				RequestParameters.Add("max-results", new Google.Apis.Discovery.Parameter { Name = "maxResults" , IsRequired = false, ParameterType = "query", DefaultValue = null, Pattern = null } );
				RequestParameters.Add("start-index", new Google.Apis.Discovery.Parameter { Name = "startIndex" , IsRequired = false, ParameterType = "query", DefaultValue = null, Pattern = null } );
				RequestParameters.Add("updated-min", new Google.Apis.Discovery.Parameter { Name = "updatedMin" , IsRequired = false, ParameterType = "query", DefaultValue = null, Pattern = null } );
				// The only supported oderby value is lastmodified. 
				RequestParameters.Add("orderby"    , new Google.Apis.Discovery.Parameter { Name = "orderBy"    , IsRequired = false, ParameterType = "query", DefaultValue = null, Pattern = null } );
				RequestParameters.Add("showdeleted", new Google.Apis.Discovery.Parameter { Name = "showDeleted", IsRequired = false, ParameterType = "query", DefaultValue = null, Pattern = null } );
				RequestParameters.Add("sortorder"  , new Google.Apis.Discovery.Parameter { Name = "sortOrder"  , IsRequired = false, ParameterType = "query", DefaultValue = null, Pattern = null } );
			}
		}
		#endregion

		#region UpdateRequest
		public UpdateRequest Update(Google.Apis.Contacts.v3.Data.Group body, string group)
		{
			return new UpdateRequest( service, body, group );
		}

		public class UpdateRequest : ContactsBaseServiceRequest<Google.Apis.Contacts.v3.Data.Group>
		{
			public UpdateRequest(Google.Apis.Services.IClientService service, Google.Apis.Contacts.v3.Data.Group body, string group) : base( service )
			{
				Group = group;
				Body = body;
				InitParameters();
			}

			[RequestParameterAttribute( "group", RequestParameterType.Path )] public string Group { get; private set; }

			Data.Group Body { get; set; }

			protected override object GetBody()
			{
				return Body;
			}

			public override string MethodName { get { return "update"; } }
			public override string HttpMethod { get { return "PUT"   ; } }
			public override string RestPath   { get { return "groups/default/full/{group}"; } }

			protected override void InitParameters()
			{
				base.InitParameters();
				RequestParameters.Add("group", new Google.Apis.Discovery.Parameter { Name = "group", IsRequired = true, ParameterType = "path", DefaultValue = null, Pattern = null } );
			}
		}
		#endregion
	}
}

