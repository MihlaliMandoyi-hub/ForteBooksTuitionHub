<%@ Page Title="Book Stock Status" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="RentalStockStatus.aspx.cs" Inherits="ForteBooksTuitionHub.RentalStockStatus" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="utilisation-page stock-report">

        <div class="management-page-header">
            <div class="management-header-icon">
                <i class="fa-solid fa-boxes-stacked" aria-hidden="true"></i>
            </div>
            <div>
                <div class="management-eyebrow">FORTE BOOKS &amp; TUITION HUB</div>
                <h2>Book Stock Status</h2>
                <p>A clear view of the collection, available copies and outstanding loans.</p>
            </div>
        </div>

        <div class="utilisation-toolbar no-print">
            <a href="Books.aspx" class="btn utilisation-secondary">
                <i class="fa-solid fa-arrow-left" aria-hidden="true"></i>
                Back to Catalogue
            </a>

            <div>
                <asp:Button ID="btnPrint" runat="server"
                    Text="Print Report"
                    CssClass="btn btn-gold"
                    CausesValidation="false"
                    OnClientClick="window.print(); return false;" />

                <asp:Button ID="btnExport" runat="server"
                    Text="Download CSV"
                    CssClass="btn utilisation-secondary"
                    OnClick="btnExport_Click"
                    CausesValidation="false" />
            </div>
        </div>

        <div class="utilisation-body">

            <div class="utilisation-summary stock-summary" id="stockSummary" hidden>

                <div>
                    <i class="fa-solid fa-book" aria-hidden="true"></i>
                    <span>TOTAL COPIES</span>
                    <strong id="stockTotal">0</strong>
                    <small>Recorded in the collection</small>
                </div>

                <div class="approved-summary">
                    <i class="fa-solid fa-circle-check" aria-hidden="true"></i>
                    <span>AVAILABLE COPIES</span>
                    <strong id="stockAvailable">0</strong>
                    <small>Recorded as available to borrow</small>
                </div>

                <div>
                    <i class="fa-solid fa-book-open-reader" aria-hidden="true"></i>
                    <span>ON LOAN</span>
                    <strong id="stockLoans">0</strong>
                    <small>Rentals awaiting a return</small>
                </div>

                <div class="stock-overdue-summary">
                    <i class="fa-solid fa-triangle-exclamation" aria-hidden="true"></i>
                    <span>OVERDUE LOANS</span>
                    <strong id="stockOverdue">0</strong>
                    <small>Included in the on-loan total</small>
                </div>

            </div>

            <div class="utilisation-heading">
                <h3>Your collection at a glance</h3>
                <p>Compare stock levels and see which titles need attention.</p>
            </div>

            <div class="utilisation-table-wrap">

                <asp:GridView ID="gvStockStatus" runat="server"
                    AutoGenerateColumns="false"
                    CssClass="grid utilisation-table stock-table"
                    GridLines="None">

                    <Columns>

                        <asp:TemplateField HeaderText="Book">
                            <ItemTemplate>
                                <div class="stock-book"
                                    data-total='<%# Eval("TotalCopies") %>'
                                    data-available='<%# Eval("AvailableCopies") %>'
                                    data-loans='<%# Eval("OnLoan") %>'
                                    data-overdue='<%# Eval("OverdueCount") %>'>

                                    <span class="stock-book-icon" aria-hidden="true">
                                        <i class="fa-solid fa-book"></i>
                                    </span>

                                    <strong><%#: Eval("Title") %></strong>
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:BoundField DataField="Author" HeaderText="Author" />

                        <asp:TemplateField HeaderText="Total copies">
                            <ItemTemplate>
                                <strong class="stock-number">
                                    <%#: Eval("TotalCopies") %>
                                </strong>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="On loan">
                            <ItemTemplate>
                                <span class="utilisation-session-count">
                                    <%#: Eval("OnLoan") %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Available">
                            <ItemTemplate>

                                <div class="stock-availability">
                                    <span class='<%# Convert.ToInt32(Eval("AvailableCopies")) > 0
                                        ? "stock-badge stock-available"
                                        : "stock-badge stock-unavailable" %>'>

                                        <%#: Eval("AvailableCopies") %>
                                        <%#: Convert.ToInt32(Eval("AvailableCopies")) > 0
                                            ? " available"
                                            : " available copies" %>
                                    </span>

                                    <div class="stock-bar" hidden aria-hidden="true">
                                        <span></span>
                                    </div>
                                </div>

                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Overdue">
                            <ItemTemplate>
                                <span class='<%# Convert.ToInt32(Eval("OverdueCount")) > 0
                                    ? "stock-badge stock-warning"
                                    : "stock-badge stock-clear" %>'>

                                    <i class='<%# Convert.ToInt32(Eval("OverdueCount")) > 0
                                        ? "fa-solid fa-triangle-exclamation"
                                        : "fa-solid fa-circle-check" %>'
                                        aria-hidden="true"></i>

                                    <%#: Eval("OverdueCount") %>

                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>

                    </Columns>

                    <EmptyDataTemplate>
                        <div class="utilisation-empty">
                            <i class="fa-solid fa-book-open" aria-hidden="true"></i>
                            <h3>The collection is waiting for its first book</h3>
                            <p>Add books to the catalogue to begin tracking stock.</p>
                        </div>
                    </EmptyDataTemplate>

                </asp:GridView>

            </div>

            <div class="utilisation-report-note">
                <i class="fa-solid fa-circle-info" aria-hidden="true"></i>
                <div>
                    <strong>Reading your stock report</strong>
                    <p>
                        Availability bars show recorded available copies as a share
                        of total copies. On-loan counts come from rentals without
                        a return date. Overdue loans are part of that on-loan total,
                        not additional copies.
                    </p>
                    <p>
                        This page displays the stock figures stored in your system;
                        it does not change or reconcile inventory.
                    </p>
                </div>
            </div>

        </div>
    </div>

    <script>
        (function () {
            var books = document.querySelectorAll('.stock-report .stock-book');
            if (!books.length) return;

            var total = 0;
            var available = 0;
            var loans = 0;
            var overdue = 0;

            books.forEach(function (book) {
                var copies = Number(book.dataset.total) || 0;
                var availableCopies = Number(book.dataset.available) || 0;

                total += copies;
                available += availableCopies;
                loans += Number(book.dataset.loans) || 0;
                overdue += Number(book.dataset.overdue) || 0;

                var bar = book.closest('tr').querySelector('.stock-bar');

                if (bar) {
                    var width = copies > 0
                        ? Math.max(0, Math.min(100, availableCopies / copies * 100))
                        : 0;

                    bar.querySelector('span').style.width = width + '%';
                    bar.hidden = false;
                }
            });

            function format(value) {
                return value.toLocaleString('en-ZA');
            }

            document.getElementById('stockTotal').textContent = format(total);
            document.getElementById('stockAvailable').textContent = format(available);
            document.getElementById('stockLoans').textContent = format(loans);
            document.getElementById('stockOverdue').textContent = format(overdue);
            document.getElementById('stockSummary').hidden = false;
        })();
    </script>

</asp:Content>
