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

// 1. React and fabric. 
import * as React from 'react';
import { FontAwesomeIcon }                   from '@fortawesome/react-fontawesome' ;
// 2. Store and Types. 
// 3. Scripts. 
import L10n                                  from '../../scripts/L10n'             ;
import Sql                                   from '../../scripts/Sql'              ;
import Credentials                           from '../../scripts/Credentials'      ;
import SplendidCache                         from '../../scripts/SplendidCache'    ;
import { Crm_Config, Crm_Modules }           from '../../scripts/Crm'              ;
import { screenWidth, screenHeight }         from '../../scripts/utility'          ;
// 4. Components and Views. 
import DynamicButtons                        from '../../components/DynamicButtons';
import { ISubPanelHeaderButtonsProps, SubPanelHeaderButtons} from '../../types/SubPanelHeaderButtons';

export default class ArcticSubPanelHeaderButtons extends SubPanelHeaderButtons
{
	private dynamicButtons = React.createRef<DynamicButtons>();

	constructor(props: ISubPanelHeaderButtonsProps)
	{
		super(props);
		let nACLACCESS_Help: number = SplendidCache.GetUserAccess("Help", 'edit');
		let helpText       : string = (nACLACCESS_Help >= 0 && Crm_Config.ToBoolean('enable_help_wiki') ? L10n.Term('.LNK_HELP_WIKI') : L10n.Term('.LNK_HELP') );
		let streamEnabled  : boolean = Crm_Modules.StreamEnabled(props.MODULE_NAME);
		let archiveView    : boolean = false;
		// 11/10/2020 Paul.  A customer wants to be able to have subpanels default to open. 
		let rawOpen        : string  = localStorage.getItem(props.CONTROL_VIEW_NAME);
		// 04/10/2021 Paul.  Create framework to allow pre-compile of all modules. 
		let open           : boolean = (rawOpen == 'true' || this.props.isPrecompile);
		if ( rawOpen == null && Crm_Config.ToBoolean('default_subpanel_open') )
		{
			open = true;
		}

		if ( props.location != undefined && props.location.pathname.indexOf('/ArchiveView') >= 0 )
		{
			archiveView = true;
		}
		this.state =
		{
			helpText     ,
			archiveView  ,
			streamEnabled,
			headerError  : null,
			localKey     : '',
			open         ,
		};
	}

	public Busy = (): void =>
	{
		if ( this.dynamicButtons.current != null )
		{
			this.dynamicButtons.current.Busy();
		}
	}

	public NotBusy = (): void =>
	{
		if ( this.dynamicButtons.current != null )
		{
			this.dynamicButtons.current.NotBusy();
		}
	}

	public DisableAll = (): void =>
	{
		if ( this.dynamicButtons.current != null )
		{
			this.dynamicButtons.current.DisableAll();
		}
	}

	public EnableAll = (): void =>
	{
		if ( this.dynamicButtons.current != null )
		{
			this.dynamicButtons.current.EnableAll();
		}
	}

	public HideAll = (): void =>
	{
		if ( this.dynamicButtons.current != null )
		{
			this.dynamicButtons.current.HideAll();
		}
	}

	public ShowAll = (): void =>
	{
		if ( this.dynamicButtons.current != null )
		{
			this.dynamicButtons.current.ShowAll();
		}
	}

	public EnableButton = (COMMAND_NAME: string, enabled: boolean): void =>
	{
		if ( this.dynamicButtons.current != null )
		{
			this.dynamicButtons.current.EnableButton(COMMAND_NAME, enabled);
		}
	}

	public ShowButton = (COMMAND_NAME: string, visible: boolean): void =>
	{
		if ( this.dynamicButtons.current != null )
		{
			this.dynamicButtons.current.ShowButton(COMMAND_NAME, visible);
		}
	}

	public ShowHyperLink = (URL: string, visible: boolean): void =>
	{
		if ( this.dynamicButtons.current != null )
		{
			this.dynamicButtons.current.ShowHyperLink(URL, visible);
		}
	}

	private toggle = () =>
	{
		this.setState({ open: !this.state.open }, () =>
		{
			if ( this.props.onToggle )
			{
				this.props.onToggle(this.state.open);
			}
		});
	}

	public render()
	{
		const { MODULE_NAME, MODULE_TITLE, SUB_TITLE, ID, error } = this.props;
		const { ButtonStyle, FrameStyle, ContentStyle, VIEW_NAME, LINK_NAME, row, Page_Command, onLayoutLoaded, showButtons } = this.props;
		const { helpText, archiveView, streamEnabled, localKey, headerError, open } = this.state;
		
		let sMODULE_TITLE: string = !Sql.IsEmptyString(MODULE_TITLE) ? L10n.Term(MODULE_TITLE) : L10n.Term('.moduleList.' + MODULE_NAME);
		let themeURL     : string = Credentials.RemoteServer + 'App_Themes/' + SplendidCache.UserTheme + '/';
		let sError       : string = null;
		if ( error !== undefined && error != null )
		{
			if ( error.message !== undefined )
			{
				sError = error.message;
			}
			else if ( typeof(error) == 'string' )
			{
				sError = error;
			}
			else if ( typeof(error) == 'object' )
			{
				sError = JSON.stringify(error);
			}
		}
		else if ( headerError !== undefined && headerError != null )
		{
			if ( headerError.message !== undefined )
			{
				sError = headerError.message;
			}
			else if ( typeof(headerError) == 'string' )
			{
				sError = headerError;
			}
			else if ( typeof(headerError) == 'object' )
			{
				sError = JSON.stringify(headerError);
			}
		}
		// 04/28/2019 Paul.  Can't use react-bootstrap Breadcrumb as it will reload the app is is therefore slow. 
		// 07/09/2019 Paul.  Use span instead of a tag to prevent navigation. 
		return (
			<React.Fragment>
				<div id={ 'divModuleHeader' + MODULE_NAME }>
					<table className={ !open ? 'h3Row h3RowDisabled' : 'h3Row' } cellPadding={ 0 } cellSpacing={ 1 } style={ {width: '100%'} }>
						<tr>
							<td style={ {verticalAlign: 'center', textAlign: 'left', paddingTop: 3, paddingLeft: 5, paddingRight: 15, width: '98%'} }>
								<a onClick={ this.toggle }>
									<span className="h3Button"><FontAwesomeIcon icon={ open ? 'minus' : 'plus' } size='lg' /></span>
									<span className="h3Row" style={ {paddingLeft: '10px', cursor: 'pointer'} }>{ sMODULE_TITLE }</span>
								</a>
							</td>
							<td style={ {textAlign: 'right'} }>
								{ open && showButtons 
								? <DynamicButtons
									ButtonStyle={ ButtonStyle }
									FrameStyle={ FrameStyle }
									ContentStyle={ ContentStyle }
									VIEW_NAME={ VIEW_NAME }
									row={ row }
									Page_Command={ Page_Command }
									onLayoutLoaded={ onLayoutLoaded }
									history={ this.props.history }
									location={ this.props.location }
									match={ this.props.match }
									ref={ this.dynamicButtons }
									/>
								: null
								}
							</td>
						</tr>
					</table>
					{ open
					? <React.Fragment>
						{ !Sql.IsEmptyString(sError)
						? <div className='error'>{ sError }</div>
						: null
						}
					</React.Fragment>
					: null
					}
				</div>
			</React.Fragment>
		);
	}
}

// 12/05/2019 Paul.  We don't want to use withRouter() as it makes it difficult to get a reference. 

