using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace ForteBooksTuitionHub
{
    public partial class Sessions : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["ForteDb"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            AuthHelper.CheckAccess(this, new string[] { "Admin", "Tutor", "Student" });

            string role = Session["Role"] != null ? Session["Role"].ToString() : "";
            lnkBookSession.Visible = (role == "Admin" || role == "Student");
            pnlFilters.Visible = role == "Admin";

            if (!IsPostBack)
            {
                BindSessions(null, null);
            }
        }

        private void BindSessions(DateTime? fromDate, DateTime? toDate)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string role = Session["Role"] != null ? Session["Role"].ToString() : "";

                string sql = @"SELECT s.SessionId, st.FullName AS StudentName, t.FullName AS TutorName,
                               s.SessionDate, s.StartTime, s.EndTime, s.Status, s.Rating AS MyRating
                               FROM Sessions s
                               INNER JOIN Students st ON s.StudentId = st.StudentId
                               INNER JOIN Tutors t ON s.TutorId = t.TutorId
                               WHERE 1=1";

                bool filterByStudent = role == "Student" && Session["StudentId"] != null;
                bool filterByTutor = role == "Tutor" && Session["TutorId"] != null;

                if (filterByStudent)
                    sql += " AND s.StudentId = @ownerId";
                else if (filterByTutor)
                    sql += " AND s.TutorId = @ownerId";

                if (fromDate.HasValue)
                    sql += " AND s.SessionDate >= @fromDate";
                if (toDate.HasValue)
                    sql += " AND s.SessionDate <= @toDate";

                sql += " ORDER BY s.SessionDate DESC, s.StartTime DESC";

                SqlCommand cmd = new SqlCommand(sql, conn);
                if (filterByStudent)
                    cmd.Parameters.AddWithValue("@ownerId", Convert.ToInt32(Session["StudentId"]));
                else if (filterByTutor)
                    cmd.Parameters.AddWithValue("@ownerId", Convert.ToInt32(Session["TutorId"]));

                if (fromDate.HasValue)
                    cmd.Parameters.AddWithValue("@fromDate", fromDate.Value.Date);
                if (toDate.HasValue)
                    cmd.Parameters.AddWithValue("@toDate", toDate.Value.Date);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvSessions.DataSource = dt;
                gvSessions.DataBind();
            }
        }

        protected void btnFilter_Click(object sender, EventArgs e)
        {
            DateTime? fromDate = null;
            DateTime? toDate = null;

            DateTime parsed;
            if (DateTime.TryParse(txtFromDate.Text, out parsed)) fromDate = parsed;
            if (DateTime.TryParse(txtToDate.Text, out parsed)) toDate = parsed;

            BindSessions(fromDate, toDate);
        }

        protected void btnClear_Click(object sender, EventArgs e)
        {
            txtFromDate.Text = "";
            txtToDate.Text = "";
            BindSessions(null, null);
        }

        protected void gvSessions_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                DataRowView row = (DataRowView)e.Row.DataItem;
                Button btnCancel = (Button)e.Row.FindControl("btnCancel");
                Button btnComplete = (Button)e.Row.FindControl("btnComplete");
                Label lblStars = (Label)e.Row.FindControl("lblStars");
                HyperLink lnkRate = (HyperLink)e.Row.FindControl("lnkRate");

                string role = Session["Role"] != null ? Session["Role"].ToString() : "";
                string status = row["Status"].ToString();
                DateTime sessionDate = Convert.ToDateTime(row["SessionDate"]);
                int sessionId = Convert.ToInt32(row["SessionId"]);

                btnCancel.Visible = (role == "Admin" || role == "Student") && status == "Booked";
                btnComplete.Visible = role == "Tutor" && status == "Booked" && sessionDate.Date <= DateTime.Today;

                bool hasRating = row["MyRating"] != DBNull.Value;

                if (hasRating)
                {
                    int rating = Convert.ToInt32(row["MyRating"]);
                    lblStars.Text = new string('\u2605', rating) + new string('\u2606', 5 - rating);
                }
                else if (role == "Student" && status == "Completed")
                {
                    lnkRate.NavigateUrl = "RateSession.aspx?sessionId=" + sessionId;
                    lnkRate.Visible = true;
                }
            }
        }

        protected void gvSessions_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            string role = Session["Role"] != null ? Session["Role"].ToString() : "";

            if (e.CommandName == "CancelSession")
            {
                if (role != "Admin" && role != "Student")
                {
                    lblMessage.ForeColor = System.Drawing.Color.Red;
                    lblMessage.Text = "You do not have permission to cancel sessions.";
                    return;
                }

                int sessionId = Convert.ToInt32(e.CommandArgument);

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();

                    if (role == "Student" && Session["StudentId"] != null)
                    {
                        SqlCommand ownerCheck = new SqlCommand(
                            "SELECT COUNT(*) FROM Sessions WHERE SessionId = @id AND StudentId = @studentId", conn);
                        ownerCheck.Parameters.AddWithValue("@id", sessionId);
                        ownerCheck.Parameters.AddWithValue("@studentId", Convert.ToInt32(Session["StudentId"]));
                        int owns = (int)ownerCheck.ExecuteScalar();

                        if (owns == 0)
                        {
                            lblMessage.ForeColor = System.Drawing.Color.Red;
                            lblMessage.Text = "You can only cancel your own sessions.";
                            return;
                        }
                    }

                    SqlCommand cmd = new SqlCommand(
                        "UPDATE Sessions SET Status = 'Cancelled' WHERE SessionId = @id", conn);
                    cmd.Parameters.AddWithValue("@id", sessionId);
                    cmd.ExecuteNonQuery();
                }

                lblMessage.ForeColor = System.Drawing.Color.Green;
                lblMessage.Text = "Session cancelled.";
                BindSessions(null, null);
            }
            else if (e.CommandName == "CompleteSession")
            {
                if (role != "Tutor" || Session["TutorId"] == null)
                {
                    lblMessage.ForeColor = System.Drawing.Color.Red;
                    lblMessage.Text = "You do not have permission to complete sessions.";
                    return;
                }

                int sessionId = Convert.ToInt32(e.CommandArgument);
                int tutorId = Convert.ToInt32(Session["TutorId"]);

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();

                    SqlCommand ownerCheck = new SqlCommand(
                        "SELECT COUNT(*) FROM Sessions WHERE SessionId = @id AND TutorId = @tutorId", conn);
                    ownerCheck.Parameters.AddWithValue("@id", sessionId);
                    ownerCheck.Parameters.AddWithValue("@tutorId", tutorId);
                    int owns = (int)ownerCheck.ExecuteScalar();

                    if (owns == 0)
                    {
                        lblMessage.ForeColor = System.Drawing.Color.Red;
                        lblMessage.Text = "You can only mark your own sessions as completed.";
                        return;
                    }

                    SqlCommand cmd = new SqlCommand(
                        "UPDATE Sessions SET Status = 'Completed' WHERE SessionId = @id", conn);
                    cmd.Parameters.AddWithValue("@id", sessionId);
                    cmd.ExecuteNonQuery();
                }

                lblMessage.ForeColor = System.Drawing.Color.Green;
                lblMessage.Text = "Session marked as completed.";
                BindSessions(null, null);
            }
        }
    }
}