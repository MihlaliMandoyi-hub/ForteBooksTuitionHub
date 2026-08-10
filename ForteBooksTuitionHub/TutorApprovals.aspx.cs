using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace ForteBooksTuitionHub
{
    public partial class TutorApprovals : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["ForteDb"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            AuthHelper.CheckAccess(this, new string[] { "Admin" });

            if (!IsPostBack)
            {
                BindPending();
                BindReviewed();
            }
        }

        private void BindPending()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = @"
                    SELECT u.UserId, t.FullName, t.Email, t.Phone, t.Subject, t.HourlyRate, u.Username
                    FROM Users u
                    INNER JOIN Tutors t ON u.TutorId = t.TutorId
                    WHERE u.Status = 'Pending'
                    ORDER BY t.FullName";

                SqlCommand cmd = new SqlCommand(sql, conn);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvPending.DataSource = dt;
                gvPending.DataBind();
            }
        }

        private void BindReviewed()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = @"
                    SELECT u.UserId, t.FullName, t.Email, t.Subject, u.Username, u.Status
                    FROM Users u
                    INNER JOIN Tutors t ON u.TutorId = t.TutorId
                    WHERE u.Status IN ('Active', 'Rejected') AND u.Role = 'Tutor'
                    ORDER BY t.FullName";

                SqlCommand cmd = new SqlCommand(sql, conn);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvReviewed.DataSource = dt;
                gvReviewed.DataBind();
            }
        }

        protected void gvPending_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            HandleDecision(e);
        }

        protected void gvReviewed_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            HandleDecision(e);
        }

        private void HandleDecision(GridViewCommandEventArgs e)
        {
            if (e.CommandName == "ApproveTutor" || e.CommandName == "RejectTutor")
            {
                int userId = Convert.ToInt32(e.CommandArgument);
                string newStatus = e.CommandName == "ApproveTutor" ? "Active" : "Rejected";

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    SqlCommand cmd = new SqlCommand("UPDATE Users SET Status = @status WHERE UserId = @id", conn);
                    cmd.Parameters.AddWithValue("@status", newStatus);
                    cmd.Parameters.AddWithValue("@id", userId);
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }

                string notifMessage = newStatus == "Active"
                    ? "Your tutor application has been approved. You can now log in and start using the system."
                    : "Your tutor application was not approved. Please contact the administrator for more information.";
                NotificationHelper.CreateForUser(userId, notifMessage, "Default.aspx");

                string adminUsername = Session["Username"] != null ? Session["Username"].ToString() : "Admin";
                ActivityLogHelper.Log(adminUsername, "TutorApproval", "Tutor application " + (newStatus == "Active" ? "approved" : "rejected") + " (UserId " + userId + ").");

                lblMessage.Text = newStatus == "Active"
                    ? "Tutor approved successfully. They can now log in."
                    : "Tutor application rejected.";

                BindPending();
                BindReviewed();
            }
        }

        protected void gvReviewed_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                DataRowView row = (DataRowView)e.Row.DataItem;
                Label lblStatus = (Label)e.Row.FindControl("lblStatus");
                if (lblStatus == null) return;

                string status = row["Status"].ToString();
                lblStatus.Text = status;
                lblStatus.ForeColor = status == "Active" ? System.Drawing.Color.Green : System.Drawing.Color.Red;
                lblStatus.Font.Bold = true;
            }
        }
    }
}