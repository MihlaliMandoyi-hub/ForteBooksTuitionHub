using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace ForteBooksTuitionHub
{
    public partial class Notifications : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["ForteDb"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            AuthHelper.CheckAccess(this, new string[] { "Admin", "Tutor", "Student" });

            if (!IsPostBack)
            {
                BindNotifications();
            }
        }

        private int CurrentUserId
        {
            get { return Convert.ToInt32(Session["UserId"]); }
        }

        private void BindNotifications()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand(
                    "SELECT NotificationId, Message, Link, CreatedDate, IsRead FROM Notifications " +
                    "WHERE UserId = @userId ORDER BY CreatedDate DESC", conn);
                cmd.Parameters.AddWithValue("@userId", CurrentUserId);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvNotifications.DataSource = dt;
                gvNotifications.DataBind();
            }
        }

        protected void gvNotifications_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                DataRowView row = (DataRowView)e.Row.DataItem;
                Label lblStatus = (Label)e.Row.FindControl("lblStatus");
                bool isRead = Convert.ToBoolean(row["IsRead"]);

                lblStatus.Text = isRead ? "Read" : "New";
                lblStatus.ForeColor = isRead ? System.Drawing.Color.Gray : System.Drawing.Color.DarkOrange;
                lblStatus.Font.Bold = !isRead;
            }
        }

        protected void gvNotifications_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "ViewNotification")
            {
                int notificationId = Convert.ToInt32(e.CommandArgument);
                string link = "Default.aspx";

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();

                    SqlCommand getLink = new SqlCommand(
                        "SELECT Link FROM Notifications WHERE NotificationId = @id AND UserId = @userId", conn);
                    getLink.Parameters.AddWithValue("@id", notificationId);
                    getLink.Parameters.AddWithValue("@userId", CurrentUserId);
                    object result = getLink.ExecuteScalar();
                    if (result != null && result != DBNull.Value)
                    {
                        link = result.ToString();
                    }

                    SqlCommand markRead = new SqlCommand(
                        "UPDATE Notifications SET IsRead = 1 WHERE NotificationId = @id AND UserId = @userId", conn);
                    markRead.Parameters.AddWithValue("@id", notificationId);
                    markRead.Parameters.AddWithValue("@userId", CurrentUserId);
                    markRead.ExecuteNonQuery();
                }

                Response.Redirect(link);
            }
        }

        protected void btnMarkAllRead_Click(object sender, EventArgs e)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand("UPDATE Notifications SET IsRead = 1 WHERE UserId = @userId", conn);
                cmd.Parameters.AddWithValue("@userId", CurrentUserId);
                conn.Open();
                cmd.ExecuteNonQuery();
            }

            BindNotifications();
        }
    }
}