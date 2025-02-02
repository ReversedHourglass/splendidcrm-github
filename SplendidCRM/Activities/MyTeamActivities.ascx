<%@ Control CodeBehind="MyTeamActivities.ascx.cs" Language="c#" AutoEventWireup="false" Inherits="SplendidCRM.Activities.MyTeamActivities" %>
<script runat="server">
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
</script>
<div id="divActivitiesMyActivities">
	<%@ Register TagPrefix="SplendidCRM" Tagname="MyActivitiesHeader" Src="MyActivitiesHeader.ascx" %>
	<SplendidCRM:MyActivitiesHeader ID="ctlDashletHeader" Title="Activities.LBL_UPCOMING" DivEditName="my_activities_edit" Runat="Server" />

	<div ID="my_activities_edit" style="DISPLAY: <%= bShowEditDialog ? "inline" : "none" %>">
		<%@ Register TagPrefix="SplendidCRM" Tagname="SearchView" Src="~/_controls/SearchView.ascx" %>
		<SplendidCRM:SearchView ID="ctlSearchView" Module="Activities" SearchMode="SearchHome" IsDashlet="true" AutoSaveSearch="true" ShowSearchTabs="false" ShowSearchViews="false" ShowDuplicateSearch="false" Visible="<%# !PrintView %>" Runat="Server" />
	</div>
	<asp:Panel CssClass="button-panel" Visible="<%# !PrintView %>" runat="server">
		<asp:Label ID="lblError" CssClass="error" EnableViewState="false" Runat="server" />
	</asp:Panel>
	
	<SplendidCRM:SplendidGrid id="grdMain" SkinID="grdListView" AllowPaging="<%# !PrintView %>" EnableViewState="true" runat="server">
		<Columns>
			<asp:TemplateColumn HeaderText="" ItemStyle-Width="1%" ItemStyle-HorizontalAlign="Center">
				<ItemTemplate>
					<SplendidCRM:DynamicImage ImageSkinID='<%# Eval("ACTIVITY_TYPE") %>' runat="server" />
				</ItemTemplate>
			</asp:TemplateColumn>
			<asp:TemplateColumn HeaderText="Activities.LBL_LIST_CLOSE" ItemStyle-Width="1%" ItemStyle-HorizontalAlign="Center">
				<ItemTemplate>
					<%-- 10/31/2017 Paul.  Provide a way to inject Record level ACL. --%>
					<asp:HyperLink Visible='<%# SplendidCRM.Security.GetRecordAccess(Container, Sql.ToString(Eval("ACTIVITY_TYPE")), "edit", "ASSIGNED_USER_ID") >= 0 %>' NavigateUrl='<%# "~/" + Eval("ACTIVITY_TYPE") + "/edit.aspx?id=" + Eval("ID") + "&Status=Close" %>' Runat="server">
						<asp:Image SkinID="close_inline" AlternateText='<%# L10n.Term("Activities.LBL_LIST_CLOSE") %>' Runat="server" />
					</asp:HyperLink>
				</ItemTemplate>
			</asp:TemplateColumn>
			<asp:TemplateColumn  HeaderText="Activities.LBL_LIST_DATE" SortExpression="DATE_START" ItemStyle-Width="15%" ItemStyle-Wrap="false">
				<ItemTemplate>
					<font class="<%# (Sql.ToDateTime(Eval("DATE_START")) < DateTime.Now) ? "overdueTask" : "futureTask" %>"><%# Sql.ToDateString(T10n.FromServerTime(Sql.ToDateTime(Eval("DATE_START")))) %></font>
				</ItemTemplate>
			</asp:TemplateColumn>
			<asp:TemplateColumn HeaderText="Activities.LBL_ACCEPT_THIS" ItemStyle-Width="5%" ItemStyle-Wrap="false">
				<ItemTemplate>
					<%-- 10/31/2017 Paul.  Provide a way to inject Record level ACL. --%>
					<div style="DISPLAY: <%# String.Compare((Eval("ACCEPT_STATUS") as string), "none", true) == 0 ? "inline" : "none" %>">
						<asp:ImageButton Visible='<%# SplendidCRM.Security.GetRecordAccess(Container, Sql.ToString(Eval("ACTIVITY_TYPE")), "edit", "ASSIGNED_USER_ID") >= 0 %>' CommandName="Activity.Accept"    CommandArgument='<%# Eval("ID") %>' OnCommand="Page_Command" AlternateText='<%# L10n.Term(".dom_meeting_accept_options.accept"   ) %>' SkinID="accept_inline"    Runat="server" />
						<asp:ImageButton Visible='<%# SplendidCRM.Security.GetRecordAccess(Container, Sql.ToString(Eval("ACTIVITY_TYPE")), "edit", "ASSIGNED_USER_ID") >= 0 %>' CommandName="Activity.Tentative" CommandArgument='<%# Eval("ID") %>' OnCommand="Page_Command" AlternateText='<%# L10n.Term(".dom_meeting_accept_options.tentative") %>' SkinID="tentative_inline" Runat="server" />
						<asp:ImageButton Visible='<%# SplendidCRM.Security.GetRecordAccess(Container, Sql.ToString(Eval("ACTIVITY_TYPE")), "edit", "ASSIGNED_USER_ID") >= 0 %>' CommandName="Activity.Decline"   CommandArgument='<%# Eval("ID") %>' OnCommand="Page_Command" AlternateText='<%# L10n.Term(".dom_meeting_accept_options.decline"  ) %>' SkinID="decline_inline"   Runat="server" />
					</div>
					<div style="DISPLAY: <%# String.Compare((Eval("ACCEPT_STATUS") as string), "none", true) != 0 ? "inline" : "none" %>">
						<%# L10n.Term(".dom_meeting_accept_status." + Eval("ACCEPT_STATUS")) %>
					</div>
				</ItemTemplate>
			</asp:TemplateColumn>
			<asp:TemplateColumn HeaderText="" ItemStyle-Width="1%" ItemStyle-HorizontalAlign="Center" ItemStyle-Wrap="false">
				<ItemTemplate>
					<%-- 10/31/2017 Paul.  Provide a way to inject Record level ACL. --%>
					<asp:HyperLink Visible='<%# SplendidCRM.Security.GetRecordAccess(Container, Sql.ToString(Eval("ACTIVITY_TYPE")), "edit", "ASSIGNED_USER_ID") >= 0 %>' NavigateUrl='<%# "~/" + Sql.ToString(Eval("ACTIVITY_TYPE")) + "/edit.aspx?id=" + Eval("ID") %>' ToolTip='<%# L10n.Term(".LNK_EDIT") %>' Runat="server">
						<asp:Image SkinID="edit_inline" Runat="server" />
					</asp:HyperLink>
					<asp:HyperLink Visible='<%# SplendidCRM.Security.GetRecordAccess(Container, Sql.ToString(Eval("ACTIVITY_TYPE")), "view", "ASSIGNED_USER_ID") >= 0 %>' NavigateUrl='<%# "~/" + Sql.ToString(Eval("ACTIVITY_TYPE")) + "/view.aspx?id=" + Eval("ID") %>' ToolTip='<%# L10n.Term(".LNK_VIEW") %>' Runat="server">
						<asp:Image SkinID="view_inline" Runat="server" />
					</asp:HyperLink>
				</ItemTemplate>
			</asp:TemplateColumn>
		</Columns>
	</SplendidCRM:SplendidGrid>
	<br />
</div>

