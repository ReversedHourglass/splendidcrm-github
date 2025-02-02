<%@ Page language="c#" MasterPageFile="~/PopupView.Master" Codebehind="OAuthLanding.aspx.cs" AutoEventWireup="false" Inherits="SplendidCRM.Import.OAuthLanding" %>
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
<asp:Content ID="cntBody" ContentPlaceHolderID="cntBody" runat="server">
<script type="text/javascript">
function getQuerystring(key, default_)
{
	if ( default_ == null || typeof(default_) == 'undefined' )
		default_ = '';
	key = key.replace(/[\[]/,"\\\[").replace(/[\]]/,"\\\]");
	// 04/13/2012 Paul.  For some odd reason, facebook is using # and not ? as the separator. 
	var regex = new RegExp("[\\?&#]"+key+"=([^&#]*)");
	var qs = regex.exec(window.location.href);
	if ( qs == null )
		return default_;
	else
		return qs[1];
}


window.onload = function()
{
	var divDebug = document.getElementById('divDebug');
	divDebug.innerHTML = window.location.href;
	try
	{
		var oauth_token    = getQuerystring('oauth_token'   );
		var oauth_verifier = getQuerystring('oauth_verifier');
		var access_token   = getQuerystring('access_token'  );
		var instance_url   = getQuerystring('instance_url'  );
		if ( access_token != '' )
			oauth_token = decodeURIComponent(access_token);
		if ( instance_url != '' )
			oauth_verifier = decodeURIComponent(instance_url);
		// 06/03/2014 Paul.  Extract the QuickBooks realmId (same as Company ID). 
		var realmId   = getQuerystring('realmId');
		// 04/23/2015 Paul.  HubSpot has more data. 
		var refresh_token  = getQuerystring('refresh_token' );
		var expires_in     = getQuerystring('expires_in'    );
		if ( refresh_token != '' )
			refresh_token = decodeURIComponent(refresh_token);

		window.opener.OAuthTokenUpdate(oauth_token, oauth_verifier, realmId, refresh_token, expires_in);
		window.close();
	}
	catch(e)
	{
		divDebug.innerHTML += '<p>' + e.message;
	}
}
</script>
<div id="divDebug"></div>
</asp:Content>
