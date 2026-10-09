<%@ Page Title="Refund Student Credit" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="RefundStudent.aspx.cs" Inherits="ForteBooksTuitionHub.RefundStudent" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="fine-page refund-page">

        <div class="management-page-header">
            <div class="management-header-icon">
                <i class="fa-solid fa-hand-holding-dollar" aria-hidden="true"></i>
            </div>
            <div>
                <div class="management-eyebrow">FORTE BOOKS &amp; TUITION HUB</div>
                <h2>Refund Student Credit</h2>
                <p>Review the student’s credit and record a refund clearly.</p>
            </div>
        </div>

        <asp:Panel ID="pnlNotFound" runat="server"
            Visible="false" CssClass="fine-state fine-unavailable">

            <div class="fine-state-icon">
                <i class="fa-solid fa-user-slash" aria-hidden="true"></i>
            </div>

            <h3>Student not found</h3>
            <p>
                Return to Outstanding Balances and select a student record.
            </p>

            <a href="OutstandingBalances.aspx" class="btn refund-secondary">
                Back to Outstanding Balances
            </a>

        </asp:Panel>

        <asp:Panel ID="pnlNoCredit" runat="server"
            Visible="false" CssClass="fine-state fine-unavailable">

            <div class="fine-state-icon">
                <i class="fa-solid fa-wallet" aria-hidden="true"></i>
            </div>

            <h3>No credit available to refund</h3>
            <p>
                This student does not currently have credit owed to them.
                There is no refund to record.
            </p>

            <a href="OutstandingBalances.aspx" class="btn refund-secondary">
                Back to Outstanding Balances
            </a>

        </asp:Panel>

        <asp:Panel ID="pnlForm" runat="server"
            Visible="false" CssClass="fine-content">

            <div class="fine-layout">

                <aside class="fine-summary">

                    <span class="fine-eyebrow">STUDENT CREDIT SUMMARY</span>

                    <div class="fine-book-icon">
                        <i class="fa-solid fa-user-graduate" aria-hidden="true"></i>
                    </div>

                    <h3>
                        <asp:Label ID="lblStudentName" runat="server"></asp:Label>
                    </h3>

                    <div class="refund-credit">
                        <span>CREDIT OWED TO STUDENT</span>
                        <strong>
                            R<asp:Label ID="lblCreditOwed" runat="server"></asp:Label>
                        </strong>
                    </div>

                    <p class="fine-summary-help">
                        You may record a full or partial refund.
                        The amount must be greater than zero and cannot
                        exceed the student’s current credit.
                    </p>

                    <div class="refund-summary-note">
                        <i class="fa-solid fa-circle-info" aria-hidden="true"></i>
                        <p>
                            The system checks the available credit again
                            when you submit the refund.
                        </p>
                    </div>

                </aside>

                <div class="fine-form">

                    <div class="fine-section-heading">
                        <span class="fine-step">01</span>
                        <div>
                            <h3>Refund details</h3>
                            <p>Record the amount and how it was returned.</p>
                        </div>
                    </div>

                    <div class="fine-field">
                        <asp:Label runat="server"
                            AssociatedControlID="txtAmount"
                            CssClass="fine-field-label"
                            Text="Refund amount (R) *"></asp:Label>

                        <asp:TextBox ID="txtAmount" runat="server"
                            CssClass="fine-input"
                            inputmode="decimal"
                            placeholder="e.g. 100.00"></asp:TextBox>

                        <asp:RequiredFieldValidator runat="server"
                            ControlToValidate="txtAmount"
                            ErrorMessage="Amount is required."
                            CssClass="error-text"
                            Display="Dynamic" />

                        <asp:RegularExpressionValidator runat="server"
                            ControlToValidate="txtAmount"
                            ValidationExpression="^\d+(\.\d{1,2})?$"
                            ErrorMessage="Enter a valid amount (e.g. 100 or 100.00)."
                            CssClass="error-text"
                            Display="Dynamic" />
                    </div>

                    <div class="fine-field">
                        <asp:Label runat="server"
                            AssociatedControlID="ddlMethod"
                            CssClass="fine-field-label"
                            Text="Refund method"></asp:Label>

                        <asp:DropDownList ID="ddlMethod" runat="server"
                            CssClass="fine-input">
                            <asp:ListItem Text="Cash" Value="Cash" />
                            <asp:ListItem Text="Card" Value="Card" />
                            <asp:ListItem Text="EFT" Value="EFT" />
                        </asp:DropDownList>
                    </div>

                    <div class="fine-field">
                        <asp:Label runat="server"
                            AssociatedControlID="txtNotes"
                            CssClass="fine-field-label"
                            Text="Notes (optional)"></asp:Label>

                        <asp:TextBox ID="txtNotes" runat="server"
                            CssClass="fine-input refund-notes"
                            TextMode="MultiLine"
                            Rows="4"
                            placeholder="Add the refund reason or payment reference."></asp:TextBox>

                        <p class="refund-field-help">
                            Notes are included in the activity log.
                        </p>
                    </div>

                    <div class="refund-confirmation-note">
                        <i class="fa-solid fa-triangle-exclamation" aria-hidden="true"></i>
                        <div>
                            <strong>Confirm the money has been returned</strong>
                            <p>
                                This page records a refund; it does not send money
                                or process a bank transfer. Confirm only after
                                paying the student back.
                            </p>
                        </div>
                    </div>

                    <asp:Label ID="lblError" runat="server"
                        CssClass="fine-error"
                        role="alert"></asp:Label>

                    <div class="fine-actions">
                        <asp:Button ID="btnRefund" runat="server"
                            Text="Record Refund"
                            CssClass="btn btn-gold"
                            OnClick="btnRefund_Click"
                            OnClientClick="return confirm('Confirm you have paid this student back? This refund cannot be undone from this page.');" />

                        <a href="OutstandingBalances.aspx"
                            class="btn refund-secondary">
                            Cancel
                        </a>
                    </div>

                </div>
            </div>

        </asp:Panel>

    </div>

</asp:Content>