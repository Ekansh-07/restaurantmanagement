﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace restaurant_management.Modal
{
    public class User
    {
        public int Id { get; set; }
        public string fname { get; set; }
        public string lname { get; set; }
        public string email { get; set; }
        public string phone { get; set; }
        public int roleId { get; set; }
    }

    public class UserDetail : User
    {

        public string role { get; set; }
    }

    public class Auth
    {
        public string email { get; set; }
        public string password { get; set; }
    }

    public class Role
    {
        public int id { get; set; }
        public string role_name { get; set; }
    }

    public class UserAddress
    {
        public int id { get; set; }
        public string address { get; set; }
        public int userId { get; set; }
    }

    public class Recipe
    {
        public int id { get; set; }
        public string name { get; set; }

        public int price { get; set; }

        public string description { get; set; }

        public int category_id { get; set; }

        public string image_url { get; set; }

        public int status_id { get; set; }
        public string status { get; set; }
        
        public int  qty { get; set; }
    }

    public class Order
    {
        public int id { get; set; }
        public int user_id { get; set; }
        public DateTime order_date { get; set; }
        public int order_status_id { get; set; }
        public string order_status { get; set; }
    }

    public class Order_Mapping
    {
        public int user_id { get; set; }
        public Dictionary<int, int> Items { get; set; }

    }

    public class Order_Items
    {
        public int id { get; set; }
        public int order_id { get; set; }
        public int item_id { get; set; }
        public int qty { get; set; }
    }

    public class Modal
    {
    }
}