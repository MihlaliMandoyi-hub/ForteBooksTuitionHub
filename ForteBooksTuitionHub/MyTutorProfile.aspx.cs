using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;

namespace ForteBooksTuitionHub
{
    public partial class MyTutorProfile : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["ForteDb"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            AuthHelper.CheckAccess(this, new string[] { "Tutor" });

            if (Session["TutorId"] == null)
            {
                Response.Redirect("AccessDenied.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadProfile();
                LoadSummary();
                LoadFeedback();
            }
        }

        private int CurrentTutorId
        {
            get { return Convert.ToInt32(Session["TutorId"]); }
        }

        private void LoadProfile()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand(
                    "SELECT FullName, Email, Phone, Subject, HourlyRate FROM Tutors WHERE TutorId = @id", conn);
                cmd.Parameters.AddWithValue("@id", CurrentTutorId);
                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();

                if (reader.Read())
                {
                    txtFullName.Text = reader["FullName"].ToString();
                    txtEmail.Text = reader["Email"].ToString();
                    txtPhone.Text = reader["Phone"].ToString();
                    txtSubject.Text = reader["Subject"].ToString();
                    txtHourlyRate.Text = Convert.ToDecimal(reader["HourlyRate"]).ToString("0.00");
                }
            }
        }

        private void LoadSummary()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                SqlCommand sessionsCmd = new SqlCommand(
                    "SELECT COUNT(*) FROM Sessions WHERE TutorId = @id AND Status <> 'Cancelled'", conn);
                sessionsCmd.Parameters.AddWithValue("@id", CurrentTutorId);
                lblTotalSessions.Text = sessionsCmd.ExecuteScalar().ToString();

                SqlCommand hoursCmd = new SqlCommand(
                    "SELECT ISNULL(SUM(HoursWorked), 0) FROM Timesheets WHERE TutorId = @id AND Status = 'Approved'", conn);
                hoursCmd.Parameters.AddWithValue("@id", CurrentTutorId);
                decimal approvedHours = (decimal)hoursCmd.ExecuteScalar();
                lblApprovedHours.Text = approvedHours.ToString("N1");

                SqlCommand availCmd = new SqlCommand(
                    "SELECT ISNULL(SUM(DATEDIFF(MINUTE, StartTime, EndTime)), 0) / 60.0 FROM TutorAvailability WHERE TutorId = @id", conn);
                availCmd.Parameters.AddWithValue("@id", CurrentTutorId);
                decimal availHours = Convert.ToDecimal(availCmd.ExecuteScalar());
                lblAvailableHours.Text = availHours.ToString("N1");

                SqlCommand grossCmd = new SqlCommand(
                    "SELECT ISNULL(SUM(t.HourlyRate), 0) FROM Sessions s INNER JOIN Tutors t ON s.TutorId = t.TutorId WHERE s.TutorId = @id AND s.Status = 'Completed'", conn);
                grossCmd.Parameters.AddWithValue("@id", CurrentTutorId);
                decimal gross = (decimal)grossCmd.ExecuteScalar();
                decimal netEarnings = gross * 0.95m;

                SqlCommand paidCmd = new SqlCommand("SELECT ISNULL(SUM(Amount), 0) FROM TutorPayouts WHERE TutorId = @id", conn);
                paidCmd.Parameters.AddWithValue("@id", CurrentTutorId);
                decimal paidOut = (decimal)paidCmd.ExecuteScalar();

                lblNetEarnings.Text = netEarnings.ToString("N2");
                lblPaidOut.Text = paidOut.ToString("N2");
                lblStillOwed.Text = (netEarnings - paidOut).ToString("N2");

                SqlCommand ratingCmd = new SqlCommand(
                    "SELECT AVG(CAST(Rating AS DECIMAL(3,2))), COUNT(*) FROM Sessions WHERE TutorId = @id AND Rating IS NOT NULL", conn);
                ratingCmd.Parameters.AddWithValue("@id", CurrentTutorId);
                SqlDataReader ratingReader = ratingCmd.ExecuteReader();
                if (ratingReader.Read() && ratingReader[0] != DBNull.Value)
                {
                    decimal avgRating = Convert.ToDecimal(ratingReader[0]);
                    int ratingCount = Convert.ToInt32(ratingReader[1]);
                    lblAvgRating.Text = avgRating.ToString("N1") + " / 5 (" + ratingCount + " review" + (ratingCount == 1 ? "" : "s") + ")";
                    int roundedStars = (int)Math.Round(avgRating);
                    lblAvgStars.Text = new string('\u2605', roundedStars) + new string('\u2606', 5 - roundedStars);
                }
                else
                {
                    lblAvgRating.Text = "No ratings yet";
                }
            }
        }

        private void LoadFeedback()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand(
                    @"SELECT TOP 10 s.Rating, s.RatingComment AS Comment, s.RatingDate AS CreatedDate, st.FullName AS StudentName
                      FROM Sessions s
                      INNER JOIN Students st ON s.StudentId = st.StudentId
                      WHERE s.TutorId = @id AND s.Rating IS NOT NULL
                      ORDER BY s.RatingDate DESC", conn);
                cmd.Parameters.AddWithValue("@id", CurrentTutorId);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvFeedback.DataSource = dt;
                gvFeedback.DataBind();
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                SqlCommand checkCmd = new SqlCommand(
                    "SELECT COUNT(*) FROM Tutors WHERE Email = @email AND TutorId <> @id", conn);
                checkCmd.Parameters.AddWithValue("@email", txtEmail.Text.Trim());
                checkCmd.Parameters.AddWithValue("@id", CurrentTutorId);
                int existing = (int)checkCmd.ExecuteScalar();

                if (existing > 0)
                {
                    lblError.Text = "Another tutor is already using this email address.";
                    lblMessage.Text = "";
                    return;
                }

                decimal hourlyRate = string.IsNullOrWhiteSpace(txtHourlyRate.Text)
                    ? 0
                    : Convert.ToDecimal(txtHourlyRate.Text.Trim(), CultureInfo.InvariantCulture);

                SqlCommand cmd = new SqlCommand(
                    "UPDATE Tutors SET FullName=@fullName, Email=@email, Phone=@phone, Subject=@subject, HourlyRate=@rate WHERE TutorId=@id", conn);
                cmd.Parameters.AddWithValue("@fullName", txtFullName.Text.Trim());
                cmd.Parameters.AddWithValue("@email", txtEmail.Text.Trim());
                cmd.Parameters.AddWithValue("@phone", txtPhone.Text.Trim());
                cmd.Parameters.AddWithValue("@subject", txtSubject.Text.Trim());
                cmd.Parameters.AddWithValue("@rate", hourlyRate);
                cmd.Parameters.AddWithValue("@id", CurrentTutorId);
                cmd.ExecuteNonQuery();
            }

            lblError.Text = "";
            lblMessage.Text = "Profile updated successfully.";
        }
    }
}