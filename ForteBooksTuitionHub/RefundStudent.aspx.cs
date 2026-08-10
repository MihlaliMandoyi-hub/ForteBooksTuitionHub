using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Globalization;

namespace ForteBooksTuitionHub
{
    public partial class RefundStudent : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["ForteDb"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            AuthHelper.CheckAccess(this, new string[] { "Admin" });

            if (!IsPostBack)
            {
                LoadStudent();
            }
        }

        private int StudentIdParam
        {
            get
            {
                int id;
                int.TryParse(Request.QueryString["studentId"], out id);
                return id;
            }
        }

        private decimal GetCreditOwed(SqlConnection conn, int studentId)
        {
            SqlCommand cmd = new SqlCommand(
                @"SELECT ISNULL((SELECT SUM(Amount) FROM Payments WHERE StudentId = @id), 0)
                        - ISNULL((SELECT SUM(t.HourlyRate) FROM Sessions s INNER JOIN Tutors t ON s.TutorId = t.TutorId
                                  WHERE s.StudentId = @id AND s.Status <> 'Cancelled'), 0)", conn);
            cmd.Parameters.AddWithValue("@id", studentId);
            decimal paidMinusCharges = (decimal)cmd.ExecuteScalar();
            // Positive here means the student has overpaid (credit owed to them)
            return paidMinusCharges;
        }

        private void LoadStudent()
        {
            if (StudentIdParam == 0)
            {
                pnlNotFound.Visible = true;
                return;
            }

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand nameCmd = new SqlCommand("SELECT FullName FROM Students WHERE StudentId = @id", conn);
                nameCmd.Parameters.AddWithValue("@id", StudentIdParam);
                conn.Open();
                object nameResult = nameCmd.ExecuteScalar();

                if (nameResult == null)
                {
                    pnlNotFound.Visible = true;
                    return;
                }

                decimal creditOwed = GetCreditOwed(conn, StudentIdParam);

                if (creditOwed <= 0)
                {
                    pnlNoCredit.Visible = true;
                    return;
                }

                lblStudentName.Text = nameResult.ToString();
                lblCreditOwed.Text = creditOwed.ToString("N2");
                txtAmount.Text = creditOwed.ToString("0.00");

                pnlForm.Visible = true;
            }
        }

        protected void btnRefund_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            if (StudentIdParam == 0)
            {
                pnlForm.Visible = false;
                pnlNotFound.Visible = true;
                return;
            }

            decimal refundAmount = Convert.ToDecimal(txtAmount.Text.Trim(), CultureInfo.InvariantCulture);

            if (refundAmount <= 0)
            {
                lblError.Text = "Refund amount must be greater than zero.";
                return;
            }

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                decimal creditOwed = GetCreditOwed(conn, StudentIdParam);

                if (refundAmount > creditOwed)
                {
                    lblError.Text = "Refund amount cannot exceed the credit owed (R" + creditOwed.ToString("N2") + ").";
                    return;
                }

                // Recorded as a negative Payment so it reduces TotalPaid, which reduces the credit owed
                SqlCommand insertCmd = new SqlCommand(
                    "INSERT INTO Payments (StudentId, Amount, PaymentDate, Method, Reason) " +
                    "VALUES (@studentId, @amount, @date, @method, 'Refund')", conn);
                insertCmd.Parameters.AddWithValue("@studentId", StudentIdParam);
                insertCmd.Parameters.AddWithValue("@amount", -refundAmount);
                insertCmd.Parameters.AddWithValue("@date", DateTime.Today);
                insertCmd.Parameters.AddWithValue("@method", ddlMethod.SelectedValue);
                insertCmd.ExecuteNonQuery();

                string adminUsername = Session["Username"] != null ? Session["Username"].ToString() : "Admin";
                string notesPart = string.IsNullOrWhiteSpace(txtNotes.Text) ? "" : " Notes: " + txtNotes.Text.Trim();
                ActivityLogHelper.Log(adminUsername, "Refund",
                    "Refund of R" + refundAmount.ToString("N2") + " paid to StudentId " + StudentIdParam + " via " + ddlMethod.SelectedValue + "." + notesPart);

                NotificationHelper.CreateForStudent(StudentIdParam,
                    "You were refunded R" + refundAmount.ToString("N2") + " by the centre.", "MyProfile.aspx");
            }

            Response.Redirect("OutstandingBalances.aspx?refunded=1");
        }
    }
}