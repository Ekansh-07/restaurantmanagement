using restaurant_management.Modal;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace restaurant_management.Support
{
    public class SupportLogic
    {
        string strcon = ConfigurationManager.ConnectionStrings["con"].ConnectionString;

        public bool SendMsg(Message msg)
        {
            using ( SqlConnection con = new SqlConnection(strcon))
            {
                try
                {
                con.Open();
                using (SqlTransaction tran = con.BeginTransaction())
                {
                        string query = "INSERT INTO TBL_MESSAGE(USER_ID,MSG,TIME_STAMP) VALUES(@USER,@MSG,@TIME)"; 
                        SqlCommand sqlCommand = new SqlCommand(query, con,tran);
                        sqlCommand.Parameters.AddWithValue("USER", msg.User_id); 
                        sqlCommand.Parameters.AddWithValue("MSG", msg.Msg); 
                        sqlCommand.Parameters.AddWithValue("TIME", DateTime.Now); 
                        sqlCommand.ExecuteNonQuery();
                        tran.Commit();  
                        return true;    
                }
                }
                catch { return false;  }   
                finally { }
            }
        }

        public List<Modal.Message> GetMsgs()
        
        {
            List<Modal.Message> msgs = new List<Modal.Message>();   
            using (SqlConnection con = new SqlConnection(strcon))
            {
                try
                {
                    con.Open();
                    using (SqlTransaction tran = con.BeginTransaction())
                    {
                        
                        string query = "SELECT * FROM TBL_MESSAGE";
                        SqlCommand sqlCommand = new SqlCommand(query, con, tran);
                        using (SqlDataReader reader = sqlCommand.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                Message msg = new Message()
                                {
                                    Id = int.Parse(reader["ID"].ToString()),
                                    Msg = reader["MSG"].ToString(),
                                    User_id = int.Parse(reader["USER_ID"].ToString()),
                                    Time = DateTime.Parse(reader["TIME_STAMP"].ToString())
                                };
                                msgs.Add(msg);
                            }
                        }
                        tran.Commit();
                        return msgs ;
                    }
                }
                catch { return msgs; }
                finally { }
            }
        }
    }
}