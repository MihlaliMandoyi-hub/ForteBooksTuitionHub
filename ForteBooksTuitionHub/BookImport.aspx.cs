using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Text;

namespace ForteBooksTuitionHub
{
    public partial class BookImport : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["ForteDb"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            AuthHelper.CheckAccess(this, new string[] { "Admin" });
        }

        protected void btnSample_Click(object sender, EventArgs e)
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("Title");
            dt.Columns.Add("Author");
            dt.Columns.Add("TotalCopies");
            dt.Rows.Add("Introduction to Algebra", "J. Smith", "5");
            dt.Rows.Add("English Grammar Essentials", "M. Naidoo", "3");

            CsvExportHelper.ExportDataTable(Response, dt, "SampleBookImport.csv");
        }

        protected void btnImport_Click(object sender, EventArgs e)
        {
            lblError.Text = "";
            pnlResults.Visible = false;

            if (!fuCsv.HasFile)
            {
                lblError.Text = "Please choose a CSV file to upload.";
                return;
            }

            int successCount = 0;
            List<string> skippedRows = new List<string>();

            using (StreamReader reader = new StreamReader(fuCsv.FileContent))
            {
                bool isFirstLine = true;
                int lineNumber = 0;

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();

                    while (!reader.EndOfStream)
                    {
                        string line = reader.ReadLine();
                        lineNumber++;

                        if (isFirstLine)
                        {
                            isFirstLine = false;
                            continue; // skip header row
                        }

                        if (string.IsNullOrWhiteSpace(line)) continue;

                        string[] parts = line.Split(',');

                        if (parts.Length < 3)
                        {
                            skippedRows.Add("Line " + lineNumber + ": expected 3 columns, found " + parts.Length + ".");
                            continue;
                        }

                        string title = parts[0].Trim();
                        string author = parts[1].Trim();
                        string copiesText = parts[2].Trim();

                        int totalCopies;
                        if (string.IsNullOrWhiteSpace(title) || string.IsNullOrWhiteSpace(author) ||
                            !int.TryParse(copiesText, out totalCopies) || totalCopies <= 0)
                        {
                            skippedRows.Add("Line " + lineNumber + ": \"" + line + "\" — invalid title, author, or copy count.");
                            continue;
                        }

                        SqlCommand cmd = new SqlCommand(
                            "INSERT INTO Books (Title, Author, TotalCopies, AvailableCopies) VALUES (@title, @author, @total, @total)", conn);
                        cmd.Parameters.AddWithValue("@title", title);
                        cmd.Parameters.AddWithValue("@author", author);
                        cmd.Parameters.AddWithValue("@total", totalCopies);
                        cmd.ExecuteNonQuery();

                        successCount++;
                    }
                }
            }

            string adminUsername = Session["Username"] != null ? Session["Username"].ToString() : "Admin";
            ActivityLogHelper.Log(adminUsername, "BookImport", successCount + " book(s) imported via CSV, " + skippedRows.Count + " row(s) skipped.");

            lblSummary.Text = successCount + " book(s) imported successfully. " + skippedRows.Count + " row(s) skipped.";
            pnlResults.Visible = true;

            if (skippedRows.Count > 0)
            {
                StringBuilder sb = new StringBuilder();
                foreach (string s in skippedRows)
                {
                    sb.Append("<p style='font-size:13px; color:#c0392b;'>" + System.Web.HttpUtility.HtmlEncode(s) + "</p>");
                }
                litSkipped.Text = sb.ToString();
                pnlSkipped.Visible = true;
            }
        }
    }
}