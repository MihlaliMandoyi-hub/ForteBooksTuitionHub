using System;
using System.Linq;
using System.Web.UI;

namespace ForteBooksTuitionHub
{
    public static class AuthHelper
    {
        // Call this at the top of Page_Load on any page that needs login.
        // allowedRoles example: new string[] { "Admin" } or new string[] { "Admin", "Tutor" }
        public static void CheckAccess(Page page, string[] allowedRoles)
        {
            if (page.Session["Role"] == null)
            {
                page.Response.Redirect("Login.aspx");
                return;
            }

            string currentRole = page.Session["Role"].ToString();

            if (!allowedRoles.Contains(currentRole))
            {
                page.Response.Redirect("AccessDenied.aspx");
            }
        }
    }
}