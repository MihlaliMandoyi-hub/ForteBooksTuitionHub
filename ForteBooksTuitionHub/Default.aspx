<%@ Page Title="Home" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="ForteBooksTuitionHub._Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <h2><i class="fa-solid fa-gauge"></i> Dashboard</h2>

    <!-- ===================== ADMIN DASHBOARD ===================== -->
    <asp:Panel ID="pnlAdminDashboard" runat="server" Visible="false">
        <p>Welcome back, Admin. Here's what's happening across the centre.</p>

        <div class="admin-dashboard-grid">

            <asp:Panel ID="pnlPendingTutors" runat="server" Visible="false">
                <div class="dash-card alert">
                    <h3><i class="fa-solid fa-user-clock"></i> Pending Tutor Applications</h3>
                    <p class="value"><asp:Label ID="lblPendingTutors" runat="server"></asp:Label></p>
                    <a href="TutorApprovals.aspx" class="btn btn-danger">Review Now</a>
                </div>
            </asp:Panel>

            <div class="dash-card">
                <h3><i class="fa-solid fa-user-graduate"></i> Students</h3>
                <p class="value"><asp:Label ID="lblStudentCount" runat="server"></asp:Label></p>
                <a href="Students.aspx" class="btn">View</a>
            </div>

            <div class="dash-card">
                <h3><i class="fa-solid fa-chalkboard-user"></i> Tutors</h3>
                <p class="value"><asp:Label ID="lblTutorCount" runat="server"></asp:Label></p>
                <a href="Tutors.aspx" class="btn">View</a>
            </div>

            <div class="dash-card">
                <h3><i class="fa-solid fa-calendar-check"></i> Sessions Booked</h3>
                <p class="value"><asp:Label ID="lblSessionCount" runat="server"></asp:Label></p>
                <a href="Sessions.aspx" class="btn">View</a>
            </div>

            <div class="dash-card">
                <h3><i class="fa-solid fa-book"></i> Books on Loan</h3>
                <p class="value"><asp:Label ID="lblOnLoanCount" runat="server"></asp:Label></p>
                <a href="BookRentals.aspx" class="btn">View</a>
            </div>

            <div class="dash-card alert">
                <h3><i class="fa-solid fa-triangle-exclamation"></i> Overdue Books</h3>
                <p class="value"><asp:Label ID="lblOverdueCount" runat="server"></asp:Label></p>
                <a href="OverdueBooks.aspx" class="btn btn-danger">View</a>
            </div>

            <div class="dash-card">
                <h3><i class="fa-solid fa-clock"></i> Pending Timesheets</h3>
                <p class="value"><asp:Label ID="lblPendingTimesheets" runat="server"></asp:Label></p>
                <a href="Timesheets.aspx" class="btn">View</a>
            </div>

            <div class="dash-card">
                <h3><i class="fa-solid fa-money-bill-wave"></i> Total Revenue</h3>
                <p class="value">R<asp:Label ID="lblRevenue" runat="server"></asp:Label></p>
                <a href="Payments.aspx" class="btn">View</a>
            </div>

            <div class="dash-card earnings">
                <h3><i class="fa-solid fa-sack-dollar"></i> Commission Earned (5%)</h3>
                <p class="value">R<asp:Label ID="lblCommissionEarned" runat="server"></asp:Label></p>
                <a href="Tutors.aspx" class="btn btn-gold">View Tutors</a>
            </div>

            <div class="dash-card alert">
                <h3><i class="fa-solid fa-scale-balanced"></i> Owed to Tutors</h3>
                <p class="value">R<asp:Label ID="lblOwedToTutors" runat="server"></asp:Label></p>
                <a href="TutorPayouts.aspx" class="btn btn-danger">Manage Payouts</a>
            </div>

        </div>
    </asp:Panel>

    <!-- ===================== TUTOR DASHBOARD ===================== -->
    <asp:Panel ID="pnlTutorDashboard" runat="server" Visible="false">
        <p>Welcome back! Here's a summary of your tutoring activity.</p>

        <div style="display:flex; flex-wrap:wrap; gap:20px; margin-top:20px;">

            <div class="dash-card">
                <h3><i class="fa-solid fa-calendar-check"></i> Upcoming Sessions</h3>
                <p class="value"><asp:Label ID="lblUpcomingSessions" runat="server"></asp:Label></p>
                <a href="Sessions.aspx" class="btn">View</a>
            </div>

            <div class="dash-card">
                <h3><i class="fa-solid fa-hourglass-half"></i> Pending Timesheets</h3>
                <p class="value"><asp:Label ID="lblMyPendingTimesheets" runat="server"></asp:Label></p>
                <a href="Timesheets.aspx" class="btn">View</a>
            </div>

            <div class="dash-card">
                <h3><i class="fa-solid fa-clock"></i> Approved Hours</h3>
                <p class="value"><asp:Label ID="lblMyApprovedHours" runat="server"></asp:Label></p>
                <a href="Timesheets.aspx" class="btn">View</a>
            </div>

            <div class="dash-card">
                <h3><i class="fa-solid fa-circle-check"></i> Sessions Completed</h3>
                <p class="value"><asp:Label ID="lblCompletedSessions" runat="server"></asp:Label></p>
                <a href="Sessions.aspx" class="btn">View</a>
            </div>

        </div>

        <h3 style="margin-top:30px;"><i class="fa-solid fa-sack-dollar"></i> My Earnings</h3>
        <div style="display:flex; flex-wrap:wrap; gap:20px; margin-top:10px;">

            <div class="dash-card earnings">
                <h3><i class="fa-solid fa-coins"></i> Gross Earnings</h3>
                <p class="value">R<asp:Label ID="lblGrossEarnings" runat="server"></asp:Label></p>
            </div>

            <div class="dash-card alert">
                <h3><i class="fa-solid fa-scissors"></i> Admin Commission (5%)</h3>
                <p class="value">-R<asp:Label ID="lblCommissionDeducted" runat="server"></asp:Label></p>
            </div>

            <div class="dash-card">
                <h3><i class="fa-solid fa-wallet"></i> Net Earnings</h3>
                <p class="value" style="color:#1B7A3D;">R<asp:Label ID="lblNetEarnings" runat="server"></asp:Label></p>
            </div>

        </div>

        <div style="display:flex; flex-wrap:wrap; gap:20px; margin-top:15px;">
            <div class="dash-card">
                <h3><i class="fa-solid fa-circle-check"></i> Already Paid Out</h3>
                <p class="value">R<asp:Label ID="lblPaidOut" runat="server"></asp:Label></p>
            </div>
            <div class="dash-card alert">
                <h3><i class="fa-solid fa-hourglass-half"></i> Still Owed to You</h3>
                <p class="value">R<asp:Label ID="lblStillOwed" runat="server"></asp:Label></p>
            </div>
            <div class="dash-card earnings">
                <h3><i class="fa-solid fa-star"></i> Average Rating</h3>
                <p class="value"><asp:Label ID="lblAvgRating" runat="server"></asp:Label></p>
            </div>
        </div>

        <p style="font-size:12px; color:#7A8699; margin-top:10px;">
            <i class="fa-solid fa-circle-info"></i> Earnings are calculated from sessions you've marked as
            <strong>Completed</strong>, at your hourly rate, less the centre's 5% commission. Payouts are recorded by the Administrator.
        </p>
    </asp:Panel>

    <!-- ===================== STUDENT DASHBOARD ===================== -->
    <asp:Panel ID="pnlStudentDashboard" runat="server" Visible="false">
        <p>Welcome back! Here's where things stand for you.</p>

        <asp:Panel ID="pnlBalanceCard" runat="server" CssClass="balance-banner balance-settled">
            <div class="balance-banner-icon"><i class="fa-solid fa-wallet"></i></div>
            <div>
                <div class="balance-banner-label">Your Account Balance</div>
                <div class="balance-banner-amount"><asp:Label ID="lblBalanceAmount" runat="server"></asp:Label></div>
                <div class="balance-banner-meaning"><asp:Label ID="lblBalanceMeaning" runat="server"></asp:Label></div>
                <a href="TopUpBalance.aspx" class="btn btn-gold" style="margin-top:8px; display:inline-block;"><i class="fa-solid fa-wallet"></i> Top Up Balance</a>
            </div>
        </asp:Panel>

        <div style="display:flex; flex-wrap:wrap; gap:20px;">

            <div class="dash-card">
                <h3><i class="fa-solid fa-calendar-check"></i> Upcoming Sessions</h3>
                <p class="value"><asp:Label ID="lblStudentUpcomingSessions" runat="server"></asp:Label></p>
                <a href="Sessions.aspx" class="btn">View</a>
            </div>

            <div class="dash-card">
                <h3><i class="fa-solid fa-book"></i> Books On Loan</h3>
                <p class="value"><asp:Label ID="lblMyBooksOnLoan" runat="server"></asp:Label></p>
                <a href="MyRentals.aspx" class="btn">View</a>
            </div>

            <asp:Panel ID="pnlMyOverdueAlert" runat="server" Visible="false">
                <div class="dash-card alert">
                    <h3><i class="fa-solid fa-triangle-exclamation"></i> Overdue Books</h3>
                    <p class="value"><asp:Label ID="lblMyOverdueBooks" runat="server"></asp:Label></p>
                    <a href="MyRentals.aspx" class="btn btn-danger">Pay Fine</a>
                </div>
            </asp:Panel>

            <div class="dash-card">
                <h3><i class="fa-solid fa-book-open"></i> Book Catalogue</h3>
                <p class="value"><i class="fa-solid fa-arrow-right"></i></p>
                <a href="BookCatalogue.aspx" class="btn btn-gold">Browse Books</a>
            </div>

        </div>
    </asp:Panel>

</asp:Content>