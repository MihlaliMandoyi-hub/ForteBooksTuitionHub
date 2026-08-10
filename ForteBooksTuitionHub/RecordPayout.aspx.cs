using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Globalization;

namespace ForteBooksTuitionHub
{
    public partial class RecordPayout : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["ForteDb"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            AuthHelper.CheckAccess(this, new string[] { "Admin" });

            if (!IsPostBack)
            {
                LoadTutor();
            }
        }

        private int TutorIdParam
        {
            get
            {
                int id;
                int.TryParse(Request.QueryString["tutorId"], out id);
                return id;
            }
        }

        private void LoadTutor()
        {
            if (TutorIdParam == 0)
            {
                pnlNotFound.Visible = true;
                return;
            }

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand nameCmd = new SqlCommand("SELECT FullName FROM Tutors WHERE TutorId = @id", conn);
                nameCmd.Parameters.AddWithValue("@id", TutorIdParam);
                conn.Open();
                object nameResult = nameCmd.ExecuteScalar();

                if (nameResult == null)
                {
                    pnlNotFound.Visible = true;
                    return;
                }

                lblTutorName.Text = nameResult.ToString();

                SqlCommand owedCmd = new SqlCommand(
                    @"SELECT (ISNULL((SELECT SUM(t.HourlyRate) FROM Sessions s INNER JOIN Tutors t ON s.TutorId=t.TutorId
                                      WHERE s.TutorId=@id AND s.Status='Completed'), 0) * 0.95)
                            - ISNULL((SELECT SUM(Amount) FROM TutorPayouts WHERE TutorId=@id), 0)", conn);
                owedCmd.Parameters.AddWithValue("@id", TutorIdParam);
                decimal stillOwed = (decimal)owedCmd.ExecuteScalar();

                lblStillOwed.Text = stillOwed.ToString("N2");
                txtAmount.Text = stillOwed > 0 ? stillOwed.ToString("0.00") : "0.00";

                pnlForm.Visible = true;
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            if (TutorIdParam == 0)
            {
                pnlForm.Visible = false;
                pnlNotFound.Visible = true;
                return;
            }

            decimal amount = Convert.ToDecimal(txtAmount.Text.Trim(), CultureInfo.InvariantCulture);

            if (amount <= 0)
            {
                lblError.Text = "Payout amount must be greater than zero.";
                return;
            }

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand(
                    "INSERT INTO TutorPayouts (TutorId, Amount, Notes) VALUES (@tutorId, @amount, @notes)", conn);
                cmd.Parameters.AddWithValue("@tutorId", TutorIdParam);
                cmd.Parameters.AddWithValue("@amount", amount);
                cmd.Parameters.AddWithValue("@notes", string.IsNullOrWhiteSpace(txtNotes.Text) ? (object)DBNull.Value : txtNotes.Text.Trim());
                conn.Open();
                cmd.ExecuteNonQuery();

                string adminUsername = Session["Username"] != null ? Session["Username"].ToString() : "Admin";
                ActivityLogHelper.Log(adminUsername, "Payout", "Payout of R" + amount.ToString("N2") + " recorded (TutorId " + TutorIdParam + ").");

                NotificationHelper.CreateForTutor(TutorIdParam, "You were paid out R" + amount.ToString("N2") + ".", "MyTutorProfile.aspx");
            }

            Response.Redirect("TutorPayouts.aspx?paid=1");
        }
    }
}