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
        public bool SendMsg(string msg)
        {
            Message Msg = new Message(); 
            Msg = JsonConvert.DeserializeObject<Message>(msg);  
           return sl.SendMsg(Msg); 
        }

        [WebMethod]

        public string GetMsgs()
        {
            return JsonConvert.SerializeObject(sl.GetMsgs());
        }
    }
}
