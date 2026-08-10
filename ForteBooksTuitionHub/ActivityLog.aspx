<%@ Page Title="Activity Log" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ActivityLog.aspx.cs" Inherits="ForteBooksTuitionHub.ActivityLog" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <h2><i class="fa-solid fa-list-check"></i> Activity Log</h2>

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
                <label>Action Type</label>
                <asp:DropDownList ID="ddlActionType" runat="server" style="padding:10px; border-radius:6px; border:1.5px solid #E0E6ED;">
                    <asp:ListItem Text="All Actions" Value="" />
                    <asp:ListItem Text="Registration" Value="Registration" />
                    <asp:ListItem Text="Tutor Approval" Value="TutorApproval" />
                    <asp:ListItem Text="Book Issued" Value="BookIssued" />
                    <asp:ListItem Text="Book Returned" Value="BookReturned" />
                    <asp:ListItem Text="Payment" Value="Payment" />
                    <asp:ListItem Text="Fine Payment" Value="FinePayment" />
                    <asp:ListItem Text="Rating" Value="Rating" />
                    <asp:ListItem Text="Payout" Value="Payout" />
                    <asp:ListItem Text="Top Up" Value="TopUp" />
                    <asp:ListItem Text="Book Import" Value="BookImport" />
                    <asp:ListItem Text="Refund" Value="Refund" />
                </asp:DropDownList>
            </div>
            <div>
                <asp:Button ID="btnFilter" runat="server" Text="Filter" CssClass="btn btn-gold" OnClick="btnFilter_Click" />
                <asp:Button ID="btnClear" runat="server" Text="Clear" CssClass="btn" OnClick="btnClear_Click" CausesValidation="false" />
            </div>
        </div>
    </div>

    <asp:GridView ID="gvLog" runat="server" AutoGenerateColumns="false" CssClass="grid" GridLines="None">
        <Columns>
            <asp:BoundField DataField="CreatedDate" HeaderText="Date/Time" DataFormatString="{0:yyyy-MM-dd HH:mm}" />
            <asp:BoundField DataField="Username" HeaderText="User" />
            <asp:BoundField DataField="ActionType" HeaderText="Action" />
            <asp:BoundField DataField="Description" HeaderText="Description" />
        </Columns>
        <EmptyDataTemplate>No activity recorded for this filter.</EmptyDataTemplate>
    </asp:GridView>

</asp:Content>