using Microsoft.Ajax.Utilities;
using restaurant_management.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace restaurant_management.Customers
{
    public partial class Profile : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (IsPostBack)
            {
                if (Session["email"] == null)
                {
                    Response.Redirect("/Admin/Login");
                }
            }
            else
            {
                Console.WriteLine("yo");
            }
        }
    }
}