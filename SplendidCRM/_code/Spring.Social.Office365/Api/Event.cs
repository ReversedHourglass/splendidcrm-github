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
using System;
using System.Data;
using System.Text;
using System.Collections.Generic;
using System.Collections.Specialized;
using Spring.Json;

namespace Spring.Social.Office365.Api
{
	[Serializable]
	public class Event : OutlookItem
	{
		#region Properties
		public bool?               AllowNewTimeProposals      { get; set; }
		public IList<Attendee>     Attendees                  { get; set; }
		public ItemBody            Body                       { get; set; }
		public String              BodyPreview                { get; set; }
		public DateTimeTimeZone    End                        { get; set; }
		public bool?               HasAttachments             { get; set; }
		public String              ICalUId                    { get; set; }
		public String              Importance                 { get; set; }
		public bool?               IsAllDay                   { get; set; }
		public bool?               IsCancelled                { get; set; }
		public bool?               IsDraft                    { get; set; }
		public bool?               IsOnlineMeeting            { get; set; }
		public bool?               IsOrganizer                { get; set; }
		public bool?               IsReminderOn               { get; set; }
		public Location            Location                   { get; set; }
		public IList<Location>     Locations                  { get; set; }
		public OnlineMeetingInfo   OnlineMeeting              { get; set; }
		public String              OnlineMeetingProvider      { get; set; }
		public String              OnlineMeetingUrl           { get; set; }
		public Recipient           Organizer                  { get; set; }
		public String              OriginalEndTimeZone        { get; set; }
		public DateTimeOffset?     OriginalStart              { get; set; }
		public String              OriginalStartTimeZone      { get; set; }
		public PatternedRecurrence Recurrence                 { get; set; }
		public Int32?              ReminderMinutesBeforeStart { get; set; }
		public bool?               ResponseRequested          { get; set; }
		public ResponseStatus      ResponseStatus             { get; set; }
		public String              Sensitivity                { get; set; }
		public String              SeriesMasterId             { get; set; }
		public String              ShowAs                     { get; set; }
		public DateTimeTimeZone    Start                      { get; set; }
		public String              Subject                    { get; set; }
		public String              TransactionId              { get; set; }
		public String              Type                       { get; set; }
		public String              WebLink                    { get; set; }
		public IList<Attachment>   Attachments                { get; set; }
		public Calendar            Calendar                   { get; set; }
		//public IEventExtensionsCollectionPage Extensions { get; set; }
		//public IEventInstancesCollectionPage Instances { get; set; }
		//public IEventMultiValueExtendedPropertiesCollectionPage MultiValueExtendedProperties { get; set; }
		//public IEventSingleValueExtendedPropertiesCollectionPage SingleValueExtendedProperties { get; set; }
		#endregion

		public Event()
		{
			this.ODataType = "microsoft.graph.event";
		}

		public static DataTable CreateTable()
		{
			DataTable dt = new DataTable();
			dt.Columns.Add("id"                      , System.Type.GetType("System.String"  ));
			return dt;
		}

		public void SetRow(DataRow row)
		{
			for ( int i = 0; i < row.Table.Columns.Count; i++ )
			{
				row[i] = DBNull.Value;
			}
			row["id"  ] = this.Id;
		}

		public static DataRow ConvertToRow(Message obj)
		{
			DataTable dt = Message.CreateTable();
			DataRow row = dt.NewRow();
			obj.SetRow(row);
			return row;
		}

		public static DataTable ConvertToTable(IList<Message> contacts)
		{
			DataTable dt = Message.CreateTable();
			if ( contacts != null )
			{
				foreach ( Message contact in contacts )
				{
					DataRow row = dt.NewRow();
					dt.Rows.Add(row);
					contact.SetRow(row);
				}
			}
			return dt;
		}
	}

	public class EventPagination
	{
		public IList<Event>   events         { get; set; }
		public int            count          { get; set; }
		public String         nextLink       { get; set; }
		public String         deltaLink      { get; set; }
	}
}
