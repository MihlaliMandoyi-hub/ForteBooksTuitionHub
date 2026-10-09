<%@ Page Title="Sessions" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Sessions.aspx.cs" Inherits="ForteBooksTuitionHub.Sessions" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="sessions-management">

        <div class="management-page-header">
            <div class="management-header-icon">
                <i class="fa-solid fa-calendar-check" aria-hidden="true"></i>
            </div>

            <div>
                <span class="management-eyebrow">
                    Forte Books &amp; Tuition Hub
                </span>
                <h2>Tutoring Sessions</h2>
                <p>Organise bookings, view session details and stay connected.</p>
            </div>
        </div>

        <div class="sessions-booking-bar">
            <div>
                <h3>Session overview</h3>
                <p>Your available session actions appear alongside each booking.</p>
            </div>

            <asp:HyperLink ID="lnkBookSession" runat="server"
                NavigateUrl="~/SessionAdd.aspx" CssClass="btn">
                <i class="fa-solid fa-plus"></i> Book New Session
            </asp:HyperLink>
        </div>

        <asp:Panel ID="pnlFilters" runat="server"
            Visible="false" CssClass="form-box sessions-filters">

            <div class="sessions-filter-fields">
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

                <div class="sessions-filter-actions">
                    <asp:Button ID="btnFilter" runat="server"
                        Text="Filter" CssClass="btn btn-gold"
                        OnClick="btnFilter_Click" />

                    <asp:Button ID="btnClear" runat="server"
                        Text="Clear" CssClass="btn"
                        OnClick="btnClear_Click"
                        CausesValidation="false" />
                </div>
            </div>
        </asp:Panel>

        <asp:Label ID="lblMessage" runat="server"
            Font-Bold="true" CssClass="sessions-message" />

        <div class="sessions-table-wrap" tabindex="0"
            role="region" aria-label="Tutoring sessions table">

            <asp:GridView ID="gvSessions" runat="server"
                AutoGenerateColumns="false"
                CssClass="grid"
                DataKeyNames="SessionId"
                OnRowCommand="gvSessions_RowCommand"
                OnRowDataBound="gvSessions_RowDataBound"
                GridLines="None">

                <Columns>
                    <asp:BoundField DataField="StudentName"
                        HeaderText="Student" />

                    <asp:BoundField DataField="TutorName"
                        HeaderText="Tutor" />

                    <asp:BoundField DataField="SessionDate"
                        HeaderText="Date"
                        DataFormatString="{0:yyyy-MM-dd}" />

                    <asp:BoundField DataField="StartTime"
                        HeaderText="Start" />

                    <asp:BoundField DataField="EndTime"
                        HeaderText="End" />

                    <asp:BoundField DataField="Venue"
                        HeaderText="Venue" />

                    <asp:BoundField DataField="Status"
                        HeaderText="Status" />

                    <asp:TemplateField HeaderText="Rating">
                        <ItemTemplate>
                            <asp:Label ID="lblStars" runat="server"
                                CssClass="stars" />

                            <asp:HyperLink ID="lnkRate" runat="server"
                                CssClass="btn btn-gold" Visible="false">
                                <i class="fa-solid fa-star"></i> Rate
                            </asp:HyperLink>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Actions">
                        <ItemTemplate>
                            <div class="session-row-actions">
                                <asp:HyperLink ID="lnkMessages"
                                    runat="server"
                                    CssClass="btn session-action-message">
                                    <i class="fa-solid fa-comments"></i>
                                    Messages
                                </asp:HyperLink>

                                <asp:Button ID="btnComplete"
                                    runat="server"
                                    Text="Mark Completed"
                                    CommandName="CompleteSession"
                                    CommandArgument='<%# Eval("SessionId") %>'
                                    CssClass="btn btn-gold session-action-complete" />

                                <asp:Button ID="btnCancel"
                                    runat="server"
                                    Text="Cancel"
                                    CommandName="CancelSession"
                                    CommandArgument='<%# Eval("SessionId") %>'
                                    CssClass="btn btn-danger session-action-cancel"
                                    OnClientClick="return confirm('Cancel this session?');" />
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>

                <EmptyDataTemplate>
                    <div class="sessions-empty">
                        <i class="fa-solid fa-calendar-check"
                            aria-hidden="true"></i>
                        <h3>No sessions found</h3>
                        <p>
                            If you applied date filters, try a wider range
                            or clear them to view available sessions.
                        </p>
                    </div>
                </EmptyDataTemplate>
            </asp:GridView>
        </div>
    </div>

</asp:Content>