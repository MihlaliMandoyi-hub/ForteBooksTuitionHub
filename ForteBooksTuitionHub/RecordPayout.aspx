<%@ Page Title="Record Payout" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="RecordPayout.aspx.cs" Inherits="ForteBooksTuitionHub.RecordPayout" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="payout-editor">

        <div class="management-page-header">
            <div class="management-header-icon">
                <i class="fa-solid fa-money-check-dollar"
                    aria-hidden="true"></i>
            </div>

            <div>
                <span class="management-eyebrow">
                    Forte Books &amp; Tuition Hub
                </span>
                <h2>Record Tutor Payout</h2>
                <p>Review the tutor's balance and record a payment made to them.</p>
            </div>
        </div>

        <asp:Panel ID="pnlNotFound" runat="server"
            Visible="false" CssClass="payout-not-found">

            <div class="error-text" role="alert">
                <i class="fa-solid fa-circle-exclamation"></i>
                Tutor not found.
            </div>

            <p>Return to Tutor Payouts and select a tutor's Record Payout button.</p>

            <a href="TutorPayouts.aspx" class="btn">
                Back to Tutor Payouts
            </a>
        </asp:Panel>

        <asp:Panel ID="pnlForm" runat="server" Visible="false">

            <div class="payout-editor-body">

                <div class="payout-summary-grid">
                    <div class="payout-summary-card">
                        <i class="fa-solid fa-chalkboard-user"
                            aria-hidden="true"></i>

                        <div>
                            <span class="payout-summary-caption">Tutor</span>
                            <strong>
                                <asp:Label ID="lblTutorName" runat="server" />
                            </strong>
                        </div>
                    </div>

                    <div class="payout-summary-card payout-summary-owed">
                        <i class="fa-solid fa-scale-balanced"
                            aria-hidden="true"></i>

                        <div>
                            <span class="payout-summary-caption">Currently owed</span>
                            <strong>
                                R<asp:Label ID="lblStillOwed" runat="server" />
                            </strong>
                        </div>
                    </div>
                </div>

                <div class="payout-form-section">
                    <h3>Payout details</h3>
                    <p class="payout-form-description">
                        Enter the amount paid and an optional reference or note.
                    </p>

                    <div class="payout-form-grid">
                        <div class="payout-field">
                            <asp:Label ID="lblAmountCaption" runat="server"
                                AssociatedControlID="txtAmount"
                                Text="Payout amount (R) *" />

                            <asp:TextBox ID="txtAmount" runat="server" />

                            <asp:RequiredFieldValidator runat="server"
                                ControlToValidate="txtAmount"
                                ErrorMessage="Amount is required."
                                CssClass="error-text" Display="Dynamic" />

                            <asp:RegularExpressionValidator runat="server"
                                ControlToValidate="txtAmount"
                                ValidationExpression="^\d+(\.\d{1,2})?$"
                                ErrorMessage="Enter a valid amount (e.g. 500 or 500.00)."
                                CssClass="error-text" Display="Dynamic" />

                            <span class="payout-field-hint">
                                Use a full stop for decimals, for example 500.00.
                            </span>
                        </div>

                        <div class="payout-field">
                            <asp:Label ID="lblNotesCaption" runat="server"
                                AssociatedControlID="txtNotes"
                                Text="Notes (optional)" />

                            <asp:TextBox ID="txtNotes" runat="server"
                                TextMode="MultiLine" Rows="3"
                                placeholder="e.g. EFT reference number" />
                        </div>
                    </div>
                </div>

                <asp:Label ID="lblError" runat="server"
                    CssClass="error-text payout-editor-error"
                    role="alert" />
            </div>

            <div class="payout-editor-actions">
                <span>Check the tutor and amount before recording the payout.</span>

                <div>
                    <a href="TutorPayouts.aspx" class="btn payout-editor-cancel">
                        Cancel
                    </a>

                    <asp:Button ID="btnSave" runat="server"
                        Text="Record Payout" CssClass="btn btn-gold"
                        OnClick="btnSave_Click" />
                </div>
            </div>

        </asp:Panel>
    </div>

</asp:Content>