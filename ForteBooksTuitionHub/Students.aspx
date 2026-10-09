<%@ Page Title="Students" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Students.aspx.cs" Inherits="ForteBooksTuitionHub.Students" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="students-management">
    <div class="management-page-header">
    <div class="management-header-icon">
        <i class="fa-solid fa-user-graduate" aria-hidden="true"></i>
    </div>

    <div>
        <span class="management-eyebrow">Forte Books &amp; Tuition Hub</span>
        <h2>Student Management</h2>
        <p>Manage student records, contact details and registrations.</p>
    </div>
</div>

    <div class="students-toolbar">
    <div class="students-search">
        <asp:Label ID="lblSearchCaption" runat="server"
            AssociatedControlID="txtSearch"
            Text="Find a student" CssClass="students-search-label" />

        <div class="students-search-controls">
            <asp:TextBox ID="txtSearch" runat="server"
                placeholder="Search by name or email"
                CssClass="students-search-input" />

            <asp:Button ID="btnSearch" runat="server"
                Text="Search" CssClass="btn btn-gold"
                OnClick="btnSearch_Click" />
        </div>
    </div>

    <a href="StudentAdd.aspx" class="btn students-register">
        + Register New Student
    </a>
</div>

    <asp:Label ID="lblMessage" runat="server" ForeColor="Green" Font-Bold="true"></asp:Label>
    <div class="students-table-wrap" tabindex="0"
         role="region" aria-label="Registered students table">

    <asp:GridView ID="gvStudents" runat="server" AutoGenerateColumns="false"
        CssClass="grid" DataKeyNames="StudentId" OnRowCommand="gvStudents_RowCommand" GridLines="None">
        <Columns>
            <asp:BoundField DataField="FullName" HeaderText="Full Name" />
            <asp:BoundField DataField="Email" HeaderText="Email" />
            <asp:BoundField DataField="Phone" HeaderText="Phone" />
            <asp:BoundField DataField="DateRegistered" HeaderText="Date Registered" DataFormatString="{0:yyyy-MM-dd}" />
            <asp:TemplateField HeaderText="">
                <ItemTemplate>
                    <a href='StudentAdd.aspx?id=<%# Eval("StudentId") %>' class="btn">Edit</a>
                    <asp:Button runat="server" Text="Delete" CommandName="DeleteStudent"
                        CommandArgument='<%# Eval("StudentId") %>' CssClass="btn btn-danger"
                        OnClientClick="return confirm('Delete this student?');" />
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>
</div> 

</div>
</asp:Content>