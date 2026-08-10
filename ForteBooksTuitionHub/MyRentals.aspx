<%@ Page Title="My Book Rentals" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="MyRentals.aspx.cs" Inherits="ForteBooksTuitionHub.MyRentals" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <h2><i class="fa-solid fa-book"></i> My Book Rentals</h2>

    <asp:Label ID="lblMessage" runat="server" ForeColor="Green" Font-Bold="true" style="display:block; margin-bottom:10px;"></asp:Label>

    <asp:GridView ID="gvMyRentals" runat="server" AutoGenerateColumns="false"
        CssClass="grid" OnRowDataBound="gvMyRentals_RowDataBound" GridLines="None">
        <Columns>
            <asp:BoundField DataField="Title" HeaderText="Book" />
            <asp:BoundField DataField="IssueDate" HeaderText="Issued" DataFormatString="{0:yyyy-MM-dd}" />
            <asp:BoundField DataField="DueDate" HeaderText="Due" DataFormatString="{0:yyyy-MM-dd}" />
            <asp:TemplateField HeaderText="Status">
                <ItemTemplate>
                    <asp:Label ID="lblStatus" runat="server"></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Fine Owed">
                <ItemTemplate>
                    <asp:Label ID="lblFine" runat="server"></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="">
                <ItemTemplate>
                    <asp:HyperLink ID="lnkPayFine" runat="server" CssClass="btn btn-gold">
                        <i class="fa-solid fa-credit-card"></i> Pay Fine
                    </asp:HyperLink>
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
        <EmptyDataTemplate>
            You have no book rentals on record.
        </EmptyDataTemplate>
    </asp:GridView>

</asp:Content>