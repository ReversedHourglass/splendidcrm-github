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

namespace SplendidCRM.Reports
{
	/// <summary>
	///		Summary description for ListView.
	/// </summary>
	public class ListView : SplendidControl
	{
		// 06/05/2015 Paul.  Combine ModuleHeader and DynamicButtons. 
		protected _controls.HeaderButtons ctlModuleHeader;
		protected _controls.SearchView   ctlSearchView  ;
		protected _controls.CheckAll     ctlCheckAll    ;
		//protected _controls.ListHeader ctlListHeaderMySaved  ;
		//protected _controls.ListHeader ctlListHeaderPublished;

		protected UniqueStringCollection arrSelectFields;
		protected DataView      vwMySaved        ;
		//protected DataView      vwPublished      ;
		protected SplendidGrid  grdMain          ;
		//protected SplendidGrid  grdPublished     ;
		protected Label         lblError         ;
		protected string        sMODULE_NAME     ;
		protected MassUpdate    ctlMassUpdate  ;
		// 06/06/2015 Paul.  Combine ModuleHeader and DynamicButtons. 
		protected Panel         pnlMassUpdateSeven;
		protected bool          bSchedulerEnabled;
		// 06/17/2017 Paul.  Allow dashboard selection. 
		protected HtmlInputHidden txtREPORT_ID   ;
		protected HtmlInputHidden txtDASHBOARD_ID;
		protected HtmlInputHidden txtCATEGORY    ;
		protected Button          btnAddDashlet  ;

		protected void Page_Command(object sender, CommandEventArgs e)
		{
			try
			{
				switch ( e.CommandName )
				{
					case "SortGrid":
					{
						grdMain.SetSortFields(e.CommandArgument as string[]);
						break;
					}
					case "Search":
					{
						grdMain.CurrentPageIndex = 0;
						grdMain.DataBind();
						break;
					}
					// 11/17/2010 Paul.  Populate the hidden Selected field with all IDs. 
					case "SelectAll":
					{
						ctlCheckAll.SelectAll(vwMySaved, "ID");
						grdMain.DataBind();
						break;
					}
					case "Reports.Create":
					{
						Response.Redirect("edit.aspx");
						break;
					}
					case "Reports.Import":
					{
						Response.Redirect("import.aspx");
						break;
					}
					case "Reports.View":
					{
						Guid gID = Sql.ToGuid(e.CommandArgument);
						Response.Redirect("view.aspx?ID=" + gID.ToString());
						break;
					}
					case "Reports.Publish":
					{
						Guid gID = Sql.ToGuid(e.CommandArgument);
						SqlProcs.spREPORTS_Publish(gID);
						// 01/24/2010 Paul.  Clear the Report List on save. 
						SplendidCache.ClearReports();
						Response.Redirect("default.aspx?MODULE_NAME=" + sMODULE_NAME);
						break;
					}
					case "Reports.Unpublish":
					{
						Guid gID = Sql.ToGuid(e.CommandArgument);
						SqlProcs.spREPORTS_Unpublish(gID);
						// 01/24/2010 Paul.  Clear the Report List on save. 
						SplendidCache.ClearReports();
						Response.Redirect("default.aspx?MODULE_NAME=" + sMODULE_NAME);
						break;
					}
					case "Reports.Delete":
					{
						Guid gID = Sql.ToGuid(e.CommandArgument);
						SqlProcs.spREPORTS_Delete(gID);
						// 01/24/2010 Paul.  Clear the Report List on save. 
						SplendidCache.ClearReports();
						Response.Redirect("default.aspx?MODULE_NAME=" + sMODULE_NAME);
						break;
					}
					case "Reports.AddDashlet":
					{
						if ( !Sql.IsEmptyString(txtREPORT_ID.Value) )
						{
							// 06/17/2017 Paul.  Allow dashboard selection. 
							Guid gID = Sql.ToGuid(txtREPORT_ID.Value);
							Guid gDASHBOARD_ID = Sql.ToGuid(txtDASHBOARD_ID.Value);
							if ( Sql.IsEmptyGuid(gDASHBOARD_ID) )
							{
								if ( !Sql.ToString(Application["Modules.Home.RelativePath"]).ToLower().Contains("/html5") )
								{
									string sDetailView = txtCATEGORY.Value;
									if ( Sql.IsEmptyString(sDetailView) )
										sDetailView = "Home.DetailView.Body";
									SqlProcs.spDASHLETS_USERS_AddReport(Security.USER_ID, sDetailView, gID);
									SplendidCache.ClearUserDashlets(sDetailView);
								}
								else
								{
									SqlProcs.spDASHBOARDS_PANELS_AddReport(Security.USER_ID, Security.TEAM_ID, gDASHBOARD_ID, txtCATEGORY.Value, gID);
								}
							}
							else
							{
								SqlProcs.spDASHBOARDS_PANELS_AddReport(Security.USER_ID, Security.TEAM_ID, gDASHBOARD_ID, txtCATEGORY.Value, gID);
							}
							txtREPORT_ID.Value    = String.Empty;
							txtDASHBOARD_ID.Value = String.Empty;
							txtCATEGORY.Value     = String.Empty;
						}
						break;
					}
					// 06/06/2015 Paul.  Change standard MassUpdate command to a command to toggle visibility. 
					case "ToggleMassUpdate":
					{
						pnlMassUpdateSeven.Visible = !pnlMassUpdateSeven.Visible;
						break;
					}
					case "MassUpdate":
					{
						// 10/24/2010 Paul.  Add ability to mass update Team and Assigned User. 
						// 11/27/2010 Paul.  Use new selected items. 
						string[] arrID = ctlCheckAll.SelectedItemsArray;
						if ( arrID != null )
						{
							System.Collections.Stack stk = Utils.FilterByACL_Stack(m_sMODULE, "edit", arrID, Crm.Modules.TableName(m_sMODULE));
							if ( stk.Count > 0 )
							{
								DbProviderFactory dbf = DbProviderFactories.GetFactory();
								using ( IDbConnection con = dbf.CreateConnection() )
								{
									con.Open();
									using ( IDbTransaction trn = Sql.BeginTransaction(con) )
									{
										try
										{
											while ( stk.Count > 0 )
											{
												string sIDs = Utils.BuildMassIDs(stk);
												// 06/29/2018 Paul.  Placeholders for ASSIGNED_SET_LIST and ASSIGNED_SET_ADD. 
												SqlProcs.spREPORTS_MassUpdate(sIDs, ctlMassUpdate.ASSIGNED_USER_ID, ctlMassUpdate.PRIMARY_TEAM_ID, ctlMassUpdate.TEAM_SET_LIST, ctlMassUpdate.ADD_TEAM_SET, String.Empty, false, trn);
											}
											trn.Commit();
										}
										catch(Exception ex)
										{
											trn.Rollback();
											throw(new Exception(ex.Message, ex.InnerException));
										}
									}
								}
								Response.Redirect("default.aspx");
							}
						}
						break;
					}
					case "MassDelete":
					{
						// 11/27/2010 Paul.  Use new selected items. 
						string[] arrID = ctlCheckAll.SelectedItemsArray;
						if ( arrID != null )
						{
							// 10/26/2007 Paul.  Use a stack to run the update in blocks of under 200 IDs. 
							//string sIDs = Utils.ValidateIDs(arrID);
							System.Collections.Stack stk = Utils.FilterByACL_Stack(m_sMODULE, "delete", arrID, Crm.Modules.TableName(m_sMODULE));
							if ( stk.Count > 0 )
							{
								DbProviderFactory dbf = DbProviderFactories.GetFactory();
								using ( IDbConnection con = dbf.CreateConnection() )
								{
									con.Open();
									// 10/07/2009 Paul.  We need to create our own global transaction ID to support auditing and workflow on SQL Azure, PostgreSQL, Oracle, DB2 and MySQL. 
									using ( IDbTransaction trn = Sql.BeginTransaction(con) )
									{
										try
										{
											while ( stk.Count > 0 )
											{
												Guid gID = Sql.ToGuid(stk.Pop());
												SqlProcs.spREPORTS_Delete(gID, trn);
											}
											trn.Commit();
										}
										catch(Exception ex)
										{
											trn.Rollback();
											throw(new Exception(ex.Message, ex.InnerException));
										}
									}
								}
								Response.Redirect("default.aspx");
							}
						}
						break;
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
			// 06/04/2006 Paul.  Visibility is already controlled by the ASPX page, but it is probably a good idea to skip the load. 
			this.Visible = (SplendidCRM.Security.GetUserAccess(m_sMODULE, "list") >= 0);
			if ( !this.Visible )
				return;
			
			// 06/17/2017 Paul. The button is not calling the callback, so process manually. 
			if ( !Sql.IsEmptyString(txtREPORT_ID.Value) )
			{
				Page_Command(sender, new CommandEventArgs("Reports.AddDashlet", null));
			}
			// 06/17/2010 Paul.  Export access is now embedded. 
			// nACLACCESS_Export = Security.GetUserAccess(m_sMODULE, "export");
			try
			{
				//sMODULE_NAME = Sql.ToString(Request["MODULE_NAME"]);
				//ctlListHeaderMySaved  .Title = ".saved_reports_dom."     + sMODULE_NAME;
				//ctlListHeaderPublished.Title = ".published_reports_dom." + sMODULE_NAME;
				DbProviderFactory dbf = DbProviderFactories.GetFactory();
				using ( IDbConnection con = dbf.CreateConnection() )
				{
					con.Open();
					string sSQL;
					if ( Application["Exists.WORKFLOW"] == null )
					{
						sSQL = "select count(*)               " + ControlChars.CrLf
						     + "  from vwSqlTables            " + ControlChars.CrLf
						     + " where TABLE_NAME = 'WORKFLOW'" + ControlChars.CrLf;
						using ( IDbCommand cmd = con.CreateCommand() )
						{
							cmd.CommandText = sSQL;
							Application["Exists.WORKFLOW"] = (Sql.ToInteger(cmd.ExecuteScalar()) > 0);
						}
					}
					bSchedulerEnabled = Sql.ToBoolean(Application["Exists.WORKFLOW"]);
					// 06/26/2010 Paul.  There are fields dynamically added in the middle of the report, 
					// so we need to hide the Schedule fields based on their position from the last column. 
					grdMain.Columns[grdMain.Columns.Count - 3].Visible = bSchedulerEnabled;
					grdMain.Columns[grdMain.Columns.Count - 2].Visible = bSchedulerEnabled;
					
					m_sVIEW_NAME = "vwREPORTS_List";
					if ( bSchedulerEnabled )
					{
						// 07/12/2010 Paul.  In order to prevent name collisions, use two sub queries. 
						// Failure to use sub queries would result in an error "Ambiguous column name 'NAME'" as the vwWORKFLOWS view also as a NAME field. 
						// 08/19/2010 Paul.  Oracle requires that the table name be specified. 
						// 11/01/2017 Paul.  Use a module-based flag so that Record Level Security is only enabled when needed. 
						// 04/26/2018 Paul.  There could be multiple workflows for a report, so use a join instead of a subquery. 
						sSQL = "select " + m_sVIEW_NAME + ".*    " + ControlChars.CrLf
						     + "     , JOB_INTERVAL        " + ControlChars.CrLf
						     + "     , LAST_RUN            " + ControlChars.CrLf
						     + "     , FAVORITE_RECORD_ID  " + ControlChars.CrLf
						     + Sql.AppendRecordLevelSecurityField(m_sMODULE, "edit", m_sVIEW_NAME)
						     + "  from " + m_sVIEW_NAME + ControlChars.CrLf;
					}
					else
					{
						// 11/01/2017 Paul.  Use a module-based flag so that Record Level Security is only enabled when needed. 
						sSQL = "select " + m_sVIEW_NAME + ".*" + ControlChars.CrLf
						     + "     , null as JOB_INTERVAL" + ControlChars.CrLf
						     + "     , null as LAST_RUN    " + ControlChars.CrLf
						     + "     , FAVORITE_RECORD_ID  " + ControlChars.CrLf
						     + Sql.AppendRecordLevelSecurityField(m_sMODULE, "edit", m_sVIEW_NAME)
						     + "  from " + m_sVIEW_NAME + ControlChars.CrLf;
					}
					using ( IDbCommand cmd = con.CreateCommand() )
					{
						// 03/09/2012 Paul.  Move order default above the search clause. This fixes the failure to remember the last sort. 
						grdMain.OrderByClause("NAME", "asc");

						cmd.CommandText = sSQL;
						// 04/26/2018 Paul.  There could be multiple workflows for a report, so use a join instead of a subquery. 
						if ( bSchedulerEnabled )
						{
							cmd.CommandText += "  left outer join (select JOB_INTERVAL, LAST_RUN, PARENT_ID from vwWORKFLOWS) WORKFLOWS" + ControlChars.CrLf
							                +  "               on WORKFLOWS.PARENT_ID = ID                                             " + ControlChars.CrLf;
						}
						// 03/31/2012 Paul.  Add support for favorites. 
						cmd.CommandText += "  left outer join vwSUGARFAVORITES                                       " + ControlChars.CrLf
						                + "               on vwSUGARFAVORITES.FAVORITE_RECORD_ID = ID               " + ControlChars.CrLf
						                + "              and vwSUGARFAVORITES.FAVORITE_USER_ID   = @FAVORITE_USER_ID" + ControlChars.CrLf;
						Sql.AddParameter(cmd, "@FAVORITE_USER_ID", Security.USER_ID);

						// 06/17/2010 Paul.  Use new Security.Filter() function to apply Team and ACL security rules.
						// 04/24/2018 Paul.  Provide a way to exclude the SavedSearch for areas that are global in nature. 
						Security.Filter(cmd, m_sMODULE, "list", "ASSIGNED_USER_ID", true);
						ctlSearchView.SqlSearchClause(cmd);
						//Sql.AppendParameter(cmd, sMODULE_NAME, "MODULE_NAME");
						// 07/12/2010 Paul.  Order by was being saved, but not applied. 
						cmd.CommandText += grdMain.OrderByClause();

						if ( bDebug )
							RegisterClientScriptBlock("SQLCode", Sql.ClientScriptBlock(cmd));

						// 01/13/2010 Paul.  Allow default search to be disabled. 
						if ( PrintView || IsPostBack || SplendidCRM.Crm.Modules.DefaultSearch(m_sMODULE) )
						{
							using ( DbDataAdapter da = dbf.CreateDataAdapter() )
							{
								((IDbDataAdapter)da).SelectCommand = cmd;
								using ( DataTable dt = new DataTable() )
								{
									da.Fill(dt);
									// 06/18/2006 Paul.  Translate the report type. 
									foreach(DataRow row in dt.Rows)
									{
										row["REPORT_TYPE" ] = L10n.Term(".dom_report_types.", row["REPORT_TYPE"]);
										string sJOB_INTERVAL = Sql.ToString(row["JOB_INTERVAL"]);
										if ( !Sql.IsEmptyString(sJOB_INTERVAL) )
											row["JOB_INTERVAL"] = SchedulerUtils.CronDescription(L10n, sJOB_INTERVAL);
									}

									vwMySaved = new DataView(dt);
									//vwMySaved.RowFilter = "PUBLISHED = 0 and ASSIGNED_USER_ID = '" + Security.USER_ID.ToString() + "'";
									grdMain.DataSource = vwMySaved ;
									/*
									if ( !IsPostBack )
									{
										grdMain.SortColumn = "NAME";
										grdMain.SortOrder  = "asc" ;
										grdMain.ApplySort();
										grdMain.DataBind();
									}
									
									vwPublished = new DataView(dt);
									// 05/18/2006 Paul.  Lets include unassigned so that they don't get lost. 
									vwPublished.RowFilter = "PUBLISHED = 1 or ASSIGNED_USER_ID is null";
									grdPublished.DataSource = vwPublished;
									if ( !IsPostBack )
									{
										grdPublished.SortColumn = "NAME";
										grdPublished.SortOrder  = "asc" ;
										grdPublished.ApplySort();
										grdPublished.DataBind();
									}
									*/
								}
							}
						}
					}
				}
				if ( !IsPostBack )
				{
					// 06/09/2006 Paul.  Remove data binding in the user controls.  Binding is required, but only do so in the ASPX pages. 
					//Page.DataBind();
					// 09/08/2009 Paul.  Let the grid handle the differences between normal and custom paging. 
					// 09/08/2009 Paul.  Bind outside of the existing connection so that a second connect would not get created. 
					grdMain.DataBind();
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
			ctlSearchView  .Command += new CommandEventHandler(Page_Command);
			ctlMassUpdate  .Command += new CommandEventHandler(Page_Command);
			ctlCheckAll    .Command += new CommandEventHandler(Page_Command);
			m_sMODULE = "Reports";
			SetMenu(m_sMODULE);
			arrSelectFields = new UniqueStringCollection();
			// 03/31/2012 Paul.  Add support for favorites. 
			arrSelectFields.Add("FAVORITE_RECORD_ID");
			this.AppendGridColumns(grdMain, m_sMODULE + "." + LayoutListView, arrSelectFields);
			if ( Security.GetUserAccess(m_sMODULE, "delete") < 0 )
				ctlMassUpdate.Visible = false;
			
			// 05/31/2015 Paul.  Combine ModuleHeader and DynamicButtons. 
			if ( SplendidDynamic.StackedLayout(Page.Theme) )
			{
				ctlModuleHeader.Command += new CommandEventHandler(Page_Command);
				ctlModuleHeader.AppendButtons(m_sMODULE + "." + LayoutListView, Guid.Empty, null);
				// 06/05/2015 Paul.  Move MassUpdate buttons to the SplendidGrid. 
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
