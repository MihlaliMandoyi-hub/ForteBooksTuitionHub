<%@ Page Title="Access Denied" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="AccessDenied.aspx.cs" Inherits="ForteBooksTuitionHub.AccessDenied" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="access-page">

        <div class="access-illustration" aria-hidden="true">
            <div class="access-icon">
                <i class="fa-solid fa-lock"></i>
            </div>
            <span class="access-key">
                <i class="fa-solid fa-key"></i>
            </span>
        </div>

        <span class="access-eyebrow">FORTE BOOKS &amp; TUITION HUB</span>

        <h2>This page is restricted</h2>

        <p class="access-description">
            Your current account does not have permission to view this page.
            Return to your dashboard to access the services available to you.
        </p>

        <div class="access-actions">
            <% if (Session["Username"] != null) { %>

                <a href="Default.aspx" class="btn access-primary">
                    <i class="fa-solid fa-house" aria-hidden="true"></i>
                    Back to Dashboard
                </a>

            <% } else { %>

                <a href="Login.aspx" class="btn access-primary">
                    <i class="fa-solid fa-right-to-bracket" aria-hidden="true"></i>
                    Sign In
                </a>

            <% } %>

            <a href="About.aspx" class="btn access-secondary">
                <i class="fa-solid fa-circle-question" aria-hidden="true"></i>
                Contact the Centre
            </a>
        </div>

        <div class="access-help">
            <i class="fa-solid fa-circle-info" aria-hidden="true"></i>
            <p>
                Think you should have access?
                Ask the centre to check your account role and permissions.
            </p>
        </div>

        <div class="access-signature">
            <i class="fa-solid fa-graduation-cap" aria-hidden="true"></i>
            InnovaTech Hub
        </div>

    </div>

</asp:Content>