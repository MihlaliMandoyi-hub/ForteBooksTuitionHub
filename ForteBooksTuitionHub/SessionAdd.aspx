<%@ Page Title="Book Session" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="SessionAdd.aspx.cs" Inherits="ForteBooksTuitionHub.SessionAdd" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="booking-workspace">

        <!-- BOOKING DETAILS -->
        <asp:Panel ID="pnlForm" runat="server">

            <div class="management-page-header">
                <div class="management-header-icon">
                    <i class="fa-solid fa-calendar-plus" aria-hidden="true"></i>
                </div>
                <div>
                    <span class="management-eyebrow">Step 1 · Session details</span>
                    <h2>Book New Session</h2>
                    <p>Choose your tutor and find a suitable session time.</p>
                </div>
            </div>

            <div class="booking-body">
                <div class="form-box booking-form">

                    <div class="booking-field-grid">
                        <div>
                            <asp:Label ID="lblStudentCaption" runat="server"
                                AssociatedControlID="ddlStudent" Text="Student" />
                            <asp:DropDownList ID="ddlStudent" runat="server"
                                DataTextField="FullName" DataValueField="StudentId"
                                AppendDataBoundItems="true">
                                <asp:ListItem Text="-- Select Student --" Value="0" />
                            </asp:DropDownList>
                        </div>

                        <div>
                            <asp:Label ID="lblTutorCaption" runat="server"
                                AssociatedControlID="ddlTutor" Text="Tutor" />
                            <asp:DropDownList ID="ddlTutor" runat="server"
                                DataTextField="FullName" DataValueField="TutorId"
                                AppendDataBoundItems="true"
                                AutoPostBack="true"
                                OnSelectedIndexChanged="ddlTutor_SelectedIndexChanged">
                                <asp:ListItem Text="-- Select Tutor --" Value="0" />
                            </asp:DropDownList>
                        </div>
                    </div>

                    <asp:Panel ID="pnlTutorAvailability" runat="server"
                        Visible="false" CssClass="booking-tutor-preview">

                        <div class="tutor-rating-preview">
                            <span class="stars">
                                <asp:Label ID="lblTutorStars" runat="server" />
                            </span>
                            <asp:Label ID="lblTutorRatingText" runat="server" />
                        </div>

                        <h3>
                            <i class="fa-solid fa-calendar-days"></i>
                            This tutor's availability &amp; venues
                        </h3>

                        <asp:Label ID="lblAvailability" runat="server"
                            CssClass="booking-availability-details" />

                        <p>
                            <i class="fa-solid fa-circle-info"></i>
                            Hourly rate:
                            <strong>
                                R<asp:Label ID="lblHourlyRatePreview" runat="server" />
                            </strong>
                            — a deposit of at least 50% will be required
                            to confirm this booking.
                        </p>
                    </asp:Panel>

                    <div class="booking-time-grid">
                        <div>
                            <asp:Label ID="lblSessionDateCaption" runat="server"
                                AssociatedControlID="txtSessionDate"
                                Text="Session date" />
                            <asp:TextBox ID="txtSessionDate" runat="server"
                                TextMode="Date" />
                        </div>

                        <div>
                            <asp:Label ID="lblStartTimeCaption" runat="server"
                                AssociatedControlID="txtStartTime"
                                Text="Start time" />
                            <asp:TextBox ID="txtStartTime" runat="server"
                                TextMode="Time" />
                        </div>

                        <div>
                            <asp:Label ID="lblEndTimeCaption" runat="server"
                                AssociatedControlID="txtEndTime"
                                Text="End time" />
                            <asp:TextBox ID="txtEndTime" runat="server"
                                TextMode="Time" />
                        </div>
                    </div>

                    <div class="booking-actions">
                        <a href="Sessions.aspx" class="btn booking-secondary">
                            Cancel
                        </a>
                        <asp:Button ID="btnContinue" runat="server"
                            Text="Continue to Deposit Payment"
                            CssClass="btn btn-gold"
                            OnClick="btnContinue_Click" />
                    </div>

                    <asp:Label ID="lblError" runat="server"
                        CssClass="error-text booking-error" role="alert" />
                </div>
            </div>
        </asp:Panel>

        <!-- STUDENT DEPOSIT -->
        <asp:Panel ID="pnlStudentPayment" runat="server" Visible="false">

            <div class="management-page-header">
                <div class="management-header-icon">
                    <i class="fa-solid fa-credit-card" aria-hidden="true"></i>
                </div>
                <div>
                    <span class="management-eyebrow">Step 2 · Deposit details</span>
                    <h2>Pay Session Deposit</h2>
                    <p>Review your session and enter the deposit details.</p>
                </div>
            </div>

            <div class="booking-body">
                <div class="form-box booking-form">

                    <div class="booking-summary">
                        <p>
                            <i class="fa-solid fa-chalkboard-user"></i>
                            Tutor:
                            <strong><asp:Label ID="lblPayTutorName" runat="server" /></strong>
                        </p>
                        <p>
                            <i class="fa-solid fa-calendar"></i>
                            Date: <asp:Label ID="lblPaySessionDate" runat="server" />
                        </p>
                        <p>
                            <i class="fa-solid fa-location-dot"></i>
                            Venue:
                            <strong><asp:Label ID="lblPayVenue" runat="server" /></strong>
                        </p>
                        <p>
                            Session Cost:
                            R<asp:Label ID="lblSessionCost" runat="server" />
                        </p>

                        <div class="booking-deposit-total">
                            Minimum Deposit (50%):
                            <strong>
                                R<asp:Label ID="lblRequiredDeposit" runat="server" />
                            </strong>
                        </div>
                    </div>

                    <asp:Label ID="lblDepositCaption" runat="server"
                        AssociatedControlID="txtDepositAmount"
                        Text="Amount to pay now (R)" />
                    <asp:TextBox ID="txtDepositAmount" runat="server" />

                    <asp:RequiredFieldValidator runat="server"
                        ControlToValidate="txtDepositAmount"
                        ErrorMessage="Amount is required."
                        CssClass="error-text" Display="Dynamic"
                        ValidationGroup="Deposit" />

                    <asp:RegularExpressionValidator runat="server"
                        ControlToValidate="txtDepositAmount"
                        ValidationExpression="^\d+(\.\d{1,2})?$"
                        ErrorMessage="Enter a valid amount (e.g. 100 or 100.00)."
                        CssClass="error-text" Display="Dynamic"
                        ValidationGroup="Deposit" />

                    <span class="booking-field-caption">Payment method</span>

                    <asp:RadioButtonList ID="rblMethod" runat="server"
                        AutoPostBack="true"
                        OnSelectedIndexChanged="rblMethod_SelectedIndexChanged"
                        RepeatDirection="Horizontal"
                        CssClass="booking-methods">
                        <asp:ListItem Text="Voucher" Value="Voucher" Selected="True" />
                        <asp:ListItem Text="Card" Value="Card" />
                    </asp:RadioButtonList>

                    <asp:Panel ID="pnlVoucherFields" runat="server" Visible="true">
                        <p class="booking-demo-note">
                            <i class="fa-solid fa-shield-halved"></i>
                            Demo voucher redemption — no real voucher balance is checked.
                        </p>

                        <asp:Label ID="lblVoucherTypeCaption" runat="server"
                            AssociatedControlID="ddlVoucherType" Text="Voucher type" />
                        <asp:DropDownList ID="ddlVoucherType" runat="server">
                            <asp:ListItem Text="1Voucher" Value="1Voucher" />
                            <asp:ListItem Text="OTT Voucher" Value="OTT Voucher" />
                            <asp:ListItem Text="Blu Voucher" Value="Blu Voucher" />
                        </asp:DropDownList>

                        <asp:Label ID="lblVoucherCodeCaption" runat="server"
                            AssociatedControlID="txtVoucherCode" Text="Voucher code" />
                        <asp:TextBox ID="txtVoucherCode" runat="server"
                            placeholder="e.g. 1234567890123456" MaxLength="16" />
                    </asp:Panel>

                    <asp:Panel ID="pnlCardFields" runat="server" Visible="false">
                        <p class="booking-demo-note">
                            <i class="fa-solid fa-shield-halved"></i>
                            Demo payment form — no real card is charged.
                        </p>

                        <div class="booking-field-grid">
                            <div>
                                <asp:Label ID="lblCardNameCaption" runat="server"
                                    AssociatedControlID="txtCardName" Text="Cardholder name" />
                                <asp:TextBox ID="txtCardName" runat="server"
                                    placeholder="e.g. T Mtshali" />
                            </div>

                            <div>
                                <asp:Label ID="lblCardNumberCaption" runat="server"
                                    AssociatedControlID="txtCardNumber" Text="Card number" />
                                <asp:TextBox ID="txtCardNumber" runat="server"
                                    placeholder="1234 5678 9012 3456" MaxLength="19" />
                            </div>

                            <div>
                                <asp:Label ID="lblExpiryCaption" runat="server"
                                    AssociatedControlID="txtExpiry" Text="Expiry (MM/YY)" />
                                <asp:TextBox ID="txtExpiry" runat="server"
                                    placeholder="MM/YY" MaxLength="5" />
                            </div>

                            <div>
                                <asp:Label ID="lblCvvCaption" runat="server"
                                    AssociatedControlID="txtCvv" Text="CVV" />
                                <asp:TextBox ID="txtCvv" runat="server"
                                    placeholder="123" MaxLength="3" TextMode="Password" />
                            </div>
                        </div>
                    </asp:Panel>

                    <div class="booking-actions">
                        <asp:Button ID="btnBackToDetails" runat="server"
                            Text="Back" CssClass="btn booking-secondary"
                            OnClick="btnBackToDetails_Click" CausesValidation="false" />

                        <asp:Button ID="btnReviewDeposit" runat="server"
                            Text="Review Payment" CssClass="btn btn-gold"
                            OnClick="btnReviewDeposit_Click" ValidationGroup="Deposit" />
                    </div>

                    <asp:Label ID="lblPayError" runat="server"
                        CssClass="error-text booking-error" role="alert" />
                </div>
            </div>
        </asp:Panel>

        <!-- ADMIN DEPOSIT -->
        <asp:Panel ID="pnlAdminPayment" runat="server" Visible="false">

            <div class="management-page-header">
                <div class="management-header-icon">
                    <i class="fa-solid fa-cash-register" aria-hidden="true"></i>
                </div>
                <div>
                    <span class="management-eyebrow">Step 2 · Record deposit</span>
                    <h2>Record Deposit &amp; Confirm Booking</h2>
                    <p>Check the session and record the amount received.</p>
                </div>
            </div>

            <div class="booking-body">
                <div class="form-box booking-form">

                    <div class="booking-summary">
                        <p>
                            <i class="fa-solid fa-user-graduate"></i>
                            Student:
                            <strong><asp:Label ID="lblAdminStudentName" runat="server" /></strong>
                        </p>
                        <p>
                            <i class="fa-solid fa-chalkboard-user"></i>
                            Tutor:
                            <strong><asp:Label ID="lblAdminTutorName" runat="server" /></strong>
                        </p>
                        <p>
                            <i class="fa-solid fa-location-dot"></i>
                            Venue:
                            <strong><asp:Label ID="lblAdminVenue" runat="server" /></strong>
                        </p>
                        <p>
                            Session Cost:
                            R<asp:Label ID="lblAdminSessionCost" runat="server" />
                        </p>

                        <div class="booking-deposit-total">
                            Minimum Deposit (50%):
                            <strong>
                                R<asp:Label ID="lblAdminRequiredDeposit" runat="server" />
                            </strong>
                        </div>
                    </div>

                    <div class="booking-field-grid">
                        <div>
                            <asp:Label ID="lblAdminAmountCaption" runat="server"
                                AssociatedControlID="txtAdminAmount"
                                Text="Amount received (R)" />
                            <asp:TextBox ID="txtAdminAmount" runat="server" />

                            <asp:RequiredFieldValidator runat="server"
                                ControlToValidate="txtAdminAmount"
                                ErrorMessage="Amount is required."
                                CssClass="error-text" Display="Dynamic"
                                ValidationGroup="AdminDeposit" />

                            <asp:RegularExpressionValidator runat="server"
                                ControlToValidate="txtAdminAmount"
                                ValidationExpression="^\d+(\.\d{1,2})?$"
                                ErrorMessage="Enter a valid amount (e.g. 100 or 100.00)."
                                CssClass="error-text" Display="Dynamic"
                                ValidationGroup="AdminDeposit" />
                        </div>

                        <div>
                            <asp:Label ID="lblAdminMethodCaption" runat="server"
                                AssociatedControlID="ddlAdminMethod"
                                Text="Payment method" />
                            <asp:DropDownList ID="ddlAdminMethod" runat="server">
                                <asp:ListItem Text="Cash" Value="Cash" />
                                <asp:ListItem Text="Card" Value="Card" />
                                <asp:ListItem Text="EFT" Value="EFT" />
                            </asp:DropDownList>
                        </div>
                    </div>

                    <div class="booking-actions">
                        <asp:Button ID="btnAdminBackToDetails" runat="server"
                            Text="Back" CssClass="btn booking-secondary"
                            OnClick="btnBackToDetails_Click" CausesValidation="false" />

                        <asp:Button ID="btnConfirmAdminBooking" runat="server"
                            Text="Confirm Deposit &amp; Book Session"
                            CssClass="btn btn-gold"
                            OnClick="btnConfirmAdminBooking_Click"
                            ValidationGroup="AdminDeposit" />
                    </div>

                    <asp:Label ID="lblAdminPayError" runat="server"
                        CssClass="error-text booking-error" role="alert" />
                </div>
            </div>
        </asp:Panel>

        <!-- STUDENT REVIEW -->
        <asp:Panel ID="pnlConfirm" runat="server" Visible="false">

            <div class="management-page-header">
                <div class="management-header-icon">
                    <i class="fa-solid fa-circle-question" aria-hidden="true"></i>
                </div>
                <div>
                    <span class="management-eyebrow">Step 3 · Review</span>
                    <h2>Confirm Deposit Payment</h2>
                    <p>Review the details before confirming your booking.</p>
                </div>
            </div>

            <div class="booking-body">
                <div class="form-box booking-form">
                    <div class="booking-summary">
                        <p>
                            <i class="fa-solid fa-chalkboard-user"></i>
                            Tutor:
                            <strong><asp:Label ID="lblConfirmTutor2" runat="server" /></strong>
                        </p>
                        <p>
                            Amount:
                            <strong>R<asp:Label ID="lblConfirmAmount2" runat="server" /></strong>
                        </p>
                        <p>
                            Method: <asp:Label ID="lblConfirmMethod2" runat="server" />
                        </p>
                    </div>

                    <div class="booking-actions">
                        <asp:Button ID="btnBackToPayment" runat="server"
                            Text="Go Back" CssClass="btn booking-secondary"
                            OnClick="btnBackToPayment_Click" CausesValidation="false" />

                        <asp:Button ID="btnConfirmPay" runat="server"
                            Text="Confirm &amp; Book Session"
                            CssClass="btn btn-gold"
                            OnClick="btnConfirmPay_Click" />
                    </div>
                </div>
            </div>
        </asp:Panel>

        <!-- SUCCESS -->
        <asp:Panel ID="pnlConfirmation" runat="server" Visible="false">

            <div class="management-page-header booking-success-header">
                <div class="management-header-icon">
                    <i class="fa-solid fa-envelope-circle-check" aria-hidden="true"></i>
                </div>
                <div>
                    <span class="management-eyebrow">Booking complete</span>
                    <h2>Booking Confirmation</h2>
                    <p>Your tutoring session has been booked successfully.</p>
                </div>
            </div>

            <div class="booking-body">
                <div class="email-receipt booking-receipt">
                    <div class="email-receipt-header">
                        <div class="subject">
                            <i class="fa-solid fa-calendar-check"></i>
                            Your tutoring session is confirmed
                        </div>
                        <div class="meta">
                            <%: DateTime.Now.ToString("yyyy-MM-dd HH:mm") %>
                        </div>
                    </div>

                    <div class="email-receipt-body">
                        <div class="greeting">Session Booked Successfully</div>

                        <div class="email-receipt-row">
                            <span class="label">Student</span>
                            <span class="value">
                                <asp:Label ID="lblConfirmStudent" runat="server" />
                            </span>
                        </div>

                        <div class="email-receipt-row">
                            <span class="label">Tutor</span>
                            <span class="value">
                                <asp:Label ID="lblConfirmTutor" runat="server" />
                            </span>
                        </div>

                        <div class="email-receipt-row">
                            <span class="label">Date</span>
                            <span class="value">
                                <asp:Label ID="lblConfirmDate" runat="server" />
                            </span>
                        </div>

                        <div class="email-receipt-row">
                            <span class="label">Time</span>
                            <span class="value">
                                <asp:Label ID="lblConfirmTime" runat="server" />
                            </span>
                        </div>

                        <div class="email-receipt-row">
                            <span class="label">Venue</span>
                            <span class="value">
                                <asp:Label ID="lblConfirmVenue" runat="server" />
                            </span>
                        </div>

                        <div class="email-receipt-row">
                            <span class="label">Deposit Paid</span>
                            <span class="value">
                                R<asp:Label ID="lblConfirmDeposit" runat="server" />
                            </span>
                        </div>

                        <div class="booking-actions">
                            <a href="Sessions.aspx" class="btn btn-gold">
                                <i class="fa-solid fa-list"></i>
                                View My Sessions
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </asp:Panel>

    </div>

</asp:Content>