<%@ Page Title="Book Rentals" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="BookRentals.aspx.cs" Inherits="ForteBooksTuitionHub.BookRentals" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Book Rentals</h2>

    <div style="margin-bottom:15px;">
        <a href="RentalIssue.aspx" class="btn">+ Issue Book</a>
        <a href="Books.aspx" class="btn">&laquo; Back to Catalogue</a>
    </div>

    <asp:Label ID="lblMessage" runat="server" ForeColor="Green" Font-Bold="true"></asp:Label>

    <asp:GridView ID="gvRentals" runat="server" AutoGenerateColumns="false"
        CssClass="grid" DataKeyNames="RentalId" OnRowCommand="gvRentals_RowCommand"
        OnRowDataBound="gvRentals_RowDataBound" GridLines="None">
        <Columns>
            <asp:BoundField DataField="Title" HeaderText="Book" />
            <asp:BoundField DataField="StudentName" HeaderText="Student" />
            <asp:BoundField DataField="IssueDate" HeaderText="Issued" DataFormatString="{0:yyyy-MM-dd}" />
            <asp:BoundField DataField="DueDate" HeaderText="Due" DataFormatString="{0:yyyy-MM-dd}" />
            <asp:TemplateField HeaderText="Status">
                <ItemTemplate>
                    <asp:Label ID="lblStatus" runat="server"></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="">
                <ItemTemplate>
                    <asp:Button runat="server" Text="Mark Returned" CommandName="ReturnBook"
                        CommandArgument='<%# Eval("RentalId") %>' CssClass="btn btn-gold"
                        Visible='<%# Eval("ReturnDate") == DBNull.Value %>' />
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>

</asp:Content>