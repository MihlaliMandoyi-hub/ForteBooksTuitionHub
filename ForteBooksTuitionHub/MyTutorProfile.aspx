<%@ Page Title="My Profile" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="MyTutorProfile.aspx.cs" Inherits="ForteBooksTuitionHub.MyTutorProfile" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <h2><i class="fa-solid fa-id-badge"></i> My Profile</h2>

    <div style="display:flex; flex-wrap:wrap; gap:20px; margin-bottom:25px;">
        <div class="dash-card">
            <h3><i class="fa-solid fa-calendar-check"></i> Sessions Booked</h3>
            <p class="value"><asp:Label ID="lblTotalSessions" runat="server"></asp:Label></p>
        </div>
        <div class="dash-card">
            <h3><i class="fa-solid fa-clock"></i> Approved Hours</h3>
            <p class="value"><asp:Label ID="lblApprovedHours" runat="server"></asp:Label></p>
        </div>
        <div class="dash-card">
            <h3><i class="fa-solid fa-calendar-days"></i> Weekly Availability</h3>
            <p class="value"><asp:Label ID="lblAvailableHours" runat="server"></asp:Label> hrs</p>
        </div>
        <div class="dash-card earnings">
            <h3><i class="fa-solid fa-star"></i> Average Rating</h3>
            <p class="value"><asp:Label ID="lblAvgRating" runat="server"></asp:Label></p>
            <span class="stars"><asp:Label ID="lblAvgStars" runat="server"></asp:Label></span>
        </div>
    </div>

    <h3><i class="fa-solid fa-sack-dollar"></i> Earnings &amp; Payouts</h3>
    <div style="display:flex; flex-wrap:wrap; gap:20px; margin-bottom:25px;">
        <div class="dash-card earnings">
            <h3><i class="fa-solid fa-wallet"></i> Net Earnings (All-Time)</h3>
            <p class="value">R<asp:Label ID="lblNetEarnings" runat="server"></asp:Label></p>
        </div>
        <div class="dash-card">
            <h3><i class="fa-solid fa-circle-check"></i> Already Paid Out</h3>
            <p class="value">R<asp:Label ID="lblPaidOut" runat="server"></asp:Label></p>
        </div>
        <div class="dash-card alert">
            <h3><i class="fa-solid fa-hourglass-half"></i> Still Owed to You</h3>
            <p class="value">R<asp:Label ID="lblStillOwed" runat="server"></asp:Label></p>
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

        <label>Subject / Specialty</label>
        <asp:TextBox ID="txtSubject" runat="server"></asp:TextBox>
        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtSubject"
            ErrorMessage="Subject is required." CssClass="error-text" Display="Dynamic" />

        <label>Hourly Rate (R)</label>
        <asp:TextBox ID="txtHourlyRate" runat="server"></asp:TextBox>
        <asp:RegularExpressionValidator runat="server" ControlToValidate="txtHourlyRate"
            ValidationExpression="^\d+(\.\d{1,2})?$"
            ErrorMessage="Enter a valid amount (e.g. 150 or 150.00)." CssClass="error-text" Display="Dynamic" />

        <br /><br />
        <asp:Button ID="btnSave" runat="server" Text="Save Changes" CssClass="btn btn-gold" OnClick="btnSave_Click" />

        <br /><br />
        <asp:Label ID="lblMessage" runat="server" ForeColor="Green" Font-Bold="true"></asp:Label>
        <asp:Label ID="lblError" runat="server" CssClass="error-text"></asp:Label>
    </div>

    <h3 style="margin-top:30px;"><i class="fa-solid fa-comments"></i> Recent Feedback</h3>
    <asp:GridView ID="gvFeedback" runat="server" AutoGenerateColumns="false" CssClass="grid" GridLines="None">
        <Columns>
            <asp:TemplateField HeaderText="Rating">
                <ItemTemplate><asp:Label runat="server" CssClass="stars" Text='<%# new string((char)9733, Convert.ToInt32(Eval("Rating"))) + new string((char)9734, 5 - Convert.ToInt32(Eval("Rating"))) %>'></asp:Label></ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="StudentName" HeaderText="Student" />
            <asp:BoundField DataField="Comment" HeaderText="Comment" />
            <asp:BoundField DataField="CreatedDate" HeaderText="Date" DataFormatString="{0:yyyy-MM-dd}" />
        </Columns>
        <EmptyDataTemplate>No feedback received yet.</EmptyDataTemplate>
    </asp:GridView>

</asp:Content>