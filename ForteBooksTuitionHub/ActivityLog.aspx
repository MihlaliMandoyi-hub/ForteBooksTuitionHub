<%@ Page Title="Activity Log" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ActivityLog.aspx.cs" Inherits="ForteBooksTuitionHub.ActivityLog" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="activity-workspace">

        <div class="management-page-header">
            <div class="management-header-icon">
                <i class="fa-solid fa-list-check" aria-hidden="true"></i>
            </div>

            <div>
                <span class="management-eyebrow">
                    Forte Books &amp; Tuition Hub
                </span>
                <h2>Activity Log</h2>
                <p>Review recorded actions across the centre.</p>
            </div>
        </div>

        <div class="activity-body">

            <div class="form-box activity-filters">
                <h3>Find activity</h3>
                <p class="activity-description">
                    Narrow the records by date or action type.
                </p>

                <div class="activity-filter-grid">
                    <div>
                        <asp:Label ID="lblFromDateCaption" runat="server"
                            AssociatedControlID="txtFromDate"
                            Text="From Date" />

                        <asp:TextBox ID="txtFromDate" runat="server"
                            TextMode="Date" />
                    </div>

                    <div>
                        <asp:Label ID="lblToDateCaption" runat="server"
                            AssociatedControlID="txtToDate"
                            Text="To Date" />

                        <asp:TextBox ID="txtToDate" runat="server"
                            TextMode="Date" />
                    </div>

                    <div>
                        <asp:Label ID="lblActionTypeCaption" runat="server"
                            AssociatedControlID="ddlActionType"
                            Text="Action Type" />

                        <asp:DropDownList ID="ddlActionType" runat="server">
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
                </div>

                <div class="activity-filter-actions">
                    <asp:Button ID="btnClear" runat="server"
                        Text="Clear" CssClass="btn"
                        OnClick="btnClear_Click"
                        CausesValidation="false" />

                    <asp:Button ID="btnFilter" runat="server"
                        Text="Filter Activity" CssClass="btn btn-gold"
                        OnClick="btnFilter_Click" />
                </div>
            </div>

            <section class="activity-records">
                <div class="activity-records-heading">
                    <h3>Recorded activity</h3>
                    <p>Date, user, action and details in one place.</p>
                </div>

                <div class="activity-table-wrap" tabindex="0"
                    role="region" aria-label="Recorded system activity">

                    <asp:GridView ID="gvLog" runat="server"
                        AutoGenerateColumns="false"
                        CssClass="grid" GridLines="None">

                        <Columns>
                            <asp:BoundField DataField="CreatedDate"
                                HeaderText="Date/Time"
                                DataFormatString="{0:yyyy-MM-dd HH:mm}" />

                            <asp:BoundField DataField="Username"
                                HeaderText="User" />

                            <asp:BoundField DataField="ActionType"
                                HeaderText="Action" />

                            <asp:BoundField DataField="Description"
                                HeaderText="Description" />
                        </Columns>

                        <EmptyDataTemplate>
                            <div class="activity-empty">
                                <i class="fa-solid fa-list-check"
                                    aria-hidden="true"></i>
                                <h3>No matching activity</h3>
                                <p>Try another date range or clear the filters.</p>
                            </div>
                        </EmptyDataTemplate>
                    </asp:GridView>
                </div>
            </section>

        </div>
    </div>

</asp:Content>