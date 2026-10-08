using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;

namespace ForteBooksTuitionHub
{
    public partial class SiteMaster : System.Web.UI.MasterPage
    {
        string connStr = ConfigurationManager.ConnectionStrings["ForteDb"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] != null)
            {
                GenerateDueSoonNotifications();
                GenerateSessionReminders();
                LoadUnreadCount();
            }
        }

        protected string NavClass(string pageFileName)
        {
            // Compare filenames WITHOUT extension, since Friendly URLs strips ".aspx" from the browser address bar
            string currentPage = System.IO.Path.GetFileNameWithoutExtension(Request.Path);
            string targetPage = System.IO.Path.GetFileNameWithoutExtension(pageFileName);
            return string.Equals(currentPage, targetPage, StringComparison.OrdinalIgnoreCase) ? "active" : "";
        }

        private void LoadUnreadCount()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM Notifications WHERE UserId = @userId AND IsRead = 0", conn);
                cmd.Parameters.AddWithValue("@userId", Convert.ToInt32(Session["UserId"]));
                conn.Open();
                int count = (int)cmd.ExecuteScalar();

                if (count > 0)
                {
                    lblNotificationCount.Text = count.ToString();
                    pnlNotificationBadge.Visible = true;
                }
            }
        }

        private void GenerateDueSoonNotifications()
        {
            string role = Session["Role"] != null ? Session["Role"].ToString() : "";
            if (role != "Student" || Session["StudentId"] == null) return;

            int studentId = Convert.ToInt32(Session["StudentId"]);

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                SqlCommand cmd = new SqlCommand(
                    @"SELECT r.RentalId, b.Title, r.DueDate
                      FROM BookRentals r
                      INNER JOIN Books b ON r.BookId = b.BookId
                      WHERE r.StudentId = @studentId AND r.ReturnDate IS NULL
                      AND r.DueSoonNotified = 0
                      AND DATEDIFF(DAY, GETDATE(), r.DueDate) BETWEEN 0 AND 2", conn);
                cmd.Parameters.AddWithValue("@studentId", studentId);

                SqlDataReader reader = cmd.ExecuteReader();
                var dueSoon = new List<Tuple<int, string, DateTime>>();
                while (reader.Read())
                {
                    dueSoon.Add(new Tuple<int, string, DateTime>(
                        Convert.ToInt32(reader["RentalId"]),
                        reader["Title"].ToString(),
                        Convert.ToDateTime(reader["DueDate"])));
                }
                reader.Close();

                foreach (var item in dueSoon)
                {
                    string message = "Your book \"" + item.Item2 + "\" is due on " + item.Item3.ToString("yyyy-MM-dd") + ".";
                    NotificationHelper.CreateForStudent(studentId, message, "MyRentals.aspx");

                    SqlCommand markCmd = new SqlCommand("UPDATE BookRentals SET DueSoonNotified = 1 WHERE RentalId = @id", conn);
                    markCmd.Parameters.AddWithValue("@id", item.Item1);
                    markCmd.ExecuteNonQuery();
                }
            }
        }

        private void GenerateSessionReminders()
        {
            string role = Session["Role"] != null ? Session["Role"].ToString() : "";
            bool isStudent = role == "Student" && Session["StudentId"] != null;
            bool isTutor = role == "Tutor" && Session["TutorId"] != null;

            if (!isStudent && !isTutor) return;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                string sql;
                SqlCommand cmd;

                if (isStudent)
                {
                    int studentId = Convert.ToInt32(Session["StudentId"]);
                    sql = @"SELECT s.SessionId, t.FullName AS OtherPartyName, s.SessionDate, s.StartTime
                            FROM Sessions s
                            INNER JOIN Tutors t ON s.TutorId = t.TutorId
                            WHERE s.StudentId = @ownerId AND s.Status = 'Booked' AND s.ReminderSent = 0
                            AND s.SessionDate = @tomorrow";
                    cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.AddWithValue("@ownerId", studentId);
                }
                else
                {
                    int tutorId = Convert.ToInt32(Session["TutorId"]);
                    sql = @"SELECT s.SessionId, st.FullName AS OtherPartyName, s.SessionDate, s.StartTime
                            FROM Sessions s
                            INNER JOIN Students st ON s.StudentId = st.StudentId
                            WHERE s.TutorId = @ownerId AND s.Status = 'Booked' AND s.ReminderSent = 0
                            AND s.SessionDate = @tomorrow";
                    cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.AddWithValue("@ownerId", tutorId);
                }

                cmd.Parameters.AddWithValue("@tomorrow", DateTime.Today.AddDays(1));

                SqlDataReader reader = cmd.ExecuteReader();
                var upcoming = new List<Tuple<int, string, TimeSpan>>();
                while (reader.Read())
                {
                    upcoming.Add(new Tuple<int, string, TimeSpan>(
                        Convert.ToInt32(reader["SessionId"]),
                        reader["OtherPartyName"].ToString(),
                        (TimeSpan)reader["StartTime"]));
                }
                reader.Close();

                foreach (var item in upcoming)
                {
                    string message = "You have a session tomorrow at " + item.Item3.ToString(@"hh\:mm") + " with " + item.Item2 + ".";

                    if (isStudent)
                        NotificationHelper.CreateForStudent(Convert.ToInt32(Session["StudentId"]), message, "MySchedule.aspx");
                    else
                        NotificationHelper.CreateForTutor(Convert.ToInt32(Session["TutorId"]), message, "MySchedule.aspx");

                    SqlCommand markCmd = new SqlCommand("UPDATE Sessions SET ReminderSent = 1 WHERE SessionId = @id", conn);
                    markCmd.Parameters.AddWithValue("@id", item.Item1);
                    markCmd.ExecuteNonQuery();
                }
            }
        }
    }
}