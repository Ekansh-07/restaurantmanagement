using restaurant_management.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Optimization;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace restaurant_management
{
    public partial class temporary : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            var query = Request.QueryString;
            var email = query["email"];
            bool toAdmin = Boolean.Parse(query["toAdmin"]);
            if (toAdmin)
            {
                if (email != null)
                {
                    int role = int.Parse(query["role"]);
                    Modal.User user = new Modal.User()
                    {
                        email = email,
                        roleId = role,
                    };
                    new common().AssignRole(user);
                }
                if (query["dishId"] != null)
                {
                    int dishId = Int32.Parse(query["dishId"]);
                    Recipes r = new Recipes();
                    if (Boolean.Parse(query["isApprove"]))
                    {
                        r.ApproveWithId(dishId);
                    }
                    else
                    {
                        r.DeleteDishStatus(dishId);
                    }
                }

                if (query["userId"]!=null && query["itemId"]!=null)
                {
                    PaypalHandler ob = new PaypalHandler();
                    int userId = Int32.Parse(query["userId"]);
                    int itemId = Int32.Parse(query["itemId"]);
                    int cost = Int32.Parse(query["cost"]);
                    if (Boolean.Parse(query["isValidRefund"]))
                    {
                        ob.UpdateUserWallet(userId, cost);
                        ob.UpdateRefundStatus(new Modal.Order_Items() { id = itemId }, 600);
                    }
                    else
                    {
                        ob.UpdateRefundStatus(new Modal.Order_Items() { id = itemId }, 700);
                    }
                }

            }
                ClientScript.RegisterStartupScript(this.GetType(), "Success", "window.close()", true);
        }
    }
}
