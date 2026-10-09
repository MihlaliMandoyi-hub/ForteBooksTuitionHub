<%@ Page Title="Issue Book" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="RentalIssue.aspx.cs" Inherits="ForteBooksTuitionHub.RentalIssue" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="rental-issue-workspace">

        <div class="management-page-header">
            <div class="management-header-icon">
                <i class="fa-solid fa-book" aria-hidden="true"></i>
            </div>

            <div>
                <span class="management-eyebrow">
                    Forte Books &amp; Tuition Hub
                </span>
                <h2>Issue Book to Student</h2>
                <p>Select an available book, choose the student and set the loan period.</p>
            </div>
        </div>

        <div class="rental-issue-body">

            <div class="rental-issue-intro">
                <div>
                    <h3>New book rental</h3>
                    <p>All three fields are required.</p>
                </div>

                <a href="BookRentals.aspx" class="rental-issue-back">
                    Back to rentals
                </a>
            </div>

            <div class="rental-issue-fields">

                <div class="rental-issue-field">
                    <asp:Label ID="lblBookCaption" runat="server"
                        AssociatedControlID="ddlBook"
                        Text="Book *" />

                    <asp:DropDownList ID="ddlBook" runat="server"
                        DataTextField="DisplayText"
                        DataValueField="BookId"
                        AppendDataBoundItems="true">
                        <asp:ListItem Text="-- Select Book --" Value="0" />
                    </asp:DropDownList>

                    <span class="rental-issue-hint">
                        Only books with available copies appear here.
                    </span>
                </div>

                <div class="rental-issue-field">
                    <asp:Label ID="lblStudentCaption" runat="server"
                        AssociatedControlID="ddlStudent"
                        Text="Student *" />

                    <asp:DropDownList ID="ddlStudent" runat="server"
                        DataTextField="FullName"
                        DataValueField="StudentId"
                        AppendDataBoundItems="true">
                        <asp:ListItem Text="-- Select Student --" Value="0" />
                    </asp:DropDownList>

                    <span class="rental-issue-hint">
                        Choose the student receiving this copy.
                    </span>
                </div>

                <div class="rental-issue-field">
                    <asp:Label ID="lblLoanDaysCaption" runat="server"
                        AssociatedControlID="txtLoanDays"
                        Text="Loan period (days) *" />

                    <asp:TextBox ID="txtLoanDays" runat="server"
                        Text="14" />

                    <asp:RequiredFieldValidator runat="server"
                        ControlToValidate="txtLoanDays"
                        ErrorMessage="Enter the loan period."
                        CssClass="error-text"
                        Display="Dynamic" />

                    <asp:RegularExpressionValidator runat="server"
                        ControlToValidate="txtLoanDays"
                        ValidationExpression="^[1-9]\d*$"
                        ErrorMessage="Enter a whole number of days."
                        CssClass="error-text"
                        Display="Dynamic" />

                    <span class="rental-issue-hint">
                        Enter a whole number greater than zero.
                    </span>
                </div>

                <div class="rental-issue-note">
                    <strong>How this rental works</strong>
                    <p>
                        The issue date is today. The due date is calculated
                        using your chosen loan period.
                    </p>
                    <p>
                        Issuing the book reduces its available copies by one.
                    </p>
                </div>

            </div>

            <asp:Label ID="lblError" runat="server"
                CssClass="error-text rental-issue-error"
                role="alert" />

        </div>

        <div class="rental-issue-actions">
            <span>Check the book and student before issuing.</span>

            <div>
                <a href="BookRentals.aspx" class="btn rental-issue-cancel">
                    Cancel
                </a>

                <asp:Button ID="btnIssue" runat="server"
                    Text="Issue Book"
                    CssClass="btn btn-gold"
                    OnClick="btnIssue_Click" />
            </div>
        </div>

    </div>

</asp:Content>
