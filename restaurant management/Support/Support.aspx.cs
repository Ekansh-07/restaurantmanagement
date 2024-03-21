using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace restaurant_management.Support
{
    public partial class Support : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            //if (Request.HttpMethod == "POST")
            //{

            //    HttpPostedFile postedFile = Request.Files[0];
            //    string fileName = Path.GetFileName(postedFile.FileName);
            //    string filePath = Server.MapPath("~/Uploads/") + fileName;
            //    postedFile.SaveAs(filePath);

            //    string imageUrl = "/Uploads/" + fileName;

            //    var responseObj = new { imageUrl = imageUrl };

            //    string jsonResponse = new JavaScriptSerializer().Serialize(responseObj);

            //    Response.ContentType = "application/json";

            //    Response.Write(jsonResponse);

            //    Response.End();
            //}
        }
    }
    
}