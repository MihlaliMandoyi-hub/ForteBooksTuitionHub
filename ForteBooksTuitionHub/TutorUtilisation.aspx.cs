using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace ForteBooksTuitionHub
{
    public partial class TutorUtilisation : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["ForteDb"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            AuthHelper.CheckAccess(this, new string[] { "Admin" });

            if (!IsPostBack)
            {
                gvUtilisation.DataSource = GetData();
                gvUtilisation.DataBind();
            }
        }

        private DataTable GetData()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = @"
                    SELECT t.FullName, t.Subject,
                           ISNULL(avail.AvailableHoursPerWeek, 0) AS AvailableHoursPerWeek,
                           ISNULL(sess.SessionsBooked, 0) AS SessionsBooked,
                           ISNULL(hrs.ApprovedHours, 0) AS ApprovedHours
                    FROM Tutors t
                    LEFT JOIN (
                        SELECT TutorId,
                               SUM(DATEDIFF(MINUTE, StartTime, EndTime)) / 60.0 AS AvailableHoursPerWeek
                        FROM TutorAvailability
                        GROUP BY TutorId
                    ) avail ON t.TutorId = avail.TutorId
                    LEFT JOIN (
                        SELECT TutorId, COUNT(*) AS SessionsBooked
                        FROM Sessions
                        WHERE Status <> 'Cancelled'
                        GROUP BY TutorId
                    ) sess ON t.TutorId = sess.TutorId
                    LEFT JOIN (
                        SELECT TutorId, SUM(HoursWorked) AS ApprovedHours
                        FROM Timesheets
                        WHERE Status = 'Approved'
                        GROUP BY TutorId
                    ) hrs ON t.TutorId = hrs.TutorId
                    ORDER BY t.FullName";

                SqlCommand cmd = new SqlCommand(sql, conn);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);
                return dt;
            }
        }

        protected void btnExport_Click(object sender, EventArgs e)
        {
            DataTable dt = GetData();
            CsvExportHelper.ExportDataTable(Response, dt, "TutorUtilisationReport.csv");
        }
    }
}