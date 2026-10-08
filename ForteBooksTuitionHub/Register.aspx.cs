using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Globalization;

namespace ForteBooksTuitionHub
{
    public partial class Register : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["ForteDb"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void rbRole_CheckedChanged(object sender, EventArgs e)
        {
            bool isTutor = rbTutor.Checked;
            pnlTutorFields.Visible = isTutor;
            pnlTutorNotice.Visible = isTutor;
        }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            string role = rbTutor.Checked ? "Tutor" : "Student";
            string fullName = txtFullName.Text.Trim();
            string email = txtEmail.Text.Trim();
            string phone = txtPhone.Text.Trim();
            string username = txtUsername.Text.Trim();
            string password = txtPassword.Text.Trim();
            string securityQuestion = ddlSecurityQuestion.SelectedValue;
            string securityAnswer = txtSecurityAnswer.Text.Trim();

            if (role == "Tutor" && string.IsNullOrWhiteSpace(txtSubject.Text))
            {
                lblError.Text = "Please enter your subject/specialty.";
                return;
            }

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                SqlCommand userCheck = new SqlCommand("SELECT COUNT(*) FROM Users WHERE Username = @username", conn);
                userCheck.Parameters.AddWithValue("@username", username);
                if ((int)userCheck.ExecuteScalar() > 0)
                {
                    lblError.Text = "That username is already taken. Please choose another.";
                    return;
                }

                if (role == "Student")
                {
                    SqlCommand emailCheck = new SqlCommand("SELECT COUNT(*) FROM Students WHERE Email = @email", conn);
                    emailCheck.Parameters.AddWithValue("@email", email);
                    if ((int)emailCheck.ExecuteScalar() > 0)
                    {
                        lblError.Text = "A student with this email already exists.";
                        return;
                    }

                    SqlCommand insertStudent = new SqlCommand(
                        "INSERT INTO Students (FullName, Email, Phone, DateRegistered) " +
                        "OUTPUT INSERTED.StudentId " +
                        "VALUES (@fullName, @email, @phone, @dateRegistered)", conn);
                    insertStudent.Parameters.AddWithValue("@fullName", fullName);
                    insertStudent.Parameters.AddWithValue("@email", email);
                    insertStudent.Parameters.AddWithValue("@phone", phone);
                    insertStudent.Parameters.AddWithValue("@dateRegistered", DateTime.Today);
                    int newStudentId = (int)insertStudent.ExecuteScalar();

                    SqlCommand insertUser = new SqlCommand(
                        "INSERT INTO Users (Username, Password, Role, StudentId, Email, Status, SecurityQuestion, SecurityAnswer) " +
                        "VALUES (@username, @password, 'Student', @studentId, @email, 'Active', @question, @answer)", conn);
                    insertUser.Parameters.AddWithValue("@username", username);
                    insertUser.Parameters.AddWithValue("@password", PasswordHelper.Hash(password));
                    insertUser.Parameters.AddWithValue("@studentId", newStudentId);
                    insertUser.Parameters.AddWithValue("@email", email);
                    insertUser.Parameters.AddWithValue("@question", securityQuestion);
                    insertUser.Parameters.AddWithValue("@answer", PasswordHelper.Hash(securityAnswer.ToLower()));
                    insertUser.ExecuteNonQuery();

                    ActivityLogHelper.Log(username, "Registration", fullName + " registered as a Student.");

                    ShowConfirmation(fullName, email, "Student", username, "Active");
                }
                else
                {
                    SqlCommand emailCheck = new SqlCommand("SELECT COUNT(*) FROM Tutors WHERE Email = @email", conn);
                    emailCheck.Parameters.AddWithValue("@email", email);
                    if ((int)emailCheck.ExecuteScalar() > 0)
                    {
                        lblError.Text = "A tutor with this email already exists.";
                        return;
                    }

                    decimal hourlyRate = string.IsNullOrWhiteSpace(txtHourlyRate.Text)
                        ? 0
                        : Convert.ToDecimal(txtHourlyRate.Text.Trim(), CultureInfo.InvariantCulture);

                    SqlCommand insertTutor = new SqlCommand(
                        "INSERT INTO Tutors (FullName, Email, Phone, Subject, HourlyRate) " +
                        "OUTPUT INSERTED.TutorId " +
                        "VALUES (@fullName, @email, @phone, @subject, @rate)", conn);
                    insertTutor.Parameters.AddWithValue("@fullName", fullName);
                    insertTutor.Parameters.AddWithValue("@email", email);
                    insertTutor.Parameters.AddWithValue("@phone", phone);
                    insertTutor.Parameters.AddWithValue("@subject", txtSubject.Text.Trim());
                    insertTutor.Parameters.AddWithValue("@rate", hourlyRate);
                    int newTutorId = (int)insertTutor.ExecuteScalar();

                    SqlCommand insertUser = new SqlCommand(
                        "INSERT INTO Users (Username, Password, Role, TutorId, Email, Status, SecurityQuestion, SecurityAnswer) " +
                        "VALUES (@username, @password, 'Tutor', @tutorId, @email, 'Pending', @question, @answer)", conn);
                    insertUser.Parameters.AddWithValue("@username", username);
                    insertUser.Parameters.AddWithValue("@password", PasswordHelper.Hash(password));
                    insertUser.Parameters.AddWithValue("@tutorId", newTutorId);
                    insertUser.Parameters.AddWithValue("@email", email);
                    insertUser.Parameters.AddWithValue("@question", securityQuestion);
                    insertUser.Parameters.AddWithValue("@answer", PasswordHelper.Hash(securityAnswer.ToLower()));
                    insertUser.ExecuteNonQuery();

                    ActivityLogHelper.Log(username, "Registration", fullName + " applied as a Tutor (pending approval).");

                    ShowConfirmation(fullName, email, "Tutor", username, "Pending Approval");
                }
            }
        }

        private void ShowConfirmation(string fullName, string email, string role, string username, string status)
        {
            lblConfirmName.Text = fullName;
            lblConfirmEmail.Text = email;
            lblConfirmRole.Text = role;
            lblConfirmUsername.Text = username;
            lblConfirmStatus.Text = status;

            pnlTutorPendingNotice.Visible = status == "Pending Approval";

            pnlForm.Visible = false;
            pnlConfirmation.Visible = true;
        }
    }
}