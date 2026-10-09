<%@ Page Title="Student Details" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="StudentAdd.aspx.cs" Inherits="ForteBooksTuitionHub.StudentAdd" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="student-editor">

        <div class="management-page-header">
            <div class="management-header-icon">
                <i class="fa-solid fa-user-graduate" aria-hidden="true"></i>
            </div>
            <div>
                <div class="management-eyebrow">FORTE BOOKS &amp; TUITION HUB</div>
                <h2>
                    <asp:Label ID="lblTitle" runat="server"
                        Text="Register New Student"></asp:Label>
                </h2>
                <p>Keep student records clear, accurate and easy to manage.</p>
            </div>
        </div>

        <asp:Panel ID="pnlStudentEditor" runat="server"
            CssClass="student-editor-body"
            DefaultButton="btnSave">

            <asp:HiddenField ID="hfStudentId" runat="server" Value="0" />

            <div class="student-editor-toolbar">
                <div>
                    <h3>Student information</h3>
                    <p>Fields marked * are required.</p>
                </div>

                <a href="Students.aspx" class="btn student-editor-back">
                    <i class="fa-solid fa-arrow-left" aria-hidden="true"></i>
                    Back to Students
                </a>
            </div>

            <div class="student-editor-section">

                <div class="student-editor-heading">
                    <span>01</span>
                    <div>
                        <h3>Personal &amp; contact details</h3>
                        <p>Use the student’s current contact information.</p>
                    </div>
                </div>

                <div class="student-editor-fields">

                    <div class="student-editor-field student-editor-wide">
                        <asp:Label runat="server"
                            AssociatedControlID="txtFullName"
                            Text="Full name *"></asp:Label>

                        <asp:TextBox ID="txtFullName" runat="server"
                            autocomplete="name"
                            placeholder="e.g. Thandiwe Mtshali"></asp:TextBox>

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
                            placeholder="student@example.com"></asp:TextBox>

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
                            placeholder="e.g. 0821234567"></asp:TextBox>

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
                        <h3>Registration record</h3>
                        <p>Confirm the date associated with this student record.</p>
                    </div>
                </div>

                <div class="student-editor-fields">

                    <div class="student-editor-field">
                        <asp:Label runat="server"
                            AssociatedControlID="txtDateRegistered"
                            Text="Date registered *"></asp:Label>

                        <asp:TextBox ID="txtDateRegistered" runat="server"
                            TextMode="Date"></asp:TextBox>

                        <asp:RequiredFieldValidator runat="server"
                            ControlToValidate="txtDateRegistered"
                            ErrorMessage="Registration date is required."
                            CssClass="error-text"
                            Display="Dynamic" />
                    </div>

                    <div class="student-editor-note">
                        <i class="fa-solid fa-circle-info" aria-hidden="true"></i>
                        <div>
                            <strong>Student record only</strong>
                            <p>
                                Saving this form creates or updates a student record.
                                It does not create a sign-in account.
                            </p>
                        </div>
                    </div>

                </div>
            </div>

            <asp:Label ID="lblError" runat="server"
                CssClass="student-editor-error"
                role="alert"></asp:Label>

            <div class="student-editor-actions">
                <asp:Button ID="btnSave" runat="server"
                    Text="Save Student Details"
                    CssClass="btn btn-gold"
                    OnClick="btnSave_Click" />

                <a href="Students.aspx" class="btn student-editor-back">
                    Cancel
                </a>
            </div>

        </asp:Panel>
    </div>

</asp:Content>