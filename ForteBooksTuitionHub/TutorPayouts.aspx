<%@ Page Title="Tutor Payouts" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="TutorPayouts.aspx.cs" Inherits="ForteBooksTuitionHub.TutorPayouts" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <h2><i class="fa-solid fa-hand-holding-dollar"></i> Tutor Payouts</h2>
    <p>Net earnings are calculated from sessions marked <strong>Completed</strong>, at each tutor's hourly rate, less the centre's 5% commission.</p>

    <asp:Label ID="lblMessage" runat="server" ForeColor="Green" Font-Bold="true" style="display:block; margin-bottom:10px;"></asp:Label>

    <asp:GridView ID="gvPayoutStatus" runat="server" AutoGenerateColumns="false" CssClass="grid" GridLines="None">
        <Columns>
            <asp:BoundField DataField="FullName" HeaderText="Tutor" />
            <asp:BoundField DataField="Subject" HeaderText="Subject" />
            <asp:BoundField DataField="GrossEarnings" HeaderText="Gross Earnings (R)" DataFormatString="{0:N2}" />
            <asp:BoundField DataField="Commission" HeaderText="Commission -5% (R)" DataFormatString="{0:N2}" />
            <asp:BoundField DataField="NetEarnings" HeaderText="Net Earnings (R)" DataFormatString="{0:N2}" />
            <asp:BoundField DataField="PaidOut" HeaderText="Already Paid Out (R)" DataFormatString="{0:N2}" />
            <asp:BoundField DataField="StillOwed" HeaderText="Still Owed (R)" DataFormatString="{0:N2}" />
            <asp:TemplateField HeaderText="">
                <ItemTemplate>
                    <a href='RecordPayout.aspx?tutorId=<%# Eval("TutorId") %>' class="btn btn-gold">
                        <i class="fa-solid fa-money-check-dollar"></i> Record Payout
                    </a>
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
        <EmptyDataTemplate>No tutors found.</EmptyDataTemplate>
    </asp:GridView>

    <h3 style="margin-top:35px;"><i class="fa-solid fa-clock-rotate-left"></i> Payout History</h3>
    <asp:GridView ID="gvHistory" runat="server" AutoGenerateColumns="false" CssClass="grid" GridLines="None">
        <Columns>
            <asp:BoundField DataField="TutorName" HeaderText="Tutor" />
            <asp:BoundField DataField="Amount" HeaderText="Amount (R)" DataFormatString="{0:N2}" />
            <asp:BoundField DataField="PayoutDate" HeaderText="Date" DataFormatString="{0:yyyy-MM-dd HH:mm}" />
            <asp:BoundField DataField="Notes" HeaderText="Notes" />
        </Columns>
        <EmptyDataTemplate>No payouts recorded yet.</EmptyDataTemplate>
    </asp:GridView>

</asp:Content>