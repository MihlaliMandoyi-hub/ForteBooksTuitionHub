using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Text;
using System.Text.RegularExpressions;

namespace ForteBooksTuitionHub
{
    public partial class SessionAdd : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["ForteDb"].ConnectionString;
        const decimal DepositPercentage = 0.5m;

        protected void Page_Load(object sender, EventArgs e)
        {
            AuthHelper.CheckAccess(this, new string[] { "Admin", "Student" });

            if (!IsPostBack)
            {
                BindStudents();
                BindTutors();
            }
        }

        private void BindStudents()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string role = Session["Role"] != null ? Session["Role"].ToString() : "";
                bool isStudent = role == "Student" && Session["StudentId"] != null;

                string sql = isStudent
                    ? "SELECT StudentId, FullName FROM Students WHERE StudentId = @id"
                    : "SELECT StudentId, FullName FROM Students ORDER BY FullName";

                SqlCommand cmd = new SqlCommand(sql, conn);
                if (isStudent)
                {
                    cmd.Parameters.AddWithValue("@id", Convert.ToInt32(Session["StudentId"]));
                }

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                ddlStudent.DataSource = dt;
                ddlStudent.DataBind();

                if (isStudent)
                {
                    if (ddlStudent.Items.Count > 0 && ddlStudent.Items[0].Value == "0")
                    {
                        ddlStudent.Items.RemoveAt(0);
                    }
                    ddlStudent.Enabled = false;
                }
            }
        }

        private void BindTutors()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand("SELECT TutorId, FullName FROM Tutors ORDER BY FullName", conn);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);
                ddlTutor.DataSource = dt;
                ddlTutor.DataBind();
            }
        }

        protected void ddlTutor_SelectedIndexChanged(object sender, EventArgs e)
        {
            int tutorId = Convert.ToInt32(ddlTutor.SelectedValue);

            if (tutorId == 0)
            {
                pnlTutorAvailability.Visible = false;
                return;
            }

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                SqlCommand rateCmd = new SqlCommand("SELECT HourlyRate FROM Tutors WHERE TutorId = @id", conn);
                rateCmd.Parameters.AddWithValue("@id", tutorId);
                decimal hourlyRate = Convert.ToDecimal(rateCmd.ExecuteScalar());
                lblHourlyRatePreview.Text = hourlyRate.ToString("N2");

                SqlCommand ratingCmd = new SqlCommand(
                    "SELECT AVG(CAST(Rating AS DECIMAL(3,2))), COUNT(*) FROM Sessions WHERE TutorId = @id AND Rating IS NOT NULL", conn);
                ratingCmd.Parameters.AddWithValue("@id", tutorId);
                SqlDataReader ratingReader = ratingCmd.ExecuteReader();
                if (ratingReader.Read() && ratingReader[0] != DBNull.Value)
                {
                    decimal avgRating = Convert.ToDecimal(ratingReader[0]);
                    int ratingCount = Convert.ToInt32(ratingReader[1]);
                    int roundedStars = (int)Math.Round(avgRating);
                    lblTutorStars.Text = new string('\u2605', roundedStars) + new string('\u2606', 5 - roundedStars);
                    lblTutorRatingText.Text = avgRating.ToString("N1") + " / 5 (" + ratingCount + " review" + (ratingCount == 1 ? "" : "s") + ")";
                }
                else
                {
                    lblTutorStars.Text = "";
                    lblTutorRatingText.Text = "No ratings yet";
                }
                ratingReader.Close();

                SqlCommand cmd = new SqlCommand(
                    "SELECT DayOfWeek, StartTime, EndTime, Venue FROM TutorAvailability WHERE TutorId = @id " +
                    "ORDER BY CASE DayOfWeek WHEN 'Monday' THEN 1 WHEN 'Tuesday' THEN 2 WHEN 'Wednesday' THEN 3 " +
                    "WHEN 'Thursday' THEN 4 WHEN 'Friday' THEN 5 WHEN 'Saturday' THEN 6 ELSE 7 END, StartTime", conn);
                cmd.Parameters.AddWithValue("@id", tutorId);
                SqlDataReader reader = cmd.ExecuteReader();

                StringBuilder sb = new StringBuilder();
                bool any = false;
                while (reader.Read())
                {
                    any = true;
                    string venue = reader["Venue"] != DBNull.Value ? reader["Venue"].ToString() : "Venue to be confirmed";
                    sb.Append(reader["DayOfWeek"] + ": " + reader["StartTime"] + " - " + reader["EndTime"] +
                        " <i class=\"fa-solid fa-location-dot\"></i> " + venue + "<br/>");
                }

                lblAvailability.Text = any ? sb.ToString() : "No availability slots set for this tutor yet.";
                pnlTutorAvailability.Visible = true;
            }
        }

        protected void btnContinue_Click(object sender, EventArgs e)
        {
            lblError.Text = "";

            int studentId = Convert.ToInt32(ddlStudent.SelectedValue);
            int tutorId = Convert.ToInt32(ddlTutor.SelectedValue);

            if (studentId == 0 || tutorId == 0)
            {
                lblError.Text = "Please select both a student and a tutor.";
                return;
            }

            DateTime sessionDate;
            TimeSpan startTime, endTime;

            if (!DateTime.TryParse(txtSessionDate.Text, out sessionDate))
            {
                lblError.Text = "Please enter a valid session date.";
                return;
            }

            if (!TimeSpan.TryParse(txtStartTime.Text, out startTime) || !TimeSpan.TryParse(txtEndTime.Text, out endTime))
            {
                lblError.Text = "Please enter valid start and end times.";
                return;
            }

            if (endTime <= startTime)
            {
                lblError.Text = "End time must be after start time.";
                return;
            }

            if (sessionDate.Date < DateTime.Today)
            {
                lblError.Text = "Session date cannot be in the past.";
                return;
            }

            string studentName = "", tutorName = "", venue = "";
            decimal hourlyRate = 0;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                string dayOfWeek = sessionDate.DayOfWeek.ToString();

                SqlCommand availCmd = new SqlCommand(
                    "SELECT TOP 1 Venue FROM TutorAvailability WHERE TutorId = @tutorId AND DayOfWeek = @day " +
                    "AND StartTime <= @start AND EndTime >= @end", conn);
                availCmd.Parameters.AddWithValue("@tutorId", tutorId);
                availCmd.Parameters.AddWithValue("@day", dayOfWeek);
                availCmd.Parameters.AddWithValue("@start", startTime);
                availCmd.Parameters.AddWithValue("@end", endTime);
                object venueResult = availCmd.ExecuteScalar();

                if (venueResult == null)
                {
                    lblError.Text = "This time falls outside the tutor's published availability for " + dayOfWeek + ".";
                    return;
                }

                venue = venueResult == DBNull.Value ? "Venue to be confirmed" : venueResult.ToString();

                SqlCommand conflictCmd = new SqlCommand(
                    "SELECT COUNT(*) FROM Sessions WHERE TutorId = @tutorId AND SessionDate = @date " +
                    "AND Status <> 'Cancelled' AND StartTime < @end AND @start < EndTime", conn);
                conflictCmd.Parameters.AddWithValue("@tutorId", tutorId);
                conflictCmd.Parameters.AddWithValue("@date", sessionDate.Date);
                conflictCmd.Parameters.AddWithValue("@start", startTime);
                conflictCmd.Parameters.AddWithValue("@end", endTime);
                int conflicts = (int)conflictCmd.ExecuteScalar();

                if (conflicts > 0)
                {
                    lblError.Text = "This tutor already has a session booked that overlaps this time. Please choose another slot.";
                    return;
                }

                SqlCommand namesCmd = new SqlCommand(
                    "SELECT (SELECT FullName FROM Students WHERE StudentId = @studentId) AS StudentName, " +
                    "(SELECT FullName FROM Tutors WHERE TutorId = @tutorId) AS TutorName, " +
                    "(SELECT HourlyRate FROM Tutors WHERE TutorId = @tutorId) AS HourlyRate", conn);
                namesCmd.Parameters.AddWithValue("@studentId", studentId);
                namesCmd.Parameters.AddWithValue("@tutorId", tutorId);
                SqlDataReader reader = namesCmd.ExecuteReader();
                if (reader.Read())
                {
                    studentName = reader["StudentName"].ToString();
                    tutorName = reader["TutorName"].ToString();
                    hourlyRate = Convert.ToDecimal(reader["HourlyRate"]);
                }
            }

            ViewState["StudentId"] = studentId;
            ViewState["TutorId"] = tutorId;
            ViewState["StudentName"] = studentName;
            ViewState["TutorName"] = tutorName;
            ViewState["SessionDate"] = sessionDate;
            ViewState["StartTime"] = startTime;
            ViewState["EndTime"] = endTime;
            ViewState["HourlyRate"] = hourlyRate;
            ViewState["Venue"] = venue;

            decimal requiredDeposit = Math.Round(hourlyRate * DepositPercentage, 2);
            ViewState["RequiredDeposit"] = requiredDeposit;

            string role = Session["Role"] != null ? Session["Role"].ToString() : "";

            pnlForm.Visible = false;

            if (role == "Admin")
            {
                lblAdminStudentName.Text = studentName;
                lblAdminTutorName.Text = tutorName;
                lblAdminVenue.Text = venue;
                lblAdminSessionCost.Text = hourlyRate.ToString("N2");
                lblAdminRequiredDeposit.Text = requiredDeposit.ToString("N2");
                txtAdminAmount.Text = requiredDeposit.ToString("0.00");
                pnlAdminPayment.Visible = true;
            }
            else
            {
                lblPayTutorName.Text = tutorName;
                lblPaySessionDate.Text = sessionDate.ToString("yyyy-MM-dd (dddd)");
                lblPayVenue.Text = venue;
                lblSessionCost.Text = hourlyRate.ToString("N2");
                lblRequiredDeposit.Text = requiredDeposit.ToString("N2");
                txtDepositAmount.Text = requiredDeposit.ToString("0.00");
                pnlStudentPayment.Visible = true;
            }
        }

        protected void btnBackToDetails_Click(object sender, EventArgs e)
        {
            pnlStudentPayment.Visible = false;
            pnlAdminPayment.Visible = false;
            pnlConfirm.Visible = false;
            pnlForm.Visible = true;
        }

        protected void rblMethod_SelectedIndexChanged(object sender, EventArgs e)
        {
            bool isVoucher = rblMethod.SelectedValue == "Voucher";
            pnlVoucherFields.Visible = isVoucher;
            pnlCardFields.Visible = !isVoucher;
        }

        protected void btnReviewDeposit_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            lblPayError.Text = "";

            decimal requiredDeposit = (decimal)ViewState["RequiredDeposit"];
            decimal amount = Convert.ToDecimal(txtDepositAmount.Text.Trim(), CultureInfo.InvariantCulture);

            if (amount < requiredDeposit)
            {
                lblPayError.Text = "The minimum deposit for this session is R" + requiredDeposit.ToString("N2") + " (50% of the session cost).";
                return;
            }

            string methodDisplay;

            if (rblMethod.SelectedValue == "Voucher")
            {
                string code = txtVoucherCode.Text.Trim();

                if (!Regex.IsMatch(code, @"^\d{10,16}$"))
                {
                    lblPayError.Text = "Please enter a valid voucher code (10 to 16 digits).";
                    return;
                }

                string last4 = code.Substring(code.Length - 4);
                methodDisplay = ddlVoucherType.SelectedValue + " ending in " + last4;
                ViewState["MethodForDb"] = "Voucher";
            }
            else
            {
                string cardNumberDigitsOnly = txtCardNumber.Text.Replace(" ", "");

                if (string.IsNullOrWhiteSpace(txtCardName.Text))
                {
                    lblPayError.Text = "Please enter the cardholder name.";
                    return;
                }

                if (!Regex.IsMatch(cardNumberDigitsOnly, @"^\d{16}$"))
                {
                    lblPayError.Text = "Please enter a valid 16-digit card number.";
                    return;
                }

                if (!Regex.IsMatch(txtExpiry.Text.Trim(), @"^(0[1-9]|1[0-2])\/\d{2}$"))
                {
                    lblPayError.Text = "Please enter a valid expiry date in MM/YY format.";
                    return;
                }

                if (!Regex.IsMatch(txtCvv.Text.Trim(), @"^\d{3}$"))
                {
                    lblPayError.Text = "Please enter a valid 3-digit CVV.";
                    return;
                }

                string last4 = cardNumberDigitsOnly.Substring(cardNumberDigitsOnly.Length - 4);
                methodDisplay = "Card ending in " + last4;
                ViewState["MethodForDb"] = "Card";
            }

            ViewState["DepositAmount"] = amount;
            ViewState["MethodDisplay"] = methodDisplay;

            lblConfirmTutor2.Text = ViewState["TutorName"].ToString();
            lblConfirmAmount2.Text = amount.ToString("N2");
            lblConfirmMethod2.Text = methodDisplay;

            pnlStudentPayment.Visible = false;
            pnlConfirm.Visible = true;
        }

        protected void btnBackToPayment_Click(object sender, EventArgs e)
        {
            pnlConfirm.Visible = false;
            pnlStudentPayment.Visible = true;
        }

        protected void btnConfirmPay_Click(object sender, EventArgs e)
        {
            decimal amount = (decimal)ViewState["DepositAmount"];
            string methodForDb = ViewState["MethodForDb"].ToString();

            CreateSessionAndDeposit(amount, methodForDb);
        }

        protected void btnConfirmAdminBooking_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            lblAdminPayError.Text = "";

            decimal requiredDeposit = (decimal)ViewState["RequiredDeposit"];
            decimal amount = Convert.ToDecimal(txtAdminAmount.Text.Trim(), CultureInfo.InvariantCulture);

            if (amount < requiredDeposit)
            {
                lblAdminPayError.Text = "The minimum deposit for this session is R" + requiredDeposit.ToString("N2") + " (50% of the session cost).";
                return;
            }

            CreateSessionAndDeposit(amount, ddlAdminMethod.SelectedValue);
        }

        private void CreateSessionAndDeposit(decimal depositAmount, string method)
        {
            int studentId = (int)ViewState["StudentId"];
            int tutorId = (int)ViewState["TutorId"];
            DateTime sessionDate = (DateTime)ViewState["SessionDate"];
            TimeSpan startTime = (TimeSpan)ViewState["StartTime"];
            TimeSpan endTime = (TimeSpan)ViewState["EndTime"];
            string studentName = ViewState["StudentName"].ToString();
            string tutorName = ViewState["TutorName"].ToString();
            string venue = ViewState["Venue"].ToString();

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                SqlCommand conflictCmd = new SqlCommand(
                    "SELECT COUNT(*) FROM Sessions WHERE TutorId = @tutorId AND SessionDate = @date " +
                    "AND Status <> 'Cancelled' AND StartTime < @end AND @start < EndTime", conn);
                conflictCmd.Parameters.AddWithValue("@tutorId", tutorId);
                conflictCmd.Parameters.AddWithValue("@date", sessionDate.Date);
                conflictCmd.Parameters.AddWithValue("@start", startTime);
                conflictCmd.Parameters.AddWithValue("@end", endTime);
                int conflicts = (int)conflictCmd.ExecuteScalar();

                if (conflicts > 0)
                {
                    lblPayError.Text = "Sorry, this slot was just booked by someone else. Please choose another time.";
                    lblAdminPayError.Text = lblPayError.Text;
                    pnlConfirm.Visible = false;
                    pnlStudentPayment.Visible = false;
                    pnlAdminPayment.Visible = false;
                    pnlForm.Visible = true;
                    return;
                }

                SqlCommand insertCmd = new SqlCommand(
                    "INSERT INTO Sessions (StudentId, TutorId, SessionDate, StartTime, EndTime, Status, Venue) " +
                    "VALUES (@studentId, @tutorId, @date, @start, @end, 'Booked', @venue)", conn);
                insertCmd.Parameters.AddWithValue("@studentId", studentId);
                insertCmd.Parameters.AddWithValue("@tutorId", tutorId);
                insertCmd.Parameters.AddWithValue("@date", sessionDate.Date);
                insertCmd.Parameters.AddWithValue("@start", startTime);
                insertCmd.Parameters.AddWithValue("@end", endTime);
                insertCmd.Parameters.AddWithValue("@venue", venue);
                insertCmd.ExecuteNonQuery();

                SqlCommand paymentCmd = new SqlCommand(
                    "INSERT INTO Payments (StudentId, Amount, PaymentDate, Method, Reason) " +
                    "VALUES (@studentId, @amount, @date, @method, 'Session')", conn);
                paymentCmd.Parameters.AddWithValue("@studentId", studentId);
                paymentCmd.Parameters.AddWithValue("@amount", depositAmount);
                paymentCmd.Parameters.AddWithValue("@date", DateTime.Today);
                paymentCmd.Parameters.AddWithValue("@method", method);
                paymentCmd.ExecuteNonQuery();

                string actingUsername = Session["Username"] != null ? Session["Username"].ToString() : "";
                ActivityLogHelper.Log(actingUsername, "SessionBooked",
                    "Session booked with " + tutorName + " for " + studentName + " at " + venue + "; deposit of R" + depositAmount.ToString("N2") + " paid via " + method + ".");
            }

            lblConfirmStudent.Text = studentName;
            lblConfirmTutor.Text = tutorName;
            lblConfirmDate.Text = sessionDate.ToString("yyyy-MM-dd (dddd)");
            lblConfirmTime.Text = startTime.ToString(@"hh\:mm") + " - " + endTime.ToString(@"hh\:mm");
            lblConfirmVenue.Text = venue;
            lblConfirmDeposit.Text = depositAmount.ToString("N2");

            pnlConfirm.Visible = false;
            pnlStudentPayment.Visible = false;
            pnlAdminPayment.Visible = false;
            pnlConfirmation.Visible = true;
        }
    }
}