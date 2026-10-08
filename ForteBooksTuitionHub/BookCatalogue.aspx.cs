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
                BindBooks(null, "TitleAsc");
            }
        }

        private void BindBooks(string search, string sortOption)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "SELECT BookId, Title, Author, ISBN, YearPublished, Edition, AvailableCopies, TotalCopies FROM Books WHERE 1=1";

                if (!string.IsNullOrWhiteSpace(search))
                {
                    sql += " AND (Title LIKE @search OR Author LIKE @search OR ISBN LIKE @search)";
                }

                switch (sortOption)
                {
                    case "TitleDesc":
                        sql += " ORDER BY Title DESC";
                        break;
                    case "YearDesc":
                        sql += " ORDER BY YearPublished DESC, Title ASC";
                        break;
                    case "YearAsc":
                        sql += " ORDER BY YearPublished ASC, Title ASC";
                        break;
                    case "AvailDesc":
                        sql += " ORDER BY AvailableCopies DESC, Title ASC";
                        break;
                    default: // TitleAsc
                        sql += " ORDER BY Title ASC";
                        break;
                }

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

        protected void btnFilter_Click(object sender, EventArgs e)
        {
            BindBooks(txtSearch.Text.Trim(), ddlSort.SelectedValue);
        }

        protected void btnClear_Click(object sender, EventArgs e)
        {
            txtSearch.Text = "";
            ddlSort.SelectedValue = "TitleAsc";
            BindBooks(null, "TitleAsc");
        }

        protected void gvBooks_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                DataRowView row = (DataRowView)e.Row.DataItem;
                Button btnRent = (Button)e.Row.FindControl("btnRent");

                string role = Session["Role"] != null ? Session["Role"].ToString() : "";
                int availableCopies = Convert.ToInt32(row["AvailableCopies"]);

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
                BindBooks(txtSearch.Text.Trim(), ddlSort.SelectedValue);
                return;
            }

            int bookId = Convert.ToInt32(e.CommandArgument);
            int studentId = Convert.ToInt32(Session["StudentId"]);

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                SqlCommand duplicateCheck = new SqlCommand(
                    "SELECT COUNT(*) FROM BookRentals WHERE BookId = @bookId AND StudentId = @studentId AND ReturnDate IS NULL", conn);
                duplicateCheck.Parameters.AddWithValue("@bookId", bookId);
                duplicateCheck.Parameters.AddWithValue("@studentId", studentId);
                int alreadyHasOut = (int)duplicateCheck.ExecuteScalar();

                if (alreadyHasOut > 0)
                {
                    lblError.Text = "You already have a copy of this book out on loan.";
                    BindBooks(txtSearch.Text.Trim(), ddlSort.SelectedValue);
                    return;
                }

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
                    BindBooks(txtSearch.Text.Trim(), ddlSort.SelectedValue);
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

                string studentUsername = Session["Username"] != null ? Session["Username"].ToString() : "Student";
                ActivityLogHelper.Log(studentUsername, "BookIssued", "\"" + title + "\" self-rented by student (StudentId " + studentId + ").");

                lblMessage.Text = "\"" + title + "\" has been rented to you. Due back on " + dueDate.ToString("yyyy-MM-dd") + ".";
            }

            BindBooks(txtSearch.Text.Trim(), ddlSort.SelectedValue);
        }
    }
}