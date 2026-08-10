<%@ Page Title="Record Payment" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="PaymentAdd.aspx.cs" Inherits="ForteBooksTuitionHub.PaymentAdd" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <asp:Panel ID="pnlForm" runat="server">
        <h2><i class="fa-solid fa-money-bill-wave"></i> Record New Payment</h2>

        <div class="form-box">
            <label>Student</label>
            <asp:DropDownList ID="ddlStudent" runat="server" style="padding:8px; width:100%;"
                DataTextField="FullName" DataValueField="StudentId" AppendDataBoundItems="true"
                AutoPostBack="true" OnSelectedIndexChanged="ddlStudent_SelectedIndexChanged">
                <asp:ListItem Text="-- Select Student --" Value="0" />
            </asp:DropDownList>

            <asp:Panel ID="pnlBalance" runat="server" Visible="false">
                <p style="margin-top:10px;"><strong><i class="fa-solid fa-scale-balanced"></i> Outstanding balance: R<asp:Label ID="lblBalance" runat="server"></asp:Label></strong></p>
            </asp:Panel>

            <label>Amount (R)</label>
            <asp:TextBox ID="txtAmount" runat="server" placeholder="e.g. 300.00"></asp:TextBox>
            <asp:RequiredFieldValidator runat="server" ControlToValidate="txtAmount"
                ErrorMessage="Amount is required." CssClass="error-text" Display="Dynamic" />
            <asp:RegularExpressionValidator runat="server" ControlToValidate="txtAmount"
                ValidationExpression="^\d+(\.\d{1,2})?$"
                ErrorMessage="Enter a valid amount (e.g. 300 or 300.00)." CssClass="error-text" Display="Dynamic" />

            <label>Payment Date</label>
            <asp:TextBox ID="txtPaymentDate" runat="server" TextMode="Date"></asp:TextBox>

            <label>Method</label>
            <asp:DropDownList ID="ddlMethod" runat="server" style="padding:8px; width:100%;">
                <asp:ListItem Text="Cash" Value="Cash" />
                <asp:ListItem Text="Card" Value="Card" />
                <asp:ListItem Text="EFT" Value="EFT" />
            </asp:DropDownList>

            <label>Reason</label>
            <asp:DropDownList ID="ddlReason" runat="server" style="padding:8px; width:100%;">
                <asp:ListItem Text="Session" Value="Session" />
                <asp:ListItem Text="Rental" Value="Rental" />
                <asp:ListItem Text="Fine" Value="Fine" />
            </asp:DropDownList>

            <br /><br />
            <asp:Button ID="btnSave" runat="server" Text="Record Payment" CssClass="btn btn-gold" OnClick="btnSave_Click" />
            <a href="Payments.aspx" class="btn">Cancel</a>

            <br /><br />
            <asp:Label ID="lblError" runat="server" CssClass="error-text"></asp:Label>
        </div>
    </asp:Panel>

    <asp:Panel ID="pnlConfirmation" runat="server" Visible="false">
        <h2><i class="fa-solid fa-envelope-circle-check"></i> Payment Confirmation</h2>

        <div class="email-receipt">
            <div class="email-receipt-header">
                <div class="subject"><i class="fa-solid fa-receipt"></i> Payment Recorded</div>
                <div class="meta"><%: DateTime.Now.ToString("yyyy-MM-dd HH:mm") %></div>
            </div>
            <div class="email-receipt-body">
                <div class="greeting">Receipt Summary</div>

                <div class="email-receipt-row"><span class="label">Student</span><span class="value"><asp:Label ID="lblConfirmStudent" runat="server"></asp:Label></span></div>
                <div class="email-receipt-row"><span class="label">Amount</span><span class="value">R<asp:Label ID="lblConfirmAmount" runat="server"></asp:Label></span></div>
                <div class="email-receipt-row"><span class="label">Method</span><span class="value"><asp:Label ID="lblConfirmMethod" runat="server"></asp:Label></span></div>
                <div class="email-receipt-row"><span class="label">Reason</span><span class="value"><asp:Label ID="lblConfirmReason" runat="server"></asp:Label></span></div>
                <div class="email-receipt-row"><span class="label">Date</span><span class="value"><asp:Label ID="lblConfirmDate" runat="server"></asp:Label></span></div>

                <br />
                <a href="Payments.aspx" class="btn btn-gold"><i class="fa-solid fa-list"></i> View All Payments</a>
            </div>
        </div>
    </asp:Panel>

</asp:Content>