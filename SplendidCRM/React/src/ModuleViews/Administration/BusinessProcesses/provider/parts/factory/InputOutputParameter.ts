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
import L10n              from '../../../../../../scripts/L10n';

var is                    = require('bpmn-js/lib/util/ModelUtil').is;
var elementHelper         = require('bpmn-js-properties-panel/lib/helper/ElementHelper');
var inputOutputHelper     = require('bpmn-js-properties-panel/lib/helper/InputOutputHelper');
var cmdHelper             = require('bpmn-js-properties-panel/lib/helper/CmdHelper');
var utils                 = require('bpmn-js-properties-panel/lib/Utils');
var entryFactory          = require('bpmn-js-properties-panel/lib/factory/EntryFactory');
//var script                = require('bpmn-js-properties-panel/lib/provider/camunda/parts/implementation/Script')('scriptFormat', 'value', true);

/*
function createElement(type, parent, factory, properties)
{
	return elementHelper.createElement(type, properties, parent, factory);
}

function isScript(elem)
{
	return is(elem, 'camunda:Script');
}

function isList(elem)
{
	return is(elem, 'camunda:List');
}

function isMap(elem)
{
	return is(elem, 'camunda:Map');
}

var typeInfo =
{
	'camunda:Map':
	{
		value: 'map',
		label: 'Map'
	},
	'camunda:List':
	{
		value: 'list',
		label: 'List'
	},
	'camunda:Script':
	{
		value: 'script',
		label: 'Script'
	}
};
*/

function ensureInputOutputSupported(element, insideConnector)
{
	return inputOutputHelper.isInputOutputSupported(element, insideConnector);
}

export default function(element, bpmnFactory, options)
{
	options = options || {};

	var insideConnector = !!options.insideConnector;
	var idPrefix        = options.idPrefix || '';
	var getSelected     = options.getSelectedParameter;

	if ( !ensureInputOutputSupported(element, insideConnector) )
	{
		return [];
	}

	var entries = [];
	var isSelected = function(element, node)
	{
		return getSelected(element, node);
	};

	// parameter name ////////////////////////////////////////////////////////
	entries.push(entryFactory.validationAwareTextField(
	{
		id            : idPrefix + 'parameterName',
		label         : L10n.Term('BusinessProcesses.LBL_BPMN_PARAMETER_NAME'),
		modelProperty : 'name',
		getProperty : function(element, node)
		{
			return (getSelected(element, node) || {}).name;
		},
		setProperty : function(element, values, node)
		{
			var param = getSelected(element, node);
			return cmdHelper.updateBusinessObject(element, param, values);
		},
		validate : function(element, values, node)
		{
			var bo = getSelected(element, node);
			let validation: any = {};
			if (bo)
			{
				var nameValue = values.name;
				if ( nameValue )
				{
					if ( utils.containsSpace(nameValue) )
					{
						validation.name = L10n.Term('BusinessProcesses.ERR_BPMN_PARAMETER_NAME_SPACES');  // 'Name must not contain spaces';
					}
				}
				else
				{
					validation.name = L10n.Term('BusinessProcesses.ERR_BPMN_PARAMETER_NAME_REQUIRED');  // 'Parameter must have a name';
				}
			}
			return validation;
		},
		disabled : function(element, node)
		{
			return !isSelected(element, node);
		}
	}));

	/*
	// parameter type //////////////////////////////////////////////////////
	var selectOptions =
	[
		{ value: 'text'  , name: 'Text'   },
		{ value: 'script', name: 'Script' },
		{ value: 'list'  , name: 'List'   },
		{ value: 'map'   , name: 'Map'    }
	];

	entries.push(entryFactory.selectBox(
	{
		id            : idPrefix + 'parameterType',
		label         : 'Type',
		selectOptions : selectOptions,
		modelProperty : 'parameterType',
		get : function(element, node)
		{
			var bo = getSelected(element, node);
			var parameterType = 'text';
			if ( typeof bo !== 'undefined')
			{
				var definition = bo.get('definition');
				if ( typeof definition !== 'undefined' )
				{
					var type = definition.$type;
					parameterType = typeInfo[type].value;
				}
			}
			return { parameterType: parameterType };
		},
		set : function(element, values, node)
		{
			var bo = getSelected(element, node);
			var properties =
			{
				value: undefined,
				definition: undefined
			};
			var createParameterTypeElem = function(type)
			{
				return createElement(type, bo, bpmnFactory);
			};
			var parameterType = values.parameterType;
			if ( parameterType === 'script' )
			{
				properties.definition = createParameterTypeElem('camunda:Script');
			}
			else if ( parameterType === 'list' )
			{
				properties.definition = createParameterTypeElem('camunda:List');
			}
			else if ( parameterType === 'map' )
			{
				properties.definition = createParameterTypeElem('camunda:Map');
			}
			return cmdHelper.updateBusinessObject(element, bo, properties);
		},
		show: function(element, node)
		{
			return isSelected(element, node);
		}
	}));
	*/

	// parameter value (type = text) ///////////////////////////////////////////////////////
	// 05/10/2022 Paul.  Changed to textBox. 
	entries.push(entryFactory.textBox(
	{
		id            : idPrefix + 'parameterType-text',
		label         : L10n.Term('BusinessProcesses.LBL_BPMN_PARAMETER_VALUE'),
		modelProperty : 'value',
		get : function(element, node)
		{
			return { value: (getSelected(element, node) || {}).value };
		},
		set : function(element, values, node)
		{
			var param = getSelected(element, node);
			values.value = values.value || undefined;
			return cmdHelper.updateBusinessObject(element, param, values);
		},
		show : function(element, node)
		{
			var bo = getSelected(element, node);
			return bo && !bo.definition;
		}
	}));

	/*
	// parameter value (type = script) ///////////////////////////////////////////////////////
	entries.push(
	{
		id   : idPrefix + 'parameterType-script',
		html : '<div data-show="isScript">' + script.template + '</div>',
		get  : function(element, node)
		{
			var bo = getSelected(element, node);
			return bo && isScript(bo.definition) ? script.get(element, bo.definition) : {};
		},
		set : function(element, values, node)
		{
			var bo = getSelected(element, node);
			var update = script.set(element, values);
			return cmdHelper.updateBusinessObject(element, bo.definition, update);
		},
		validate: function(element, values, node)
		{
			var bo = getSelected(element, node);
			return bo && isScript(bo.definition) ? script.validate(element, bo.definition) : {};
		},
		isScript: function(element, node)
		{
			var bo = getSelected(element, node);
			return bo && isScript(bo.definition);
		},
		script: script
	});

	// parameter value (type = list) ///////////////////////////////////////////////////////
	entries.push(entryFactory.table(
	{
		id              : idPrefix + 'parameterType-list',
		modelProperties : [ 'value' ],
		labels          : [ 'Value' ],
		getElements: function(element, node)
		{
			var bo = getSelected(element, node);
			if (bo && isList(bo.definition))
			{
				return bo.definition.items;
			}
			return [];
		},
		updateElement : function(element, values, node, idx)
		{
			var bo = getSelected(element, node);
			var item = bo.definition.items[idx];
			return cmdHelper.updateBusinessObject(element, item, values);
		},
		addElement: function(element, node)
		{
			var bo = getSelected(element, node);
			var newValue = createElement('camunda:Value', bo.definition, bpmnFactory, { value: undefined });
			return cmdHelper.addElementsTolist(element, bo.definition, 'items', [ newValue ]);
		},
		removeElement: function(element, node, idx)
		{
			var bo = getSelected(element, node);
			return cmdHelper.removeElementsFromList(element, bo.definition, 'items', null, [ bo.definition.items[idx] ]);
		},
		editable: function(element, node, prop, idx)
		{
			var bo = getSelected(element, node);
			var item = bo.definition.items[idx];
			return !isMap(item) && !isList(item) && !isScript(item);
		},
		setControlValue: function(element, node, input, prop, value, idx)
		{
			var bo = getSelected(element, node);
			var item = bo.definition.items[idx];
			if ( !isMap(item) && !isList(item) && !isScript(item) )
			{
				input.value = value;
			}
			else
			{
				input.value = typeInfo[item.$type].label;
			}
		},
		show : function(element, node)
		{
			var bo = getSelected(element, node);
			return bo && bo.definition && isList(bo.definition);
		}
	}));

	// parameter value (type = map) ///////////////////////////////////////////////////////
	entries.push(entryFactory.table(
	{
		id              : idPrefix + 'parameterType-map',
		modelProperties : [ 'key', 'value' ],
		labels          : [ 'Key', 'Value' ],
		addLabel        : 'Add Entry',
		getElements : function(element, node)
		{
			var bo = getSelected(element, node);
			if ( bo && isMap(bo.definition) )
			{
				return bo.definition.entries;
			}
			return [];
		},
		updateElement : function(element, values, node, idx)
		{
			var bo = getSelected(element, node);
			var entry = bo.definition.entries[idx];
			if ( isMap(entry.definition) || isList(entry.definition) || isScript(entry.definition) )
			{
				values = { key: values.key };
			}
			return cmdHelper.updateBusinessObject(element, entry, values);
		},
		addElement : function(element, node)
		{
			var bo = getSelected(element, node);
			var newEntry = createElement('camunda:Entry', bo.definition, bpmnFactory, { key: undefined, value: undefined });
			return cmdHelper.addElementsTolist(element, bo.definition, 'entries', [ newEntry ]);
		},
		removeElement : function(element, node, idx)
		{
			var bo = getSelected(element, node);
			return cmdHelper.removeElementsFromList(element, bo.definition, 'entries', null, [ bo.definition.entries[idx] ]);
		},
		editable : function(element, node, prop, idx)
		{
			var bo = getSelected(element, node);
			var entry = bo.definition.entries[idx];
			return prop === 'key' || (!isMap(entry.definition) && !isList(entry.definition) && !isScript(entry.definition));
		},
		setControlValue : function(element, node, input, prop, value, idx)
		{
			var bo = getSelected(element, node);
			var entry = bo.definition.entries[idx];
			if ( prop === 'key' || (!isMap(entry.definition) && !isList(entry.definition) && !isScript(entry.definition)) )
			{
				input.value = value;
			}
			else
			{
				input.value = typeInfo[entry.definition.$type].label;
			}
		},
		show : function(element, node)
		{
			var bo = getSelected(element, node);
			return bo && bo.definition && isMap(bo.definition);
		}
	}));
	*/
	return entries;
};
