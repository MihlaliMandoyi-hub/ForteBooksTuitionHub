using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace ForteBooksTuitionHub
{
    public partial class RevenueReport : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["ForteDb"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            AuthHelper.CheckAccess(this, new string[] { "Admin" });

            if (!IsPostBack)
            {
                BindReport();
            }
        }

        private void BindReport()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                SqlCommand totalCmd = new SqlCommand("SELECT ISNULL(SUM(Amount), 0) FROM Payments", conn);
                decimal total = (decimal)totalCmd.ExecuteScalar();
                lblTotalRevenue.Text = total.ToString("N2");
            }

            gvByMonth.DataSource = GetByMonth();
            gvByMonth.DataBind();

            gvByMethod.DataSource = GetByMethod();
            gvByMethod.DataBind();

            gvByReason.DataSource = GetByReason();
            gvByReason.DataBind();
        }

        private DataTable GetByMonth()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = @"
                    SELECT FORMAT(PaymentDate, 'yyyy MMMM') AS MonthLabel,
                           COUNT(*) AS PaymentCount,
                           SUM(Amount) AS TotalAmount
                    FROM Payments
                    GROUP BY FORMAT(PaymentDate, 'yyyy MMMM'), YEAR(PaymentDate), MONTH(PaymentDate)
                    ORDER BY YEAR(PaymentDate) DESC, MONTH(PaymentDate) DESC";
                SqlCommand cmd = new SqlCommand(sql, conn);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);
                return dt;
            }
        }

        private DataTable GetByMethod()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = @"SELECT Method, COUNT(*) AS PaymentCount, SUM(Amount) AS TotalAmount
                               FROM Payments GROUP BY Method ORDER BY TotalAmount DESC";
                SqlCommand cmd = new SqlCommand(sql, conn);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);
                return dt;
            }
        }

        private DataTable GetByReason()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = @"SELECT Reason, COUNT(*) AS PaymentCount, SUM(Amount) AS TotalAmount
                               FROM Payments GROUP BY Reason ORDER BY TotalAmount DESC";
                SqlCommand cmd = new SqlCommand(sql, conn);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);
                return dt;
            }
        }

        protected void btnExportMonth_Click(object sender, EventArgs e)
        {
            CsvExportHelper.ExportDataTable(Response, GetByMonth(), "RevenueByMonth.csv");
        }

        protected void btnExportMethod_Click(object sender, EventArgs e)
        {
            CsvExportHelper.ExportDataTable(Response, GetByMethod(), "RevenueByMethod.csv");
        }

        protected void btnExportReason_Click(object sender, EventArgs e)
        {
            CsvExportHelper.ExportDataTable(Response, GetByReason(), "RevenueByReason.csv");
        }
    }
}