<%@ Page Title="Create an Account" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="ForteBooksTuitionHub.Register" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="hub-login hub-register">

        <section class="hub-login-welcome">

            <img class="hub-login-logo"
                src="Images/ufh-logo.png"
                alt="University of Fort Hare" />

            <span class="hub-login-eyebrow">FORTE BOOKS &amp; TUITION HUB</span>
            <h2>A new chapter.<br />Your next step.</h2>

            <p class="hub-login-intro">
                Join the hub as a student or apply as a tutor.
                Bring your learning, books and session activity together.
            </p>

            <div class="hub-login-features">
                <div>
                    <span>
                        <i class="fa-solid fa-user-graduate" aria-hidden="true"></i>
                    </span>
                    <div>
                        <strong>Here to learn?</strong>
                        <p>Create a student account to access the hub.</p>
                    </div>
                </div>

                <div>
                    <span>
                        <i class="fa-solid fa-chalkboard-user" aria-hidden="true"></i>
                    </span>
                    <div>
                        <strong>Here to teach?</strong>
                        <p>Apply as a tutor. Administrator approval is required before sign-in.</p>
                    </div>
                </div>

                <div>
                    <span>
                        <i class="fa-solid fa-book-open" aria-hidden="true"></i>
                    </span>
                    <div>
                        <strong>Keep moving forward</strong>
                        <p>Find support, explore books and organise your learning.</p>
                    </div>
                </div>
            </div>

            <div class="hub-login-signature">
                <i class="fa-solid fa-graduation-cap" aria-hidden="true"></i>
                <span>InnovaTech Hub</span>
            </div>

        </section>

        <div class="hub-register-main">

            <asp:Panel ID="pnlForm" runat="server"
                CssClass="hub-login-form"
                DefaultButton="btnRegister">

                <div class="hub-login-heading-icon">
                    <i class="fa-solid fa-user-plus" aria-hidden="true"></i>
                </div>

                <span class="hub-login-eyebrow">JOIN THE HUB</span>
                <h2>Create your account</h2>
                <p class="hub-login-form-intro">Fields marked * are required.</p>

                <fieldset class="register-role">
    <legend>Choose your account type</legend>

    <div class="register-role-options">

        <div class="register-choice">
            <i class="fa-solid fa-user-graduate register-choice-icon"
                aria-hidden="true"></i>

            <asp:RadioButton ID="rbStudent" runat="server"
                GroupName="RegistrationRole"
                Text="Student"
                Checked="true"
                AutoPostBack="true"
                CausesValidation="false"
                OnCheckedChanged="rbRole_CheckedChanged" />

            <span class="register-choice-caption">Learn &amp; discover</span>
        </div>

        <div class="register-choice">
            <i class="fa-solid fa-chalkboard-user register-choice-icon"
                aria-hidden="true"></i>

            <asp:RadioButton ID="rbTutor" runat="server"
                GroupName="RegistrationRole"
                Text="Tutor"
                AutoPostBack="true"
                CausesValidation="false"
                OnCheckedChanged="rbRole_CheckedChanged" />

            <span class="register-choice-caption">Teach &amp; inspire</span>
        </div>

    </div>
</fieldset>

                <asp:Panel ID="pnlTutorNotice" runat="server"
                    Visible="false" CssClass="register-pending-note">
                    <i class="fa-solid fa-clock" aria-hidden="true"></i>
                    Tutor applications are reviewed by an administrator.
                    You can sign in once your account is approved.
                </asp:Panel>

                <div class="register-section-heading">
                    <span>01</span>
                    <h3>Your details</h3>
                </div>

                <div class="hub-login-field">
                    <asp:Label runat="server" AssociatedControlID="txtFullName"
                        Text="Full name *"></asp:Label>
                    <asp:TextBox ID="txtFullName" runat="server"
                        CssClass="hub-login-input"
                        autocomplete="name"
                        placeholder="Enter your full name"></asp:TextBox>
                    <asp:RequiredFieldValidator runat="server"
                        ControlToValidate="txtFullName"
                        ErrorMessage="Full name is required."
                        CssClass="error-text" Display="Dynamic"
                        ValidationGroup="Register" />
                </div>

                <div class="hub-login-field">
                    <asp:Label runat="server" AssociatedControlID="txtEmail"
                        Text="Email address *"></asp:Label>
                    <asp:TextBox ID="txtEmail" runat="server"
                        CssClass="hub-login-input"
                        TextMode="Email"
                        autocomplete="email"
                        placeholder="you@example.com"></asp:TextBox>
                    <asp:RequiredFieldValidator runat="server"
                        ControlToValidate="txtEmail"
                        ErrorMessage="Email is required."
                        CssClass="error-text" Display="Dynamic"
                        ValidationGroup="Register" />
                    <asp:RegularExpressionValidator runat="server"
                        ControlToValidate="txtEmail"
                        ValidationExpression="^[^@\s]+@[^@\s]+\.[^@\s]+$"
                        ErrorMessage="Enter a valid email address."
                        CssClass="error-text" Display="Dynamic"
                        ValidationGroup="Register" />
                </div>

                <div class="hub-login-field">
                    <asp:Label runat="server" AssociatedControlID="txtPhone"
                        Text="Phone number (optional)"></asp:Label>
                    <asp:TextBox ID="txtPhone" runat="server"
                        CssClass="hub-login-input"
                        TextMode="Phone"
                        autocomplete="tel"
                        placeholder="Enter your contact number"></asp:TextBox>
                </div>

                <asp:Panel ID="pnlTutorFields" runat="server"
                    Visible="false" CssClass="register-tutor-fields">

                    <div class="hub-login-field">
                        <asp:Label runat="server" AssociatedControlID="txtSubject"
                            Text="Subject / specialty *"></asp:Label>
                        <asp:TextBox ID="txtSubject" runat="server"
                            CssClass="hub-login-input"
                            placeholder="e.g. Mathematics"></asp:TextBox>
                        <asp:RequiredFieldValidator runat="server"
                            ControlToValidate="txtSubject"
                            ErrorMessage="Enter your subject or specialty."
                            CssClass="error-text" Display="Dynamic"
                            ValidationGroup="Register" />
                    </div>

                    <div class="hub-login-field">
                        <asp:Label runat="server" AssociatedControlID="txtHourlyRate"
                            Text="Hourly rate (R, optional)"></asp:Label>
                        <asp:TextBox ID="txtHourlyRate" runat="server"
                            CssClass="hub-login-input"
                            inputmode="decimal"
                            placeholder="e.g. 100.00"></asp:TextBox>
                        <asp:RegularExpressionValidator runat="server"
                            ControlToValidate="txtHourlyRate"
                            ValidationExpression="^\d+(\.\d{1,2})?$"
                            ErrorMessage="Use an amount such as 100 or 100.00."
                            CssClass="error-text" Display="Dynamic"
                            ValidationGroup="Register" />
                    </div>

                </asp:Panel>

                <div class="register-section-heading">
                    <span>02</span>
                    <h3>Sign-in details</h3>
                </div>

                <div class="hub-login-field">
                    <asp:Label runat="server" AssociatedControlID="txtUsername"
                        Text="Username *"></asp:Label>
                    <asp:TextBox ID="txtUsername" runat="server"
                        CssClass="hub-login-input"
                        autocomplete="username"
                        autocapitalize="none"
                        spellcheck="false"
                        placeholder="Choose a username"></asp:TextBox>
                    <asp:RequiredFieldValidator runat="server"
                        ControlToValidate="txtUsername"
                        ErrorMessage="Username is required."
                        CssClass="error-text" Display="Dynamic"
                        ValidationGroup="Register" />
                </div>

                <div class="hub-login-field">
                    <asp:Label runat="server" AssociatedControlID="txtPassword"
                        Text="Password *"></asp:Label>

                    <div class="hub-login-password">
                        <asp:TextBox ID="txtPassword" runat="server"
                            CssClass="hub-login-input"
                            TextMode="Password"
                            autocomplete="new-password"
                            placeholder="Choose a password"></asp:TextBox>

                        <button type="button" id="registerPasswordToggle"
                            class="hub-login-toggle"
                            aria-label="Show passwords"
                            aria-pressed="false"
                            aria-controls="<%= txtPassword.ClientID %> <%= txtConfirmPassword.ClientID %>"
                            hidden>
                            <i class="fa-solid fa-eye" aria-hidden="true"></i>
                        </button>
                    </div>

                    <asp:RequiredFieldValidator runat="server"
                        ControlToValidate="txtPassword"
                        ErrorMessage="Password is required."
                        CssClass="error-text" Display="Dynamic"
                        ValidationGroup="Register" />
                </div>

                <div class="hub-login-field">
                    <asp:Label runat="server" AssociatedControlID="txtConfirmPassword"
                        Text="Confirm password *"></asp:Label>
                    <asp:TextBox ID="txtConfirmPassword" runat="server"
                        CssClass="hub-login-input"
                        TextMode="Password"
                        autocomplete="new-password"
                        placeholder="Re-enter your password"></asp:TextBox>
                    <asp:RequiredFieldValidator runat="server"
                        ControlToValidate="txtConfirmPassword"
                        ErrorMessage="Confirm your password."
                        CssClass="error-text" Display="Dynamic"
                        ValidationGroup="Register" />
                    <asp:CompareValidator runat="server"
                        ControlToValidate="txtConfirmPassword"
                        ControlToCompare="txtPassword"
                        ErrorMessage="The passwords do not match."
                        CssClass="error-text" Display="Dynamic"
                        ValidationGroup="Register" />
                </div>

                <div class="register-section-heading">
                    <span>03</span>
                    <h3>Account recovery</h3>
                </div>

                <p class="register-recovery-help">
                    Your existing password reset process uses this question and answer.
                    Choose an answer you can remember.
                </p>

                <div class="hub-login-field">
                    <asp:Label runat="server" AssociatedControlID="ddlSecurityQuestion"
                        Text="Security question *"></asp:Label>

                    <asp:DropDownList ID="ddlSecurityQuestion" runat="server"
                        CssClass="hub-login-input">
                        <asp:ListItem Text="Choose a question" Value="" />
                        <asp:ListItem Text="What was the name of your first pet?"
                            Value="What was the name of your first pet?" />
                        <asp:ListItem Text="What city were you born in?"
                            Value="What city were you born in?" />
                        <asp:ListItem Text="What was the name of your first school?"
                            Value="What was the name of your first school?" />
                    </asp:DropDownList>

                    <asp:RequiredFieldValidator runat="server"
                        ControlToValidate="ddlSecurityQuestion"
                        InitialValue=""
                        ErrorMessage="Choose a security question."
                        CssClass="error-text" Display="Dynamic"
                        ValidationGroup="Register" />
                </div>

                <div class="hub-login-field">
                    <asp:Label runat="server" AssociatedControlID="txtSecurityAnswer"
                        Text="Security answer *"></asp:Label>
                    <asp:TextBox ID="txtSecurityAnswer" runat="server"
                        CssClass="hub-login-input"
                        autocomplete="off"
                        placeholder="Enter your answer"></asp:TextBox>
                    <asp:RequiredFieldValidator runat="server"
                        ControlToValidate="txtSecurityAnswer"
                        ErrorMessage="Security answer is required."
                        CssClass="error-text" Display="Dynamic"
                        ValidationGroup="Register" />
                </div>

                <asp:Label ID="lblError" runat="server"
                    CssClass="hub-login-error" role="alert"></asp:Label>

                <asp:Button ID="btnRegister" runat="server"
                    Text="Create Account / Submit Application"
                    CssClass="btn hub-login-submit"
                    ValidationGroup="Register"
                    OnClick="btnRegister_Click" />

                <div class="hub-login-divider">
                    <span>Already part of the hub?</span>
                </div>

                <a href="Login.aspx" class="btn hub-login-register">Sign In</a>
                <a href="Landing.aspx" class="hub-login-home">
                    <i class="fa-solid fa-arrow-left" aria-hidden="true"></i>
                    Back to Home
                </a>

            </asp:Panel>

            <asp:Panel ID="pnlConfirmation" runat="server"
                Visible="false" CssClass="register-confirmation">

                <div class="register-confirm-icon">
                    <i class="fa-solid fa-check" aria-hidden="true"></i>
                </div>

                <span class="hub-login-eyebrow">REGISTRATION SAVED</span>
                <h2>Welcome to the hub</h2>
                <p>Your details have been recorded successfully.</p>

                <div class="register-confirm-details">
                    <div>
                        <span>Name</span>
                        <strong><asp:Label ID="lblConfirmName" runat="server"></asp:Label></strong>
                    </div>
                    <div>
                        <span>Email</span>
                        <strong><asp:Label ID="lblConfirmEmail" runat="server"></asp:Label></strong>
                    </div>
                    <div>
                        <span>Account type</span>
                        <strong><asp:Label ID="lblConfirmRole" runat="server"></asp:Label></strong>
                    </div>
                    <div>
                        <span>Username</span>
                        <strong><asp:Label ID="lblConfirmUsername" runat="server"></asp:Label></strong>
                    </div>
                    <div>
                        <span>Account status</span>
                        <strong class='<%= rbTutor.Checked
                            ? "register-status pending"
                            : "register-status active" %>'>
                            <asp:Label ID="lblConfirmStatus" runat="server"></asp:Label>
                        </strong>
                    </div>
                </div>

                <asp:Panel ID="pnlTutorPendingNotice" runat="server"
                    Visible="false" CssClass="register-pending-note">
                    <i class="fa-solid fa-clock" aria-hidden="true"></i>
                    Your tutor account is awaiting administrator approval.
                    You will be able to sign in once approved.
                </asp:Panel>

                <a href="Login.aspx" class="btn hub-login-submit">
                    Go to Sign In
                </a>

            </asp:Panel>

        </div>
    </div>

    <script>
        (function () {
            var password = document.getElementById('<%= txtPassword.ClientID %>');
            var confirmation = document.getElementById('<%= txtConfirmPassword.ClientID %>');
            var toggle = document.getElementById('registerPasswordToggle');

            if (!password || !confirmation || !toggle) return;

            toggle.hidden = false;

            toggle.addEventListener('click', function () {
                var show = password.type === 'password';

                password.type = show ? 'text' : 'password';
                confirmation.type = show ? 'text' : 'password';

                toggle.setAttribute('aria-pressed', show ? 'true' : 'false');
                toggle.setAttribute('aria-label', show ? 'Hide passwords' : 'Show passwords');
                toggle.querySelector('i').className =
                    show ? 'fa-solid fa-eye-slash' : 'fa-solid fa-eye';
            });
        })();
    </script>

</asp:Content>