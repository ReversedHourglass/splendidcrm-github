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
using System.Runtime.Serialization;
using System.Security.Permissions;

namespace Spring.Social.Office365.Api
{
	[Serializable]
	public class Office365ApiException : SocialException
	{
		private Office365ApiError error;

		public Office365ApiError Error
		{
			get { return this.error; }
		}

		public Office365ApiException(string message, Office365ApiError error)
			: base(message)
		{
			this.error = error;
		}

		public Office365ApiException(string message, Exception innerException)
			: base(message, innerException)
		{
			this.error = Office365ApiError.Unknown;
		}

		protected Office365ApiException(SerializationInfo info, StreamingContext context)
			: base(info, context)
		{
			if (info != null)
			{
				this.error = (Office365ApiError)info.GetValue("Error", typeof(Office365ApiError));
			}
		}

		[SecurityPermission(SecurityAction.Demand, SerializationFormatter = true)]
		public override void GetObjectData(SerializationInfo info, StreamingContext context)
		{
			base.GetObjectData(info, context);
			if (info != null)
			{
				info.AddValue("Error", this.error);
			}
		}
	}
}
