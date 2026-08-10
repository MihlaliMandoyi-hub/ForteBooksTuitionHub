using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace ForteBooksTuitionHub
{
    public partial class OverdueBooks : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["ForteDb"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            AuthHelper.CheckAccess(this, new string[] { "Admin" });

            if (!IsPostBack)
            {
                gvOverdue.DataSource = GetData();
                gvOverdue.DataBind();
            }
        }

        private DataTable GetData()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = @"SELECT b.Title, s.FullName AS StudentName, s.Phone, r.DueDate,
                               DATEDIFF(DAY, r.DueDate, GETDATE()) AS DaysOverdue
                               FROM BookRentals r
                               INNER JOIN Books b ON r.BookId = b.BookId
                               INNER JOIN Students s ON r.StudentId = s.StudentId
                               WHERE r.ReturnDate IS NULL AND r.DueDate < GETDATE()
                               ORDER BY r.DueDate ASC";

                SqlCommand cmd = new SqlCommand(sql, conn);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);
                return dt;
            }
        }

        protected void btnExport_Click(object sender, EventArgs e)
        {
            DataTable dt = GetData();
            CsvExportHelper.ExportDataTable(Response, dt, "OverdueBooksReport.csv");
        }
    }
}