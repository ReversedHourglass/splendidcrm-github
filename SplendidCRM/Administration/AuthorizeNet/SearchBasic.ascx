<%@ Control Language="c#" AutoEventWireup="false" Codebehind="SearchBasic.ascx.cs" Inherits="SplendidCRM.Administration.AuthorizeNet.SearchBasic" TargetSchema="http://schemas.microsoft.com/intellisense/ie5" %>
<%@ Register TagPrefix="SplendidCRM" Tagname="DatePicker" Src="~/_controls/DatePicker.ascx" %>
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
<%@ Register TagPrefix="SplendidCRM" Tagname="ListHeader" Src="~/_controls/ListHeader.ascx" %>
<SplendidCRM:ListHeader Title="AuthorizeNet.LBL_SEARCH_FORM_TITLE" Runat="Server" />
<div id="divSearch">
	<asp:Table SkinID="tabSearchForm" runat="server">
		<asp:TableRow>
			<asp:TableCell>
				<asp:Table Width="100%" CellPadding="0" CellSpacing="0" runat="server">
					<asp:TableRow>
						<asp:TableCell CssClass="dataLabel" Wrap="false"><%= L10n.Term("AuthorizeNet.LBL_START_DATE"      ) %></asp:TableCell>
						<asp:TableCell CssClass="dataField" Wrap="false"><SplendidCRM:DatePicker ID="ctlSTART_DATE" TabIndex="6" Runat="Server" /></asp:TableCell>
						<asp:TableCell CssClass="dataLabel" Wrap="false"><%= L10n.Term("AuthorizeNet.LBL_END_DATE"        ) %></asp:TableCell>
						<asp:TableCell CssClass="dataField" Wrap="false"><SplendidCRM:DatePicker ID="ctlEND_DATE"   TabIndex="6" Runat="Server" /></asp:TableCell>
					</asp:TableRow>
				</asp:Table>
				<%@ Register TagPrefix="SplendidCRM" Tagname="SearchButtons" Src="~/_controls/SearchButtons.ascx" %>
				<SplendidCRM:SearchButtons ID="ctlSearchButtons" Module="Payments" Visible="<%# !PrintView %>" Runat="Server" />
			</asp:TableCell>
		</asp:TableRow>
	</asp:Table>
</div>
