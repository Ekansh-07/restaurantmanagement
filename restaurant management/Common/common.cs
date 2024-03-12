using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Dynamic;
using System.Linq;
using System.Net;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using restaurant_management.Modal;
using System.Drawing;
using System.Net.Mail;

namespace restaurant_management.Common
{


    public class common
    {
        public string salt = "randomSeQuence";
        string strcon = ConfigurationManager.ConnectionStrings["con"].ConnectionString;
        public static Dictionary<string, dynamic> sessionData = new Dictionary<string, dynamic>();
        public EmailHandler eHandler = new EmailHandler();
        public static void setSessionData(string key, dynamic obj)
        {

            sessionData[key] = obj;
        }

        public static dynamic getSessionData(string key)
        {
            if (sessionData.ContainsKey(key))
            {
                return sessionData[key];
            }
            return null;
        }
        public int RoleExist(string email)
        {
            using (SqlConnection con = new SqlConnection(strcon))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand("SELECT * FROM TBL_USERS WHERE EMAIL=@EMAIL", con);
                cmd.Parameters.AddWithValue("EMAIL", email);
                using (SqlDataReader rdr = cmd.ExecuteReader())
                {
                    if (rdr.Read())
                    {
                        if (!rdr.IsDBNull(1)) return Int32.Parse(rdr["role_id"].ToString());

                    }
                    return -1;

                }
            }


        }
        public bool EmailExist(string email)
        {
            using (SqlConnection con = new SqlConnection(strcon))
            {
                con.Open();
                using (SqlTransaction trans = con.BeginTransaction())
                {

                    SqlCommand cmd = new SqlCommand("SELECT * FROM TBL_AUTH WHERE EMAIL=@EMAIL", con, trans);
                    cmd.Parameters.AddWithValue("EMAIL", email);
                    using (SqlDataReader rdr = cmd.ExecuteReader())
                    {
                        if (rdr.HasRows) return true;
                        else return false;
                    }
                }
            }
        }
        public string GenerateHash(string input)
        {
            byte[] bytes = Encoding.UTF8.GetBytes(input + salt);
            SHA256Managed sHA256ManagedString = new SHA256Managed();
            byte[] hash = sHA256ManagedString.ComputeHash(bytes);
            return Convert.ToBase64String(hash);
        }

        public void SetEmailPwd(Auth auth, int userId, SqlConnection con, SqlTransaction trans)
        {
            string hashedPwd = GenerateHash(auth.password);
            string query = "INSERT INTO TBL_AUTH(EMAIL,PASSWORD) VALUES(@EMAIL,@PWD); EXEC ADDID @EMAILID = @EMAIL";
            SqlCommand cmd = new SqlCommand(query, con, trans);
            cmd.Parameters.AddWithValue("EMAIL", auth.email);
            cmd.Parameters.AddWithValue("PWD", hashedPwd);
            cmd.ExecuteNonQuery();

        }
        public bool CheckPwdMatch(string email, string pwd, SqlConnection con, SqlTransaction tran)
        {

            SqlCommand cmd = new SqlCommand("SELECT * FROM TBL_AUTH WHERE EMAIL=@EMAIL", con, tran);
            cmd.Parameters.AddWithValue("EMAIL", email);
            using (SqlDataReader rdr = cmd.ExecuteReader())
            {
                while (rdr.Read())
                {
                    string fetchedPwd = rdr["password"].ToString();
                    if (fetchedPwd == pwd) return true;
                }
                return false;
            }


        }
        public bool updateUserPwd(dynamic ob)
        {
            using (SqlConnection CON = new SqlConnection(strcon))
            {
                CON.Open();
                try
                {

                    using (SqlTransaction trans = CON.BeginTransaction())
                    {
                        string email = ob.email; 
                        string oldPwd = ob.oldPwd;
                        string newPwd = ob.newPwd;
                        string eOld = GenerateHash(oldPwd);
                        string eNew = GenerateHash(newPwd);
                     
                        if (CheckPwdMatch(email, eOld, CON, trans))
                        {
                            string query = "UPDATE TBL_AUTH SET PASSWORD=@PWD WHERE EMAIL = @EMAIL";

                            SqlCommand cmd = new SqlCommand(query, CON, trans);
                            cmd.Parameters.AddWithValue("PWD", eNew);
                            cmd.Parameters.AddWithValue("Email", email);
                            cmd.ExecuteNonQuery();
                            trans.Commit();
                                return true; 
                        }
                        else
                        {
                            return false;
                        }
                    }
                }
                catch (Exception ex) { return false; }
                finally
                {
                    CON.Close();
                }
            }
        }

        public void setUser(User user, SqlConnection con, SqlTransaction trans)
        {
            try
            {
                string query = "INSERT INTO TBL_USERS(FNAME,LNAME,EMAIL,WALLET) VALUES(@FNAME,@LNAME,@EMAIL,@WALLET)";
                SqlCommand cmd = new SqlCommand(query, con, trans);
                cmd.Parameters.AddWithValue("FNAME", user.fname);
                cmd.Parameters.AddWithValue("LNAME", user.lname);
                cmd.Parameters.AddWithValue("EMAIL", user.email);
                cmd.Parameters.AddWithValue("WALLET", 0);
                cmd.ExecuteNonQuery();
            }
            catch (Exception ex) { }
        }

        public string RegisterUser(User user, Auth auth)
        {
            using (SqlConnection CON = new SqlConnection(strcon))
            {
                CON.Open();
                try
                {

                    using (SqlTransaction trans = CON.BeginTransaction())
                    {
                        if (EmailExist(auth.email))
                        {
                            return "Email already exist.Kindly Login ";
                        }
                        setUser(user, CON, trans);
                        SetEmailPwd(auth, user.Id, CON, trans);
                        trans.Commit();

                        SendAdminConfirmationEmail(user);
                        return "Registered Successfully";
                    }

                }
                catch (Exception ex) { return ex.ToString(); }
                finally
                {
                    CON.Close();
                }
            }
        }

        public int UserLogin(Auth auth)
        {
            using (SqlConnection CON = new SqlConnection(strcon))
            {
                CON.Open();
                try
                {

                    using (SqlTransaction trans = CON.BeginTransaction())
                    {
                        if (!EmailExist(auth.email))
                            return 1;
                        int role = RoleExist(auth.email);
                        if (role == -1) return role;

                        SqlCommand cmd = new SqlCommand("SELECT PASSWORD from TBL_AUTH WHERE EMAIL = @EMAIL", CON, trans);
                        cmd.Parameters.AddWithValue("EMAIL", auth.email);
                        using (SqlDataReader dr = cmd.ExecuteReader())
                        {
                            if (dr.Read())
                            {
                                string storedPwd = dr.GetString(0);
                                string hashed = GenerateHash(auth.password);
                                if (!storedPwd.Equals(hashed))
                                {
                                    return 2;
                                }
                                else
                                {
                                    SiteMaster.email = auth.email;
                                    dynamic obj = new ExpandoObject();
                                    obj.roleId = role;
                                    obj.email = auth.email;
                                    common.setSessionData("sesssionData", obj);

                                    return role;
                                }
                            }


                        }

                        trans.Commit();
                        return 2;

                    }
                }
                catch (Exception ex) { return 2; }
                finally
                {

                    CON.Close();
                }
            }
        }

        public UserDetail GetUserData(string email)
        {
            UserDetail ud = GetUsersData().Where(u => u.email == email).FirstOrDefault();
            return ud;
        }

        public List<UserDetail> GetUsersData()
        {
            List<UserDetail> list = new List<UserDetail>();
            using (SqlConnection CON = new SqlConnection(strcon))
            {
                CON.Open();
                using (SqlTransaction trans = CON.BeginTransaction())
                {
                    string query = "SELECT U.ID,FNAME,LNAME,EMAIL,PHONE_NUMBER,R.ROLE_NAME AS ROLE, R.ID AS ROLE_ID,WALLET FROM TBL_USERS U LEFT JOIN TBL_ROLE AS R ON R.ID = U.ROLE_ID";
                    SqlCommand cmd = new SqlCommand(query, CON, trans);
                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        while (dr.Read())
                        {
                            UserDetail userDetail = new UserDetail
                            {
                                Id = Int32.Parse(dr["id"].ToString()),
                                fname = dr["fname"].ToString(),
                                lname = dr["lname"].ToString(),
                                phone = dr.IsDBNull(4) ? "" : (dr["phone_number"].ToString()),
                                role = dr.IsDBNull(5) ? "Unassigned" : (dr["role"].ToString()),
                                email = dr["email"].ToString(),
                                roleId = dr.IsDBNull(6) ? 0 : Int32.Parse(dr["role_id"].ToString()),
                                wallet = double.Parse(dr["wallet"].ToString())
                            };
                            list.Add(userDetail);
                        }
                    }

                }
            }
            return list;
        }

        public void UpdateUserDetails(User user)
        {
            using (SqlConnection con = new SqlConnection(strcon))
            {
                con.Open();
                try
                {
                    using (SqlTransaction trans = con.BeginTransaction())
                    {
                        string query = "UPDATE TBL_USERS SET FNAME =@FNAME,LNAME=@LNAME,PHONE_NUMBER=@CONTACT WHERE ID = @ID";
                        SqlCommand cmd = new SqlCommand(query, con, trans);
                        cmd.Parameters.AddWithValue("FNAME", user.fname);
                        cmd.Parameters.AddWithValue("LNAME", user.lname);
                        cmd.Parameters.AddWithValue("CONTACT", user.phone);
                        cmd.Parameters.AddWithValue("ID", user.Id);
                        cmd.ExecuteNonQuery();
                        trans.Commit();
                    }
                }
                catch (Exception ex) {  }
                finally
                {
                    con.Close();
                }
            }
        }

        public List<Role> GetRoles()
        {
            List<Role> list = new List<Role>();
            using (SqlConnection CON = new SqlConnection(strcon))
            {
                CON.Open();
                using (SqlTransaction trans = CON.BeginTransaction())
                {
                    string query = "SELECT * FROM TBL_ROLE";
                    SqlCommand cmd = new SqlCommand(query, CON, trans);
                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        while (dr.Read())
                        {
                            Role r = new Role
                            {
                                id = Int32.Parse(dr["id"].ToString()),
                                role_name = dr["role_name"].ToString()
                            };
                            list.Add(r);
                        }
                    }
                }

            }
            return list;
        }

        public bool AssignRole(User user)
        {
            using (SqlConnection con = new SqlConnection(strcon))
            {

                con.Open();
                using (SqlTransaction trans = con.BeginTransaction())
                {
                    try
                    {
                        string query = "UPDATE TBL_USERS SET ROLE_ID = @ROLE WHERE EMAIL = @EMAIL";
                        SqlCommand cmd = new SqlCommand(query, con, trans);
                        cmd.Parameters.AddWithValue("ROLE", user.roleId);
                        cmd.Parameters.AddWithValue("EMAIL", user.email);
                        cmd.ExecuteNonQuery();
                        return true;
                    }
                    catch (Exception ex)
                    {
                        return false;
                    }
                    finally
                    {
                        trans.Commit();
                        con.Close();
                    }

                }
            }
        }

        public List<UserAddress> GetAddresses(int id)
        {
            List<UserAddress> list = new List<UserAddress>();
            using (SqlConnection con = new SqlConnection(strcon))
            {

                con.Open();
                using (SqlTransaction trans = con.BeginTransaction())
                {
                    try
                    {
                        string query = "SELECT * FROM TBL_ADDRESS WHERE USER_ID = @ID";
                        SqlCommand cmd = new SqlCommand(query, con, trans);
                        cmd.Parameters.AddWithValue("ID", id);
                        SqlDataReader dr = cmd.ExecuteReader();
                        while (dr.Read())
                        {
                            UserAddress ud = new UserAddress()
                            {
                                address = dr["address"].ToString(),
                                id = Int32.Parse(dr["id"].ToString()),
                                userId = Int32.Parse(dr["user_id"].ToString())
                            };
                            list.Add(ud);
                        }
                        dr.Close();
                        return list;
                    }
                    catch (Exception ex)
                    {
                        return list;
                    }
                    finally
                    {
                        trans.Commit();
                        con.Close();
                    }

                }
            }
        }
        public bool AddAddress(int userId, string address)
        {
            using (SqlConnection con = new SqlConnection(strcon))
            {

                con.Open();
                using (SqlTransaction trans = con.BeginTransaction())
                {
                    try
                    {
                        string query = "INSERT INTO TBL_ADDRESS(USER_ID,ADDRESS) VALUES(@ID,@ADDR);";
                        SqlCommand cmd = new SqlCommand(query, con, trans);
                        cmd.Parameters.AddWithValue("ADDR", address);
                        cmd.Parameters.AddWithValue("ID", userId);
                        cmd.ExecuteNonQuery();
                        return true;
                    }
                    catch (Exception ex)
                    {
                        return false;
                    }
                    finally
                    {
                        trans.Commit();
                        con.Close();
                    }

                }
            }
        }

        public bool DeleteAddress(int addressId)
        {
            using (SqlConnection con = new SqlConnection(strcon))
            {

                con.Open();
                using (SqlTransaction trans = con.BeginTransaction())
                {
                    try
                    {
                        string query = "DELETE FROM TBL_ADDRESS WHERE ID = @ADR";
                        SqlCommand cmd = new SqlCommand(query, con, trans);
                        cmd.Parameters.AddWithValue("ADR", addressId);
                        cmd.ExecuteNonQuery();
                        return true;
                    }
                    catch (Exception ex)
                    {
                        return false;
                    }
                    finally
                    {
                        trans.Commit();
                        con.Close();
                    }

                }
            }
        }
        public bool LogOut()
        {
            SiteMaster.email = null;
            return true;
        }


        //Email Section 

        public void SendAdminConfirmationEmail(User user)
        {
            string host = $"https://localhost:44389/temporary?toAdmin=true&email={user.email}&role=";
            string mailbody = $@"
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
              New User SignUp
			
          </td>
        </tr>
      <tr> 
        <td align='center' valign='top' style='padding: 20px 0;'>
          Dear Admin, a new user {user.fname} {user.lname} has signed in to the website.</br>Kindly assign user the role
        </td>
      </tr>
      <tr> 
        <td align='center' valign='top' style='padding: 20px 0;'>
          <a href='{host}20' style='background - color:#ffffff; border:1px solid #333333; border-color:#333333; border-radius:6px; border-width:1px; color:#00843c !important; display:inline-block; font-size:18px; font-weight:normal; letter-spacing:0px; line-height:normal; padding:12px 18px 12px 18px; text-align:center; text-decoration:none; border-style:solid; font-family:courier, monospace;
   	text-decoration:none; 
   margin:20px;'>Customer</a>
          <a href='{host}30' style='background - color:#ffffff; border:1px solid #333333; border-color:#333333; border-radius:6px; border-width:1px; color:#00843c !important; display:inline-block; font-size:18px; font-weight:normal; letter-spacing:0px; line-height:normal; padding:12px 18px 12px 18px; text-align:center; text-decoration:none; border-style:solid; font-family:courier, monospace;
   	text-decoration:none; 
   margin:20px;'>Chef</a>
          <a href='{host}10020' style='background - color:#ffffff; border:1px solid #333333; border-color:#333333; border-radius:6px; border-width:1px; color:#00843c !important; display:inline-block; font-size:18px; font-weight:normal; letter-spacing:0px; line-height:normal; padding:12px 18px 12px 18px; text-align:center; text-decoration:none; border-style:solid; font-family:courier, monospace;
   	text-decoration:none; 
   margin:20px;'>Delivery</a>
        </td>
      </tr>
    </table>
</body>
</html>
  ";

            eHandler.sendEmail(mailbody, "anshul.saxena@xorosoft.com");
        }
    }
}

