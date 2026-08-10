using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;

namespace ForteBooksTuitionHub
{
    public partial class PaymentAdd : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["ForteDb"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindStudents();
                txtPaymentDate.Text = DateTime.Today.ToString("yyyy-MM-dd");
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

        protected void ddlStudent_SelectedIndexChanged(object sender, EventArgs e)
        {
            int studentId = Convert.ToInt32(ddlStudent.SelectedValue);

            if (studentId == 0)
            {
                pnlBalance.Visible = false;
                return;
            }

            decimal balance = CalculateOutstandingBalance(studentId);
            lblBalance.Text = balance.ToString("N2");
            pnlBalance.Visible = true;
        }

        private decimal CalculateOutstandingBalance(int studentId)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand chargeCmd = new SqlCommand(
                    @"SELECT ISNULL(SUM(t.HourlyRate), 0)
                      FROM Sessions s
                      INNER JOIN Tutors t ON s.TutorId = t.TutorId
                      WHERE s.StudentId = @id AND s.Status <> 'Cancelled'", conn);
                chargeCmd.Parameters.AddWithValue("@id", studentId);
                conn.Open();
                decimal totalCharges = (decimal)chargeCmd.ExecuteScalar();

                SqlCommand paidCmd = new SqlCommand(
                    "SELECT ISNULL(SUM(Amount), 0) FROM Payments WHERE StudentId = @id", conn);
                paidCmd.Parameters.AddWithValue("@id", studentId);
                decimal totalPaid = (decimal)paidCmd.ExecuteScalar();

                return totalCharges - totalPaid;
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            int studentId = Convert.ToInt32(ddlStudent.SelectedValue);

            if (studentId == 0)
            {
                lblError.Text = "Please select a student.";
                return;
            }

            decimal amount = Convert.ToDecimal(txtAmount.Text.Trim(), CultureInfo.InvariantCulture);
            DateTime paymentDate = Convert.ToDateTime(txtPaymentDate.Text);
            string studentName = "";

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                SqlCommand cmd = new SqlCommand(
                    "INSERT INTO Payments (StudentId, Amount, PaymentDate, Method, Reason) " +
                    "VALUES (@studentId, @amount, @date, @method, @reason)", conn);
                cmd.Parameters.AddWithValue("@studentId", studentId);
                cmd.Parameters.AddWithValue("@amount", amount);
                cmd.Parameters.AddWithValue("@date", paymentDate);
                cmd.Parameters.AddWithValue("@method", ddlMethod.SelectedValue);
                cmd.Parameters.AddWithValue("@reason", ddlReason.SelectedValue);
                cmd.ExecuteNonQuery();

                SqlCommand nameCmd = new SqlCommand("SELECT FullName FROM Students WHERE StudentId = @id", conn);
                nameCmd.Parameters.AddWithValue("@id", studentId);
                object result = nameCmd.ExecuteScalar();
                studentName = result != null ? result.ToString() : "";

                string adminUsername = Session["Username"] != null ? Session["Username"].ToString() : "Admin";
                ActivityLogHelper.Log(adminUsername, "Payment", "Payment of R" + amount.ToString("N2") + " recorded (StudentId " + studentId + ", Reason: " + ddlReason.SelectedValue + ").");
            }

            lblConfirmStudent.Text = studentName;
            lblConfirmAmount.Text = amount.ToString("N2");
            lblConfirmMethod.Text = ddlMethod.SelectedValue;
            lblConfirmReason.Text = ddlReason.SelectedValue;
            lblConfirmDate.Text = paymentDate.ToString("yyyy-MM-dd");

            pnlForm.Visible = false;
            pnlConfirmation.Visible = true;
        }
    }
}