<%@ Page Title="Login" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="ForteBooksTuitionHub.Login" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="auth-wrapper">
        <div class="auth-visual">
            <img src="Images/ufh-logo.png" alt="University of Fort Hare" />
            <h3>Forte Books &amp; Tuition Hub</h3>
            <p>Manage bookings, book rentals, and payments in one place — built in partnership with the values of Together in Excellence.</p>
        </div>

        <div class="auth-form-side">
            <h2><i class="fa-solid fa-right-to-bracket"></i> Login</h2>

            <div class="form-box">

                <asp:Label ID="lblInfo" runat="server" ForeColor="Green" Font-Bold="true" style="display:block; margin-bottom:10px;"></asp:Label>

                <label>Username</label>
                <asp:TextBox ID="txtUsername" runat="server"></asp:TextBox>

                <label>Password</label>
                <div class="password-wrapper">
                    <asp:TextBox ID="txtPassword" runat="server" TextMode="Password"></asp:TextBox>
                    <i class="fa-solid fa-eye password-toggle-icon" id="iconLoginPassword"
                       onclick="togglePasswordVisibility('<%= txtPassword.ClientID %>', 'iconLoginPassword')"></i>
                </div>

                <br /><br />
                <asp:Button ID="btnLogin" runat="server" Text="Login" CssClass="btn btn-gold" OnClick="btnLogin_Click" />
                <a href="Register.aspx" class="btn">Create an Account</a>

                <br /><br />
                <a href="ForgotPassword.aspx"><i class="fa-solid fa-key"></i> Forgot your password?</a>

                <br /><br />
                <a href="Landing.aspx"><i class="fa-solid fa-arrow-left"></i> Back to Home</a>

                <br /><br />
                <asp:Label ID="lblError" runat="server" CssClass="error-text"></asp:Label>
            </div>
        </div>
    </div>

</asp:Content>
