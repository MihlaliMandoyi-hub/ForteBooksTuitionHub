<%@ Page Title="Pay Fine" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="PayFine.aspx.cs" Inherits="ForteBooksTuitionHub.PayFine" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <h2><i class="fa-solid fa-credit-card"></i> Pay Overdue Book Fine</h2>

    <asp:Panel ID="pnlNotFound" runat="server" Visible="false">
        <div class="error-text"><i class="fa-solid fa-circle-exclamation"></i> This rental was not found, does not belong to you, or has no outstanding fine.</div>
        <br />
        <a href="MyRentals.aspx" class="btn">Back to My Rentals</a>
    </asp:Panel>

    <asp:Panel ID="pnlDetails" runat="server" Visible="false">
        <div class="form-box" style="max-width:480px;">

            <p><i class="fa-solid fa-book"></i> <strong><asp:Label ID="lblBookTitle" runat="server"></asp:Label></strong></p>
            <p>Due Date: <asp:Label ID="lblDueDate" runat="server"></asp:Label></p>
            <p>Days Overdue: <asp:Label ID="lblDaysOverdue" runat="server"></asp:Label></p>
            <p style="font-size:20px; font-weight:700; color:#c0392b;">
                Amount Owed: R<asp:Label ID="lblFineAmount" runat="server"></asp:Label>
            </p>

            <hr style="margin:15px 0; border-color:#eee;" />

            <label>Payment Method</label>
            <asp:DropDownList ID="ddlMethod" runat="server" style="padding:8px; width:100%;"
                AutoPostBack="true" OnSelectedIndexChanged="ddlMethod_SelectedIndexChanged">
                <asp:ListItem Text="Card" Value="Card" />
                <asp:ListItem Text="EFT" Value="EFT" />
            </asp:DropDownList>

            <asp:Panel ID="pnlCardFields" runat="server" Visible="true">
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
            <asp:Button ID="btnReview" runat="server" Text="Review Payment" CssClass="btn btn-gold" OnClick="btnReview_Click" />
            <a href="MyRentals.aspx" class="btn">Cancel</a>

            <br /><br />
            <asp:Label ID="lblError" runat="server" CssClass="error-text"></asp:Label>
        </div>
    </asp:Panel>

    <asp:Panel ID="pnlConfirm" runat="server" Visible="false">
        <div class="form-box" style="max-width:480px;">
            <h3><i class="fa-solid fa-circle-question"></i> Confirm Payment</h3>

            <p><i class="fa-solid fa-book"></i> Book: <strong><asp:Label ID="lblConfirmBook" runat="server"></asp:Label></strong></p>
            <p>Method: <asp:Label ID="lblConfirmMethod" runat="server"></asp:Label></p>
            <p style="font-size:20px; font-weight:700; color:#112A43;">
                Total: R<asp:Label ID="lblConfirmAmount" runat="server"></asp:Label>
            </p>

            <br />
            <asp:Button ID="btnConfirmPay" runat="server" Text="Confirm &amp; Pay" CssClass="btn btn-gold" OnClick="btnConfirmPay_Click" />
            <asp:Button ID="btnBack" runat="server" Text="Go Back" CssClass="btn" OnClick="btnBack_Click" CausesValidation="false" />
        </div>
    </asp:Panel>

    <asp:Panel ID="pnlSuccess" runat="server" Visible="false">
        <div class="dash-card" style="max-width:400px; border-top-color:#1B7A3D;">
            <h3><i class="fa-solid fa-circle-check" style="color:#1B7A3D;"></i> Payment Successful</h3>
            <p>Your fine of R<asp:Label ID="lblSuccessAmount" runat="server"></asp:Label> has been paid. Thank you!</p>
            <a href="MyRentals.aspx" class="btn btn-gold">Back to My Rentals</a>
        </div>
    </asp:Panel>

</asp:Content>