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

namespace SplendidCRM.Quotes
{
	/// <summary>
	///		Summary description for MyQuotes.
	/// </summary>
	public class MyQuotes : DashletControl
	{
		protected _controls.DashletHeader ctlDashletHeader;
		protected _controls.SearchView    ctlSearchView   ;

		protected UniqueStringCollection arrSelectFields;
		protected DataView      vwMain         ;
		protected SplendidGrid  grdMain        ;
		protected Label         lblError       ;
		protected bool          bShowEditDialog = false;

		protected void Page_Command(object sender, CommandEventArgs e)
		{
			try
			{
				if ( e.CommandName == "Search" )
				{
					bShowEditDialog = true;
					grdMain.CurrentPageIndex = 0;
					Bind(true);
				}
				else if ( e.CommandName == "Refresh" )
				{
					Bind(true);
				}
				else if ( e.CommandName == "Remove" )
				{
					if ( !Sql.IsEmptyString(sDetailView) )
					{
						SqlProcs.spDASHLETS_USERS_InitDisable(Security.USER_ID, sDetailView, m_sMODULE, this.AppRelativeVirtualPath.Substring(0, this.AppRelativeVirtualPath.Length-5));
						SplendidCache.ClearUserDashlets(sDetailView);
						Response.Redirect(Page.AppRelativeVirtualPath + Request.Url.Query);
					}
				}
			}
			catch(Exception ex)
			{
				SplendidError.SystemError(new StackTrace(true).GetFrame(0), ex);
				lblError.Text = ex.Message;
			}
		}

		protected void Bind(bool bBind)
		{
			DbProviderFactory dbf = DbProviderFactories.GetFactory();
			using ( IDbConnection con = dbf.CreateConnection() )
			{
				string sSQL;
				// 11/01/2017 Paul.  Use a module-based flag so that Record Level Security is only enabled when needed. 
				m_sVIEW_NAME = "vwQUOTES_MyList";
				sSQL = "  from " + m_sVIEW_NAME + ControlChars.CrLf;
				using ( IDbCommand cmd = con.CreateCommand() )
				{
					cmd.CommandText = sSQL;
					Security.Filter(cmd, m_sMODULE, "list");
					grdMain.OrderByClause("DATE_QUOTE_EXPECTED_CLOSED", "desc");
					if ( !ctlSearchView.SqlSearchClause(cmd) )
					{
						// 06/23/2018 Paul.  Need to allow multiple users to see the data they are assigned to. 
						if ( Crm.Config.enable_dynamic_assignment() )
							cmd.CommandText += "   and ASSIGNED_SET_LIST like '%" + Security.USER_ID.ToString() + "%'" + ControlChars.CrLf;
						else
							Sql.AppendParameter(cmd, Security.USER_ID, "ASSIGNED_USER_ID", false);
						ListBox lstASSIGNED_USER_ID = ctlSearchView.FindControl("ASSIGNED_USER_ID") as ListBox;
						if ( lstASSIGNED_USER_ID != null )
						{
							Utils.SelectItem(lstASSIGNED_USER_ID, Security.USER_ID.ToString());
						}
					}
					cmd.CommandText = "select " + Sql.FormatSelectFields(arrSelectFields)
					                + Sql.AppendRecordLevelSecurityField(m_sMODULE, "edit", m_sVIEW_NAME)
					                + cmd.CommandText
					                + grdMain.OrderByClause();

					if ( bDebug )
						RegisterClientScriptBlock("vwQUOTES_MyList", Sql.ClientScriptBlock(cmd));

					try
					{
						using ( DbDataAdapter da = dbf.CreateDataAdapter() )
						{
							((IDbDataAdapter)da).SelectCommand = cmd;
							using ( DataTable dt = new DataTable() )
							{
								da.Fill(dt);
								// 03/07/2013 Paul.  Apply business rules to subpanel. 
								this.ApplyGridViewRules(m_sMODULE + ".MyQuotes", dt);
								vwMain = dt.DefaultView;
								grdMain.DataSource = vwMain ;
								if ( bBind )
									grdMain.DataBind();
							}
						}
					}
					catch(Exception ex)
					{
						SplendidError.SystemError(new StackTrace(true).GetFrame(0), ex);
						lblError.Text = ex.Message;
					}
				}
			}
		}

		private void Page_Load(object sender, System.EventArgs e)
		{
			this.Visible = this.Visible && (SplendidCRM.Security.GetUserAccess(m_sMODULE, "list") >= 0);
			if ( !this.Visible )
				return;

			try
			{
				Bind(!IsPostBack);
			}
			catch(Exception ex)
			{
				SplendidError.SystemError(new StackTrace(true).GetFrame(0), ex);
				lblError.Text = ex.Message;
			}
		}

		protected override void OnPreRender(EventArgs e)
		{
			// 06/21/2009 Paul.  We are having an issue with other panels losing pagination information 
			// during a refresh of an alternate panel.
			if ( IsPostBack )
			{
				grdMain.DataBind();
			}
			base.OnPreRender(e);
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
			this.Load                += new System.EventHandler(this.Page_Load);
			ctlDashletHeader.Command += new CommandEventHandler(Page_Command);
			ctlSearchView.Command    += new CommandEventHandler(Page_Command);
			m_sMODULE = "Quotes";
			arrSelectFields = new UniqueStringCollection();
			arrSelectFields.Add("DATE_QUOTE_EXPECTED_CLOSED");
			arrSelectFields.Add("ASSIGNED_USER_ID"          );
			this.AppendGridColumns(grdMain, m_sMODULE + ".MyQuotes", arrSelectFields);
		}
		#endregion
	}
}
