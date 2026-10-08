using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace ForteBooksTuitionHub
{
    public partial class SessionMessages : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["ForteDb"].ConnectionString;

        public class MessageRow
        {
            public string SenderLabel { get; set; }
            public string MessageText { get; set; }
            public DateTime CreatedDate { get; set; }
            public string BubbleStyle { get; set; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            AuthHelper.CheckAccess(this, new string[] { "Admin", "Tutor", "Student" });

            if (!IsPostBack)
            {
                LoadSession();
            }
        }

        private int SessionIdParam
        {
            get
            {
                int id;
                int.TryParse(Request.QueryString["sessionId"], out id);
                return id;
            }
        }

        private bool HasAccess(SqlConnection conn, out int studentId, out int tutorId, out string studentName, out string tutorName, out string sessionInfo, out string venue)
        {
            studentId = 0; tutorId = 0; studentName = ""; tutorName = ""; sessionInfo = ""; venue = "";

            SqlCommand cmd = new SqlCommand(
                @"SELECT s.StudentId, s.TutorId, st.FullName AS StudentName, t.FullName AS TutorName,
                         s.SessionDate, s.StartTime, s.EndTime, ISNULL(s.Venue, 'Not specified') AS Venue
                  FROM Sessions s
                  INNER JOIN Students st ON s.StudentId = st.StudentId
                  INNER JOIN Tutors t ON s.TutorId = t.TutorId
                  WHERE s.SessionId = @id", conn);
            cmd.Parameters.AddWithValue("@id", SessionIdParam);

            SqlDataReader reader = cmd.ExecuteReader();
            if (!reader.Read())
            {
                reader.Close();
                return false;
            }

            studentId = Convert.ToInt32(reader["StudentId"]);
            tutorId = Convert.ToInt32(reader["TutorId"]);
            studentName = reader["StudentName"].ToString();
            tutorName = reader["TutorName"].ToString();
            venue = reader["Venue"].ToString();

            DateTime sessionDate = Convert.ToDateTime(reader["SessionDate"]);
            TimeSpan startTime = (TimeSpan)reader["StartTime"];
            TimeSpan endTime = (TimeSpan)reader["EndTime"];
            sessionInfo = sessionDate.ToString("yyyy-MM-dd") + ", " + startTime.ToString(@"hh\:mm") + " - " + endTime.ToString(@"hh\:mm");
            reader.Close();

            string role = Session["Role"] != null ? Session["Role"].ToString() : "";

            if (role == "Admin") return true;
            if (role == "Student" && Session["StudentId"] != null && Convert.ToInt32(Session["StudentId"]) == studentId) return true;
            if (role == "Tutor" && Session["TutorId"] != null && Convert.ToInt32(Session["TutorId"]) == tutorId) return true;

            return false;
        }

        private void LoadSession()
        {
            if (SessionIdParam == 0)
            {
                pnlNotFound.Visible = true;
                return;
            }

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                int studentId, tutorId;
                string studentName, tutorName, sessionInfo, venue;

                if (!HasAccess(conn, out studentId, out tutorId, out studentName, out tutorName, out sessionInfo, out venue))
                {
                    pnlNotFound.Visible = true;
                    return;
                }

                lblStudentName.Text = studentName;
                lblTutorName.Text = tutorName;
                lblSessionInfo.Text = sessionInfo;
                lblVenue.Text = venue;

                LoadMessages(conn);
                MarkMessagesRead(conn);

                pnlThread.Visible = true;
            }
        }

        private void LoadMessages(SqlConnection conn)
        {
            SqlCommand cmd = new SqlCommand(
                "SELECT SenderRole, MessageText, CreatedDate FROM SessionMessages WHERE SessionId = @id ORDER BY CreatedDate ASC", conn);
            cmd.Parameters.AddWithValue("@id", SessionIdParam);

            SqlDataReader reader = cmd.ExecuteReader();
            var rows = new List<MessageRow>();

            string myRole = Session["Role"] != null ? Session["Role"].ToString() : "";

            while (reader.Read())
            {
                string senderRole = reader["SenderRole"].ToString();
                bool isMine = senderRole == myRole;

                string bubbleStyle = isMine
                    ? "background:var(--ufh-gold); color:var(--ufh-navy); margin-left:auto;"
                    : "background:var(--table-hover); color:var(--text-main);";

                rows.Add(new MessageRow
                {
                    SenderLabel = senderRole,
                    MessageText = System.Web.HttpUtility.HtmlEncode(reader["MessageText"].ToString()),
                    CreatedDate = Convert.ToDateTime(reader["CreatedDate"]),
                    BubbleStyle = bubbleStyle
                });
            }
            reader.Close();

            rptMessages.DataSource = rows;
            rptMessages.DataBind();

            lblNoMessages.Visible = rows.Count == 0;
        }

        private void MarkMessagesRead(SqlConnection conn)
        {
            if (Session["UserId"] == null) return;
            int userId = Convert.ToInt32(Session["UserId"]);

            SqlCommand cmd = new SqlCommand(
                "UPDATE SessionMessages SET IsRead = 1 WHERE SessionId = @id AND SenderUserId <> @userId", conn);
            cmd.Parameters.AddWithValue("@id", SessionIdParam);
            cmd.Parameters.AddWithValue("@userId", userId);
            cmd.ExecuteNonQuery();
        }

        protected void btnSend_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            if (Session["UserId"] == null)
            {
                pnlNotFound.Visible = true;
                pnlThread.Visible = false;
                return;
            }

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                int studentId, tutorId;
                string studentName, tutorName, sessionInfo, venue;

                if (!HasAccess(conn, out studentId, out tutorId, out studentName, out tutorName, out sessionInfo, out venue))
                {
                    pnlThread.Visible = false;
                    pnlNotFound.Visible = true;
                    return;
                }

                int userId = Convert.ToInt32(Session["UserId"]);
                string role = Session["Role"].ToString();
                string messageText = txtMessage.Text.Trim();

                SqlCommand insertCmd = new SqlCommand(
                    "INSERT INTO SessionMessages (SessionId, SenderUserId, SenderRole, MessageText) " +
                    "VALUES (@sessionId, @senderUserId, @senderRole, @messageText)", conn);
                insertCmd.Parameters.AddWithValue("@sessionId", SessionIdParam);
                insertCmd.Parameters.AddWithValue("@senderUserId", userId);
                insertCmd.Parameters.AddWithValue("@senderRole", role);
                insertCmd.Parameters.AddWithValue("@messageText", messageText);
                insertCmd.ExecuteNonQuery();

                string preview = messageText.Length > 60 ? messageText.Substring(0, 60) + "..." : messageText;
                string notifLink = "SessionMessages.aspx?sessionId=" + SessionIdParam;

                if (role == "Student")
                {
                    NotificationHelper.CreateForTutor(tutorId, "New message from " + studentName + ": \"" + preview + "\"", notifLink);
                }
                else if (role == "Tutor")
                {
                    NotificationHelper.CreateForStudent(studentId, "New message from " + tutorName + ": \"" + preview + "\"", notifLink);
                }
                else if (role == "Admin")
                {
                    NotificationHelper.CreateForStudent(studentId, "New message from Admin: \"" + preview + "\"", notifLink);
                    NotificationHelper.CreateForTutor(tutorId, "New message from Admin: \"" + preview + "\"", notifLink);
                }

                LoadMessages(conn);
                MarkMessagesRead(conn);
            }

            txtMessage.Text = "";
            lblStudentName.Text = lblStudentName.Text; // no-op, keeps header intact
            pnlThread.Visible = true;
        }
    }
}