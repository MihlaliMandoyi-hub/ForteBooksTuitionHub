<%@ Page Title="Books" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Books.aspx.cs" Inherits="ForteBooksTuitionHub.Books" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="books-management">

        <div class="management-page-header">
            <div class="management-header-icon">
                <i class="fa-solid fa-book" aria-hidden="true"></i>
            </div>

            <div>
                <span class="management-eyebrow">
                    Forte Books &amp; Tuition Hub
                </span>
                <h2>Book Catalogue</h2>
                <p>Manage your collection, available copies and book rentals.</p>
            </div>
        </div>

        <div class="books-toolbar">
            <div class="books-search">
                <asp:Label ID="lblSearchCaption" runat="server"
                    AssociatedControlID="txtSearch"
                    Text="Find a book" CssClass="books-search-label" />

                <div class="books-search-controls">
                    <asp:TextBox ID="txtSearch" runat="server"
                        placeholder="Search by title or author"
                        CssClass="books-search-input" />

                    <asp:Button ID="btnSearch" runat="server"
                        Text="Search" CssClass="btn btn-gold"
                        OnClick="btnSearch_Click" />
                </div>
            </div>

            <a href="BookAdd.aspx" class="btn books-add">
                <i class="fa-solid fa-plus"></i> Add New Book
            </a>
        </div>

        <div class="books-tools">
            <a href="BookRentals.aspx" class="books-tool">
                View Rentals
            </a>

            <a href="RentalStockStatus.aspx"
                class="books-tool books-tool-stock">
                Stock Status Report
            </a>

            <a href="BookImport.aspx" class="books-tool">
                <i class="fa-solid fa-file-csv"></i> Bulk Import
            </a>

            <a href="OverdueBooks.aspx"
                class="books-tool books-tool-warning">
                Overdue Books
            </a>
        </div>

        <asp:Label ID="lblMessage" runat="server"
            ForeColor="Green" Font-Bold="true"
            CssClass="books-message" />

        <div class="books-table-wrap" tabindex="0"
            role="region" aria-label="Book catalogue table">

            <asp:GridView ID="gvBooks" runat="server"
                AutoGenerateColumns="false"
                CssClass="grid"
                DataKeyNames="BookId"
                OnRowCommand="gvBooks_RowCommand"
                GridLines="None">

                <Columns>
                    <asp:BoundField DataField="Title"
                        HeaderText="Title" />

                    <asp:BoundField DataField="Author"
                        HeaderText="Author" />

                    <asp:BoundField DataField="ISBN"
                        HeaderText="ISBN" />

                    <asp:BoundField DataField="YearPublished"
                        HeaderText="Year" />

                    <asp:BoundField DataField="Edition"
                        HeaderText="Edition" />

                    <asp:BoundField DataField="TotalCopies"
                        HeaderText="Total Copies" />

                    <asp:BoundField DataField="AvailableCopies"
                        HeaderText="Available" />

                    <asp:TemplateField HeaderText="Actions">
                        <ItemTemplate>
                            <div class="book-row-actions">
                                <a href='BookAdd.aspx?id=<%# Eval("BookId") %>'
                                    class="btn book-action-edit">
                                    Edit
                                </a>

                                <asp:Button runat="server"
                                    Text="Delete"
                                    CommandName="DeleteBook"
                                    CommandArgument='<%# Eval("BookId") %>'
                                    CssClass="btn btn-danger book-action-delete"
                                    OnClientClick="return confirm('Delete this book?');" />
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>

                <EmptyDataTemplate>
                    <div class="books-empty">
                        <i class="fa-solid fa-book" aria-hidden="true"></i>
                        <h3>No books found</h3>
                        <p>
                            Try another title or author.
                            To view the full catalogue, clear the search
                            box and select Search.
                        </p>
                    </div>
                </EmptyDataTemplate>
            </asp:GridView>
        </div>
    </div>

</asp:Content>