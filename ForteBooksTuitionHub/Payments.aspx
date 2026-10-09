<%@ Page Title="Payments" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Payments.aspx.cs" Inherits="ForteBooksTuitionHub.Payments" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="payments-workspace">

        <div class="management-page-header">
            <div class="management-header-icon">
                <i class="fa-solid fa-money-bill-wave" aria-hidden="true"></i>
            </div>

            <div>
                <span class="management-eyebrow">Forte Books &amp; Tuition Hub</span>
                <h2>Payments</h2>
                <p>Review student payments and access your financial reports.</p>
            </div>
        </div>

        <div class="payments-toolbar">
            <div>
                <h3>Payment records</h3>
                <p>Use the date filters to review a specific period.</p>
            </div>

            <a href="PaymentAdd.aspx" class="btn btn-gold">
                <i class="fa-solid fa-plus"></i> Record New Payment
            </a>
        </div>

        <div class="payments-reports">
            <a href="OutstandingBalances.aspx" class="payments-report">
                <i class="fa-solid fa-scale-balanced"></i>
                Outstanding Balances Report
            </a>

            <a href="RevenueReport.aspx" class="payments-report">
                <i class="fa-solid fa-chart-line"></i>
                Revenue Report
            </a>
        </div>

        <div class="form-box payments-filters">
            <div class="payments-filter-fields">
                <div>
                    <asp:Label ID="lblFromDateCaption" runat="server"
                        AssociatedControlID="txtFromDate" Text="From Date" />
                    <asp:TextBox ID="txtFromDate" runat="server" TextMode="Date" />
                </div>

                <div>
                    <asp:Label ID="lblToDateCaption" runat="server"
                        AssociatedControlID="txtToDate" Text="To Date" />
                    <asp:TextBox ID="txtToDate" runat="server" TextMode="Date" />
                </div>

                <div class="payments-filter-actions">
                    <asp:Button ID="btnFilter" runat="server"
                        Text="Filter" CssClass="btn btn-gold"
                        OnClick="btnFilter_Click" />

                    <asp:Button ID="btnClear" runat="server"
                        Text="Clear" CssClass="btn"
                        OnClick="btnClear_Click" CausesValidation="false" />
                </div>
            </div>
        </div>

        <asp:Label ID="lblMessage" runat="server"
            ForeColor="Green" Font-Bold="true"
            CssClass="payments-message" />

        <div class="payments-table-wrap" tabindex="0"
            role="region" aria-label="Student payment records">

            <asp:GridView ID="gvPayments" runat="server"
                AutoGenerateColumns="false"
                CssClass="grid" DataKeyNames="PaymentId"
                OnRowCommand="gvPayments_RowCommand" GridLines="None">

                <Columns>
                    <asp:BoundField DataField="StudentName"
                        HeaderText="Student" />

                    <asp:BoundField DataField="Amount"
                        HeaderText="Amount (R)" DataFormatString="{0:N2}" />

                    <asp:BoundField DataField="PaymentDate"
                        HeaderText="Date" DataFormatString="{0:yyyy-MM-dd}" />

                    <asp:BoundField DataField="Method"
                        HeaderText="Method" />

                    <asp:BoundField DataField="Reason"
                        HeaderText="Reason" />

                    <asp:TemplateField HeaderText="Actions">
                        <ItemTemplate>
                            <asp:Button runat="server"
                                Text="Delete" CommandName="DeletePayment"
                                CommandArgument='<%# Eval("PaymentId") %>'
                                CssClass="btn btn-danger payment-delete"
                                OnClientClick="return confirm('Delete this payment record?');" />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>

                <EmptyDataTemplate>
                    <div class="payments-empty">
                        <i class="fa-solid fa-money-bill-wave"
                            aria-hidden="true"></i>
                        <h3>No payments found</h3>
                        <p>Try another date range or clear the filters.</p>
                    </div>
                </EmptyDataTemplate>
            </asp:GridView>
        </div>
    </div>

</asp:Content>
