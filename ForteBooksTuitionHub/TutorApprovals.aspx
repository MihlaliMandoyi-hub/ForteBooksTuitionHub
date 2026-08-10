<%@ Page Title="Tutor Approvals" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="TutorApprovals.aspx.cs" Inherits="ForteBooksTuitionHub.TutorApprovals" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <h2><i class="fa-solid fa-user-check"></i> Tutor Approvals</h2>
    <p>Review tutors who have registered themselves and are awaiting approval before they can log in.</p>

    <asp:Label ID="lblMessage" runat="server" ForeColor="Green" Font-Bold="true" style="display:block; margin-bottom:10px;"></asp:Label>

    <h3><i class="fa-solid fa-hourglass-half"></i> Pending Applications</h3>
    <asp:GridView ID="gvPending" runat="server" AutoGenerateColumns="false"
        CssClass="grid" DataKeyNames="UserId" OnRowCommand="gvPending_RowCommand" GridLines="None">
        <Columns>
            <asp:BoundField DataField="FullName" HeaderText="Full Name" />
            <asp:BoundField DataField="Email" HeaderText="Email" />
            <asp:BoundField DataField="Phone" HeaderText="Phone" />
            <asp:BoundField DataField="Subject" HeaderText="Subject" />
            <asp:BoundField DataField="HourlyRate" HeaderText="Hourly Rate (R)" DataFormatString="{0:N2}" />
            <asp:BoundField DataField="Username" HeaderText="Username" />
            <asp:TemplateField HeaderText="">
                <ItemTemplate>
                    <asp:Button runat="server" Text="Approve" CommandName="ApproveTutor"
                        CommandArgument='<%# Eval("UserId") %>' CssClass="btn btn-gold"
                        OnClientClick="return confirm('Approve this tutor? They will be able to log in immediately.');" />
                    <asp:Button runat="server" Text="Reject" CommandName="RejectTutor"
                        CommandArgument='<%# Eval("UserId") %>' CssClass="btn btn-danger"
                        OnClientClick="return confirm('Reject this tutor application?');" />
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
        <EmptyDataTemplate>
            <i class="fa-solid fa-circle-check"></i> No pending tutor applications right now.
        </EmptyDataTemplate>
    </asp:GridView>

    <h3 style="margin-top:35px;"><i class="fa-solid fa-clock-rotate-left"></i> Previously Reviewed</h3>
    <asp:GridView ID="gvReviewed" runat="server" AutoGenerateColumns="false"
        CssClass="grid" DataKeyNames="UserId" OnRowCommand="gvReviewed_RowCommand" OnRowDataBound="gvReviewed_RowDataBound" GridLines="None">
        <Columns>
            <asp:BoundField DataField="FullName" HeaderText="Full Name" />
            <asp:BoundField DataField="Email" HeaderText="Email" />
            <asp:BoundField DataField="Subject" HeaderText="Subject" />
            <asp:BoundField DataField="Username" HeaderText="Username" />
            <asp:TemplateField HeaderText="Status">
                <ItemTemplate>
                    <asp:Label ID="lblStatus" runat="server"></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="">
                <ItemTemplate>
                    <asp:Button runat="server" Text="Re-approve" CommandName="ApproveTutor"
                        CommandArgument='<%# Eval("UserId") %>' CssClass="btn btn-gold"
                        Visible='<%# Eval("Status").ToString() == "Rejected" %>'
                        OnClientClick="return confirm('Approve this tutor?');" />
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
        <EmptyDataTemplate>
            No applications have been reviewed yet.
        </EmptyDataTemplate>
    </asp:GridView>

</asp:Content>