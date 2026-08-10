<%@ Page Title="Rate Session" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="RateSession.aspx.cs" Inherits="ForteBooksTuitionHub.RateSession" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <h2><i class="fa-solid fa-star"></i> Rate Your Session</h2>

    <asp:Panel ID="pnlNotFound" runat="server" Visible="false">
        <div class="error-text"><i class="fa-solid fa-circle-exclamation"></i> This session was not found, doesn't belong to you, isn't completed yet, or has already been rated.</div>
        <br />
        <a href="Sessions.aspx" class="btn">Back to My Sessions</a>
    </asp:Panel>

    <asp:Panel ID="pnlForm" runat="server" Visible="false">
        <div class="form-box">
            <p><i class="fa-solid fa-chalkboard-user"></i> Tutor: <strong><asp:Label ID="lblTutorName" runat="server"></asp:Label></strong></p>
            <p><i class="fa-solid fa-calendar"></i> Date: <asp:Label ID="lblSessionDate" runat="server"></asp:Label></p>

            <label>How would you rate this session?</label>
            <asp:DropDownList ID="ddlRating" runat="server" style="padding:8px; width:100%;">
                <asp:ListItem Text="&#9733;&#9734;&#9734;&#9734;&#9734;  (1 - Poor)" Value="1" />
                <asp:ListItem Text="&#9733;&#9733;&#9734;&#9734;&#9734;  (2 - Below Average)" Value="2" />
                <asp:ListItem Text="&#9733;&#9733;&#9733;&#9734;&#9734;  (3 - Average)" Value="3" />
                <asp:ListItem Text="&#9733;&#9733;&#9733;&#9733;&#9734;  (4 - Good)" Value="4" Selected="True" />
                <asp:ListItem Text="&#9733;&#9733;&#9733;&#9733;&#9733;  (5 - Excellent)" Value="5" />
            </asp:DropDownList>

            <label>Comments (optional)</label>
            <asp:TextBox ID="txtComment" runat="server" TextMode="MultiLine" Rows="3" placeholder="What went well? Anything to improve?"></asp:TextBox>

            <br /><br />
            <asp:Button ID="btnSubmit" runat="server" Text="Submit Rating" CssClass="btn btn-gold" OnClick="btnSubmit_Click" />
            <a href="Sessions.aspx" class="btn">Cancel</a>
        </div>
    </asp:Panel>

    <asp:Panel ID="pnlSuccess" runat="server" Visible="false">
        <div class="dash-card" style="max-width:400px; border-top-color:#1B7A3D;">
            <h3><i class="fa-solid fa-circle-check" style="color:#1B7A3D;"></i> Thank You!</h3>
            <p>Your rating has been submitted.</p>
            <a href="Sessions.aspx" class="btn btn-gold">Back to My Sessions</a>
        </div>
    </asp:Panel>

</asp:Content>