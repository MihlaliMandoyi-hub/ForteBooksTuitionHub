using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace ForteBooksTuitionHub
{
    public partial class Books : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["ForteDb"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            AuthHelper.CheckAccess(this, new string[] { "Admin" });

            if (!IsPostBack)
            {
                BindBooks(null);
            }
        }

        private void BindBooks(string search)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "SELECT BookId, Title, Author, ISBN, YearPublished, Edition, TotalCopies, AvailableCopies FROM Books";
                if (!string.IsNullOrWhiteSpace(search))
                {
                    sql += " WHERE Title LIKE @search OR Author LIKE @search OR ISBN LIKE @search";
                }
                sql += " ORDER BY Title";

                SqlCommand cmd = new SqlCommand(sql, conn);
                if (!string.IsNullOrWhiteSpace(search))
                {
                    cmd.Parameters.AddWithValue("@search", "%" + search + "%");
                }

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvBooks.DataSource = dt;
                gvBooks.DataBind();
            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            BindBooks(txtSearch.Text.Trim());
        }

        protected void gvBooks_RowCommand(object sender, System.Web.UI.WebControls.GridViewCommandEventArgs e)
        {
            if (e.CommandName == "DeleteBook")
            {
                int bookId = Convert.ToInt32(e.CommandArgument);

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();

                    SqlCommand checkCmd = new SqlCommand(
                        "SELECT COUNT(*) FROM BookRentals WHERE BookId = @id AND ReturnDate IS NULL", conn);
                    checkCmd.Parameters.AddWithValue("@id", bookId);
                    int activeRentals = (int)checkCmd.ExecuteScalar();

                    if (activeRentals > 0)
                    {
                        lblMessage.ForeColor = System.Drawing.Color.Red;
                        lblMessage.Text = "Cannot delete — this book has active rentals out.";
                        BindBooks(txtSearch.Text.Trim());
                        return;
                    }

                    SqlCommand cmd = new SqlCommand("DELETE FROM Books WHERE BookId = @id", conn);
                    cmd.Parameters.AddWithValue("@id", bookId);
                    cmd.ExecuteNonQuery();
                }

                lblMessage.ForeColor = System.Drawing.Color.Green;
                lblMessage.Text = "Book deleted successfully.";
                BindBooks(txtSearch.Text.Trim());
            }
        }
    }
}