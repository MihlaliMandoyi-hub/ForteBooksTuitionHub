using System;
using System.Configuration;
using System.Data.SqlClient;

namespace ForteBooksTuitionHub
{
    public partial class Login : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["ForteDb"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string registered = Request.QueryString["registered"];
                if (registered == "student")
                {
                    lblInfo.Text = "Account created! You can log in now.";
                }
                else if (registered == "tutor")
                {
                    lblInfo.Text = "Account created! Your account is pending Admin approval — you'll be able to log in once approved.";
                }
                else if (Request.QueryString["reset"] == "1")
                {
                    lblInfo.Text = "Your password has been reset. You can log in with your new password.";
                }
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string username = txtUsername.Text.Trim();
            string password = txtPassword.Text.Trim();

            if (string.IsNullOrWhiteSpace(username) || string.IsNullOrWhiteSpace(password))
            {
                lblError.Text = "Please enter both username and password.";
                return;
            }

            string hashedPassword = PasswordHelper.Hash(password);

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand(
                    "SELECT UserId, Role, StudentId, TutorId, Status FROM Users WHERE Username = @username AND Password = @password", conn);
                cmd.Parameters.AddWithValue("@username", username);
                cmd.Parameters.AddWithValue("@password", hashedPassword);

                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();

                if (reader.Read())
                {
                    string status = reader["Status"].ToString();

                    if (status == "Pending")
                    {
                        lblError.Text = "Your tutor account is still awaiting Admin approval. Please check back soon.";
                        return;
                    }

                    if (status == "Rejected")
                    {
                        lblError.Text = "Your tutor application was not approved. Please contact the administrator.";
                        return;
                    }

                    Session["UserId"] = reader["UserId"].ToString();
                    Session["Username"] = username;
                    Session["Role"] = reader["Role"].ToString();
                    Session["StudentId"] = reader["StudentId"] != DBNull.Value ? reader["StudentId"].ToString() : null;
                    Session["TutorId"] = reader["TutorId"] != DBNull.Value ? reader["TutorId"].ToString() : null;

                    Response.Redirect("Default.aspx");
                }
                else
                {
                    lblError.Text = "Invalid username or password.";
                }
            }
        }
    }
}