<%@ Page Title="Tutor Details" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="TutorAdd.aspx.cs" Inherits="ForteBooksTuitionHub.TutorAdd" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="student-editor tutor-editor">

        <div class="management-page-header">
            <div class="management-header-icon">
                <i class="fa-solid fa-chalkboard-user" aria-hidden="true"></i>
            </div>

            <div>
                <div class="management-eyebrow">FORTE BOOKS &amp; TUITION HUB</div>
                <h2>
                    <asp:Label ID="lblTitle" runat="server"
                        Text="Add New Tutor"></asp:Label>
                </h2>
                <p>Manage tutor contact details, teaching subjects and hourly rates.</p>
            </div>
        </div>

        <asp:Panel ID="pnlTutorEditor" runat="server"
            CssClass="student-editor-body"
            DefaultButton="btnSave">

            <asp:HiddenField ID="hfTutorId" runat="server" Value="0" />

            <div class="student-editor-toolbar">
                <div>
                    <h3>Tutor information</h3>
                    <p>All fields below are required.</p>
                </div>

                <a href="Tutors.aspx" class="btn student-editor-back">
                    <i class="fa-solid fa-arrow-left" aria-hidden="true"></i>
                    Back to Tutors
                </a>
            </div>

            <div class="student-editor-section">

                <div class="student-editor-heading">
                    <span>01</span>
                    <div>
                        <h3>Personal &amp; contact details</h3>
                        <p>Keep the tutor’s contact information up to date.</p>
                    </div>
                </div>

                <div class="student-editor-fields">

                    <div class="student-editor-field student-editor-wide">
                        <asp:Label runat="server"
                            AssociatedControlID="txtFullName"
                            Text="Full name *"></asp:Label>

                        <asp:TextBox ID="txtFullName" runat="server"
                            autocomplete="name"
                            placeholder="e.g. Sipho Ndlovu"></asp:TextBox>

                        <asp:RequiredFieldValidator runat="server"
                            ControlToValidate="txtFullName"
                            ErrorMessage="Full name is required."
                            CssClass="error-text"
                            Display="Dynamic" />
                    </div>

                    <div class="student-editor-field">
                        <asp:Label runat="server"
                            AssociatedControlID="txtEmail"
                            Text="Email address *"></asp:Label>

                        <asp:TextBox ID="txtEmail" runat="server"
                            TextMode="Email"
                            autocomplete="email"
                            placeholder="tutor@example.com"></asp:TextBox>

                        <asp:RequiredFieldValidator runat="server"
                            ControlToValidate="txtEmail"
                            ErrorMessage="Email is required."
                            CssClass="error-text"
                            Display="Dynamic" />

                        <asp:RegularExpressionValidator runat="server"
                            ControlToValidate="txtEmail"
                            ValidationExpression="^[^@\s]+@[^@\s]+\.[^@\s]+$"
                            ErrorMessage="Enter a valid email address."
                            CssClass="error-text"
                            Display="Dynamic" />
                    </div>

                    <div class="student-editor-field">
                        <asp:Label runat="server"
                            AssociatedControlID="txtPhone"
                            Text="Phone number *"></asp:Label>

                        <asp:TextBox ID="txtPhone" runat="server"
                            autocomplete="tel"
                            inputmode="tel"
                            placeholder="e.g. 0731234567"></asp:TextBox>

                        <asp:RequiredFieldValidator runat="server"
                            ControlToValidate="txtPhone"
                            ErrorMessage="Phone number is required."
                            CssClass="error-text"
                            Display="Dynamic" />

                        <asp:RegularExpressionValidator runat="server"
                            ControlToValidate="txtPhone"
                            ValidationExpression="^0\d{9}$"
                            ErrorMessage="Enter a valid 10-digit phone number starting with 0."
                            CssClass="error-text"
                            Display="Dynamic" />

                        <p class="student-editor-help">
                            Enter 10 digits, starting with 0.
                        </p>
                    </div>

                </div>
            </div>

            <div class="student-editor-section">

                <div class="student-editor-heading">
                    <span>02</span>
                    <div>
                        <h3>Teaching &amp; pricing</h3>
                        <p>Specify the tutor’s subject and rate per hour.</p>
                    </div>
                </div>

                <div class="student-editor-fields">

                    <div class="student-editor-field">
                        <asp:Label runat="server"
                            AssociatedControlID="txtSubject"
                            Text="Subject / specialty *"></asp:Label>

                        <asp:TextBox ID="txtSubject" runat="server"
                            placeholder="e.g. Mathematics"></asp:TextBox>

                        <asp:RequiredFieldValidator runat="server"
                            ControlToValidate="txtSubject"
                            ErrorMessage="Subject is required."
                            CssClass="error-text"
                            Display="Dynamic" />

                        <p class="student-editor-help">
                            Enter the subject or specialty offered by this tutor.
                        </p>
                    </div>

                    <div class="student-editor-field">
                        <asp:Label runat="server"
                            AssociatedControlID="txtHourlyRate"
                            Text="Hourly rate (R) *"></asp:Label>

                        <asp:TextBox ID="txtHourlyRate" runat="server"
                            inputmode="decimal"
                            placeholder="e.g. 150.00"></asp:TextBox>

                        <asp:RequiredFieldValidator runat="server"
                            ControlToValidate="txtHourlyRate"
                            ErrorMessage="Hourly rate is required."
                            CssClass="error-text"
                            Display="Dynamic" />

                        <asp:RegularExpressionValidator runat="server"
                            ControlToValidate="txtHourlyRate"
                            ValidationExpression="^\d+(\.\d{1,2})?$"
                            ErrorMessage="Enter a valid amount (e.g. 150 or 150.00)."
                            CssClass="error-text"
                            Display="Dynamic" />

                        <p class="student-editor-help">
                            Use a full stop for decimals, for example 150.00.
                        </p>
                    </div>

                </div>

                <div class="student-editor-note tutor-editor-note">
                    <i class="fa-solid fa-circle-info" aria-hidden="true"></i>
                    <div>
                        <strong>Tutor record only</strong>
                        <p>
                            This form saves tutor details.
                            It does not create a sign-in account or approve a tutor application.
                        </p>
                    </div>
                </div>

            </div>

            <asp:Label ID="lblError" runat="server"
                CssClass="student-editor-error"
                role="alert"></asp:Label>

            <div class="student-editor-actions">
                <asp:Button ID="btnSave" runat="server"
                    Text="Save Tutor Details"
                    CssClass="btn btn-gold"
                    OnClick="btnSave_Click" />

                <a href="Tutors.aspx" class="btn student-editor-back">
                    Cancel
                </a>
            </div>

        </asp:Panel>
    </div>

</asp:Content>