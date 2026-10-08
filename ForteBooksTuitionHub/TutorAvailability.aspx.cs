using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace ForteBooksTuitionHub
{
    public partial class TutorAvailability : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["ForteDb"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            AuthHelper.CheckAccess(this, new string[] { "Admin" });

            if (Request.QueryString["tutorId"] == null)
            {
                Response.Redirect("Tutors.aspx");
                return;
            }

            int tutorId = Convert.ToInt32(Request.QueryString["tutorId"]);
            hfTutorId.Value = tutorId.ToString();

            if (!IsPostBack)
            {
                LoadTutorName(tutorId);
                BindAvailability(tutorId);
            }
        }

        private void LoadTutorName(int tutorId)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand("SELECT FullName FROM Tutors WHERE TutorId = @id", conn);
                cmd.Parameters.AddWithValue("@id", tutorId);
                conn.Open();
                object result = cmd.ExecuteScalar();
                lblTutorName.Text = result != null ? result.ToString() : "";
            }
        }

        private void BindAvailability(int tutorId)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand(
                    "SELECT AvailabilityId, DayOfWeek, StartTime, EndTime, Venue FROM TutorAvailability " +
                    "WHERE TutorId = @tutorId ORDER BY " +
                    "CASE DayOfWeek WHEN 'Monday' THEN 1 WHEN 'Tuesday' THEN 2 WHEN 'Wednesday' THEN 3 " +
                    "WHEN 'Thursday' THEN 4 WHEN 'Friday' THEN 5 WHEN 'Saturday' THEN 6 ELSE 7 END, StartTime", conn);
                cmd.Parameters.AddWithValue("@tutorId", tutorId);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvAvailability.DataSource = dt;
                gvAvailability.DataBind();
            }
        }

        protected void btnAdd_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            int tutorId = Convert.ToInt32(hfTutorId.Value);

            TimeSpan startTime, endTime;
            bool validStart = TimeSpan.TryParse(txtStartTime.Text, out startTime);
            bool validEnd = TimeSpan.TryParse(txtEndTime.Text, out endTime);

            if (!validStart || !validEnd)
            {
                lblError.Text = "Please enter both a start time and an end time.";
                return;
            }

            if (endTime <= startTime)
            {
                lblError.Text = "End time must be after start time.";
                return;
            }

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand(
                    "INSERT INTO TutorAvailability (TutorId, DayOfWeek, StartTime, EndTime, Venue) " +
                    "VALUES (@tutorId, @day, @start, @end, @venue)", conn);
                cmd.Parameters.AddWithValue("@tutorId", tutorId);
                cmd.Parameters.AddWithValue("@day", ddlDay.SelectedValue);
                cmd.Parameters.AddWithValue("@start", startTime);
                cmd.Parameters.AddWithValue("@end", endTime);
                cmd.Parameters.AddWithValue("@venue", txtVenue.Text.Trim());

                conn.Open();
                cmd.ExecuteNonQuery();
            }

            lblError.Text = "";
            txtVenue.Text = "";
            LoadTutorName(tutorId);
            BindAvailability(tutorId);
        }

        protected void gvAvailability_RowCommand(object sender, System.Web.UI.WebControls.GridViewCommandEventArgs e)
        {
            if (e.CommandName == "DeleteSlot")
            {
                int availabilityId = Convert.ToInt32(e.CommandArgument);
                int tutorId = Convert.ToInt32(hfTutorId.Value);

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    SqlCommand cmd = new SqlCommand("DELETE FROM TutorAvailability WHERE AvailabilityId = @id", conn);
                    cmd.Parameters.AddWithValue("@id", availabilityId);
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }

                LoadTutorName(tutorId);
                BindAvailability(tutorId);
            }
        }
    }
}