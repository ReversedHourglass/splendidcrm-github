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

namespace SplendidCRM.Administration.Tags
{
	/// <summary>
	///		Summary description for ListView.
	/// </summary>
	public class ListView : SplendidControl
	{
		protected _controls.HeaderButtons ctlModuleHeader;
		protected _controls.CheckAll     ctlCheckAll    ;

		protected DataView      vwMain         ;
		protected SplendidGrid  grdMain        ;
		protected Label         lblError       ;
		protected PlaceHolder   plcSearch      ;
		protected SearchControl ctlSearch      ;
		protected MassUpdate    ctlMassUpdate  ;
		protected Panel         pnlMassUpdateSeven;

		protected void Page_Command(object sender, CommandEventArgs e)
		{
			try
			{
				if ( e.CommandName == "Clear" )
				{
					ctlSearch.ClearForm();
					Server.Transfer("default.aspx");
				}
				else if ( e.CommandName == "Search" )
				{
					grdMain.CurrentPageIndex = 0;
					grdMain.ApplySort();
					grdMain.DataBind();
				}
				else if ( e.CommandName == "SelectAll" )
				{
					ctlCheckAll.SelectAll(vwMain, "ID");
					grdMain.DataBind();
				}
				else if ( e.CommandName == "Tags.Delete" )
				{
					Guid gID = Sql.ToGuid(e.CommandArgument);
					SqlProcs.spTAGS_Delete(gID);
					grdMain.CurrentPageIndex = 0;
					grdMain.ApplySort();
					grdMain.DataBind();
					Response.Redirect("default.aspx");
				}
				else if ( e.CommandName == "ToggleMassUpdate" )
				{
					pnlMassUpdateSeven.Visible = !pnlMassUpdateSeven.Visible;
				}
				else if ( e.CommandName == "MassDelete" )
				{
					string[] arrID = ctlCheckAll.SelectedItemsArray;
					if ( arrID != null )
					{
						string sIDs = Utils.ValidateIDs(arrID);
						if ( !Sql.IsEmptyString(sIDs) )
						{
							SqlProcs.spTAGS_MassDelete(sIDs);
							Response.Redirect("default.aspx");
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

		private void Page_Load(object sender, System.EventArgs e)
		{
			SetPageTitle(L10n.Term(m_sMODULE + ".LBL_LIST_FORM_TITLE"));
			this.Visible = (SplendidCRM.Security.AdminUserAccess(m_sMODULE, "list") >= 0);
			if ( !this.Visible )
			{
				Parent.DataBind();
				return;
			}

			try
			{
				DbProviderFactory dbf = DbProviderFactories.GetFactory();
				using ( IDbConnection con = dbf.CreateConnection() )
				{
					string sSQL;
					sSQL = "select *           " + ControlChars.CrLf
					     + "  from vwTAGS_List " + ControlChars.CrLf
					     + " where 1 = 1       " + ControlChars.CrLf;
					using ( IDbCommand cmd = con.CreateCommand() )
					{
						cmd.CommandText = sSQL;
						ctlSearch.SqlSearchClause(cmd);

						if ( bDebug )
							RegisterClientScriptBlock("SQLCode", Sql.ClientScriptBlock(cmd));

						using ( DbDataAdapter da = dbf.CreateDataAdapter() )
						{
							((IDbDataAdapter)da).SelectCommand = cmd;
							using ( DataTable dt = new DataTable() )
							{
								da.Fill(dt);
								vwMain = dt.DefaultView;
								grdMain.DataSource = vwMain ;
								if ( !IsPostBack )
								{
									if ( String.IsNullOrEmpty(grdMain.SortColumn) )
									{
										grdMain.SortColumn = "NAME";
										grdMain.SortOrder  = "asc" ;
									}
									grdMain.ApplySort();
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
			if ( !IsPostBack )
			{
				// 06/09/2006 Paul.  Remove data binding in the user controls.  Binding is required, but only do so in the ASPX pages. 
				//Page.DataBind();
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
			ctlMassUpdate.Command += new CommandEventHandler(Page_Command);
			ctlCheckAll  .Command += new CommandEventHandler(Page_Command);
			m_sMODULE = "Tags";
			SetMenu(m_sMODULE);
			this.AppendGridColumns(grdMain, m_sMODULE + "." + LayoutListView);
			ctlSearch = (SearchControl) LoadControl("SearchBasic.ascx");
			plcSearch.Controls.Add(ctlSearch);
			ctlSearch.Command += new CommandEventHandler(Page_Command);
			
			if ( SplendidDynamic.StackedLayout(Page.Theme) )
			{
				ctlModuleHeader.Command += new CommandEventHandler(Page_Command);
				ctlModuleHeader.AppendButtons(m_sMODULE + "." + LayoutListView, Guid.Empty, null);
				grdMain.IsMobile       = this.IsMobile;
				grdMain.MassUpdateView = m_sMODULE + ".MassUpdate";
				grdMain.Command       += new CommandEventHandler(Page_Command);
				if ( !IsPostBack )
					pnlMassUpdateSeven.Visible = false;
			}
		}
		#endregion
	}
}
