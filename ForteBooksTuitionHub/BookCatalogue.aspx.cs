using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace ForteBooksTuitionHub
{
    public partial class BookCatalogue : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["ForteDb"].ConnectionString;
        const int LoanDays = 14;

        protected void Page_Load(object sender, EventArgs e)
        {
            AuthHelper.CheckAccess(this, new string[] { "Student", "Admin" });

            if (!IsPostBack)
            {
                BindBooks();
            }
        }

        private void BindBooks()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand(
                    "SELECT BookId, Title, Author, AvailableCopies, TotalCopies FROM Books ORDER BY Title", conn);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvBooks.DataSource = dt;
                gvBooks.DataBind();
            }
        }

        protected void gvBooks_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                DataRowView row = (DataRowView)e.Row.DataItem;
                Button btnRent = (Button)e.Row.FindControl("btnRent");

                string role = Session["Role"] != null ? Session["Role"].ToString() : "";
                int availableCopies = Convert.ToInt32(row["AvailableCopies"]);

                // Only Students can rent for themselves; Admin is just browsing here
                if (role != "Student")
                {
                    btnRent.Visible = false;
                    return;
                }

                if (availableCopies <= 0)
                {
                    btnRent.Text = "Unavailable";
                    btnRent.Enabled = false;
                }
            }
        }

        protected void gvBooks_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            lblMessage.Text = "";
            lblError.Text = "";

            if (e.CommandName != "RentBook") return;

            string role = Session["Role"] != null ? Session["Role"].ToString() : "";
            if (role != "Student" || Session["StudentId"] == null)
            {
                lblError.Text = "Only students can rent books from this page.";
                BindBooks();
                return;
            }

            int bookId = Convert.ToInt32(e.CommandArgument);
            int studentId = Convert.ToInt32(Session["StudentId"]);

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                // Business rule: can't rent the same book again while you already have an unreturned copy
                SqlCommand duplicateCheck = new SqlCommand(
                    "SELECT COUNT(*) FROM BookRentals WHERE BookId = @bookId AND StudentId = @studentId AND ReturnDate IS NULL", conn);
                duplicateCheck.Parameters.AddWithValue("@bookId", bookId);
                duplicateCheck.Parameters.AddWithValue("@studentId", studentId);
                int alreadyHasOut = (int)duplicateCheck.ExecuteScalar();

                if (alreadyHasOut > 0)
                {
                    lblError.Text = "You already have a copy of this book out on loan.";
                    BindBooks();
                    return;
                }

                // Re-check availability at the moment of renting (in case it changed)
                SqlCommand checkCmd = new SqlCommand("SELECT AvailableCopies, Title FROM Books WHERE BookId = @id", conn);
                checkCmd.Parameters.AddWithValue("@id", bookId);
                SqlDataReader reader = checkCmd.ExecuteReader();

                int available = 0;
                string title = "";
                if (reader.Read())
                {
                    available = Convert.ToInt32(reader["AvailableCopies"]);
                    title = reader["Title"].ToString();
                }
                reader.Close();

                if (available <= 0)
                {
                    lblError.Text = "Sorry, no copies of this book are currently available.";
                    BindBooks();
                    return;
                }

                DateTime issueDate = DateTime.Today;
                DateTime dueDate = issueDate.AddDays(LoanDays);

                SqlCommand insertCmd = new SqlCommand(
                    "INSERT INTO BookRentals (BookId, StudentId, IssueDate, DueDate) " +
                    "VALUES (@bookId, @studentId, @issueDate, @dueDate)", conn);
                insertCmd.Parameters.AddWithValue("@bookId", bookId);
                insertCmd.Parameters.AddWithValue("@studentId", studentId);
                insertCmd.Parameters.AddWithValue("@issueDate", issueDate);
                insertCmd.Parameters.AddWithValue("@dueDate", dueDate);
                insertCmd.ExecuteNonQuery();

                SqlCommand updateCmd = new SqlCommand(
                    "UPDATE Books SET AvailableCopies = AvailableCopies - 1 WHERE BookId = @id", conn);
                updateCmd.Parameters.AddWithValue("@id", bookId);
                updateCmd.ExecuteNonQuery();

                lblMessage.Text = "\"" + title + "\" has been rented to you. Due back on " + dueDate.ToString("yyyy-MM-dd") + ".";
                string studentUsername = Session["Username"] != null ? Session["Username"].ToString() : "Student";
                ActivityLogHelper.Log(studentUsername, "BookIssued", "\"" + title + "\" self-rented by student (StudentId " + studentId + ").");

            }

            BindBooks();
        }
    }
}