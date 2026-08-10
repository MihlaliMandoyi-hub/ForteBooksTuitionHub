using System;
using System.Configuration;
using System.Data.SqlClient;

namespace ForteBooksTuitionHub
{
    public partial class BookAdd : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["ForteDb"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            AuthHelper.CheckAccess(this, new string[] { "Admin" });

            if (!IsPostBack)
            {
                if (Request.QueryString["id"] != null)
                {
                    int bookId = Convert.ToInt32(Request.QueryString["id"]);
                    LoadBook(bookId);
                    lblTitle.Text = "Edit Book";
                }
            }
        }

        private void LoadBook(int bookId)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand("SELECT * FROM Books WHERE BookId = @id", conn);
                cmd.Parameters.AddWithValue("@id", bookId);
                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();

                if (reader.Read())
                {
                    hfBookId.Value = reader["BookId"].ToString();
                    txtTitle.Text = reader["Title"].ToString();
                    txtAuthor.Text = reader["Author"].ToString();
                    txtTotalCopies.Text = reader["TotalCopies"].ToString();
                }
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            int bookId = Convert.ToInt32(hfBookId.Value);
            int totalCopies = Convert.ToInt32(txtTotalCopies.Text.Trim());

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                if (bookId == 0)
                {
                    // New book: AvailableCopies starts equal to TotalCopies
                    SqlCommand cmd = new SqlCommand(
                        "INSERT INTO Books (Title, Author, TotalCopies, AvailableCopies) " +
                        "VALUES (@title, @author, @total, @total)", conn);
                    cmd.Parameters.AddWithValue("@title", txtTitle.Text.Trim());
                    cmd.Parameters.AddWithValue("@author", txtAuthor.Text.Trim());
                    cmd.Parameters.AddWithValue("@total", totalCopies);
                    cmd.ExecuteNonQuery();
                }
                else
                {
                    // Editing: work out how many copies are currently out on loan
                    SqlCommand loanCmd = new SqlCommand(
                        "SELECT COUNT(*) FROM BookRentals WHERE BookId = @id AND ReturnDate IS NULL", conn);
                    loanCmd.Parameters.AddWithValue("@id", bookId);
                    int onLoan = (int)loanCmd.ExecuteScalar();

                    if (totalCopies < onLoan)
                    {
                        lblError.Text = "Total copies cannot be less than the " + onLoan + " currently on loan.";
                        return;
                    }

                    int newAvailable = totalCopies - onLoan;

                    SqlCommand cmd = new SqlCommand(
                        "UPDATE Books SET Title=@title, Author=@author, TotalCopies=@total, AvailableCopies=@available " +
                        "WHERE BookId=@id", conn);
                    cmd.Parameters.AddWithValue("@title", txtTitle.Text.Trim());
                    cmd.Parameters.AddWithValue("@author", txtAuthor.Text.Trim());
                    cmd.Parameters.AddWithValue("@total", totalCopies);
                    cmd.Parameters.AddWithValue("@available", newAvailable);
                    cmd.Parameters.AddWithValue("@id", bookId);
                    cmd.ExecuteNonQuery();
                }
            }

            Response.Redirect("Books.aspx");
        }
    }
}