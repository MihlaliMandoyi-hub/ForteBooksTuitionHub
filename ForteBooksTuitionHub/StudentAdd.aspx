<%@ Page Title="Register Student" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="StudentAdd.aspx.cs" Inherits="ForteBooksTuitionHub.StudentAdd" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <h2><asp:Label ID="lblTitle" runat="server" Text="Register New Student"></asp:Label></h2>

    <div class="form-box">
        <asp:HiddenField ID="hfStudentId" runat="server" Value="0" />

        <label>Full Name</label>
        <asp:TextBox ID="txtFullName" runat="server" CssClass="" placeholder="e.g. Thandiwe Mtshali"></asp:TextBox>
        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtFullName"
            ErrorMessage="Full name is required." CssClass="error-text" Display="Dynamic" />

        <label>Email</label>
        <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" placeholder="e.g. student@example.com"></asp:TextBox>
        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtEmail"
            ErrorMessage="Email is required." CssClass="error-text" Display="Dynamic" />
        <asp:RegularExpressionValidator runat="server" ControlToValidate="txtEmail"
            ValidationExpression="^[^@\s]+@[^@\s]+\.[^@\s]+$"
            ErrorMessage="Enter a valid email address." CssClass="error-text" Display="Dynamic" />

        <label>Phone Number</label>
        <asp:TextBox ID="txtPhone" runat="server" placeholder="e.g. 0821234567"></asp:TextBox>
        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtPhone"
            ErrorMessage="Phone number is required." CssClass="error-text" Display="Dynamic" />
        <asp:RegularExpressionValidator runat="server" ControlToValidate="txtPhone"
            ValidationExpression="^0\d{9}$"
            ErrorMessage="Enter a valid 10-digit phone number starting with 0." CssClass="error-text" Display="Dynamic" />

        <label>Date Registered</label>
        <asp:TextBox ID="txtDateRegistered" runat="server" TextMode="Date"></asp:TextBox>

        <br /><br />
        <asp:Button ID="btnSave" runat="server" Text="Save" CssClass="btn btn-gold" OnClick="btnSave_Click" />
        <a href="Students.aspx" class="btn">Cancel</a>

        <br /><br />
        <asp:Label ID="lblError" runat="server" CssClass="error-text"></asp:Label>
    </div>

</asp:Content>