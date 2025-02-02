<%@ Control CodeBehind="MyTeamPipeline.ascx.cs" Language="c#" AutoEventWireup="false" Inherits="SplendidCRM.Opportunities.MyTeamPipeline" %>
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
<div id="divOpportunitiesMyPipeline">
	<%@ Register TagPrefix="SplendidCRM" Tagname="ChartDatePicker" Src="~/_controls/ChartDatePicker.ascx" %>
	<%@ Register TagPrefix="SplendidCRM" Tagname="DashletHeader" Src="~/_controls/DashletHeader.ascx" %>
	<SplendidCRM:DashletHeader ID="ctlDashletHeader" Title="Home.LBL_MY_TEAM_PIPELINE" DivEditName="my_pipeline_edit" Runat="Server" />
	<p></p>
	<SplendidCRM:DatePickerValidator ID="valDATE_START" ControlToValidate="ctlDATE_START" CssClass="required" EnableClientScript="false" EnableViewState="false" Enabled="false" Display="Dynamic" Runat="server" />
	<SplendidCRM:DatePickerValidator ID="valDATE_END"   ControlToValidate="ctlDATE_END"   CssClass="required" EnableClientScript="false" EnableViewState="false" Enabled="false" Display="Dynamic" Runat="server" />
	<div ID="my_pipeline_edit" style="DISPLAY: <%= bShowEditDialog ? "inline" : "none" %>">
		<asp:Table BorderWidth="0" CellPadding="0" CellSpacing="0" CssClass="chartForm" HorizontalAlign="Center" runat="server">
			<asp:TableRow>
				<asp:TableCell VerticalAlign="top" Wrap="false">
					<b><%# L10n.Term("Dashboard.LBL_DATE_START") %> </b><br />
					<asp:Label CssClass="dateFormat" Text='<%# System.Threading.Thread.CurrentThread.CurrentCulture.DateTimeFormat.ShortDatePattern.ToUpper() %>' runat="server" />
				</asp:TableCell>
				<asp:TableCell VerticalAlign="top">
					<SplendidCRM:ChartDatePicker ID="ctlDATE_START" Runat="Server" />
				</asp:TableCell>
			</asp:TableRow>
			<asp:TableRow>
				<asp:TableCell VerticalAlign="top" Wrap="false">
					<b><%# L10n.Term("Dashboard.LBL_DATE_END") %></b><br />
					<asp:Label CssClass="dateFormat" Text='<%# System.Threading.Thread.CurrentThread.CurrentCulture.DateTimeFormat.ShortDatePattern.ToUpper() %>' runat="server" />
				</asp:TableCell>
				<asp:TableCell VerticalAlign="top">
					<SplendidCRM:ChartDatePicker ID="ctlDATE_END" Runat="Server" />
				</asp:TableCell>
			</asp:TableRow>
			<asp:TableRow>
				<asp:TableCell VerticalAlign="top" Wrap="false"><b><%# L10n.Term("Dashboard.LBL_SALES_STAGES") %></b></asp:TableCell>
				<asp:TableCell VerticalAlign="top">
					<asp:ListBox ID="lstSALES_STAGE" DataValueField="NAME" DataTextField="DISPLAY_NAME" SelectionMode="Multiple" Rows="3" Runat="server" />
				</asp:TableCell>
			</asp:TableRow>
			<asp:TableRow>
				<asp:TableCell HorizontalAlign="Right" ColumnSpan="2">
					<asp:Button ID="btnSubmit" CommandName="Submit" OnCommand="Page_Command"                    CssClass="button" Text='<%# "  " + L10n.Term(".LBL_SELECT_BUTTON_LABEL") + "  " %>' ToolTip='<%# L10n.Term(".LBL_SELECT_BUTTON_TITLE") %>' AccessKey='<%# L10n.AccessKey(".LBL_SELECT_BUTTON_KEY") %>' runat="server" />
					<asp:Button ID="btnEdit"   UseSubmitBehavior="false" OnClientClick="toggleDisplay('my_pipeline_edit'); return false;" CssClass="button" Text='<%# "  " + L10n.Term(".LBL_CANCEL_BUTTON_LABEL") + "  " %>' ToolTip='<%# L10n.Term(".LBL_CANCEL_BUTTON_TITLE") %>' AccessKey='<%# L10n.AccessKey(".LBL_CANCEL_BUTTON_KEY") %>' runat="server" />
				</asp:TableCell>
			</asp:TableRow>
		</asp:Table>
	</div>
	<p></p>
	<div Visible="<%# bDebug %>" align="center" runat="server">
		<asp:HyperLink ID="lnkXML" NavigateUrl=<%# Application["rootURL"] + "Opportunities/xml/PipelineBySalesStage.aspx?" + ViewState["MyPipelineQueryString"] %> Text="XML" Target="xml" Visible="<%# bDebug %>" runat="server" /><br />
	</div>
	<div align="center">
<%@ Register TagPrefix="SplendidCRM" Tagname="MyPipelineBySalesStage" Src="~/Opportunities/xaml/MyPipelineBySalesStage.ascx" %>
<script type="text/xaml" id="xamlMyPipelineBySalesStage"><?xml version="1.0"?>
<SplendidCRM:MyPipelineBySalesStage CHART_LENGTH="4" Visible="<%# SplendidCRM.Crm.Config.enable_silverlight() %>" Runat="Server" />
</script>
	<asp:Panel Visible="<%# SplendidCRM.Crm.Config.enable_silverlight() %>" runat="server">
		<div id="hostMyPipelineBySalesStage" style="width: 350px; height: 400px; padding-bottom: 2px;" align="center"></div>
<SplendidCRM:InlineScript runat="server">
			<script type="text/javascript">
			Silverlight.createObjectEx({
				source: "#xamlMyPipelineBySalesStage",
				parentElement: document.getElementById("hostMyPipelineBySalesStage"),
				id: "SilverlightControl",
				properties: {
					width: "350",
					height: "400",
					version: "1.0",
					enableHtmlAccess: "true",
					isWindowless: "true" /* 05/08/2010 Paul.  The isWindowless allows HTML to appear over a silverlight app. */
				},
				events: {}
			});
			</script>
</SplendidCRM:InlineScript>
	</asp:Panel>
	</div>
	<div align="center" Visible="<%# SplendidCRM.Crm.Config.enable_flash() %>" runat="server">
	<object width="350" height="400" align="" classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="https://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,0,0" viewastext>
		<param name="movie"   value="<%= Application["chartURL" ] %>hBarS.swf?filename=<%= Server.UrlEncode(Application["rootURL"] + "Opportunities/xml/PipelineBySalesStage.aspx?" + ViewState["MyPipelineQueryString"]) %>">
		<param name="bgcolor" value="#FFFFFF" />
		<param name="wmode"   value="transparent" />
		<param name="quality" value="high" />
		<embed src="<%= Application["chartURL" ] %>hBarS.swf?filename=<%= Server.UrlEncode(Application["rootURL"] + "Opportunities/xml/PipelineBySalesStage.aspx?" + ViewState["MyPipelineQueryString"]) %>" wmode="transparent" quality=high bgcolor=#FFFFFF  WIDTH="350" HEIGHT="400" NAME="hBarS" ALIGN="" TYPE="application/x-shockwave-flash" PLUGINSPAGE="https://www.macromedia.com/go/getflashplayer" />
	</object>
	</div>
	<span class="chartFootnote">
		<p align="center"><%# L10n.Term("Dashboard.LBL_PIPELINE_FORM_TITLE_DESC") %></p>
		<p aligh="right"><i><%# L10n.Term("Dashboard.LBL_CREATED_ON") + T10n.FromServerTime(DateTime.Now).ToString() %></i></p>
	</span>
</div>

