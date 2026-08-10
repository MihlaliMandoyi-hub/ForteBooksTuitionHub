using System;
using System.Configuration;
using System.Data.SqlClient;

namespace ForteBooksTuitionHub
{
    public static class ActivityLogHelper
    {
        static string connStr = ConfigurationManager.ConnectionStrings["ForteDb"].ConnectionString;

        public static void Log(string username, string actionType, string description)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand(
                    "INSERT INTO ActivityLog (Username, ActionType, Description) VALUES (@username, @actionType, @description)", conn);
                cmd.Parameters.AddWithValue("@username", (object)username ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@actionType", actionType);
                cmd.Parameters.AddWithValue("@description", description);
                conn.Open();
                cmd.ExecuteNonQuery();
            }
        }
    }
}