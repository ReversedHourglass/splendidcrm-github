/*
 * Copyright (C) 2005-2023 SplendidCRM Software, Inc. All rights reserved.
 *
 * Any use of the contents of this file are subject to the SplendidCRM Professional Source Code License 
 * Agreement, or other written agreement between you and SplendidCRM ("License"). By installing or 
 * using this file, you have unconditionally agreed to the terms and conditions of the License, 
 * including but not limited to restrictions on the number of users therein, and you may not use this 
 * file except in compliance with the License. 
 * 
 */

define(function()
{
	var sMODULE_NAME    = 'Emails';
	var sGRID_NAME      = sMODULE_NAME + '.My' + sMODULE_NAME;
	var sTABLE_NAME     = 'vw' + sMODULE_NAME.toUpperCase();
	var sSORT_FIELD     = 'DATE_START';
	var sSORT_DIRECTION = 'desc';

	return {
		Render: function(sLayoutPanel, sActionsPanel, sSCRIPT_URL, sSETTINGS_EDITVIEW, sDEFAULT_SETTINGS)
		{
			var divDashboardPanel = document.getElementById(sLayoutPanel);
			if ( divDashboardPanel != null )
			{
				var divDashletBody = document.createElement('div');
				divDashletBody.id = sLayoutPanel + '_divDashletBody';
				divDashletBody.align = 'center';
				divDashboardPanel.appendChild(divDashletBody);
				var divDashletError = document.createElement('div');
				divDashletError.id = sLayoutPanel + '_divDashletError';
				divDashletError.className = 'error';
				divDashletBody.appendChild(divDashletError);
				var divDashletHTML5 = document.createElement('div');
				divDashletHTML5.id = sLayoutPanel + '_divDashletHTML5';
				divDashletHTML5.style.width = '100%';
				divDashletBody.appendChild(divDashletHTML5);
				
				var rowDefaultSearch = Sql.ParseFormData(sDEFAULT_SETTINGS);
				SearchViewUI_Load(sLayoutPanel, sActionsPanel, sMODULE_NAME, sSETTINGS_EDITVIEW, rowDefaultSearch, false, this.Search, function(status, message)
				{
					if ( status == 1 )
					{
						SearchViewUI_SearchForm(sLayoutPanel, sActionsPanel, sSETTINGS_EDITVIEW, this.Search, this);
					}
					else
					{
						$('#' + sLayoutPanel + '_divDashletError').text('Dashlet error: ' + message);
					}
				}, this);
			}
		},
		Search: function(sLayoutPanel, sActionsPanel, sSEARCH_FILTER, rowSEARCH_VALUES)
		{
			var bgPage = chrome.extension.getBackgroundPage();
			bgPage.AuthenticatedMethod(function(status, message)
			{
				if ( status == 1 )
				{
					if ( !Sql.IsEmptyString(sSEARCH_FILTER) )
						sSEARCH_FILTER += ' and ';
					sSEARCH_FILTER += 'dbo.fnDateOnly(DATE_MODIFIED) > dbo.fnDateSpecial(\'last month\')';
					//$('#' + sLayoutPanel + '_divDashletError').text('Search: ' + sSEARCH_FILTER);

					var divDashletHTML5 = document.getElementById(sLayoutPanel + '_divDashletHTML5');
					while ( divDashletHTML5.childNodes.length > 0 )
					{
						divDashletHTML5.removeChild(divDashletHTML5.firstChild);
					}
			
					try
					{
						var sPRIMARY_ID     = null;
						var oListViewUI = new ListViewUI();
						oListViewUI.LoadRelatedModule(divDashletHTML5.id, sActionsPanel, sMODULE_NAME, sMODULE_NAME, sGRID_NAME, sTABLE_NAME, sSORT_FIELD, sSORT_DIRECTION, sSEARCH_FILTER, sPRIMARY_ID, function(status, message)
						{
							if ( status != 1 )
								$('#' + sLayoutPanel + '_divDashletError').text('Dashlet error: ' + message);
						});
					}
					catch(e)
					{
						$('#' + sLayoutPanel + '_divDashletError').text(e.message);
					}
				}
			}, this);
		}
	};
});
