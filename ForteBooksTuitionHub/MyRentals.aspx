<%@ Page Title="My Book Rentals" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="MyRentals.aspx.cs" Inherits="ForteBooksTuitionHub.MyRentals" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="my-books-page">

        <div class="management-page-header">
            <div class="management-header-icon">
                <i class="fa-solid fa-book-open" aria-hidden="true"></i>
            </div>
            <div>
                <div class="management-eyebrow">Forte Books &amp; Tuition Hub</div>
                <h2>My Personal Bookshelf</h2>
                <p>Your borrowed books, return dates and reading history.</p>
            </div>
        </div>

        <div class="my-books-toolbar">
            <div>
                <h3>A little reading. A lot of possibility.</h3>
                <p>Current loans appear first, followed by returned books.</p>
            </div>
            <a href="BookCatalogue.aspx" class="btn btn-gold">
                <i class="fa-solid fa-book-open" aria-hidden="true"></i>
                Explore the Catalogue
            </a>
        </div>

        <div class="my-books-content">

            <asp:Label ID="lblMessage" runat="server"
                CssClass="my-books-message"
                role="status"></asp:Label>

            <div class="my-books-legend">
                <span><i class="legend-dot loan"></i> On loan</span>
                <span><i class="legend-dot overdue"></i> Overdue</span>
                <span><i class="legend-dot returned"></i> Returned</span>
            </div>

            <asp:GridView ID="gvMyRentals" runat="server"
                AutoGenerateColumns="false"
                ShowHeader="false"
                GridLines="None"
                CssClass="my-books-grid"
                OnRowDataBound="gvMyRentals_RowDataBound"
                OnRowCommand="gvMyRentals_RowCommand">

                <Columns>
                    <asp:TemplateField>
                        <ItemTemplate>

                            <article class='<%# "rental-book-card is-" + RentalState(Eval("ReturnDate"), Eval("DueDate")) %>'>

                                <div class="rental-book-stage">
                                    <div class="rental-book-object" aria-hidden="true">
                                        <div class="rental-book-cover">

                                            <span class="book-cover-brand">FORTE BOOKS</span>

                                            <div class="book-cover-emblem">
                                                <i class="fa-solid fa-book-open"></i>
                                            </div>

                                            <div class="book-cover-title">
                                                <%#: Eval("Title") %>
                                            </div>

                                            <div class="book-cover-rule"></div>
                                            <span class="book-cover-footer">READ · LEARN · GROW</span>

                                        </div>
                                    </div>
                                </div>

                                <div class="rental-book-information">

                                    <div class='<%# "rental-status status-" + RentalState(Eval("ReturnDate"), Eval("DueDate")) %>'>
                                        <asp:Label ID="lblStatus" runat="server"></asp:Label>
                                    </div>

                                    <h3 class="rental-book-title">
                                        <%#: Eval("Title") %>
                                    </h3>

                                    <p class="rental-book-author">
                                        <i class="fa-solid fa-pen-nib" aria-hidden="true"></i>
                                        <%#: BookDetail(Eval("Author")) %>
                                    </p>

                                    <div class="rental-publication">

                                        <div class="rental-isbn">
                                            <span class="rental-detail-label">ISBN</span>
                                            <strong><%#: BookDetail(Eval("ISBN")) %></strong>
                                        </div>

                                        <div>
                                            <span class="rental-detail-label">Edition</span>
                                            <strong><%#: BookDetail(Eval("Edition")) %></strong>
                                        </div>

                                        <div>
                                            <span class="rental-detail-label">Published</span>
                                            <strong><%#: BookDetail(Eval("YearPublished")) %></strong>
                                        </div>

                                    </div>

                                    <div class="rental-date-grid">
                                        <div>
                                            <span class="rental-detail-label">
                                                <i class="fa-solid fa-calendar-plus" aria-hidden="true"></i>
                                                Borrowed
                                            </span>
                                            <strong><%#: Eval("IssueDate", "{0:dd MMM yyyy}") %></strong>
                                        </div>
                                        <div>
                                            <span class="rental-detail-label">
                                                <i class="fa-solid fa-calendar-check" aria-hidden="true"></i>
                                                Return due
                                            </span>
                                            <strong><%#: Eval("DueDate", "{0:dd MMM yyyy}") %></strong>
                                        </div>
                                    </div>

                                    <div class="rental-time-note">
                                        <i class='<%# RentalState(Eval("ReturnDate"), Eval("DueDate")) == "returned"
                                            ? "fa-solid fa-circle-check"
                                            : "fa-solid fa-clock" %>' aria-hidden="true"></i>

                                        <span><%#: RentalReminder(Eval("ReturnDate"), Eval("DueDate")) %></span>
                                    </div>

                                    <div class="rental-fine-panel">
                                        <div>
                                            <span class="rental-detail-label">Fine owed</span>
                                            <asp:Label ID="lblFine" runat="server"
                                                CssClass="rental-fine-value"></asp:Label>
                                        </div>

                                        <asp:HyperLink ID="lnkPayFine" runat="server"
                                            CssClass="btn btn-gold rental-pay-button">
                                            <i class="fa-solid fa-credit-card" aria-hidden="true"></i>
                                            Pay Fine
                                        </asp:HyperLink>
                                    </div>

                                    <div class="rental-return-area">

                                        <asp:Button ID="btnReturnBook" runat="server"
                                            Text="Return Book"
                                            CssClass="btn rental-return-button"
                                            CommandName="ReturnBook"
                                            CommandArgument='<%# Eval("RentalId") %>'
                                            Visible='<%# Eval("ReturnDate") == DBNull.Value %>'
                                            CausesValidation="false"
                                            OnClientClick="return confirm('Confirm that you have physically returned this book to the centre. Any unpaid late fine will remain payable.');" />

                                        <p class="rental-return-help"
                                            runat="server"
                                            Visible='<%# Eval("ReturnDate") == DBNull.Value %>'>
                                            Confirm only after returning the physical book to the centre.
                                        </p>

                                    </div>

                                </div>
                            </article>

                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>

                <EmptyDataTemplate>
                    <div class="my-books-empty">
                        <div class="my-books-empty-icon">
                            <i class="fa-solid fa-book-open" aria-hidden="true"></i>
                        </div>
                        <h3>Your bookshelf is ready for its first book</h3>
                        <p>Explore the catalogue to discover your next read.</p>
                        <a href="BookCatalogue.aspx" class="btn btn-gold">Browse Books</a>
                    </div>
                </EmptyDataTemplate>

            </asp:GridView>

            <div class="my-books-care">
                <div class="my-books-care-icon">
                    <i class="fa-solid fa-bookmark" aria-hidden="true"></i>
                </div>
                <div>
                    <h3>Good books deserve good care</h3>
                    <p>
                        Use a bookmark, keep pages clean and dry, and return books
                        on time so another student can enjoy them.
                    </p>
                </div>
            </div>

        </div>
    </div>

</asp:Content>