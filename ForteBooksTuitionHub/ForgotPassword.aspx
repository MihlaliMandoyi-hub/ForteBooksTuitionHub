<%@ Page Title="Forgot Password" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ForgotPassword.aspx.cs" Inherits="ForteBooksTuitionHub.ForgotPassword" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <h2><i class="fa-solid fa-key"></i> Reset Your Password</h2>

    <div class="form-box">

        <asp:Panel ID="pnlStep1" runat="server">
            <label>Username</label>
            <asp:TextBox ID="txtUsername" runat="server"></asp:TextBox>
            <br /><br />
            <asp:Button ID="btnFindAccount" runat="server" Text="Find My Account" CssClass="btn btn-gold" OnClick="btnFindAccount_Click" />
        </asp:Panel>

        <asp:Panel ID="pnlStep2" runat="server" Visible="false">
            <p><i class="fa-solid fa-circle-user"></i> Account: <strong><asp:Label ID="lblFoundUsername" runat="server"></asp:Label></strong></p>
            <label><asp:Label ID="lblSecurityQuestion" runat="server"></asp:Label></label>
            <asp:TextBox ID="txtSecurityAnswer" runat="server"></asp:TextBox>
            <br /><br />
            <asp:Button ID="btnCheckAnswer" runat="server" Text="Submit Answer" CssClass="btn btn-gold" OnClick="btnCheckAnswer_Click" />
        </asp:Panel>

        <asp:Panel ID="pnlStep3" runat="server" Visible="false">
            <p><i class="fa-solid fa-circle-check" style="color:green;"></i> Identity confirmed. Choose a new password.</p>

            <label>New Password <span style="font-weight:normal; text-transform:none;">(at least 6 characters)</span></label>
            <asp:TextBox ID="txtNewPassword" runat="server" TextMode="Password"></asp:TextBox>

            <label>Confirm New Password</label>
            <asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password"></asp:TextBox>

            <br /><br />
            <asp:Button ID="btnResetPassword" runat="server" Text="Reset Password" CssClass="btn btn-gold" OnClick="btnResetPassword_Click" />
        </asp:Panel>

        <br />
        <asp:Label ID="lblError" runat="server" CssClass="error-text"></asp:Label>
        <a href="Login.aspx"><i class="fa-solid fa-arrow-left"></i> Back to Login</a>
    </div>

</asp:Content>