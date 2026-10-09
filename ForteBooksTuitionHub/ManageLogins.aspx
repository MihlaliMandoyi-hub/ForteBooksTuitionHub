<%@ Page Title="Manage Logins" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ManageLogins.aspx.cs" Inherits="ForteBooksTuitionHub.ManageLogins" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="logins-workspace">

        <div class="management-page-header">
            <div class="management-header-icon">
                <i class="fa-solid fa-user-gear" aria-hidden="true"></i>
            </div>

            <div>
                <span class="management-eyebrow">
                    Forte Books &amp; Tuition Hub
                </span>
                <h2>Manage Logins</h2>
                <p>Create portal access for existing student and tutor records.</p>
            </div>
        </div>

        <div class="logins-body">

            <section class="form-box logins-form">
                <h3>Create an account</h3>
                <p class="logins-description">
                    Choose the account type and person, then set their login details.
                </p>

                <span class="logins-field-caption">Account type</span>

                <div class="role-select">
                    <label class="role-card" id="cardStudentType">
                        <asp:RadioButton ID="rbStudentType" runat="server"
                            GroupName="acctType" AutoPostBack="true"
                            OnCheckedChanged="rbType_CheckedChanged"
                            Checked="true" />

                        <div class="role-card-icon">
                            <i class="fa-solid fa-user-graduate"></i>
                        </div>

                        <div class="role-card-text">
                            <div class="role-card-title">Student</div>
                            <div class="role-card-desc">
                                Create a login for a student record
                            </div>
                        </div>
                    </label>

                    <label class="role-card" id="cardTutorType">
                        <asp:RadioButton ID="rbTutorType" runat="server"
                            GroupName="acctType" AutoPostBack="true"
                            OnCheckedChanged="rbType_CheckedChanged" />

                        <div class="role-card-icon">
                            <i class="fa-solid fa-chalkboard-user"></i>
                        </div>

                        <div class="role-card-text">
                            <div class="role-card-title">Tutor</div>
                            <div class="role-card-desc">
                                Create a login for a tutor record
                            </div>
                        </div>
                    </label>
                </div>

                <div class="logins-person">
                    <asp:Label ID="lblPersonCaption" runat="server"
                        AssociatedControlID="ddlPerson"
                        Text="Select person" />

                    <asp:DropDownList ID="ddlPerson" runat="server"
                        DataTextField="FullName" DataValueField="Id"
                        AppendDataBoundItems="true">
                        <asp:ListItem Text="-- Select --" Value="0" />
                    </asp:DropDownList>

                    <span class="logins-hint">
                        Only people without an existing login appear here.
                    </span>
                </div>

                <div class="logins-field-grid">
                    <div>
                        <asp:Label ID="lblUsernameCaption" runat="server"
                            AssociatedControlID="txtUsername"
                            Text="Username *" />

                        <asp:TextBox ID="txtUsername" runat="server"
                            placeholder="e.g. jsmith" />

                        <asp:RequiredFieldValidator runat="server"
                            ControlToValidate="txtUsername"
                            ErrorMessage="Username is required."
                            CssClass="error-text" Display="Dynamic" />
                    </div>

                    <div>
                        <asp:Label ID="lblPasswordCaption" runat="server"
                            AssociatedControlID="txtPassword"
                            Text="Password *" />

                        <asp:TextBox ID="txtPassword" runat="server"
                            TextMode="Password" />

                        <asp:RequiredFieldValidator runat="server"
                            ControlToValidate="txtPassword"
                            ErrorMessage="Password is required."
                            CssClass="error-text" Display="Dynamic" />
                    </div>
                </div>

                <div class="logins-create-actions">
                    <asp:Button ID="btnCreate" runat="server"
                        Text="Create Login" CssClass="btn btn-gold"
                        OnClick="btnCreate_Click" />
                </div>

                <asp:Label ID="lblError" runat="server"
                    CssClass="error-text logins-error" role="alert" />

                <asp:Label ID="lblSuccess" runat="server"
                    ForeColor="Green" Font-Bold="true"
                    CssClass="logins-success" role="status" />
            </section>

            <section class="logins-existing">
                <div class="logins-section-heading">
                    <h3>Existing Logins</h3>
                    <p>Review usernames, roles and their linked records.</p>
                </div>

                <div class="logins-table-wrap" tabindex="0"
                    role="region" aria-label="Existing login accounts">

                    <asp:GridView ID="gvLogins" runat="server"
                        AutoGenerateColumns="false"
                        CssClass="grid" GridLines="None">
                        <Columns>
                            <asp:BoundField DataField="Username"
                                HeaderText="Username" />
                            <asp:BoundField DataField="Role"
                                HeaderText="Role" />
                            <asp:BoundField DataField="LinkedTo"
                                HeaderText="Linked To" />
                        </Columns>

                        <EmptyDataTemplate>
                            <div class="logins-empty">
                                No login accounts yet.
                            </div>
                        </EmptyDataTemplate>
                    </asp:GridView>
                </div>
            </section>

        </div>
    </div>

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