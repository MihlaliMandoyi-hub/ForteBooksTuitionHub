using System;
using System.Configuration;
using System.Data.SqlClient;

namespace ForteBooksTuitionHub
{
    public partial class StudentAdd : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["ForteDb"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            AuthHelper.CheckAccess(this, new string[] { "Admin" });

            if (!IsPostBack)
            {
                if (Request.QueryString["id"] != null)
                {
                    int studentId = Convert.ToInt32(Request.QueryString["id"]);
                    LoadStudent(studentId);
                    lblTitle.Text = "Edit Student";
                }
                else
                {
                    txtDateRegistered.Text = DateTime.Today.ToString("yyyy-MM-dd");
                }
            }
        }

        private void LoadStudent(int studentId)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand("SELECT * FROM Students WHERE StudentId = @id", conn);
                cmd.Parameters.AddWithValue("@id", studentId);
                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();

                if (reader.Read())
                {
                    hfStudentId.Value = reader["StudentId"].ToString();
                    txtFullName.Text = reader["FullName"].ToString();
                    txtEmail.Text = reader["Email"].ToString();
                    txtPhone.Text = reader["Phone"].ToString();
                    txtDateRegistered.Text = Convert.ToDateTime(reader["DateRegistered"]).ToString("yyyy-MM-dd");
                }
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            int studentId = Convert.ToInt32(hfStudentId.Value);

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                // Check for duplicate email (excluding this student if editing)
                SqlCommand checkCmd = new SqlCommand(
                    "SELECT COUNT(*) FROM Students WHERE Email = @email AND StudentId <> @id", conn);
                checkCmd.Parameters.AddWithValue("@email", txtEmail.Text.Trim());
                checkCmd.Parameters.AddWithValue("@id", studentId);
                int existing = (int)checkCmd.ExecuteScalar();

                if (existing > 0)
                {
                    lblError.Text = "A student with this email already exists.";
                    return;
                }

                SqlCommand cmd;

                if (studentId == 0)
                {
                    // INSERT new student
                    cmd = new SqlCommand(
                        "INSERT INTO Students (FullName, Email, Phone, DateRegistered) " +
                        "VALUES (@fullName, @email, @phone, @dateRegistered)", conn);
                }
                else
                {
                    // UPDATE existing student
                    cmd = new SqlCommand(
                        "UPDATE Students SET FullName=@fullName, Email=@email, Phone=@phone, DateRegistered=@dateRegistered " +
                        "WHERE StudentId=@id", conn);
                    cmd.Parameters.AddWithValue("@id", studentId);
                }

                cmd.Parameters.AddWithValue("@fullName", txtFullName.Text.Trim());
                cmd.Parameters.AddWithValue("@email", txtEmail.Text.Trim());
                cmd.Parameters.AddWithValue("@phone", txtPhone.Text.Trim());
                cmd.Parameters.AddWithValue("@dateRegistered", Convert.ToDateTime(txtDateRegistered.Text));

                cmd.ExecuteNonQuery();
            }

            Response.Redirect("Students.aspx");
        }
    }
}