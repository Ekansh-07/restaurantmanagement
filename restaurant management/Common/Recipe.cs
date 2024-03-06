using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Services.Protocols;
using Newtonsoft.Json.Serialization;
using restaurant_management.Modal;


namespace restaurant_management.Common
{
    public class Recipes
    {
        string strcon = ConfigurationManager.ConnectionStrings["con"].ConnectionString;
        public EmailHandler eHandler = new EmailHandler();

        public bool AddRecipe(Recipe recipe)
        {
            using (SqlConnection con = new SqlConnection(strcon))
            {

                con.Open();
                using (SqlTransaction trans = con.BeginTransaction())
                {
                    try
                    {
                        string query = "INSERT INTO TBL_MENU(NAME,DESCRIPTION,PRICE,CATEGORY_ID,IMG_URL,STATUS_ID) VALUES(@NAME,@DES,@PRICE,@CTG,@URL,@SID);";
                        SqlCommand cmd = new SqlCommand(query, con, trans);
                        cmd.Parameters.AddWithValue("NAME", recipe.name);
                        cmd.Parameters.AddWithValue("DES", recipe.description);
                        cmd.Parameters.AddWithValue("PRICE", recipe.price);
                        cmd.Parameters.AddWithValue("CTG", recipe.category_id);
                        cmd.Parameters.AddWithValue("URL", recipe.image_url);
                        cmd.Parameters.AddWithValue("SID", 10);
                        cmd.ExecuteNonQuery();
                        trans.Commit();
                        List<Recipe> pendingDishes = GetDishes().Where(d  => d.status_id == 10).ToList();
                        SendAdminDishAdditionEmail(pendingDishes); 
                        return true;
                    }
                    catch (Exception ex)
                    {
                        return false;
                    }
                    finally
                    {
                        
                        con.Close();
                    }
                }
            }
        }
        public bool UpdateDishStatus(Recipe recipe)
        {
            using (SqlConnection con = new SqlConnection(strcon))
            {

                con.Open();
                using (SqlTransaction trans = con.BeginTransaction())
                {
                    try
                    {
                        string query = "UPDATE TBL_MENU SET NAME= @NAME,DESCRIPTION = @DES,PRICE =@PRICE,IMG_URL = @IMG, STATUS_ID =@SID WHERE ID= @ID";
                        SqlCommand cmd = new SqlCommand(query, con, trans);
                        cmd.Parameters.AddWithValue("ID", recipe.id);
                        cmd.Parameters.AddWithValue("NAME",recipe.name);
                        cmd.Parameters.AddWithValue ("DES", recipe.description);
                        cmd.Parameters.AddWithValue("PRICE", recipe.price);
                        cmd.Parameters.AddWithValue("IMG", recipe.image_url);
                        cmd.Parameters.AddWithValue("SID", recipe.status_id);
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
        public bool ApproveWithId(int id)
        {
            using (SqlConnection con = new SqlConnection(strcon))
            {

                con.Open();
                using (SqlTransaction trans = con.BeginTransaction())
                {
                    try
                    {
                        string query = "UPDATE TBL_MENU SET STATUS_ID =@SID WHERE ID= @ID";
                        SqlCommand cmd = new SqlCommand(query, con, trans);
                        cmd.Parameters.AddWithValue("ID", id);                      
                        cmd.Parameters.AddWithValue("SID",30);
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
        public bool DeleteDishStatus(int id)
        {
            using (SqlConnection con = new SqlConnection(strcon))
            {

                con.Open();
                using (SqlTransaction trans = con.BeginTransaction())
                {
                    try
                    {
                        string query = "DELETE TBL_MENU WHERE ID= @ID";
                        SqlCommand cmd = new SqlCommand(query, con, trans);
                        cmd.Parameters.AddWithValue("ID",id);
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
        public List<Recipe> GetDishes()
        {
            List<Recipe> list = new List<Recipe>();
            using (SqlConnection con = new SqlConnection(strcon))
            {

                con.Open();
                using (SqlTransaction trans = con.BeginTransaction())
                {
                    try
                    {
                        string query = "SELECT * FROM MENU_VIEW";
                        SqlCommand cmd = new SqlCommand(query, con, trans);
                        using (SqlDataReader dr = cmd.ExecuteReader())
                        {
                            while (dr.Read())
                            {
                                Recipe recipe = new Recipe()
                                {
                                    id = Int32.Parse(dr["ID"].ToString()),
                                    name = dr["Name"].ToString(),
                                    description = dr["Description"].ToString(),
                                    price = Int32.Parse(dr["PRICE"].ToString()),
                                    category_id = Int32.Parse(dr["CATEGORY_ID"].ToString()),
                                    status_id = Int32.Parse(dr["STATUS_ID"].ToString()),
                                    image_url = dr["IMG_URL"].ToString(),
                                    status = dr["STATUS"].ToString(),
                                };
                                list.Add(recipe);
                            }
                        }
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

       
        public string getSearchItems(string query)
        {
            string data = string.Empty;
            string key = "f265ae31226a4f4ab41320e2bab06a03"; 
            HttpWebRequest req = (HttpWebRequest)WebRequest.Create("https://api.spoonacular.com/recipes/complexSearch?apiKey=" + key + "&query=" + query +"&number=20 ");
            HttpWebResponse res = (HttpWebResponse)req.GetResponse();
            StreamReader reader = new StreamReader(res.GetResponseStream());
            data = reader.ReadToEnd();
            return data; 
        }

        public string GetRecipeInfo(int id)
        {
            string data = string.Empty;
            string key = "f265ae31226a4f4ab41320e2bab06a03";
            HttpWebRequest req = (HttpWebRequest)WebRequest.Create("https://api.spoonacular.com/recipes/"+id+"/information?apiKey=" + key);
             HttpWebResponse res = (HttpWebResponse)req.GetResponse();
            StreamReader reader = new StreamReader(res.GetResponseStream());
            data = reader.ReadToEnd();
            return data;
        }

        public void SendAdminDishAdditionEmail( List<Recipe> recipes)
        {
            string listOfRecipes = string.Empty; 
            foreach(Recipe r in  recipes )
            {
                string host =  $"https://localhost:44389/temporary?toAdmin=true&dishId={r.id}&isApprove=";
                string item = $@" <tr> 
        <td align='center' valign='top' style='padding: 20px 0;'><img src='{r.image_url}'/></td>
        <td align='center' valign='top' style='padding: 20px 0;'>{r.name}</td>
        <td align='center' valign='top' style='padding: 20px 0;'>{r.description}</td>
        <td align='center' valign='top' style='padding: 20px 0;'>
          <a href='{host}true' style='background-color:#ffffff; border:1px solid #333333; border-color:#333333; border-radius:6px; border-width:1px; color:#00843c !important; display:inline-block; font-size:18px; font-weight:normal; letter-spacing:0px; line-height:normal; padding:12px 18px 12px 18px; text-align:center; text-decoration:none; border-style:solid; font-family:courier, monospace;
   	    text-decoration:none;margin:20px;'>Approve</a>
        </td>
        <td align='center' valign='top' style='padding: 20px 0;'>
          <a href='{host}false' style='background-color:#ffffff; border:1px solid #333333; border-color:#333333; border-radius:6px; border-width:1px; color:#00843c !important; display:inline-block; font-size:18px; font-weight:normal; letter-spacing:0px; line-height:normal; padding:12px 18px 12px 18px; text-align:center; text-decoration:none; border-style:solid; font-family:courier, monospace;
   	text-decoration:none; margin:20px;'>Reject</a>
        </td>
</tr>";
                listOfRecipes += item; 
            }
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
              Newly Added Recipes For Approval
			
          </td>
        </tr>
      <tr> 
        <td align='center' valign='top' style='padding: 20px 0;'>
          Dear Admin,kindly approve/reject the new recipes.</br>
        </td>
      </tr>
        {listOfRecipes}; 
    </table>
</body>
</html>
  ";

            eHandler.sendEmail(mailbody, "anshul.saxena@xorosoft.com");
        }
    }
}

