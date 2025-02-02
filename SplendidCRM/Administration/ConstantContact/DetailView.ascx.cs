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
using System.Text;
using System.Data;
using System.Data.Common;
using System.Net;
using System.Web;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.Diagnostics;

namespace SplendidCRM.Administration.ConstantContact
{
	/// <summary>
	///		Summary description for DetailView.
	/// </summary>
	public class DetailView : SplendidControl
	{
		// 05/31/2015 Paul.  Combine ModuleHeader and DynamicButtons. 
		protected _controls.HeaderButtons ctlDynamicButtons;
		protected PlaceHolder plcSubPanel      ;

		protected TableRow     trInstructions          ;
		protected CheckBox     ENABLED                 ;
		protected CheckBox     VERBOSE_STATUS          ;
		protected Label        DIRECTION               ;
		protected Label        CONFLICT_RESOLUTION     ;
		protected Label        SYNC_MODULES            ;

		protected void Page_Command(Object sender, CommandEventArgs e)
		{
			if ( e.CommandName == "Test" )
			{
				try
				{
					StringBuilder sbErrors = new StringBuilder();
					// 11/11/2019 Paul.  Always refresh before we validate so that we do not need to worry about token expiration. 
					Spring.Social.ConstantContact.ConstantContactSync.RefreshAccessToken(Application, sbErrors);
					if ( sbErrors.Length == 0 )
					{
						Spring.Social.ConstantContact.ConstantContactSync.ValidateConstantContact(Application, sbErrors);
					}
					if ( sbErrors.Length > 0 )
						ctlDynamicButtons.ErrorText = sbErrors.ToString();
					else
						ctlDynamicButtons.ErrorText = L10n.Term("ConstantContact.LBL_TEST_SUCCESSFUL");
				}
				catch(Exception ex)
				{
					SplendidError.SystemError(new StackTrace(true).GetFrame(0), ex);
					ctlDynamicButtons.ErrorText = ex.Message;
				}
			}
			else if ( e.CommandName == "Sync" )
			{
#if false
				Spring.Social.ConstantContact.ConstantContactSync.Sync(Context);
#else
				System.Threading.Thread t = new System.Threading.Thread(Spring.Social.ConstantContact.ConstantContactSync.Sync);
				t.Start(Context);
				ctlDynamicButtons.ErrorText = L10n.Term("ConstantContact.LBL_SYNC_BACKGROUND");
#endif
				Response.Redirect("default.aspx");
			}
			else if ( e.CommandName == "SyncAll" )
			{
#if false
				Spring.Social.ConstantContact.ConstantContactSync.SyncAll(Context);
#else
				System.Threading.Thread t = new System.Threading.Thread(Spring.Social.ConstantContact.ConstantContactSync.SyncAll);
				t.Start(Context);
				ctlDynamicButtons.ErrorText = L10n.Term("ConstantContact.LBL_SYNC_BACKGROUND");
#endif
				Response.Redirect("default.aspx");
			}
			else if ( e.CommandName == "Edit" )
			{
				Response.Redirect("config.aspx");
			}
			else if ( e.CommandName == "Cancel" )
			{
				Response.Redirect("../default.aspx");
			}
		}

		private void Page_Load(object sender, System.EventArgs e)
		{
			SetPageTitle(L10n.Term("ConstantContact.LBL_CONSTANTCONTACT_SETTINGS"));
			this.Visible = (SplendidCRM.Security.AdminUserAccess(m_sMODULE, "edit") >= 0);
			if ( !this.Visible )
			{
				Parent.DataBind();
				return;
			}

			try
			{
				if ( !IsPostBack )
				{
					ENABLED            .Checked = Sql.ToBoolean(Application["CONFIG.ConstantContact.Enabled"           ]);
					VERBOSE_STATUS     .Checked = Sql.ToBoolean(Application["CONFIG.ConstantContact.VerboseStatus"     ]);
					DIRECTION          .Text    = Sql.ToString (Application["CONFIG.ConstantContact.Direction"         ]);
					CONFLICT_RESOLUTION.Text    = Sql.ToString (Application["CONFIG.ConstantContact.ConflictResolution"]);
					string sSYNC_MODULES = Sql.ToString(Application["CONFIG.ConstantContact.SyncModules"]);
					if ( !Sql.IsEmptyString(sSYNC_MODULES) )
						SYNC_MODULES.Text = Sql.ToString(L10n.Term(".constantcontact_sync_module.", sSYNC_MODULES));
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
			m_sMODULE = "ConstantContact";
			SetAdminMenu(m_sMODULE);
			this.AppendDetailViewRelationships(m_sMODULE + "." + LayoutDetailView, plcSubPanel);
			ctlDynamicButtons.AppendButtons(m_sMODULE + "." + LayoutDetailView, Guid.Empty, null);
		}
		#endregion
	}
}
