<%@ Control CodeBehind="Users.ascx.cs" Language="c#" AutoEventWireup="false" Inherits="SplendidCRM.Administration.Teams.Users" %>
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
<script type="text/javascript">
function UserMultiSelect()
{
	return ModulePopup('Users', '<%= txtUSER_ID.ClientID %>', null, null, true, 'PopupMultiSelect.aspx');
}
</script>
<input ID="txtUSER_ID" type="hidden" Runat="server" />
<%-- 06/03/2015 Paul.  Combine ListHeader and DynamicButtons. --%>
<%@ Register TagPrefix="SplendidCRM" Tagname="SubPanelButtons" Src="~/_controls/SubPanelButtons.ascx" %>
<SplendidCRM:SubPanelButtons ID="ctlDynamicButtons" Module="Users" SubPanel="divTeamsUsers" Title="Users.LBL_MODULE_NAME" Runat="Server" />

<div id="divTeamsUsers" style='<%= "display:" + (CookieValue("divTeamsUsers") != "1" ? "inline" : "none") %>'>
	<SplendidCRM:SplendidGrid id="grdMain" SkinID="grdListView" AllowPaging="<%# !PrintView %>" EnableViewState="true" runat="server">
		<Columns>
			<asp:HyperLinkColumn HeaderText="Users.LBL_LIST_NAME"       DataTextField="FULL_NAME" SortExpression="FULL_NAME"  ItemStyle-Width="18%" ItemStyle-CssClass="listViewTdLinkS1" DataNavigateUrlField="USER_ID" DataNavigateUrlFormatString="~/Users/view.aspx?id={0}" />
			<asp:BoundColumn     HeaderText="Users.LBL_LIST_USER_NAME"  DataField="USER_NAME"     SortExpression="USER_NAME"  ItemStyle-Width="18%" />
			<asp:BoundColumn     HeaderText="Teams.LBL_LIST_MEMBERSHIP" DataField="MEMBERSHIP"    SortExpression="MEMBERSHIP" ItemStyle-Width="18%" />
			<asp:BoundColumn     HeaderText="Users.LBL_LIST_EMAIL"      DataField="EMAIL1"        SortExpression="EMAIL1"     ItemStyle-Width="18%" />
			<asp:BoundColumn     HeaderText=".LBL_LIST_PHONE"           DataField="PHONE_WORK"    SortExpression="PHONE_WORK" ItemStyle-Width="15%" ItemStyle-Wrap="false" />
			<asp:TemplateColumn  HeaderText="" ItemStyle-Width="1%" ItemStyle-HorizontalAlign="Left" ItemStyle-Wrap="false">
				<ItemTemplate>
					<div style="DISPLAY: <%# Sql.ToBoolean(DataBinder.Eval(Container.DataItem, "EXPLICIT_ASSIGN")) ? "INLINE" : "NONE" %>">
					<asp:ImageButton Visible='<%# SplendidCRM.Security.AdminUserAccess("Teams", "edit") >= 0 %>' CommandName="Users.Remove" CommandArgument='<%# DataBinder.Eval(Container.DataItem, "USER_ID") %>' OnCommand="Page_Command" CssClass="listViewTdToolsS1" AlternateText='<%# L10n.Term(".LNK_REMOVE") %>' SkinID="delete_inline" Runat="server" />
					<asp:LinkButton  Visible='<%# SplendidCRM.Security.AdminUserAccess("Teams", "edit") >= 0 %>' CommandName="Users.Remove" CommandArgument='<%# DataBinder.Eval(Container.DataItem, "USER_ID") %>' OnCommand="Page_Command" CssClass="listViewTdToolsS1" Text='<%# L10n.Term(".LNK_REMOVE") %>' Runat="server" />
					</div>
				</ItemTemplate>
			</asp:TemplateColumn>
		</Columns>
	</SplendidCRM:SplendidGrid>
</div>
