<%@ Page Title="My Profile" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="MyProfile.aspx.cs" Inherits="ForteBooksTuitionHub.MyProfile" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <h2><i class="fa-solid fa-id-badge"></i> My Profile</h2>

    <asp:Panel ID="pnlBalanceCard" runat="server" CssClass="balance-banner balance-settled">
        <div class="balance-banner-icon"><i class="fa-solid fa-wallet"></i></div>
        <div>
            <div class="balance-banner-label">Your Account Balance</div>
            <div class="balance-banner-amount"><asp:Label ID="lblBalanceAmount" runat="server"></asp:Label></div>
            <div class="balance-banner-meaning"><asp:Label ID="lblBalanceMeaning" runat="server"></asp:Label></div>
            <a href="TopUpBalance.aspx" class="btn btn-gold" style="margin-top:8px; display:inline-block;"><i class="fa-solid fa-wallet"></i> Top Up Balance</a>
        </div>
    </asp:Panel>

    <div style="display:flex; flex-wrap:wrap; gap:20px; margin-bottom:25px;">
        <div class="dash-card">
            <h3><i class="fa-solid fa-calendar-check"></i> Total Sessions</h3>
            <p class="value"><asp:Label ID="lblTotalSessions" runat="server"></asp:Label></p>
        </div>
        <div class="dash-card">
            <h3><i class="fa-solid fa-book"></i> Books On Loan</h3>
            <p class="value"><asp:Label ID="lblBooksOnLoan" runat="server"></asp:Label></p>
        </div>
    </div>

    <div class="form-box">
        <label>Full Name</label>
        <asp:TextBox ID="txtFullName" runat="server"></asp:TextBox>
        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtFullName"
            ErrorMessage="Full name is required." CssClass="error-text" Display="Dynamic" />

        <label>Email</label>
        <asp:TextBox ID="txtEmail" runat="server" TextMode="Email"></asp:TextBox>
        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtEmail"
            ErrorMessage="Email is required." CssClass="error-text" Display="Dynamic" />
        <asp:RegularExpressionValidator runat="server" ControlToValidate="txtEmail"
            ValidationExpression="^[^@\s]+@[^@\s]+\.[^@\s]+$"
            ErrorMessage="Enter a valid email address." CssClass="error-text" Display="Dynamic" />

        <label>Phone Number</label>
        <asp:TextBox ID="txtPhone" runat="server"></asp:TextBox>
        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtPhone"
            ErrorMessage="Phone number is required." CssClass="error-text" Display="Dynamic" />
        <asp:RegularExpressionValidator runat="server" ControlToValidate="txtPhone"
            ValidationExpression="^0\d{9}$"
            ErrorMessage="Enter a valid 10-digit phone number starting with 0." CssClass="error-text" Display="Dynamic" />

        <br /><br />
        <asp:Button ID="btnSave" runat="server" Text="Save Changes" CssClass="btn btn-gold" OnClick="btnSave_Click" />

        <br /><br />
        <asp:Label ID="lblMessage" runat="server" ForeColor="Green" Font-Bold="true"></asp:Label>
        <asp:Label ID="lblError" runat="server" CssClass="error-text"></asp:Label>
    </div>

</asp:Content>
