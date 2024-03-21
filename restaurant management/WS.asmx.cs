using Newtonsoft.Json;
using restaurant_management.Modal; 
using restaurant_management.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Dynamic;

namespace restaurant_management
{
    /// <summary>
    /// Summary description for WS
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    // To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
     [System.Web.Script.Services.ScriptService]
    public class WS : System.Web.Services.WebService
    {
        
        common com = new common();
        Recipes recOb = new Recipes();
        [WebMethod]
        public string SetUser(string UserDetails,string UserAuth)
        {
            User user = JsonConvert.DeserializeObject<User>(UserDetails);   
            Auth auth = JsonConvert.DeserializeObject<Auth>(UserAuth);
          return  com.RegisterUser(user, auth);
        }

        [WebMethod]

        public bool SetUserPwd(string userData)
        {
            dynamic ob = new ExpandoObject();
            ob.email = string.Empty;
            ob.newPwd = string.Empty; 
            ob.oldPwd = string.Empty; 
            ob = JsonConvert.DeserializeObject<dynamic>(userData);

            return com.updateUserPwd(ob);
        }

        [WebMethod]
        public string LoginUser(string UserAuth)
        {
            Auth auth = JsonConvert.DeserializeObject<Auth>(UserAuth);
            return Newtonsoft.Json.JsonConvert.SerializeObject(com.UserLogin(auth));

        }

        [WebMethod]

        public string LogOut()
        {
           return com.LogOut();

        }

        [WebMethod]
        public void UpdateUserDetails(string UserDetails)
        {
            User user = JsonConvert.DeserializeObject<User>(UserDetails);
            com.UpdateUserDetails(user);
        }

        [WebMethod]

        public string UserData(int id)
        {
            return JsonConvert.SerializeObject(com.GetUsersData().Where(u => u.Id == id).FirstOrDefault());
        }

        [WebMethod]

        public string UsersData()
        {
            return JsonConvert.SerializeObject( com.GetUsersData()); 
        }
        [WebMethod]
        public string GetRoles()
        {
            return JsonConvert.SerializeObject(com.GetRoles());
        }

        [WebMethod]
        public bool AssignRole(string userDetail)
        {
            User user = JsonConvert.DeserializeObject<User>(userDetail);
            return com.AssignRole(user);
        }
        [WebMethod]

        public string GetAddresses(int userId)
        {
            return JsonConvert.SerializeObject( com.GetAddresses(userId)); 
        }

        [WebMethod]
        public void AddAddress(int userId, string address)
        {
             com.AddAddress(userId, address);
        }

        [WebMethod]
        public bool DeleteAddress(int addressId)
        {
            return com.DeleteAddress(addressId);
        }

        [WebMethod]
        public bool AddRecipe(string dish)
        {
            Recipe recipe = new Recipe();
            recipe = JsonConvert.DeserializeObject<Recipe>(dish);
            return recOb.AddRecipe(recipe); 
        }

        [WebMethod]
        public string GetCustomerDishes()
        {
            List<Recipe> recipes = new List<Recipe>();
            recipes = recOb.GetDishes().Where(dish => dish.status_id == 30).ToList();
            return JsonConvert.SerializeObject(recipes);
        }

        [WebMethod]
        public string GetDishes()
        {
            return JsonConvert.SerializeObject(recOb.GetDishes());
        }


        [WebMethod]
        public bool UpdateDishStatus(string dish)
        {
            Recipe recipe = new Recipe(); 
            recipe = JsonConvert.DeserializeObject<Recipe>(dish);
            return recOb.UpdateDishStatus(recipe);
        }


        [WebMethod]
        
        public bool DeleteDishStatus(string dish)
        {
            Recipe recipe = new Recipe();
            recipe = JsonConvert.DeserializeObject<Recipe>(dish);
            return recOb.DeleteDishStatus(recipe.id);
        }


        [WebMethod]

        public string getSearchData(string query)
        {
            return recOb.getSearchItems(query); 
        }

        [WebMethod]

        public string GetRecipeInfo(int id)
        {
            return recOb.GetRecipeInfo(id);
        }

    }
}
