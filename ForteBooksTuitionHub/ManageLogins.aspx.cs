using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace ForteBooksTuitionHub
{
    public partial class ManageLogins : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["ForteDb"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            AuthHelper.CheckAccess(this, new string[] { "Admin" });

            if (!IsPostBack)
            {
                BindPersonDropdown();
                BindLogins();
            }
        }

        private void BindPersonDropdown()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql;
                if (rbTutorType.Checked)
                {
                    sql = @"SELECT TutorId AS Id, FullName FROM Tutors
                            WHERE TutorId NOT IN (SELECT TutorId FROM Users WHERE TutorId IS NOT NULL)
                            ORDER BY FullName";
                }
                else
                {
                    sql = @"SELECT StudentId AS Id, FullName FROM Students
                            WHERE StudentId NOT IN (SELECT StudentId FROM Users WHERE StudentId IS NOT NULL)
                            ORDER BY FullName";
                }

                SqlCommand cmd = new SqlCommand(sql, conn);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                ddlPerson.DataSource = dt;
                ddlPerson.DataBind();
            }
        }

        private void BindLogins()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = @"
                    SELECT u.Username, u.Role,
                           ISNULL(s.FullName, ISNULL(t.FullName, '-')) AS LinkedTo
                    FROM Users u
                    LEFT JOIN Students s ON u.StudentId = s.StudentId
                    LEFT JOIN Tutors t ON u.TutorId = t.TutorId
                    ORDER BY u.Role, u.Username";

                SqlCommand cmd = new SqlCommand(sql, conn);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvLogins.DataSource = dt;
                gvLogins.DataBind();
            }
        }

        protected void rbType_CheckedChanged(object sender, EventArgs e)
        {
            BindPersonDropdown();
        }

        protected void btnCreate_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            int personId = Convert.ToInt32(ddlPerson.SelectedValue);
            if (personId == 0)
            {
                lblError.Text = "Please select a student or tutor.";
                lblSuccess.Text = "";
                return;
            }

            string username = txtUsername.Text.Trim();
            string password = txtPassword.Text.Trim();
            string role = rbTutorType.Checked ? "Tutor" : "Student";

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                SqlCommand checkCmd = new SqlCommand("SELECT COUNT(*) FROM Users WHERE Username = @username", conn);
                checkCmd.Parameters.AddWithValue("@username", username);
                int exists = (int)checkCmd.ExecuteScalar();

                if (exists > 0)
                {
                    lblError.Text = "That username is already taken.";
                    lblSuccess.Text = "";
                    return;
                }

                string hashedPassword = PasswordHelper.Hash(password);

                SqlCommand insertCmd;
                if (role == "Tutor")
                {
                    insertCmd = new SqlCommand(
                        "INSERT INTO Users (Username, Password, Role, TutorId) VALUES (@username, @password, 'Tutor', @personId)", conn);
                }
                else
                {
                    insertCmd = new SqlCommand(
                        "INSERT INTO Users (Username, Password, Role, StudentId) VALUES (@username, @password, 'Student', @personId)", conn);
                }
                insertCmd.Parameters.AddWithValue("@username", username);
                insertCmd.Parameters.AddWithValue("@password", hashedPassword);
                insertCmd.Parameters.AddWithValue("@personId", personId);
                insertCmd.ExecuteNonQuery();
            }

            lblError.Text = "";
            lblSuccess.Text = "Login created successfully for " + username + ".";
            txtUsername.Text = "";
            txtPassword.Text = "";
            BindPersonDropdown();
            BindLogins();
        }
    }
}