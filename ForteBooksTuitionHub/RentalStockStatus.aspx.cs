using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace ForteBooksTuitionHub
{
    public partial class RentalStockStatus : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["ForteDb"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            AuthHelper.CheckAccess(this, new string[] { "Admin" });

            if (!IsPostBack)
            {
                gvStockStatus.DataSource = GetData();
                gvStockStatus.DataBind();
            }
        }

        private DataTable GetData()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = @"
                    SELECT b.Title, b.Author, b.TotalCopies, b.AvailableCopies,
                           ISNULL(loan.OnLoan, 0) AS OnLoan,
                           ISNULL(overdue.OverdueCount, 0) AS OverdueCount
                    FROM Books b
                    LEFT JOIN (
                        SELECT BookId, COUNT(*) AS OnLoan
                        FROM BookRentals
                        WHERE ReturnDate IS NULL
                        GROUP BY BookId
                    ) loan ON b.BookId = loan.BookId
                    LEFT JOIN (
                        SELECT BookId, COUNT(*) AS OverdueCount
                        FROM BookRentals
                        WHERE ReturnDate IS NULL AND DueDate < GETDATE()
                        GROUP BY BookId
                    ) overdue ON b.BookId = overdue.BookId
                    ORDER BY b.Title";

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
            CsvExportHelper.ExportDataTable(Response, dt, "RentalStockStatusReport.csv");
        }
    }
}