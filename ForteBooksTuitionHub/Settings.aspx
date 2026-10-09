<%@ Page Title="Settings" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Settings.aspx.cs" Inherits="ForteBooksTuitionHub.Settings" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="settings-workspace">

        <div class="management-page-header">
            <div class="management-header-icon">
                <i class="fa-solid fa-gear" aria-hidden="true"></i>
            </div>

            <div>
                <span class="management-eyebrow">
                    Forte Books &amp; Tuition Hub
                </span>
                <h2>Settings</h2>
                <p>Personalise your appearance and portal preferences.</p>
            </div>
        </div>

        <div class="settings-body">

            <section class="settings-section">
                <div class="settings-section-heading">
                    <h3>
                        <i class="fa-solid fa-palette"></i>
                        Appearance
                    </h3>
                    <p>Select your preferred theme. Theme changes save immediately.</p>
                </div>

                <div class="settings-theme-grid">
                    <asp:LinkButton ID="btnLight" runat="server"
                        CssClass="theme-option"
                        OnClick="btnLight_Click"
                        CausesValidation="false">

                        <i class="fa-solid fa-sun" aria-hidden="true"></i>

                        <span class="settings-theme-text">
                            <strong>Light Mode</strong>
                            <span>Soft blue-grey surfaces and light-blue accents.</span>
                        </span>
                    </asp:LinkButton>

                    <asp:LinkButton ID="btnDark" runat="server"
                        CssClass="theme-option"
                        OnClick="btnDark_Click"
                        CausesValidation="false">

                        <i class="fa-solid fa-moon" aria-hidden="true"></i>

                        <span class="settings-theme-text">
                            <strong>Dark Mode</strong>
                            <span>Darker surfaces for a lower-brightness workspace.</span>
                        </span>
                    </asp:LinkButton>
                </div>
            </section>

            <section class="settings-section">
                <div class="settings-section-heading">
                    <h3>
                        <i class="fa-solid fa-sliders"></i>
                        Preferences
                    </h3>
                    <p>Choose how your portal works after signing in.</p>
                </div>

                <div class="settings-preference">
                    <div>
                        <asp:Label ID="lblLandingPageCaption" runat="server"
                            AssociatedControlID="ddlLandingPage"
                            Text="Default landing page"
                            CssClass="settings-preference-title" />

                        <p>The page you see first after logging in.</p>
                    </div>

                    <asp:DropDownList ID="ddlLandingPage"
                        runat="server" />
                </div>

                <div class="settings-preference">
                    <div>
                        <asp:Label ID="lblNotificationsCaption" runat="server"
                            AssociatedControlID="chkNotifications"
                            Text="In-app notifications"
                            CssClass="settings-preference-title" />

                        <p>Bell-icon alerts for approvals, reminders and updates.</p>
                    </div>

                    <asp:CheckBox ID="chkNotifications" runat="server"
                        CssClass="settings-notification-check" />
                </div>
            </section>

            <asp:Label ID="lblMessage" runat="server"
                ForeColor="Green" Font-Bold="true"
                CssClass="settings-success" role="status" />

        </div>

        <div class="settings-save-bar">
            <span>Save your preferences when you are finished.</span>

            <asp:Button ID="btnSave" runat="server"
                Text="Save Settings" CssClass="btn btn-gold"
                OnClick="btnSave_Click" />
        </div>

    </div>

</asp:Content>