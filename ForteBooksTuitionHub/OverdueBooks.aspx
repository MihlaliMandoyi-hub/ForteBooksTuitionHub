<%@ Page Title="Overdue Books" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="OverdueBooks.aspx.cs" Inherits="ForteBooksTuitionHub.OverdueBooks" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="overdue-workspace">

        <div class="management-page-header">
            <div class="management-header-icon">
                <i class="fa-solid fa-triangle-exclamation"
                    aria-hidden="true"></i>
            </div>

            <div>
                <span class="management-eyebrow">
                    Forte Books &amp; Tuition Hub
                </span>
                <h2>Overdue Books</h2>
                <p>Review outstanding returns and student contact details.</p>
            </div>
        </div>

        <div class="overdue-toolbar no-print">
            <div>
                <h3>Outstanding returns report</h3>
                <p>Records are ordered by due date, with the earliest first.</p>
            </div>

            <div class="overdue-toolbar-actions">
                <a href="Books.aspx" class="btn overdue-back">
                    &laquo; Back to Catalogue
                </a>

                <asp:Button ID="btnPrint" runat="server"
                    Text="Print This Report"
                    CssClass="btn overdue-print"
                    OnClientClick="window.print(); return false;" />

                <asp:Button ID="btnExport" runat="server"
                    Text="Download as CSV"
                    CssClass="btn btn-gold"
                    OnClick="btnExport_Click"
                    CausesValidation="false" />
            </div>
        </div>

        <div class="overdue-table-wrap" tabindex="0"
            role="region" aria-label="Overdue book report">

            <asp:GridView ID="gvOverdue" runat="server"
                AutoGenerateColumns="false"
                CssClass="grid"
                GridLines="None">

                <Columns>
                    <asp:BoundField DataField="Title"
                        HeaderText="Book" />

                    <asp:BoundField DataField="StudentName"
                        HeaderText="Student" />

                    <asp:BoundField DataField="Phone"
                        HeaderText="Student Phone" />

                    <asp:BoundField DataField="DueDate"
                        HeaderText="Due Date"
                        DataFormatString="{0:yyyy-MM-dd}" />

                    <asp:BoundField DataField="DaysOverdue"
                        HeaderText="Days Overdue" />
                </Columns>

                <EmptyDataTemplate>
                    <div class="overdue-empty">
                        <i class="fa-solid fa-book" aria-hidden="true"></i>
                        <h3>No overdue books</h3>
                        <p>No books are currently overdue.</p>
                    </div>
                </EmptyDataTemplate>
            </asp:GridView>
        </div>

        <div class="overdue-followup no-print">
            <strong>Recording a return?</strong>
            <span>
                Open Book Rentals to mark a book as returned
                and update its available copies.
            </span>
            <a href="BookRentals.aspx">Open Book Rentals &raquo;</a>
        </div>

    </div>

</asp:Content>