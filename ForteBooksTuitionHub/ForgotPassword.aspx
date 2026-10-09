<%@ Page Title="Forgot Password" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ForgotPassword.aspx.cs" Inherits="ForteBooksTuitionHub.ForgotPassword" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="recovery-page">

        <div class="recovery-header">
            <img src="Images/ufh-logo.png"
                alt="University of Fort Hare"
                class="recovery-logo" />

            <span class="recovery-eyebrow">FORTE BOOKS &amp; TUITION HUB</span>
            <h2>Let’s get you back in</h2>
            <p>Recover access to your student or tutor account.</p>
        </div>

        <div class="recovery-progress" aria-label="Password recovery steps">
            <div>
                <span>01</span>
                <strong>Find account</strong>
            </div>
            <div>
                <span>02</span>
                <strong>Verify answer</strong>
            </div>
            <div>
                <span>03</span>
                <strong>New password</strong>
            </div>
        </div>

        <div class="recovery-body">

            <asp:Panel ID="pnlStep1" runat="server"
                DefaultButton="btnFindAccount">

                <div class="recovery-heading">
                    <div>
                        <i class="fa-solid fa-user" aria-hidden="true"></i>
                    </div>
                    <section>
                        <h3>Find your account</h3>
                        <p>Enter the username you normally sign in with.</p>
                    </section>
                </div>

                <asp:Label runat="server"
                    AssociatedControlID="txtUsername"
                    CssClass="recovery-label"
                    Text="Username"></asp:Label>

                <asp:TextBox ID="txtUsername" runat="server"
                    CssClass="recovery-input"
                    autocomplete="username"
                    autocapitalize="none"
                    spellcheck="false"
                    placeholder="Enter your username"></asp:TextBox>

                <asp:Button ID="btnFindAccount" runat="server"
                    Text="Find My Account"
                    CssClass="btn recovery-submit"
                    OnClick="btnFindAccount_Click" />

            </asp:Panel>

            <asp:Panel ID="pnlStep2" runat="server"
                Visible="false"
                DefaultButton="btnCheckAnswer">

                <div class="recovery-heading">
                    <div>
                        <i class="fa-solid fa-key" aria-hidden="true"></i>
                    </div>
                    <section>
                        <h3>Answer your security question</h3>
                        <p>Use the answer you provided when creating your account.</p>
                    </section>
                </div>

                <div class="recovery-account">
                    <i class="fa-solid fa-circle-user" aria-hidden="true"></i>
                    <span>Account</span>
                    <strong>
                        <asp:Label ID="lblFoundUsername" runat="server"></asp:Label>
                    </strong>
                </div>

                <asp:Label runat="server"
                    AssociatedControlID="txtSecurityAnswer"
                    CssClass="recovery-label">
                    <asp:Label ID="lblSecurityQuestion" runat="server"></asp:Label>
                </asp:Label>

                <asp:TextBox ID="txtSecurityAnswer" runat="server"
                    CssClass="recovery-input"
                    autocomplete="off"
                    placeholder="Enter your answer"></asp:TextBox>

                <asp:Button ID="btnCheckAnswer" runat="server"
                    Text="Verify My Answer"
                    CssClass="btn recovery-submit"
                    OnClick="btnCheckAnswer_Click" />

            </asp:Panel>

            <asp:Panel ID="pnlStep3" runat="server"
                Visible="false"
                DefaultButton="btnResetPassword">

                <div class="recovery-verified" role="status">
                    <i class="fa-solid fa-circle-check" aria-hidden="true"></i>
                    Identity confirmed. Choose your new password.
                </div>

                <div class="recovery-heading">
                    <div>
                        <i class="fa-solid fa-lock" aria-hidden="true"></i>
                    </div>
                    <section>
                        <h3>A fresh start</h3>
                        <p>Your new password must contain at least 6 characters.</p>
                    </section>
                </div>

                <asp:Label runat="server"
                    AssociatedControlID="txtNewPassword"
                    CssClass="recovery-label"
                    Text="New password"></asp:Label>

                <asp:TextBox ID="txtNewPassword" runat="server"
                    CssClass="recovery-input"
                    TextMode="Password"
                    autocomplete="new-password"
                    placeholder="Enter your new password"></asp:TextBox>

                <asp:Label runat="server"
                    AssociatedControlID="txtConfirmPassword"
                    CssClass="recovery-label recovery-confirm-label"
                    Text="Confirm new password"></asp:Label>

                <asp:TextBox ID="txtConfirmPassword" runat="server"
                    CssClass="recovery-input"
                    TextMode="Password"
                    autocomplete="new-password"
                    placeholder="Re-enter your new password"></asp:TextBox>

                <button type="button" id="recoveryPasswordToggle"
                    class="recovery-show-password"
                    aria-pressed="false"
                    aria-controls="<%= txtNewPassword.ClientID %> <%= txtConfirmPassword.ClientID %>"
                    hidden>
                    <i class="fa-solid fa-eye" aria-hidden="true"></i>
                    <span>Show passwords</span>
                </button>

                <asp:Button ID="btnResetPassword" runat="server"
                    Text="Save New Password"
                    CssClass="btn recovery-submit"
                    OnClick="btnResetPassword_Click" />

            </asp:Panel>

            <asp:Label ID="lblError" runat="server"
                CssClass="recovery-error"
                role="alert"></asp:Label>

            <a href="Login.aspx" class="recovery-back">
                <i class="fa-solid fa-arrow-left" aria-hidden="true"></i>
                Back to Sign In
            </a>

        </div>

        <div class="recovery-footer">
            <i class="fa-solid fa-circle-question" aria-hidden="true"></i>
            <span>
                Need help recovering your account?
                <a href="About.aspx">Contact the centre</a>.
            </span>
        </div>

    </div>

    <script>
        (function () {
            var password = document.getElementById('<%= txtNewPassword.ClientID %>');
            var confirmation = document.getElementById('<%= txtConfirmPassword.ClientID %>');
            var toggle = document.getElementById('recoveryPasswordToggle');

            if (!password || !confirmation || !toggle) return;

            toggle.hidden = false;

            toggle.addEventListener('click', function () {
                var show = password.type === 'password';

                password.type = show ? 'text' : 'password';
                confirmation.type = show ? 'text' : 'password';

                toggle.setAttribute('aria-pressed', show ? 'true' : 'false');
                toggle.querySelector('span').textContent =
                    show ? 'Hide passwords' : 'Show passwords';
                toggle.querySelector('i').className =
                    show ? 'fa-solid fa-eye-slash' : 'fa-solid fa-eye';
            });
        })();
    </script>

</asp:Content>