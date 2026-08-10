using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace ForteBooksTuitionHub
{
    public partial class ActivityLog : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["ForteDb"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            AuthHelper.CheckAccess(this, new string[] { "Admin" });

            if (!IsPostBack)
            {
                BindLog(null, null, "");
            }
        }

        private void BindLog(DateTime? fromDate, DateTime? toDate, string actionType)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "SELECT Username, ActionType, Description, CreatedDate FROM ActivityLog WHERE 1=1";

                if (fromDate.HasValue) sql += " AND CreatedDate >= @fromDate";
                if (toDate.HasValue) sql += " AND CreatedDate < @toDateExclusive";
                if (!string.IsNullOrEmpty(actionType)) sql += " AND ActionType = @actionType";

                sql += " ORDER BY CreatedDate DESC";

                SqlCommand cmd = new SqlCommand(sql, conn);
                if (fromDate.HasValue) cmd.Parameters.AddWithValue("@fromDate", fromDate.Value.Date);
                if (toDate.HasValue) cmd.Parameters.AddWithValue("@toDateExclusive", toDate.Value.Date.AddDays(1));
                if (!string.IsNullOrEmpty(actionType)) cmd.Parameters.AddWithValue("@actionType", actionType);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvLog.DataSource = dt;
                gvLog.DataBind();
            }
        }

        protected void btnFilter_Click(object sender, EventArgs e)
        {
            DateTime? fromDate = null;
            DateTime? toDate = null;

            DateTime parsed;
            if (DateTime.TryParse(txtFromDate.Text, out parsed)) fromDate = parsed;
            if (DateTime.TryParse(txtToDate.Text, out parsed)) toDate = parsed;

            BindLog(fromDate, toDate, ddlActionType.SelectedValue);
        }

        protected void btnClear_Click(object sender, EventArgs e)
        {
            txtFromDate.Text = "";
            txtToDate.Text = "";
            ddlActionType.SelectedIndex = 0;
            BindLog(null, null, "");
        }
    }
}