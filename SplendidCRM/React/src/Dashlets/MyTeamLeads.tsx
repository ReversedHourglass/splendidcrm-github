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
// 2. Store and Types. 
import IDashletProps                       from '../types/IDashletProps'        ;
// 3. Scripts. 
// 4. Components and Views. 
import BaseMyTeamDashlet                   from './BaseMyTeamDashlet'           ;

const MODULE_NAME   : string = 'Leads';
const SORT_FIELD    : string = 'DATE_ENTERED';
const SORT_DIRECTION: string = 'desc';

export default class MyTeamLeads extends React.Component<IDashletProps>
{
	public render()
	{
		//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.render', SETTINGS_EDITVIEW, DEFAULT_SETTINGS);
		return (
			<BaseMyTeamDashlet
				{ ...this.props }
				MODULE_NAME={ MODULE_NAME }
				SORT_FIELD={ SORT_FIELD }
				SORT_DIRECTION={ SORT_DIRECTION }
			/>
		)
	}
}
