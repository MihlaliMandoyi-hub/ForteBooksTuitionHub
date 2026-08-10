<%@ Page Title="My Schedule" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="MySchedule.aspx.cs" Inherits="ForteBooksTuitionHub.MySchedule" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <h2><i class="fa-solid fa-calendar-week"></i> My Schedule</h2>

    <div style="margin-bottom:15px;">
        <asp:Button ID="btnPrevWeek" runat="server" Text="&laquo; Previous Week" CssClass="btn" OnClick="btnPrevWeek_Click" />
        <span style="margin:0 15px; font-weight:600; color:#112A43;"><asp:Label ID="lblWeekRange" runat="server"></asp:Label></span>
        <asp:Button ID="btnNextWeek" runat="server" Text="Next Week &raquo;" CssClass="btn" OnClick="btnNextWeek_Click" />
        <asp:Button ID="btnThisWeek" runat="server" Text="This Week" CssClass="btn btn-gold" OnClick="btnThisWeek_Click" />
    </div>

    <div style="display:flex; gap:10px; overflow-x:auto; padding-bottom:10px;">
        <asp:Literal ID="litSchedule" runat="server"></asp:Literal>
    </div>

</asp:Content>