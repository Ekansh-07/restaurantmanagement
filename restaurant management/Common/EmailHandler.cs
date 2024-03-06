using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Mail;
using System.Web;

namespace restaurant_management.Common
{
    public class EmailHandler
    {
        public void sendEmail(string mailBody, string email)
        {
            SmtpClient smtpClient = new SmtpClient();
            MailMessage message = new MailMessage();
            message.IsBodyHtml = true;
            message.Body = mailBody;
            message.To.Add(email);
            smtpClient.Send(message);
        }

    }
}