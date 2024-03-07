using Newtonsoft.Json;
using restaurant_management.Common;
using restaurant_management.Modal;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;

namespace restaurant_management
{
    /// <summary>
    /// Summary description for WS2
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    // To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
     [System.Web.Script.Services.ScriptService]
    public class WS2 : System.Web.Services.WebService
    {

        Orders orderOb = new Orders();
        [WebMethod]
        public bool MapOrders(string cart)
        {
            Order_Mapping mp = new Order_Mapping();
            mp = JsonConvert.DeserializeObject<Order_Mapping>(cart);
            return orderOb.handleMapping(mp);
        
        }
        [WebMethod]
        public string GetUserCart(int curUser)
        {            
            return JsonConvert.SerializeObject( orderOb.GetUserCart(curUser));
        }

        [WebMethod]
        public string GetUserCartDetails(int curUser)
        {
            return JsonConvert.SerializeObject(orderOb.GetUserCartDetails(curUser));
        }

        [WebMethod]
        public bool UpdateOrders(string curOrder)
        {
            Order_Mapping mp = new Order_Mapping();
            mp = JsonConvert.DeserializeObject<Order_Mapping>(curOrder);
            return orderOb.UpdateExistingCart(mp);

        }

        [WebMethod]

        public bool PlaceOrder(int userId)
        {
            return orderOb.PlaceOrder(userId);
        }
    }
}
