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
var getBusinessObject    = require('bpmn-js/lib/util/ModelUtil').getBusinessObject;
var getExtensionElements = require('bpmn-js-properties-panel/lib/helper/ExtensionElementsHelper').getExtensionElements;

let FormHelper: any = {};

export default FormHelper;

/**
 * Return the form type of an element: Checks if the 'camunda:FormData'
 * exists in the extensions elements and returns 'form-data' when true.
 * If it does not exist, 'form-key' is returned.
 *
 * @param  {djs.model.Base} element
 *
 * @return {string} a form type (either 'form-key' or 'form-value')
 */
/*
FormHelper.getFormType = function(element)
{
	var bo = getBusinessObject(element);
	var formData = getExtensionElements(bo, 'crm:CrmMessageReports');
	var formType = 'form-key';

	if (formData)
	{
		formType = 'form-data';
	}
	return formType;
};
*/

/**
 * Return all form fields existing in the business object, and
 * an empty array if none exist.
 *
 * @param  {djs.model.Base} element
 *
 * @return {Array} a list of form field objects
 */
FormHelper.getFormFields = function(element)
{
	var bo = getBusinessObject(element);
	var formData = getExtensionElements(bo, 'crm:CrmMessageReports');

	if (typeof formData !== 'undefined')
	{
		return formData[0].fields;
	}
	else
	{
		return [];
	}
};


/**
 * Get a form field from the business object at given index
 *
 * @param {djs.model.Base} element
 * @param {number} idx
 *
 * @return {ModdleElement} the form field
 */
FormHelper.getFormField = function(element, idx)
{
	var formFields = this.getFormFields(element);
	// 09/07/2016 Paul.  It is hard to catch these bugs, so throw to the debugger. 
	if ( formFields === undefined )
	{
		console.log('formHelper.getFormField: formFields is undefined');
		// 06/23/2017 Paul.  Should have disabled debugger before production build. 
		//debugger;
	}
	return formFields[idx];
};


/**
 * Get all camunda:value objects for a specific form field from the business object
 *
 * @param  {ModdleElement} formField
 *
 * @return {Array<ModdleElement>} a list of camunda:value objects
 */
FormHelper.getEnumValues = function(formField)
{
	if (formField && formField.values)
	{
		return formField.values;
	}
	return [];
};

