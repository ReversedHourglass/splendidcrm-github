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
import { IEditComponentProps, EditComponent } from '../types/EditComponent';
// 3. Scripts. 
import Sql                                    from '../scripts/Sql'         ;
import L10n                                   from '../scripts/L10n'        ;
// 4. Components and Views. 

interface IEditComponentState
{
	ID               : string;
	FIELD_INDEX      : number;
	DATA_LABEL?      : string;
	DATA_FIELD?      : string;
	DATA_VALUE?      : string;
	DATA_FORMAT?     : string;
	CSS_CLASS?       : string;
}

export default class SplendidButton extends React.Component<IEditComponentProps, IEditComponentState>
{
	public get data(): any
	{
		return null;
	}

	public validate(): boolean
	{
		return true;
	}

	public updateDependancy(PARENT_FIELD: string, DATA_VALUE: any, PROPERTY_NAME?: string, item?: any): void
	{
		if ( PROPERTY_NAME == 'class' )
		{
			this.setState({ CSS_CLASS: DATA_VALUE });
		}
	}

	public clear(): void
	{
	}

	constructor(props: IEditComponentProps)
	{
		super(props);
		let FIELD_INDEX      : number = 0;
		let DATA_LABEL       : string = '';
		let DATA_FIELD       : string = '';
		let DATA_VALUE       : string = '';
		let DATA_FORMAT      : string = '';

		let ID: string = null;
		try
		{
			const { baseId, layout, row } = this.props;
			if ( layout != null )
			{
				FIELD_INDEX       = Sql.ToInteger(layout.FIELD_INDEX);
				DATA_LABEL        = Sql.ToString (layout.DATA_LABEL );
				DATA_FIELD        = Sql.ToString (layout.DATA_FIELD );
				DATA_FORMAT       = Sql.ToString (layout.DATA_FORMAT);
				// 12/24/2012 Paul.  Use regex global replace flag. 
				ID = baseId + '_' + DATA_FIELD.replace(/\s/g, '_');
				
				// 05/01/2020 Paul.  New approach is to put button label in the label field. 
				if ( !Sql.IsEmptyString(DATA_LABEL) )
				{
					if ( DATA_LABEL.indexOf('.') >= 0 )
					{
						DATA_VALUE = L10n.Term(DATA_LABEL);
					}
					else if ( row != null && !Sql.IsEmptyString(DATA_LABEL) )
					{
						DATA_VALUE = Sql.ToString(row[DATA_LABEL]);
					}
				}
				else if ( !Sql.IsEmptyString(DATA_FIELD) )
				{
					if ( DATA_FIELD.indexOf('.') >= 0 )
					{
						DATA_VALUE = L10n.Term(DATA_FIELD);
					}
					else if ( row != null && !Sql.IsEmptyString(DATA_FIELD) )
					{
						DATA_VALUE = Sql.ToString(row[DATA_FIELD]);
					}
				}
			}
			//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.constructor ' + DATA_FIELD, DATA_VALUE, row);
		}
		catch(error)
		{
			console.error((new Date()).toISOString() + ' ' + this.constructor.name + '.constructor', error);
		}
		this.state =
		{
			ID         ,
			FIELD_INDEX,
			DATA_LABEL ,
			DATA_FIELD ,
			DATA_VALUE ,
			DATA_FORMAT,
			CSS_CLASS  : 'button'
		};
	}

	async componentDidMount()
	{
		const { DATA_FIELD } = this.state;
		if ( this.props.fieldDidMount )
		{
			this.props.fieldDidMount(DATA_FIELD, this);
		}
	}

	shouldComponentUpdate(nextProps: IEditComponentProps, nextState: IEditComponentState)
	{
		const { DATA_FIELD, DATA_VALUE } = this.state;
		if ( nextProps.row != this.props.row )
		{
			//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.shouldComponentUpdate ' + DATA_FIELD, DATA_VALUE, nextProps, nextState);
			return true;
		}
		else if ( nextProps.layout != this.props.layout )
		{
			//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.shouldComponentUpdate ' + DATA_FIELD, DATA_VALUE, nextProps, nextState);
			return true;
		}
		// 11/02/2019 Paul.  Hidden property is used to dynamically hide and show layout fields. 
		else if ( nextProps.bIsHidden != this.props.bIsHidden )
		{
			//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.shouldComponentUpdate ' + DATA_FIELD, DATA_VALUE, nextProps, nextState);
			return true;
		}
		else if ( nextState.DATA_VALUE != this.state.DATA_VALUE )
		{
			//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.shouldComponentUpdate ' + DATA_FIELD, DATA_VALUE, nextProps, nextState);
			return true;
		}
		else if ( nextState.CSS_CLASS != this.state.CSS_CLASS )
		{
			//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.shouldComponentUpdate ' + DATA_FIELD, CSS_CLASS, nextProps, nextState);
			return true;
		}
		return false;
	}

	private _onClick = () =>
	{
		const { Page_Command } = this.props;
		const { DATA_FORMAT, DATA_FIELD } = this.state;
		if ( Page_Command != null )
		{
			Page_Command(DATA_FORMAT, DATA_FIELD);
		}
	}

	public render()
	{
		const { baseId, layout, row } = this.props;
		const { ID, FIELD_INDEX, DATA_FIELD, DATA_VALUE, CSS_CLASS } = this.state;
		if ( layout == null )
		{
			return (<span>layout prop is null</span>);
		}
		else if ( Sql.IsEmptyString(DATA_FIELD) )
		{
			return (<span>DATA_FIELD is empty for FIELD_INDEX { FIELD_INDEX }</span>);
		}
		// 11/02/2019 Paul.  Hidden property is used to dynamically hide and show layout fields. 
		else if ( layout.hidden )
		{
			return (<span></span>);
		}
		else
		{
			return (
			<button className={ CSS_CLASS } id={ ID } key={ ID } onClick={ this._onClick } title={ DATA_VALUE } style={ {marginLeft: '4px'} }>
				{ DATA_VALUE }
			</button>);
		}
	}
}

