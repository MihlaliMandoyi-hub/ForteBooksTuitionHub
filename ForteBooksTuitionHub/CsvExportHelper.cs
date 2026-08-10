using System;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;

namespace ForteBooksTuitionHub
{
    public static class CsvExportHelper
    {
        public static void ExportDataTable(HttpResponse response, DataTable dt, string fileName)
        {
            response.Clear();
            response.ContentType = "text/csv";
            response.AddHeader("Content-Disposition", "attachment;filename=" + fileName);

            StringBuilder sb = new StringBuilder();

            string[] columnNames = dt.Columns.Cast<DataColumn>().Select(c => EscapeCsv(c.ColumnName)).ToArray();
            sb.AppendLine(string.Join(",", columnNames));

            foreach (DataRow row in dt.Rows)
            {
                string[] fields = row.ItemArray.Select(f => EscapeCsv(f.ToString())).ToArray();
                sb.AppendLine(string.Join(",", fields));
            }

            response.Write(sb.ToString());
            response.End();
        }

        private static string EscapeCsv(string value)
        {
            if (value == null) value = "";
            if (value.Contains(",") || value.Contains("\"") || value.Contains("\n"))
            {
                value = value.Replace("\"", "\"\"");
                return "\"" + value + "\"";
            }
            return value;
        }
    }
}