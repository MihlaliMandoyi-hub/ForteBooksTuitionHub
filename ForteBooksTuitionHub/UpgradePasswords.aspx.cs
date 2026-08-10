using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Collections.Generic;

namespace ForteBooksTuitionHub
{
    public partial class UpgradePasswords : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["ForteDb"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                SqlCommand selectCmd = new SqlCommand("SELECT UserId, Password FROM Users", conn);
                SqlDataReader reader = selectCmd.ExecuteReader();

                var updates = new List<Tuple<int, string>>();
                while (reader.Read())
                {
                    int userId = (int)reader["UserId"];
                    string plainPassword = reader["Password"].ToString();

                    if (plainPassword.Length != 64)
                    {
                        updates.Add(new Tuple<int, string>(userId, PasswordHelper.Hash(plainPassword)));
                    }
                }
                reader.Close();

                foreach (var u in updates)
                {
                    SqlCommand updateCmd = new SqlCommand("UPDATE Users SET Password = @pwd WHERE UserId = @id", conn);
                    updateCmd.Parameters.AddWithValue("@pwd", u.Item2);
                    updateCmd.Parameters.AddWithValue("@id", u.Item1);
                    updateCmd.ExecuteNonQuery();
                }

                lblResult.Text = updates.Count + " account(s) upgraded to hashed passwords. You can now delete this page.";
            }
        }
    }
}