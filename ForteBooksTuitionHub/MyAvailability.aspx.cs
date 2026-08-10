using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace ForteBooksTuitionHub
{
    public partial class MyAvailability : System.Web.UI.Page
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
                BindAvailability();
            }
        }

        private int CurrentTutorId
        {
            get { return Convert.ToInt32(Session["TutorId"]); }
        }

        private void BindAvailability()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand(
                    "SELECT AvailabilityId, DayOfWeek, StartTime, EndTime FROM TutorAvailability " +
                    "WHERE TutorId = @tutorId ORDER BY " +
                    "CASE DayOfWeek WHEN 'Monday' THEN 1 WHEN 'Tuesday' THEN 2 WHEN 'Wednesday' THEN 3 " +
                    "WHEN 'Thursday' THEN 4 WHEN 'Friday' THEN 5 WHEN 'Saturday' THEN 6 ELSE 7 END, StartTime", conn);
                cmd.Parameters.AddWithValue("@tutorId", CurrentTutorId);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvAvailability.DataSource = dt;
                gvAvailability.DataBind();
            }
        }

        protected void btnAdd_Click(object sender, EventArgs e)
        {
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
                    "INSERT INTO TutorAvailability (TutorId, DayOfWeek, StartTime, EndTime) " +
                    "VALUES (@tutorId, @day, @start, @end)", conn);
                cmd.Parameters.AddWithValue("@tutorId", CurrentTutorId);
                cmd.Parameters.AddWithValue("@day", ddlDay.SelectedValue);
                cmd.Parameters.AddWithValue("@start", startTime);
                cmd.Parameters.AddWithValue("@end", endTime);

                conn.Open();
                cmd.ExecuteNonQuery();
            }

            lblError.Text = "";
            BindAvailability();
        }

        protected void gvAvailability_RowCommand(object sender, System.Web.UI.WebControls.GridViewCommandEventArgs e)
        {
            if (e.CommandName == "DeleteSlot")
            {
                int availabilityId = Convert.ToInt32(e.CommandArgument);

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    SqlCommand cmd = new SqlCommand(
                        "DELETE FROM TutorAvailability WHERE AvailabilityId = @id AND TutorId = @tutorId", conn);
                    cmd.Parameters.AddWithValue("@id", availabilityId);
                    cmd.Parameters.AddWithValue("@tutorId", CurrentTutorId);
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }

                BindAvailability();
            }
        }
    }
}