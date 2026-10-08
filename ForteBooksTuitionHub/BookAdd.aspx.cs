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
                    txtIsbn.Text = reader["ISBN"] != DBNull.Value ? reader["ISBN"].ToString() : "";
                    txtYear.Text = reader["YearPublished"] != DBNull.Value ? reader["YearPublished"].ToString() : "";
                    txtEdition.Text = reader["Edition"] != DBNull.Value ? reader["Edition"].ToString() : "";
                }
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            int bookId = Convert.ToInt32(hfBookId.Value);
            int totalCopies = Convert.ToInt32(txtTotalCopies.Text.Trim());

            string isbn = string.IsNullOrWhiteSpace(txtIsbn.Text) ? null : txtIsbn.Text.Trim();
            string edition = string.IsNullOrWhiteSpace(txtEdition.Text) ? null : txtEdition.Text.Trim();
            int? year = null;
            if (!string.IsNullOrWhiteSpace(txtYear.Text))
            {
                year = Convert.ToInt32(txtYear.Text.Trim());
            }

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                if (bookId == 0)
                {
                    SqlCommand cmd = new SqlCommand(
                        "INSERT INTO Books (Title, Author, TotalCopies, AvailableCopies, ISBN, YearPublished, Edition) " +
                        "VALUES (@title, @author, @total, @total, @isbn, @year, @edition)", conn);
                    cmd.Parameters.AddWithValue("@title", txtTitle.Text.Trim());
                    cmd.Parameters.AddWithValue("@author", txtAuthor.Text.Trim());
                    cmd.Parameters.AddWithValue("@total", totalCopies);
                    cmd.Parameters.AddWithValue("@isbn", (object)isbn ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@year", (object)year ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@edition", (object)edition ?? DBNull.Value);
                    cmd.ExecuteNonQuery();
                }
                else
                {
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
                        "UPDATE Books SET Title=@title, Author=@author, TotalCopies=@total, AvailableCopies=@available, " +
                        "ISBN=@isbn, YearPublished=@year, Edition=@edition WHERE BookId=@id", conn);
                    cmd.Parameters.AddWithValue("@title", txtTitle.Text.Trim());
                    cmd.Parameters.AddWithValue("@author", txtAuthor.Text.Trim());
                    cmd.Parameters.AddWithValue("@total", totalCopies);
                    cmd.Parameters.AddWithValue("@available", newAvailable);
                    cmd.Parameters.AddWithValue("@isbn", (object)isbn ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@year", (object)year ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@edition", (object)edition ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@id", bookId);
                    cmd.ExecuteNonQuery();
                }
            }

            Response.Redirect("Books.aspx");
        }
    }
}