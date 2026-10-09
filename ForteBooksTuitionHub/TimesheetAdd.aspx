<%@ Page Title="Log Timesheet" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="TimesheetAdd.aspx.cs" Inherits="ForteBooksTuitionHub.TimesheetAdd" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="timesheet-editor">

        <div class="management-page-header">
            <div class="management-header-icon">
                <i class="fa-solid fa-clock" aria-hidden="true"></i>
            </div>

            <div>
                <span class="management-eyebrow">
                    Forte Books &amp; Tuition Hub
                </span>
                <h2>Log New Timesheet Entry</h2>
                <p>Record completed work and submit it for review.</p>
            </div>
        </div>

        <div class="timesheet-editor-body">

            <div class="timesheet-editor-intro">
                <div>
                    <h3>Work details</h3>
                    <p>Fields marked * are required.</p>
                </div>

                <a href="Timesheets.aspx" class="timesheet-editor-back">
                    Back to timesheets
                </a>
            </div>

            <div class="timesheet-editor-grid">

                <div class="timesheet-editor-field">
                    <asp:Label ID="lblTutorCaption" runat="server"
                        AssociatedControlID="ddlTutor" Text="Tutor *" />

                    <asp:DropDownList ID="ddlTutor" runat="server"
                        DataTextField="FullName"
                        DataValueField="TutorId"
                        AppendDataBoundItems="true">
                        <asp:ListItem Text="-- Select Tutor --" Value="0" />
                    </asp:DropDownList>
                </div>

                <div class="timesheet-editor-field">
                    <asp:Label ID="lblWorkDateCaption" runat="server"
                        AssociatedControlID="txtWorkDate"
                        Text="Work date *" />

                    <asp:TextBox ID="txtWorkDate" runat="server"
                        TextMode="Date" />

                    <span class="timesheet-editor-hint">
                        Choose today or an earlier date.
                    </span>
                </div>

                <div class="timesheet-editor-field">
                    <asp:Label ID="lblHoursCaption" runat="server"
                        AssociatedControlID="txtHours"
                        Text="Hours worked *" />

                    <asp:TextBox ID="txtHours" runat="server"
                        placeholder="e.g. 2.5" />

                    <asp:RequiredFieldValidator runat="server"
                        ControlToValidate="txtHours"
                        ErrorMessage="Hours worked is required."
                        CssClass="error-text" Display="Dynamic" />

                    <asp:RegularExpressionValidator runat="server"
                        ControlToValidate="txtHours"
                        ValidationExpression="^\d+(\.\d{1,2})?$"
                        ErrorMessage="Enter a valid number of hours (e.g. 2 or 2.5)."
                        CssClass="error-text" Display="Dynamic" />

                    <span class="timesheet-editor-hint">
                        Enter between 0.5 and 12 hours.
                        Use a full stop for decimals.
                    </span>
                </div>

                <div class="timesheet-editor-note">
                    <strong>Submitted for review</strong>
                    <p>
                        New entries start as Pending.
                        You can check their approval status
                        on the Timesheets page.
                    </p>
                </div>

                <div class="timesheet-editor-field timesheet-description">
                    <asp:Label ID="lblDescriptionCaption" runat="server"
                        AssociatedControlID="txtDescription"
                        Text="Description (optional)" />

                    <asp:TextBox ID="txtDescription" runat="server"
                        TextMode="MultiLine" Rows="4"
                        placeholder="e.g. Tutored Grade 11 Mathematics session" />
                </div>

            </div>

            <asp:Label ID="lblError" runat="server"
                CssClass="error-text timesheet-editor-error"
                role="alert" />

        </div>

        <div class="timesheet-editor-actions">
            <span>Check your work date and hours before submitting.</span>

            <div>
                <a href="Timesheets.aspx" class="btn timesheet-editor-cancel">
                    Cancel
                </a>

                <asp:Button ID="btnSave" runat="server"
                    Text="Submit Timesheet"
                    CssClass="btn btn-gold"
                    OnClick="btnSave_Click" />
            </div>
        </div>

    </div>

</asp:Content>