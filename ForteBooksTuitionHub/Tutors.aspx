<%@ Page Title="Tutors" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Tutors.aspx.cs" Inherits="ForteBooksTuitionHub.Tutors" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Tutors</h2>

    <div style="margin-bottom:15px;">
        <asp:TextBox ID="txtSearch" runat="server" placeholder="Search by name, email or subject" style="padding:8px; width:250px;"></asp:TextBox>
        <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="btn btn-gold" OnClick="btnSearch_Click" />
        <a href="TutorAdd.aspx" class="btn">+ Add New Tutor</a>
        <a href="TutorUtilisation.aspx" class="btn btn-gold">Utilisation Report</a>
    </div>

    <asp:Label ID="lblMessage" runat="server" ForeColor="Green" Font-Bold="true"></asp:Label>

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
                    <a href='TutorAvailability.aspx?tutorId=<%# Eval("TutorId") %>' class="btn btn-gold">Availability</a>
                    <a href='TutorAdd.aspx?id=<%# Eval("TutorId") %>' class="btn">Edit</a>
                    <a href="TutorUtilisation.aspx" class="btn btn-gold">Utilisation Report</a>
                    <asp:Button runat="server" Text="Delete" CommandName="DeleteTutor"
                        CommandArgument='<%# Eval("TutorId") %>' CssClass="btn btn-danger"
                        OnClientClick="return confirm('Delete this tutor?');" />
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>

</asp:Content>
