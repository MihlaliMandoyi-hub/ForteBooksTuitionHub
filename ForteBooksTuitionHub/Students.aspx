<%@ Page Title="Students" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Students.aspx.cs" Inherits="ForteBooksTuitionHub.Students" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Registered Students</h2>

    <div style="margin-bottom:15px;">
        <asp:TextBox ID="txtSearch" runat="server" placeholder="Search by name or email" style="padding:8px; width:250px;"></asp:TextBox>
        <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="btn btn-gold" OnClick="btnSearch_Click" />
        <a href="StudentAdd.aspx" class="btn">+ Register New Student</a>
    </div>

    <asp:Label ID="lblMessage" runat="server" ForeColor="Green" Font-Bold="true"></asp:Label>

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

</asp:Content>