using System;
using System.Configuration;
using System.Data.SqlClient;

namespace ForteBooksTuitionHub
{
    public partial class MyProfile : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["ForteDb"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            AuthHelper.CheckAccess(this, new string[] { "Student" });

            if (Session["StudentId"] == null)
            {
                Response.Redirect("AccessDenied.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadProfile();
                LoadSummary();
            }
        }

        private int CurrentStudentId
        {
            get { return Convert.ToInt32(Session["StudentId"]); }
        }

        private void LoadProfile()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand("SELECT FullName, Email, Phone FROM Students WHERE StudentId = @id", conn);
                cmd.Parameters.AddWithValue("@id", CurrentStudentId);
                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();

                if (reader.Read())
                {
                    txtFullName.Text = reader["FullName"].ToString();
                    txtEmail.Text = reader["Email"].ToString();
                    txtPhone.Text = reader["Phone"].ToString();
                }
            }
        }

        private void LoadSummary()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                SqlCommand sessionsCmd = new SqlCommand(
                    "SELECT COUNT(*) FROM Sessions WHERE StudentId = @id AND Status <> 'Cancelled'", conn);
                sessionsCmd.Parameters.AddWithValue("@id", CurrentStudentId);
                lblTotalSessions.Text = sessionsCmd.ExecuteScalar().ToString();

                SqlCommand rentalsCmd = new SqlCommand(
                    "SELECT COUNT(*) FROM BookRentals WHERE StudentId = @id AND ReturnDate IS NULL", conn);
                rentalsCmd.Parameters.AddWithValue("@id", CurrentStudentId);
                lblBooksOnLoan.Text = rentalsCmd.ExecuteScalar().ToString();

                SqlCommand chargeCmd = new SqlCommand(
                    @"SELECT ISNULL(SUM(t.HourlyRate), 0)
                      FROM Sessions s
                      INNER JOIN Tutors t ON s.TutorId = t.TutorId
                      WHERE s.StudentId = @id AND s.Status <> 'Cancelled'", conn);
                chargeCmd.Parameters.AddWithValue("@id", CurrentStudentId);
                decimal totalCharges = (decimal)chargeCmd.ExecuteScalar();

                SqlCommand paidCmd = new SqlCommand("SELECT ISNULL(SUM(Amount), 0) FROM Payments WHERE StudentId = @id", conn);
                paidCmd.Parameters.AddWithValue("@id", CurrentStudentId);
                decimal totalPaid = (decimal)paidCmd.ExecuteScalar();

                decimal accountBalance = totalPaid - totalCharges;

                if (accountBalance > 0)
                {
                    lblBalanceAmount.Text = "+R" + accountBalance.ToString("N2");
                    lblBalanceMeaning.Text = "The centre owes you this amount in credit.";
                    pnlBalanceCard.CssClass = "balance-banner balance-credit";
                }
                else if (accountBalance < 0)
                {
                    lblBalanceAmount.Text = "-R" + Math.Abs(accountBalance).ToString("N2");
                    lblBalanceMeaning.Text = "You currently owe this amount to the centre.";
                    pnlBalanceCard.CssClass = "balance-banner balance-owing";
                }
                else
                {
                    lblBalanceAmount.Text = "R0.00";
                    lblBalanceMeaning.Text = "Your account is fully settled.";
                    pnlBalanceCard.CssClass = "balance-banner balance-settled";
                }
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                SqlCommand checkCmd = new SqlCommand(
                    "SELECT COUNT(*) FROM Students WHERE Email = @email AND StudentId <> @id", conn);
                checkCmd.Parameters.AddWithValue("@email", txtEmail.Text.Trim());
                checkCmd.Parameters.AddWithValue("@id", CurrentStudentId);
                int existing = (int)checkCmd.ExecuteScalar();

                if (existing > 0)
                {
                    lblError.Text = "Another student is already using this email address.";
                    lblMessage.Text = "";
                    return;
                }

                SqlCommand cmd = new SqlCommand(
                    "UPDATE Students SET FullName=@fullName, Email=@email, Phone=@phone WHERE StudentId=@id", conn);
                cmd.Parameters.AddWithValue("@fullName", txtFullName.Text.Trim());
                cmd.Parameters.AddWithValue("@email", txtEmail.Text.Trim());
                cmd.Parameters.AddWithValue("@phone", txtPhone.Text.Trim());
                cmd.Parameters.AddWithValue("@id", CurrentStudentId);
                cmd.ExecuteNonQuery();
            }

            lblError.Text = "";
            lblMessage.Text = "Profile updated successfully.";
        }
    }
}