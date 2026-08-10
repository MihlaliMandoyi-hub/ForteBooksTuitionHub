<%@ Page Title="Notifications" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Notifications.aspx.cs" Inherits="ForteBooksTuitionHub.Notifications" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <h2><i class="fa-solid fa-bell"></i> Notifications</h2>

    <div style="margin-bottom:15px;">
        <asp:Button ID="btnMarkAllRead" runat="server" Text="Mark All As Read" CssClass="btn btn-gold" OnClick="btnMarkAllRead_Click" />
    </div>

    <asp:GridView ID="gvNotifications" runat="server" AutoGenerateColumns="false"
        CssClass="grid" DataKeyNames="NotificationId" OnRowCommand="gvNotifications_RowCommand"
        OnRowDataBound="gvNotifications_RowDataBound" GridLines="None">
        <Columns>
            <asp:TemplateField HeaderText="Status">
                <ItemTemplate>
                    <asp:Label ID="lblStatus" runat="server"></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="Message" HeaderText="Message" />
            <asp:BoundField DataField="CreatedDate" HeaderText="Date" DataFormatString="{0:yyyy-MM-dd HH:mm}" />
            <asp:TemplateField HeaderText="">
                <ItemTemplate>
                    <asp:Button ID="btnView" runat="server" Text="View" CommandName="ViewNotification"
                        CommandArgument='<%# Eval("NotificationId") %>' CssClass="btn" />
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
        <EmptyDataTemplate>
            <i class="fa-solid fa-circle-check"></i> You have no notifications.
        </EmptyDataTemplate>
    </asp:GridView>

</asp:Content>