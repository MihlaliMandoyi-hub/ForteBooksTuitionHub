using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace ForteBooksTuitionHub
{
    public partial class TutorPayouts : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["ForteDb"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            AuthHelper.CheckAccess(this, new string[] { "Admin" });

            if (Request.QueryString["paid"] == "1")
            {
                lblMessage.Text = "Payout recorded successfully.";
            }

            if (!IsPostBack)
            {
                BindStatus();
                BindHistory();
            }
        }

        private void BindStatus()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = @"
                    SELECT t.TutorId, t.FullName, t.Subject,
                           ISNULL(g.GrossEarnings, 0) AS GrossEarnings,
                           ISNULL(g.GrossEarnings, 0) * 0.05 AS Commission,
                           ISNULL(g.GrossEarnings, 0) * 0.95 AS NetEarnings,
                           ISNULL(p.PaidOut, 0) AS PaidOut,
                           (ISNULL(g.GrossEarnings, 0) * 0.95) - ISNULL(p.PaidOut, 0) AS StillOwed
                    FROM Tutors t
                    LEFT JOIN (
                        SELECT s.TutorId, SUM(t3.HourlyRate) AS GrossEarnings
                        FROM Sessions s
                        INNER JOIN Tutors t3 ON s.TutorId = t3.TutorId
                        WHERE s.Status = 'Completed'
                        GROUP BY s.TutorId
                    ) g ON t.TutorId = g.TutorId
                    LEFT JOIN (
                        SELECT TutorId, SUM(Amount) AS PaidOut FROM TutorPayouts GROUP BY TutorId
                    ) p ON t.TutorId = p.TutorId
                    ORDER BY StillOwed DESC";

                SqlCommand cmd = new SqlCommand(sql, conn);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvPayoutStatus.DataSource = dt;
                gvPayoutStatus.DataBind();
            }
        }

        private void BindHistory()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = @"
                    SELECT t.FullName AS TutorName, tp.Amount, tp.PayoutDate, tp.Notes
                    FROM TutorPayouts tp
                    INNER JOIN Tutors t ON tp.TutorId = t.TutorId
                    ORDER BY tp.PayoutDate DESC";

                SqlCommand cmd = new SqlCommand(sql, conn);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvHistory.DataSource = dt;
                gvHistory.DataBind();
            }
        }
    }
}