using Antlr.Runtime.Tree;
using restaurant_management.Common;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Net.Mail;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace restaurant_management.Admin
{
    public partial class ForgetPassword : System.Web.UI.Page
    {
        static int generatedOTP;
        static string email = string.Empty;
        protected void Page_Load(object sender, EventArgs e)
        {
        }
        protected void Button1_Click(object sender, EventArgs e)
        {
            ForgetPassword.generatedOTP = generateOTP();
            email = emailTextBox.Text.Trim();
            if (email == "")
            {
                Response.Write("<script>alert('Please Enter Email')</script>");
            }
            else
            {
                if (!new common().EmailExist(email))
                {
                    string script = "alert('Account does not exist. Kindly Sign In');" +
                        "window.location.href='SignUp.aspx'";
                    ClientScript.RegisterStartupScript(this.GetType(), "Unsuccessful", script, true);
                }
                else
                {

                    SmtpClient smtpClient = new SmtpClient();
                    MailMessage message = new MailMessage();
                    message.IsBodyHtml = true;
                    string emailBody = @"
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
                <h1 style='color: #007bff; margin-bottom: 20px;'>Password Reset Request</h1>
                <p>Dear User,</p>
                <p>As per your request, the otp for password reset is :" + generatedOTP + @"</p>
                <p><b>Do not share this with anyone</b></p>
                <p>If you didn't request this password reset, please ignore this email.</p>
                <p style='color: #888; font-size: 12px;'>This email was sent to you as part of a password reset request. 
                If you have any concerns, please contact our support team.</p>
            </td>
        </tr>
    </table>
</body>
</html>
";
                    message.Body = emailBody;
                    message.To.Add(email);
                    try
                    {
                        //      smtpClient.Send(message);
                        string script = "alert('Kindly check your email')";
                        ClientScript.RegisterStartupScript(this.GetType(), "Success", script, true);
                        otpLabel.Visible = true;
                        otpBox.Visible = true;
                        Button2.Visible = true;
                    }
                    catch (Exception ex)
                    {
                        throw ex;
                    }

                }
            }
        }

        protected void Button2_Click(object sender, EventArgs e)
        {
            Response.Redirect("ResetPassword.aspx/?email=" + email);
            int userOTP = Int32.Parse(otpBox.Text.Trim());
            if (userOTP != ForgetPassword.generatedOTP)
            {
                string script = "alert('OTP Incorrect')";
                ClientScript.RegisterStartupScript(this.GetType(), "Unsuccessful", script, true);
                otpBox.Text = string.Empty;
            }
            else
            {
                Session["email"] = email;
                Response.Redirect("ResetPassword.aspx/?email=" + email);
            }
        }
        public int generateOTP()
        {
            Random rnd = new Random();

            return rnd.Next(100000, 1000000);
        }

    }
}

/* 
    iterate all and take max left distance
    Calculate height at left leaf 
    
 */