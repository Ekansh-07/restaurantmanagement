using Newtonsoft.Json;
using restaurant_management.Modal;
using restaurant_management.Support;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;

namespace restaurant_management
{
    /// <summary>
    /// Summary description for SupportService
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    // To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
    [System.Web.Script.Services.ScriptService]
    public class SupportService : System.Web.Services.WebService
    {
        SupportLogic sl = new SupportLogic();

        [WebMethod]

        public int GetChatID(int userId)
        {
            return sl.GetChatID(userId); 
        }

        [WebMethod]

        public string GetUsers()
        {
            return JsonConvert.SerializeObject(sl.GetUsers());
        }

        [WebMethod]
        public int SendMsg(string msg)
        {
            Message Msg = new Message(); 
            Msg = JsonConvert.DeserializeObject<Message>(msg);  
           return sl.SendMsg(Msg); 
        }

        [WebMethod]

        public string GetMsgs(int chat_id)
        {
            return JsonConvert.SerializeObject(sl.GetMsgs(chat_id));
        }

        [WebMethod]

        public bool SetChatStatus(int userId)
        {
            return sl.SetChatStatus(userId);
        }
    }
}
