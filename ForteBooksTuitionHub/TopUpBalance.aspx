<%@ Page Title="Top Up Balance" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="TopUpBalance.aspx.cs" Inherits="ForteBooksTuitionHub.TopUpBalance" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="fine-page topup-page">

        <div class="management-page-header">
            <div class="management-header-icon">
                <i class="fa-solid fa-wallet" aria-hidden="true"></i>
            </div>
            <div>
                <div class="management-eyebrow">Forte Books &amp; Tuition Hub</div>
                <h2>Top Up My Balance</h2>
                <p>Add credit to your account and prepare for your next learning session.</p>
            </div>
        </div>

        <div class="fine-demo-note">
            <i class="fa-solid fa-circle-info" aria-hidden="true"></i>
            <span>
                <strong>Demo top-up experience.</strong>
                No real card is charged and no voucher balance is checked.
                Use test details only.
            </span>
        </div>

        <asp:Panel ID="pnlForm" runat="server" CssClass="fine-content">

            <div class="fine-layout">

                <aside class="topup-sidebar">

                    <div class="topup-wallet">
                        <div class="topup-wallet-heading">
                            <span>FORTE BOOKS</span>
                            <i class="fa-solid fa-wallet" aria-hidden="true"></i>
                        </div>

                        <span class="topup-wallet-caption">YOUR SELECTED TOP-UP</span>

                        <strong id="topupPreview">R0.00</strong>

                        <div class="topup-wallet-footer">
                            <span>Student account credit</span>
                            <i class="fa-solid fa-graduation-cap" aria-hidden="true"></i>
                        </div>
                    </div>

                    <div class="topup-guide">
                        <h3>A little credit. More possibilities.</h3>

                        <div>
                            <span class="fine-step">01</span>
                            <p>Choose an amount of <strong>R10 or more.</strong></p>
                        </div>

                        <div>
                            <span class="fine-step">02</span>
                            <p>Select Voucher or Card and enter your test details.</p>
                        </div>

                        <div>
                            <span class="fine-step">03</span>
                            <p>Review your top-up before confirming.</p>
                        </div>
                    </div>

                </aside>

                <div class="fine-form">

                    <div class="fine-section-heading">
                        <span class="fine-step">01</span>
                        <div>
                            <h3>Choose your amount</h3>
                            <p>Use a quick amount or enter your own.</p>
                        </div>
                    </div>

                    <div class="topup-quick-amounts" id="topupQuickAmounts" hidden
                        role="group" aria-label="Suggested top-up amounts">

                        <button type="button" data-amount="50" aria-pressed="false">R50</button>
                        <button type="button" data-amount="100" aria-pressed="false">R100</button>
                        <button type="button" data-amount="200" aria-pressed="false">R200</button>
                        <button type="button" data-amount="500" aria-pressed="false">R500</button>

                    </div>

                    <asp:Label ID="lblAmountCaption" runat="server"
                        AssociatedControlID="txtAmount"
                        CssClass="fine-field-label"
                        Text="Amount to top up (R)"></asp:Label>

                    <asp:TextBox ID="txtAmount" runat="server"
                        CssClass="fine-input"
                        inputmode="decimal"
                        placeholder="e.g. 200.00"></asp:TextBox>

                    <asp:RequiredFieldValidator runat="server"
                        ControlToValidate="txtAmount"
                        ErrorMessage="Amount is required."
                        CssClass="error-text"
                        Display="Dynamic"
                        ValidationGroup="TopUp" />

                    <asp:RegularExpressionValidator runat="server"
                        ControlToValidate="txtAmount"
                        ValidationExpression="^\d+(\.\d{1,2})?$"
                        ErrorMessage="Enter a valid amount (e.g. 200 or 200.00)."
                        CssClass="error-text"
                        Display="Dynamic"
                        ValidationGroup="TopUp" />

                    <p class="topup-amount-help">
                        Minimum R10.00. Use a full stop for decimal amounts.
                    </p>

                    <div class="fine-section-heading topup-method-heading">
                        <span class="fine-step">02</span>
                        <div>
                            <h3>Choose your method</h3>
                            <p>Both options are demonstration payments.</p>
                        </div>
                    </div>

                    <asp:RadioButtonList ID="rblMethod" runat="server"
                        CssClass="topup-methods"
                        AutoPostBack="true"
                        OnSelectedIndexChanged="rblMethod_SelectedIndexChanged"
                        RepeatDirection="Horizontal"
                        CausesValidation="false">

                        <asp:ListItem Text="Voucher" Value="Voucher" Selected="True" />
                        <asp:ListItem Text="Card" Value="Card" />

                    </asp:RadioButtonList>

                    <asp:Panel ID="pnlVoucherFields" runat="server"
                        Visible="true" CssClass="fine-card-fields">

                        <div class="fine-card-heading">
                            <i class="fa-solid fa-ticket" aria-hidden="true"></i>
                            <span>Test voucher details</span>
                        </div>

                        <div class="fine-field">
                            <asp:Label ID="lblVoucherTypeCaption" runat="server"
                                AssociatedControlID="ddlVoucherType"
                                CssClass="fine-field-label"
                                Text="Voucher type"></asp:Label>

                            <asp:DropDownList ID="ddlVoucherType" runat="server"
                                CssClass="fine-input">

                                <asp:ListItem Text="1Voucher" Value="1Voucher" />
                                <asp:ListItem Text="OTT Voucher" Value="OTT Voucher" />
                                <asp:ListItem Text="Blu Voucher" Value="Blu Voucher" />

                            </asp:DropDownList>
                        </div>

                        <asp:Label ID="lblVoucherCodeCaption" runat="server"
                            AssociatedControlID="txtVoucherCode"
                            CssClass="fine-field-label"
                            Text="Test voucher code"></asp:Label>

                        <asp:TextBox ID="txtVoucherCode" runat="server"
                            CssClass="fine-input"
                            MaxLength="16"
                            inputmode="numeric"
                            autocomplete="off"
                            placeholder="Enter 10 to 16 digits"></asp:TextBox>

                    </asp:Panel>

                    <asp:Panel ID="pnlCardFields" runat="server"
                        Visible="false" CssClass="fine-card-fields">

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
                                    MaxLength="3"
                                    TextMode="Password"
                                    inputmode="numeric"
                                    autocomplete="off"
                                    placeholder="123"></asp:TextBox>
                            </div>
                        </div>

                    </asp:Panel>

                    <asp:Label ID="lblError" runat="server"
                        CssClass="fine-error" role="alert"></asp:Label>

                    <div class="fine-actions">
                        <asp:Button ID="btnReview" runat="server"
                            Text="Review Top-Up"
                            CssClass="btn btn-gold"
                            OnClick="btnReview_Click"
                            ValidationGroup="TopUp" />

                        <a href="Default.aspx" class="btn fine-secondary">Cancel</a>
                    </div>

                </div>
            </div>

        </asp:Panel>

        <asp:Panel ID="pnlConfirm" runat="server"
            Visible="false" CssClass="fine-content">

            <div class="fine-review">

                <div class="fine-section-heading">
                    <span class="fine-step">03</span>
                    <div>
                        <h3>Review your top-up</h3>
                        <p>Check the amount and method before confirming.</p>
                    </div>
                </div>

                <div class="fine-review-row">
                    <span>Payment method</span>
                    <strong>
                        <asp:Label ID="lblConfirmMethod" runat="server"></asp:Label>
                    </strong>
                </div>

                <div class="fine-review-total">
                    <span>Credit to add</span>
                    <strong>
                        R<asp:Label ID="lblConfirmAmount" runat="server"></asp:Label>
                    </strong>
                </div>

                <p class="fine-form-footer">
                    This records a demo deposit in your account.
                    No real card charge or voucher redemption takes place.
                </p>

                <div class="fine-actions">
                    <asp:Button ID="btnConfirmPay" runat="server"
                        Text="Confirm Demo Top-Up"
                        CssClass="btn btn-gold"
                        OnClick="btnConfirmPay_Click"
                        CausesValidation="false" />

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

            <span class="fine-success-badge">TOP-UP RECORDED</span>
            <h3>Your account credit is ready</h3>

            <p>
                <strong>R<asp:Label ID="lblSuccessAmount" runat="server"></asp:Label></strong>
                has been added to your balance through this demo top-up.
            </p>

            <a href="Default.aspx" class="btn fine-success-button">
                Back to Dashboard
            </a>

        </asp:Panel>

    </div>

    <script>
        (function () {
            var amount = document.getElementById('<%= txtAmount.ClientID %>');
            var preview = document.getElementById('topupPreview');
            var quickAmounts = document.getElementById('topupQuickAmounts');

            if (!amount || !preview || !quickAmounts) return;

            var buttons = quickAmounts.querySelectorAll('button[data-amount]');

            function updatePreview() {
                var text = amount.value.trim();
                var valid = /^\d+(\.\d{1,2})?$/.test(text);
                var value = valid ? Number(text) : 0;

                if (!Number.isFinite(value)) value = 0;

                preview.textContent = 'R' + value.toLocaleString('en-ZA', {
                    minimumFractionDigits: 2,
                    maximumFractionDigits: 2
                });

                buttons.forEach(function (button) {
                    var selected = valid && value === Number(button.dataset.amount);
                    button.classList.toggle('is-selected', selected);
                    button.setAttribute('aria-pressed', selected ? 'true' : 'false');
                });
            }

            buttons.forEach(function (button) {
                button.addEventListener('click', function () {
                    amount.value = button.dataset.amount;
                    updatePreview();
                });
            });

            amount.addEventListener('input', updatePreview);
            quickAmounts.hidden = false;
            updatePreview();
        })();
    </script>

</asp:Content>