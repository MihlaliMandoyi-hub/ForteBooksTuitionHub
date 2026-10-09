<%@ Page Title="Bulk Import Books" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="BookImport.aspx.cs" Inherits="ForteBooksTuitionHub.BookImport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="student-editor book-import-page">

        <div class="management-page-header">
            <div class="management-header-icon">
                <i class="fa-solid fa-file-csv" aria-hidden="true"></i>
            </div>
            <div>
                <div class="management-eyebrow">FORTE BOOKS &amp; TUITION HUB</div>
                <h2>Bulk Book Import</h2>
                <p>Bring book records into the catalogue with clear column matching.</p>
            </div>
        </div>

        <div class="student-editor-body">

            <div class="student-editor-toolbar">
                <div>
                    <h3>Prepare your collection</h3>
                    <p>Download the template, fill in your books and upload the CSV.</p>
                </div>

                <a href="Books.aspx" class="btn student-editor-back">
                    <i class="fa-solid fa-arrow-left" aria-hidden="true"></i>
                    Back to Catalogue
                </a>
            </div>

            <div class="student-editor-section">

                <div class="student-editor-heading">
                    <span>01</span>
                    <div>
                        <h3>Match your column headings</h3>
                        <p>Columns can appear in any order. The headings identify each field.</p>
                    </div>
                </div>

                <div class="import-columns">
                    <div><strong>Title</strong><span>Required · book title</span></div>
                    <div><strong>Author</strong><span>Required · author name</span></div>
                    <div><strong>TotalCopies</strong><span>Required · positive whole number</span></div>
                    <div><strong>ISBN</strong><span>Optional · keep as text</span></div>
                    <div><strong>YearPublished</strong><span>Optional · year from 1 to 9999</span></div>
                    <div><strong>Edition</strong><span>Optional · edition description</span></div>
                </div>

                <div class="student-editor-note import-note">
                    <i class="fa-solid fa-circle-info" aria-hidden="true"></i>
                    <div>
                        <strong>New stock records</strong>
                        <p>
                            This imports new books, not updates to existing records.
                            Available copies start equal to TotalCopies.
                            Existing loans and stock reports should not be imported here.
                        </p>
                    </div>
                </div>

                <asp:Button ID="btnSample" runat="server"
                    Text="Download Sample CSV"
                    CssClass="btn student-editor-back import-template"
                    OnClick="btnSample_Click"
                    CausesValidation="false" />

            </div>

            <div class="student-editor-section">

                <div class="student-editor-heading">
                    <span>02</span>
                    <div>
                        <h3>Upload your CSV</h3>
                        <p>Use a UTF-8, comma-separated CSV file up to 2 MB.</p>
                    </div>
                </div>

                <div class="import-upload">
                    <i class="fa-solid fa-file-arrow-up" aria-hidden="true"></i>

                    <asp:Label runat="server"
                        AssociatedControlID="fuCsv"
                        Text="Choose your book import file"></asp:Label>

                    <asp:FileUpload ID="fuCsv" runat="server"
                        accept=".csv"
                        CssClass="import-file" />

                    <p>
                        Every row is checked before saving.
                        If a row is invalid, no books are imported.
                    </p>
                </div>

                <asp:Label ID="lblError" runat="server"
                    CssClass="student-editor-error import-error"
                    role="alert"></asp:Label>

                <asp:Button ID="btnImport" runat="server"
                    Text="Validate &amp; Import Books"
                    CssClass="btn btn-gold"
                    OnClick="btnImport_Click" />

            </div>

            <asp:Panel ID="pnlResults" runat="server"
                Visible="false" CssClass="import-success" role="status">
                <i class="fa-solid fa-circle-check" aria-hidden="true"></i>
                <div>
                    <h3>Import complete</h3>
                    <asp:Label ID="lblSummary" runat="server"></asp:Label>
                </div>
            </asp:Panel>

            <asp:Panel ID="pnlSkipped" runat="server"
                Visible="false" CssClass="import-problems">
                <h3>
                    <i class="fa-solid fa-triangle-exclamation" aria-hidden="true"></i>
                    Please correct these rows
                </h3>
                <p>No books were imported. Fix the file and upload it again.</p>
                <asp:Literal ID="litSkipped" runat="server"></asp:Literal>
            </asp:Panel>

        </div>
    </div>

</asp:Content>