using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Text.RegularExpressions;

namespace ForteBooksTuitionHub
{
    public partial class PayFine : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["ForteDb"].ConnectionString;
        const decimal FinePerDay = 5.00m;

        protected void Page_Load(object sender, EventArgs e)
        {
            AuthHelper.CheckAccess(this, new string[] { "Student" });

            if (!IsPostBack)
            {
                LoadRental();
            }
        }

        private int RentalId
        {
            get
            {
                int id;
                int.TryParse(Request.QueryString["rentalId"], out id);
                return id;
            }
        }

        private void LoadRental()
        {
            if (Session["StudentId"] == null || RentalId == 0)
            {
                pnlNotFound.Visible = true;
                return;
            }

            int studentId = Convert.ToInt32(Session["StudentId"]);

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand(
                    @"SELECT b.Title, r.DueDate, r.ReturnDate, r.FinePaid
                      FROM BookRentals r
                      INNER JOIN Books b ON r.BookId = b.BookId
                      WHERE r.RentalId = @rentalId AND r.StudentId = @studentId", conn);
                cmd.Parameters.AddWithValue("@rentalId", RentalId);
                cmd.Parameters.AddWithValue("@studentId", studentId);

                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();

                if (!reader.Read())
                {
                    pnlNotFound.Visible = true;
                    return;
                }

                bool finePaid = Convert.ToBoolean(reader["FinePaid"]);
                DateTime dueDate = Convert.ToDateTime(reader["DueDate"]);
                DateTime compareDate = reader["ReturnDate"] != DBNull.Value ? Convert.ToDateTime(reader["ReturnDate"]) : DateTime.Today;

                int daysOverdue = compareDate.Date > dueDate.Date ? (compareDate.Date - dueDate.Date).Days : 0;

                if (finePaid || daysOverdue <= 0)
                {
                    pnlNotFound.Visible = true;
                    return;
                }

                decimal fineAmount = daysOverdue * FinePerDay;

                lblBookTitle.Text = reader["Title"].ToString();
                lblDueDate.Text = dueDate.ToString("yyyy-MM-dd");
                lblDaysOverdue.Text = daysOverdue.ToString();
                lblFineAmount.Text = fineAmount.ToString("N2");

                ViewState["FineAmount"] = fineAmount;
                ViewState["BookTitle"] = reader["Title"].ToString();

                pnlDetails.Visible = true;
            }
        }

        protected void ddlMethod_SelectedIndexChanged(object sender, EventArgs e)
        {
            pnlCardFields.Visible = ddlMethod.SelectedValue == "Card";
        }

        protected void btnReview_Click(object sender, EventArgs e)
        {
            lblError.Text = "";

            if (ddlMethod.SelectedValue == "Card")
            {
                string cardNumberDigitsOnly = txtCardNumber.Text.Replace(" ", "");

                if (string.IsNullOrWhiteSpace(txtCardName.Text))
                {
                    lblError.Text = "Please enter the cardholder name.";
                    return;
                }

                if (!Regex.IsMatch(cardNumberDigitsOnly, @"^\d{16}$"))
                {
                    lblError.Text = "Please enter a valid 16-digit card number.";
                    return;
                }

                if (!Regex.IsMatch(txtExpiry.Text.Trim(), @"^(0[1-9]|1[0-2])\/\d{2}$"))
                {
                    lblError.Text = "Please enter a valid expiry date in MM/YY format.";
                    return;
                }

                if (!Regex.IsMatch(txtCvv.Text.Trim(), @"^\d{3}$"))
                {
                    lblError.Text = "Please enter a valid 3-digit CVV.";
                    return;
                }

                string last4 = cardNumberDigitsOnly.Substring(cardNumberDigitsOnly.Length - 4);
                ViewState["MethodDisplay"] = "Card ending in " + last4;
            }
            else
            {
                ViewState["MethodDisplay"] = "EFT";
            }

            decimal fineAmount = (decimal)ViewState["FineAmount"];
            string bookTitle = (string)ViewState["BookTitle"];

            lblConfirmBook.Text = bookTitle;
            lblConfirmMethod.Text = ViewState["MethodDisplay"].ToString();
            lblConfirmAmount.Text = fineAmount.ToString("N2");

            pnlDetails.Visible = false;
            pnlConfirm.Visible = true;
        }

        protected void btnBack_Click(object sender, EventArgs e)
        {
            pnlConfirm.Visible = false;
            pnlDetails.Visible = true;
        }

        protected void btnConfirmPay_Click(object sender, EventArgs e)
        {
            if (Session["StudentId"] == null || ViewState["FineAmount"] == null)
            {
                pnlNotFound.Visible = true;
                pnlConfirm.Visible = false;
                return;
            }

            int studentId = Convert.ToInt32(Session["StudentId"]);
            decimal fineAmount = (decimal)ViewState["FineAmount"];
            string methodDisplay = ViewState["MethodDisplay"].ToString();
            string methodForDb = methodDisplay.StartsWith("Card") ? "Card" : "EFT";

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                SqlCommand insertPayment = new SqlCommand(
                    "INSERT INTO Payments (StudentId, Amount, PaymentDate, Method, Reason) " +
                    "VALUES (@studentId, @amount, @date, @method, 'Fine')", conn);
                insertPayment.Parameters.AddWithValue("@studentId", studentId);
                insertPayment.Parameters.AddWithValue("@amount", fineAmount);
                insertPayment.Parameters.AddWithValue("@date", DateTime.Today);
                insertPayment.Parameters.AddWithValue("@method", methodForDb);
                insertPayment.ExecuteNonQuery();

                SqlCommand markPaid = new SqlCommand(
                    "UPDATE BookRentals SET FinePaid = 1 WHERE RentalId = @id AND StudentId = @studentId", conn);
                markPaid.Parameters.AddWithValue("@id", RentalId);
                markPaid.Parameters.AddWithValue("@studentId", studentId);
                markPaid.ExecuteNonQuery();
            }

            string studentUsername = Session["Username"] != null ? Session["Username"].ToString() : "Student";
            ActivityLogHelper.Log(studentUsername, "FinePayment", "Overdue book fine of R" + fineAmount.ToString("N2") + " paid via " + methodDisplay + ".");

            lblSuccessAmount.Text = fineAmount.ToString("N2");
            pnlConfirm.Visible = false;
            pnlSuccess.Visible = true;
        }
    }
}