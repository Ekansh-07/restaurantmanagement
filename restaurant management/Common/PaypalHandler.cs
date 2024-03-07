using PayPal.Api;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace restaurant_management.Common
{
    public class PaypalHandler
    {
        public static string paymentId; 
        public string InitiatePayment(dynamic paymentDetails)
        {
            var config = ConfigManager.Instance.GetProperties();
            var accessToken = new OAuthTokenCredential(config).GetAccessToken();
            var apiContext = new APIContext(accessToken);
            var ru = new RedirectUrls()
            {
                cancel_url = "https://localhost:44389/",
                return_url = $"https://localhost:44389/Payments/CompletePayment.aspx?cost={paymentDetails.bill.Total}&adrs={paymentDetails.adrsId}"
            };           
            var payer = new Payer() { payment_method = "paypal" };
            var tdetails = new Details()
            {
                tax = paymentDetails.bill.gst,
                shipping = paymentDetails.bill.delivery,
                subtotal = paymentDetails.bill.cost
            };
            var transaction = new Transaction() { };
            Amount amount = new Amount()
            {
                currency = "USD",
                total = (paymentDetails.bill.Total/80).ToString("0.00")
            };
            transaction.amount = amount;
            var payment = new Payment()
            {
              
                intent = "sale",
                payer = payer,
                transactions = new List<Transaction> { transaction },
                redirect_urls = ru
            };
            var cp = payment.Create(apiContext);
            paymentId = cp.id;
            var approvalUrl = cp.links.FirstOrDefault(link => link.rel.Equals("approval_url", StringComparison.OrdinalIgnoreCase));

            if (approvalUrl != null)
            {
                return approvalUrl.href;
            }
            return ""; 
        }
    }
}