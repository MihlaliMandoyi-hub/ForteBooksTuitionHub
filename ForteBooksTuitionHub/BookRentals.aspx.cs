using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace ForteBooksTuitionHub
{
    public partial class BookRentals : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["ForteDb"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            AuthHelper.CheckAccess(this, new string[] { "Admin" });

            if (!IsPostBack)
            {
                BindRentals();
            }
        }

        private void BindRentals()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = @"SELECT r.RentalId, b.Title, s.FullName AS StudentName,
                       r.IssueDate, r.DueDate, r.ReturnDate
                       FROM BookRentals r
                       INNER JOIN Books b ON r.BookId = b.BookId
                       INNER JOIN Students s ON r.StudentId = s.StudentId
                       ORDER BY CASE WHEN r.ReturnDate IS NULL THEN 0 ELSE 1 END, r.DueDate ASC";

                SqlCommand cmd = new SqlCommand(sql, conn);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvRentals.DataSource = dt;
                gvRentals.DataBind();
            }
        }

        protected void gvRentals_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                DataRowView row = (DataRowView)e.Row.DataItem;
                Label lblStatus = (Label)e.Row.FindControl("lblStatus");

                if (row["ReturnDate"] != DBNull.Value)
                {
                    lblStatus.Text = "Returned";
                    lblStatus.ForeColor = System.Drawing.Color.Green;
                }
                else
                {
                    DateTime dueDate = Convert.ToDateTime(row["DueDate"]);
                    if (dueDate < DateTime.Today)
                    {
                        lblStatus.Text = "OVERDUE";
                        lblStatus.ForeColor = System.Drawing.Color.Red;
                        lblStatus.Font.Bold = true;
                    }
                    else
                    {
                        lblStatus.Text = "On Loan";
                        lblStatus.ForeColor = System.Drawing.Color.Black;
                    }
                }
            }
        }

        protected void gvRentals_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "ReturnBook")
            {
                int rentalId = Convert.ToInt32(e.CommandArgument);

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();

                    // Get the BookId and title for this rental so we can restore its available copy count and log it
                    SqlCommand getBookCmd = new SqlCommand(
                        "SELECT r.BookId, b.Title FROM BookRentals r INNER JOIN Books b ON r.BookId = b.BookId WHERE r.RentalId = @id", conn);
                    getBookCmd.Parameters.AddWithValue("@id", rentalId);
                    SqlDataReader bookReader = getBookCmd.ExecuteReader();
                    int bookId = 0;
                    string bookTitleForLog = "";
                    if (bookReader.Read())
                    {
                        bookId = Convert.ToInt32(bookReader["BookId"]);
                        bookTitleForLog = bookReader["Title"].ToString();
                    }
                    bookReader.Close();

                    // Mark the rental as returned
                    SqlCommand returnCmd = new SqlCommand(
                        "UPDATE BookRentals SET ReturnDate = @today WHERE RentalId = @id", conn);
                    returnCmd.Parameters.AddWithValue("@today", DateTime.Today);
                    returnCmd.Parameters.AddWithValue("@id", rentalId);
                    returnCmd.ExecuteNonQuery();

                    // Increase AvailableCopies for that book by 1
                    SqlCommand updateBookCmd = new SqlCommand(
                        "UPDATE Books SET AvailableCopies = AvailableCopies + 1 WHERE BookId = @bookId", conn);
                    updateBookCmd.Parameters.AddWithValue("@bookId", bookId);
                    updateBookCmd.ExecuteNonQuery();
                }

                //string adminUsername = Session["Username"] != null ? Session["Username"].ToString() : "Admin";
                //ActivityLogHelper.Log(adminUsername, "BookReturned", "\"" + bookTitleForLog + "\" marked as returned.");

                lblMessage.Text = "Book marked as returned.";
                BindRentals();
            }
        }
    }
}