using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace ForteBooksTuitionHub
{
    public partial class Timesheets : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["ForteDb"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            AuthHelper.CheckAccess(this, new string[] { "Admin", "Tutor" });

            if (!IsPostBack)
            {
                BindTimesheets(null, null);
            }
        }

        private void BindTimesheets(DateTime? fromDate, DateTime? toDate)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string role = Session["Role"] != null ? Session["Role"].ToString() : "";
                bool filterByTutor = role == "Tutor" && Session["TutorId"] != null;

                string sql = @"SELECT ts.TimesheetId, t.FullName AS TutorName, ts.WorkDate,
                               ts.HoursWorked, ts.Description, ts.Status
                               FROM Timesheets ts
                               INNER JOIN Tutors t ON ts.TutorId = t.TutorId
                               WHERE 1=1";

                if (filterByTutor)
                    sql += " AND ts.TutorId = @tutorId";
                if (fromDate.HasValue)
                    sql += " AND ts.WorkDate >= @fromDate";
                if (toDate.HasValue)
                    sql += " AND ts.WorkDate <= @toDate";

                sql += " ORDER BY CASE WHEN ts.Status = 'Pending' THEN 0 ELSE 1 END, ts.WorkDate DESC";

                SqlCommand cmd = new SqlCommand(sql, conn);
                if (filterByTutor)
                    cmd.Parameters.AddWithValue("@tutorId", Convert.ToInt32(Session["TutorId"]));
                if (fromDate.HasValue)
                    cmd.Parameters.AddWithValue("@fromDate", fromDate.Value.Date);
                if (toDate.HasValue)
                    cmd.Parameters.AddWithValue("@toDate", toDate.Value.Date);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvTimesheets.DataSource = dt;
                gvTimesheets.DataBind();
            }
        }

        protected void btnFilter_Click(object sender, EventArgs e)
        {
            DateTime? fromDate = null;
            DateTime? toDate = null;

            DateTime parsed;
            if (DateTime.TryParse(txtFromDate.Text, out parsed)) fromDate = parsed;
            if (DateTime.TryParse(txtToDate.Text, out parsed)) toDate = parsed;

            BindTimesheets(fromDate, toDate);
        }

        protected void btnClear_Click(object sender, EventArgs e)
        {
            txtFromDate.Text = "";
            txtToDate.Text = "";
            BindTimesheets(null, null);
        }

        protected void gvTimesheets_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                DataRowView row = (DataRowView)e.Row.DataItem;
                Label lblStatus = (Label)e.Row.FindControl("lblStatus");
                string status = row["Status"].ToString();

                lblStatus.Text = status;

                if (status == "Approved")
                    lblStatus.ForeColor = System.Drawing.Color.Green;
                else if (status == "Rejected")
                    lblStatus.ForeColor = System.Drawing.Color.Red;
                else
                    lblStatus.ForeColor = System.Drawing.Color.DarkOrange;

                lblStatus.Font.Bold = true;

                string role = Session["Role"] != null ? Session["Role"].ToString() : "";
                bool isAdmin = role == "Admin";

                Button btnApprove = (Button)e.Row.FindControl("btnApprove");
                Button btnReject = (Button)e.Row.FindControl("btnReject");

                btnApprove.Visible = isAdmin && status == "Pending";
                btnReject.Visible = isAdmin && status == "Pending";
            }
        }

        protected void gvTimesheets_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            string role = Session["Role"] != null ? Session["Role"].ToString() : "";
            if (role != "Admin")
            {
                lblMessage.ForeColor = System.Drawing.Color.Red;
                lblMessage.Text = "Only an Administrator can approve or reject timesheets.";
                return;
            }

            if (e.CommandName == "ApproveTimesheet" || e.CommandName == "RejectTimesheet")
            {
                int timesheetId = Convert.ToInt32(e.CommandArgument);
                string newStatus = e.CommandName == "ApproveTimesheet" ? "Approved" : "Rejected";
                int tutorId = 0;
                DateTime workDate = DateTime.Today;

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();

                    SqlCommand getInfo = new SqlCommand("SELECT TutorId, WorkDate FROM Timesheets WHERE TimesheetId = @id", conn);
                    getInfo.Parameters.AddWithValue("@id", timesheetId);
                    SqlDataReader reader = getInfo.ExecuteReader();
                    if (reader.Read())
                    {
                        tutorId = Convert.ToInt32(reader["TutorId"]);
                        workDate = Convert.ToDateTime(reader["WorkDate"]);
                    }
                    reader.Close();

                    SqlCommand cmd = new SqlCommand(
                        "UPDATE Timesheets SET Status = @status WHERE TimesheetId = @id", conn);
                    cmd.Parameters.AddWithValue("@status", newStatus);
                    cmd.Parameters.AddWithValue("@id", timesheetId);
                    cmd.ExecuteNonQuery();
                }

                if (tutorId > 0)
                {
                    string notifMessage = "Your timesheet entry for " + workDate.ToString("yyyy-MM-dd") + " was " + newStatus.ToLower() + ".";
                    NotificationHelper.CreateForTutor(tutorId, notifMessage, "Timesheets.aspx");
                }

                lblMessage.ForeColor = System.Drawing.Color.Green;
                lblMessage.Text = "Timesheet marked as " + newStatus + ".";
                BindTimesheets(null, null);
            }
        }
    }
}