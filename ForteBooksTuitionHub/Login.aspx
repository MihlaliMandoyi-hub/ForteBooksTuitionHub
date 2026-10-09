<%@ Page Title="Login" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="ForteBooksTuitionHub.Login" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="hub-login">

        <section class="hub-login-welcome">

            <img class="hub-login-logo"
                src="Images/ufh-logo.png"
                alt="University of Fort Hare" />

            <span class="hub-login-eyebrow">FORTE BOOKS &amp; TUITION HUB</span>

            <h2>Your next chapter<br />starts here.</h2>

            <p class="hub-login-intro">
                A place for learning, connection and progress.
                Sign in to manage your activity at the hub.
            </p>

            <div class="hub-login-features">

                <div>
                    <span><i class="fa-solid fa-calendar-check" aria-hidden="true"></i></span>
                    <div>
                        <strong>Stay organised</strong>
                        <p>Keep your sessions and schedule together.</p>
                    </div>
                </div>

                <div>
                    <span><i class="fa-solid fa-book-open" aria-hidden="true"></i></span>
                    <div>
                        <strong>Discover more</strong>
                        <p>Explore books and keep track of your rentals.</p>
                    </div>
                </div>

                <div>
                    <span><i class="fa-solid fa-comments" aria-hidden="true"></i></span>
                    <div>
                        <strong>Stay connected</strong>
                        <p>Access your session conversations and notifications.</p>
                    </div>
                </div>

            </div>

            <div class="hub-login-signature">
                <i class="fa-solid fa-graduation-cap" aria-hidden="true"></i>
                <span>InnovaTech Hub</span>
            </div>

        </section>

        <asp:Panel ID="pnlLoginForm" runat="server"
            CssClass="hub-login-form"
            DefaultButton="btnLogin">

            <div class="hub-login-heading-icon">
                <i class="fa-solid fa-right-to-bracket" aria-hidden="true"></i>
            </div>

            <span class="hub-login-eyebrow">WELCOME BACK</span>
            <h2>Sign in to your account</h2>
            <p class="hub-login-form-intro">
                Enter your username and password to continue.
            </p>

            <div class='<%= Request.QueryString["registered"] == "tutor"
                ? "hub-login-notice is-pending"
                : "hub-login-notice is-success" %>'>

                <asp:Label ID="lblInfo" runat="server"
                    role="status"></asp:Label>

            </div>

            <div class="hub-login-field">
                <asp:Label ID="lblUsernameCaption" runat="server"
                    AssociatedControlID="txtUsername"
                    Text="Username"></asp:Label>

                <asp:TextBox ID="txtUsername" runat="server"
                    CssClass="hub-login-input"
                    autocomplete="username"
                    autocapitalize="none"
                    spellcheck="false"
                    placeholder="Enter your username"></asp:TextBox>
            </div>

            <div class="hub-login-field">
                <asp:Label ID="lblPasswordCaption" runat="server"
                    AssociatedControlID="txtPassword"
                    Text="Password"></asp:Label>

                <div class="hub-login-password">
                    <asp:TextBox ID="txtPassword" runat="server"
                        TextMode="Password"
                        CssClass="hub-login-input"
                        autocomplete="current-password"
                        placeholder="Enter your password"></asp:TextBox>

                    <button type="button" id="hubPasswordToggle"
                        class="hub-login-toggle"
                        aria-label="Show password"
                        aria-pressed="false"
                        aria-controls="<%= txtPassword.ClientID %>"
                        hidden>
                        <i class="fa-solid fa-eye" aria-hidden="true"></i>
                    </button>
                </div>
            </div>

            <div class="hub-login-forgot">
                <a href="ForgotPassword.aspx">
                    <i class="fa-solid fa-key" aria-hidden="true"></i>
                    Forgot your password?
                </a>
            </div>

            <asp:Label ID="lblError" runat="server"
                CssClass="hub-login-error"
                role="alert"></asp:Label>

            <asp:Button ID="btnLogin" runat="server"
                Text="Sign In"
                CssClass="btn hub-login-submit"
                OnClick="btnLogin_Click" />

            <div class="hub-login-divider">
                <span>New to the hub?</span>
            </div>

            <a href="Register.aspx" class="btn hub-login-register">
                Create an Account
            </a>

            <a href="Landing.aspx" class="hub-login-home">
                <i class="fa-solid fa-arrow-left" aria-hidden="true"></i>
                Back to Home
            </a>

        </asp:Panel>

    </div>

    <script>
        (function () {
            var password = document.getElementById('<%= txtPassword.ClientID %>');
            var toggle = document.getElementById('hubPasswordToggle');

            if (!password || !toggle) return;

            toggle.hidden = false;

            toggle.addEventListener('click', function () {
                var show = password.type === 'password';

                password.type = show ? 'text' : 'password';
                toggle.setAttribute('aria-pressed', show ? 'true' : 'false');
                toggle.setAttribute('aria-label', show ? 'Hide password' : 'Show password');

                toggle.querySelector('i').className =
                    show ? 'fa-solid fa-eye-slash' : 'fa-solid fa-eye';
            });
        })();
    </script>

</asp:Content>
