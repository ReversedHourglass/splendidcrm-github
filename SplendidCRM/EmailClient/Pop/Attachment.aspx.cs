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
using System.Xml;
using System.Text;
using System.Data;
using System.Drawing.Imaging;
using System.Diagnostics;

namespace SplendidCRM.EmailClient.Pop
{
	/// <summary>
	/// Summary description for Attachment.
	/// </summary>
	public class Attachment : SplendidPage
	{
		private void Page_Load(object sender, System.EventArgs e)
		{
			try
			{
				string sUNIQUE_ID     = Sql.ToString(Request["UNIQUE_ID"    ]);
				string sATTACHMENT_ID = Sql.ToString(Request["ATTACHMENT_ID"]);
				if ( !Sql.IsEmptyString(sUNIQUE_ID) && !Sql.IsEmptyString(sATTACHMENT_ID) )
				{
					string sSERVER_URL         = Sql.ToString (Session["Pop3.SERVER_URL"    ]);
					string sEMAIL_USER         = Sql.ToString (Session["Pop3.EMAIL_USER"    ]);
					string sEMAIL_PASSWORD     = Sql.ToString (Session["Pop3.EMAIL_PASSWORD"]);
					int    nPORT               = Sql.ToInteger(Session["Pop3.PORT"          ]);
					bool   bMAILBOX_SSL        = Sql.ToBoolean(Session["Pop3.MAILBOX_SSL"   ]);
					string sMAILBOX            = Sql.ToString (Session["Pop3.MAILBOX"       ]);
					string sDECRYPTED_PASSWORD = String.Empty;
					
					Guid gINBOUND_EMAIL_KEY = Sql.ToGuid(Application["CONFIG.InboundEmailKey"]);
					Guid gINBOUND_EMAIL_IV  = Sql.ToGuid(Application["CONFIG.InboundEmailIV" ]);
					if ( !Sql.IsEmptyString(sEMAIL_PASSWORD) )
						sDECRYPTED_PASSWORD = Security.DecryptPassword(sEMAIL_PASSWORD, gINBOUND_EMAIL_KEY, gINBOUND_EMAIL_IV);
					
					bool   bIsInline    = false;
					string sFileName    = String.Empty;
					string sContentType = String.Empty;
					int nATTACHMENT_ID = Sql.ToInteger(sATTACHMENT_ID);
					byte[] byDataBinary = PopUtils.GetAttachmentData(Context, sSERVER_URL, nPORT, bMAILBOX_SSL, sEMAIL_USER, sDECRYPTED_PASSWORD, sUNIQUE_ID, nATTACHMENT_ID, ref sFileName, ref sContentType, ref bIsInline);
					if ( byDataBinary != null )
					{
						Response.ContentType = sContentType;
						if ( !bIsInline )
							Response.AddHeader("Content-Disposition", "attachment;filename=" + Utils.ContentDispositionEncode(Request.Browser, sFileName));
						using ( BinaryWriter writer = new BinaryWriter(Response.OutputStream) )
						{
							writer.Write(byDataBinary);
						}
					}
					else
					{
						throw(new Exception("Attachment " + sATTACHMENT_ID + " not found in " + sUNIQUE_ID));
					}
				}
				else
				{
					//throw(new Exception("Message or attachment not specified."));
					// 02/28/2012 Paul.  We do not need to log the missing data error.  We don't want any error generated by the precompile process. 
					byte[] byImage = Images.Image.RenderAsImage(Response, 300, 100, "Message or attachment not specified.", ImageFormat.Gif);
					Response.ContentType = "image/gif";
					Response.BinaryWrite(byImage);
				}
			}
			catch(Exception ex)
			{
				SplendidError.SystemError(new StackTrace(true).GetFrame(0), ex);
				//Response.Write(ex.Message);
				if ( ex.GetType() != Type.GetType("System.Threading.ThreadAbortException") )
				{
					byte[] byImage = Images.Image.RenderAsImage(Response, 300, 100, ex.Message, ImageFormat.Gif);
					Response.ContentType = "image/gif";
					Response.BinaryWrite(byImage);
				}
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
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{    
			this.Load += new System.EventHandler(this.Page_Load);
		}
		#endregion
	}
}

