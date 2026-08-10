<%@ Page Title="Overdue Books" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="OverdueBooks.aspx.cs" Inherits="ForteBooksTuitionHub.OverdueBooks" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <h2><i class="fa-solid fa-triangle-exclamation"></i> Overdue Books</h2>
    <div class="no-print" style="margin-bottom:15px;">
        <a href="Books.aspx" class="btn">&laquo; Back to Catalogue</a>
        <asp:Button ID="btnPrint" runat="server" Text="Print This Report" CssClass="btn btn-gold" OnClientClick="window.print(); return false;" />
        <asp:Button ID="btnExport" runat="server" Text="Download as CSV" CssClass="btn btn-gold" OnClick="btnExport_Click" CausesValidation="false" />
    </div>

    <asp:GridView ID="gvOverdue" runat="server" AutoGenerateColumns="false" CssClass="grid" GridLines="None">
        <Columns>
            <asp:BoundField DataField="Title" HeaderText="Book" />
            <asp:BoundField DataField="StudentName" HeaderText="Student" />
            <asp:BoundField DataField="Phone" HeaderText="Student Phone" />
            <asp:BoundField DataField="DueDate" HeaderText="Due Date" DataFormatString="{0:yyyy-MM-dd}" />
            <asp:BoundField DataField="DaysOverdue" HeaderText="Days Overdue" />
        </Columns>
        <EmptyDataTemplate>
            No books are currently overdue.
        </EmptyDataTemplate>
    </asp:GridView>

</asp:Content>