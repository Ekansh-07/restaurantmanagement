using restaurant_management.Common;
using restaurant_management.Modal;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Dynamic;
using System.Linq;
using System.Web;

namespace restaurant_management.Support
{
    public class SupportLogic
    {
        string strcon = ConfigurationManager.ConnectionStrings["con"].ConnectionString;

        //public int SendMsg(Message msg)
        //{
        //    using (SqlConnection con = new SqlConnection(strcon))
        //    {
        //        try
        //        {
        //            con.Open();

        //            using (SqlTransaction tran = con.BeginTransaction())
        //            {
        //                string query = "INSERT INTO TBL_MSG(CHAT_ID,USER_ID,MSG,TIME_STAMP,IS_IMG) VALUES(@CHAT,@USER,@MSG,@TIME,@FLAG)";
        //                SqlCommand sqlCommand = new SqlCommand(query, con, tran);
        //                sqlCommand.Parameters.AddWithValue("CHAT", msg.Chat_Id);
        //                sqlCommand.Parameters.AddWithValue("USER", msg.User_id);
        //                sqlCommand.Parameters.AddWithValue("MSG", msg.Msg);
        //                sqlCommand.Parameters.AddWithValue("TIME", DateTime.Now);
        //                sqlCommand.Parameters.AddWithValue("FLAG", msg.Is_Img);
        //                sqlCommand.ExecuteNonQuery();
        //                tran.Commit();
        //                return msg.Chat_Id;
        //            }
        //        }
        //        catch { return msg.Chat_Id; }
        //        finally { }
        //    }
        //}

        public int SendMsg(Message msg)
        {
           
            string query = "INSERT INTO TBL_MSG(CHAT_ID, USER_ID, MSG, TIME_STAMP, IS_IMG) VALUES (@0, @1, @2, @3, @4)";

            
            string[] args = {
        msg.Chat_Id.ToString(),    
        msg.User_id.ToString(),    
        msg.Msg,                  
        DateTime.Now.ToString(), 
        msg.Is_Img ? "1" : "0"   
    };
            bool success = CallNonQuery(query, args);
            return success ? msg.Chat_Id : -1;
        }

        public List<Modal.Message> GetMsgs(int chat_id)
        {
            List<Modal.Message> msgs = new List<Modal.Message>();
            using (SqlConnection con = new SqlConnection(strcon))
            {
                try
                {
                    con.Open();
                    using (SqlTransaction tran = con.BeginTransaction())
                    {
                        string query = "SELECT * FROM TBL_MSG WHERE CHAT_ID = @CHAT_ID";
                        SqlCommand sqlCommand = new SqlCommand(query, con, tran);
                        sqlCommand.Parameters.AddWithValue("@CHAT_ID", chat_id);
                        using (SqlDataReader reader = sqlCommand.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                Message msg = new Message()
                                {
                                    Id = int.Parse(reader["ID"].ToString()),
                                    Msg = reader["MSG"].ToString(),
                                    User_id = int.Parse(reader["USER_ID"].ToString()),
                                    Time = DateTime.Parse(reader["TIME_STAMP"].ToString()),
                                    Is_Img = Boolean.Parse(reader["IS_IMG"].ToString())
                                };
                                msgs.Add(msg);
                            }
                        }
                        tran.Commit();
                        return msgs;
                    }
                }
                catch { return msgs; }
                finally { }
            }
        }

        public List<UserChat> GetUsers()
        {
            List<UserChat> userChats = new List<UserChat>();
            using (SqlConnection con = new SqlConnection(strcon))
            {
                try
                {
                    con.Open();
                    using (SqlTransaction tran = con.BeginTransaction())
                    {
                        string query = "SELECT * FROM USERSCHAT;";
                        SqlCommand sqlCommand = new SqlCommand(query, con, tran);
                        using (SqlDataReader reader = sqlCommand.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                UserChat msg = new UserChat()
                                {
                                    Fname = reader["FNAME"].ToString(),
                                    Lname = reader["LNAME"].ToString(),
                                    Chat_Id = int.Parse(reader["CHAT_ID"].ToString()),
                                    Active = Boolean.Parse(reader["ACTIVE"].ToString())
                                };
                                userChats.Add(msg);
                            }
                        }
                        tran.Commit();
                        return userChats;
                    }
                }
                catch { return userChats; }
                finally { }
            }
        }

        public int GetChatID(int userId)
        {
            using (SqlConnection con = new SqlConnection(strcon))
            {
                try
                {
                    con.Open();
                    using (SqlTransaction tran = con.BeginTransaction())
                    {
                        string query = "SELECT CHAT_ID FROM TBL_CHATMAPPING WHERE USER_ID = @id;";
                      
                        SqlCommand sqlCommand = new SqlCommand(query, con, tran);
                        sqlCommand.Parameters.AddWithValue("id", userId);
                        var res = sqlCommand.ExecuteScalar();
                        if (res == null)
                        {
                            query = "exec sp_setchatid @id = @user";
                            sqlCommand = new SqlCommand(query, con, tran);
                            sqlCommand.Parameters.AddWithValue("user", userId);
                            res = sqlCommand.ExecuteScalar();
                        }
                        tran.Commit();
                        int chat_id = int.Parse(res.ToString());
                        return chat_id;
                    }
                }
                catch { return -1; }
                finally { con.Close(); }
            }
        }

        public DataTable getDt()
        {
            using (SqlConnection con = new SqlConnection(strcon))
            {
                try
                {
                    con.Open();

                    string query = "SELECT * FROM USERSCHAT ";
                    SqlDataAdapter da = new SqlDataAdapter(query, con);
                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    if(dt.Rows.Count != 0) 
                    {
                       List<UserChat> uc = new List<UserChat>();
                       var list =  dt.AsEnumerable().Select(row =>
                            new
                            {
                                Fname = row.Field<string>("Fname"),
                                Lname = row.Field<string>("Lname"),
                                Active = row.Field<bool>("Active"),
                                Chat_id = row.Field<int>("Chat_Id")
                            }).ToList();
                        var val = list[0].Chat_id;     
                      }
                   
                    return dt;
                }
                catch (Exception ex) { throw ex; }
                finally { con.Close(); }
            }
        }
        //public bool SetChatStatus(int userId)
        //{
        //    using (SqlConnection con = new SqlConnection(strcon))
        //    {
        //        try
        //        {
        //            con.Open();
        //            using (SqlTransaction tran = con.BeginTransaction())
        //            {
        //                string query = "UPDATE TBL_CHATMAPPING SET ACTIVE = CASE WHEN ACTIVE = 0 THEN 1 ELSE 0 END WHERE USER_ID = @id;";
        //                SqlCommand sqlCommand = new SqlCommand(query, con, tran);
        //                sqlCommand.Parameters.AddWithValue("id", userId);
        //                sqlCommand.ExecuteNonQuery();
        //                tran.Commit();
        //                return true;
        //            }
        //        }
        //        catch { return false; }
        //        finally { con.Close(); }
        //    }
        //}

        public bool CallNonQuery(string query, string[] args)
        {
            using (SqlConnection con = new SqlConnection(strcon))
            {
                try
                {
                    con.Open();
                    using (SqlTransaction tran = con.BeginTransaction())
                    {
                        SqlCommand cmd = new SqlCommand(query, con, tran);
                        for (int i = 0; i < args.Length; i++)
                        {
                            cmd.Parameters.AddWithValue((i).ToString(), args[i]);
                        }
                        cmd.ExecuteNonQuery();
                        tran.Commit();
                        return true;
                    }
                }
                catch
                {
                    return false;
                }
                finally { con.Close(); }
            }
        }

        public static Result ClearChatData(int chat_id,SqlConnection con,SqlTransaction tran)
        {
            Result r  = new Result();
            try
            {
                string query = "DELETE FROM TBL_MSG WHERE CHAT_ID = @PARAM_CHAT_ID"; 
                using(SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = query;
                    cmd.Connection = con;
                    cmd.Transaction = tran;
                    cmd.Parameters.AddWithValue("PARAM_CHAT_ID", chat_id); 
                    cmd.ExecuteNonQuery();
                    r.data = null;
                    r.result = true;
                    r.msg = "Chat deleted successfully"; 
                    return r;
                }
            }
            catch (Exception ex) {
                r.data = null;
                r.result = false;
                r.msg = ex.ToString();
                return r;
            } 
        }
        public bool SetChatStatus(int userId)
        {
            string query = "UPDATE TBL_CHATMAPPING SET ACTIVE = CASE WHEN ACTIVE = 0 THEN 1 ELSE 0 END WHERE USER_ID = @0;";
            string[] args = { userId.ToString() };
            return CallNonQuery(query, args);
        }


    }
}











