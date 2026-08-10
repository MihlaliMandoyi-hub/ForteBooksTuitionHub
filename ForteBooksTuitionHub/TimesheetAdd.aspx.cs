using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;

namespace ForteBooksTuitionHub
{
    public partial class TimesheetAdd : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["ForteDb"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            AuthHelper.CheckAccess(this, new string[] { "Admin", "Tutor" });

            if (!IsPostBack)
            {
                BindTutors();
                txtWorkDate.Text = DateTime.Today.ToString("yyyy-MM-dd");
            }
        }

        private void BindTutors()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string role = Session["Role"] != null ? Session["Role"].ToString() : "";
                bool isTutor = role == "Tutor" && Session["TutorId"] != null;

                string sql = isTutor
                    ? "SELECT TutorId, FullName FROM Tutors WHERE TutorId = @id"
                    : "SELECT TutorId, FullName FROM Tutors ORDER BY FullName";

                SqlCommand cmd = new SqlCommand(sql, conn);
                if (isTutor)
                {
                    cmd.Parameters.AddWithValue("@id", Convert.ToInt32(Session["TutorId"]));
                }

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                ddlTutor.DataSource = dt;
                ddlTutor.DataBind();

                if (isTutor)
                {
                    if (ddlTutor.Items.Count > 0 && ddlTutor.Items[0].Value == "0")
                    {
                        ddlTutor.Items.RemoveAt(0);
                    }
                    ddlTutor.Enabled = false;
                }
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            int tutorId = Convert.ToInt32(ddlTutor.SelectedValue);

            if (tutorId == 0)
            {
                lblError.Text = "Please select a tutor.";
                return;
            }

            DateTime workDate;
            if (!DateTime.TryParse(txtWorkDate.Text, out workDate))
            {
                lblError.Text = "Please enter a valid work date.";
                return;
            }

            if (workDate.Date > DateTime.Today)
            {
                lblError.Text = "Work date cannot be in the future.";
                return;
            }

            decimal hours = Convert.ToDecimal(txtHours.Text.Trim(), CultureInfo.InvariantCulture);

            if (hours < 0.5m || hours > 12m)
            {
                lblError.Text = "Hours worked must be between 0.5 and 12 for a single entry.";
                return;
            }

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand(
                    "INSERT INTO Timesheets (TutorId, WorkDate, HoursWorked, Description, Status) " +
                    "VALUES (@tutorId, @workDate, @hours, @description, 'Pending')", conn);
                cmd.Parameters.AddWithValue("@tutorId", tutorId);
                cmd.Parameters.AddWithValue("@workDate", workDate.Date);
                cmd.Parameters.AddWithValue("@hours", hours);
                cmd.Parameters.AddWithValue("@description",
                    string.IsNullOrWhiteSpace(txtDescription.Text) ? (object)DBNull.Value : txtDescription.Text.Trim());

                conn.Open();
                cmd.ExecuteNonQuery();
            }

            Response.Redirect("Timesheets.aspx");
        }
    }
}