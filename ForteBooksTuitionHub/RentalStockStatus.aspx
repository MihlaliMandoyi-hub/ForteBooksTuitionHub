<%@ Page Title="Rental Stock Status" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="RentalStockStatus.aspx.cs" Inherits="ForteBooksTuitionHub.RentalStockStatus" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <h2><i class="fa-solid fa-boxes-stacked"></i> Rental Stock Status Report</h2>
    <div class="no-print" style="margin-bottom:15px;">
        <a href="Books.aspx" class="btn">&laquo; Back to Catalogue</a>
        <asp:Button ID="btnPrint" runat="server" Text="Print This Report" CssClass="btn btn-gold" OnClientClick="window.print(); return false;" />
        <asp:Button ID="btnExport" runat="server" Text="Download as CSV" CssClass="btn btn-gold" OnClick="btnExport_Click" CausesValidation="false" />
    </div>

    <asp:GridView ID="gvStockStatus" runat="server" AutoGenerateColumns="false" CssClass="grid" GridLines="None">
        <Columns>
            <asp:BoundField DataField="Title" HeaderText="Book" />
            <asp:BoundField DataField="Author" HeaderText="Author" />
            <asp:BoundField DataField="TotalCopies" HeaderText="Total Copies" />
            <asp:BoundField DataField="OnLoan" HeaderText="On Loan" />
            <asp:BoundField DataField="AvailableCopies" HeaderText="Available" />
            <asp:BoundField DataField="OverdueCount" HeaderText="Overdue" />
        </Columns>
        <EmptyDataTemplate>
            No books in catalogue.
        </EmptyDataTemplate>
    </asp:GridView>

</asp:Content>
