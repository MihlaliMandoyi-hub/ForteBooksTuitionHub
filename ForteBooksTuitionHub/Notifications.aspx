<%@ Page Title="Notifications" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Notifications.aspx.cs" Inherits="ForteBooksTuitionHub.Notifications" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="notifications-workspace">

        <div class="management-page-header">
            <div class="management-header-icon">
                <i class="fa-solid fa-bell" aria-hidden="true"></i>
            </div>

            <div>
                <span class="management-eyebrow">
                    Forte Books &amp; Tuition Hub
                </span>
                <h2>Notifications</h2>
                <p>Your updates, reminders and account activity in one place.</p>
            </div>
        </div>

        <div class="notifications-toolbar">
            <div>
                <h3>Your inbox</h3>
                <p>Open a notification to view its related page and mark it as read.</p>
            </div>

            <asp:Button ID="btnMarkAllRead" runat="server"
                Text="Mark All As Read"
                CssClass="btn btn-gold"
                OnClick="btnMarkAllRead_Click" />
        </div>

        <div class="notifications-table-wrap" tabindex="0"
            role="region" aria-label="Your notifications">

            <asp:GridView ID="gvNotifications" runat="server"
                AutoGenerateColumns="false"
                CssClass="grid"
                DataKeyNames="NotificationId"
                OnRowCommand="gvNotifications_RowCommand"
                OnRowDataBound="gvNotifications_RowDataBound"
                GridLines="None">

                <Columns>
                    <asp:TemplateField HeaderText="Status">
                        <ItemTemplate>
                            <span class='<%# Convert.ToBoolean(Eval("IsRead")) ? "notification-status notification-read" : "notification-status notification-new" %>'>
                                <asp:Label ID="lblStatus" runat="server" />
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:BoundField DataField="Message"
                        HeaderText="Message" />

                    <asp:BoundField DataField="CreatedDate"
                        HeaderText="Date"
                        DataFormatString="{0:yyyy-MM-dd HH:mm}" />

                    <asp:TemplateField HeaderText="Actions"
                        HeaderStyle-CssClass="no-print"
                        ItemStyle-CssClass="no-print">
                        <ItemTemplate>
                            <asp:Button ID="btnView" runat="server"
                                Text="View"
                                CommandName="ViewNotification"
                                CommandArgument='<%# Eval("NotificationId") %>'
                                CssClass="btn notification-view" />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>

                <EmptyDataTemplate>
                    <div class="notifications-empty">
                        <i class="fa-solid fa-circle-check"
                            aria-hidden="true"></i>
                        <h3>You're all caught up</h3>
                        <p>You have no notifications.</p>
                    </div>
                </EmptyDataTemplate>
            </asp:GridView>
        </div>

    </div>

</asp:Content>