<%@ Page Title="Timesheets" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Timesheets.aspx.cs" Inherits="ForteBooksTuitionHub.Timesheets" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="timesheets-workspace">

        <div class="management-page-header">
            <div class="management-header-icon">
                <i class="fa-solid fa-clock" aria-hidden="true"></i>
            </div>

            <div>
                <span class="management-eyebrow">
                    Forte Books &amp; Tuition Hub
                </span>
                <h2>Tutor Timesheets</h2>
                <p>Review logged work, hours and approval status.</p>
            </div>
        </div>

        <div class="timesheets-toolbar">
            <div>
                <h3>Work records</h3>
                <p>Filter by date to review entries for a specific period.</p>
            </div>

            <a href="TimesheetAdd.aspx" class="btn btn-gold">
                <i class="fa-solid fa-plus"></i>
                Log New Timesheet Entry
            </a>
        </div>

        <div class="form-box timesheets-filters">
            <div class="timesheets-filter-fields">
                <div>
                    <asp:Label ID="lblFromDateCaption" runat="server"
                        AssociatedControlID="txtFromDate" Text="From Date" />
                    <asp:TextBox ID="txtFromDate" runat="server"
                        TextMode="Date" />
                </div>

                <div>
                    <asp:Label ID="lblToDateCaption" runat="server"
                        AssociatedControlID="txtToDate" Text="To Date" />
                    <asp:TextBox ID="txtToDate" runat="server"
                        TextMode="Date" />
                </div>

                <div class="timesheets-filter-actions">
                    <asp:Button ID="btnFilter" runat="server"
                        Text="Filter" CssClass="btn btn-gold"
                        OnClick="btnFilter_Click" />

                    <asp:Button ID="btnClear" runat="server"
                        Text="Clear" CssClass="btn"
                        OnClick="btnClear_Click"
                        CausesValidation="false" />
                </div>
            </div>
        </div>

        <asp:Label ID="lblMessage" runat="server"
            ForeColor="Green" Font-Bold="true"
            CssClass="timesheets-message" />

        <div class="timesheets-table-wrap" tabindex="0"
            role="region" aria-label="Tutor timesheet records">

            <asp:GridView ID="gvTimesheets" runat="server"
                AutoGenerateColumns="false"
                CssClass="grid"
                DataKeyNames="TimesheetId"
                OnRowCommand="gvTimesheets_RowCommand"
                OnRowDataBound="gvTimesheets_RowDataBound"
                GridLines="None">

                <Columns>
                    <asp:BoundField DataField="TutorName"
                        HeaderText="Tutor" />

                    <asp:BoundField DataField="WorkDate"
                        HeaderText="Date"
                        DataFormatString="{0:yyyy-MM-dd}" />

                    <asp:BoundField DataField="HoursWorked"
                        HeaderText="Hours"
                        HeaderStyle-CssClass="timesheet-hours"
                        ItemStyle-CssClass="timesheet-hours" />

                    <asp:BoundField DataField="Description"
                        HeaderText="Description" />

                    <asp:TemplateField HeaderText="Status">
                        <ItemTemplate>
                            <span class="timesheet-status">
                                <asp:Label ID="lblStatus" runat="server" />
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Actions"
                        HeaderStyle-CssClass="no-print"
                        ItemStyle-CssClass="no-print">
                        <ItemTemplate>
                            <div class="timesheet-row-actions">
                                <asp:Button ID="btnApprove" runat="server"
                                    Text="Approve"
                                    CommandName="ApproveTimesheet"
                                    CommandArgument='<%# Eval("TimesheetId") %>'
                                    CssClass="btn btn-gold timesheet-approve" />

                                <asp:Button ID="btnReject" runat="server"
                                    Text="Reject"
                                    CommandName="RejectTimesheet"
                                    CommandArgument='<%# Eval("TimesheetId") %>'
                                    CssClass="btn btn-danger timesheet-reject" />
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>

                <EmptyDataTemplate>
                    <div class="timesheets-empty">
                        <i class="fa-solid fa-clock" aria-hidden="true"></i>
                        <h3>No timesheet entries found</h3>
                        <p>Try another date range or clear the filters.</p>
                    </div>
                </EmptyDataTemplate>
            </asp:GridView>
        </div>
    </div>

</asp:Content>