<%@ Control Language="c#" AutoEventWireup="false" Codebehind="EditView.ascx.cs" Inherits="SplendidCRM.Products.EditView" TargetSchema="http://schemas.microsoft.com/intellisense/ie5" %>
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
<SplendidCRM:InlineScript runat="server">
<script type="text/javascript">
// 09/03/2012 Paul.  Must place within InlineScript to prevent error. The Controls collection cannot be modified because the control contains code blocks (i.e. ).
function ContactPopup()
{
	var sACCOUNT_NAME = document.getElementById('<%= new SplendidCRM.DynamicControl(this, "ACCOUNT_NAME").ClientID %>').value;
	return ModulePopup('Contacts', '<%= new SplendidCRM.DynamicControl(this, "CONTACT_ID").ClientID %>', '<%= new SplendidCRM.DynamicControl(this, "CONTACT_NAME").ClientID %>', 'ACCOUNT_NAME=' + escape(sACCOUNT_NAME), false, null);
}
function ChangeProductTemplate(sPARENT_ID, sPARENT_NAME)
{
	document.getElementById('<%= new SplendidCRM.DynamicControl(this, "PRODUCT_TEMPLATE_ID").ClientID %>').value = sPARENT_ID  ;
	document.getElementById('<%= new SplendidCRM.DynamicControl(this, "NAME"               ).ClientID %>').value = sPARENT_NAME;
	var btnProductChanged = document.getElementById('<%= btnProductChanged.ClientID %>');
	btnProductChanged.click();
}
function ProductCatalogPopup()
{
	window.open('ProductCatalog/Popup.aspx', 'ProductCatalogPopup', '<%= SplendidCRM.Crm.Config.PopupWindowOptions() %>');
	return false;
}
</script>
</SplendidCRM:InlineScript>
<div id="divEditView" runat="server">
	<%-- 05/31/2015 Paul.  Combine ModuleHeader and DynamicButtons. --%>
	<%@ Register TagPrefix="SplendidCRM" Tagname="HeaderButtons" Src="~/_controls/HeaderButtons.ascx" %>
	<SplendidCRM:HeaderButtons ID="ctlDynamicButtons" ShowRequired="true" EditView="true" Module="Products" EnablePrint="false" HelpName="EditView" EnableHelp="true" Runat="Server" />

	<asp:Button ID="btnProductChanged" Text="Product Changed" OnClick="btnProductChanged_Clicked" style="DISPLAY:none" runat="server" />
	<asp:HiddenField ID="LAYOUT_EDIT_VIEW" Runat="server" />
	<asp:Table SkinID="tabForm" runat="server">
		<asp:TableRow>
			<asp:TableCell>
				<table ID="tblMain" class="tabEditView" runat="server">
				</table>
			</asp:TableCell>
		</asp:TableRow>
	</asp:Table>

	<asp:Table SkinID="tabForm" runat="server">
		<asp:TableRow>
			<asp:TableCell>
				<table ID="tblCost" class="tabEditView" runat="server">
				</table>
			</asp:TableCell>
		</asp:TableRow>
	</asp:Table>

	<asp:Table SkinID="tabForm" runat="server">
		<asp:TableRow>
			<asp:TableCell>
				<table ID="tblManufacturer" class="tabEditView" runat="server">
				</table>
			</asp:TableCell>
		</asp:TableRow>
	</asp:Table>
	<%-- 05/31/2015 Paul.  Combine ModuleHeader and DynamicButtons. --%>
	<%@ Register TagPrefix="SplendidCRM" Tagname="DynamicButtons" Src="~/_controls/DynamicButtons.ascx" %>
	<SplendidCRM:DynamicButtons ID="ctlFooterButtons" Visible="<%# !SplendidDynamic.StackedLayout(this.Page.Theme) && !PrintView %>" ShowRequired="false" Runat="Server" />
</div>

<%@ Register TagPrefix="SplendidCRM" Tagname="DumpSQL" Src="~/_controls/DumpSQL.ascx" %>
<SplendidCRM:DumpSQL ID="ctlDumpSQL" Visible="<%# !PrintView %>" Runat="Server" />
