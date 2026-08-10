using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace ForteBooksTuitionHub
{
    public partial class Payments : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["ForteDb"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            AuthHelper.CheckAccess(this, new string[] { "Admin" });

            if (!IsPostBack)
            {
                BindPayments(null, null);
            }
        }

        private void BindPayments(DateTime? fromDate, DateTime? toDate)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = @"SELECT p.PaymentId, s.FullName AS StudentName, p.Amount,
                               p.PaymentDate, p.Method, p.Reason
                               FROM Payments p
                               INNER JOIN Students s ON p.StudentId = s.StudentId
                               WHERE 1=1";

                if (fromDate.HasValue) sql += " AND p.PaymentDate >= @fromDate";
                if (toDate.HasValue) sql += " AND p.PaymentDate <= @toDate";

                sql += " ORDER BY p.PaymentDate DESC";

                SqlCommand cmd = new SqlCommand(sql, conn);
                if (fromDate.HasValue) cmd.Parameters.AddWithValue("@fromDate", fromDate.Value.Date);
                if (toDate.HasValue) cmd.Parameters.AddWithValue("@toDate", toDate.Value.Date);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvPayments.DataSource = dt;
                gvPayments.DataBind();
            }
        }

        protected void btnFilter_Click(object sender, EventArgs e)
        {
            DateTime? fromDate = null;
            DateTime? toDate = null;

            DateTime parsed;
            if (DateTime.TryParse(txtFromDate.Text, out parsed)) fromDate = parsed;
            if (DateTime.TryParse(txtToDate.Text, out parsed)) toDate = parsed;

            BindPayments(fromDate, toDate);
        }

        protected void btnClear_Click(object sender, EventArgs e)
        {
            txtFromDate.Text = "";
            txtToDate.Text = "";
            BindPayments(null, null);
        }

        protected void gvPayments_RowCommand(object sender, System.Web.UI.WebControls.GridViewCommandEventArgs e)
        {
            if (e.CommandName == "DeletePayment")
            {
                int paymentId = Convert.ToInt32(e.CommandArgument);

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    SqlCommand cmd = new SqlCommand("DELETE FROM Payments WHERE PaymentId = @id", conn);
                    cmd.Parameters.AddWithValue("@id", paymentId);
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }

                lblMessage.Text = "Payment record deleted.";
                BindPayments(null, null);
            }
        }
    }
}