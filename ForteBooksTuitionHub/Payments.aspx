<%@ Page Title="Payments" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Payments.aspx.cs" Inherits="ForteBooksTuitionHub.Payments" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <h2><i class="fa-solid fa-money-bill-wave"></i> Payments</h2>

    <div style="margin-bottom:15px;">
        <a href="PaymentAdd.aspx" class="btn"><i class="fa-solid fa-plus"></i> Record New Payment</a>
        <a href="OutstandingBalances.aspx" class="btn btn-gold"><i class="fa-solid fa-scale-balanced"></i> Outstanding Balances Report</a>
        <a href="RevenueReport.aspx" class="btn btn-gold"><i class="fa-solid fa-chart-line"></i> Revenue Report</a>
    </div>

    <div class="form-box" style="max-width:100%; margin-bottom:20px;">
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
    </div>

    <asp:Label ID="lblMessage" runat="server" ForeColor="Green" Font-Bold="true" style="display:block; margin-bottom:10px;"></asp:Label>

    <asp:GridView ID="gvPayments" runat="server" AutoGenerateColumns="false"
        CssClass="grid" DataKeyNames="PaymentId" OnRowCommand="gvPayments_RowCommand" GridLines="None">
        <Columns>
            <asp:BoundField DataField="StudentName" HeaderText="Student" />
            <asp:BoundField DataField="Amount" HeaderText="Amount (R)" DataFormatString="{0:N2}" />
            <asp:BoundField DataField="PaymentDate" HeaderText="Date" DataFormatString="{0:yyyy-MM-dd}" />
            <asp:BoundField DataField="Method" HeaderText="Method" />
            <asp:BoundField DataField="Reason" HeaderText="Reason" />
            <asp:TemplateField HeaderText="">
                <ItemTemplate>
                    <asp:Button runat="server" Text="Delete" CommandName="DeletePayment"
                        CommandArgument='<%# Eval("PaymentId") %>' CssClass="btn btn-danger"
                        OnClientClick="return confirm('Delete this payment record?');" />
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>

</asp:Content>
