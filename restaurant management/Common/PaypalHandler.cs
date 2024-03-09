using Newtonsoft.Json;
using PayPal.Api;
using restaurant_management.Modal;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace restaurant_management.Common
{
    public class PaypalHandler
    {
        public static string paymentId;
        string strcon = ConfigurationManager.ConnectionStrings["con"].ConnectionString;

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

        public bool UpdateUserWallet(int userId,int amt)
        {
            using (SqlConnection con = new SqlConnection(strcon))
            {
                con.Open();
                try
                {
                    using (SqlTransaction tran = con.BeginTransaction())
                    {

                        string query = "UPDATE TBL_USERS SET WALLET = CASE WHEN WALLET IS NULL THEN @AMT ELSE WALLET + @AMT END WHERE ID = @USERID";
                        SqlCommand cmd = new SqlCommand(query, con, tran);
                        cmd.Parameters.AddWithValue("USERID", userId);
                        cmd.Parameters.AddWithValue("AMT", amt);
                        cmd.ExecuteNonQuery();
                        tran.Commit();
                    }
                    return true;
                }
                catch (Exception ex)
                {
                    return false;
                    throw ex;
                }
                finally
                {
                    con.Close();
                }
            }
        }
        public bool UpdateRefundStatus(Order_Items item, int status)
        {
            using (SqlConnection con = new SqlConnection(strcon))
            {
                con.Open();
                try
                {
                    using (SqlTransaction tran = con.BeginTransaction())
                    {

                        string query = "UPDATE TBL_ORDER_ITEMS SET STATUS_ID = @STATUS WHERE ID = @ID";
                        SqlCommand cmd = new SqlCommand(query, con, tran);
                        cmd.Parameters.AddWithValue("ID", item.id);
                        cmd.Parameters.AddWithValue("STATUS", status);
                        cmd.ExecuteNonQuery();
                        tran.Commit();
                    }
                    return true;
                }
                catch (Exception ex)
                {
                    return false;
                    throw ex;
                }
                finally
                {
                    con.Close();
                }
            }
        }

        public void InitiateRefund(dynamic ob)
        {
            Order_Items item = JsonConvert.DeserializeObject<Order_Items>(ob.item.ToString());
            UpdateRefundStatus(item, 500);
            User user = new common().GetUserData(ob.email.ToString());
            string host = $"https://localhost:44389/temporary?toAdmin=true&userId={user.Id}&itemId={item.id}&cost={item.cost}&isValidRefund=";

            string mailbody = $@"
<!DOCTYPE html>
<html lang='en'>
<head>
    <meta charset='UTF-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1.0'>
    <title>Password Reset Request</title>
</head>
<body style='font-family: Arial, sans-serif; background-color: #f4f4f4; padding: 20px;'>
    <table border='0' cellpadding='0' cellspacing='0' width='100%' style='max-width: 600px; margin: 0 auto; background-color: #ffffff; box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.3);'>
        <tr>
            <td align='center' valign='top' style='padding: 20px 0;'>
              New User SignUp
			
          </td>
        </tr>
      <tr> 
        <td align='center' valign='top' style='padding: 20px 0;'>
          <p>Dear Admin, User {user.fname} {user.lname} has requested a refund on their Order Item : {item.id}.</p>
          <p>Reason mentioned : {ob.reason.ToString()}</p>
        </td>
      </tr>
      <tr> 
        <td align='center' valign='top' style='padding: 20px 0;'>
          <a href='{host}true' style='background - color:#ffffff; border:1px solid #333333; border-color:#333333; border-radius:6px; border-width:1px; color:#00843c !important; display:inline-block; font-size:18px; font-weight:normal; letter-spacing:0px; line-height:normal; padding:12px 18px 12px 18px; text-align:center; text-decoration:none; border-style:solid; font-family:courier, monospace;
   	text-decoration:none; 
   margin:20px;'>Approve</a>
          <a href='{host}false' style='background - color:#ffffff; border:1px solid #333333; border-color:#333333; border-radius:6px; border-width:1px; color:#00843c !important; display:inline-block; font-size:18px; font-weight:normal; letter-spacing:0px; line-height:normal; padding:12px 18px 12px 18px; text-align:center; text-decoration:none; border-style:solid; font-family:courier, monospace;
   	text-decoration:none; 
   margin:20px;'>Reject</a>
         
        </td>
      </tr>
    </table>
</body>
</html>
  ";
            new EmailHandler().sendEmail(mailbody, "anshul.saxena@xorosoft.com");
        }

    }
}