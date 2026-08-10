using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace ForteBooksTuitionHub
{
    public partial class MyRentals : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["ForteDb"].ConnectionString;
        const decimal FinePerDay = 5.00m;

        protected void Page_Load(object sender, EventArgs e)
        {
            AuthHelper.CheckAccess(this, new string[] { "Student" });

            if (Request.QueryString["paid"] == "1")
            {
                //lblMessage.Text = "Fine paid successfully. Thank you!";
            }

            if (!IsPostBack)
            {
                BindRentals();
            }
        }

        private void BindRentals()
        {
            if (Session["StudentId"] == null)
            {
                return;
            }

            int studentId = Convert.ToInt32(Session["StudentId"]);

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = @"SELECT r.RentalId, b.Title, r.IssueDate, r.DueDate, r.ReturnDate, r.FinePaid
                               FROM BookRentals r
                               INNER JOIN Books b ON r.BookId = b.BookId
                               WHERE r.StudentId = @studentId
                               ORDER BY CASE WHEN r.ReturnDate IS NULL THEN 0 ELSE 1 END, r.DueDate ASC";

                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@studentId", studentId);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvMyRentals.DataSource = dt;
                gvMyRentals.DataBind();
            }
        }

        protected void gvMyRentals_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                DataRowView row = (DataRowView)e.Row.DataItem;
                Label lblStatus = (Label)e.Row.FindControl("lblStatus");
                Label lblFine = (Label)e.Row.FindControl("lblFine");
                HyperLink lnkPayFine = (HyperLink)e.Row.FindControl("lnkPayFine");

                int rentalId = Convert.ToInt32(row["RentalId"]);
                DateTime dueDate = Convert.ToDateTime(row["DueDate"]);
                bool finePaid = Convert.ToBoolean(row["FinePaid"]);

                decimal fineOwed = 0;
                int daysOverdue = 0;

                if (row["ReturnDate"] != DBNull.Value)
                {
                    lblStatus.Text = "Returned";
                    lblStatus.ForeColor = System.Drawing.Color.Green;

                    DateTime returnDate = Convert.ToDateTime(row["ReturnDate"]);
                    if (returnDate.Date > dueDate.Date)
                    {
                        daysOverdue = (returnDate.Date - dueDate.Date).Days;
                    }
                }
                else
                {
                    if (dueDate.Date < DateTime.Today)
                    {
                        lblStatus.Text = "OVERDUE";
                        lblStatus.ForeColor = System.Drawing.Color.Red;
                        lblStatus.Font.Bold = true;
                        daysOverdue = (DateTime.Today - dueDate.Date).Days;
                    }
                    else
                    {
                        lblStatus.Text = "On Loan";
                        lblStatus.ForeColor = System.Drawing.Color.Black;
                    }
                }

                if (daysOverdue > 0 && !finePaid)
                {
                    fineOwed = daysOverdue * FinePerDay;
                }

                if (fineOwed > 0)
                {
                    lblFine.Text = "R" + fineOwed.ToString("N2");
                    lblFine.ForeColor = System.Drawing.Color.Red;
                    lblFine.Font.Bold = true;

                    lnkPayFine.NavigateUrl = "PayFine.aspx?rentalId=" + rentalId;
                    lnkPayFine.Visible = true;
                }
                else if (finePaid && daysOverdue > 0)
                {
                    lblFine.Text = "Paid";
                    lblFine.ForeColor = System.Drawing.Color.Green;
                    lnkPayFine.Visible = false;
                }
                else
                {
                    lblFine.Text = "R0.00";
                    lnkPayFine.Visible = false;
                }
            }
        }
    }
}