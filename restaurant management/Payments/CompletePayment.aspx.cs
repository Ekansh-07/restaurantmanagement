using PayPal.Api;
using restaurant_management.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace restaurant_management.Payments
{
    public partial class CompletePayment : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            var config = ConfigManager.Instance.GetProperties();
            var accessToken = new OAuthTokenCredential(config).GetAccessToken();
            var apiContext = new APIContext(accessToken);
            var paymentId = PaypalHandler.paymentId;
            if (!string.IsNullOrEmpty(paymentId))
            {
                var payment = new Payment()
                {
                    id = paymentId
                };
                var adrId =int.Parse(Request.QueryString["adrs"].ToString());
                var cost = Double.Parse(Request.QueryString["cost"].ToString());
                var payerId = Request.QueryString["payerID"].ToString();
               
                var payExecute = new PaymentExecution() { payer_id = payerId };
                var result = payment.Execute(apiContext, payExecute);
                var res = new Orders().PlaceOrder(SiteMaster.ud.Id,cost,adrId); 
                if(res)
                    Response.Redirect("/Customers/OrderDetails.aspx");
            }
        }
    
    }
}