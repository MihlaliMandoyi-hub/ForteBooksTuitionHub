<%@ Page Title="Add Book" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="BookAdd.aspx.cs" Inherits="ForteBooksTuitionHub.BookAdd" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="book-editor">

        <div class="management-page-header">
            <div class="management-header-icon">
                <i class="fa-solid fa-book" aria-hidden="true"></i>
            </div>

            <div>
                <span class="management-eyebrow">
                    Forte Books &amp; Tuition Hub
                </span>

                <h2>
                    <asp:Label ID="lblTitle" runat="server"
                        Text="Add New Book" />
                </h2>

                <p>Keep your catalogue accurate with clear book and stock details.</p>
            </div>
        </div>

        <div class="book-editor-body">
            <asp:HiddenField ID="hfBookId" runat="server" Value="0" />

            <div class="book-editor-intro">
                <div>
                    <h3>Book information</h3>
                    <p>Fields marked * are required.</p>
                </div>

                <a href="Books.aspx" class="book-editor-back">
                    Back to catalogue
                </a>
            </div>

            <div class="book-editor-section">
                <div class="book-section-heading">
                    <span class="book-section-number">01</span>

                    <div>
                        <h3>Publication details</h3>
                        <p>Identify the book and its edition.</p>
                    </div>
                </div>

                <div class="book-field-grid">
                    <div class="book-field">
                        <asp:Label ID="lblBookTitleCaption" runat="server"
                            AssociatedControlID="txtTitle"
                            Text="Title *" />

                        <asp:TextBox ID="txtTitle" runat="server"
                            placeholder="e.g. Introduction to Algebra" />

                        <asp:RequiredFieldValidator runat="server"
                            ControlToValidate="txtTitle"
                            ErrorMessage="Title is required."
                            CssClass="error-text" Display="Dynamic" />
                    </div>

                    <div class="book-field">
                        <asp:Label ID="lblAuthorCaption" runat="server"
                            AssociatedControlID="txtAuthor"
                            Text="Author *" />

                        <asp:TextBox ID="txtAuthor" runat="server"
                            placeholder="e.g. J. Smith" />

                        <asp:RequiredFieldValidator runat="server"
                            ControlToValidate="txtAuthor"
                            ErrorMessage="Author is required."
                            CssClass="error-text" Display="Dynamic" />
                    </div>

                    <div class="book-field">
                        <asp:Label ID="lblIsbnCaption" runat="server"
                            AssociatedControlID="txtIsbn"
                            Text="ISBN (optional)" />

                        <asp:TextBox ID="txtIsbn" runat="server"
                            placeholder="e.g. 978-3-16-148410-0"
                            MaxLength="20" />

                        <asp:RegularExpressionValidator runat="server"
                            ControlToValidate="txtIsbn"
                            ValidationExpression="^[0-9Xx\-\s]{0,20}$"
                            ErrorMessage="ISBN can only contain numbers, dashes, and X."
                            CssClass="error-text" Display="Dynamic" />
                    </div>

                    <div class="book-field">
                        <asp:Label ID="lblYearCaption" runat="server"
                            AssociatedControlID="txtYear"
                            Text="Year of publication (optional)" />

                        <asp:TextBox ID="txtYear" runat="server"
                            placeholder="e.g. 2021" />

                        <asp:RegularExpressionValidator runat="server"
                            ControlToValidate="txtYear"
                            ValidationExpression="^(19|20)\d{2}$"
                            ErrorMessage="Enter a valid 4-digit year (e.g. 2021)."
                            CssClass="error-text" Display="Dynamic" />
                    </div>

                    <div class="book-field">
                        <asp:Label ID="lblEditionCaption" runat="server"
                            AssociatedControlID="txtEdition"
                            Text="Edition (optional)" />

                        <asp:TextBox ID="txtEdition" runat="server"
                            placeholder="e.g. 3rd Edition" />
                    </div>
                </div>
            </div>

            <div class="book-editor-section">
                <div class="book-section-heading">
                    <span class="book-section-number">02</span>

                    <div>
                        <h3>Stock details</h3>
                        <p>Record the total number of copies owned by the centre.</p>
                    </div>
                </div>

                <div class="book-stock-layout">
                    <div class="book-field">
                        <asp:Label ID="lblCopiesCaption" runat="server"
                            AssociatedControlID="txtTotalCopies"
                            Text="Total copies *" />

                        <asp:TextBox ID="txtTotalCopies" runat="server"
                            placeholder="e.g. 5" />

                        <asp:RequiredFieldValidator runat="server"
                            ControlToValidate="txtTotalCopies"
                            ErrorMessage="Total copies is required."
                            CssClass="error-text" Display="Dynamic" />

                        <asp:RegularExpressionValidator runat="server"
                            ControlToValidate="txtTotalCopies"
                            ValidationExpression="^[1-9]\d*$"
                            ErrorMessage="Enter a whole number greater than 0."
                            CssClass="error-text" Display="Dynamic" />
                    </div>

                    <div class="book-stock-note">
                        <strong>How availability works</strong>
                        <p>
                            New books start with all copies available.
                            When editing, copies currently on loan
                            are deducted automatically.
                        </p>
                    </div>
                </div>
            </div>

            <asp:Label ID="lblError" runat="server"
                CssClass="error-text book-editor-error" />
        </div>

        <div class="book-editor-actions">
            <span>Check the details before saving.</span>

            <div>
                <a href="Books.aspx" class="btn book-editor-cancel">
                    Cancel
                </a>

                <asp:Button ID="btnSave" runat="server"
                    Text="Save Book" CssClass="btn btn-gold"
                    OnClick="btnSave_Click" />
            </div>
        </div>
    </div>

</asp:Content>