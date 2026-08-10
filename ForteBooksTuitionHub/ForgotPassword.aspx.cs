using System;
using System.Configuration;
using System.Data.SqlClient;

namespace ForteBooksTuitionHub
{
    public partial class ForgotPassword : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["ForteDb"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void btnFindAccount_Click(object sender, EventArgs e)
        {
            lblError.Text = "";
            string username = txtUsername.Text.Trim();

            if (string.IsNullOrWhiteSpace(username))
            {
                lblError.Text = "Please enter your username.";
                return;
            }

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand(
                    "SELECT UserId, Role, SecurityQuestion FROM Users WHERE Username = @username AND Role IN ('Student', 'Tutor')", conn);
                cmd.Parameters.AddWithValue("@username", username);
                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();

                if (reader.Read())
                {
                    object securityQuestion = reader["SecurityQuestion"];

                    if (securityQuestion == DBNull.Value)
                    {
                        lblError.Text = "This account has no security question set up. Please contact the Administrator.";
                        return;
                    }

                    Session["ResetUserId"] = reader["UserId"].ToString();
                    Session["ResetAttempts"] = 0;

                    lblFoundUsername.Text = username;
                    lblSecurityQuestion.Text = securityQuestion.ToString();

                    pnlStep1.Visible = false;
                    pnlStep2.Visible = true;
                }
                else
                {
                    lblError.Text = "No student or tutor account found with that username.";
                }
            }
        }

        protected void btnCheckAnswer_Click(object sender, EventArgs e)
        {
            lblError.Text = "";

            if (Session["ResetUserId"] == null)
            {
                lblError.Text = "Session expired. Please start again.";
                pnlStep1.Visible = true;
                pnlStep2.Visible = false;
                return;
            }

            int attempts = Session["ResetAttempts"] != null ? (int)Session["ResetAttempts"] : 0;

            if (attempts >= 3)
            {
                lblError.Text = "Too many incorrect attempts. Please contact the Administrator to reset your password.";
                pnlStep2.Visible = false;
                return;
            }

            int userId = Convert.ToInt32(Session["ResetUserId"]);
            string answer = txtSecurityAnswer.Text.Trim().ToLower();
            string hashedAnswer = PasswordHelper.Hash(answer);

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand("SELECT SecurityAnswer FROM Users WHERE UserId = @id", conn);
                cmd.Parameters.AddWithValue("@id", userId);
                conn.Open();
                object storedAnswer = cmd.ExecuteScalar();

                if (storedAnswer != null && storedAnswer.ToString() == hashedAnswer)
                {
                    pnlStep2.Visible = false;
                    pnlStep3.Visible = true;
                }
                else
                {
                    attempts++;
                    Session["ResetAttempts"] = attempts;
                    int remaining = 3 - attempts;

                    if (remaining <= 0)
                    {
                        lblError.Text = "Too many incorrect attempts. Please contact the Administrator to reset your password.";
                        pnlStep2.Visible = false;
                    }
                    else
                    {
                        lblError.Text = "Incorrect answer. You have " + remaining + " attempt(s) remaining.";
                    }
                }
            }
        }

        protected void btnResetPassword_Click(object sender, EventArgs e)
        {
            lblError.Text = "";

            if (Session["ResetUserId"] == null)
            {
                lblError.Text = "Session expired. Please start again.";
                pnlStep1.Visible = true;
                pnlStep3.Visible = false;
                return;
            }

            string newPassword = txtNewPassword.Text.Trim();
            string confirmPassword = txtConfirmPassword.Text.Trim();

            if (string.IsNullOrWhiteSpace(newPassword) || newPassword.Length < 6)
            {
                lblError.Text = "Password must be at least 6 characters long.";
                return;
            }

            if (newPassword != confirmPassword)
            {
                lblError.Text = "Passwords do not match.";
                return;
            }

            int userId = Convert.ToInt32(Session["ResetUserId"]);
            string hashedPassword = PasswordHelper.Hash(newPassword);

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand("UPDATE Users SET Password = @pwd WHERE UserId = @id", conn);
                cmd.Parameters.AddWithValue("@pwd", hashedPassword);
                cmd.Parameters.AddWithValue("@id", userId);
                conn.Open();
                cmd.ExecuteNonQuery();
            }

            Session["ResetUserId"] = null;
            Session["ResetAttempts"] = null;

            Response.Redirect("Login.aspx?reset=1");
        }
    }
}