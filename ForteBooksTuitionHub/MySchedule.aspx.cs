using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Text;

namespace ForteBooksTuitionHub
{
    public partial class MySchedule : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["ForteDb"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            AuthHelper.CheckAccess(this, new string[] { "Student", "Tutor" });

            if (!IsPostBack)
            {
                ViewState["WeekOffset"] = 0;
                RenderWeek();
            }
        }

        private DateTime GetStartOfWeek(int offsetWeeks)
        {
            DateTime today = DateTime.Today.AddDays(offsetWeeks * 7);
            int diff = (7 + (today.DayOfWeek - DayOfWeek.Monday)) % 7;
            return today.AddDays(-diff);
        }

        private void RenderWeek()
        {
            int offset = ViewState["WeekOffset"] != null ? (int)ViewState["WeekOffset"] : 0;
            DateTime weekStart = GetStartOfWeek(offset);
            DateTime weekEnd = weekStart.AddDays(6);

            lblWeekRange.Text = weekStart.ToString("dd MMM yyyy") + " - " + weekEnd.ToString("dd MMM yyyy");

            DataTable dt = LoadSessions(weekStart, weekEnd);

            StringBuilder html = new StringBuilder();

            for (int i = 0; i < 7; i++)
            {
                DateTime day = weekStart.AddDays(i);
                bool isToday = day.Date == DateTime.Today;

                html.Append("<div style='flex:1; min-width:150px; background:#fff; border-radius:10px; box-shadow:var(--shadow); overflow:hidden;");
                if (isToday) html.Append(" border:2px solid #FFC520;");
                html.Append("'>");

                html.Append("<div style='background:linear-gradient(135deg, #8ED1FC, #b3e2ff); color:#112A43; padding:10px; text-align:center; font-weight:600;'>");
                html.Append(day.ToString("ddd") + "<br/><span style='font-size:12px; font-weight:400;'>" + day.ToString("dd MMM") + "</span>");
                html.Append("</div>");

                html.Append("<div style='padding:10px; min-height:120px;'>");

                DataRow[] rows = dt.Select("SessionDate = #" + day.ToString("MM/dd/yyyy") + "#");

                if (rows.Length == 0)
                {
                    html.Append("<p style='font-size:12px; color:#B0B8C4; text-align:center; margin-top:20px;'><i class=\"fa-solid fa-mug-hot\"></i><br/>Free</p>");
                }
                else
                {
                    foreach (DataRow row in rows)
                    {
                        TimeSpan start = (TimeSpan)row["StartTime"];
                        TimeSpan end = (TimeSpan)row["EndTime"];
                        string otherParty = row["OtherPartyName"].ToString();
                        string status = row["Status"].ToString();

                        string badgeColor = status == "Completed" ? "#DFF5E4" : status == "Cancelled" ? "#FBE0DE" : "#FFF1D6";
                        string textColor = status == "Completed" ? "#1B7A3D" : status == "Cancelled" ? "#C0392B" : "#B8760A";

                        html.Append("<div style='background:" + badgeColor + "; color:" + textColor + "; border-radius:6px; padding:6px 8px; margin-bottom:6px; font-size:12px;'>");
                        html.Append("<i class=\"fa-solid fa-clock\"></i> " + start.ToString(@"hh\:mm") + " - " + end.ToString(@"hh\:mm") + "<br/>");
                        html.Append("<i class=\"fa-solid fa-user\"></i> " + otherParty + "<br/>");
                        html.Append("<strong>" + status + "</strong>");
                        html.Append("</div>");
                    }
                }

                html.Append("</div></div>");
            }

            litSchedule.Text = html.ToString();
        }

        private DataTable LoadSessions(DateTime weekStart, DateTime weekEnd)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string role = Session["Role"] != null ? Session["Role"].ToString() : "";
                bool isStudent = role == "Student" && Session["StudentId"] != null;

                string sql;
                SqlCommand cmd;

                if (isStudent)
                {
                    sql = @"SELECT s.SessionDate, s.StartTime, s.EndTime, s.Status, t.FullName AS OtherPartyName
                            FROM Sessions s
                            INNER JOIN Tutors t ON s.TutorId = t.TutorId
                            WHERE s.StudentId = @ownerId AND s.SessionDate BETWEEN @weekStart AND @weekEnd
                            ORDER BY s.SessionDate, s.StartTime";
                    cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.AddWithValue("@ownerId", Convert.ToInt32(Session["StudentId"]));
                }
                else
                {
                    sql = @"SELECT s.SessionDate, s.StartTime, s.EndTime, s.Status, st.FullName AS OtherPartyName
                            FROM Sessions s
                            INNER JOIN Students st ON s.StudentId = st.StudentId
                            WHERE s.TutorId = @ownerId AND s.SessionDate BETWEEN @weekStart AND @weekEnd
                            ORDER BY s.SessionDate, s.StartTime";
                    cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.AddWithValue("@ownerId", Convert.ToInt32(Session["TutorId"]));
                }

                cmd.Parameters.AddWithValue("@weekStart", weekStart.Date);
                cmd.Parameters.AddWithValue("@weekEnd", weekEnd.Date);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);
                return dt;
            }
        }

        protected void btnPrevWeek_Click(object sender, EventArgs e)
        {
            ViewState["WeekOffset"] = (int)ViewState["WeekOffset"] - 1;
            RenderWeek();
        }

        protected void btnNextWeek_Click(object sender, EventArgs e)
        {
            ViewState["WeekOffset"] = (int)ViewState["WeekOffset"] + 1;
            RenderWeek();
        }

        protected void btnThisWeek_Click(object sender, EventArgs e)
        {
            ViewState["WeekOffset"] = 0;
            RenderWeek();
        }
    }
}