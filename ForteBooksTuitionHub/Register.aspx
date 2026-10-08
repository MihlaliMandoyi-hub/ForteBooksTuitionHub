<%@ Page Title="Book Session" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="SessionAdd.aspx.cs" Inherits="ForteBooksTuitionHub.SessionAdd" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <!-- ===================== STEP 1: BOOKING DETAILS ===================== -->
    <asp:Panel ID="pnlForm" runat="server">
        <h2><i class="fa-solid fa-calendar-plus"></i> Book New Session</h2>

        <div class="form-box">
            <label>Student</label>
            <asp:DropDownList ID="ddlStudent" runat="server" style="padding:8px; width:100%;"
                DataTextField="FullName" DataValueField="StudentId" AppendDataBoundItems="true">
                <asp:ListItem Text="-- Select Student --" Value="0" />
            </asp:DropDownList>

            <label>Tutor</label>
            <asp:DropDownList ID="ddlTutor" runat="server" style="padding:8px; width:100%;"
                DataTextField="FullName" DataValueField="TutorId" AppendDataBoundItems="true"
                AutoPostBack="true" OnSelectedIndexChanged="ddlTutor_SelectedIndexChanged">
                <asp:ListItem Text="-- Select Tutor --" Value="0" />
            </asp:DropDownList>

            <asp:Panel ID="pnlTutorAvailability" runat="server" Visible="false">
                <div class="tutor-rating-preview">
                    <span class="stars"><asp:Label ID="lblTutorStars" runat="server"></asp:Label></span>
                    <asp:Label ID="lblTutorRatingText" runat="server"></asp:Label>
                </div>

                <p style="margin-top:10px;"><strong><i class="fa-solid fa-calendar-days"></i> This tutor's availability &amp; venues:</strong></p>
                <asp:Label ID="lblAvailability" runat="server" style="display:block; margin-bottom:10px;"></asp:Label>
                <p style="font-size:13px; color:var(--text-muted);">
                    <i class="fa-solid fa-circle-info"></i> Hourly rate: R<asp:Label ID="lblHourlyRatePreview" runat="server"></asp:Label>
                    &mdash; a deposit of at least 50% will be required to confirm this booking.
                </p>
            </asp:Panel>

            <label>Session Date</label>
            <asp:TextBox ID="txtSessionDate" runat="server" TextMode="Date"></asp:TextBox>

            <label>Start Time</label>
            <asp:TextBox ID="txtStartTime" runat="server" TextMode="Time"></asp:TextBox>

            <label>End Time</label>
            <asp:TextBox ID="txtEndTime" runat="server" TextMode="Time"></asp:TextBox>

            <br /><br />
            <asp:Button ID="btnContinue" runat="server" Text="Continue to Deposit Payment" CssClass="btn btn-gold" OnClick="btnContinue_Click" />
            <a href="Sessions.aspx" class="btn">Cancel</a>

            <br /><br />
            <asp:Label ID="lblError" runat="server" CssClass="error-text"></asp:Label>
        </div>
    </asp:Panel>

    <!-- ===================== STEP 2a: STUDENT DEPOSIT PAYMENT ===================== -->
    <asp:Panel ID="pnlStudentPayment" runat="server" Visible="false">
        <h2><i class="fa-solid fa-credit-card"></i> Pay Session Deposit</h2>

        <div class="form-box" style="max-width:480px;">
            <p><i class="fa-solid fa-chalkboard-user"></i> Tutor: <strong><asp:Label ID="lblPayTutorName" runat="server"></asp:Label></strong></p>
            <p><i class="fa-solid fa-calendar"></i> Date: <asp:Label ID="lblPaySessionDate" runat="server"></asp:Label></p>
            <p><i class="fa-solid fa-location-dot"></i> Venue: <strong><asp:Label ID="lblPayVenue" runat="server"></asp:Label></strong></p>
            <p>Session Cost: R<asp:Label ID="lblSessionCost" runat="server"></asp:Label></p>
            <p style="font-size:18px; font-weight:700; color:var(--ufh-navy);">
                Minimum Deposit (50%): R<asp:Label ID="lblRequiredDeposit" runat="server"></asp:Label>
            </p>

            <label>Amount to Pay Now (R)</label>
            <asp:TextBox ID="txtDepositAmount" runat="server"></asp:TextBox>
            <asp:RequiredFieldValidator runat="server" ControlToValidate="txtDepositAmount"
                ErrorMessage="Amount is required." CssClass="error-text" Display="Dynamic" ValidationGroup="Deposit" />
            <asp:RegularExpressionValidator runat="server" ControlToValidate="txtDepositAmount"
                ValidationExpression="^\d+(\.\d{1,2})?$"
                ErrorMessage="Enter a valid amount (e.g. 100 or 100.00)." CssClass="error-text" Display="Dynamic" ValidationGroup="Deposit" />

            <label>Payment Method</label>
            <asp:RadioButtonList ID="rblMethod" runat="server" AutoPostBack="true"
                OnSelectedIndexChanged="rblMethod_SelectedIndexChanged" RepeatDirection="Horizontal">
                <asp:ListItem Text="Voucher" Value="Voucher" Selected="True" />
                <asp:ListItem Text="Card" Value="Card" />
            </asp:RadioButtonList>

            <asp:Panel ID="pnlVoucherFields" runat="server" Visible="true">
                <p style="font-size:12px; color:var(--text-muted); margin-top:10px;">
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
                <p style="font-size:12px; color:var(--text-muted); margin-top:10px;">
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
            <asp:Button ID="btnReviewDeposit" runat="server" Text="Review Payment" CssClass="btn btn-gold" OnClick="btnReviewDeposit_Click" ValidationGroup="Deposit" />
            <asp:Button ID="btnBackToDetails" runat="server" Text="Back" CssClass="btn" OnClick="btnBackToDetails_Click" CausesValidation="false" />

            <br /><br />
            <asp:Label ID="lblPayError" runat="server" CssClass="error-text"></asp:Label>
        </div>
    </asp:Panel>

    <!-- ===================== STEP 2b: ADMIN DEPOSIT ENTRY ===================== -->
    <asp:Panel ID="pnlAdminPayment" runat="server" Visible="false">
        <h2><i class="fa-solid fa-cash-register"></i> Record Deposit &amp; Confirm Booking</h2>

        <div class="form-box" style="max-width:480px;">
            <p><i class="fa-solid fa-user-graduate"></i> Student: <strong><asp:Label ID="lblAdminStudentName" runat="server"></asp:Label></strong></p>
            <p><i class="fa-solid fa-chalkboard-user"></i> Tutor: <strong><asp:Label ID="lblAdminTutorName" runat="server"></asp:Label></strong></p>
            <p><i class="fa-solid fa-location-dot"></i> Venue: <strong><asp:Label ID="lblAdminVenue" runat="server"></asp:Label></strong></p>
            <p>Session Cost: R<asp:Label ID="lblAdminSessionCost" runat="server"></asp:Label></p>
            <p style="font-size:18px; font-weight:700; color:var(--ufh-navy);">
                Minimum Deposit (50%): R<asp:Label ID="lblAdminRequiredDeposit" runat="server"></asp:Label>
            </p>

            <label>Amount Received (R)</label>
            <asp:TextBox ID="txtAdminAmount" runat="server"></asp:TextBox>
            <asp:RequiredFieldValidator runat="server" ControlToValidate="txtAdminAmount"
                ErrorMessage="Amount is required." CssClass="error-text" Display="Dynamic" ValidationGroup="AdminDeposit" />
            <asp:RegularExpressionValidator runat="server" ControlToValidate="txtAdminAmount"
                ValidationExpression="^\d+(\.\d{1,2})?$"
                ErrorMessage="Enter a valid amount (e.g. 100 or 100.00)." CssClass="error-text" Display="Dynamic" ValidationGroup="AdminDeposit" />

            <label>Payment Method</label>
            <asp:DropDownList ID="ddlAdminMethod" runat="server" style="padding:8px; width:100%;">
                <asp:ListItem Text="Cash" Value="Cash" />
                <asp:ListItem Text="Card" Value="Card" />
                <asp:ListItem Text="EFT" Value="EFT" />
            </asp:DropDownList>

            <br /><br />
            <asp:Button ID="btnConfirmAdminBooking" runat="server" Text="Confirm Deposit &amp; Book Session" CssClass="btn btn-gold" OnClick="btnConfirmAdminBooking_Click" ValidationGroup="AdminDeposit" />
            <asp:Button ID="btnAdminBackToDetails" runat="server" Text="Back" CssClass="btn" OnClick="btnBackToDetails_Click" CausesValidation="false" />

            <br /><br />
            <asp:Label ID="lblAdminPayError" runat="server" CssClass="error-text"></asp:Label>
        </div>
    </asp:Panel>

    <!-- ===================== STEP 3: REVIEW (Student path only) ===================== -->
    <asp:Panel ID="pnlConfirm" runat="server" Visible="false">
        <h2><i class="fa-solid fa-circle-question"></i> Confirm Deposit Payment</h2>
        <div class="form-box" style="max-width:480px;">
            <p><i class="fa-solid fa-chalkboard-user"></i> Tutor: <strong><asp:Label ID="lblConfirmTutor2" runat="server"></asp:Label></strong></p>
            <p>Amount: <strong>R<asp:Label ID="lblConfirmAmount2" runat="server"></asp:Label></strong></p>
            <p>Method: <asp:Label ID="lblConfirmMethod2" runat="server"></asp:Label></p>

            <br />
            <asp:Button ID="btnConfirmPay" runat="server" Text="Confirm &amp; Book Session" CssClass="btn btn-gold" OnClick="btnConfirmPay_Click" />
            <asp:Button ID="btnBackToPayment" runat="server" Text="Go Back" CssClass="btn" OnClick="btnBackToPayment_Click" CausesValidation="false" />
        </div>
    </asp:Panel>

    <!-- ===================== STEP 4: SUCCESS ===================== -->
    <asp:Panel ID="pnlConfirmation" runat="server" Visible="false">
        <h2><i class="fa-solid fa-envelope-circle-check"></i> Booking Confirmation</h2>

        <div class="email-receipt">
            <div class="email-receipt-header">
                <div class="subject"><i class="fa-solid fa-calendar-check"></i> Your tutoring session is confirmed</div>
                <div class="meta"><%: DateTime.Now.ToString("yyyy-MM-dd HH:mm") %></div>
            </div>
            <div class="email-receipt-body">
                <div class="greeting">Session Booked Successfully</div>

                <div class="email-receipt-row"><span class="label">Student</span><span class="value"><asp:Label ID="lblConfirmStudent" runat="server"></asp:Label></span></div>
                <div class="email-receipt-row"><span class="label">Tutor</span><span class="value"><asp:Label ID="lblConfirmTutor" runat="server"></asp:Label></span></div>
                <div class="email-receipt-row"><span class="label">Date</span><span class="value"><asp:Label ID="lblConfirmDate" runat="server"></asp:Label></span></div>
                <div class="email-receipt-row"><span class="label">Time</span><span class="value"><asp:Label ID="lblConfirmTime" runat="server"></asp:Label></span></div>
                <div class="email-receipt-row"><span class="label">Venue</span><span class="value"><asp:Label ID="lblConfirmVenue" runat="server"></asp:Label></span></div>
                <div class="email-receipt-row"><span class="label">Deposit Paid</span><span class="value">R<asp:Label ID="lblConfirmDeposit" runat="server"></asp:Label></span></div>

                <br />
                <a href="Sessions.aspx" class="btn btn-gold"><i class="fa-solid fa-list"></i> View My Sessions</a>
            </div>
        </div>
    </asp:Panel>

</asp:Content>