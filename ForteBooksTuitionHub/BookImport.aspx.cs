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
        string connStr =
            ConfigurationManager.ConnectionStrings["ForteDb"].ConnectionString;

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
            dt.Columns.Add("ISBN");
            dt.Columns.Add("YearPublished");
            dt.Columns.Add("Edition");

            dt.Rows.Add(
                "Introduction to Algebra",
                "J. Smith",
                "5",
                "9783161484100",
                "2019",
                "2nd Edition"
            );

            dt.Rows.Add(
                "English Grammar Essentials",
                "M. Naidoo",
                "3",
                "9781234567897",
                "2022",
                "1st Edition"
            );

            CsvExportHelper.ExportDataTable(
                Response,
                dt,
                "SampleBookImport.csv"
            );
        }

        protected void btnImport_Click(object sender, EventArgs e)
        {
            lblError.Text = "";
            pnlResults.Visible = false;
            pnlSkipped.Visible = false;

            if (!fuCsv.HasFile)
            {
                lblError.Text = "Please choose a CSV file to upload.";
                return;
            }

            int successCount = 0;
            List<string> skippedRows = new List<string>();

            using (StreamReader reader =
                   new StreamReader(fuCsv.FileContent))
            {
                bool isFirstLine = true;
                int lineNumber = 0;

                using (SqlConnection conn =
                       new SqlConnection(connStr))
                {
                    conn.Open();

                    while (!reader.EndOfStream)
                    {
                        string line = reader.ReadLine();
                        lineNumber++;

                        if (isFirstLine)
                        {
                            isFirstLine = false;
                            continue;
                        }

                        if (string.IsNullOrWhiteSpace(line))
                            continue;

                        string[] parts = line.Split(',');

                        if (parts.Length < 6)
                        {
                            skippedRows.Add(
                                "Line " + lineNumber +
                                ": expected 6 columns " +
                                "(Title, Author, TotalCopies, ISBN, YearPublished, Edition)."
                            );

                            continue;
                        }

                        string title =
                            parts[0].Trim();

                        string author =
                            parts[1].Trim();

                        string copiesText =
                            parts[2].Trim();

                        string isbn =
                            parts[3].Trim();

                        string yearText =
                            parts[4].Trim();

                        string edition =
                            parts[5].Trim();

                        int totalCopies;

                        if (
                            string.IsNullOrWhiteSpace(title) ||
                            string.IsNullOrWhiteSpace(author) ||
                            !int.TryParse(copiesText, out totalCopies) ||
                            totalCopies <= 0
                        )
                        {
                            skippedRows.Add(
                                "Line " + lineNumber +
                                ": invalid title, author, or copy count."
                            );

                            continue;
                        }

                        int? year = null;

                        if (!string.IsNullOrWhiteSpace(yearText))
                        {
                            int parsedYear;

                            if (
                                int.TryParse(
                                    yearText,
                                    out parsedYear
                                ) &&
                                parsedYear >= 1900 &&
                                parsedYear <= DateTime.Today.Year
                            )
                            {
                                year = parsedYear;
                            }
                        }

                        try
                        {
                            SqlCommand cmd =
                                new SqlCommand(
                                    @"INSERT INTO Books
                                    (
                                        Title,
                                        Author,
                                        TotalCopies,
                                        AvailableCopies,
                                        ISBN,
                                        YearPublished,
                                        Edition
                                    )
                                    VALUES
                                    (
                                        @title,
                                        @author,
                                        @total,
                                        @available,
                                        @isbn,
                                        @year,
                                        @edition
                                    )",
                                    conn
                                );

                            cmd.Parameters.AddWithValue(
                                "@title",
                                title
                            );

                            cmd.Parameters.AddWithValue(
                                "@author",
                                author
                            );

                            cmd.Parameters.AddWithValue(
                                "@total",
                                totalCopies
                            );

                            // All newly imported books start as available
                            cmd.Parameters.AddWithValue(
                                "@available",
                                totalCopies
                            );

                            cmd.Parameters.AddWithValue(
                                "@isbn",
                                string.IsNullOrWhiteSpace(isbn)
                                    ? (object)DBNull.Value
                                    : isbn
                            );

                            cmd.Parameters.AddWithValue(
                                "@year",
                                (object)year ?? DBNull.Value
                            );

                            cmd.Parameters.AddWithValue(
                                "@edition",
                                string.IsNullOrWhiteSpace(edition)
                                    ? (object)DBNull.Value
                                    : edition
                            );

                            cmd.ExecuteNonQuery();

                            successCount++;
                        }
                        catch (Exception ex)
                        {
                            skippedRows.Add(
                                "Line " + lineNumber +
                                ": database error - " +
                                ex.Message
                            );
                        }
                    }
                }
            }

            string adminUsername =
                Session["Username"] != null
                    ? Session["Username"].ToString()
                    : "Admin";

            ActivityLogHelper.Log(
                adminUsername,
                "BookImport",
                successCount +
                " book(s) imported via CSV, " +
                skippedRows.Count +
                " row(s) skipped."
            );

            lblSummary.Text =
                successCount +
                " book(s) imported successfully. " +
                skippedRows.Count +
                " row(s) skipped.";

            pnlResults.Visible = true;

            if (skippedRows.Count > 0)
            {
                StringBuilder sb =
                    new StringBuilder();

                foreach (string s in skippedRows)
                {
                    sb.Append(
                        "<p style='font-size:13px; color:#c0392b;'>" +
                        System.Web.HttpUtility.HtmlEncode(s) +
                        "</p>"
                    );
                }

                litSkipped.Text = sb.ToString();
                pnlSkipped.Visible = true;
            }
        }
    }
}