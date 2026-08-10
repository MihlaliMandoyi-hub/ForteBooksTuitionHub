<%@ Page Title="Refund Student" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="RefundStudent.aspx.cs" Inherits="ForteBooksTuitionHub.RefundStudent" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <h2><i class="fa-solid fa-hand-holding-dollar"></i> Refund Student Credit</h2>

    <asp:Panel ID="pnlNotFound" runat="server" Visible="false">
        <div class="error-text"><i class="fa-solid fa-circle-exclamation"></i> Student not found.</div>
        <br />
        <a href="OutstandingBalances.aspx" class="btn">Back to Outstanding Balances</a>
    </asp:Panel>

    <asp:Panel ID="pnlNoCredit" runat="server" Visible="false">
        <div class="error-text"><i class="fa-solid fa-circle-exclamation"></i> This student does not currently have any credit owed to them — nothing to refund.</div>
        <br />
        <a href="OutstandingBalances.aspx" class="btn">Back to Outstanding Balances</a>
    </asp:Panel>

    <asp:Panel ID="pnlForm" runat="server" Visible="false">
        <div class="form-box" style="max-width:500px;">
            <p><i class="fa-solid fa-user-graduate"></i> Student: <strong><asp:Label ID="lblStudentName" runat="server"></asp:Label></strong></p>
            <p><i class="fa-solid fa-wallet"></i> Credit Owed: <strong>R<asp:Label ID="lblCreditOwed" runat="server"></asp:Label></strong></p>

            <label>Refund Amount (R)</label>
            <asp:TextBox ID="txtAmount" runat="server"></asp:TextBox>
            <asp:RequiredFieldValidator runat="server" ControlToValidate="txtAmount"
                ErrorMessage="Amount is required." CssClass="error-text" Display="Dynamic" />
            <asp:RegularExpressionValidator runat="server" ControlToValidate="txtAmount"
                ValidationExpression="^\d+(\.\d{1,2})?$"
                ErrorMessage="Enter a valid amount (e.g. 100 or 100.00)." CssClass="error-text" Display="Dynamic" />

            <label>Method</label>
            <asp:DropDownList ID="ddlMethod" runat="server" style="padding:8px; width:100%;">
                <asp:ListItem Text="Cash" Value="Cash" />
                <asp:ListItem Text="Card" Value="Card" />
                <asp:ListItem Text="EFT" Value="EFT" />
            </asp:DropDownList>

            <label>Notes (optional)</label>
            <asp:TextBox ID="txtNotes" runat="server" TextMode="MultiLine" Rows="2" placeholder="e.g. Refunded because student is no longer active"></asp:TextBox>

            <br /><br />
            <asp:Button ID="btnRefund" runat="server" Text="Confirm Refund" CssClass="btn btn-gold" OnClick="btnRefund_Click"
                OnClientClick="return confirm('Confirm you have paid this student back? This cannot be undone from here.');" />
            <a href="OutstandingBalances.aspx" class="btn">Cancel</a>

            <br /><br />
            <asp:Label ID="lblError" runat="server" CssClass="error-text"></asp:Label>
        </div>
    </asp:Panel>

</asp:Content>