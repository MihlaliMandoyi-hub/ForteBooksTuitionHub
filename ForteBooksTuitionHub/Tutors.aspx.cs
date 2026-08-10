using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace ForteBooksTuitionHub
{
    public partial class Tutors : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["ForteDb"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            AuthHelper.CheckAccess(this, new string[] { "Admin" });

            if (!IsPostBack)
            {
                BindTutors(null);
            }
        }

        private void BindTutors(string search)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "SELECT TutorId, FullName, Email, Phone, Subject, HourlyRate FROM Tutors";
                if (!string.IsNullOrWhiteSpace(search))
                {
                    sql += " WHERE FullName LIKE @search OR Email LIKE @search OR Subject LIKE @search";
                }
                sql += " ORDER BY FullName";

                SqlCommand cmd = new SqlCommand(sql, conn);
                if (!string.IsNullOrWhiteSpace(search))
                {
                    cmd.Parameters.AddWithValue("@search", "%" + search + "%");
                }

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvTutors.DataSource = dt;
                gvTutors.DataBind();
            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            BindTutors(txtSearch.Text.Trim());
        }

        protected void gvTutors_RowCommand(object sender, System.Web.UI.WebControls.GridViewCommandEventArgs e)
        {
            if (e.CommandName == "DeleteTutor")
            {
                int tutorId = Convert.ToInt32(e.CommandArgument);

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();

                    // Prevent deleting a tutor who already has sessions or timesheets booked
                    SqlCommand checkCmd = new SqlCommand(
                        "SELECT (SELECT COUNT(*) FROM Sessions WHERE TutorId=@id) + " +
                        "(SELECT COUNT(*) FROM Timesheets WHERE TutorId=@id)", conn);
                    checkCmd.Parameters.AddWithValue("@id", tutorId);
                    int linkedRecords = (int)checkCmd.ExecuteScalar();

                    if (linkedRecords > 0)
                    {
                        lblMessage.ForeColor = System.Drawing.Color.Red;
                        lblMessage.Text = "Cannot delete this tutor — they have existing sessions or timesheets.";
                        BindTutors(txtSearch.Text.Trim());
                        return;
                    }

                    SqlCommand cmd = new SqlCommand("DELETE FROM Tutors WHERE TutorId = @id", conn);
                    cmd.Parameters.AddWithValue("@id", tutorId);
                    cmd.ExecuteNonQuery();
                }

                lblMessage.ForeColor = System.Drawing.Color.Green;
                lblMessage.Text = "Tutor deleted successfully.";
                BindTutors(txtSearch.Text.Trim());
            }
        }
    }
}