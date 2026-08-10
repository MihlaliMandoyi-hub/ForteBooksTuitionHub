<%@ Page Title="Book Session" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="SessionAdd.aspx.cs" Inherits="ForteBooksTuitionHub.SessionAdd" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <asp:Panel ID="pnlForm" runat="server">
        <h2><i class="fa-solid fa-calendar-plus"></i> Book New Session</h2>

        <div class="form-box">
            <label>Student</label>
            <asp:DropDownList ID="ddlStudent" runat="server" style="padding:8px; width:100%;"
                DataTextField="FullName" DataValueField="StudentId" AppendDataBoundItems="true">
                <asp:ListItem Text="-- Select Student --" Value="0" />
            </asp:DropDownList>

            <label>Tutor</label>
            <asp:DropDownList ID="ddlTutor" runat="server" style="padding:8px; width:100%;"
                DataTextField="FullName" DataValueField="TutorId" AppendDataBoundItems="true"
                AutoPostBack="true" OnSelectedIndexChanged="ddlTutor_SelectedIndexChanged">
                <asp:ListItem Text="-- Select Tutor --" Value="0" />
            </asp:DropDownList>

            <asp:Panel ID="pnlTutorAvailability" runat="server" Visible="false">
                <p style="margin-top:10px;"><strong><i class="fa-solid fa-calendar-days"></i> This tutor's availability:</strong></p>
                <asp:Label ID="lblAvailability" runat="server" style="display:block; margin-bottom:10px;"></asp:Label>
            </asp:Panel>

            <label>Session Date</label>
            <asp:TextBox ID="txtSessionDate" runat="server" TextMode="Date"></asp:TextBox>

            <label>Start Time</label>
            <asp:TextBox ID="txtStartTime" runat="server" TextMode="Time"></asp:TextBox>

            <label>End Time</label>
            <asp:TextBox ID="txtEndTime" runat="server" TextMode="Time"></asp:TextBox>

            <br /><br />
            <asp:Button ID="btnBook" runat="server" Text="Book Session" CssClass="btn btn-gold" OnClick="btnBook_Click" />
            <a href="Sessions.aspx" class="btn">Cancel</a>

            <br /><br />
            <asp:Label ID="lblError" runat="server" CssClass="error-text"></asp:Label>
        </div>
    </asp:Panel>

    <asp:Panel ID="pnlConfirmation" runat="server" Visible="false">
        <h2><i class="fa-solid fa-envelope-circle-check"></i> Booking Confirmation</h2>

        <div class="email-receipt">
            <div class="email-receipt-header">
                <div class="subject"><i class="fa-solid fa-calendar-check"></i> Your tutoring session is confirmed</div>
                <div class="meta"><%: DateTime.Now.ToString("yyyy-MM-dd HH:mm") %></div>
            </div>
            <div class="email-receipt-body">
                <div class="greeting">Session Booked Successfully</div>

                <div class="email-receipt-row"><span class="label">Student</span><span class="value"><asp:Label ID="lblConfirmStudent" runat="server"></asp:Label></span></div>
                <div class="email-receipt-row"><span class="label">Tutor</span><span class="value"><asp:Label ID="lblConfirmTutor" runat="server"></asp:Label></span></div>
                <div class="email-receipt-row"><span class="label">Date</span><span class="value"><asp:Label ID="lblConfirmDate" runat="server"></asp:Label></span></div>
                <div class="email-receipt-row"><span class="label">Time</span><span class="value"><asp:Label ID="lblConfirmTime" runat="server"></asp:Label></span></div>

                <br />
                <a href="Sessions.aspx" class="btn btn-gold"><i class="fa-solid fa-list"></i> View My Sessions</a>
            </div>
        </div>
    </asp:Panel>

</asp:Content>
