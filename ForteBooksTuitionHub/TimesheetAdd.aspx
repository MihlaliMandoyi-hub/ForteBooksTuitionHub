<%@ Page Title="Log Timesheet" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="TimesheetAdd.aspx.cs" Inherits="ForteBooksTuitionHub.TimesheetAdd" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Log New Timesheet Entry</h2>

    <div class="form-box">
        <label>Tutor</label>
        <asp:DropDownList ID="ddlTutor" runat="server" style="padding:8px; width:100%;"
            DataTextField="FullName" DataValueField="TutorId" AppendDataBoundItems="true">
            <asp:ListItem Text="-- Select Tutor --" Value="0" />
        </asp:DropDownList>

        <label>Work Date</label>
        <asp:TextBox ID="txtWorkDate" runat="server" TextMode="Date"></asp:TextBox>

        <label>Hours Worked</label>
        <asp:TextBox ID="txtHours" runat="server" placeholder="e.g. 2.5"></asp:TextBox>
        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtHours"
            ErrorMessage="Hours worked is required." CssClass="error-text" Display="Dynamic" />
        <asp:RegularExpressionValidator runat="server" ControlToValidate="txtHours"
            ValidationExpression="^\d+(\.\d{1,2})?$"
            ErrorMessage="Enter a valid number of hours (e.g. 2 or 2.5)." CssClass="error-text" Display="Dynamic" />

        <label>Description</label>
        <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" Rows="3"
            placeholder="e.g. Tutored Grade 11 Mathematics session"></asp:TextBox>

        <br /><br />
        <asp:Button ID="btnSave" runat="server" Text="Submit Timesheet" CssClass="btn btn-gold" OnClick="btnSave_Click" />
        <a href="Timesheets.aspx" class="btn">Cancel</a>

        <br /><br />
        <asp:Label ID="lblError" runat="server" CssClass="error-text"></asp:Label>
    </div>

</asp:Content>
