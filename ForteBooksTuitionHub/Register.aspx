<%@ Page Title="Register" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="ForteBooksTuitionHub.Register" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <asp:Panel ID="pnlForm" runat="server">
        <div class="auth-wrapper">
            <div class="auth-visual">
                <img src="Images/ufh-logo.png" alt="University of Fort Hare" />
                <h3>Join Forte Books &amp; Tuition Hub</h3>
                <p>Register as a Student to book tutoring sessions and rent books, or as a Tutor to offer your academic support.</p>
            </div>

            <div class="auth-form-side">
                <h2><i class="fa-solid fa-user-plus"></i> Create an Account</h2>

                <div class="form-box">

                    <label>I am registering as a...</label>
                    <asp:RadioButtonList ID="rblRole" runat="server" AutoPostBack="true"
                        OnSelectedIndexChanged="rblRole_SelectedIndexChanged" RepeatDirection="Horizontal">
                        <asp:ListItem Text="Student" Value="Student" Selected="True" />
                        <asp:ListItem Text="Tutor" Value="Tutor" />
                    </asp:RadioButtonList>

                    <asp:Panel ID="pnlTutorNotice" runat="server" Visible="false">
                        <div style="background:#FFF1D6; color:#B8760A; padding:10px 14px; border-radius:6px; margin-top:10px; font-size:13px;">
                            <i class="fa-solid fa-circle-info"></i> Tutor accounts require Admin approval before you can log in.
                        </div>
                    </asp:Panel>

                    <label>Full Name</label>
                    <asp:TextBox ID="txtFullName" runat="server" placeholder="e.g. Thandiwe Mtshali"></asp:TextBox>
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="txtFullName"
                        ErrorMessage="Full name is required." CssClass="error-text" Display="Dynamic" ValidationGroup="RegisterForm" />

                    <label>Email</label>
                    <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" placeholder="e.g. you@example.com"></asp:TextBox>
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="txtEmail"
                        ErrorMessage="Email is required." CssClass="error-text" Display="Dynamic" ValidationGroup="RegisterForm" />
                    <asp:RegularExpressionValidator runat="server" ControlToValidate="txtEmail"
                        ValidationExpression="^[^@\s]+@[^@\s]+\.[^@\s]+$"
                        ErrorMessage="Enter a valid email address." CssClass="error-text" Display="Dynamic" ValidationGroup="RegisterForm" />

                    <label>Phone Number</label>
                    <asp:TextBox ID="txtPhone" runat="server" placeholder="e.g. 0821234567"></asp:TextBox>
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="txtPhone"
                        ErrorMessage="Phone number is required." CssClass="error-text" Display="Dynamic" ValidationGroup="RegisterForm" />
                    <asp:RegularExpressionValidator runat="server" ControlToValidate="txtPhone"
                        ValidationExpression="^0\d{9}$"
                        ErrorMessage="Enter a valid 10-digit phone number starting with 0." CssClass="error-text" Display="Dynamic" ValidationGroup="RegisterForm" />

                    <asp:Panel ID="pnlTutorFields" runat="server" Visible="false">
                        <label>Subject / Specialty</label>
                        <asp:TextBox ID="txtSubject" runat="server" placeholder="e.g. Mathematics"></asp:TextBox>

                        <label>Hourly Rate (R)</label>
                        <asp:TextBox ID="txtHourlyRate" runat="server" placeholder="e.g. 150.00"></asp:TextBox>
                        <asp:RegularExpressionValidator runat="server" ControlToValidate="txtHourlyRate"
                            ValidationExpression="^\d+(\.\d{1,2})?$"
                            ErrorMessage="Enter a valid amount (e.g. 150 or 150.00)." CssClass="error-text" Display="Dynamic" ValidationGroup="RegisterForm" />
                    </asp:Panel>

                    <hr style="margin:20px 0; border-color:#eee;" />

                    <label>Choose a Username</label>
                    <asp:TextBox ID="txtUsername" runat="server" placeholder="e.g. tmtshali"></asp:TextBox>
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="txtUsername"
                        ErrorMessage="Username is required." CssClass="error-text" Display="Dynamic" ValidationGroup="RegisterForm" />

                    <label>Choose a Password</label>
                    <asp:TextBox ID="txtPassword" runat="server" TextMode="Password"></asp:TextBox>
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="txtPassword"
                        ErrorMessage="Password is required." CssClass="error-text" Display="Dynamic" ValidationGroup="RegisterForm" />

                    <label>Confirm Password</label>
                    <asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password"></asp:TextBox>
                    <asp:CompareValidator runat="server" ControlToValidate="txtConfirmPassword" ControlToCompare="txtPassword"
                        ErrorMessage="Passwords do not match." CssClass="error-text" Display="Dynamic" ValidationGroup="RegisterForm" />

                    <label>Security Question <span style="font-weight:normal; text-transform:none;">(used to reset your password later)</span></label>
                    <asp:DropDownList ID="ddlSecurityQuestion" runat="server" style="padding:8px; width:100%;">
                        <asp:ListItem Text="What is your mother's maiden name?" Value="What is your mother's maiden name?" />
                        <asp:ListItem Text="What was the name of your first school?" Value="What was the name of your first school?" />
                        <asp:ListItem Text="What is your favourite subject?" Value="What is your favourite subject?" />
                        <asp:ListItem Text="What city were you born in?" Value="What city were you born in?" />
                    </asp:DropDownList>

                    <label>Security Answer</label>
                    <asp:TextBox ID="txtSecurityAnswer" runat="server"></asp:TextBox>
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="txtSecurityAnswer"
                        ErrorMessage="Security answer is required." CssClass="error-text" Display="Dynamic" ValidationGroup="RegisterForm" />

                    <br /><br />
                    <asp:Button ID="btnRegister" runat="server" Text="Create Account" CssClass="btn btn-gold" OnClick="btnRegister_Click" ValidationGroup="RegisterForm" />
                    <a href="Login.aspx" class="btn">Already have an account? Login</a>

                    <br /><br />
                    <asp:Label ID="lblError" runat="server" CssClass="error-text"></asp:Label>
                </div>
            </div>
        </div>
    </asp:Panel>

    <asp:Panel ID="pnlConfirmation" runat="server" Visible="false">
        <h2><i class="fa-solid fa-envelope-circle-check"></i> Registration Confirmation</h2>

        <div class="email-receipt">
            <div class="email-receipt-header">
                <div class="subject"><i class="fa-solid fa-envelope"></i> Welcome to Forte Books &amp; Tuition Hub</div>
                <div class="meta">To: <asp:Label ID="lblConfirmEmail" runat="server"></asp:Label> &nbsp;|&nbsp; <%: DateTime.Now.ToString("yyyy-MM-dd HH:mm") %></div>
            </div>
            <div class="email-receipt-body">
                <div class="greeting">Hi <asp:Label ID="lblConfirmName" runat="server"></asp:Label>,</div>
                <p style="font-size:14px; color:#555;">Your account has been created successfully. Here's a summary:</p>

                <div class="email-receipt-row"><span class="label">Account Type</span><span class="value"><asp:Label ID="lblConfirmRole" runat="server"></asp:Label></span></div>
                <div class="email-receipt-row"><span class="label">Username</span><span class="value"><asp:Label ID="lblConfirmUsername" runat="server"></asp:Label></span></div>
                <div class="email-receipt-row"><span class="label">Status</span><span class="value"><asp:Label ID="lblConfirmStatus" runat="server"></asp:Label></span></div>

                <asp:Panel ID="pnlTutorPendingNotice" runat="server" Visible="false">
                    <p style="font-size:13px; color:#B8760A; margin-top:14px;">
                        <i class="fa-solid fa-hourglass-half"></i> Your tutor account is awaiting Admin approval. You'll be notified once it's reviewed.
                    </p>
                </asp:Panel>

                <br />
                <a href="Login.aspx" class="btn btn-gold"><i class="fa-solid fa-right-to-bracket"></i> Continue to Login</a>
            </div>
        </div>
    </asp:Panel>

</asp:Content>