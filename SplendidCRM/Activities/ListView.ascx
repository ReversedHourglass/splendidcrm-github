<%@ Control CodeBehind="ListView.ascx.cs" Language="c#" AutoEventWireup="false" Inherits="SplendidCRM.Activities.ListView" %>
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
<div id="divListView">
	<%-- 05/31/2015 Paul.  Combine ModuleHeader and DynamicButtons. --%>
	<%@ Register TagPrefix="SplendidCRM" Tagname="HeaderButtons" Src="~/_controls/HeaderButtons.ascx" %>
	<SplendidCRM:HeaderButtons ID="ctlModuleHeader" Module="Activities" Title=".moduleList.Home" EnablePrint="true" HelpName="index" EnableHelp="true" Runat="Server" />

	<%@ Register TagPrefix="SplendidCRM" Tagname="SearchView" Src="~/_controls/SearchView.ascx" %>
	<SplendidCRM:SearchView ID="ctlSearchView" Module="Activities" Visible="<%# !PrintView %>" Runat="Server" />

	<%@ Register TagPrefix="SplendidCRM" Tagname="ExportHeader" Src="~/_controls/ExportHeader.ascx" %>
	<SplendidCRM:ExportHeader ID="ctlExportHeader" Module="Activities" Title="Activities.LBL_LIST_FORM_TITLE" Runat="Server" />
	
	<asp:Panel CssClass="button-panel" Visible="<%# !PrintView %>" runat="server">
		<asp:Label ID="lblError" CssClass="error" EnableViewState="false" Runat="server" />
	</asp:Panel>
	
	<%-- 06/23/2015 Paul.  MassUpdate hover needs to be in column 0. --%>
	<%-- 03/15/2016 Paul.  Make better use of the activities list by showing all.  Activities cannot be udpated en-mass. --%>
	<%-- 05/24/2018 Paul.  Restore checkboxes to allow export. --%>
	<SplendidCRM:SplendidGrid id="grdMain" SkinID="grdListView" AllowPaging="<%# !PrintView %>" EnableViewState="true" MassUpdateHoverColumn="0" runat="server">
		<Columns>
			<asp:TemplateColumn HeaderText="" ItemStyle-Width="1%" Visible="true">
				<ItemTemplate><%# grdMain.InputCheckbox(!PrintView && !IsMobile, ctlCheckAll.FieldName, Sql.ToGuid(Eval("ID")), ctlCheckAll.SelectedItems) %></ItemTemplate>
			</asp:TemplateColumn>
			<asp:TemplateColumn HeaderText="" ItemStyle-Width="1%" ItemStyle-HorizontalAlign="Center" ItemStyle-Wrap="false">
				<ItemTemplate>
					<%-- 10/31/2017 Paul.  Provide a way to inject Record level ACL. --%>
					<SplendidCRM:DynamicImage ImageSkinID='<%# Eval("ACTIVITY_TYPE") %>' runat="server" />
					<asp:HyperLink Visible='<%# SplendidCRM.Security.GetRecordAccess(Container, Sql.ToString(Eval("ACTIVITY_TYPE")), "view", "ASSIGNED_USER_ID") >= 0 %>' NavigateUrl='<%# "~/" + Sql.ToString(Eval("ACTIVITY_TYPE")) + "/view.aspx?id=" + Eval("ID") %>' ToolTip='<%# L10n.Term(".LNK_VIEW") %>' Runat="server">
						<asp:Image SkinID="view_inline" Runat="server" />
					</asp:HyperLink>
				</ItemTemplate>
			</asp:TemplateColumn>
		</Columns>
	</SplendidCRM:SplendidGrid>
	<%@ Register TagPrefix="SplendidCRM" Tagname="CheckAll" Src="~/_controls/CheckAll.ascx" %>
	<SplendidCRM:CheckAll ID="ctlCheckAll" Visible="<%# true %>" Runat="Server" />
	<%-- 06/06/2015 Paul.  MassUpdateButtons combines ListHeader and DynamicButtons. --%>
	<%-- 03/15/2016 Paul.  Make better use of the activities list by showing all.  Activities cannot be udpated en-mass. --%>
	<asp:Panel ID="pnlMassUpdateSeven" Visible="false" runat="server">
		<%@ Register TagPrefix="SplendidCRM" Tagname="MassUpdate" Src="~/Calls/MassUpdate.ascx" %>
		<SplendidCRM:MassUpdate ID="ctlMassUpdate" Visible="<%# false %>" Runat="Server" />
	</asp:Panel>

	<%@ Register TagPrefix="SplendidCRM" Tagname="DumpSQL" Src="~/_controls/DumpSQL.ascx" %>
	<SplendidCRM:DumpSQL ID="ctlDumpSQL" Visible="<%# !PrintView %>" Runat="Server" />
</div>

