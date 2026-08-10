using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace ForteBooksTuitionHub
{
    public partial class OutstandingBalances : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["ForteDb"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            AuthHelper.CheckAccess(this, new string[] { "Admin" });

            if (Request.QueryString["refunded"] == "1")
            {
                lblMessage.Text = "Refund recorded successfully.";
            }

            if (!IsPostBack)
            {
                BindBalances();
            }
        }

        private void BindBalances()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = @"
                    SELECT st.StudentId, st.FullName,
                           ISNULL(charges.TotalCharges, 0) AS TotalCharges,
                           ISNULL(paid.TotalPaid, 0) AS TotalPaid,
                           ISNULL(charges.TotalCharges, 0) - ISNULL(paid.TotalPaid, 0) AS Balance
                    FROM Students st
                    LEFT JOIN (
                        SELECT s.StudentId, SUM(t.HourlyRate) AS TotalCharges
                        FROM Sessions s
                        INNER JOIN Tutors t ON s.TutorId = t.TutorId
                        WHERE s.Status <> 'Cancelled'
                        GROUP BY s.StudentId
                    ) charges ON st.StudentId = charges.StudentId
                    LEFT JOIN (
                        SELECT StudentId, SUM(Amount) AS TotalPaid
                        FROM Payments
                        GROUP BY StudentId
                    ) paid ON st.StudentId = paid.StudentId
                    ORDER BY Balance ASC";

                SqlCommand cmd = new SqlCommand(sql, conn);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvBalances.DataSource = dt;
                gvBalances.DataBind();
            }
        }
    }
}