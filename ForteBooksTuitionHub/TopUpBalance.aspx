<%@ Page Title="Top Up Balance" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="TopUpBalance.aspx.cs" Inherits="ForteBooksTuitionHub.TopUpBalance" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <asp:Panel ID="pnlForm" runat="server">
        <h2><i class="fa-solid fa-wallet"></i> Top Up My Balance</h2>

        <div class="form-box" style="max-width:500px;">

            <label>Amount to Top Up (R)</label>
            <asp:TextBox ID="txtAmount" runat="server" placeholder="e.g. 200.00"></asp:TextBox>
            <asp:RequiredFieldValidator runat="server" ControlToValidate="txtAmount"
                ErrorMessage="Amount is required." CssClass="error-text" Display="Dynamic" ValidationGroup="TopUp" />
            <asp:RegularExpressionValidator runat="server" ControlToValidate="txtAmount"
                ValidationExpression="^\d+(\.\d{1,2})?$"
                ErrorMessage="Enter a valid amount (e.g. 200 or 200.00)." CssClass="error-text" Display="Dynamic" ValidationGroup="TopUp" />

            <label>Top-Up Method</label>
            <asp:RadioButtonList ID="rblMethod" runat="server" AutoPostBack="true"
                OnSelectedIndexChanged="rblMethod_SelectedIndexChanged" RepeatDirection="Horizontal">
                <asp:ListItem Text="Voucher" Value="Voucher" Selected="True" />
                <asp:ListItem Text="Card" Value="Card" />
            </asp:RadioButtonList>

            <asp:Panel ID="pnlVoucherFields" runat="server" Visible="true">
                <p style="font-size:12px; color:#7A8699; margin-top:10px;">
                    <i class="fa-solid fa-shield-halved"></i> Demo voucher redemption — no real voucher balance is checked.
                </p>

                <label>Voucher Type</label>
                <asp:DropDownList ID="ddlVoucherType" runat="server" style="padding:8px; width:100%;">
                    <asp:ListItem Text="1Voucher" Value="1Voucher" />
                    <asp:ListItem Text="OTT Voucher" Value="OTT Voucher" />
                    <asp:ListItem Text="Blu Voucher" Value="Blu Voucher" />
                </asp:DropDownList>

                <label>Voucher Code</label>
                <asp:TextBox ID="txtVoucherCode" runat="server" placeholder="e.g. 1234567890123456" MaxLength="16"></asp:TextBox>
            </asp:Panel>

            <asp:Panel ID="pnlCardFields" runat="server" Visible="false">
                <p style="font-size:12px; color:#7A8699; margin-top:10px;">
                    <i class="fa-solid fa-shield-halved"></i> Demo payment form — no real card is charged.
                </p>

                <label>Cardholder Name</label>
                <asp:TextBox ID="txtCardName" runat="server" placeholder="e.g. T Mtshali"></asp:TextBox>

                <label>Card Number</label>
                <asp:TextBox ID="txtCardNumber" runat="server" placeholder="1234 5678 9012 3456" MaxLength="19"></asp:TextBox>

                <label>Expiry (MM/YY)</label>
                <asp:TextBox ID="txtExpiry" runat="server" placeholder="MM/YY" MaxLength="5"></asp:TextBox>

                <label>CVV</label>
                <asp:TextBox ID="txtCvv" runat="server" placeholder="123" MaxLength="3" TextMode="Password"></asp:TextBox>
            </asp:Panel>

            <br />
            <asp:Button ID="btnReview" runat="server" Text="Review Top-Up" CssClass="btn btn-gold" OnClick="btnReview_Click" ValidationGroup="TopUp" />
            <a href="Default.aspx" class="btn">Cancel</a>

            <br /><br />
            <asp:Label ID="lblError" runat="server" CssClass="error-text"></asp:Label>
        </div>
    </asp:Panel>

    <asp:Panel ID="pnlConfirm" runat="server" Visible="false">
        <h2><i class="fa-solid fa-circle-question"></i> Confirm Top-Up</h2>
        <div class="form-box" style="max-width:480px;">
            <p><i class="fa-solid fa-wallet"></i> Amount: <strong>R<asp:Label ID="lblConfirmAmount" runat="server"></asp:Label></strong></p>
            <p>Method: <asp:Label ID="lblConfirmMethod" runat="server"></asp:Label></p>

            <br />
            <asp:Button ID="btnConfirmPay" runat="server" Text="Confirm &amp; Top Up" CssClass="btn btn-gold" OnClick="btnConfirmPay_Click" />
            <asp:Button ID="btnBack" runat="server" Text="Go Back" CssClass="btn" OnClick="btnBack_Click" CausesValidation="false" />
        </div>
    </asp:Panel>

    <asp:Panel ID="pnlSuccess" runat="server" Visible="false">
        <div class="dash-card" style="max-width:400px; border-top-color:#1B7A3D;">
            <h3><i class="fa-solid fa-circle-check" style="color:#1B7A3D;"></i> Top-Up Successful</h3>
            <p>R<asp:Label ID="lblSuccessAmount" runat="server"></asp:Label> has been added to your balance.</p>
            <a href="Default.aspx" class="btn btn-gold">Back to Dashboard</a>
        </div>
    </asp:Panel>

</asp:Content>