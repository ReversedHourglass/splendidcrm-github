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
using System.Data;
using System.Data.Common;
//using IBM.Data.DB2;

namespace SplendidCRM
{
	/// <summary>
	/// Summary description for DB2ClientFactory.
	/// </summary>
	public class DB2ClientFactory : DbProviderFactory
	{
		public DB2ClientFactory(string sConnectionString)
			: base( sConnectionString
			      , "IBM.Data.DB2"
			      , "IBM.Data.DB2.DB2Connection" 
			      , "IBM.Data.DB2.DB2Command"    
			      , "IBM.Data.DB2.DB2DataAdapter"
			      , "IBM.Data.DB2.DB2Parameter"  
			      , "IBM.Data.DB2.DB2CommandBuilder"
			      )
		{
		}
	}
}
