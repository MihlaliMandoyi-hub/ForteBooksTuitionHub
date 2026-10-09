using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Web.UI.WebControls;

namespace ForteBooksTuitionHub
{
    public partial class MyRentals : System.Web.UI.Page
    {
        private readonly string connStr =
            ConfigurationManager.ConnectionStrings["ForteDb"].ConnectionString;

        private const decimal FinePerDay = 5.00m;

        protected void Page_Load(object sender, EventArgs e)
        {
            AuthHelper.CheckAccess(this, new string[] { "Student" });

            if (!IsPostBack)
            {
                BindRentals();
            }
        }

        private void BindRentals()
        {
            if (Session["StudentId"] == null)
            {
                return;
            }

            int studentId = Convert.ToInt32(Session["StudentId"]);

            using (SqlConnection conn = new SqlConnection(connStr))
            using (SqlCommand cmd = new SqlCommand(@"
                SELECT
                    r.RentalId,
                    b.Title,
                    b.Author,
                    b.ISBN,
                    b.Edition,
                    b.YearPublished,
                    r.IssueDate,
                    r.DueDate,
                    r.ReturnDate,
                    r.FinePaid
                FROM BookRentals r
                INNER JOIN Books b ON r.BookId = b.BookId
                WHERE r.StudentId = @studentId
                ORDER BY
                    CASE WHEN r.ReturnDate IS NULL THEN 0 ELSE 1 END,
                    r.DueDate ASC", conn))
            {
                cmd.Parameters.Add("@studentId", SqlDbType.Int).Value = studentId;

                using (SqlDataAdapter adapter = new SqlDataAdapter(cmd))
                {
                    DataTable table = new DataTable();
                    adapter.Fill(table);

                    gvMyRentals.DataSource = table;
                    gvMyRentals.DataBind();
                }
            }
        }

        protected string BookDetail(object value)
        {
            if (value == null || value == DBNull.Value ||
                string.IsNullOrWhiteSpace(Convert.ToString(value)))
            {
                return "Not listed";
            }

            return Convert.ToString(value).Trim();
        }

        protected string RentalState(object returnDate, object dueDate)
        {
            if (returnDate != null && returnDate != DBNull.Value)
            {
                return "returned";
            }

            return Convert.ToDateTime(dueDate).Date < DateTime.Today
                ? "overdue"
                : "loan";
        }

        protected string RentalReminder(object returnDate, object dueDate)
        {
            if (returnDate != null && returnDate != DBNull.Value)
            {
                return "Returned on " +
                    Convert.ToDateTime(returnDate).ToString("dd MMM yyyy");
            }

            int days = (Convert.ToDateTime(dueDate).Date - DateTime.Today).Days;

            if (days < 0)
            {
                int overdueDays = Math.Abs(days);

                return overdueDays + (overdueDays == 1 ? " day overdue" : " days overdue") +
                    " — please arrange a return.";
            }

            if (days == 0)
            {
                return "Due today — remember to return your book.";
            }

            return days + (days == 1 ? " day" : " days") +
                " until your return date.";
        }

        protected void gvMyRentals_RowDataBound(
            object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType != DataControlRowType.DataRow)
            {
                return;
            }

            DataRowView row = (DataRowView)e.Row.DataItem;

            Label lblStatus = (Label)e.Row.FindControl("lblStatus");
            Label lblFine = (Label)e.Row.FindControl("lblFine");
            HyperLink lnkPayFine =
                (HyperLink)e.Row.FindControl("lnkPayFine");

            int rentalId = Convert.ToInt32(row["RentalId"]);
            DateTime dueDate = Convert.ToDateTime(row["DueDate"]).Date;

            bool finePaid = row["FinePaid"] != DBNull.Value &&
                Convert.ToBoolean(row["FinePaid"]);

            int daysOverdue = 0;

            if (row["ReturnDate"] != DBNull.Value)
            {
                DateTime returnDate =
                    Convert.ToDateTime(row["ReturnDate"]).Date;

                lblStatus.Text = "Returned";

                if (returnDate > dueDate)
                {
                    daysOverdue = (returnDate - dueDate).Days;
                }
            }
            else if (dueDate < DateTime.Today)
            {
                lblStatus.Text = "Overdue";
                daysOverdue = (DateTime.Today - dueDate).Days;
            }
            else
            {
                lblStatus.Text = "On Loan";
            }

            decimal fineOwed = finePaid ? 0 : daysOverdue * FinePerDay;

            lnkPayFine.Visible = false;

            if (fineOwed > 0)
            {
                lblFine.Text = "R" + fineOwed.ToString("N2");
                lblFine.CssClass = "rental-fine-value fine-unpaid";

                lnkPayFine.NavigateUrl =
                    "PayFine.aspx?rentalId=" + rentalId;

                lnkPayFine.Visible = true;
            }
            else if (finePaid && daysOverdue > 0)
            {
                lblFine.Text = "Paid";
                lblFine.CssClass = "rental-fine-value fine-paid";
            }
            else
            {
                lblFine.Text = "R0.00";
                lblFine.CssClass = "rental-fine-value";
            }
        }

        protected void gvMyRentals_RowCommand(
            object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName != "ReturnBook")
            {
                return;
            }

            lblMessage.Text = "";

            int studentId;
            int rentalId;

            if (Convert.ToString(Session["Role"]) != "Student" ||
                !int.TryParse(Convert.ToString(Session["StudentId"]), out studentId))
            {
                ShowMessage("Please sign in as a student to return a book.", true);
                return;
            }

            if (!int.TryParse(Convert.ToString(e.CommandArgument), out rentalId))
            {
                ShowMessage("This rental could not be identified.", true);
                return;
            }

            bool returned = false;

            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();

                    using (SqlTransaction transaction = conn.BeginTransaction())
                    {
                        // Ownership and ReturnDate are checked in the update.
                        // A repeated return cannot restore another copy.
                        using (SqlCommand returnCmd = new SqlCommand(@"
                            UPDATE BookRentals
                            SET ReturnDate = @today
                            OUTPUT INSERTED.BookId
                            WHERE RentalId = @rentalId
                              AND StudentId = @studentId
                              AND ReturnDate IS NULL", conn, transaction))
                        {
                            returnCmd.Parameters.Add("@today", SqlDbType.DateTime)
                                .Value = DateTime.Today;

                            returnCmd.Parameters.Add("@rentalId", SqlDbType.Int)
                                .Value = rentalId;

                            returnCmd.Parameters.Add("@studentId", SqlDbType.Int)
                                .Value = studentId;

                            object bookId = returnCmd.ExecuteScalar();

                            if (bookId != null && bookId != DBNull.Value)
                            {
                                using (SqlCommand stockCmd = new SqlCommand(@"
                                    UPDATE Books
                                    SET AvailableCopies = AvailableCopies + 1
                                    WHERE BookId = @bookId", conn, transaction))
                                {
                                    stockCmd.Parameters.Add("@bookId", SqlDbType.Int)
                                        .Value = Convert.ToInt32(bookId);

                                    if (stockCmd.ExecuteNonQuery() != 1)
                                    {
                                        throw new InvalidOperationException(
                                            "The book stock could not be updated.");
                                    }
                                }

                                returned = true;
                            }
                        }

                        transaction.Commit();
                    }
                }
            }
            catch (Exception ex)
            {
                Trace.Warn("MyRentals", "Book return failed.", ex);

                ShowMessage(
                    "The return could not be saved. Please try again or contact the centre.",
                    true);

                return;
            }

            ShowMessage(
                returned
                    ? "Book returned successfully. Thank you! Any unpaid late fine remains payable."
                    : "This rental is already returned or is not available to your account.",
                !returned);

            BindRentals();
        }

        private void ShowMessage(string message, bool isError)
        {
            lblMessage.Text = message;
            lblMessage.CssClass = isError
                ? "my-books-message my-books-message-error"
                : "my-books-message";

            lblMessage.ForeColor = isError
                ? Color.FromArgb(165, 46, 37)
                : Color.FromArgb(27, 107, 58);
        }
    }
}