<%@ Control CodeBehind="UserCalendarPopupView.ascx.cs" Language="c#" AutoEventWireup="false" Inherits="SplendidCRM.Users.UserCalendarPopupView" %>
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
<div id="divPopupView">
	<%@ Register TagPrefix="SplendidCRM" Tagname="SearchView" Src="~/_controls/SearchView.ascx" %>
	<SplendidCRM:SearchView ID="ctlSearchView" Module="Users" IsPopupSearch="true" ShowSearchTabs="false" Visible="<%# !PrintView %>" Runat="Server" />

	<script type="text/javascript">
	function SelectUser(sPARENT_ID, sPARENT_NAME)
	{
		if ( window.opener != null && window.opener.ChangeUser != null )
		{
			window.opener.ChangeUser(sPARENT_ID, sPARENT_NAME);
			window.close();
		}
		else
		{
			alert('Original window has closed.  User cannot be assigned.' + '\n' + sPARENT_ID + '\n' + sPARENT_NAME);
		}
	}
	function SelectChecked()
	{
		if ( window.opener != null && window.opener.ChangeUser != null )
		{
			var sSelectedItems = document.getElementById('<%= ctlCheckAll.SelectedItems.ClientID %>').value;
			window.opener.ChangeUser(sSelectedItems, '');
			window.close();
		}
		else
		{
			alert('Original window has closed.  User cannot be assigned.');
		}
	}
	function Clear()
	{
		if ( window.opener != null && window.opener.ChangeUser != null )
		{
			window.opener.ChangeUser('', '');
			window.close();
		}
		else
		{
			alert('Original window has closed.  User cannot be assigned.');
		}
	}
	function Cancel()
	{
		window.close();
	}
	</script>
	<%@ Register TagPrefix="SplendidCRM" Tagname="ListHeader" Src="~/_controls/ListHeader.ascx" %>
	<SplendidCRM:ListHeader Title="Users.LBL_LIST_FORM_TITLE" Runat="Server" />

	<%@ Register TagPrefix="SplendidCRM" Tagname="DynamicButtons" Src="~/_controls/DynamicButtons.ascx" %>
	<SplendidCRM:DynamicButtons ID="ctlDynamicButtons" Runat="Server" />

	<SplendidCRM:SplendidGrid id="grdMain" SkinID="grdPopupView" EnableViewState="true" runat="server">
		<Columns>
			<asp:TemplateColumn HeaderText="" ItemStyle-Width="2%">
				<ItemTemplate><%# grdMain.InputCheckbox(!PrintView && bMultiSelect, ctlCheckAll.FieldName, Sql.ToGuid(Eval("ID")), ctlCheckAll.SelectedItems) %></ItemTemplate>
			</asp:TemplateColumn>
			<asp:TemplateColumn HeaderText="" ItemStyle-Width="40%">
				<ItemTemplate>
					<%@ Register TagPrefix="SplendidCRM" Tagname="UserSchedule" Src="~/Activities/UserSchedule.ascx" %>
					<SplendidCRM:UserSchedule ID="ctlUserSchedule" DATE_START='<%# dtDATE_START %>' DATE_END='<%# dtDATE_END %>' USER_ID='<%# Sql.ToGuid(Eval("ID")) %>' Runat="Server" />
				</ItemTemplate>
			</asp:TemplateColumn>
		</Columns>
	</SplendidCRM:SplendidGrid>
	<%@ Register TagPrefix="SplendidCRM" Tagname="CheckAll" Src="~/_controls/CheckAll.ascx" %>
	<SplendidCRM:CheckAll ID="ctlCheckAll" Visible="<%# !PrintView && bMultiSelect %>" Runat="Server" />

	<%@ Register TagPrefix="SplendidCRM" Tagname="DumpSQL" Src="~/_controls/DumpSQL.ascx" %>
	<SplendidCRM:DumpSQL ID="ctlDumpSQL" Visible="<%# !PrintView %>" Runat="Server" />
</div>

