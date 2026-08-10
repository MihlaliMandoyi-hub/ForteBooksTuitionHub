<%@ Page Title="Issue Book" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="RentalIssue.aspx.cs" Inherits="ForteBooksTuitionHub.RentalIssue" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Issue Book to Student</h2>

    <div class="form-box">
        <label>Book</label>
        <asp:DropDownList ID="ddlBook" runat="server" style="padding:8px; width:100%;"
            DataTextField="DisplayText" DataValueField="BookId" AppendDataBoundItems="true">
            <asp:ListItem Text="-- Select Book --" Value="0" />
        </asp:DropDownList>

        <label>Student</label>
        <asp:DropDownList ID="ddlStudent" runat="server" style="padding:8px; width:100%;"
            DataTextField="FullName" DataValueField="StudentId" AppendDataBoundItems="true">
            <asp:ListItem Text="-- Select Student --" Value="0" />
        </asp:DropDownList>

        <label>Loan Period (days)</label>
        <asp:TextBox ID="txtLoanDays" runat="server" Text="14"></asp:TextBox>
        <asp:RegularExpressionValidator runat="server" ControlToValidate="txtLoanDays"
            ValidationExpression="^[1-9]\d*$"
            ErrorMessage="Enter a whole number of days." CssClass="error-text" Display="Dynamic" />

        <br /><br />
        <asp:Button ID="btnIssue" runat="server" Text="Issue Book" CssClass="btn btn-gold" OnClick="btnIssue_Click" />
        <a href="BookRentals.aspx" class="btn">Cancel</a>

        <br /><br />
        <asp:Label ID="lblError" runat="server" CssClass="error-text"></asp:Label>
    </div>

</asp:Content>
