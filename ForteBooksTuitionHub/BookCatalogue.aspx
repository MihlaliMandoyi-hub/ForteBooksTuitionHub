<%@ Page Title="Book Catalogue" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="BookCatalogue.aspx.cs" Inherits="ForteBooksTuitionHub.BookCatalogue" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="my-books-page catalogue-page">

        <div class="management-page-header">
            <div class="management-header-icon">
                <i class="fa-solid fa-book-open" aria-hidden="true"></i>
            </div>
            <div>
                <div class="management-eyebrow">Forte Books &amp; Tuition Hub</div>
                <h2>Discover Your Next Read</h2>
                <p>Explore the collection and find a book for your next chapter.</p>
            </div>
        </div>

        <div class="catalogue-benefits">

            <div>
                <span class="catalogue-benefit-icon">
                    <i class="fa-solid fa-book" aria-hidden="true"></i>
                </span>
                <div>
                    <strong>Free book rentals</strong>
                    <span>Learning within reach</span>
                </div>
            </div>

            <div>
                <span class="catalogue-benefit-icon">
                    <i class="fa-solid fa-calendar-days" aria-hidden="true"></i>
                </span>
                <div>
                    <strong>14-day loan period</strong>
                    <span>Make time for your next read</span>
                </div>
            </div>

            <div>
                <span class="catalogue-benefit-icon">
                    <i class="fa-solid fa-clock" aria-hidden="true"></i>
                </span>
                <div>
                    <strong>Return on time</strong>
                    <span>Late returns cost R5.00 per day</span>
                </div>
            </div>

        </div>

        <asp:Panel ID="pnlCatalogueSearch" runat="server"
            CssClass="catalogue-search"
            DefaultButton="btnFilter">

            <div class="catalogue-search-field">
                <asp:Label ID="lblSearchCaption" runat="server"
                    AssociatedControlID="txtSearch"
                    Text="Find a book"></asp:Label>

                <asp:TextBox ID="txtSearch" runat="server"
                    placeholder="Search by title, author or ISBN"></asp:TextBox>
            </div>

            <div class="catalogue-sort-field">
                <asp:Label ID="lblSortCaption" runat="server"
                    AssociatedControlID="ddlSort"
                    Text="Arrange your bookshelf"></asp:Label>

                <asp:DropDownList ID="ddlSort" runat="server">
                    <asp:ListItem Text="Title (A - Z)" Value="TitleAsc" />
                    <asp:ListItem Text="Title (Z - A)" Value="TitleDesc" />
                    <asp:ListItem Text="Year (Newest First)" Value="YearDesc" />
                    <asp:ListItem Text="Year (Oldest First)" Value="YearAsc" />
                    <asp:ListItem Text="Most Available Copies" Value="AvailDesc" />
                </asp:DropDownList>
            </div>

            <div class="catalogue-search-actions">
                <asp:Button ID="btnFilter" runat="server"
                    Text="Search"
                    CssClass="btn btn-gold"
                    OnClick="btnFilter_Click" />

                <asp:Button ID="btnClear" runat="server"
                    Text="Clear"
                    CssClass="btn catalogue-clear"
                    OnClick="btnClear_Click"
                    CausesValidation="false" />
            </div>

        </asp:Panel>

        <div class="my-books-content">

            <asp:Label ID="lblMessage" runat="server"
                ForeColor="Green" Font-Bold="true"
                CssClass="my-books-message"
                role="status"></asp:Label>

            <asp:Label ID="lblError" runat="server"
                CssClass="catalogue-error"
                role="alert"></asp:Label>

            <div class="catalogue-collection-heading">
                <div>
                    <h3>The Collection</h3>
                    <p>Check the available copies before choosing your book.</p>
                </div>

                <span class="catalogue-cover-note">
                    <i class="fa-solid fa-palette" aria-hidden="true"></i>
                    Illustrated covers
                </span>
            </div>

            <asp:GridView ID="gvBooks" runat="server"
                AutoGenerateColumns="false"
                ShowHeader="false"
                GridLines="None"
                DataKeyNames="BookId"
                CssClass="my-books-grid catalogue-grid"
                OnRowCommand="gvBooks_RowCommand"
                OnRowDataBound="gvBooks_RowDataBound">

                <Columns>
                    <asp:TemplateField>
                        <ItemTemplate>

                            <article class='<%# Convert.ToInt32(Eval("AvailableCopies")) > 0
                                ? "rental-book-card catalogue-book available-book"
                                : "rental-book-card catalogue-book unavailable-book" %>'>

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

                                    <span class='<%# Convert.ToInt32(Eval("AvailableCopies")) > 0
                                        ? "catalogue-availability available"
                                        : "catalogue-availability unavailable" %>'>

                                        <i class='<%# Convert.ToInt32(Eval("AvailableCopies")) > 0
                                            ? "fa-solid fa-circle-check"
                                            : "fa-solid fa-clock" %>' aria-hidden="true"></i>

                                        <%#: Convert.ToInt32(Eval("AvailableCopies")) > 0
                                            ? "Available to borrow"
                                            : "All copies on loan" %>

                                    </span>

                                    <h3 class="rental-book-title">
                                        <%#: Eval("Title") %>
                                    </h3>

                                    <p class="rental-book-author">
                                        <i class="fa-solid fa-pen-nib" aria-hidden="true"></i>
                                        <%#: string.IsNullOrWhiteSpace(Convert.ToString(Eval("Author")))
                                            ? "Author not listed"
                                            : Convert.ToString(Eval("Author")) %>
                                    </p>

                                    <div class="rental-publication">

                                        <div class="rental-isbn">
                                            <span class="rental-detail-label">ISBN</span>
                                            <strong>
                                                <%#: string.IsNullOrWhiteSpace(Convert.ToString(Eval("ISBN")))
                                                    ? "Not listed"
                                                    : Convert.ToString(Eval("ISBN")) %>
                                            </strong>
                                        </div>

                                        <div>
                                            <span class="rental-detail-label">Edition</span>
                                            <strong>
                                                <%#: string.IsNullOrWhiteSpace(Convert.ToString(Eval("Edition")))
                                                    ? "Not listed"
                                                    : Convert.ToString(Eval("Edition")) %>
                                            </strong>
                                        </div>

                                        <div>
                                            <span class="rental-detail-label">Published</span>
                                            <strong>
                                                <%#: string.IsNullOrWhiteSpace(Convert.ToString(Eval("YearPublished")))
                                                    ? "Not listed"
                                                    : Convert.ToString(Eval("YearPublished")) %>
                                            </strong>
                                        </div>

                                    </div>

                                    <div class="catalogue-stock">
                                        <div>
                                            <strong><%#: Eval("AvailableCopies") %></strong>
                                            <span>Available copies</span>
                                        </div>
                                        <div>
                                            <strong><%#: Eval("TotalCopies") %></strong>
                                            <span>In the collection</span>
                                        </div>
                                    </div>

                                    <div class="catalogue-rent-area">

                                        <asp:Button ID="btnRent" runat="server"
                                            Text="Rent This Book"
                                            CommandName="RentBook"
                                            CommandArgument='<%# Eval("BookId") %>'
                                            CssClass="btn btn-gold catalogue-rent-button"
                                            CausesValidation="false"
                                            OnClientClick="return confirm('Rent this book for 14 days? Late returns cost R5.00 per day.');" />

                                    </div>

                                </div>

                            </article>

                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>

                <EmptyDataTemplate>
                    <div class="my-books-empty">
                        <div class="my-books-empty-icon">
                            <i class="fa-solid fa-magnifying-glass" aria-hidden="true"></i>
                        </div>
                        <h3>No books found</h3>
                        <p>
                            Try a different title, author or ISBN.
                            Use Clear to view the full collection.
                        </p>
                    </div>
                </EmptyDataTemplate>

            </asp:GridView>

            <div class="my-books-care">
                <div class="my-books-care-icon">
                    <i class="fa-solid fa-bookmark" aria-hidden="true"></i>
                </div>
                <div>
                    <h3>Your next chapter starts here</h3>
                    <p>
                        Borrowing is free. Keep your book in good condition and return it
                        within 14 days so the next reader can enjoy it too.
                    </p>
                </div>
            </div>

        </div>
    </div>

</asp:Content>