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

namespace SplendidCRM.Users
{
	/// <summary>
	///		Summary description for Roles.
	/// </summary>
	public class Roles : SplendidControl
	{
		// 06/03/2015 Paul.  Combine ListHeader and DynamicButtons. 
		protected _controls.SubPanelButtons ctlDynamicButtons;
		protected UniqueStringCollection arrSelectFields;
		protected Guid            gID            ;
		protected DataView        vwMain         ;
		protected SplendidGrid    grdMain        ;
		protected HtmlInputHidden txtROLE_ID     ;
		protected bool            bMyAccount     ;

		public bool MyAccount
		{
			get
			{
				return bMyAccount;
			}
			set
			{
				bMyAccount = value;
			}
		}

		protected void Page_Command(object sender, CommandEventArgs e)
		{
			try
			{
				switch ( e.CommandName )
				{
					case "Roles.Edit":
					{
						Guid gROLE_ID = Sql.ToGuid(e.CommandArgument);
						Response.Redirect("~/Administration/ACLRoles/edit.aspx?ID=" + gROLE_ID.ToString());
						break;
					}
					case "Roles.Remove":
					{
						Guid gROLE_ID = Sql.ToGuid(e.CommandArgument);
						SqlProcs.spACL_ROLES_USERS_Delete(gROLE_ID, gID);
						//Response.Redirect("view.aspx?ID=" + gID.ToString());
						// 05/16/2008 Paul.  Instead of redirecting, just rebind the grid and AJAX will repaint. 
						BindGrid();
						// 03/17/2010 Paul.  We can only reset the current user. 
						SplendidInit.ClearUserACL();
						SplendidInit.LoadUserACL(Security.USER_ID);
						break;
					}
					// 05/05/2016 Paul.  The User Primary Role is used with role-based views. 
					case "Roles.MakeDefault":
					{
						Guid gROLE_ID = Sql.ToGuid(e.CommandArgument);
						SqlProcs.spUSERS_UpdatePrimaryRole(gID, gROLE_ID);
						BindGrid();
						break;
					}
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
				sSQL = "select " + Sql.FormatSelectFields(arrSelectFields)
				     + "  from vwUSERS_ACL_ROLES" + ControlChars.CrLf
				     + " where 1 = 1            " + ControlChars.CrLf;
				using ( IDbCommand cmd = con.CreateCommand() )
				{
					cmd.CommandText = sSQL;
					Sql.AppendParameter(cmd, gID, "USER_ID");
					// 04/26/2008 Paul.  Move Last Sort to the database.
					cmd.CommandText += grdMain.OrderByClause("ROLE_NAME", "asc");

					if ( bDebug )
						RegisterClientScriptBlock("vwUSER_ACL_ROLES", Sql.ClientScriptBlock(cmd));

					try
					{
						using ( DbDataAdapter da = dbf.CreateDataAdapter() )
						{
							((IDbDataAdapter)da).SelectCommand = cmd;
							using ( DataTable dt = new DataTable() )
							{
								da.Fill(dt);
								// 03/07/2013 Paul.  Apply business rules to subpanel. 
								this.ApplyGridViewRules("Users." + m_sMODULE, dt);
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
			// 03/08/2007 Paul.  We need to disable the buttons unless the user is an administrator. 
			if ( bMyAccount )
			{
				gID = Security.USER_ID;
			}
			if ( !Sql.IsEmptyString(txtROLE_ID.Value) )
			{
				try
				{
					SqlProcs.spUSERS_ACL_ROLES_MassUpdate(gID, txtROLE_ID.Value);
					// 05/16/2008 Paul.  Instead of redirecting, just rebind the grid and AJAX will repaint. 
					//Response.Redirect("view.aspx?ID=" + gID.ToString());
					// 05/16/2008 Paul.  If we are not going to redirect,then we must clear the value. 
					txtROLE_ID.Value = String.Empty;
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
				ctlDynamicButtons.AppendButtons("Users." + m_sMODULE, gASSIGNED_USER_ID, gID);
				// 11/19/2008 Paul.  HideAll must be after the buttons are appended.
				if ( bMyAccount && !(SplendidCRM.Security.AdminUserAccess("Users", "edit") >= 0) )
				{
					ctlDynamicButtons.HideAll();
				}
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
			m_sMODULE = "ACLRoles";
			// 04/26/2008 Paul.  We need to build a list of the fields used by the search clause. 
			arrSelectFields = new UniqueStringCollection();
			arrSelectFields.Add("DATE_ENTERED");
			arrSelectFields.Add("ROLE_ID"     );
			arrSelectFields.Add("ROLE_NAME"   );
			arrSelectFields.Add("DESCRIPTION" );
			// 05/05/2016 Paul.  The User Primary Role is used with role-based views. 
			arrSelectFields.Add("IS_PRIMARY_ROLE");
			// 04/28/2008 Paul.  Make use of dynamic buttons. 
			if ( IsPostBack )
				ctlDynamicButtons.AppendButtons("Users." + m_sMODULE, Guid.Empty, Guid.Empty);
		}
		#endregion
	}
}

