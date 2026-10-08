<%@ Page Title="Sessions" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Sessions.aspx.cs" Inherits="ForteBooksTuitionHub.Sessions" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <h2><i class="fa-solid fa-calendar-check"></i> Tutoring Sessions</h2>

    <div style="margin-bottom:15px;">
        <asp:HyperLink ID="lnkBookSession" runat="server" NavigateUrl="~/SessionAdd.aspx" CssClass="btn">
            <i class="fa-solid fa-plus"></i> Book New Session
        </asp:HyperLink>
    </div>

    <asp:Panel ID="pnlFilters" runat="server" Visible="false" CssClass="form-box" Style="max-width:100%; margin-bottom:20px;">
        <div style="display:flex; gap:15px; flex-wrap:wrap; align-items:flex-end;">
            <div>
                <label>From Date</label>
                <asp:TextBox ID="txtFromDate" runat="server" TextMode="Date"></asp:TextBox>
            </div>
            <div>
                <label>To Date</label>
                <asp:TextBox ID="txtToDate" runat="server" TextMode="Date"></asp:TextBox>
            </div>
            <div>
                <asp:Button ID="btnFilter" runat="server" Text="Filter" CssClass="btn btn-gold" OnClick="btnFilter_Click" />
                <asp:Button ID="btnClear" runat="server" Text="Clear" CssClass="btn" OnClick="btnClear_Click" CausesValidation="false" />
            </div>
        </div>
    </asp:Panel>

    <asp:Label ID="lblMessage" runat="server" Font-Bold="true" style="display:block; margin-bottom:10px;"></asp:Label>

    <asp:GridView ID="gvSessions" runat="server" AutoGenerateColumns="false"
        CssClass="grid" DataKeyNames="SessionId" OnRowCommand="gvSessions_RowCommand"
        OnRowDataBound="gvSessions_RowDataBound" GridLines="None">
        <Columns>
            <asp:BoundField DataField="StudentName" HeaderText="Student" />
            <asp:BoundField DataField="TutorName" HeaderText="Tutor" />
            <asp:BoundField DataField="SessionDate" HeaderText="Date" DataFormatString="{0:yyyy-MM-dd}" />
            <asp:BoundField DataField="StartTime" HeaderText="Start" />
            <asp:BoundField DataField="EndTime" HeaderText="End" />
            <asp:BoundField DataField="Venue" HeaderText="Venue" />
            <asp:BoundField DataField="Status" HeaderText="Status" />
            <asp:TemplateField HeaderText="Rating">
                <ItemTemplate>
                    <asp:Label ID="lblStars" runat="server" CssClass="stars"></asp:Label>
                    <asp:HyperLink ID="lnkRate" runat="server" CssClass="btn btn-gold" Visible="false">
                        <i class="fa-solid fa-star"></i> Rate
                    </asp:HyperLink>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="">
                <ItemTemplate>
                    <asp:HyperLink ID="lnkMessages" runat="server" CssClass="btn">
                        <i class="fa-solid fa-comments"></i> Messages
                    </asp:HyperLink>
                    <asp:Button ID="btnComplete" runat="server" Text="Mark Completed" CommandName="CompleteSession"
                        CommandArgument='<%# Eval("SessionId") %>' CssClass="btn btn-gold" />
                    <asp:Button ID="btnCancel" runat="server" Text="Cancel" CommandName="CancelSession"
                        CommandArgument='<%# Eval("SessionId") %>' CssClass="btn btn-danger"
                        OnClientClick="return confirm('Cancel this session?');" />
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
        <EmptyDataTemplate>No sessions found.</EmptyDataTemplate>
    </asp:GridView>

</asp:Content>