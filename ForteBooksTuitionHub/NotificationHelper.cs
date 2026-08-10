using System;
using System.Configuration;
using System.Data.SqlClient;

namespace ForteBooksTuitionHub
{
    public static class NotificationHelper
    {
        static string connStr = ConfigurationManager.ConnectionStrings["ForteDb"].ConnectionString;

        public static void CreateForUser(int userId, string message, string link)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand(
                    "INSERT INTO Notifications (UserId, Message, Link) VALUES (@userId, @message, @link)", conn);
                cmd.Parameters.AddWithValue("@userId", userId);
                cmd.Parameters.AddWithValue("@message", message);
                cmd.Parameters.AddWithValue("@link", (object)link ?? DBNull.Value);
                conn.Open();
                cmd.ExecuteNonQuery();
            }
        }

        public static void CreateForTutor(int tutorId, string message, string link)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                SqlCommand findUser = new SqlCommand("SELECT UserId FROM Users WHERE TutorId = @tutorId", conn);
                findUser.Parameters.AddWithValue("@tutorId", tutorId);
                object result = findUser.ExecuteScalar();
                if (result == null) return;
                int userId = Convert.ToInt32(result);

                SqlCommand cmd = new SqlCommand(
                    "INSERT INTO Notifications (UserId, Message, Link) VALUES (@userId, @message, @link)", conn);
                cmd.Parameters.AddWithValue("@userId", userId);
                cmd.Parameters.AddWithValue("@message", message);
                cmd.Parameters.AddWithValue("@link", (object)link ?? DBNull.Value);
                cmd.ExecuteNonQuery();
            }
        }

        public static void CreateForStudent(int studentId, string message, string link)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                SqlCommand findUser = new SqlCommand("SELECT UserId FROM Users WHERE StudentId = @studentId", conn);
                findUser.Parameters.AddWithValue("@studentId", studentId);
                object result = findUser.ExecuteScalar();
                if (result == null) return;
                int userId = Convert.ToInt32(result);

                SqlCommand cmd = new SqlCommand(
                    "INSERT INTO Notifications (UserId, Message, Link) VALUES (@userId, @message, @link)", conn);
                cmd.Parameters.AddWithValue("@userId", userId);
                cmd.Parameters.AddWithValue("@message", message);
                cmd.Parameters.AddWithValue("@link", (object)link ?? DBNull.Value);
                cmd.ExecuteNonQuery();
            }
        }
    }
}