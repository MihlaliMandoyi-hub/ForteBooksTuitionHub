<%@ Page Title="Record Payment" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="PaymentAdd.aspx.cs" Inherits="ForteBooksTuitionHub.PaymentAdd" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <asp:Panel ID="pnlForm" runat="server"
        CssClass="payment-editor">

        <div class="management-page-header">
            <div class="management-header-icon">
                <i class="fa-solid fa-money-bill-wave" aria-hidden="true"></i>
            </div>

            <div>
                <span class="management-eyebrow">Forte Books &amp; Tuition Hub</span>
                <h2>Record New Payment</h2>
                <p>Capture a student's payment and review its confirmation.</p>
            </div>
        </div>

        <div class="payment-editor-body">
            <div class="payment-editor-intro">
                <h3>Payment details</h3>
                <p>Choose the student, then enter the payment information.</p>
            </div>

            <div class="payment-field payment-student-field">
                <asp:Label ID="lblStudentCaption" runat="server"
                    AssociatedControlID="ddlStudent" Text="Student *" />

                <asp:DropDownList ID="ddlStudent" runat="server"
                    DataTextField="FullName" DataValueField="StudentId"
                    AppendDataBoundItems="true"
                    AutoPostBack="true"
                    OnSelectedIndexChanged="ddlStudent_SelectedIndexChanged">
                    <asp:ListItem Text="-- Select Student --" Value="0" />
                </asp:DropDownList>
            </div>

            <asp:Panel ID="pnlBalance" runat="server"
                Visible="false" CssClass="payment-balance">

                <i class="fa-solid fa-scale-balanced" aria-hidden="true"></i>

                <div>
                    <span>Outstanding balance</span>
                    <strong>
                        R<asp:Label ID="lblBalance" runat="server" />
                    </strong>
                </div>
            </asp:Panel>

            <div class="payment-field-grid">
                <div class="payment-field">
                    <asp:Label ID="lblAmountCaption" runat="server"
                        AssociatedControlID="txtAmount" Text="Amount (R) *" />

                    <asp:TextBox ID="txtAmount" runat="server"
                        placeholder="e.g. 300.00" />

                    <asp:RequiredFieldValidator runat="server"
                        ControlToValidate="txtAmount"
                        ErrorMessage="Amount is required."
                        CssClass="error-text" Display="Dynamic" />

                    <asp:RegularExpressionValidator runat="server"
                        ControlToValidate="txtAmount"
                        ValidationExpression="^\d+(\.\d{1,2})?$"
                        ErrorMessage="Enter a valid amount (e.g. 300 or 300.00)."
                        CssClass="error-text" Display="Dynamic" />

                    <span class="payment-field-hint">
                        Use a full stop for decimals, for example 300.00.
                    </span>
                </div>

                <div class="payment-field">
                    <asp:Label ID="lblPaymentDateCaption" runat="server"
                        AssociatedControlID="txtPaymentDate"
                        Text="Payment date *" />

                    <asp:TextBox ID="txtPaymentDate" runat="server"
                        TextMode="Date" />

                    <asp:RequiredFieldValidator runat="server"
                        ControlToValidate="txtPaymentDate"
                        ErrorMessage="Payment date is required."
                        CssClass="error-text" Display="Dynamic" />
                </div>

                <div class="payment-field">
                    <asp:Label ID="lblMethodCaption" runat="server"
                        AssociatedControlID="ddlMethod" Text="Payment method" />

                    <asp:DropDownList ID="ddlMethod" runat="server">
                        <asp:ListItem Text="Cash" Value="Cash" />
                        <asp:ListItem Text="Card" Value="Card" />
                        <asp:ListItem Text="EFT" Value="EFT" />
                    </asp:DropDownList>
                </div>

                <div class="payment-field">
                    <asp:Label ID="lblReasonCaption" runat="server"
                        AssociatedControlID="ddlReason" Text="Payment reason" />

                    <asp:DropDownList ID="ddlReason" runat="server">
                        <asp:ListItem Text="Session" Value="Session" />
                        <asp:ListItem Text="Rental" Value="Rental" />
                        <asp:ListItem Text="Fine" Value="Fine" />
                    </asp:DropDownList>
                </div>
            </div>

            <asp:Label ID="lblError" runat="server"
                CssClass="error-text payment-editor-error" role="alert" />
        </div>

        <div class="payment-editor-actions">
            <span>Confirm the student, amount and date before saving.</span>

            <div>
                <a href="Payments.aspx" class="btn payment-editor-cancel">
                    Cancel
                </a>

                <asp:Button ID="btnSave" runat="server"
                    Text="Record Payment" CssClass="btn btn-gold"
                    OnClick="btnSave_Click" />
            </div>
        </div>

    </asp:Panel>

    <asp:Panel ID="pnlConfirmation" runat="server"
        Visible="false" CssClass="payment-editor">

        <div class="management-page-header">
            <div class="management-header-icon">
                <i class="fa-solid fa-envelope-circle-check"
                    aria-hidden="true"></i>
            </div>

            <div>
                <span class="management-eyebrow">Forte Books &amp; Tuition Hub</span>
                <h2>Payment Confirmation</h2>
                <p>The payment has been recorded in the system.</p>
            </div>
        </div>

        <div class="payment-editor-body">
            <div class="email-receipt payment-receipt">
                <div class="email-receipt-header">
                    <div class="subject">
                        <i class="fa-solid fa-receipt"></i>
                        Payment Recorded
                    </div>

                    <div class="meta">
                        <%: DateTime.Now.ToString("yyyy-MM-dd HH:mm") %>
                    </div>
                </div>

                <div class="email-receipt-body">
                    <div class="greeting">Receipt Summary</div>

                    <div class="email-receipt-row">
                        <span class="label">Student</span>
                        <span class="value">
                            <asp:Label ID="lblConfirmStudent" runat="server" />
                        </span>
                    </div>

                    <div class="email-receipt-row payment-receipt-amount">
                        <span class="label">Amount</span>
                        <span class="value">
                            R<asp:Label ID="lblConfirmAmount" runat="server" />
                        </span>
                    </div>

                    <div class="email-receipt-row">
                        <span class="label">Method</span>
                        <span class="value">
                            <asp:Label ID="lblConfirmMethod" runat="server" />
                        </span>
                    </div>

                    <div class="email-receipt-row">
                        <span class="label">Reason</span>
                        <span class="value">
                            <asp:Label ID="lblConfirmReason" runat="server" />
                        </span>
                    </div>

                    <div class="email-receipt-row">
                        <span class="label">Date</span>
                        <span class="value">
                            <asp:Label ID="lblConfirmDate" runat="server" />
                        </span>
                    </div>

                    <div class="payment-receipt-actions">
                        <a href="Payments.aspx" class="btn btn-gold">
                            <i class="fa-solid fa-list"></i>
                            View All Payments
                        </a>
                    </div>
                </div>
            </div>
        </div>

    </asp:Panel>

</asp:Content>