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
using System.IO;
using System.Data;
using System.Data.Common;
using System.Collections.Generic;
using System.Web;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.Xml;
using System.Diagnostics;
using Microsoft.Reporting.WebForms;

namespace SplendidCRM.Reports
{
	/// <summary>
	///		Summary description for AttachmentView.
	/// </summary>
	public class AttachmentView : SplendidControl
	{
		protected Guid     gID       ;
		protected Label    lblError  ;

		// 06/26/2010 Paul.  We need a function that will just render the report. 
		// 12/04/2010 Paul.  L10n is needed by the Rules Engine to allow translation of list terms. 
		// 04/13/2011 Paul.  A scheduled report does not have a Session, so we need to create a session using the same approach used for ExchangeSync. 
		// 10/06/2012 Paul.  REPORT_ID is needed for sub-report caching. 
		public static byte[] Render(HttpContext Context, L10N L10n, TimeZone T10n, Guid gREPORT_ID, string sRDL, string sRENDER_FORMAT, string sMODULE_NAME, Guid gSCHEDULED_USER_ID, out string sMimeType, out string sExtension)
		{
			// 10/06/2012 Paul.  REPORT_ID is needed for sub-report caching. 
			// 03/24/2016 Paul.  We need an alternate way to provide parameters to render a report with a signature. 
			return Render(Context, null, null, L10n, T10n, gREPORT_ID, sRDL, sRENDER_FORMAT, sMODULE_NAME, gSCHEDULED_USER_ID, out sMimeType, out sExtension);
		}

		// 03/24/2016 Paul.  We need an alternate way to provide parameters to render a report with a signature. 
		public static byte[] Render(HttpContext Context, Dictionary<string, string> dictParameters, L10N L10n, TimeZone T10n, Guid gREPORT_ID, string sRDL, string sRENDER_FORMAT, string sMODULE_NAME, Guid gSCHEDULED_USER_ID, out string sMimeType, out string sExtension)
		{
			return Render(Context, dictParameters, null, L10n, T10n, gREPORT_ID, sRDL, sRENDER_FORMAT, sMODULE_NAME, gSCHEDULED_USER_ID, out sMimeType, out sExtension);
		}

		// 04/13/2011 Paul.  A scheduled report does not have a Session, so we need to create a session using the same approach used for ExchangeSync. 
		// 04/06/2011 Paul.  We need a way to pull data from the Parameters form. 
		// 10/06/2012 Paul.  REPORT_ID is needed for sub-report caching. 
		// 03/24/2016 Paul.  We need an alternate way to provide parameters to render a report with a signature. 
		public static byte[] Render(HttpContext Context,  Dictionary<string, string> dictParameters, SplendidControl ctlParameterView, L10N L10n, TimeZone T10n, Guid gREPORT_ID, string sRDL, string sRENDER_FORMAT, string sMODULE_NAME, Guid gSCHEDULED_USER_ID, out string sMimeType, out string sExtension)
		{
			string sReportSQL = String.Empty;
			ReportViewer rdlViewer = new ReportViewer();
			// 01/24/2010 Paul.  Pass the context so that it can be used in the Validation call. 
			// 04/13/2011 Paul.  A scheduled report does not have a Session, so we need to create a session using the same approach used for ExchangeSync. 
			// 10/06/2012 Paul.  REPORT_ID is needed for sub-report caching. 
			// 03/24/2016 Paul.  We need an alternate way to provide parameters to render a report with a signature. 
			RdlUtil.LocalLoadReportDefinition(Context, dictParameters, ctlParameterView, L10n, T10n, rdlViewer, gREPORT_ID, sRDL, sMODULE_NAME, gSCHEDULED_USER_ID, out sReportSQL);

			// http://msdn2.microsoft.com/en-us/library/ms251839(VS.80).aspx
			switch ( sRENDER_FORMAT.ToUpper() )
			{
				// 05/13/2014 Paul.  Word format is supported by ReportViewer 2012. 
				// http://msdn.microsoft.com/en-us/library/ms251671(v=vs.110).aspx
				// 09/13/2016 Paul.  Possible render formats "Excel" "EXCELOPENXML" "IMAGE" "PDF" "WORD" "WORDOPENXML". 
				// http://stackoverflow.com/questions/3494009/creating-a-custom-export-to-excel-for-reportviewer-rdlc
				// 05/07/2018 Paul.  Include all possible values. 
				case "WORD"        :  sRENDER_FORMAT = "WORDOPENXML" ;  break;
				case "WORDOPENXML" :  sRENDER_FORMAT = "WORDOPENXML" ;  break;
				case "EXCEL"       :  sRENDER_FORMAT = "EXCELOPENXML";  break;
				case "EXCELOPENXML":  sRENDER_FORMAT = "EXCELOPENXML";  break;
				case "IMAGE"       :  sRENDER_FORMAT = "Image"       ;  break;
				case "PDF"         :  sRENDER_FORMAT = "PDF"         ;  break;
				default            :  sRENDER_FORMAT = "PDF"         ;  break;
			}
			string    sEncoding   ;
			string[]  arrStreamIDs;
			Warning[] warnings    ;
			byte[] byContent = rdlViewer.LocalReport.Render(sRENDER_FORMAT, "<DeviceInfo></DeviceInfo>", out sMimeType, out sEncoding, out sExtension, out arrStreamIDs, out warnings);
			return byContent;
		}

		// 02/07/2010 Paul.  Create static function so that we can send attachment from report pages. 
		// 10/06/2012 Paul.  REPORT_ID is needed for sub-report caching. 
		public static void SendAsAttachment(HttpContext Context, L10N L10n, TimeZone T10n, Guid gREPORT_ID, string sRDL, string sRENDER_FORMAT, string sMODULE_NAME, Guid gSOURCE_ID, string sNOTE_NAME, string sDESCRIPTION, ref Guid gNOTE_ID)
		{
			SendAsAttachment(Context, null, L10n, T10n, gREPORT_ID, sRDL, sRENDER_FORMAT, sMODULE_NAME, gSOURCE_ID, sNOTE_NAME, sDESCRIPTION, ref gNOTE_ID);
		}

		// 04/06/2011 Paul.  We need a way to pull data from the Parameters form. 
		// 10/06/2012 Paul.  REPORT_ID is needed for sub-report caching. 
		public static void SendAsAttachment(HttpContext Context, SplendidControl ctlParameterView, L10N L10n, TimeZone T10n, Guid gREPORT_ID, string sRDL, string sRENDER_FORMAT, string sMODULE_NAME, Guid gSOURCE_ID, string sNOTE_NAME, string sDESCRIPTION, ref Guid gNOTE_ID)
		{
			string sMimeType ;
			string sExtension;
			// 04/13/2011 Paul.  A scheduled report does not have a Session, so we need to create a session using the same approach used for ExchangeSync. 
			// 10/06/2012 Paul.  REPORT_ID is needed for sub-report caching. 
			// 03/24/2016 Paul.  We need an alternate way to provide parameters to render a report with a signature. 
			byte[] byContent = Render(Context, null, ctlParameterView, L10n, T10n, gREPORT_ID, sRDL, sRENDER_FORMAT, sMODULE_NAME, Guid.Empty, out sMimeType, out sExtension);
			
			// 02/05/2010 Paul.  Derive the file name from the URL. 
			// 05/11/2010 Paul.  Include he extension in the file name so that it will appear in emails.
			string sFILENAME       = sNOTE_NAME + "." + sExtension;
			string sFILE_EXT       = sExtension;
			string sFILE_MIME_TYPE = sMimeType;
			
			DbProviderFactory dbf = DbProviderFactories.GetFactory();
			using ( IDbConnection con = dbf.CreateConnection() )
			{
				con.Open();
				using ( IDbTransaction trn = Sql.BeginTransaction(con) )
				{
					try
					{
						gNOTE_ID = Guid.Empty;
						// 04/02/2012 Paul.  Add ASSIGNED_USER_ID. 
						SqlProcs.spNOTES_Update
							( ref gNOTE_ID
							, L10n.Term("Emails.LBL_EMAIL_ATTACHMENT") + ": " + sFILENAME
							, (!Sql.IsEmptyGuid(gSOURCE_ID) ? sMODULE_NAME : "Reports") // Parent Type
							, gSOURCE_ID   // Parent ID
							, Guid.Empty
							, String.Empty
							, Security.TEAM_ID
							, String.Empty
							, Security.USER_ID
							// 05/17/2017 Paul.  Add Tags module. 
							, String.Empty // TAG_SET_NAME
							// 11/07/2017 Paul.  Add IS_PRIVATE for use by a large customer. 
							, false        // IS_PRIVATE
							// 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
							, String.Empty // ASSIGNED_SET_LIST
							, trn
							);
						
						Guid gNOTE_ATTACHMENT_ID = Guid.Empty;
						SqlProcs.spNOTE_ATTACHMENTS_Insert(ref gNOTE_ATTACHMENT_ID, gNOTE_ID, sDESCRIPTION, sFILENAME, sFILE_EXT, sFILE_MIME_TYPE, trn);
						using ( MemoryStream stm = new MemoryStream(byContent) )
						{
							// 11/06/2010 Paul.  Move LoadFile() to Crm.NoteAttachments. 
							Crm.NoteAttachments.LoadFile(gNOTE_ATTACHMENT_ID, stm, trn);
						}
						trn.Commit();
					}
					catch
					{
						trn.Rollback();
						throw;
					}
				}
			}
		}

		// 02/05/2021 Paul.  The React client will need to send parameters as part of a dictionary. 
		public static void SendAsAttachment(HttpContext Context, Dictionary<string, string> dictParameters, SplendidControl ctlParameterView, L10N L10n, TimeZone T10n, Guid gREPORT_ID, string sRDL, string sRENDER_FORMAT, string sMODULE_NAME, Guid gSOURCE_ID, string sNOTE_NAME, string sDESCRIPTION, ref Guid gNOTE_ID)
		{
			string sMimeType ;
			string sExtension;
			// 04/13/2011 Paul.  A scheduled report does not have a Session, so we need to create a session using the same approach used for ExchangeSync. 
			// 10/06/2012 Paul.  REPORT_ID is needed for sub-report caching. 
			// 03/24/2016 Paul.  We need an alternate way to provide parameters to render a report with a signature. 
			byte[] byContent = Render(Context, dictParameters, ctlParameterView, L10n, T10n, gREPORT_ID, sRDL, sRENDER_FORMAT, sMODULE_NAME, Guid.Empty, out sMimeType, out sExtension);
			
			// 02/05/2010 Paul.  Derive the file name from the URL. 
			// 05/11/2010 Paul.  Include he extension in the file name so that it will appear in emails.
			string sFILENAME       = sNOTE_NAME + "." + sExtension;
			string sFILE_EXT       = sExtension;
			string sFILE_MIME_TYPE = sMimeType;
			
			DbProviderFactory dbf = DbProviderFactories.GetFactory();
			using ( IDbConnection con = dbf.CreateConnection() )
			{
				con.Open();
				using ( IDbTransaction trn = Sql.BeginTransaction(con) )
				{
					try
					{
						gNOTE_ID = Guid.Empty;
						// 04/02/2012 Paul.  Add ASSIGNED_USER_ID. 
						SqlProcs.spNOTES_Update
							( ref gNOTE_ID
							, L10n.Term("Emails.LBL_EMAIL_ATTACHMENT") + ": " + sFILENAME
							, (!Sql.IsEmptyGuid(gSOURCE_ID) ? sMODULE_NAME : "Reports") // Parent Type
							, gSOURCE_ID   // Parent ID
							, Guid.Empty
							, String.Empty
							, Security.TEAM_ID
							, String.Empty
							, Security.USER_ID
							// 05/17/2017 Paul.  Add Tags module. 
							, String.Empty // TAG_SET_NAME
							// 11/07/2017 Paul.  Add IS_PRIVATE for use by a large customer. 
							, false        // IS_PRIVATE
							// 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
							, String.Empty // ASSIGNED_SET_LIST
							, trn
							);
						
						Guid gNOTE_ATTACHMENT_ID = Guid.Empty;
						SqlProcs.spNOTE_ATTACHMENTS_Insert(ref gNOTE_ATTACHMENT_ID, gNOTE_ID, sDESCRIPTION, sFILENAME, sFILE_EXT, sFILE_MIME_TYPE, trn);
						using ( MemoryStream stm = new MemoryStream(byContent) )
						{
							// 11/06/2010 Paul.  Move LoadFile() to Crm.NoteAttachments. 
							Crm.NoteAttachments.LoadFile(gNOTE_ATTACHMENT_ID, stm, trn);
						}
						trn.Commit();
					}
					catch
					{
						trn.Rollback();
						throw;
					}
				}
			}
		}

		// 01/19/2010 Paul.  The Module Name is needed in order to apply ACL Field Security. 
		// 10/06/2012 Paul.  REPORT_ID is needed for sub-report caching. 
		// 02/05/2021 Paul.  Make static so that we can use in the React client. 
		public static Guid RunReport(HttpContext Context, Dictionary<string, string> dictParameters, L10N L10n, TimeZone T10n, Guid gREPORT_ID, string sRDL, string sRENDER_FORMAT, string sMODULE_NAME, string sREPORT_NAME, DateTime dtREPORT_DATE_MODIFIED, Guid gSOURCE_ID, string sNOTE_NAME)
		{
			HttpApplicationState Application = Context.Application;
			// 02/05/2010 Paul.  Derive the file name from the URL. 
			string sDESCRIPTION = sNOTE_NAME;
			
			Guid gNOTE_ID   = Guid.Empty;
			// 06/19/2010 Paul.  Send BILLING_ACCOUNT_ID as the parent for the email. 
			string sACCOUNT_ID_URL = String.Empty;
			DbProviderFactory dbf = DbProviderFactories.GetFactory();
			using ( IDbConnection con = dbf.CreateConnection() )
			{
				con.Open();
				
				// 02/05/2021 Paul.  Include payments and contracts. 
				if ( sMODULE_NAME == "Quotes" || sMODULE_NAME == "Orders" || sMODULE_NAME == "Invoices" || sMODULE_NAME == "Payments" || sMODULE_NAME == "Contracts" )
				{
					// 06/27/2010 Paul.  Use new TableName function. 
					string sMODULE_TABLE_NAME = Crm.Modules.TableName(Application, sMODULE_NAME);

					string sSQL = String.Empty;
					sSQL = "select *                    "   + ControlChars.CrLf
					     + "  from vw" + sMODULE_TABLE_NAME + ControlChars.CrLf
					     + " where ID = @ID             "   + ControlChars.CrLf;
					using ( IDbCommand cmd = con.CreateCommand() )
					{
						cmd.CommandText = sSQL;
						Sql.AddParameter(cmd, "@ID", gSOURCE_ID);
						using ( IDataReader rdr = cmd.ExecuteReader(CommandBehavior.SingleRow) )
						{
							if ( rdr.Read() )
							{
								DateTime dtDATE_MODIFIED = Sql.ToDateTime(rdr["DATE_MODIFIED"]);
								string   sNAME           = Sql.ToString  (rdr["NAME"         ]);
								string   sNUMBER         = String.Empty;
								switch ( sMODULE_TABLE_NAME )
								{
									// 06/27/2010 Paul.  The # gets converted to a _ in a filename, so lets just remove it. 
									case "QUOTES"  :  sNUMBER = " " + Sql.ToString(rdr["QUOTE_NUM"  ]);  sACCOUNT_ID_URL = "&PARENT_ID=" + Sql.ToString(rdr["BILLING_ACCOUNT_ID"]);  break;
									case "ORDERS"  :  sNUMBER = " " + Sql.ToString(rdr["ORDER_NUM"  ]);  sACCOUNT_ID_URL = "&PARENT_ID=" + Sql.ToString(rdr["BILLING_ACCOUNT_ID"]);  break;
									case "INVOICES":  sNUMBER = " " + Sql.ToString(rdr["INVOICE_NUM"]);  sACCOUNT_ID_URL = "&PARENT_ID=" + Sql.ToString(rdr["BILLING_ACCOUNT_ID"]);  break;
								}
								sNOTE_NAME = sMODULE_NAME + sNUMBER + " - " + sNAME;
								// 02/05/2010 Paul.  Try and build a useful description, but include the record date and the report date for uniqueness.
								// We want to be able to detect if the report has changed so that we only render when necessary. 
								sDESCRIPTION =  sNAME + " " + dtDATE_MODIFIED.ToString() + ", " + sREPORT_NAME + " " + dtREPORT_DATE_MODIFIED.ToString() + ", " + gREPORT_ID.ToString();
								// 03/24/2016 Paul.  Need to cleanse name. 
								sNOTE_NAME = sNOTE_NAME.Replace('\\', '_').Replace(':' , '_');
							}
						}
					}
					// 02/05/2010 Paul.  To revent too many identical attachments, try and locate a matching version. 
					// We include the ID, Report and modified date. 
					sSQL = "select vwNOTES.ID                                             " + ControlChars.CrLf
					     + "  from      vwNOTES                                           " + ControlChars.CrLf
					     + " inner join vwNOTE_ATTACHMENTS                                " + ControlChars.CrLf
					     + "         on vwNOTE_ATTACHMENTS.ID = vwNOTES.NOTE_ATTACHMENT_ID" + ControlChars.CrLf
					     + " where vwNOTES.PARENT_ID              = @PARENT_ID            " + ControlChars.CrLf
					     + "   and vwNOTE_ATTACHMENTS.DESCRIPTION = @DESCRIPTION          " + ControlChars.CrLf
					     + "   and vwNOTES.ATTACHMENT_READY       = 1                     " + ControlChars.CrLf;
					using ( IDbCommand cmd = con.CreateCommand() )
					{
						cmd.CommandText = sSQL;
						Sql.AddParameter(cmd, "@PARENT_ID"  , gSOURCE_ID  );
						Sql.AddParameter(cmd, "@DESCRIPTION", sDESCRIPTION);
						gNOTE_ID = Sql.ToGuid(cmd.ExecuteScalar());
					}
				}
			}
			if ( Sql.IsEmptyGuid(gNOTE_ID) )
			{
				// 10/06/2012 Paul.  REPORT_ID is needed for sub-report caching. 
				SendAsAttachment(Context, dictParameters, null, L10n, T10n, gREPORT_ID, sRDL, sRENDER_FORMAT, sMODULE_NAME, gSOURCE_ID, sNOTE_NAME, sDESCRIPTION, ref gNOTE_ID);
			}
			// 10/25/2010 Paul.  vwQUEUE_EMAIL_ADDRESS already takes care of joining to Quotes, Orders or Invoices, so we can set the parent to gSOURCE_ID. 
			//Response.Redirect("~/Emails/edit.aspx?NOTE_ID=" + gNOTE_ID.ToString() + "&PARENT_ID=" + gSOURCE_ID.ToString() );
			return gNOTE_ID;
		}

		private void Page_Load(object sender, System.EventArgs e)
		{
			Response.ExpiresAbsolute = new DateTime(1980, 1, 1, 0, 0, 0, 0);
			try
			{
				if ( !IsPostBack )
				{
					gID = Sql.ToGuid(Request["ID"]);
					if ( !Sql.IsEmptyGuid(gID) )
					{
						// 04/06/2011 Paul.  Cache reports. 
						DataTable dtReport = SplendidCache.Report(gID);
						if ( dtReport.Rows.Count > 0 )
						{
							DataRow rdr = dtReport.Rows[0];
							string sRDL                     = Sql.ToString  (rdr["RDL"          ]);
							// 01/19/2010 Paul.  The Module Name is needed in order to apply ACL Field Security. 
							string   sMODULE_NAME           = Sql.ToString  (rdr["MODULE_NAME"  ]);
							// 02/05/2010 Paul.  We need the Report Name and Modified date to create a unique description. 
							string   sREPORT_NAME           = Sql.ToString  (rdr["NAME"         ]);
							DateTime dtREPORT_DATE_MODIFIED = Sql.ToDateTime(rdr["DATE_MODIFIED"]);
							
							if ( !Sql.IsEmptyString(sRDL) )
							{
								string sRENDER_FORMAT = Sql.ToString(Request["RENDER_FORMAT"]);  // Excel, PDF, Image
								switch ( sRENDER_FORMAT.ToUpper() )
								{
									// 05/13/2014 Paul.  Word format is supported by ReportViewer 2012. 
									// http://msdn.microsoft.com/en-us/library/ms251671(v=vs.110).aspx
									// 09/13/2016 Paul.  Possible render formats "Excel" "EXCELOPENXML" "IMAGE" "PDF" "WORD" "WORDOPENXML". 
									// http://stackoverflow.com/questions/3494009/creating-a-custom-export-to-excel-for-reportviewer-rdlc
									// 05/07/2018 Paul.  Include all possible values. 
									case "WORD"        :  sRENDER_FORMAT = "WORDOPENXML" ;  break;
									case "WORDOPENXML" :  sRENDER_FORMAT = "WORDOPENXML" ;  break;
									case "EXCEL"       :  sRENDER_FORMAT = "EXCELOPENXML";  break;
									case "EXCELOPENXML":  sRENDER_FORMAT = "EXCELOPENXML";  break;
									case "IMAGE"       :  sRENDER_FORMAT = "Image"       ;  break;
									case "PDF"         :  sRENDER_FORMAT = "PDF"         ;  break;
									default            :  sRENDER_FORMAT = "PDF"         ;  break;
								}
								Guid gSOURCE_ID = Guid.Empty;
								if ( sMODULE_NAME == "Quotes" || sMODULE_NAME == "Orders" || sMODULE_NAME == "Invoices" || sMODULE_NAME == "Contracts" )
								{
									string sMODULE_FIELD_ID   = String.Empty;
									// 06/27/2010 Paul.  Use new TableName function. 
									string sMODULE_TABLE_NAME = Crm.Modules.TableName(Application, sMODULE_NAME);
									if ( sMODULE_TABLE_NAME.EndsWith("IES") )
										sMODULE_FIELD_ID = sMODULE_TABLE_NAME.Substring(0, sMODULE_TABLE_NAME.Length - 3) + "Y_ID";
									else if ( sMODULE_TABLE_NAME.EndsWith("S") )
										sMODULE_FIELD_ID = sMODULE_TABLE_NAME.Substring(0, sMODULE_TABLE_NAME.Length - 1) + "_ID";
									else
										sMODULE_FIELD_ID = sMODULE_TABLE_NAME + "_ID";
									gSOURCE_ID = Sql.ToGuid(Request[sMODULE_FIELD_ID]);
								}

								string sNOTE_NAME   = Request.QueryString.ToString().Replace("&", ",");
								// 10/06/2012 Paul.  REPORT_ID is needed for sub-report caching. 
								// 02/05/2021 Paul.  Make static so that we can use in the React client. 
								Guid gNOTE_ID = RunReport(Context, null, L10n, T10n, gID, sRDL, sRENDER_FORMAT, sMODULE_NAME, sREPORT_NAME, dtREPORT_DATE_MODIFIED, gSOURCE_ID, sNOTE_NAME);
								Response.Redirect("~/Emails/edit.aspx?NOTE_ID=" + gNOTE_ID.ToString() + "&PARENT_ID=" + gSOURCE_ID.ToString() );
							}
						}
					}
				}
			}
			catch(Exception ex)
			{
				SplendidError.SystemError(new StackTrace(true).GetFrame(0), ex);
				string sError = Utils.ExpandException(ex);
				lblError.Text = sError;
			}
		}

		#region Web Form Designer generated code
		override protected void OnInit(EventArgs e)
		{
			//
			// CODEGEN: This call is required by the ASP.NET Web Form Designer.
			//
			InitializeComponent();
			base.OnInit(e);
		}
		
		/// <summary>
		///		Required method for Designer support - do not modify
		///		the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{
			this.Load += new System.EventHandler(this.Page_Load);
			m_sMODULE = "Reports";
			SetMenu(m_sMODULE);
		}
		#endregion
	}
}
