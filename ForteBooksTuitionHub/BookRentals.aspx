<%@ Page Title="Book Rentals" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="BookRentals.aspx.cs" Inherits="ForteBooksTuitionHub.BookRentals" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="rentals-management">

        <div class="management-page-header">
            <div class="management-header-icon">
                <i class="fa-solid fa-book" aria-hidden="true"></i>
            </div>

            <div>
                <span class="management-eyebrow">
                    Forte Books &amp; Tuition Hub
                </span>
                <h2>Book Rentals</h2>
                <p>Track borrowed books, due dates and completed returns.</p>
            </div>
        </div>

        <div class="rentals-toolbar">
            <div>
                <h3>Rental records</h3>
                <p>Outstanding rentals appear first, ordered by due date.</p>
            </div>

            <div class="rentals-toolbar-actions">
                <a href="Books.aspx" class="btn rentals-back">
                    &laquo; Back to Catalogue
                </a>

                <a href="RentalIssue.aspx" class="btn btn-gold">
                    + Issue Book
                </a>
            </div>
        </div>

        <asp:Label ID="lblMessage" runat="server"
            ForeColor="Green" Font-Bold="true"
            CssClass="rentals-message" />

        <div class="rentals-table-wrap" tabindex="0"
            role="region" aria-label="Book rental records">

            <asp:GridView ID="gvRentals" runat="server"
                AutoGenerateColumns="false"
                CssClass="grid"
                DataKeyNames="RentalId"
                OnRowCommand="gvRentals_RowCommand"
                OnRowDataBound="gvRentals_RowDataBound"
                GridLines="None">

                <Columns>
                    <asp:BoundField DataField="Title"
                        HeaderText="Book" />

                    <asp:BoundField DataField="StudentName"
                        HeaderText="Student" />

                    <asp:BoundField DataField="IssueDate"
                        HeaderText="Issued"
                        DataFormatString="{0:yyyy-MM-dd}" />

                    <asp:BoundField DataField="DueDate"
                        HeaderText="Due"
                        DataFormatString="{0:yyyy-MM-dd}" />

                    <asp:TemplateField HeaderText="Status">
                        <ItemTemplate>
                            <span class="rental-status">
                                <asp:Label ID="lblStatus" runat="server" />
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Actions">
                        <ItemTemplate>
                            <asp:Button runat="server"
                                Text="Mark Returned"
                                CommandName="ReturnBook"
                                CommandArgument='<%# Eval("RentalId") %>'
                                CssClass="btn btn-gold rental-return"
                                Visible='<%# Eval("ReturnDate") == DBNull.Value %>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>

                <EmptyDataTemplate>
                    <div class="rentals-empty">
                        <i class="fa-solid fa-book" aria-hidden="true"></i>
                        <h3>No rental records yet</h3>
                        <p>Use Issue Book to record a student's book rental.</p>
                    </div>
                </EmptyDataTemplate>
            </asp:GridView>
        </div>
    </div>

</asp:Content>