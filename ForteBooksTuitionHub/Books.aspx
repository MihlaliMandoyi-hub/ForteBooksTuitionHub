<%@ Page Title="Books" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Books.aspx.cs" Inherits="ForteBooksTuitionHub.Books" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <h2><i class="fa-solid fa-book"></i> Book Catalogue</h2>

    <div style="margin-bottom:15px;">
        <asp:TextBox ID="txtSearch" runat="server" placeholder="Search by title or author" style="padding:8px; width:250px;"></asp:TextBox>
        <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="btn btn-gold" OnClick="btnSearch_Click" />
        <a href="BookAdd.aspx" class="btn"><i class="fa-solid fa-plus"></i> Add New Book</a>
        <a href="BookImport.aspx" class="btn"><i class="fa-solid fa-file-csv"></i> Bulk Import</a>
        <a href="BookRentals.aspx" class="btn">View Rentals</a>
        <a href="OverdueBooks.aspx" class="btn btn-danger">Overdue Books</a>
        <a href="RentalStockStatus.aspx" class="btn btn-gold">Stock Status Report</a>
    </div>

    <asp:Label ID="lblMessage" runat="server" ForeColor="Green" Font-Bold="true"></asp:Label>

    <asp:GridView ID="gvBooks" runat="server" AutoGenerateColumns="false"
        CssClass="grid" DataKeyNames="BookId" OnRowCommand="gvBooks_RowCommand" GridLines="None">
        <Columns>
            <asp:BoundField DataField="Title" HeaderText="Title" />
            <asp:BoundField DataField="Author" HeaderText="Author" />
            <asp:BoundField DataField="TotalCopies" HeaderText="Total Copies" />
            <asp:BoundField DataField="AvailableCopies" HeaderText="Available" />
            <asp:TemplateField HeaderText="">
                <ItemTemplate>
                    <a href='BookAdd.aspx?id=<%# Eval("BookId") %>' class="btn">Edit</a>
                    <asp:Button runat="server" Text="Delete" CommandName="DeleteBook"
                        CommandArgument='<%# Eval("BookId") %>' CssClass="btn btn-danger"
                        OnClientClick="return confirm('Delete this book?');" />
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>

</asp:Content>