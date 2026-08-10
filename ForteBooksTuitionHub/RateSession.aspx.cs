using System;
using System.Configuration;
using System.Data.SqlClient;

namespace ForteBooksTuitionHub
{
    public partial class RateSession : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["ForteDb"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            AuthHelper.CheckAccess(this, new string[] { "Student" });

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

        private void LoadSession()
        {
            if (Session["StudentId"] == null || SessionIdParam == 0)
            {
                pnlNotFound.Visible = true;
                return;
            }

            int studentId = Convert.ToInt32(Session["StudentId"]);

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand(
                    @"SELECT s.Status, s.SessionDate, s.Rating, t.FullName AS TutorName
                      FROM Sessions s
                      INNER JOIN Tutors t ON s.TutorId = t.TutorId
                      WHERE s.SessionId = @id AND s.StudentId = @studentId", conn);
                cmd.Parameters.AddWithValue("@id", SessionIdParam);
                cmd.Parameters.AddWithValue("@studentId", studentId);

                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();

                if (!reader.Read())
                {
                    pnlNotFound.Visible = true;
                    return;
                }

                string status = reader["Status"].ToString();
                DateTime sessionDate = Convert.ToDateTime(reader["SessionDate"]);
                string tutorName = reader["TutorName"].ToString();
                bool alreadyRated = reader["Rating"] != DBNull.Value;
                reader.Close();

                if (status != "Completed" || alreadyRated)
                {
                    pnlNotFound.Visible = true;
                    return;
                }

                lblTutorName.Text = tutorName;
                lblSessionDate.Text = sessionDate.ToString("yyyy-MM-dd (dddd)");
                pnlForm.Visible = true;
            }
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            if (Session["StudentId"] == null || SessionIdParam == 0)
            {
                pnlForm.Visible = false;
                pnlNotFound.Visible = true;
                return;
            }

            int studentId = Convert.ToInt32(Session["StudentId"]);
            int rating = Convert.ToInt32(ddlRating.SelectedValue);
            string comment = txtComment.Text.Trim();

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                SqlCommand getTutor = new SqlCommand(
                    "SELECT TutorId FROM Sessions WHERE SessionId = @id AND StudentId = @studentId AND Rating IS NULL", conn);
                getTutor.Parameters.AddWithValue("@id", SessionIdParam);
                getTutor.Parameters.AddWithValue("@studentId", studentId);
                object tutorResult = getTutor.ExecuteScalar();

                if (tutorResult == null)
                {
                    pnlForm.Visible = false;
                    pnlNotFound.Visible = true;
                    return;
                }

                int tutorId = Convert.ToInt32(tutorResult);

                SqlCommand updateCmd = new SqlCommand(
                    "UPDATE Sessions SET Rating = @rating, RatingComment = @comment, RatingDate = @ratingDate " +
                    "WHERE SessionId = @sessionId AND StudentId = @studentId", conn);
                updateCmd.Parameters.AddWithValue("@rating", rating);
                updateCmd.Parameters.AddWithValue("@comment", string.IsNullOrWhiteSpace(comment) ? (object)DBNull.Value : comment);
                updateCmd.Parameters.AddWithValue("@ratingDate", DateTime.Now);
                updateCmd.Parameters.AddWithValue("@sessionId", SessionIdParam);
                updateCmd.Parameters.AddWithValue("@studentId", studentId);
                updateCmd.ExecuteNonQuery();

                string studentUsername = Session["Username"] != null ? Session["Username"].ToString() : "Student";
                ActivityLogHelper.Log(studentUsername, "Rating", "Student rated a session " + rating + "/5 (SessionId " + SessionIdParam + ").");

                NotificationHelper.CreateForTutor(tutorId, "You received a " + rating + "-star rating for a completed session.", "MyTutorProfile.aspx");
            }

            pnlForm.Visible = false;
            pnlSuccess.Visible = true;
        }
    }
}