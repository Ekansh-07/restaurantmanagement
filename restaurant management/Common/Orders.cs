using Microsoft.Ajax.Utilities;
using restaurant_management.Modal;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Hosting;
using System.Xml.Linq;

namespace restaurant_management.Common
{
    public class Orders
    {
        string strcon = ConfigurationManager.ConnectionStrings["con"].ConnectionString;

        public bool handleMapping(Order_Mapping mp)
        {
            using (SqlConnection con = new SqlConnection(strcon))
            {
                try
                {
                    con.Open();
                    using (SqlTransaction tran = con.BeginTransaction())
                    {
                        string query = "INSERT INTO TBL_ORDERMAPPING(USER_ID,DISH_ID,QUANTITY) VALUES(@USER,@ITEM,@QTY); ";
                        using (SqlCommand cmd = new SqlCommand(query, con, tran))
                        {
                            cmd.Parameters.Add("@USER", SqlDbType.Int);
                            cmd.Parameters.Add("@ITEM", SqlDbType.Int);
                            cmd.Parameters.Add("@QTY", SqlDbType.Int);

                            DeleteExistingCart(mp.user_id, con, tran);

                            foreach (var item in mp.Items)
                            {
                                if (item.Value > 0)
                                {
                                    cmd.Parameters["@USER"].Value = mp.user_id;
                                    cmd.Parameters["@ITEM"].Value = item.Key;
                                    cmd.Parameters["@QTY"].Value = item.Value;
                                    cmd.ExecuteNonQuery();
                                }
                            }

                            tran.Commit();
                        }
                    }
                    return true;
                }
                catch (Exception ex)
                {
                    return false;
                }
            }
        }

        public Order_Mapping GetUserCart(int userId)
        {
            Order_Mapping mp = new Order_Mapping();
            Dictionary<int, int> items = new Dictionary<int, int>();
            using (SqlConnection con = new SqlConnection(strcon))
            {
                con.Open();
                try
                {
                    using (SqlTransaction tran = con.BeginTransaction())
                    {
                        string query = "SELECT * FROM TBL_ORDERMAPPING WHERE USER_ID = @USER";
                        SqlCommand cmd = new SqlCommand(query, con, tran);
                        cmd.Parameters.AddWithValue("USER", userId);
                        SqlDataReader dr = cmd.ExecuteReader();
                        while (dr.Read())
                        {
                            int itemId = Int32.Parse(dr["DISH_ID"].ToString());
                            int qty = Int32.Parse(dr["QUANTITY"].ToString());
                            items.Add(itemId, qty);
                        }
                        mp.Items = items;
                        tran.Commit();
                    }
                    return mp;
                }
                catch (Exception ex)
                {
                    return mp;
                    throw ex;
                }
                finally
                {
                    con.Close();
                }
            }
        }

        public bool UpdateExistingCart(Order_Mapping mp)
        {
            using (SqlConnection con = new SqlConnection(strcon))
            {
                try
                {
                    con.Open();
                    using (SqlTransaction tran = con.BeginTransaction())
                    {
                        string query = "UPDATE TBL_ORDERMAPPING SET QUANTITY = @QTY WHERE USER_ID = @USER AND DISH_ID = @ITEM; ";
                        using (SqlCommand cmd = new SqlCommand(query, con, tran))
                        {
                            cmd.Parameters.Add("@USER", SqlDbType.Int);
                            cmd.Parameters.Add("@ITEM", SqlDbType.Int);
                            cmd.Parameters.Add("@QTY", SqlDbType.Int);

                            foreach (var item in mp.Items)
                            {
                                    cmd.Parameters["@USER"].Value = mp.user_id;
                                    cmd.Parameters["@ITEM"].Value = item.Key;
                                    cmd.Parameters["@QTY"].Value = item.Value;
                                    cmd.ExecuteNonQuery();
                            }
                            DeleteExistingCart(mp.user_id, con, tran, true);
                            tran.Commit();
                        }
                    }
                    return true;
                }
                catch (Exception ex)
                {
                    return false;
                }
            }
        }

        public bool DeleteExistingCart(int userId, SqlConnection con, SqlTransaction tran, bool hasEmpty = false)
        {

            try
            {

                string query ="DELETE FROM TBL_ORDERMAPPING WHERE USER_ID = @USER";
                if (hasEmpty) { query += " AND QUANTITY = 0;";  }
                SqlCommand cmd = new SqlCommand(query, con, tran);
                cmd.Parameters.AddWithValue("USER", userId);
                cmd.ExecuteNonQuery();
                return true;
            }
            catch (Exception ex)
            {
                return false;
                throw ex;
            }

        }

        public List<Recipe> GetUserCartDetails(int userId)
        {
            List<Recipe> list = new List<Recipe>();
            using (SqlConnection con = new SqlConnection(strcon))
            {
                con.Open();
                try
                {
                    using (SqlTransaction tran = con.BeginTransaction())
                    {
                        string query = "EXEC GETUSERORDER @USER_ID = @USER";
                        SqlCommand cmd = new SqlCommand(query, con, tran);
                        cmd.Parameters.AddWithValue("USER", userId);
                        using (SqlDataReader dr = cmd.ExecuteReader())
                        {
                            while (dr.Read())
                            {
                                Recipe recipe = new Recipe()
                                {
                                    id = Int32.Parse(dr["ID"].ToString()),
                                    name = dr["Name"].ToString(),
                                    image_url = dr["IMG_URL"].ToString(),
                                    price = double.Parse(dr["PRICE"].ToString()),
                                    qty = Int32.Parse(dr["QUANTITY"].ToString()),
                                };
                                list.Add(recipe);
                            }
                        }
                    }
                    return list;
                }
                catch (Exception ex)
                {
                    return list;
                    throw ex;
                }
                finally
                {
                    con.Close();
                }
            }
        }

        public bool PlaceOrder(int userId,double cost,int adr)
        {
            using (SqlConnection con = new SqlConnection(strcon))
            {
                con.Open();
                try
                {
                    using (SqlTransaction tran = con.BeginTransaction())
                    {
                        
                        string query = "EXEC PLACEORDER @USER = @USERID, @PRICE = @COST, @ADR = @ADR";
                        SqlCommand cmd = new SqlCommand(query, con, tran);
                        cmd.Parameters.AddWithValue("USERID", userId);                       
                        cmd.Parameters.AddWithValue("COST", cost);                       
                        cmd.Parameters.AddWithValue("ADR", adr);                       
                        cmd.ExecuteNonQuery();
                        DeleteExistingCart(userId, con, tran);
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

        public List<Order> GetUserOrders(int userId)
        {
            List<Order> orders = new List<Order>(); 
            orders = GetOrderList().Where(o => o.user_id == userId).ToList();
            return orders;
        }

        public List<Order> GetOrderList()
        {
            List<Order> list = new List<Order>();   
            using (SqlConnection con = new SqlConnection(strcon))
            {
                con.Open();
                try
                {
                    using (SqlTransaction tran = con.BeginTransaction())
                    {

                        string query = "SELECT * FROM ORDERVIEW";
                        SqlCommand cmd = new SqlCommand(query, con, tran);
                        using (SqlDataReader dr = cmd.ExecuteReader())
                        {
                            while (dr.Read())
                            {
                                list.Add(new Order
                                {
                                    id = Int32.Parse(dr["ID"].ToString()),
                                    user_id = Int32.Parse(dr["USER_ID"].ToString()),
                                    name = dr["USER_NAME"].ToString(),
                                    order_status_id = Int32.Parse(dr["ORDER_STATUS_ID"].ToString()),
                                    order_date = DateTime.Parse(dr["ORDER_DATE"].ToString()),
                                    order_status = dr["STATUS"].ToString(),
                                    address = dr["ADDRESS"].ToString(),
                                    order_cost = double.Parse(dr["ORDER_COST"].ToString())
                                });
                            }
                        }
                        tran.Commit();
                    }
                    return list;
                }
                catch (Exception ex)
                {
                    return list;
                    throw ex;
                }
                finally
                {
                    con.Close();
                }
            }
        }
        public List<Order_Items> GetOrderItemList(int userId)
        {
            List<Order_Items> list = new List<Order_Items>();
            using (SqlConnection con = new SqlConnection(strcon))
            {
                con.Open();
                try
                {
                    using (SqlTransaction tran = con.BeginTransaction())
                    {

                        string query = @"SELECT o.id,m.name,order_id,item_id,quantity, quantity * m.PRICE as cost, o.status_id,status  
                                        FROM TBL_order_items O
                                        INNER JOIN TBL_MENU m 
                                        ON M.ID = O.ITEM_ID
                                        LEFT JOIN TBL_ORDER_STATUS s
                                        ON  O.STATUS_ID = s.id
                                        and o.order_id in (SELECT id from tbl_orders where user_id = @userid)  ";
                        SqlCommand cmd = new SqlCommand(query, con, tran);
                        cmd.Parameters.AddWithValue("userid", userId);
                        using (SqlDataReader dr = cmd.ExecuteReader())
                        {
                            while (dr.Read())
                            {
                                list.Add(new Order_Items
                                {
                                    id = Int32.Parse(dr["ID"].ToString()),
                                    name = dr["Name"].ToString(),
                                    order_id = Int32.Parse(dr["ORDER_ID"].ToString()),
                                    item_id = Int32.Parse(dr["ITEM_ID"].ToString()),
                                    qty = Int32.Parse(dr["QUANTITY"].ToString()),                                
                                    cost = double.Parse(dr["COST"].ToString()),
                                    status_id = dr["status_id"] == DBNull.Value ? 0 : Int32.Parse(dr["status_id"].ToString()),
                                    status = dr["status"].ToString()
                                });
                            }
                        }
                        tran.Commit();
                    }
                    return list;
                }
                catch (Exception ex)
                {
                    return list;
                    throw ex;
                }
                finally
                {
                    con.Close();
                }
            }
        }
        public bool UpdateOrderStatus(List<int> orders,int status)
        {
            using(SqlConnection con = new SqlConnection(strcon))
            {
                try
                {
                    con.Open();
                    using(SqlTransaction tran = con.BeginTransaction())
                    {
                        string query = "UPDATE TBL_ORDERS SET ORDER_STATUS_ID = @STATUS WHERE ID = @ID"; 
                        using(SqlCommand cmd = new SqlCommand(query,con,tran))
                        {
                            cmd.Parameters.Add("@STATUS", SqlDbType.Int); 
                            cmd.Parameters.Add("@ID", SqlDbType.Int); 
                            foreach (var item in orders)
                            {
                                cmd.Parameters["@STATUS"].Value = status;
                                cmd.Parameters["@ID"].Value = item;
                                cmd.ExecuteNonQuery();
                            }
                        }
                        tran.Commit() ;
                        return true;
                    }
                }
                catch (Exception ex)
                {
                    return false; 
                }
                finally
                {
                    con.Close() ;
                }
            }
        }
    }
}