<%@ Page Title="Revenue Report" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="RevenueReport.aspx.cs" Inherits="ForteBooksTuitionHub.RevenueReport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <h2><i class="fa-solid fa-chart-line"></i> Revenue Report</h2>
    <div class="no-print" style="margin-bottom:20px;">
        <a href="Payments.aspx" class="btn">&laquo; Back to Payments</a>
        <asp:Button ID="btnPrint" runat="server" Text="Print This Report" CssClass="btn btn-gold" OnClientClick="window.print(); return false;" />
    </div>

    <div class="dash-card" style="max-width:250px; margin-bottom:25px;">
        <h3><i class="fa-solid fa-sack-dollar"></i> Total Revenue To Date</h3>
        <p class="value">R<asp:Label ID="lblTotalRevenue" runat="server"></asp:Label></p>
    </div>

    <h3><i class="fa-solid fa-calendar"></i> Revenue by Month
        <asp:Button ID="btnExportMonth" runat="server" Text="Download CSV" CssClass="btn btn-gold no-print" OnClick="btnExportMonth_Click" CausesValidation="false" style="font-size:11px; padding:5px 10px; margin-left:10px;" />
    </h3>
    <asp:GridView ID="gvByMonth" runat="server" AutoGenerateColumns="false" CssClass="grid" GridLines="None">
        <Columns>
            <asp:BoundField DataField="MonthLabel" HeaderText="Month" />
            <asp:BoundField DataField="PaymentCount" HeaderText="Number of Payments" />
            <asp:BoundField DataField="TotalAmount" HeaderText="Total (R)" DataFormatString="{0:N2}" />
        </Columns>
        <EmptyDataTemplate>No payments recorded yet.</EmptyDataTemplate>
    </asp:GridView>

    <h3 style="margin-top:30px;"><i class="fa-solid fa-credit-card"></i> Revenue by Payment Method
        <asp:Button ID="btnExportMethod" runat="server" Text="Download CSV" CssClass="btn btn-gold no-print" OnClick="btnExportMethod_Click" CausesValidation="false" style="font-size:11px; padding:5px 10px; margin-left:10px;" />
    </h3>
    <asp:GridView ID="gvByMethod" runat="server" AutoGenerateColumns="false" CssClass="grid" GridLines="None">
        <Columns>
            <asp:BoundField DataField="Method" HeaderText="Method" />
            <asp:BoundField DataField="PaymentCount" HeaderText="Number of Payments" />
            <asp:BoundField DataField="TotalAmount" HeaderText="Total (R)" DataFormatString="{0:N2}" />
        </Columns>
        <EmptyDataTemplate>No payments recorded yet.</EmptyDataTemplate>
    </asp:GridView>

    <h3 style="margin-top:30px;"><i class="fa-solid fa-tags"></i> Revenue by Reason
        <asp:Button ID="btnExportReason" runat="server" Text="Download CSV" CssClass="btn btn-gold no-print" OnClick="btnExportReason_Click" CausesValidation="false" style="font-size:11px; padding:5px 10px; margin-left:10px;" />
    </h3>
    <asp:GridView ID="gvByReason" runat="server" AutoGenerateColumns="false" CssClass="grid" GridLines="None">
        <Columns>
            <asp:BoundField DataField="Reason" HeaderText="Reason" />
            <asp:BoundField DataField="PaymentCount" HeaderText="Number of Payments" />
            <asp:BoundField DataField="TotalAmount" HeaderText="Total (R)" DataFormatString="{0:N2}" />
        </Columns>
        <EmptyDataTemplate>No payments recorded yet.</EmptyDataTemplate>
    </asp:GridView>

</asp:Content>
