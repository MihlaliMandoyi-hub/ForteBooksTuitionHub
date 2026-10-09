<%@ Page Title="My Schedule" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="MySchedule.aspx.cs" Inherits="ForteBooksTuitionHub.MySchedule" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="schedule-workspace">

        <div class="management-page-header">
            <div class="management-header-icon">
                <i class="fa-solid fa-calendar-week" aria-hidden="true"></i>
            </div>

            <div>
                <span class="management-eyebrow">
                    Forte Books &amp; Tuition Hub
                </span>
                <h2>My Schedule</h2>
                <p>Your week at a glance—session times, people and venues.</p>
            </div>
        </div>

        <div class="schedule-navigation">
            <div class="schedule-week-title">
                <span>Viewing week</span>
                <h3>
                    <asp:Label ID="lblWeekRange" runat="server" />
                </h3>
            </div>

            <div class="schedule-navigation-actions">
                <asp:Button ID="btnPrevWeek" runat="server"
                    Text="&laquo; Previous Week"
                    CssClass="btn schedule-week-button"
                    OnClick="btnPrevWeek_Click" />

                <asp:Button ID="btnThisWeek" runat="server"
                    Text="This Week"
                    CssClass="btn btn-gold"
                    OnClick="btnThisWeek_Click" />

                <asp:Button ID="btnNextWeek" runat="server"
                    Text="Next Week &raquo;"
                    CssClass="btn schedule-week-button"
                    OnClick="btnNextWeek_Click" />
            </div>
        </div>

        <div class="schedule-legend">
            <span>
                <span class="schedule-dot schedule-dot-booked"></span>
                Booked
            </span>

            <span>
                <span class="schedule-dot schedule-dot-completed"></span>
                Completed
            </span>

            <span>
                <span class="schedule-dot schedule-dot-cancelled"></span>
                Cancelled
            </span>

            <span class="schedule-today-key">Gold border = today</span>
        </div>

        <div class="schedule-calendar-wrap" tabindex="0"
            role="region" aria-label="Weekly session planner">

            <div class="schedule-board">
                <asp:Literal ID="litSchedule" runat="server" />
            </div>

        </div>

        <div class="schedule-footer">
            <span>Need more details or want to send a message?</span>
            <a href="Sessions.aspx">Open My Sessions &raquo;</a>
        </div>

    </div>

</asp:Content>