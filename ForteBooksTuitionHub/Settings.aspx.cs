using System;
using System.Configuration;
using System.Data.SqlClient;

namespace ForteBooksTuitionHub
{
    public partial class Settings : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["ForteDb"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            AuthHelper.CheckAccess(this, new string[] { "Admin", "Tutor", "Student" });

            if (!IsPostBack)
            {
                BindLandingPages();
                LoadSettings();
            }

            HighlightSelectedTheme();
        }

        private void BindLandingPages()
        {
            string role = Session["Role"] != null ? Session["Role"].ToString() : "";

            ddlLandingPage.Items.Clear();
            ddlLandingPage.Items.Add(new System.Web.UI.WebControls.ListItem("Dashboard", "Default.aspx"));

            if (role == "Admin")
            {
                ddlLandingPage.Items.Add(new System.Web.UI.WebControls.ListItem("Students", "Students.aspx"));
                ddlLandingPage.Items.Add(new System.Web.UI.WebControls.ListItem("Sessions", "Sessions.aspx"));
                ddlLandingPage.Items.Add(new System.Web.UI.WebControls.ListItem("Payments", "Payments.aspx"));
            }
            else if (role == "Tutor")
            {
                ddlLandingPage.Items.Add(new System.Web.UI.WebControls.ListItem("My Sessions", "Sessions.aspx"));
                ddlLandingPage.Items.Add(new System.Web.UI.WebControls.ListItem("My Schedule", "MySchedule.aspx"));
            }
            else if (role == "Student")
            {
                ddlLandingPage.Items.Add(new System.Web.UI.WebControls.ListItem("My Sessions", "Sessions.aspx"));
                ddlLandingPage.Items.Add(new System.Web.UI.WebControls.ListItem("Book Catalogue", "BookCatalogue.aspx"));
            }
        }

        private void LoadSettings()
        {
            if (Session["UserId"] == null) return;
            int userId = Convert.ToInt32(Session["UserId"]);

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand(
                    "SELECT Theme, DefaultLandingPage, EmailNotifications FROM Users WHERE UserId = @id", conn);
                cmd.Parameters.AddWithValue("@id", userId);
                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();

                if (reader.Read())
                {
                    string theme = reader["Theme"].ToString();
                    Session["Theme"] = theme;

                    string landingPage = reader["DefaultLandingPage"].ToString();
                    if (ddlLandingPage.Items.FindByValue(landingPage) != null)
                    {
                        ddlLandingPage.SelectedValue = landingPage;
                    }

                    chkNotifications.Checked = Convert.ToBoolean(reader["EmailNotifications"]);
                }
            }
        }

        private void HighlightSelectedTheme()
        {
            string currentTheme = Session["Theme"] != null ? Session["Theme"].ToString() : "Light";

            btnLight.CssClass = currentTheme == "Dark" ? "theme-option" : "theme-option selected";
            btnDark.CssClass = currentTheme == "Dark" ? "theme-option selected" : "theme-option";
        }

        protected void btnLight_Click(object sender, EventArgs e)
        {
            ApplyTheme("Light");
        }

        protected void btnDark_Click(object sender, EventArgs e)
        {
            ApplyTheme("Dark");
        }

        private void ApplyTheme(string theme)
        {
            ThemeHelper.SetTheme(this.Context, theme);
            SaveThemeToDb(theme);
            HighlightSelectedTheme();
            lblMessage.Text = theme + " mode enabled.";
        }

        private void SaveThemeToDb(string theme)
        {
            if (Session["UserId"] == null) return;
            int userId = Convert.ToInt32(Session["UserId"]);

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand("UPDATE Users SET Theme = @theme WHERE UserId = @id", conn);
                cmd.Parameters.AddWithValue("@theme", theme);
                cmd.Parameters.AddWithValue("@id", userId);
                conn.Open();
                cmd.ExecuteNonQuery();
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (Session["UserId"] == null) return;
            int userId = Convert.ToInt32(Session["UserId"]);

            string theme = Session["Theme"] != null ? Session["Theme"].ToString() : "Light";

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand(
                    "UPDATE Users SET Theme = @theme, DefaultLandingPage = @landingPage, EmailNotifications = @notif WHERE UserId = @id", conn);
                cmd.Parameters.AddWithValue("@theme", theme);
                cmd.Parameters.AddWithValue("@landingPage", ddlLandingPage.SelectedValue);
                cmd.Parameters.AddWithValue("@notif", chkNotifications.Checked);
                cmd.Parameters.AddWithValue("@id", userId);
                conn.Open();
                cmd.ExecuteNonQuery();
            }

            lblMessage.Text = "Settings saved successfully.";
        }
    }
}