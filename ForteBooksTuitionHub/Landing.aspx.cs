using System;

namespace ForteBooksTuitionHub
{
    public partial class Landing : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // If someone who's already logged in lands here (e.g. via bookmark), send them straight to their dashboard
            if (Session["Username"] != null)
            {
                Response.Redirect("Default.aspx");
            }
        }
    }
}