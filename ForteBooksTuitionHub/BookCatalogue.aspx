<%@ Page Title="Book Catalogue" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="BookCatalogue.aspx.cs" Inherits="ForteBooksTuitionHub.BookCatalogue" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <h2><i class="fa-solid fa-book-open"></i> Book Catalogue</h2>

    <div style="background:#FFF1D6; color:#B8760A; padding:12px 16px; border-radius:8px; margin-bottom:20px; font-size:14px;">
        <i class="fa-solid fa-circle-info"></i> Renting a book is free. If it's not returned by the due date, a fine of
        <strong>R5.00 per day</strong> applies until it's returned. Loan period is 14 days.
    </div>

    <asp:Label ID="lblMessage" runat="server" ForeColor="Green" Font-Bold="true" style="display:block; margin-bottom:10px;"></asp:Label>
    <asp:Label ID="lblError" runat="server" CssClass="error-text" style="display:block; margin-bottom:10px;"></asp:Label>

    <asp:GridView ID="gvBooks" runat="server" AutoGenerateColumns="false"
        CssClass="grid" DataKeyNames="BookId" OnRowCommand="gvBooks_RowCommand"
        OnRowDataBound="gvBooks_RowDataBound" GridLines="None">
        <Columns>
            <asp:BoundField DataField="Title" HeaderText="Title" />
            <asp:BoundField DataField="Author" HeaderText="Author" />
            <asp:BoundField DataField="AvailableCopies" HeaderText="Available Copies" />
            <asp:BoundField DataField="TotalCopies" HeaderText="Total Copies" />
            <asp:TemplateField HeaderText="">
                <ItemTemplate>
                    <asp:Button ID="btnRent" runat="server" Text="Rent This Book" CommandName="RentBook"
                        CommandArgument='<%# Eval("BookId") %>' CssClass="btn btn-gold"
                        OnClientClick="return confirm('Rent this book for 14 days?');" />
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
        <EmptyDataTemplate>No books currently in the catalogue.</EmptyDataTemplate>
    </asp:GridView>

</asp:Content>