﻿using PayPal.Api;
using System;
using System.Collections.Generic;
using System.Dynamic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace restaurant_management
{
    public partial class _Default : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void ButtonClick(object sender, EventArgs e)
        {
            var item = new Item() { };
            var config  = ConfigManager.Instance.GetProperties();
            var accessToken = new OAuthTokenCredential(config).GetAccessToken();
            var apiContext = new APIContext(accessToken);
            var ru = new RedirectUrls()
            {
                cancel_url = "https://localhost:44389/",
                return_url = "https://localhost:44389/Payments/CompletePayment.aspx"
            };
            int val = 1; 
            var payer = new Payer() { payment_method = "paypal"};
            var transaction = new Transaction();
            Amount amount = new Amount()
            {
                currency = "USD",
                total = val.ToString("0.00")
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
            Session["paymentId"] = cp.id;
            var approvalUrl = cp.links.FirstOrDefault(link => link.rel.Equals("approval_url", StringComparison.OrdinalIgnoreCase));
            
            if (approvalUrl != null)
            {
                Response.Redirect(approvalUrl.href);
            }
        }
    }
}