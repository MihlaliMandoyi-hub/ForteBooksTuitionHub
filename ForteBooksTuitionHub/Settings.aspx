<%@ Page Title="Settings" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Settings.aspx.cs" Inherits="ForteBooksTuitionHub.Settings" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <h2><i class="fa-solid fa-gear"></i> Settings</h2>

    <div class="form-box" style="max-width:560px;">

        <h3 style="margin-top:0;"><i class="fa-solid fa-palette"></i> Appearance</h3>
        <label>Theme</label>
        <div>
            <asp:LinkButton ID="btnLight" runat="server" CssClass="theme-option" OnClick="btnLight_Click" CausesValidation="false">
                <i class="fa-solid fa-sun"></i>&nbsp; Light Mode
            </asp:LinkButton>
            <asp:LinkButton ID="btnDark" runat="server" CssClass="theme-option" OnClick="btnDark_Click" CausesValidation="false">
                <i class="fa-solid fa-moon"></i>&nbsp; Dark Mode
            </asp:LinkButton>
        </div>

        <h3 style="margin-top:25px;"><i class="fa-solid fa-sliders"></i> Preferences</h3>

        <div class="toggle-row">
            <div>
                <div class="toggle-row-label">Default landing page</div>
                <div class="toggle-row-desc">Which page you see first after logging in.</div>
            </div>
            <asp:DropDownList ID="ddlLandingPage" runat="server" style="padding:8px; border-radius:6px; border:1.5px solid var(--input-border);">
            </asp:DropDownList>
        </div>

        <div class="toggle-row">
            <div>
                <div class="toggle-row-label">In-app notifications</div>
                <div class="toggle-row-desc">Receive bell-icon alerts for approvals, reminders, and updates.</div>
            </div>
            <asp:CheckBox ID="chkNotifications" runat="server" />
        </div>

        <br />
        <asp:Button ID="btnSave" runat="server" Text="Save Settings" CssClass="btn btn-gold" OnClick="btnSave_Click" />

        <br /><br />
        <asp:Label ID="lblMessage" runat="server" ForeColor="Green" Font-Bold="true"></asp:Label>
    </div>

</asp:Content>