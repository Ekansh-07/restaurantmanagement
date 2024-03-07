using Newtonsoft.Json;
using restaurant_management.Common;
using System;
using System.Collections.Generic;
using System.Dynamic;
using System.Linq;
using System.Web;
using System.Web.Services;

namespace restaurant_management
{
    /// <summary>
    /// Summary description for WS3
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    // To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
    [System.Web.Script.Services.ScriptService]
    public class WS3 : System.Web.Services.WebService
    {
        PaypalHandler handler = new PaypalHandler();
        [WebMethod]
        public string HelloWorld()
        {
            return "Hello World";
        }

        [WebMethod]
        public string InitiatePayment(string cost)
        {
            dynamic ob = new ExpandoObject();
            ob = JsonConvert.DeserializeObject<dynamic>(cost); 
                    
            return handler.InitiatePayment(ob); 
        }
    }
}
