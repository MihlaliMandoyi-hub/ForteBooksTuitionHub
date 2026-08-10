<%@ Page Title="Add Book" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="BookAdd.aspx.cs" Inherits="ForteBooksTuitionHub.BookAdd" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <h2><asp:Label ID="lblTitle" runat="server" Text="Add New Book"></asp:Label></h2>

    <div class="form-box">
        <asp:HiddenField ID="hfBookId" runat="server" Value="0" />

        <label>Title</label>
        <asp:TextBox ID="txtTitle" runat="server" placeholder="e.g. Introduction to Algebra"></asp:TextBox>
        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtTitle"
            ErrorMessage="Title is required." CssClass="error-text" Display="Dynamic" />

        <label>Author</label>
        <asp:TextBox ID="txtAuthor" runat="server" placeholder="e.g. J. Smith"></asp:TextBox>
        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtAuthor"
            ErrorMessage="Author is required." CssClass="error-text" Display="Dynamic" />

        <label>Total Copies</label>
        <asp:TextBox ID="txtTotalCopies" runat="server" placeholder="e.g. 5"></asp:TextBox>
        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtTotalCopies"
            ErrorMessage="Total copies is required." CssClass="error-text" Display="Dynamic" />
        <asp:RegularExpressionValidator runat="server" ControlToValidate="txtTotalCopies"
            ValidationExpression="^[1-9]\d*$"
            ErrorMessage="Enter a whole number greater than 0." CssClass="error-text" Display="Dynamic" />

        <br /><br />
        <asp:Button ID="btnSave" runat="server" Text="Save" CssClass="btn btn-gold" OnClick="btnSave_Click" />
        <a href="Books.aspx" class="btn">Cancel</a>

        <br /><br />
        <asp:Label ID="lblError" runat="server" CssClass="error-text"></asp:Label>
    </div>

</asp:Content>
