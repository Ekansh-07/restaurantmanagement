using Newtonsoft.Json;
using restaurant_management.Common;
using restaurant_management.Modal;
using System;
using System.Collections.Generic;
using System.Dynamic;
using System.Linq;
using System.Web.Services;

namespace restaurant_management
{

    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    // To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
     [System.Web.Script.Services.ScriptService]
    public class WS2 : System.Web.Services.WebService
    {
        
        Orders orderOb = new Orders();
        PaypalHandler paymentHandler = new PaypalHandler();
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
        public bool PlaceOrder(string curOrder)
        {
            Order order = new Order();
            order = JsonConvert.DeserializeObject<Order>(curOrder);
            double walletMoneyUsed = -order.order_cost;
            paymentHandler.UpdateUserWallet(order.user_id, walletMoneyUsed);
            return orderOb.PlaceOrder(order.user_id,order.order_cost,order.address_id);
        }

        [WebMethod]

        public string GetAllOrders() {
            return JsonConvert.SerializeObject(orderOb.GetOrderList());
        }

        [WebMethod]

        public string GetOrderList(int curUser)
        {
            return JsonConvert.SerializeObject(orderOb.GetUserOrders(curUser));
        }

        [WebMethod]
        public string GetOrderItemList(int userId)
        {
            return JsonConvert.SerializeObject(orderOb.GetOrderItemList(userId));
        }

        [WebMethod]
        public bool AcceptOrders(string orders)
        {
            List<int> ordersList = new List<int>();
           ordersList = JsonConvert.DeserializeObject<List<int>>(orders);
            return orderOb.UpdateOrderStatus(ordersList,200);
        }

        [WebMethod]

        public void InitiateRefund(string ob)
        {
            dynamic d = new ExpandoObject();
            d =  JsonConvert.DeserializeObject(ob);
            paymentHandler.InitiateRefund(d);
           
        }
    }
}
