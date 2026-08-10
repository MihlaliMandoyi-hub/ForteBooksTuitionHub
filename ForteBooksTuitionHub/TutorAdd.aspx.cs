using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Globalization;

namespace ForteBooksTuitionHub
{
    public partial class TutorAdd : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["ForteDb"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            AuthHelper.CheckAccess(this, new string[] { "Admin" });

            if (!IsPostBack)
            {
                if (Request.QueryString["id"] != null)
                {
                    int tutorId = Convert.ToInt32(Request.QueryString["id"]);
                    LoadTutor(tutorId);
                    lblTitle.Text = "Edit Tutor";
                }
            }
        }

        private void LoadTutor(int tutorId)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand("SELECT * FROM Tutors WHERE TutorId = @id", conn);
                cmd.Parameters.AddWithValue("@id", tutorId);
                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();

                if (reader.Read())
                {
                    hfTutorId.Value = reader["TutorId"].ToString();
                    txtFullName.Text = reader["FullName"].ToString();
                    txtEmail.Text = reader["Email"].ToString();
                    txtPhone.Text = reader["Phone"].ToString();
                    txtSubject.Text = reader["Subject"].ToString();
                    txtHourlyRate.Text = Convert.ToDecimal(reader["HourlyRate"]).ToString("0.00");
                }
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            int tutorId = Convert.ToInt32(hfTutorId.Value);

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                // Check for duplicate email (excluding this tutor if editing)
                SqlCommand checkCmd = new SqlCommand(
                    "SELECT COUNT(*) FROM Tutors WHERE Email = @email AND TutorId <> @id", conn);
                checkCmd.Parameters.AddWithValue("@email", txtEmail.Text.Trim());
                checkCmd.Parameters.AddWithValue("@id", tutorId);
                int existing = (int)checkCmd.ExecuteScalar();

                if (existing > 0)
                {
                    lblError.Text = "A tutor with this email already exists.";
                    return;
                }

                SqlCommand cmd;

                if (tutorId == 0)
                {
                    cmd = new SqlCommand(
                        "INSERT INTO Tutors (FullName, Email, Phone, Subject, HourlyRate) " +
                        "VALUES (@fullName, @email, @phone, @subject, @rate)", conn);
                }
                else
                {
                    cmd = new SqlCommand(
                        "UPDATE Tutors SET FullName=@fullName, Email=@email, Phone=@phone, Subject=@subject, HourlyRate=@rate " +
                        "WHERE TutorId=@id", conn);
                    cmd.Parameters.AddWithValue("@id", tutorId);
                }

                cmd.Parameters.AddWithValue("@fullName", txtFullName.Text.Trim());
                cmd.Parameters.AddWithValue("@email", txtEmail.Text.Trim());
                cmd.Parameters.AddWithValue("@phone", txtPhone.Text.Trim());
                cmd.Parameters.AddWithValue("@subject", txtSubject.Text.Trim());
                cmd.Parameters.AddWithValue("@rate", Convert.ToDecimal(txtHourlyRate.Text.Trim(), CultureInfo.InvariantCulture));

                cmd.ExecuteNonQuery();
            }

            Response.Redirect("Tutors.aspx");
        }
    }
}