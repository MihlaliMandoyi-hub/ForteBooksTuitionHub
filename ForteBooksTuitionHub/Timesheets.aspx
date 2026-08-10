<%@ Page Title="Timesheets" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Timesheets.aspx.cs" Inherits="ForteBooksTuitionHub.Timesheets" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <h2><i class="fa-solid fa-clock"></i> Tutor Timesheets</h2>

    <div style="margin-bottom:15px;">
        <a href="TimesheetAdd.aspx" class="btn"><i class="fa-solid fa-plus"></i> Log New Timesheet Entry</a>
    </div>

    <div class="form-box" style="max-width:100%; margin-bottom:20px;">
        <div style="display:flex; gap:15px; flex-wrap:wrap; align-items:flex-end;">
            <div>
                <label>From Date</label>
                <asp:TextBox ID="txtFromDate" runat="server" TextMode="Date"></asp:TextBox>
            </div>
            <div>
                <label>To Date</label>
                <asp:TextBox ID="txtToDate" runat="server" TextMode="Date"></asp:TextBox>
            </div>
            <div>
                <asp:Button ID="btnFilter" runat="server" Text="Filter" CssClass="btn btn-gold" OnClick="btnFilter_Click" />
                <asp:Button ID="btnClear" runat="server" Text="Clear" CssClass="btn" OnClick="btnClear_Click" CausesValidation="false" />
            </div>
        </div>
    </div>

    <asp:Label ID="lblMessage" runat="server" ForeColor="Green" Font-Bold="true" style="display:block; margin-bottom:10px;"></asp:Label>

    <asp:GridView ID="gvTimesheets" runat="server" AutoGenerateColumns="false"
        CssClass="grid" DataKeyNames="TimesheetId" OnRowCommand="gvTimesheets_RowCommand"
        OnRowDataBound="gvTimesheets_RowDataBound" GridLines="None">
        <Columns>
            <asp:BoundField DataField="TutorName" HeaderText="Tutor" />
            <asp:BoundField DataField="WorkDate" HeaderText="Date" DataFormatString="{0:yyyy-MM-dd}" />
            <asp:BoundField DataField="HoursWorked" HeaderText="Hours" />
            <asp:BoundField DataField="Description" HeaderText="Description" />
            <asp:TemplateField HeaderText="Status">
                <ItemTemplate>
                    <asp:Label ID="lblStatus" runat="server"></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="">
                <ItemTemplate>
                    <asp:Button ID="btnApprove" runat="server" Text="Approve" CommandName="ApproveTimesheet"
                        CommandArgument='<%# Eval("TimesheetId") %>' CssClass="btn btn-gold" />
                    <asp:Button ID="btnReject" runat="server" Text="Reject" CommandName="RejectTimesheet"
                        CommandArgument='<%# Eval("TimesheetId") %>' CssClass="btn btn-danger" />
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
        <EmptyDataTemplate>No timesheet entries found.</EmptyDataTemplate>
    </asp:GridView>

</asp:Content>