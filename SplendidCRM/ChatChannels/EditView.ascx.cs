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
using System.Drawing;
using System.Web;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.Diagnostics;

namespace SplendidCRM.ChatChannels
{
	/// <summary>
	///		Summary description for EditView.
	/// </summary>
	public class EditView : SplendidControl
	{
		// 05/31/2015 Paul.  Combine ModuleHeader and DynamicButtons. 
		protected _controls.HeaderButtons  ctlDynamicButtons;
		protected _controls.DynamicButtons ctlFooterButtons ;

		protected Guid            gID                          ;
		protected HtmlTable       tblMain                      ;

		protected void Page_Command(Object sender, CommandEventArgs e)
		{
			if ( e.CommandName == "Save" || e.CommandName == "SaveConcurrency" )
			{
				try
				{
					this.ValidateEditViewFields(m_sMODULE + "." + LayoutEditView);
					this.ApplyEditViewValidationEventRules(m_sMODULE + "." + LayoutEditView);
					if ( Page.IsValid )
					{
						DbProviderFactory dbf = DbProviderFactories.GetFactory();
						using ( IDbConnection con = dbf.CreateConnection() )
						{
							con.Open();
							DataRow   rowCurrent = null;
							DataTable dtCurrent  = new DataTable();
							if ( !Sql.IsEmptyGuid(gID) )
							{
								string sSQL ;
								sSQL = "select *                   " + ControlChars.CrLf
								     + "  from vwCHAT_CHANNELS_Edit" + ControlChars.CrLf;
								using ( IDbCommand cmd = con.CreateCommand() )
								{
									cmd.CommandText = sSQL;
									Security.Filter(cmd, m_sMODULE, "edit");
									Sql.AppendParameter(cmd, gID, "ID", false);
									using ( DbDataAdapter da = dbf.CreateDataAdapter() )
									{
										((IDbDataAdapter)da).SelectCommand = cmd;
										da.Fill(dtCurrent);
										if ( dtCurrent.Rows.Count > 0 )
										{
											rowCurrent = dtCurrent.Rows[0];
											DateTime dtLAST_DATE_MODIFIED = Sql.ToDateTime(ViewState["LAST_DATE_MODIFIED"]);
											if ( Sql.ToBoolean(Application["CONFIG.enable_concurrency_check"])  && (e.CommandName != "SaveConcurrency") && dtLAST_DATE_MODIFIED != DateTime.MinValue && Sql.ToDateTime(rowCurrent["DATE_MODIFIED"]) > dtLAST_DATE_MODIFIED )
											{
												ctlDynamicButtons.ShowButton("SaveConcurrency", true);
												ctlFooterButtons .ShowButton("SaveConcurrency", true);
												throw(new Exception(String.Format(L10n.Term(".ERR_CONCURRENCY_OVERRIDE"), dtLAST_DATE_MODIFIED)));
											}
										}
										else
										{
											gID = Guid.Empty;
										}
									}
								}
							}
							
							this.ApplyEditViewPreSaveEventRules(m_sMODULE + "." + LayoutEditView, rowCurrent);
							using ( IDbTransaction trn = Sql.BeginTransaction(con) )
							{
								try
								{
									SqlProcs.spCHAT_CHANNELS_Update
										( ref gID
										, new DynamicControl(this, rowCurrent, "ASSIGNED_USER_ID").ID
										, new DynamicControl(this, rowCurrent, "NAME"            ).Text
										, new DynamicControl(this, rowCurrent, "PARENT_ID"       ).ID
										, new DynamicControl(this, rowCurrent, "PARENT_TYPE"     ).SelectedValue
										, new DynamicControl(this, rowCurrent, "TEAM_ID"         ).ID
										, new DynamicControl(this, rowCurrent, "TEAM_SET_LIST"   ).Text
										// 05/17/2017 Paul.  Add Tags module. 
										, new DynamicControl(this, rowCurrent, "TAG_SET_NAME"    ).Text
										// 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
										, new DynamicControl(this, rowCurrent, "ASSIGNED_SET_LIST").Text
										, trn
										);
									SqlProcs.spTRACKER_Update
										( Security.USER_ID
										, m_sMODULE
										, gID
										, new DynamicControl(this, rowCurrent, "NAME").Text
										, "save"
										, trn
										);
									trn.Commit();
								}
								catch(Exception ex)
								{
									trn.Rollback();
									SplendidError.SystemError(new StackTrace(true).GetFrame(0), ex);
									ctlDynamicButtons.ErrorText = ex.Message;
									return;
								}
							}
							SplendidCache.ClearChatChannels();
							rowCurrent = Crm.Modules.ItemEdit(m_sMODULE, gID);
							this.ApplyEditViewPostSaveEventRules(m_sMODULE + "." + LayoutEditView, rowCurrent);
						}
						
						if ( !Sql.IsEmptyString(RulesRedirectURL) )
							Response.Redirect(RulesRedirectURL);
						else
							Response.Redirect("view.aspx?ID=" + gID.ToString());
					}
				}
				catch(Exception ex)
				{
					SplendidError.SystemError(new StackTrace(true).GetFrame(0), ex);
					ctlDynamicButtons.ErrorText = ex.Message;
				}
			}
			else if ( e.CommandName == "Cancel" )
			{
				if ( Sql.IsEmptyGuid(gID) )
					Response.Redirect("default.aspx");
				else
					Response.Redirect("view.aspx?ID=" + gID.ToString());
			}
		}

		private void Page_Load(object sender, System.EventArgs e)
		{
			SetPageTitle(L10n.Term(".moduleList." + m_sMODULE));
			this.Visible = (SplendidCRM.Security.GetUserAccess(m_sMODULE, "edit") >= 0);
			if ( !this.Visible )
			{
				Parent.DataBind();
				return;
			}

			try
			{
				gID = Sql.ToGuid(Request["ID"]);
				if ( !IsPostBack )
				{
					Guid gDuplicateID = Sql.ToGuid(Request["DuplicateID"]);
					if ( !Sql.IsEmptyGuid(gID) || !Sql.IsEmptyGuid(gDuplicateID) )
					{
						DbProviderFactory dbf = DbProviderFactories.GetFactory();
						using ( IDbConnection con = dbf.CreateConnection() )
						{
							string sSQL ;
							sSQL = "select *                   " + ControlChars.CrLf
							     + "  from vwCHAT_CHANNELS_Edit" + ControlChars.CrLf;
							using ( IDbCommand cmd = con.CreateCommand() )
							{
								cmd.CommandText = sSQL;
								Security.Filter(cmd, m_sMODULE, "edit");
								if ( !Sql.IsEmptyGuid(gDuplicateID) )
								{
									Sql.AppendParameter(cmd, gDuplicateID, "ID", false);
									gID = Guid.Empty;
								}
								else
								{
									Sql.AppendParameter(cmd, gID, "ID", false);
								}
								con.Open();

								if ( bDebug )
									RegisterClientScriptBlock("SQLCode", Sql.ClientScriptBlock(cmd));

								using ( DbDataAdapter da = dbf.CreateDataAdapter() )
								{
									((IDbDataAdapter)da).SelectCommand = cmd;
									using ( DataTable dtCurrent = new DataTable() )
									{
										da.Fill(dtCurrent);
										if ( dtCurrent.Rows.Count > 0 )
										{
											DataRow rdr = dtCurrent.Rows[0];
											this.ApplyEditViewPreLoadEventRules(m_sMODULE + "." + LayoutEditView, rdr);
											
											// 05/31/2015 Paul.  Combine ModuleHeader and DynamicButtons. 
											ctlDynamicButtons.Title = Sql.ToString(rdr["NAME"]);
											SetPageTitle(L10n.Term(".moduleList." + m_sMODULE) + " - " + ctlDynamicButtons.Title);
											Utils.UpdateTracker(Page, m_sMODULE, gID, ctlDynamicButtons.Title);
											ViewState["ctlDynamicButtons.Title"] = ctlDynamicButtons.Title;

											this.AppendEditViewFields(m_sMODULE + "." + LayoutEditView, tblMain, rdr);
											ctlDynamicButtons.AppendButtons(m_sMODULE + "." + LayoutEditView, Sql.ToGuid(rdr["ASSIGNED_USER_ID"]), rdr);
											ctlFooterButtons .AppendButtons(m_sMODULE + "." + LayoutEditView, Sql.ToGuid(rdr["ASSIGNED_USER_ID"]), rdr);
											TextBox txtNAME = this.FindControl("NAME") as TextBox;
											if ( txtNAME != null )
												txtNAME.Focus();
											ViewState["LAST_DATE_MODIFIED"] = Sql.ToDateTime(rdr["DATE_MODIFIED"]);
											this.ApplyEditViewPostLoadEventRules(m_sMODULE + "." + LayoutEditView, rdr);
										}
										else
										{
											ctlDynamicButtons.AppendButtons(m_sMODULE + "." + LayoutEditView, Guid.Empty, null);
											ctlFooterButtons .AppendButtons(m_sMODULE + "." + LayoutEditView, Guid.Empty, null);
											ctlDynamicButtons.DisableAll();
											ctlFooterButtons .DisableAll();
											ctlDynamicButtons.ErrorText = L10n.Term("ACL.LBL_NO_ACCESS");
										}
									}
								}
							}
						}
					}
					else
					{
						this.AppendEditViewFields(m_sMODULE + "." + LayoutEditView, tblMain, null);
						ctlDynamicButtons.AppendButtons(m_sMODULE + "." + LayoutEditView, Guid.Empty, null);
						ctlFooterButtons .AppendButtons(m_sMODULE + "." + LayoutEditView, Guid.Empty, null);
						TextBox txtNAME = this.FindControl("NAME") as TextBox;
						if ( txtNAME != null )
							txtNAME.Focus();
						this.ApplyEditViewNewEventRules(m_sMODULE + "." + LayoutEditView);
					}
				}
				else
				{
					// 05/31/2015 Paul.  Combine ModuleHeader and DynamicButtons. 
					ctlDynamicButtons.Title = Sql.ToString(ViewState["ctlDynamicButtons.Title"]);
					SetPageTitle(L10n.Term(".moduleList." + m_sMODULE) + " - " + ctlDynamicButtons.Title);
				}
			}
			catch(Exception ex)
			{
				SplendidError.SystemError(new StackTrace(true).GetFrame(0), ex);
				ctlDynamicButtons.ErrorText = ex.Message;
			}
		}

		#region Web Form Designer generated code
		override protected void OnInit(EventArgs e)
		{
			//
			// CODEGEN: This Task is required by the ASP.NET Web Form Designer.
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
			ctlFooterButtons .Command += new CommandEventHandler(Page_Command);
			m_sMODULE = "ChatChannels";
			SetMenu(m_sMODULE);
			if ( IsPostBack )
			{
				this.AppendEditViewFields(m_sMODULE + "." + LayoutEditView, tblMain, null);
				ctlDynamicButtons.AppendButtons(m_sMODULE + "." + LayoutEditView, Guid.Empty, null);
				ctlFooterButtons .AppendButtons(m_sMODULE + "." + LayoutEditView, Guid.Empty, null);
				Page.Validators.Add(new RulesValidator(this));
			}
		}
		#endregion
	}
}
