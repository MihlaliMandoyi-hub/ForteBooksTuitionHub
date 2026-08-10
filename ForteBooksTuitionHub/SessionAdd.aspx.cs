using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Text;

namespace ForteBooksTuitionHub
{
    public partial class SessionAdd : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["ForteDb"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            AuthHelper.CheckAccess(this, new string[] { "Admin", "Student" });

            if (!IsPostBack)
            {
                BindStudents();
                BindTutors();
            }
        }

        private void BindStudents()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string role = Session["Role"] != null ? Session["Role"].ToString() : "";
                bool isStudent = role == "Student" && Session["StudentId"] != null;

                string sql = isStudent
                    ? "SELECT StudentId, FullName FROM Students WHERE StudentId = @id"
                    : "SELECT StudentId, FullName FROM Students ORDER BY FullName";

                SqlCommand cmd = new SqlCommand(sql, conn);
                if (isStudent)
                {
                    cmd.Parameters.AddWithValue("@id", Convert.ToInt32(Session["StudentId"]));
                }

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                ddlStudent.DataSource = dt;
                ddlStudent.DataBind();

                if (isStudent)
                {
                    if (ddlStudent.Items.Count > 0 && ddlStudent.Items[0].Value == "0")
                    {
                        ddlStudent.Items.RemoveAt(0);
                    }
                    ddlStudent.Enabled = false;
                }
            }
        }

        private void BindTutors()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand("SELECT TutorId, FullName FROM Tutors ORDER BY FullName", conn);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);
                ddlTutor.DataSource = dt;
                ddlTutor.DataBind();
            }
        }

        protected void ddlTutor_SelectedIndexChanged(object sender, EventArgs e)
        {
            int tutorId = Convert.ToInt32(ddlTutor.SelectedValue);

            if (tutorId == 0)
            {
                pnlTutorAvailability.Visible = false;
                return;
            }

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand(
                    "SELECT DayOfWeek, StartTime, EndTime FROM TutorAvailability WHERE TutorId = @id " +
                    "ORDER BY CASE DayOfWeek WHEN 'Monday' THEN 1 WHEN 'Tuesday' THEN 2 WHEN 'Wednesday' THEN 3 " +
                    "WHEN 'Thursday' THEN 4 WHEN 'Friday' THEN 5 WHEN 'Saturday' THEN 6 ELSE 7 END, StartTime", conn);
                cmd.Parameters.AddWithValue("@id", tutorId);
                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();

                StringBuilder sb = new StringBuilder();
                bool any = false;
                while (reader.Read())
                {
                    any = true;
                    sb.Append(reader["DayOfWeek"] + ": " + reader["StartTime"] + " - " + reader["EndTime"] + "<br/>");
                }

                lblAvailability.Text = any ? sb.ToString() : "No availability slots set for this tutor yet.";
                pnlTutorAvailability.Visible = true;
            }
        }

        protected void btnBook_Click(object sender, EventArgs e)
        {
            lblError.Text = "";

            int studentId = Convert.ToInt32(ddlStudent.SelectedValue);
            int tutorId = Convert.ToInt32(ddlTutor.SelectedValue);

            if (studentId == 0 || tutorId == 0)
            {
                lblError.Text = "Please select both a student and a tutor.";
                return;
            }

            DateTime sessionDate;
            TimeSpan startTime, endTime;

            if (!DateTime.TryParse(txtSessionDate.Text, out sessionDate))
            {
                lblError.Text = "Please enter a valid session date.";
                return;
            }

            if (!TimeSpan.TryParse(txtStartTime.Text, out startTime) || !TimeSpan.TryParse(txtEndTime.Text, out endTime))
            {
                lblError.Text = "Please enter valid start and end times.";
                return;
            }

            if (endTime <= startTime)
            {
                lblError.Text = "End time must be after start time.";
                return;
            }

            if (sessionDate.Date < DateTime.Today)
            {
                lblError.Text = "Session date cannot be in the past.";
                return;
            }

            string studentName = "";
            string tutorName = "";

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                string dayOfWeek = sessionDate.DayOfWeek.ToString();

                SqlCommand availCmd = new SqlCommand(
                    "SELECT COUNT(*) FROM TutorAvailability WHERE TutorId = @tutorId AND DayOfWeek = @day " +
                    "AND StartTime <= @start AND EndTime >= @end", conn);
                availCmd.Parameters.AddWithValue("@tutorId", tutorId);
                availCmd.Parameters.AddWithValue("@day", dayOfWeek);
                availCmd.Parameters.AddWithValue("@start", startTime);
                availCmd.Parameters.AddWithValue("@end", endTime);
                int withinAvailability = (int)availCmd.ExecuteScalar();

                if (withinAvailability == 0)
                {
                    lblError.Text = "This time falls outside the tutor's published availability for " + dayOfWeek + ".";
                    return;
                }

                SqlCommand conflictCmd = new SqlCommand(
                    "SELECT COUNT(*) FROM Sessions WHERE TutorId = @tutorId AND SessionDate = @date " +
                    "AND Status <> 'Cancelled' AND StartTime < @end AND @start < EndTime", conn);
                conflictCmd.Parameters.AddWithValue("@tutorId", tutorId);
                conflictCmd.Parameters.AddWithValue("@date", sessionDate.Date);
                conflictCmd.Parameters.AddWithValue("@start", startTime);
                conflictCmd.Parameters.AddWithValue("@end", endTime);
                int conflicts = (int)conflictCmd.ExecuteScalar();

                if (conflicts > 0)
                {
                    lblError.Text = "This tutor already has a session booked that overlaps this time. Please choose another slot.";
                    return;
                }

                SqlCommand insertCmd = new SqlCommand(
                    "INSERT INTO Sessions (StudentId, TutorId, SessionDate, StartTime, EndTime, Status) " +
                    "VALUES (@studentId, @tutorId, @date, @start, @end, 'Booked')", conn);
                insertCmd.Parameters.AddWithValue("@studentId", studentId);
                insertCmd.Parameters.AddWithValue("@tutorId", tutorId);
                insertCmd.Parameters.AddWithValue("@date", sessionDate.Date);
                insertCmd.Parameters.AddWithValue("@start", startTime);
                insertCmd.Parameters.AddWithValue("@end", endTime);
                insertCmd.ExecuteNonQuery();

                SqlCommand namesCmd = new SqlCommand(
                    "SELECT (SELECT FullName FROM Students WHERE StudentId = @studentId) AS StudentName, " +
                    "(SELECT FullName FROM Tutors WHERE TutorId = @tutorId) AS TutorName", conn);
                namesCmd.Parameters.AddWithValue("@studentId", studentId);
                namesCmd.Parameters.AddWithValue("@tutorId", tutorId);
                SqlDataReader reader = namesCmd.ExecuteReader();
                if (reader.Read())
                {
                    studentName = reader["StudentName"].ToString();
                    tutorName = reader["TutorName"].ToString();
                }
            }

            lblConfirmStudent.Text = studentName;
            lblConfirmTutor.Text = tutorName;
            lblConfirmDate.Text = sessionDate.ToString("yyyy-MM-dd (dddd)");
            lblConfirmTime.Text = startTime.ToString(@"hh\:mm") + " - " + endTime.ToString(@"hh\:mm");

            pnlForm.Visible = false;
            pnlConfirmation.Visible = true;
        }
    }
}