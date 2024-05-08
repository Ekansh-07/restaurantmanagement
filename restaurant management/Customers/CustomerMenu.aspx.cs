using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace restaurant_management.Customers
{
    public partial class CustomerMenu : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if(SiteMaster.ud != null)
            {
                var roleId = SiteMaster.ud.roleId; 
                if(roleId != 20)
                {
                    Response.Redirect(@"~/Admin/Menu.aspx",false); 
                }
            }
        }
    }
}