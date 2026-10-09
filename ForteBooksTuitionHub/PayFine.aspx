<%@ Page Title="Pay Fine" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="PayFine.aspx.cs" Inherits="ForteBooksTuitionHub.PayFine" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="fine-page">

        <div class="management-page-header">
            <div class="management-header-icon">
                <i class="fa-solid fa-credit-card" aria-hidden="true"></i>
            </div>
            <div>
                <div class="management-eyebrow">Forte Books &amp; Tuition Hub</div>
                <h2>Settle Your Book Fine</h2>
                <p>Check your rental details, review the amount and confirm your payment.</p>
            </div>
        </div>

        <div class="fine-demo-note">
            <i class="fa-solid fa-circle-info" aria-hidden="true"></i>
            <span>
                <strong>Demo payment experience.</strong>
                No real card charge or bank transfer is processed.
                Use test card details only.
            </span>
        </div>

        <asp:Panel ID="pnlNotFound" runat="server"
            Visible="false" CssClass="fine-state fine-unavailable">

            <div class="fine-state-icon">
                <i class="fa-solid fa-circle-exclamation" aria-hidden="true"></i>
            </div>

            <h3>No payable fine found</h3>
            <p>
                This rental was not found, does not belong to you,
                or has no outstanding fine.
            </p>

            <a href="MyRentals.aspx" class="btn">Back to My Rentals</a>
        </asp:Panel>

        <asp:Panel ID="pnlDetails" runat="server"
            Visible="false" CssClass="fine-content">

            <div class="fine-layout">

                <aside class="fine-summary">

                    <span class="fine-eyebrow">RENTAL SUMMARY</span>

                    <div class="fine-book-icon">
                        <i class="fa-solid fa-book" aria-hidden="true"></i>
                    </div>

                    <h3>
                        <asp:Label ID="lblBookTitle" runat="server"></asp:Label>
                    </h3>

                    <div class="fine-summary-row">
                        <span>Return due date</span>
                        <strong>
                            <asp:Label ID="lblDueDate" runat="server"></asp:Label>
                        </strong>
                    </div>

                    <div class="fine-summary-row">
                        <span>Days overdue</span>
                        <strong>
                            <asp:Label ID="lblDaysOverdue" runat="server"></asp:Label>
                        </strong>
                    </div>

                    <div class="fine-summary-row">
                        <span>Daily fine</span>
                        <strong>R5.00</strong>
                    </div>

                    <div class="fine-amount-box">
                        <span>AMOUNT OWED</span>
                        <strong>
                            R<asp:Label ID="lblFineAmount" runat="server"></asp:Label>
                        </strong>
                    </div>

                    <p class="fine-summary-help">
                        Paying the fine does not mark the book as returned.
                        If it is still on loan, please return it to the centre.
                    </p>

                </aside>

                <div class="fine-form">

                    <div class="fine-section-heading">
                        <span class="fine-step">01</span>
                        <div>
                            <h3>Payment details</h3>
                            <p>Choose a method and review before confirming.</p>
                        </div>
                    </div>

                    <asp:Label ID="lblMethodCaption" runat="server"
                        AssociatedControlID="ddlMethod"
                        CssClass="fine-field-label"
                        Text="Payment method"></asp:Label>

                    <asp:DropDownList ID="ddlMethod" runat="server"
                        AutoPostBack="true"
                        OnSelectedIndexChanged="ddlMethod_SelectedIndexChanged"
                        CssClass="fine-input">

                        <asp:ListItem Text="Card" Value="Card" />
                        <asp:ListItem Text="EFT" Value="EFT" />

                    </asp:DropDownList>

                    <asp:Panel ID="pnlCardFields" runat="server"
                        Visible="true" CssClass="fine-card-fields">

                        <div class="fine-card-heading">
                            <i class="fa-solid fa-credit-card" aria-hidden="true"></i>
                            <span>Test card details</span>
                        </div>

                        <div class="fine-field">
                            <asp:Label ID="lblCardNameCaption" runat="server"
                                AssociatedControlID="txtCardName"
                                CssClass="fine-field-label"
                                Text="Cardholder name"></asp:Label>

                            <asp:TextBox ID="txtCardName" runat="server"
                                CssClass="fine-input"
                                autocomplete="off"
                                placeholder="e.g. Demo Student"></asp:TextBox>
                        </div>

                        <div class="fine-field">
                            <asp:Label ID="lblCardNumberCaption" runat="server"
                                AssociatedControlID="txtCardNumber"
                                CssClass="fine-field-label"
                                Text="Test card number"></asp:Label>

                            <asp:TextBox ID="txtCardNumber" runat="server"
                                CssClass="fine-input"
                                MaxLength="19"
                                inputmode="numeric"
                                autocomplete="off"
                                placeholder="1234 5678 9012 3456"></asp:TextBox>
                        </div>

                        <div class="fine-field-pair">

                            <div>
                                <asp:Label ID="lblExpiryCaption" runat="server"
                                    AssociatedControlID="txtExpiry"
                                    CssClass="fine-field-label"
                                    Text="Expiry (MM/YY)"></asp:Label>

                                <asp:TextBox ID="txtExpiry" runat="server"
                                    CssClass="fine-input"
                                    MaxLength="5"
                                    autocomplete="off"
                                    placeholder="MM/YY"></asp:TextBox>
                            </div>

                            <div>
                                <asp:Label ID="lblCvvCaption" runat="server"
                                    AssociatedControlID="txtCvv"
                                    CssClass="fine-field-label"
                                    Text="Test CVV"></asp:Label>

                                <asp:TextBox ID="txtCvv" runat="server"
                                    CssClass="fine-input"
                                    TextMode="Password"
                                    MaxLength="3"
                                    inputmode="numeric"
                                    autocomplete="off"
                                    placeholder="123"></asp:TextBox>
                            </div>

                        </div>

                    </asp:Panel>

                    <asp:Label ID="lblError" runat="server"
                        CssClass="fine-error"
                        role="alert"></asp:Label>

                    <div class="fine-actions">
                        <asp:Button ID="btnReview" runat="server"
                            Text="Review Payment"
                            CssClass="btn btn-gold"
                            OnClick="btnReview_Click" />

                        <a href="MyRentals.aspx" class="btn fine-secondary">
                            Cancel
                        </a>
                    </div>

                    <p class="fine-form-footer">
                        <i class="fa-solid fa-circle-info" aria-hidden="true"></i>
                        You can check the amount on the next screen before saving.
                    </p>

                </div>
            </div>

        </asp:Panel>

        <asp:Panel ID="pnlConfirm" runat="server"
            Visible="false" CssClass="fine-content">

            <div class="fine-review">

                <div class="fine-section-heading">
                    <span class="fine-step">02</span>
                    <div>
                        <h3>Review your payment</h3>
                        <p>Check these details before confirming the demo payment.</p>
                    </div>
                </div>

                <div class="fine-review-row">
                    <span>Book</span>
                    <strong>
                        <asp:Label ID="lblConfirmBook" runat="server"></asp:Label>
                    </strong>
                </div>

                <div class="fine-review-row">
                    <span>Payment method</span>
                    <strong>
                        <asp:Label ID="lblConfirmMethod" runat="server"></asp:Label>
                    </strong>
                </div>

                <div class="fine-review-total">
                    <span>Total to record</span>
                    <strong>
                        R<asp:Label ID="lblConfirmAmount" runat="server"></asp:Label>
                    </strong>
                </div>

                <div class="fine-actions">
                    <asp:Button ID="btnConfirmPay" runat="server"
                        Text="Confirm Demo Payment"
                        CssClass="btn btn-gold"
                        OnClick="btnConfirmPay_Click" />

                    <asp:Button ID="btnBack" runat="server"
                        Text="Go Back"
                        CssClass="btn fine-secondary"
                        OnClick="btnBack_Click"
                        CausesValidation="false" />
                </div>

            </div>

        </asp:Panel>

        <asp:Panel ID="pnlSuccess" runat="server"
            Visible="false" CssClass="fine-state fine-success">

            <div class="fine-state-icon">
                <i class="fa-solid fa-check" aria-hidden="true"></i>
            </div>

            <span class="fine-success-badge">PAYMENT RECORDED</span>
            <h3>Fine marked as paid</h3>

            <p>
                Your demo payment of
                <strong>R<asp:Label ID="lblSuccessAmount" runat="server"></asp:Label></strong>
                has been recorded. No real money was transferred.
            </p>

            <a href="MyRentals.aspx" class="btn fine-success-button">
                Back to My Bookshelf
            </a>

        </asp:Panel>

    </div>

</asp:Content>