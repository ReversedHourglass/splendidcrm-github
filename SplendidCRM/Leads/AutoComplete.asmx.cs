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
using System.Collections;
using System.Web.Services;
using System.ComponentModel;
using SplendidCRM;

namespace SplendidCRM.Leads
{
	public class Lead
	{
		public Guid    ID  ;
		public string  LAST_NAME;

		public Lead()
		{
			ID   = Guid.Empty  ;
			LAST_NAME = String.Empty;
		}
	}

	/// <summary>
	/// Summary description for AutoComplete
	/// </summary>
	[WebService(Namespace = "http://tempuri.org/")]
	[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
	[System.Web.Script.Services.ScriptService]
	[ToolboxItem(false)]
	public class AutoComplete : System.Web.Services.WebService
	{
		[WebMethod(EnableSession=true)]
		public Lead LEADS_LEAD_LAST_NAME_Get(string sLAST_NAME)
		{
			Lead item = new Lead();
			//try
			{
				if ( !Security.IsAuthenticated() )
					throw(new Exception("Authentication required"));

				SplendidCRM.DbProviderFactory dbf = SplendidCRM.DbProviderFactories.GetFactory();
				using ( IDbConnection con = dbf.CreateConnection() )
				{
					con.Open();
					string sSQL;
					sSQL = "select ID        " + ControlChars.CrLf
					     + "     , LAST_NAME      " + ControlChars.CrLf
					     + "  from vwLEADS" + ControlChars.CrLf;
					using ( IDbCommand cmd = con.CreateCommand() )
					{
						cmd.CommandText = sSQL;
						Security.Filter(cmd, "Leads", "list");
						// 07/12/2010 Paul.  Allow fuzzy searching during AutoComplete. 
						Sql.AppendParameter(cmd, sLAST_NAME, (Sql.ToBoolean(Application["CONFIG.AutoComplete.Contains"]) ? Sql.SqlFilterMode.Contains : Sql.SqlFilterMode.StartsWith), "LAST_NAME");
						// 07/02/2007 Paul.  Sort is important so that the first match is selected. 
						cmd.CommandText += " order by LAST_NAME" + ControlChars.CrLf;
						using ( IDataReader rdr = cmd.ExecuteReader(CommandBehavior.SingleRow) )
						{
							if ( rdr.Read() )
							{
								item.ID   = Sql.ToGuid   (rdr["ID"  ]);
								item.LAST_NAME = Sql.ToString (rdr["LAST_NAME"]);
							}
						}
					}
				}
				if ( Sql.IsEmptyGuid(item.ID) )
				{
					string sCULTURE = Sql.ToString (Session["USER_SETTINGS/CULTURE"]);
					L10N L10n = new L10N(sCULTURE);
					throw(new Exception(L10n.Term("Leads.ERR_LEAD_NOT_FOUND")));
				}
			}
			//catch
			{
				// 02/04/2007 Paul.  Don't catch the exception.  
				// It is a web service, so the exception will be handled properly by the AJAX framework. 
			}
			return item;
		}

		// 03/30/2007 Paul.  Enable sessions so that we can require authentication to access the data. 
		// 03/29/2007 Paul.  In order for AutoComplete to work, the parameter names must be "prefixText" and "count". 
		[WebMethod(EnableSession=true)]
		public string[] LEADS_LEAD_LAST_NAME_List(string prefixText, int count)
		{
			string[] arrItems = new string[0];
			try
			{
				if ( !Security.IsAuthenticated() )
					throw(new Exception("Authentication required"));

				SplendidCRM.DbProviderFactory dbf = SplendidCRM.DbProviderFactories.GetFactory();
				using ( IDbConnection con = dbf.CreateConnection() )
				{
					string sSQL;
					// 10/08/2010 Paul.  Since we are only returning the name, it is useful to return a distinct list. 
					sSQL = "select distinct " + ControlChars.CrLf
					     + "       LAST_NAME" + ControlChars.CrLf
					     + "  from vwLEADS  " + ControlChars.CrLf;
					using ( IDbCommand cmd = con.CreateCommand() )
					{
						cmd.CommandText = sSQL;
						Security.Filter(cmd, "Leads", "list");
						// 07/12/2010 Paul.  Allow fuzzy searching during AutoComplete. 
						Sql.AppendParameter(cmd, prefixText, (Sql.ToBoolean(Application["CONFIG.AutoComplete.Contains"]) ? Sql.SqlFilterMode.Contains : Sql.SqlFilterMode.StartsWith), "LAST_NAME");
						cmd.CommandText += " order by LAST_NAME" + ControlChars.CrLf;
						using ( DbDataAdapter da = dbf.CreateDataAdapter() )
						{
							((IDbDataAdapter)da).SelectCommand = cmd;
							using ( DataTable dt = new DataTable() )
							{
								da.Fill(0, count, dt);
								arrItems = new string[dt.Rows.Count];
								for ( int i=0; i < dt.Rows.Count; i++ )
									arrItems[i] = Sql.ToString(dt.Rows[i]["LAST_NAME"]);
							}
						}
					}
				}
			}
			catch
			{
			}
			return arrItems;
		}

		// 09/03/2009 Paul.  The list can be retrived for the base module, or for a ModulePopup, 
		// so the field name can be NAME or LEAD_NAME. 
		[WebMethod(EnableSession=true)]
		public string[] LEADS_LAST_NAME_List(string prefixText, int count)
		{
			return LEADS_LEAD_LAST_NAME_List(prefixText, count);
		}
	}
}


