<%@ Page Title="Book Catalogue" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="BookCatalogue.aspx.cs" Inherits="ForteBooksTuitionHub.BookCatalogue" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <h2><i class="fa-solid fa-book-open"></i> Book Catalogue</h2>

    <div style="background:#FFF1D6; color:#B8760A; padding:12px 16px; border-radius:8px; margin-bottom:20px; font-size:14px;">
        <i class="fa-solid fa-circle-info"></i> Renting a book is free. If it's not returned by the due date, a fine of
        <strong>R5.00 per day</strong> applies until it's returned. Loan period is 14 days.
    </div>

    <div class="form-box" style="max-width:100%; margin-bottom:20px;">
        <div style="display:flex; gap:15px; flex-wrap:wrap; align-items:flex-end;">
            <div style="flex:1; min-width:220px;">
                <label>Search</label>
                <asp:TextBox ID="txtSearch" runat="server" placeholder="Search by title, author, or ISBN"></asp:TextBox>
            </div>
            <div>
                <label>Sort By</label>
                <asp:DropDownList ID="ddlSort" runat="server" style="padding:10px; border-radius:6px; border:1.5px solid var(--input-border); background:var(--bg-card); color:var(--text-main);">
                    <asp:ListItem Text="Title (A - Z)" Value="TitleAsc" />
                    <asp:ListItem Text="Title (Z - A)" Value="TitleDesc" />
                    <asp:ListItem Text="Year (Newest First)" Value="YearDesc" />
                    <asp:ListItem Text="Year (Oldest First)" Value="YearAsc" />
                    <asp:ListItem Text="Most Available Copies" Value="AvailDesc" />
                </asp:DropDownList>
            </div>
            <div>
                <asp:Button ID="btnFilter" runat="server" Text="Apply" CssClass="btn btn-gold" OnClick="btnFilter_Click" />
                <asp:Button ID="btnClear" runat="server" Text="Clear" CssClass="btn" OnClick="btnClear_Click" CausesValidation="false" />
            </div>
        </div>
    </div>

    <asp:Label ID="lblMessage" runat="server" ForeColor="Green" Font-Bold="true" style="display:block; margin-bottom:10px;"></asp:Label>
    <asp:Label ID="lblError" runat="server" CssClass="error-text" style="display:block; margin-bottom:10px;"></asp:Label>

    <asp:GridView ID="gvBooks" runat="server" AutoGenerateColumns="false"
        CssClass="grid" DataKeyNames="BookId" OnRowCommand="gvBooks_RowCommand"
        OnRowDataBound="gvBooks_RowDataBound" GridLines="None">
        <Columns>
            <asp:BoundField DataField="Title" HeaderText="Title" />
            <asp:BoundField DataField="Author" HeaderText="Author" />
            <asp:BoundField DataField="ISBN" HeaderText="ISBN" />
            <asp:BoundField DataField="YearPublished" HeaderText="Year" />
            <asp:BoundField DataField="Edition" HeaderText="Edition" />
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
        <EmptyDataTemplate>No books match your search.</EmptyDataTemplate>
    </asp:GridView>

</asp:Content>