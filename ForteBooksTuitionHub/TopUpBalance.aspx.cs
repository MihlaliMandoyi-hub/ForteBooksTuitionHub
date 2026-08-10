using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Globalization;
using System.Text.RegularExpressions;

namespace ForteBooksTuitionHub
{
    public partial class TopUpBalance : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["ForteDb"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            AuthHelper.CheckAccess(this, new string[] { "Student" });
        }

        protected void rblMethod_SelectedIndexChanged(object sender, EventArgs e)
        {
            bool isVoucher = rblMethod.SelectedValue == "Voucher";
            pnlVoucherFields.Visible = isVoucher;
            pnlCardFields.Visible = !isVoucher;
        }

        protected void btnReview_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            lblError.Text = "";
            decimal amount = Convert.ToDecimal(txtAmount.Text.Trim(), CultureInfo.InvariantCulture);

            if (amount < 10)
            {
                lblError.Text = "Minimum top-up amount is R10.00.";
                return;
            }

            string methodDisplay;

            if (rblMethod.SelectedValue == "Voucher")
            {
                string code = txtVoucherCode.Text.Trim();

                if (!Regex.IsMatch(code, @"^\d{10,16}$"))
                {
                    lblError.Text = "Please enter a valid voucher code (10 to 16 digits).";
                    return;
                }

                string last4 = code.Substring(code.Length - 4);
                methodDisplay = ddlVoucherType.SelectedValue + " ending in " + last4;
                ViewState["MethodForDb"] = "Voucher";
            }
            else
            {
                string cardNumberDigitsOnly = txtCardNumber.Text.Replace(" ", "");

                if (string.IsNullOrWhiteSpace(txtCardName.Text))
                {
                    lblError.Text = "Please enter the cardholder name.";
                    return;
                }

                if (!Regex.IsMatch(cardNumberDigitsOnly, @"^\d{16}$"))
                {
                    lblError.Text = "Please enter a valid 16-digit card number.";
                    return;
                }

                if (!Regex.IsMatch(txtExpiry.Text.Trim(), @"^(0[1-9]|1[0-2])\/\d{2}$"))
                {
                    lblError.Text = "Please enter a valid expiry date in MM/YY format.";
                    return;
                }

                if (!Regex.IsMatch(txtCvv.Text.Trim(), @"^\d{3}$"))
                {
                    lblError.Text = "Please enter a valid 3-digit CVV.";
                    return;
                }

                string last4 = cardNumberDigitsOnly.Substring(cardNumberDigitsOnly.Length - 4);
                methodDisplay = "Card ending in " + last4;
                ViewState["MethodForDb"] = "Card";
            }

            ViewState["Amount"] = amount;
            ViewState["MethodDisplay"] = methodDisplay;

            lblConfirmAmount.Text = amount.ToString("N2");
            lblConfirmMethod.Text = methodDisplay;

            pnlForm.Visible = false;
            pnlConfirm.Visible = true;
        }

        protected void btnBack_Click(object sender, EventArgs e)
        {
            pnlConfirm.Visible = false;
            pnlForm.Visible = true;
        }

        protected void btnConfirmPay_Click(object sender, EventArgs e)
        {
            if (Session["StudentId"] == null || ViewState["Amount"] == null)
            {
                Response.Redirect("Default.aspx");
                return;
            }

            int studentId = Convert.ToInt32(Session["StudentId"]);
            decimal amount = (decimal)ViewState["Amount"];
            string methodForDb = ViewState["MethodForDb"].ToString();
            string methodDisplay = ViewState["MethodDisplay"].ToString();

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand insertPayment = new SqlCommand(
                    "INSERT INTO Payments (StudentId, Amount, PaymentDate, Method, Reason) " +
                    "VALUES (@studentId, @amount, @date, @method, 'Deposit')", conn);
                insertPayment.Parameters.AddWithValue("@studentId", studentId);
                insertPayment.Parameters.AddWithValue("@amount", amount);
                insertPayment.Parameters.AddWithValue("@date", DateTime.Today);
                insertPayment.Parameters.AddWithValue("@method", methodForDb);
                conn.Open();
                insertPayment.ExecuteNonQuery();

                string studentUsername = Session["Username"] != null ? Session["Username"].ToString() : "Student";
                ActivityLogHelper.Log(studentUsername, "TopUp", "Balance topped up by R" + amount.ToString("N2") + " via " + methodDisplay + ".");

                NotificationHelper.CreateForStudent(studentId, "Your account was topped up by R" + amount.ToString("N2") + ".", "MyProfile.aspx");
            }

            lblSuccessAmount.Text = amount.ToString("N2");
            pnlConfirm.Visible = false;
            pnlSuccess.Visible = true;
        }
    }
}