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

namespace SplendidCRM.Calls
{
	/// <summary>
	///		Summary description for Contacts.
	/// </summary>
	public class Contacts : SubPanelControl
	{
		// 06/03/2015 Paul.  Combine ListHeader and DynamicButtons. 
		protected _controls.SubPanelButtons ctlDynamicButtons;
		protected _controls.SearchView     ctlSearchView    ;
		protected UniqueStringCollection arrSelectFields;
		protected Guid            gID            ;
		protected DataView        vwMain         ;
		protected SplendidGrid    grdMain        ;
		protected HtmlInputHidden txtCONTACT_ID  ;
		// 02/21/2010 Paul.  Controls to manage inline create. 
		protected Button          btnCreateInline   ;
		protected Panel           pnlNewRecordInline;
		// 02/21/2010 Paul.  Make sure to point to the Contacts.NewRecord. 
		protected SplendidCRM.Contacts.NewRecord ctlNewRecord   ;

		protected void Page_Command(object sender, CommandEventArgs e)
		{
			try
			{
				switch ( e.CommandName )
				{
					//case "Contacts.Create":
					//	// 05/31/2007 Paul.  The call will not be the parent of the contact, so pass a call variable. 
					//	Response.Redirect("~/Contacts/edit.aspx?CALL_ID=" + gID.ToString());
					//	break;
					case "Contacts.Edit":
					{
						Guid gCONTACT_ID = Sql.ToGuid(e.CommandArgument);
						Response.Redirect("~/Contacts/edit.aspx?ID=" + gCONTACT_ID.ToString());
						break;
					}
					case "Contacts.Remove":
					{
						Guid gCONTACT_ID = Sql.ToGuid(e.CommandArgument);
						SqlProcs.spCALLS_CONTACTS_Delete(gID, gCONTACT_ID);
						//Response.Redirect("view.aspx?ID=" + gID.ToString());
						// 05/16/2008 Paul.  Instead of redirecting, just rebind the grid and AJAX will repaint. 
						BindGrid();
						break;
					}
					// 02/21/2010 Paul.  Handle new events that hide and show the NewRecord panel. 
					//case "NewRecord.Show":
					case "Contacts.Create":
						// 02/21/2010 Paul.  We are not going to allow inline create on a mobile device. 
						// 02/22/2010 Paul.  We should have a way to turn-off inline editing as it is a performance issue. 
						if ( this.IsMobile || Sql.ToBoolean(Application["CONFIG.disable_editview_inline"]) )
							Response.Redirect("~/" + m_sMODULE + "/edit.aspx?CALL_ID=" + gID.ToString());
						else
						{
							pnlNewRecordInline.Style.Add(HtmlTextWriterStyle.Display, "inline");
							ctlDynamicButtons.HideAll();
						}
						break;
					case "NewRecord.Cancel":
						pnlNewRecordInline.Style.Add(HtmlTextWriterStyle.Display, "none");
						ctlDynamicButtons.ShowAll();
						break;
					case "NewRecord.FullForm":
						Response.Redirect("~/" + m_sMODULE + "/edit.aspx?CALL_ID=" + gID.ToString());
						break;
					case "NewRecord":
						//BindGrid();
						// 02/21/2010 Paul.  Redirect instead of rebind so that the NewRecord form will get cleared. 
						Response.Redirect(Request.RawUrl);
						break;
					// 06/20/2010 Paul.  Add support for SearchView events. Need to rebind inside the clear event. 
					case "Contacts.Search":
						ctlSearchView.Visible = !ctlSearchView.Visible;
						break;
					case "Search":
						break;
					case "Clear":
						BindGrid();
						break;
					case "SortGrid":
						break;
					// 06/07/2015 Paul.  Add support for Preview button. 
					case "Preview":
						if ( Page.Master is SplendidMaster )
						{
							CommandEventArgs ePreview = new CommandEventArgs(e.CommandName, new PreviewData(m_sMODULE, Sql.ToGuid(e.CommandArgument)));
							(Page.Master as SplendidMaster).Page_Command(sender, ePreview);
						}
						break;
					default:
						throw(new Exception("Unknown command: " + e.CommandName));
				}
			}
			catch(Exception ex)
			{
				SplendidError.SystemError(new StackTrace(true).GetFrame(0), ex);
				ctlDynamicButtons.ErrorText = ex.Message;
			}
		}

		protected void BindGrid()
		{
			DbProviderFactory dbf = DbProviderFactories.GetFactory();
			using ( IDbConnection con = dbf.CreateConnection() )
			{
				string sSQL;
				// 04/26/2008 Paul.  Build the list of fields to use in the select clause.
				// 10/05/2017 Paul.  Add Archive relationship view. 
				// 11/01/2017 Paul.  Use a module-based flag so that Record Level Security is only enabled when needed. 
				// 07/01/2018 Paul.  Add ERASED_FIELDS when data privacy enabled. 
				sSQL = "select " + Sql.FormatSelectFields(arrSelectFields)
				     + Sql.AppendRecordLevelSecurityField(m_sMODULE, "edit", m_sVIEW_NAME)
				     + Sql.AppendDataPrivacyField(m_sVIEW_NAME)
				     + "  from " + m_sVIEW_NAME + ControlChars.CrLf;
				using ( IDbCommand cmd = con.CreateCommand() )
				{
					cmd.CommandText = sSQL;
					// 11/27/2006 Paul.  Make sure to filter relationship data based on team access rights. 
					// 10/08/2017 Paul.  Add Archive access right. 
					Security.Filter(cmd, m_sMODULE, (ArchiveViewEnabled() ? "archive" : "list"));
					Sql.AppendParameter(cmd, gID, "CALL_ID");
					// 06/20/2010 Paul.  Allow searching of the subpanel. 
					ctlSearchView.SqlSearchClause(cmd);
					// 04/26/2008 Paul.  Move Last Sort to the database.
					// 10/14/2012 Paul.  Change default sort to Contact Name. 
					cmd.CommandText += grdMain.OrderByClause("CONTACT_NAME", "asc");

					if ( bDebug )
						RegisterClientScriptBlock("vwCALLS_CONTACTS", Sql.ClientScriptBlock(cmd));

					try
					{
						using ( DbDataAdapter da = dbf.CreateDataAdapter() )
						{
							((IDbDataAdapter)da).SelectCommand = cmd;
							using ( DataTable dt = new DataTable() )
							{
								da.Fill(dt);
								// 03/07/2013 Paul.  Apply business rules to subpanel. 
								// 10/05/2017 Paul.  Add Archive relationship view. 
								this.ApplyGridViewRules("Calls." + this.LayoutListView, dt);
								vwMain = dt.DefaultView;
								grdMain.DataSource = vwMain ;
								// 09/05/2005 Paul.  LinkButton controls will not fire an event unless the the grid is bound. 
								// 04/25/2008 Paul.  Enable sorting of sub panel. 
								// 04/26/2008 Paul.  Move Last Sort to the database.
								grdMain.DataBind();
							}
						}
					}
					catch(Exception ex)
					{
						SplendidError.SystemError(new StackTrace(true).GetFrame(0), ex);
						ctlDynamicButtons.ErrorText = ex.Message;
					}
				}
			}
		}

		private void Page_Load(object sender, System.EventArgs e)
		{
			gID = Sql.ToGuid(Request["ID"]);
			Guid gCONTACT_ID = Sql.ToGuid(txtCONTACT_ID.Value);
			if ( !Sql.IsEmptyGuid(gCONTACT_ID) )
			{
				try
				{
					SqlProcs.spCALLS_CONTACTS_Update(gID, gCONTACT_ID, false, String.Empty);
					// 05/16/2008 Paul.  Instead of redirecting, just rebind the grid and AJAX will repaint. 
					//Response.Redirect("view.aspx?ID=" + gID.ToString());
					// 05/16/2008 Paul.  If we are not going to redirect,then we must clear the value. 
					txtCONTACT_ID.Value = String.Empty;
				}
				catch(Exception ex)
				{
					SplendidError.SystemError(new StackTrace(true).GetFrame(0), ex);
					ctlDynamicButtons.ErrorText = ex.Message;
				}
			}
			BindGrid();

			if ( !IsPostBack )
			{
				// 06/09/2006 Paul.  Remove data binding in the user controls.  Binding is required, but only do so in the ASPX pages. 
				//Page.DataBind();
				// 04/28/2008 Paul.  Make use of dynamic buttons. 
				Guid gASSIGNED_USER_ID = Sql.ToGuid(Page.Items["ASSIGNED_USER_ID"]);
				// 10/05/2017 Paul.  Add Archive relationship view. 
				ctlDynamicButtons.AppendButtons("Calls." + this.LayoutListView, gASSIGNED_USER_ID, gID);
				// 02/21/2010 Paul.  The call needs to be initialized when the page first loads. 
				ctlNewRecord.CALL_ID = gID;
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
			ctlDynamicButtons.Command += new CommandEventHandler(Page_Command);
			ctlNewRecord.Command      += new CommandEventHandler(Page_Command);
			// 06/20/2010 Paul.  We need to connect the SearchView command handler, otherwise it will throw an exception. 
			ctlSearchView.Command     += new CommandEventHandler(Page_Command);
			m_sMODULE = "Contacts";
			// 04/26/2008 Paul.  We need to build a list of the fields used by the search clause. 
			arrSelectFields = new UniqueStringCollection();
			arrSelectFields.Add("DATE_ENTERED"         );
			arrSelectFields.Add("CONTACT_ID"           );
			arrSelectFields.Add("ASSIGNED_USER_ID"     );
			arrSelectFields.Add("CALL_ASSIGNED_USER_ID");
			// 11/26/2005 Paul.  Add fields early so that sort events will get called. 
			// 06/07/2015 Paul.  Must include Page_Command in order for Preview to fire. 
			// 10/05/2017 Paul.  Add Archive relationship view. 
			m_sVIEW_NAME = "vwCALLS_CONTACTS";
			if ( ArchiveViewExists() )
				m_sVIEW_NAME = m_sVIEW_NAME + "_ARCHIVE";
			this.LayoutListView = m_sMODULE + (ArchiveView() ? ".ArchiveView" : String.Empty);
			this.AppendGridColumns(grdMain, "Calls." + this.LayoutListView, arrSelectFields, Page_Command);
			// 04/28/2008 Paul.  Make use of dynamic buttons. 
			if ( IsPostBack )
				ctlDynamicButtons.AppendButtons("Calls." + this.LayoutListView, Guid.Empty, Guid.Empty);
		}
		#endregion
	}
}

