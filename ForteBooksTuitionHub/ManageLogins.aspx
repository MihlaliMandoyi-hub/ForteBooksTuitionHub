<%@ Page Title="Manage Logins" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ManageLogins.aspx.cs" Inherits="ForteBooksTuitionHub.ManageLogins" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Manage Logins</h2>
    <p>Create a login account for a Student or Tutor so they can access their own portal.</p>

    <div class="form-box">
        <label>Account Type</label>
        <asp:RadioButtonList ID="rblType" runat="server" AutoPostBack="true" OnSelectedIndexChanged="rblType_SelectedIndexChanged" RepeatDirection="Horizontal">
            <asp:ListItem Text="Student" Value="Student" Selected="True" />
            <asp:ListItem Text="Tutor" Value="Tutor" />
        </asp:RadioButtonList>

        <label>Select Person (only those without an existing login are shown)</label>
        <asp:DropDownList ID="ddlPerson" runat="server" style="padding:8px; width:100%;"
            DataTextField="FullName" DataValueField="Id" AppendDataBoundItems="true">
            <asp:ListItem Text="-- Select --" Value="0" />
        </asp:DropDownList>

        <label>Username</label>
        <asp:TextBox ID="txtUsername" runat="server" placeholder="e.g. jsmith"></asp:TextBox>
        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtUsername"
            ErrorMessage="Username is required." CssClass="error-text" Display="Dynamic" />

        <label>Password</label>
        <asp:TextBox ID="txtPassword" runat="server" TextMode="Password"></asp:TextBox>
        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtPassword"
            ErrorMessage="Password is required." CssClass="error-text" Display="Dynamic" />

        <br /><br />
        <asp:Button ID="btnCreate" runat="server" Text="Create Login" CssClass="btn btn-gold" OnClick="btnCreate_Click" />

        <br /><br />
        <asp:Label ID="lblError" runat="server" CssClass="error-text"></asp:Label>
        <asp:Label ID="lblSuccess" runat="server" ForeColor="Green" Font-Bold="true"></asp:Label>
    </div>

    <h3 style="margin-top:30px;">Existing Logins</h3>
    <asp:GridView ID="gvLogins" runat="server" AutoGenerateColumns="false" CssClass="grid" GridLines="None">
        <Columns>
            <asp:BoundField DataField="Username" HeaderText="Username" />
            <asp:BoundField DataField="Role" HeaderText="Role" />
            <asp:BoundField DataField="LinkedTo" HeaderText="Linked To" />
        </Columns>
        <EmptyDataTemplate>No login accounts yet.</EmptyDataTemplate>
    </asp:GridView>

</asp:Content>
