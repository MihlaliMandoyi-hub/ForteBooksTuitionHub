using System;
using System.Web;

namespace ForteBooksTuitionHub
{
    public static class ThemeHelper
    {
        public static string GetTheme(HttpContext context)
        {
            if (context.Session != null && context.Session["Theme"] != null)
            {
                string sessionTheme = context.Session["Theme"].ToString();
                if (sessionTheme == "Dark" || sessionTheme == "Light")
                {
                    return sessionTheme;
                }
            }

            HttpCookie cookie = context.Request.Cookies["ForteTheme"];
            if (cookie != null && (cookie.Value == "Dark" || cookie.Value == "Light"))
            {
                return cookie.Value;
            }

            return "Light";
        }

        public static void SetTheme(HttpContext context, string theme)
        {
            context.Session["Theme"] = theme;

            HttpCookie cookie = new HttpCookie("ForteTheme", theme);
            cookie.Expires = DateTime.Now.AddYears(1);
            context.Response.Cookies.Add(cookie);
        }
    }
}