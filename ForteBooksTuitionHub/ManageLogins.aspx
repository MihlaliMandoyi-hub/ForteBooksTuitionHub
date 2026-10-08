<%@ Page Title="Manage Logins" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ManageLogins.aspx.cs" Inherits="ForteBooksTuitionHub.ManageLogins" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <h2><i class="fa-solid fa-user-gear"></i> Manage Logins</h2>
    <p>Create a login account for a Student or Tutor so they can access their own portal.</p>

    <div class="form-box">
        <label>Account Type</label>
        <div class="role-select">
            <label class="role-card" id="cardStudentType">
                <asp:RadioButton ID="rbStudentType" runat="server" GroupName="acctType" AutoPostBack="true"
                    OnCheckedChanged="rbType_CheckedChanged" Checked="true" />
                <div class="role-card-icon"><i class="fa-solid fa-user-graduate"></i></div>
                <div class="role-card-text">
                    <div class="role-card-title">Student</div>
                    <div class="role-card-desc">Create a login for a student record</div>
                </div>
            </label>

            <label class="role-card" id="cardTutorType">
                <asp:RadioButton ID="rbTutorType" runat="server" GroupName="acctType" AutoPostBack="true"
                    OnCheckedChanged="rbType_CheckedChanged" />
                <div class="role-card-icon"><i class="fa-solid fa-chalkboard-user"></i></div>
                <div class="role-card-text">
                    <div class="role-card-title">Tutor</div>
                    <div class="role-card-desc">Create a login for a tutor record</div>
                </div>
            </label>
        </div>

        <label style="margin-top:18px;">Select Person (only those without an existing login are shown)</label>
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

    <script>
        (function () {
            var studentRadio = document.getElementById('<%= rbStudentType.ClientID %>');
            var tutorRadio = document.getElementById('<%= rbTutorType.ClientID %>');
            var studentCard = document.getElementById('cardStudentType');
            var tutorCard = document.getElementById('cardTutorType');

            function refresh() {
                studentCard.classList.toggle('selected', studentRadio.checked);
                tutorCard.classList.toggle('selected', tutorRadio.checked);
            }

            studentRadio.addEventListener('change', refresh);
            tutorRadio.addEventListener('change', refresh);
            refresh();
        })();
    </script>

</asp:Content>