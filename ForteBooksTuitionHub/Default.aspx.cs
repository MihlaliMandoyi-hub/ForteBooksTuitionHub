using System;
using System.Configuration;
using System.Data.SqlClient;

namespace ForteBooksTuitionHub
{
    public partial class _Default : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["ForteDb"].ConnectionString;
        const decimal CommissionRate = 0.05m;

        protected void Page_Load(object sender, EventArgs e)
        {
            AuthHelper.CheckAccess(this, new string[] { "Admin", "Tutor", "Student" });

            if (!IsPostBack)
            {
                string role = Session["Role"] != null ? Session["Role"].ToString() : "";

                if (role == "Admin") LoadAdminDashboard();
                else if (role == "Tutor") LoadTutorDashboard();
                else if (role == "Student") LoadStudentDashboard();
            }
        }

        private void LoadAdminDashboard()
        {
            pnlAdminDashboard.Visible = true;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                lblStudentCount.Text = RunScalar(conn, "SELECT COUNT(*) FROM Students");
                lblTutorCount.Text = RunScalar(conn, "SELECT COUNT(*) FROM Tutors");
                lblSessionCount.Text = RunScalar(conn, "SELECT COUNT(*) FROM Sessions WHERE Status <> 'Cancelled'");
                lblOnLoanCount.Text = RunScalar(conn, "SELECT COUNT(*) FROM BookRentals WHERE ReturnDate IS NULL");
                lblOverdueCount.Text = RunScalar(conn, "SELECT COUNT(*) FROM BookRentals WHERE ReturnDate IS NULL AND DueDate < GETDATE()");
                lblPendingTimesheets.Text = RunScalar(conn, "SELECT COUNT(*) FROM Timesheets WHERE Status = 'Pending'");

                SqlCommand revCmd = new SqlCommand("SELECT ISNULL(SUM(Amount), 0) FROM Payments", conn);
                decimal revenue = (decimal)revCmd.ExecuteScalar();
                lblRevenue.Text = revenue.ToString("N2");

                SqlCommand grossCmd = new SqlCommand(
                    @"SELECT ISNULL(SUM(t.HourlyRate), 0)
                      FROM Sessions s INNER JOIN Tutors t ON s.TutorId = t.TutorId
                      WHERE s.Status = 'Completed'", conn);
                decimal totalTutorGross = (decimal)grossCmd.ExecuteScalar();
                decimal totalCommission = totalTutorGross * CommissionRate;
                lblCommissionEarned.Text = totalCommission.ToString("N2");

                SqlCommand owedCmd = new SqlCommand(
                    @"SELECT ISNULL(SUM(net.NetEarnings), 0) - ISNULL((SELECT SUM(Amount) FROM TutorPayouts), 0)
                      FROM (
                          SELECT s.TutorId, SUM(t.HourlyRate) * 0.95 AS NetEarnings
                          FROM Sessions s INNER JOIN Tutors t ON s.TutorId = t.TutorId
                          WHERE s.Status = 'Completed'
                          GROUP BY s.TutorId
                      ) net", conn);
                decimal owedToTutors = (decimal)owedCmd.ExecuteScalar();
                lblOwedToTutors.Text = owedToTutors.ToString("N2");

                SqlCommand pendingCmd = new SqlCommand("SELECT COUNT(*) FROM Users WHERE Status = 'Pending'", conn);
                int pendingCount = (int)pendingCmd.ExecuteScalar();
                if (pendingCount > 0)
                {
                    pnlPendingTutors.Visible = true;
                    lblPendingTutors.Text = pendingCount.ToString();
                }
            }
        }

        private void LoadTutorDashboard()
        {
            pnlTutorDashboard.Visible = true;

            if (Session["TutorId"] == null) return;
            int tutorId = Convert.ToInt32(Session["TutorId"]);

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                SqlCommand upcomingCmd = new SqlCommand(
                    "SELECT COUNT(*) FROM Sessions WHERE TutorId=@id AND Status='Booked' AND SessionDate >= @today", conn);
                upcomingCmd.Parameters.AddWithValue("@id", tutorId);
                upcomingCmd.Parameters.AddWithValue("@today", DateTime.Today);
                lblUpcomingSessions.Text = upcomingCmd.ExecuteScalar().ToString();

                SqlCommand pendingTsCmd = new SqlCommand(
                    "SELECT COUNT(*) FROM Timesheets WHERE TutorId=@id AND Status='Pending'", conn);
                pendingTsCmd.Parameters.AddWithValue("@id", tutorId);
                lblMyPendingTimesheets.Text = pendingTsCmd.ExecuteScalar().ToString();

                SqlCommand approvedHoursCmd = new SqlCommand(
                    "SELECT ISNULL(SUM(HoursWorked),0) FROM Timesheets WHERE TutorId=@id AND Status='Approved'", conn);
                approvedHoursCmd.Parameters.AddWithValue("@id", tutorId);
                decimal approvedHours = (decimal)approvedHoursCmd.ExecuteScalar();
                lblMyApprovedHours.Text = approvedHours.ToString("N1");

                SqlCommand rateCmd = new SqlCommand("SELECT HourlyRate FROM Tutors WHERE TutorId=@id", conn);
                rateCmd.Parameters.AddWithValue("@id", tutorId);
                decimal hourlyRate = Convert.ToDecimal(rateCmd.ExecuteScalar());

                SqlCommand completedCmd = new SqlCommand(
                    "SELECT COUNT(*) FROM Sessions WHERE TutorId=@id AND Status='Completed'", conn);
                completedCmd.Parameters.AddWithValue("@id", tutorId);
                int completedCount = (int)completedCmd.ExecuteScalar();

                decimal grossEarnings = completedCount * hourlyRate;
                decimal commission = grossEarnings * CommissionRate;
                decimal netEarnings = grossEarnings - commission;

                lblCompletedSessions.Text = completedCount.ToString();
                lblGrossEarnings.Text = grossEarnings.ToString("N2");
                lblCommissionDeducted.Text = commission.ToString("N2");
                lblNetEarnings.Text = netEarnings.ToString("N2");

                SqlCommand paidCmd = new SqlCommand("SELECT ISNULL(SUM(Amount), 0) FROM TutorPayouts WHERE TutorId = @id", conn);
                paidCmd.Parameters.AddWithValue("@id", tutorId);
                decimal paidOut = (decimal)paidCmd.ExecuteScalar();
                lblPaidOut.Text = paidOut.ToString("N2");
                lblStillOwed.Text = (netEarnings - paidOut).ToString("N2");

                SqlCommand ratingCmd = new SqlCommand(
                    "SELECT AVG(CAST(Rating AS DECIMAL(3,2))) FROM Sessions WHERE TutorId = @id AND Rating IS NOT NULL", conn);
                ratingCmd.Parameters.AddWithValue("@id", tutorId);
                object ratingResult = ratingCmd.ExecuteScalar();
                lblAvgRating.Text = ratingResult != DBNull.Value ? Convert.ToDecimal(ratingResult).ToString("N1") + " / 5" : "No ratings yet";
            }
        }

        private void LoadStudentDashboard()
        {
            pnlStudentDashboard.Visible = true;

            if (Session["StudentId"] == null) return;
            int studentId = Convert.ToInt32(Session["StudentId"]);

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                SqlCommand chargeCmd = new SqlCommand(
                    @"SELECT ISNULL(SUM(t.HourlyRate), 0)
                      FROM Sessions s INNER JOIN Tutors t ON s.TutorId = t.TutorId
                      WHERE s.StudentId = @id AND s.Status <> 'Cancelled'", conn);
                chargeCmd.Parameters.AddWithValue("@id", studentId);
                decimal totalCharges = (decimal)chargeCmd.ExecuteScalar();

                SqlCommand paidCmd = new SqlCommand("SELECT ISNULL(SUM(Amount),0) FROM Payments WHERE StudentId=@id", conn);
                paidCmd.Parameters.AddWithValue("@id", studentId);
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

                SqlCommand upcomingCmd = new SqlCommand(
                    "SELECT COUNT(*) FROM Sessions WHERE StudentId=@id AND Status='Booked' AND SessionDate >= @today", conn);
                upcomingCmd.Parameters.AddWithValue("@id", studentId);
                upcomingCmd.Parameters.AddWithValue("@today", DateTime.Today);
                lblStudentUpcomingSessions.Text = upcomingCmd.ExecuteScalar().ToString();

                SqlCommand onLoanCmd = new SqlCommand(
                    "SELECT COUNT(*) FROM BookRentals WHERE StudentId=@id AND ReturnDate IS NULL", conn);
                onLoanCmd.Parameters.AddWithValue("@id", studentId);
                lblMyBooksOnLoan.Text = onLoanCmd.ExecuteScalar().ToString();

                SqlCommand overdueCmd = new SqlCommand(
                    "SELECT COUNT(*) FROM BookRentals WHERE StudentId=@id AND ReturnDate IS NULL AND DueDate < GETDATE()", conn);
                overdueCmd.Parameters.AddWithValue("@id", studentId);
                int overdueCount = (int)overdueCmd.ExecuteScalar();
                lblMyOverdueBooks.Text = overdueCount.ToString();
                pnlMyOverdueAlert.Visible = overdueCount > 0;
            }
        }

        private string RunScalar(SqlConnection conn, string sql)
        {
            SqlCommand cmd = new SqlCommand(sql, conn);
            return cmd.ExecuteScalar().ToString();
        }
    }
}