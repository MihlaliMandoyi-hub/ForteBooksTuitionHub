<%@ Page Title="Tutor Utilisation" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="TutorUtilisation.aspx.cs" Inherits="ForteBooksTuitionHub.TutorUtilisation" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <h2><i class="fa-solid fa-chart-simple"></i> Tutor Utilisation Report</h2>
    <div class="no-print" style="margin-bottom:15px;">
        <a href="Tutors.aspx" class="btn">&laquo; Back to Tutors</a>
        <asp:Button ID="btnPrint" runat="server" Text="Print This Report" CssClass="btn btn-gold" OnClientClick="window.print(); return false;" />
        <asp:Button ID="btnExport" runat="server" Text="Download as CSV" CssClass="btn btn-gold" OnClick="btnExport_Click" CausesValidation="false" />
    </div>

    <asp:GridView ID="gvUtilisation" runat="server" AutoGenerateColumns="false" CssClass="grid" GridLines="None">
        <Columns>
            <asp:BoundField DataField="FullName" HeaderText="Tutor" />
            <asp:BoundField DataField="Subject" HeaderText="Subject" />
            <asp:BoundField DataField="AvailableHoursPerWeek" HeaderText="Available Hours / Week" />
            <asp:BoundField DataField="SessionsBooked" HeaderText="Sessions Booked" />
            <asp:BoundField DataField="ApprovedHours" HeaderText="Approved Hours Logged" DataFormatString="{0:N1}" />
        </Columns>
        <EmptyDataTemplate>
            No tutors found.
        </EmptyDataTemplate>
    </asp:GridView>

</asp:Content>