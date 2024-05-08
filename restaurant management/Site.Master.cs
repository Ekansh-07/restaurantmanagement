using Microsoft.Ajax.Utilities;
using restaurant_management.Modal;
using restaurant_management.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace restaurant_management
{
    public partial class SiteMaster : MasterPage
    {
        public static UserDetail ud;
        public static string email;
        public static bool isLogout = false; 
        public dynamic sessionData;
        protected void Page_Load(object sender, EventArgs e)
        {


            if (email != null )
            {
                sessionData = common.getSessionData("sesssionData");
                int roleId = sessionData.roleId;
                string email = sessionData.email;
                Session["roleId"] = roleId;
                Session["email"] = email;
                ud = new common().GetUserData(email);
                Console.WriteLine(ud);
            }
            if(ud== null)
            {
                string url = Request.Url.AbsolutePath;
                string urlEncode = Server.UrlEncode(url);   
                Response.Redirect(@"~/Admin/Login.aspx?rurl="+urlEncode,false);
            }
        }
    }
}