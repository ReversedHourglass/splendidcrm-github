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
using System.Web;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;

namespace SplendidCRM._controls
{
	/// <summary>
	///		Summary description for DashletHeader.
	/// </summary>
	public class DashletHeader : SplendidControl
	{
		protected string sTitle       = String.Empty;
		protected string sDivEditName = String.Empty;
		protected bool   bShowCommandTitles = false;
		protected Label  lblTitle    ;
		// 04/23/2016 Paul.  How dashlets to be disabled. 
		protected ImageButton imgRefresh;
		protected LinkButton  bntRefresh;
		protected ImageButton imgEdit   ;
		protected LinkButton  bntEdit   ;
		protected ImageButton imgRemove ;
		protected LinkButton  bntRemove ;

		public CommandEventHandler Command ;

		public bool ShowEdit
		{
			get { return !Sql.IsEmptyString(sDivEditName); }
		}

		public string Title
		{
			get { return sTitle; }
			set { sTitle = value; }
		}

		public string DivEditName
		{
			get { return sDivEditName; }
			set { sDivEditName = value; }
		}

		public bool ShowCommandTitles
		{
			get { return bShowCommandTitles; }
			set { bShowCommandTitles = value; }
		}

		protected void Page_Command(object sender, CommandEventArgs e)
		{
			// 06/21/2009 Paul.  We need to be able to send the Refresh event to the parent. 
			if ( Command != null )
				Command(this, e) ;
		}
		
		private void Page_Load(object sender, System.EventArgs e)
		{
			// 04/23/2016 Paul.  How dashlets to be disabled. 
			if ( !IsPostBack )
			{
				imgRemove.Visible = !Sql.ToBoolean(Application["CONFIG.disable_add_dashlets"]);
				// 10/02/2016 Paul.  Need to include ShowCommandTitles as this will over-write the inline condition. 
				bntRemove.Visible = !Sql.ToBoolean(Application["CONFIG.disable_add_dashlets"]) && ShowCommandTitles;
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
		}
		#endregion
	}
}

