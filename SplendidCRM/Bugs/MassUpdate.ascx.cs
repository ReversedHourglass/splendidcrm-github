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

namespace SplendidCRM.Bugs
{
	/// <summary>
	///		Summary description for MassUpdate.
	/// </summary>
	public class MassUpdate : SplendidCRM.MassUpdate
	{
		// 11/10/2010 Paul.  Convert MassUpdate to dynamic buttons. 
		// 06/06/2015 Paul.  MassUpdateButtons combines ListHeader and DynamicButtons. 
		protected _controls.MassUpdateButtons ctlDynamicButtons;

		protected DropDownList lstSTATUS          ;
		protected DropDownList lstPRIORITY        ;
		protected DropDownList lstRESOLUTION      ;
		protected DropDownList lstTYPE            ;
		protected DropDownList lstSOURCE          ;
		protected DropDownList lstPRODUCT_CATEGORY;
		public    CommandEventHandler Command ;
		protected _controls.TeamAssignedMassUpdate ctlTeamAssignedMassUpdate;
		// 05/13/2016 Paul.  Add Tags module. 
		protected _controls.TagMassUpdate          ctlTagMassUpdate;

		public Guid ASSIGNED_USER_ID
		{
			get
			{
				return ctlTeamAssignedMassUpdate.ASSIGNED_USER;
			}
		}

		public Guid PRIMARY_TEAM_ID
		{
			get
			{
				return ctlTeamAssignedMassUpdate.PRIMARY_TEAM_ID;
			}
		}

		// 08/29/2009 Paul. Add support for dynamic teams. 
		public string TEAM_SET_LIST
		{
			get
			{
				return ctlTeamAssignedMassUpdate.TEAM_SET_LIST;
			}
		}

		public bool ADD_TEAM_SET
		{
			get
			{
				return ctlTeamAssignedMassUpdate.ADD_TEAM_SET;
			}
		}

		public string STATUS
		{
			get
			{
				return lstSTATUS.SelectedValue;
			}
		}

		public string PRIORITY
		{
			get
			{
				return lstPRIORITY.SelectedValue;
			}
		}

		public string RESOLUTION
		{
			get
			{
				return lstRESOLUTION.SelectedValue;
			}
		}

		public string TYPE
		{
			get
			{
				return lstTYPE.SelectedValue;
			}
		}

		public string SOURCE
		{
			get
			{
				return lstSOURCE.SelectedValue;
			}
		}

		public string PRODUCT_CATEGORY
		{
			get
			{
				return lstPRODUCT_CATEGORY.SelectedValue;
			}
		}

		// 05/13/2016 Paul.  Add Tags module. 
		public string TAG_SET_NAME
		{
			get
			{
				return ctlTagMassUpdate.TAG_SET_NAME;
			}
		}

		public bool ADD_TAG_SET
		{
			get
			{
				return ctlTagMassUpdate.ADD_TAG_SET;
			}
		}

		protected void Page_Command(Object sender, CommandEventArgs e)
		{
			// Command is handled by the parent. 
			if ( Command != null )
				Command(this, e) ;
		}

		private void Page_Load(object sender, System.EventArgs e)
		{
			try
			{
				if ( !IsPostBack )
				{
					// 06/02/2006 Paul.  Buttons should be hidden if the user does not have access. 
					int nACLACCESS_Delete = Security.GetUserAccess(m_sMODULE, "delete");
					int nACLACCESS_Edit   = Security.GetUserAccess(m_sMODULE, "edit"  );
					ctlDynamicButtons.ShowButton("MassUpdate", nACLACCESS_Edit   >= 0);
					ctlDynamicButtons.ShowButton("MassDelete", nACLACCESS_Delete >= 0);
					// 09/26/2017 Paul.  Add Archive access right. 
					int nACLACCESS_Archive = Security.GetUserAccess(m_sMODULE, "archive");
					ctlDynamicButtons.ShowButton("Archive.MoveData"   , (nACLACCESS_Archive >= ACL_ACCESS.ARCHIVE || Security.IS_ADMIN) && !ArchiveView() && ArchiveEnabled());
					ctlDynamicButtons.ShowButton("Archive.RecoverData", (nACLACCESS_Archive >= ACL_ACCESS.ARCHIVE || Security.IS_ADMIN) &&  ArchiveView() && ArchiveEnabled());

					lstSTATUS          .DataSource = SplendidCache.List("bug_status_dom");
					lstSTATUS          .DataBind();
					lstSTATUS          .Items.Insert(0, new ListItem(L10n.Term(".LBL_NONE"), ""));
					lstPRIORITY        .DataSource = SplendidCache.List("bug_priority_dom");
					lstPRIORITY        .DataBind();
					lstPRIORITY        .Items.Insert(0, new ListItem(L10n.Term(".LBL_NONE"), ""));
					lstRESOLUTION      .DataSource = SplendidCache.List("bug_resolution_dom");
					lstRESOLUTION      .DataBind();
					lstRESOLUTION      .Items.Insert(0, new ListItem(L10n.Term(".LBL_NONE"), ""));
					lstTYPE            .DataSource = SplendidCache.List("bug_type_dom");
					lstTYPE            .DataBind();
					lstTYPE            .Items.Insert(0, new ListItem(L10n.Term(".LBL_NONE"), ""));
					lstSOURCE          .DataSource = SplendidCache.List("source_dom");
					lstSOURCE          .DataBind();
					lstSOURCE          .Items.Insert(0, new ListItem(L10n.Term(".LBL_NONE"), ""));
					lstPRODUCT_CATEGORY.DataSource = SplendidCache.List("product_category_dom");
					lstPRODUCT_CATEGORY.DataBind();
					lstPRODUCT_CATEGORY.Items.Insert(0, new ListItem(L10n.Term(".LBL_NONE"), ""));
				}
			}
			catch(Exception ex)
			{
				SplendidError.SystemError(new StackTrace(true).GetFrame(0), ex);
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
			m_sMODULE = "Bugs";
			// 09/26/2017 Paul.  Add Archive access right. 
			ctlDynamicButtons.AppendButtons(m_sMODULE + ".MassUpdate" + (ArchiveView() ? ".ArchiveView" : String.Empty), Guid.Empty, null);
			ctlDynamicButtons.ShowButton("Sync"  , SplendidCRM.Crm.Modules.ExchangeFolders(m_sMODULE) && Security.HasExchangeAlias());
			ctlDynamicButtons.ShowButton("Unsync", SplendidCRM.Crm.Modules.ExchangeFolders(m_sMODULE) && Security.HasExchangeAlias());
		}
		#endregion
	}
}

