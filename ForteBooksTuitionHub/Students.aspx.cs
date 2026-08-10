using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace ForteBooksTuitionHub
{
    public partial class Students : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["ForteDb"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            AuthHelper.CheckAccess(this, new string[] { "Admin" });

            if (!IsPostBack)
            {
                BindStudents(null);
            }
        }

        private void BindStudents(string search)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "SELECT StudentId, FullName, Email, Phone, DateRegistered FROM Students";
                if (!string.IsNullOrWhiteSpace(search))
                {
                    sql += " WHERE FullName LIKE @search OR Email LIKE @search";
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

                gvStudents.DataSource = dt;
                gvStudents.DataBind();
            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            BindStudents(txtSearch.Text.Trim());
        }

        protected void gvStudents_RowCommand(object sender, System.Web.UI.WebControls.GridViewCommandEventArgs e)
        {
            if (e.CommandName == "DeleteStudent")
            {
                int studentId = Convert.ToInt32(e.CommandArgument);

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();

                    SqlCommand checkCmd = new SqlCommand(
                        "SELECT (SELECT COUNT(*) FROM Sessions WHERE StudentId=@id) + " +
                        "(SELECT COUNT(*) FROM BookRentals WHERE StudentId=@id) + " +
                        "(SELECT COUNT(*) FROM Payments WHERE StudentId=@id)", conn);
                    checkCmd.Parameters.AddWithValue("@id", studentId);
                    int linkedRecords = (int)checkCmd.ExecuteScalar();

                    if (linkedRecords > 0)
                    {
                        lblMessage.ForeColor = System.Drawing.Color.Red;
                        lblMessage.Text = "Cannot delete this student — they have existing sessions, rentals, or payment records.";
                        BindStudents(txtSearch.Text.Trim());
                        return;
                    }

                    SqlCommand cmd = new SqlCommand("DELETE FROM Students WHERE StudentId = @id", conn);
                    cmd.Parameters.AddWithValue("@id", studentId);
                    cmd.ExecuteNonQuery();
                }

                lblMessage.ForeColor = System.Drawing.Color.Green;
                lblMessage.Text = "Student deleted successfully.";
                BindStudents(txtSearch.Text.Trim());
            }
        }
    }
}