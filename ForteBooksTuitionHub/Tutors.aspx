<%@ Page Title="Tutors" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Tutors.aspx.cs" Inherits="ForteBooksTuitionHub.Tutors" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="tutors-management">
    <div class="tutors-page-header">
    <div class="tutors-header-icon">
        <i class="fa-solid fa-chalkboard-user" aria-hidden="true"></i>
    </div>

    <div>
        <span class="tutors-eyebrow">Forte Books &amp; Tuition Hub</span>
        <h2>Tutor Management</h2>
        <p>Manage tutor details, subjects, rates and availability.</p>
    </div>
</div>

    <div class="tutors-toolbar">
    <div class="tutors-search">
        <asp:Label ID="lblSearchCaption" runat="server"
            AssociatedControlID="txtSearch"
            Text="Find a tutor" CssClass="tutors-search-label" />

        <div class="tutors-search-controls">
            <asp:TextBox ID="txtSearch" runat="server"
                placeholder="Search by name, email or subject"
                CssClass="tutors-search-input" />

            <asp:Button ID="btnSearch" runat="server"
                Text="Search" CssClass="btn btn-gold"
                OnClick="btnSearch_Click" />
        </div>
    </div>

    <div class="tutors-toolbar-actions">
        <a href="TutorAdd.aspx" class="btn">+ Add New Tutor</a>
        <a href="TutorUtilisation.aspx" class="btn btn-gold">
            Utilisation Report
        </a>
    </div>
</div>

    <asp:Label ID="lblMessage" runat="server" ForeColor="Green" Font-Bold="true"></asp:Label>

    <div class="tutors-table-wrap" tabindex="0"
     role="region" aria-label="Tutors table">

    <asp:GridView ID="gvTutors" runat="server" AutoGenerateColumns="false"
        CssClass="grid" DataKeyNames="TutorId" OnRowCommand="gvTutors_RowCommand" GridLines="None">
        <Columns>
            <asp:BoundField DataField="FullName" HeaderText="Full Name" />
            <asp:BoundField DataField="Email" HeaderText="Email" />
            <asp:BoundField DataField="Phone" HeaderText="Phone" />
            <asp:BoundField DataField="Subject" HeaderText="Subject" />
            <asp:BoundField DataField="HourlyRate" HeaderText="Hourly Rate (R)" DataFormatString="{0:N2}" />
            <asp:TemplateField HeaderText="">
                <ItemTemplate>
    <div class="tutor-row-actions">
        <a href='TutorAvailability.aspx?tutorId=<%# Eval("TutorId") %>'
           class="btn btn-gold tutor-action-availability">
            Availability
        </a>

        <a href='TutorAdd.aspx?id=<%# Eval("TutorId") %>'
           class="btn tutor-action-edit">
            Edit
        </a>

        <a href="TutorUtilisation.aspx"
           class="btn btn-gold tutor-action-report">
            Utilisation Report
        </a>

        <asp:Button runat="server"
            Text="Delete"
            CommandName="DeleteTutor"
            CommandArgument='<%# Eval("TutorId") %>'
            CssClass="btn btn-danger tutor-action-delete"
            OnClientClick="return confirm('Delete this tutor?');" />
    </div>
</ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>

</div>
</div>
</asp:Content>
