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
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.Diagnostics;

namespace SplendidCRM.CallMarketing
{
	/// <summary>
	///		Summary description for ListView.
	/// </summary>
	public class ListView : SplendidControl
	{
		protected _controls.SearchView   ctlSearchView  ;

		protected UniqueStringCollection arrSelectFields;
		protected DataView      vwMain         ;
		protected SplendidGrid  grdMain        ;
		protected Label         lblError       ;

		protected void Page_Command(object sender, CommandEventArgs e)
		{
			try
			{
				if ( e.CommandName == "Search" )
				{
					grdMain.CurrentPageIndex = 0;
					grdMain.DataBind();
				}
				else if ( e.CommandName == "SortGrid" )
				{
					grdMain.SetSortFields(e.CommandArgument as string[]);
					arrSelectFields.AddFields(grdMain.SortColumn);
				}
			}
			catch(Exception ex)
			{
				SplendidError.SystemError(new StackTrace(true).GetFrame(0), ex);
				lblError.Text = ex.Message;
			}
		}

		private void Page_Load(object sender, System.EventArgs e)
		{
			SetPageTitle(L10n.Term(m_sMODULE + ".LBL_LIST_FORM_TITLE"));
			this.Visible = (SplendidCRM.Security.GetUserAccess(m_sMODULE, "list") >= 0);
			if ( !this.Visible )
				return;

			try
			{
				DbProviderFactory dbf = DbProviderFactories.GetFactory();
				using ( IDbConnection con = dbf.CreateConnection() )
				{
					string sSQL;
					// 11/01/2017 Paul.  Use a module-based flag so that Record Level Security is only enabled when needed. 
					m_sVIEW_NAME = "vwCALL_MARKETING_List";
					sSQL = "  from " + m_sVIEW_NAME + ControlChars.CrLf
					     + " where 1 = 1"           + ControlChars.CrLf;
					using ( IDbCommand cmd = con.CreateCommand() )
					{
						cmd.CommandText = sSQL;
						// 08/28/2012 Paul.  CALL_MARKETING does not have a TEAM_ID or a USER_ASSIGNED_ID, so we cannot use Security.Filter(). 
						grdMain.OrderByClause("DATE_START", "asc");
						ctlSearchView.SqlSearchClause(cmd);
						cmd.CommandText = "select " + Sql.FormatSelectFields(arrSelectFields) 
						                + Sql.AppendRecordLevelSecurityField(m_sMODULE, "edit", m_sVIEW_NAME)
						                + cmd.CommandText
						                + grdMain.OrderByClause();

						if ( bDebug )
							RegisterClientScriptBlock("SQLCode", Sql.ClientScriptBlock(cmd));

						using ( DbDataAdapter da = dbf.CreateDataAdapter() )
						{
							((IDbDataAdapter)da).SelectCommand = cmd;
							using ( DataTable dt = new DataTable() )
							{
								da.Fill(dt);
								this.ApplyGridViewRules(m_sMODULE + "." + LayoutListView, dt);
								
								vwMain = dt.DefaultView;
								grdMain.DataSource = vwMain ;
								if ( !IsPostBack )
								{
									grdMain.DataBind();
								}
							}
						}
					}
				}
			}
			catch(Exception ex)
			{
				SplendidError.SystemError(new StackTrace(true).GetFrame(0), ex);
				lblError.Text = ex.Message;
			}
		}

		#region Web Form Designer generated code
		override protected void OnInit(EventArgs e)
		{
			//
			// CODEGEN: This call is required by the ASP.NET Web Form Designer.
			//
			InitializeComponent();
			base.OnInit(e);
		}
		
		/// <summary>
		///		Required method for Designer support - do not modify
		///		the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{
			this.Load += new System.EventHandler(this.Page_Load);
			ctlSearchView.Command += new CommandEventHandler(Page_Command);
			m_sMODULE = "CallMarketing";
			SetMenu(m_sMODULE);
			arrSelectFields = new UniqueStringCollection();
			arrSelectFields.Add("DATE_START");
			this.AppendGridColumns(grdMain, m_sMODULE + "." + LayoutListView, arrSelectFields);
		}
		#endregion
	}
}

