using Microsoft.Ajax.Utilities;
using restaurant_management.Common;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace restaurant_management.Admin
{
    public partial class ResetPassword : System.Web.UI.Page
    {
        string strcon = ConfigurationManager.ConnectionStrings["con"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            string email = Request.QueryString["email"];
            if (email == null)
            {
                Response.Redirect("/Admin/Login.aspx"); 
            }
            {
                Email.Text = email;
            }
        }

        protected void SetPassword(object sender, EventArgs e)
        {
            string pwd1 = newPwd.Text; 
            string pwd2 = cnfPwd.Text;
            if( pwd1.IsNullOrWhiteSpace() || pwd2.IsNullOrWhiteSpace() || pwd1 != pwd2 )
            {
                newPwd.Text = "";
                cnfPwd.Text = ""; 
                string script = "alert('Password Mismatched')";
                ClientScript.RegisterStartupScript(this.GetType(), "Unsuccessful", script, true);

            }
            else
            {
                using (SqlConnection con = new SqlConnection(strcon))
                {
                    con.Open();
                    try
                    {

                    using(SqlTransaction tran = con.BeginTransaction())
                    {
                        string hashedPwd = new common().GenerateHash(pwd1);
                        string query = "UPDATE TBL_AUTH SET PASSWORD=@PWD WHERE EMAIL = @EMAIL"; 
                        SqlCommand cmd = new SqlCommand(query, con,tran);
                        cmd.Parameters.AddWithValue("PWD", hashedPwd); 
                        cmd.Parameters.AddWithValue("Email",Email.Text);
                        cmd.ExecuteNonQuery();
                        tran.Commit();
                        Response.Redirect("/Admin/Login.aspx",false);
                    }
                    }
                    catch (Exception ex)
                    {
                        throw ex; 
                    }
                    finally
                    {
                        con.Close();
                    }
                }
            }
        }
    }
}


/* 
 Next Task
 Payment gateway
Calculate delivery distance 
maintain a table for delivery guy availability
 On order place assign a delivery guy to that order. 
 Modify order table to have delivery guy ID 
 
Table Delivery
 */