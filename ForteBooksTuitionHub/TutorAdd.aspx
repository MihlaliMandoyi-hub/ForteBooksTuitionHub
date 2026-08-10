<%@ Page Title="Add Tutor" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="TutorAdd.aspx.cs" Inherits="ForteBooksTuitionHub.TutorAdd" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <h2><asp:Label ID="lblTitle" runat="server" Text="Add New Tutor"></asp:Label></h2>

    <div class="form-box">
        <asp:HiddenField ID="hfTutorId" runat="server" Value="0" />

        <label>Full Name</label>
        <asp:TextBox ID="txtFullName" runat="server" placeholder="e.g. Sipho Ndlovu"></asp:TextBox>
        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtFullName"
            ErrorMessage="Full name is required." CssClass="error-text" Display="Dynamic" />

        <label>Email</label>
        <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" placeholder="e.g. tutor@example.com"></asp:TextBox>
        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtEmail"
            ErrorMessage="Email is required." CssClass="error-text" Display="Dynamic" />
        <asp:RegularExpressionValidator runat="server" ControlToValidate="txtEmail"
            ValidationExpression="^[^@\s]+@[^@\s]+\.[^@\s]+$"
            ErrorMessage="Enter a valid email address." CssClass="error-text" Display="Dynamic" />

        <label>Phone Number</label>
        <asp:TextBox ID="txtPhone" runat="server" placeholder="e.g. 0731234567"></asp:TextBox>
        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtPhone"
            ErrorMessage="Phone number is required." CssClass="error-text" Display="Dynamic" />
        <asp:RegularExpressionValidator runat="server" ControlToValidate="txtPhone"
            ValidationExpression="^0\d{9}$"
            ErrorMessage="Enter a valid 10-digit phone number starting with 0." CssClass="error-text" Display="Dynamic" />

        <label>Subject / Specialty</label>
        <asp:TextBox ID="txtSubject" runat="server" placeholder="e.g. Mathematics"></asp:TextBox>
        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtSubject"
            ErrorMessage="Subject is required." CssClass="error-text" Display="Dynamic" />

        <label>Hourly Rate (R)</label>
        <asp:TextBox ID="txtHourlyRate" runat="server" placeholder="e.g. 150.00"></asp:TextBox>
        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtHourlyRate"
            ErrorMessage="Hourly rate is required." CssClass="error-text" Display="Dynamic" />
        <asp:RegularExpressionValidator runat="server" ControlToValidate="txtHourlyRate"
            ValidationExpression="^\d+(\.\d{1,2})?$"
            ErrorMessage="Enter a valid amount (e.g. 150 or 150.00)." CssClass="error-text" Display="Dynamic" />

        <br /><br />
        <asp:Button ID="btnSave" runat="server" Text="Save" CssClass="btn btn-gold" OnClick="btnSave_Click" />
        <a href="Tutors.aspx" class="btn">Cancel</a>

        <br /><br />
        <asp:Label ID="lblError" runat="server" CssClass="error-text"></asp:Label>
    </div>

</asp:Content>