using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.IO;
using System.Text;
using System.Web;

namespace ForteBooksTuitionHub
{
    public partial class BookImport : System.Web.UI.Page
    {
        private readonly string connStr =
            ConfigurationManager.ConnectionStrings["ForteDb"].ConnectionString;

        private const int MaxFileBytes = 2 * 1024 * 1024;

        private sealed class ImportBook
        {
            public string Title;
            public string Author;
            public string ISBN;
            public string Edition;
            public int TotalCopies;
            public int? YearPublished;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            AuthHelper.CheckAccess(this, new string[] { "Admin" });
        }

        protected void btnSample_Click(object sender, EventArgs e)
        {
            DataTable table = new DataTable();

            table.Columns.Add("Title");
            table.Columns.Add("Author");
            table.Columns.Add("TotalCopies");
            table.Columns.Add("ISBN");
            table.Columns.Add("YearPublished");
            table.Columns.Add("Edition");

            table.Rows.Add(
                "Introduction to Algebra",
                "J. Smith",
                "5",
                "9783161484100",
                "2019",
                "2nd Edition");

            table.Rows.Add(
                "English Grammar Essentials",
                "M. Naidoo",
                "3",
                "",
                "2022",
                "1st Edition");

            CsvExportHelper.ExportDataTable(
                Response, table, "SampleBookImport.csv");
        }

        protected void btnImport_Click(object sender, EventArgs e)
        {
            lblError.Text = "";
            lblSummary.Text = "";
            litSkipped.Text = "";
            pnlResults.Visible = false;
            pnlSkipped.Visible = false;

            if (Convert.ToString(Session["Role"]) != "Admin")
            {
                lblError.Text = "Only administrators can import books.";
                return;
            }

            if (!fuCsv.HasFile)
            {
                lblError.Text = "Please choose a CSV file.";
                return;
            }

            if (!string.Equals(
                Path.GetExtension(fuCsv.FileName),
                ".csv",
                StringComparison.OrdinalIgnoreCase))
            {
                lblError.Text = "Please upload a .csv file.";
                return;
            }

            if (fuCsv.PostedFile.ContentLength > MaxFileBytes)
            {
                lblError.Text = "The CSV file must be no larger than 2 MB.";
                return;
            }

            List<string[]> records;

            try
            {
                // Strict UTF-8 decoding prevents silently damaged text.
                using (StreamReader reader = new StreamReader(
                    fuCsv.FileContent,
                    new UTF8Encoding(false, true),
                    false))
                {
                    records = ParseCsv(reader.ReadToEnd());
                }
            }
            catch (FormatException ex)
            {
                lblError.Text = HttpUtility.HtmlEncode(ex.Message);
                return;
            }
            catch (DecoderFallbackException)
            {
                lblError.Text =
                    "The file is not valid UTF-8. Save it as CSV UTF-8 and try again.";
                return;
            }

            if (records.Count == 0 || IsBlankRecord(records[0]))
            {
                lblError.Text = "The file must begin with a column header row.";
                return;
            }

            string[] headers = records[0];

            Dictionary<string, int> columns =
                new Dictionary<string, int>(
                    StringComparer.OrdinalIgnoreCase);

            for (int i = 0; i < headers.Length; i++)
            {
                string name = NormaliseHeader(headers[i]);

                if (!IsSupportedHeader(name))
                {
                    lblError.Text =
                        "Unrecognised header: " +
                        HttpUtility.HtmlEncode(headers[i]) +
                        ". Use the sample CSV headings.";
                    return;
                }

                if (columns.ContainsKey(name))
                {
                    lblError.Text =
                        "Duplicate column header: " +
                        HttpUtility.HtmlEncode(headers[i]) + ".";
                    return;
                }

                columns.Add(name, i);
            }

            string[] required = { "title", "author", "totalcopies" };

            foreach (string name in required)
            {
                if (!columns.ContainsKey(name))
                {
                    lblError.Text =
                        "Missing required column: " + name + ".";
                    return;
                }
            }

            List<ImportBook> books = new List<ImportBook>();
            List<string> errors = new List<string>();

            for (int i = 1; i < records.Count; i++)
            {
                string[] record = records[i];

                if (IsBlankRecord(record))
                {
                    continue;
                }

                string rowLabel = "CSV record " + (i + 1) + ": ";

                if (record.Length != headers.Length)
                {
                    errors.Add(
                        rowLabel + "contains " + record.Length +
                        " fields, but the header has " + headers.Length +
                        ". Put values containing commas inside double quotes.");
                    continue;
                }

                string title = Field(record, columns, "title");
                string author = Field(record, columns, "author");
                string copiesText = Field(record, columns, "totalcopies");
                string yearText = Field(record, columns, "yearpublished");

                int copies;
                int parsedYear;
                int? year = null;

                if (string.IsNullOrWhiteSpace(title))
                {
                    errors.Add(rowLabel + "Title is required.");
                    continue;
                }

                if (string.IsNullOrWhiteSpace(author))
                {
                    errors.Add(rowLabel + "Author is required.");
                    continue;
                }

                if (!int.TryParse(
                    copiesText,
                    NumberStyles.None,
                    CultureInfo.InvariantCulture,
                    out copies) || copies <= 0)
                {
                    errors.Add(
                        rowLabel + "TotalCopies must be a positive whole number.");
                    continue;
                }

                if (!string.IsNullOrWhiteSpace(yearText))
                {
                    if (!int.TryParse(
                        yearText,
                        NumberStyles.None,
                        CultureInfo.InvariantCulture,
                        out parsedYear) ||
                        parsedYear < 1 || parsedYear > 9999)
                    {
                        errors.Add(
                            rowLabel +
                            "YearPublished must be a year from 1 to 9999, or blank.");
                        continue;
                    }

                    year = parsedYear;
                }

                books.Add(new ImportBook
                {
                    Title = title,
                    Author = author,
                    TotalCopies = copies,
                    ISBN = Field(record, columns, "isbn"),
                    YearPublished = year,
                    Edition = Field(record, columns, "edition")
                });
            }

            if (errors.Count > 0)
            {
                ShowValidationErrors(errors);
                return;
            }

            if (books.Count == 0)
            {
                lblError.Text = "The file contains no book records to import.";
                return;
            }

            try
            {
                SaveBooks(books);
            }
            catch (Exception ex)
            {
                Trace.Warn("BookImport", "Import transaction failed.", ex);

                lblError.Text =
                    "The import could not be saved. No books were imported. " +
                    "Check field lengths and database requirements, then try again.";
                return;
            }

            lblSummary.Text =
                books.Count + " book record(s) imported successfully. " +
                "Available copies were set to each book's TotalCopies.";

            pnlResults.Visible = true;

            // A logging failure must not report the committed import as failed.
            try
            {
                ActivityLogHelper.Log(
                    Convert.ToString(Session["Username"]),
                    "BookImport",
                    books.Count + " book record(s) imported via validated CSV.");
            }
            catch (Exception ex)
            {
                Trace.Warn("BookImport", "Import audit logging failed.", ex);
            }
        }

        private void SaveBooks(List<ImportBook> books)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                using (SqlTransaction transaction = conn.BeginTransaction())
                {
                    foreach (ImportBook book in books)
                    {
                        using (SqlCommand cmd = new SqlCommand(@"
                            INSERT INTO Books
                            (
                                Title, Author, TotalCopies, AvailableCopies,
                                ISBN, YearPublished, Edition
                            )
                            VALUES
                            (
                                @title, @author, @total, @available,
                                @isbn, @year, @edition
                            )", conn, transaction))
                        {
                            cmd.Parameters.Add("@title", SqlDbType.NVarChar, -1)
                                .Value = book.Title;

                            cmd.Parameters.Add("@author", SqlDbType.NVarChar, -1)
                                .Value = book.Author;

                            cmd.Parameters.Add("@total", SqlDbType.Int)
                                .Value = book.TotalCopies;

                            cmd.Parameters.Add("@available", SqlDbType.Int)
                                .Value = book.TotalCopies;

                            cmd.Parameters.Add("@isbn", SqlDbType.NVarChar, -1)
                                .Value = DbText(book.ISBN);

                            cmd.Parameters.Add("@year", SqlDbType.Int)
                                .Value = book.YearPublished.HasValue
                                    ? (object)book.YearPublished.Value
                                    : DBNull.Value;

                            cmd.Parameters.Add("@edition", SqlDbType.NVarChar, -1)
                                .Value = DbText(book.Edition);

                            cmd.ExecuteNonQuery();
                        }
                    }

                    transaction.Commit();
                }
            }
        }

        private static object DbText(string value)
        {
            return string.IsNullOrWhiteSpace(value)
                ? (object)DBNull.Value
                : value;
        }

        private static string Field(
            string[] record,
            Dictionary<string, int> columns,
            string name)
        {
            int index;

            return columns.TryGetValue(name, out index)
                ? record[index].Trim()
                : "";
        }

        private static string NormaliseHeader(string value)
        {
            string name = value.Trim().TrimStart('\uFEFF')
                .Replace(" ", "")
                .Replace("_", "")
                .ToLowerInvariant();

            // "Year" is accepted as an explicit alias.
            return name == "year" ? "yearpublished" : name;
        }

        private static bool IsSupportedHeader(string name)
        {
            return name == "title" ||
                   name == "author" ||
                   name == "totalcopies" ||
                   name == "isbn" ||
                   name == "yearpublished" ||
                   name == "edition";
        }

        private static bool IsBlankRecord(string[] record)
        {
            foreach (string value in record)
            {
                if (!string.IsNullOrWhiteSpace(value))
                {
                    return false;
                }
            }

            return true;
        }

        private void ShowValidationErrors(List<string> errors)
        {
            lblError.Text =
                "Validation failed. No books were imported.";

            StringBuilder html = new StringBuilder();
            html.Append("<ul>");

            int shown = Math.Min(errors.Count, 50);

            for (int i = 0; i < shown; i++)
            {
                html.Append("<li>");
                html.Append(HttpUtility.HtmlEncode(errors[i]));
                html.Append("</li>");
            }

            html.Append("</ul>");

            if (errors.Count > shown)
            {
                html.Append("<p>");
                html.Append(errors.Count - shown);
                html.Append(" additional error(s). Correct the file and retry.</p>");
            }

            litSkipped.Text = html.ToString();
            pnlSkipped.Visible = true;
        }

        private static List<string[]> ParseCsv(string text)
        {
            List<string[]> records = new List<string[]>();
            List<string> fields = new List<string>();
            StringBuilder field = new StringBuilder();

            bool quoted = false;
            bool closedQuote = false;

            // Ignore a UTF-8 BOM at the start of the file.
            int first = text.Length > 0 && text[0] == '\uFEFF' ? 1 : 0;

            for (int i = first; i < text.Length; i++)
            {
                char c = text[i];

                if (quoted)
                {
                    if (c == '"')
                    {
                        if (i + 1 < text.Length && text[i + 1] == '"')
                        {
                            field.Append('"');
                            i++;
                        }
                        else
                        {
                            quoted = false;
                            closedQuote = true;
                        }
                    }
                    else
                    {
                        field.Append(c);
                    }

                    continue;
                }

                if (c == ',')
                {
                    fields.Add(field.ToString());
                    field.Clear();
                    closedQuote = false;
                    continue;
                }

                if (c == '\r' || c == '\n')
                {
                    fields.Add(field.ToString());
                    records.Add(fields.ToArray());

                    fields.Clear();
                    field.Clear();
                    closedQuote = false;

                    if (c == '\r' &&
                        i + 1 < text.Length &&
                        text[i + 1] == '\n')
                    {
                        i++;
                    }

                    continue;
                }

                if (closedQuote)
                {
                    if (c == ' ' || c == '\t')
                    {
                        continue;
                    }

                    throw new FormatException(
                        "CSV record " + (records.Count + 1) +
                        " has unexpected text after a closing quote.");
                }

                if (c == '"')
                {
                    if (field.Length != 0)
                    {
                        throw new FormatException(
                            "CSV record " + (records.Count + 1) +
                            " has a quote inside an unquoted field. " +
                            "Quote the whole field and double any quotes inside it.");
                    }

                    quoted = true;
                    continue;
                }

                field.Append(c);
            }

            if (quoted)
            {
                throw new FormatException(
                    "The CSV contains an unfinished quoted field.");
            }

            if (field.Length > 0 || fields.Count > 0 || closedQuote)
            {
                fields.Add(field.ToString());
                records.Add(fields.ToArray());
            }

            return records;
        }
    }
}