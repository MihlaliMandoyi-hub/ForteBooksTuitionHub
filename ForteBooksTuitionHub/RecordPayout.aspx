<%@ Page Title="Record Payout" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="RecordPayout.aspx.cs" Inherits="ForteBooksTuitionHub.RecordPayout" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <h2><i class="fa-solid fa-money-check-dollar"></i> Record Tutor Payout</h2>

    <asp:Panel ID="pnlNotFound" runat="server" Visible="false">
        <div class="error-text"><i class="fa-solid fa-circle-exclamation"></i> Tutor not found.</div>
        <br />
        <a href="TutorPayouts.aspx" class="btn">Back to Tutor Payouts</a>
    </asp:Panel>

    <asp:Panel ID="pnlForm" runat="server" Visible="false">
        <div class="form-box">
            <p><i class="fa-solid fa-chalkboard-user"></i> Tutor: <strong><asp:Label ID="lblTutorName" runat="server"></asp:Label></strong></p>
            <p><i class="fa-solid fa-scale-balanced"></i> Currently Owed: <strong>R<asp:Label ID="lblStillOwed" runat="server"></asp:Label></strong></p>

            <label>Payout Amount (R)</label>
            <asp:TextBox ID="txtAmount" runat="server"></asp:TextBox>
            <asp:RequiredFieldValidator runat="server" ControlToValidate="txtAmount"
                ErrorMessage="Amount is required." CssClass="error-text" Display="Dynamic" />
            <asp:RegularExpressionValidator runat="server" ControlToValidate="txtAmount"
                ValidationExpression="^\d+(\.\d{1,2})?$"
                ErrorMessage="Enter a valid amount (e.g. 500 or 500.00)." CssClass="error-text" Display="Dynamic" />

            <label>Notes (optional)</label>
            <asp:TextBox ID="txtNotes" runat="server" TextMode="MultiLine" Rows="2" placeholder="e.g. EFT reference number"></asp:TextBox>

            <br /><br />
            <asp:Button ID="btnSave" runat="server" Text="Record Payout" CssClass="btn btn-gold" OnClick="btnSave_Click" />
            <a href="TutorPayouts.aspx" class="btn">Cancel</a>

            <br /><br />
            <asp:Label ID="lblError" runat="server" CssClass="error-text"></asp:Label>
        </div>
    </asp:Panel>

</asp:Content>
