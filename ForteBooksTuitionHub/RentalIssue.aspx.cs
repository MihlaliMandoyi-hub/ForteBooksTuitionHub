using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace ForteBooksTuitionHub
{
    public partial class RentalIssue : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["ForteDb"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindBooks();
                BindStudents();
            }
        }

        private void BindBooks()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand(
                    "SELECT BookId, (Title + ' (' + CAST(AvailableCopies AS VARCHAR) + ' available)') AS DisplayText " +
                    "FROM Books WHERE AvailableCopies > 0 ORDER BY Title", conn);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);
                ddlBook.DataSource = dt;
                ddlBook.DataBind();
            }
        }

        private void BindStudents()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand("SELECT StudentId, FullName FROM Students ORDER BY FullName", conn);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);
                ddlStudent.DataSource = dt;
                ddlStudent.DataBind();
            }
        }

        protected void btnIssue_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            int bookId = Convert.ToInt32(ddlBook.SelectedValue);
            int studentId = Convert.ToInt32(ddlStudent.SelectedValue);

            if (bookId == 0 || studentId == 0)
            {
                lblError.Text = "Please select both a book and a student.";
                return;
            }

            int loanDays = Convert.ToInt32(txtLoanDays.Text.Trim());

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                SqlCommand checkCmd = new SqlCommand("SELECT AvailableCopies, Title FROM Books WHERE BookId = @id", conn);
                checkCmd.Parameters.AddWithValue("@id", bookId);
                SqlDataReader reader = checkCmd.ExecuteReader();
                int available = 0;
                string bookTitle = "";
                if (reader.Read())
                {
                    available = Convert.ToInt32(reader["AvailableCopies"]);
                    bookTitle = reader["Title"].ToString();
                }
                reader.Close();

                if (available <= 0)
                {
                    lblError.Text = "No copies of this book are currently available.";
                    return;
                }

                DateTime issueDate = DateTime.Today;
                DateTime dueDate = issueDate.AddDays(loanDays);

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

                string adminUsername = Session["Username"] != null ? Session["Username"].ToString() : "Admin";
                ActivityLogHelper.Log(adminUsername, "BookIssued", "\"" + bookTitle + "\" issued to student (StudentId " + studentId + ").");
            }

            Response.Redirect("BookRentals.aspx");
        }
    }
}