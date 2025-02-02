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
using System.Web;
using System.Web.UI.WebControls;
using System.Diagnostics;

namespace SplendidCRM.ActivityStream
{
	/// <summary>
	///		Summary description for SearchBasic.
	/// </summary>
	public class SearchBasic : SearchControl
	{
		protected ListBox   lstSTREAM_ACTION;
		protected ListBox   lstMODULES      ;
		protected TextBox   txtNAME         ;
		protected Button    btnSearch       ;
		protected TableCell tdMODULES       ;
		protected TableCell tdNAME          ;

		public string Module
		{
			get { return m_sMODULE; }
			set { m_sMODULE = value; }
		}

		public override void ClearForm()
		{
			lstSTREAM_ACTION.ClearSelection();
			txtNAME.Text = String.Empty;
		}

		public override void SqlSearchClause(IDbCommand cmd)
		{
			Sql.AppendParameter(cmd, lstSTREAM_ACTION, "STREAM_ACTION");
			if ( m_sMODULE == "ActivityStream" )
				Sql.AppendParameter(cmd, lstMODULES, "MODULE_NAME");
			Sql.AppendParameter(cmd, txtNAME.Text, 1000, Sql.SqlFilterMode.StartsWith, new string[] { "NAME", "STREAM_RELATED_NAME" });
		}

		private void Page_Load(object sender, System.EventArgs e)
		{
			if ( !IsPostBack )
			{
				lstSTREAM_ACTION.DataSource = SplendidCache.List("activity_stream_action");
				lstSTREAM_ACTION.DataBind();
				if ( m_sMODULE != "ActivityStream" )
				{
					tdMODULES.Visible = false;
					tdNAME.Width = new Unit("85%");
				}
				else
				{
					lstMODULES.DataSource = SplendidCache.StreamModules(Security.USER_ID);
					lstMODULES.DataBind();
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
		}
		#endregion
	}
}
